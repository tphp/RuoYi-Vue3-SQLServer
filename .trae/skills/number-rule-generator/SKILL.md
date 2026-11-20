---
name: "number-rule-generator"
description: "生成或改造「单据编号规则」功能：常量/日期/流水号三元素可视化组合配置，行级锁保证流水号并发唯一，业务方一行代码 generateNumber(ruleCode) 取号。当用户需要单据编号、流水号、编号规则配置、或业务系统接入统一编号时使用。"
---

> 中文名称：单据编号生成规则

# 单据编号生成规则（Number Rule Generator）

## 1. 功能定位

**适用场景**
- 单据编号需要"常量 + 日期 + 流水号"自由组合（如 `QT202606260001`、`CU-20260626-0001`）
- 流水号需按日 / 按月 / 按年 / 永久循环，且要求**并发不重号**
- 编号格式要让业务人员在后台自行配置，不改代码

**不适用（改用其他方案）**
| 场景 | 替代方案 |
|------|----------|
| 固定格式编号、不会变 | 业务代码里直接拼字符串 |
| 无需顺序保证的临时编号 | `UUID` / 随机数（牺牲可读性与排序性） |
| 只需数据库自增 | `identity` 主键直接暴露或取最大值+1（高并发下需另评估） |

**核心设计原则**
- 编号规则**数据化**：三张表存储规则，不硬编码在 Java
- 取号**唯一入口**：业务方只依赖 `ISysNumberRuleService.generateNumber(ruleCode)` 一行调用
- 流水号唯一性靠**行级锁 + 唯一索引**，不靠应用层内存自增

---

## 2. 数据模型（三表结构，SQL Server）

| 表 | 职责 | 关键字段 |
|----|------|----------|
| `sys_number_rule` | 规则主表 | `rule_code`（唯一索引 `uk_rule_code`）、`rule_name`、`status` |
| `sys_number_rule_item` | 元素列表（按 `sort_order` 排序） | `item_type`(1常量/2日期/3流水号)、`item_value`、`date_format`、`cycle_type`、`serial_length`、`is_pad_zero`、`start_number` |
| `sys_number_serial` | 流水号计数器 | `rule_id` + `cycle_key`（唯一索引 `uk_rule_cycle`）、`current_value` |

**`cycle_key` 生成规则**（流水号周期重置的唯一键）：

| cycle_type | cycle_key |
|------------|-----------|
| 1 不循环 | `ALL`（永久递增） |
| 2 按日 | `yyyyMMdd`（如 `20260626`） |
| 3 按月 | `yyyyMM`（如 `202606`） |
| 4 按年 | `yyyy`（如 `2026`） |

**DDL 规范**（本项目为 SQL Server，已过 `sqlserver-compat-check`）：`bigint IDENTITY(1,1)` 主键、`nvarchar` 字符串、`datetime2` 时间、唯一索引防并发重复插入、列注释用 `sp_addextendedproperty`。

---

## 3. 取号核心流程

```
generateNumber(ruleCode)
 1. selectNumberRuleByCode(ruleCode)          —— 规则不存在 / status 非 "0"（0=启用、1=停用）→ 抛业务异常（带 i18n 消息）
 2. selectRuleItemsByRuleId(ruleId)           —— 元素为空 → 抛异常
 3. 按 sort_order 遍历元素：
    ├─ 常量：直接取 itemValue
    ├─ 日期：SimpleDateFormat(dateFormat).format(new Date())
    └─ 流水号：
        a. cycleType → cycleKey
        b. getNextSerialNumber(ruleId, cycleKey, startNumber)
        c. 按 serial_length + is_pad_zero 格式化（不足补 0）
 4. StringBuilder 拼接返回
```

**预览（previewNumber）** 与真实生成**必须分离**：预览走 `previewItemValue()`，流水号用 `startNumber` 模拟，**绝不消耗真实流水号**。

### 并发安全（关键）

```java
@Transactional
public long getNextSerialNumber(Long ruleId, String cycleKey, int startNumber) {
    // 1. 行级锁查询（SQL: select ... with (updlock, holdlock) where rule_id=? and cycle_key=?）
    SysNumberSerial serial = serialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);
    if (serial == null) {
        try {
            // 2. 首次插入初始记录
            serialMapper.insertSerial(... current_value = startNumber ...);
            return startNumber;
        } catch (DuplicateKeyException e) {
            // 3. 并发下已被其他线程插入 → 重新加锁查询
            serial = serialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);
        }
    }
    // 4. 自增并更新
    long next = serial.getCurrentValue() + 1;
    serialMapper.updateSerial(...);
    return next;
}
```

**三层防线**：`with (updlock, holdlock)` 行锁 → `uk_rule_cycle` 唯一索引 → `DuplicateKeyException` 捕获重查。缺任何一层都会在高并发下重号。

> ⚠️ 事务边界：`getNextSerialNumber` 上的 `@Transactional` 因**类内自调用**（`generateNumber` → `generateItemValue` → `getNextSerialNumber`）不经 Spring 代理，**实际不生效**；行锁全程由外层 `generateNumber` 的事务持有。因此取号必须在 `generateNumber`（或业务方事务）内完成，单独抽出去调用会让锁立即释放，并发防线失效。

---

## 4. 业务接入契约

**唯一入口**（业务方禁止自行拼编号）：

```java
@Autowired
private ISysNumberRuleService numberRuleService;

// 单据保存时取号
quotation.setQuotationNo(numberRuleService.generateNumber("CRM_QUOTATION"));
```

**接入步骤**：
1. 后台「系统管理 → 编号规则」配置规则（ruleCode 用 `模块_单据` 大写下划线风格，如 `CRM_QUOTATION`）
2. 业务 Service 注入 `ISysNumberRuleService`
3. 在 insert 前取号（编号为空时才生成，允许外部传入指定编号）
4. 取号与业务写库**同属一个 `@Transactional`**，业务回滚时流水号也回滚（避免跳号，可接受；不要求严格连续）
5. 配套资源备齐：`numberRule.*` 的 i18n 文案（中英文）、菜单与按钮权限 SQL（`system:numberRule:*`）、按需的默认规则初始化脚本（`sys_number_rule` / `sys_number_rule_item` 初始数据）

**改造旧编号**（如随机数编号）：把 `Math.random()` 拼接逻辑整体替换为一行 `generateNumber(ruleCode)`，保留"编号为空才生成"的判断。

---

## 5. 接口与前端

### API（9 个，均在 [SysNumberRuleController](file:///d:/ebs-api/ruoyi-admin/src/main/java/com/ruoyi/web/controller/system/SysNumberRuleController.java)）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/system/numberRule/list` | 列表（`startPage()` + `getDataTable()`） |
| POST | `/system/numberRule/export` | 导出（`@Excel` 字段） |
| GET | `/system/numberRule/{ruleId}` | 详情（含 items） |
| POST / PUT | `/system/numberRule` | 新增 / 修改（主子一起提交） |
| DELETE | `/system/numberRule/{ruleIds}` | 删除 |
| PUT | `/system/numberRule/status` | 启用/停用 |
| POST | `/system/numberRule/preview` | 预览（不消耗流水号） |
| POST | `/system/numberRule/generate/{ruleCode}` | 测试取号 |

权限串：`system:numberRule:list|query|add|edit|remove|export`；其中 `status` 复用 `edit`、`preview` 复用 `query`、`generate` 复用 `edit`（均无独立权限）。

### 请求体（主子结构）

```json
{
  "ruleName": "销售订单编号", "ruleCode": "SO_ORDER", "status": "0",
  "items": [
    { "itemType": "1", "itemValue": "SO-", "sortOrder": 0 },
    { "itemType": "2", "dateFormat": "yyyyMMdd", "sortOrder": 1 },
    { "itemType": "3", "cycleType": "2", "serialLength": 4,
      "isPadZero": "1", "startNumber": 1, "sortOrder": 2 }
  ]
}
```

> ⚠️ `status` 语义：**`0` = 启用、`1` = 停用**（以 `SysNumberRuleServiceImpl.generateNumber` 的 `!"0".equals(status)` 判断为准）。`docs/02-development/common/number-rule/number-generation-config-plan.md` 的 DDL 注释写作「0停用 1启用」，与代码相反，**一律以代码为准**；照抄 `"status": "1"` 会导致规则新增即停用、取号直接报「已停用」。

### 前端（主前端 ebs-web，Vue3 + TS）

```
src/api/system/numberRule.ts            # API
src/types/api/system/numberRule.ts      # 类型（ItemType/CycleType 枚举 + NumberRuleItem/Form）
src/views/system/numberRule/index.vue   # 列表 + 弹窗配置
```

**配置页交互**（6 步）：顶部按钮组添加元素 → 点击队列表单项 → 下方动态表单配置（常量/日期/流水号三种表单切换）→ 上移/下移/删除调整 → 监听 items 变化**实时调 preview** → 整个 items 数组随表单提交。

**枚举约定**：`ItemType{1常量,2日期,3流水号}`、`CycleType{1不循环,2按日,3按月,4按年}`，前后端必须一致。

---

## 6. 日期格式预设（下拉选项）

`yyyyMMdd`、`yyyy-MM-dd`、`yyyyMM`、`yyyy`、`MMdd`、`yyMMdd`、`HHmmss`、`yyyyMMddHHmmss`

> 注意：日期格式串是 **Java `SimpleDateFormat`** 语法（与 SQL Server 的 `convert` style 不同），不要混用。

---

## 7. 落位与存量豁免

- **当前实现在 [SysNumberRuleServiceImpl](file:///d:/ebs-api/ruoyi-system/src/main/java/com/ruoyi/system/service/impl/SysNumberRuleServiceImpl.java) 等**（`ruoyi-system` 下实体/Mapper/Service + `ruoyi-admin/controller/system` 控制器，`SysNumberRule*` 共 12 个后端文件）——属于规则 §3.1 **存量豁免**，按现状维护、**不迁移**；但这两处同属规则 §1 **红区**（`ruoyi-system`、`controller/system`），仅允许 Bug 修复级变更，**实质性改动须先取得用户确认**
- **新增类似功能**（如新的编码规则）不得复制该模式，必须进自建业务模块（`ruoyi-bizperm` / `ruoyi-apilog` / 新建 `ruoyi-xxx`）
- **旧前端 `ruoyi-ui`（Vue2）尚无 numberRule 页面**——按双前端并行维护约定（规则 §4.5），该功能需在 ruoyi-ui 补齐 Vue2 Options API 版本
- 所有 SQL 改动先过 `sqlserver-compat-check`（行锁写法 `with (updlock, holdlock)`、禁 `limit`）

---

## 8. 生成 / 改造时的检查清单

- [ ] 三表结构齐全，`uk_rule_code`、`uk_rule_cycle` 两个唯一索引存在
- [ ] `cycle_key` 四种周期映射正确（`ALL` / `yyyyMMdd` / `yyyyMM` / `yyyy`）
- [ ] 取号 SQL 使用 `with (updlock, holdlock)` 行级锁
- [ ] 插入冲突走 `DuplicateKeyException` → 重新加锁查询
- [ ] `generateNumber` 整体 `@Transactional`，规则不存在/停用/无元素抛 i18n 业务异常
- [ ] `previewNumber` 不消耗真实流水号（流水号用 startNumber 模拟）
- [ ] 业务接入保持"编号为空才取号"，取号与业务写库同事务
- [ ] 列表 `startPage()` + `getDataTable()`；增删改 `@Transactional` + `@PreAuthorize`
- [ ] 主子保存：items 先删后插或按 ruleId 覆盖，避免脏元素
- [ ] 前端类型枚举与后端常量一致；预览防抖，不频繁打接口
- [ ] DDL 为 SQL Server 方言（`IDENTITY`、`nvarchar`、`datetime2`、`sp_addextendedproperty`）
- [ ] 双前端同步：ebs-web（Vue3+TS）与 ruoyi-ui（Vue2）页面、文案、菜单路径一致
- [ ] 全部函数含中文注释（`@param`/`@returns`），文件头 `@author`/`@date`

---

## 9. 质量要求

- **唯一入口**：业务代码只调 `generateNumber(ruleCode)`，禁止绕过服务直接操作 `sys_number_serial`
- **预览零副作用**：配置页实时预览不得消耗流水号
- **并发正确**：三层防线（行锁 + 唯一索引 + 冲突重查）齐备，可用并发测试验证
- **可扩展**：新增元素类型只需扩展 `item_type` + `generateItemValue` 分支，不动表结构主干
- **国际化**：异常消息走 `MessageUtils.message("numberRule.xxx")`，中英文齐全
- **可运维**：规则可停用（停用后取号立即报错，用于紧急止损）

---

## 10. 后续扩展方向（按需，不过度设计）

- 更多元素类型（部门编码、用户编码）
- 流水号步长配置
- 多环境流水号隔离（测试/生产分池）
- 编号使用记录表（审计：谁在何时用了哪个号）
- 规则导入导出
