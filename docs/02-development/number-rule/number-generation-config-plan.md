# 单据编号生成配置功能方案

> 中文名称：单据编号生成配置功能方案

## 功能概述

基于若依框架开发单据编号生成配置功能，支持用户自由选择、组合**常量、日期、流水号**三种元素来自定义单据编号规则，配置后可以预览最终编号格式。

### 核心特性

- ✅ **可视化配置**：拖拽式组合常量、日期、流水号三种元素
- ✅ **实时预览**：配置过程中实时预览最终编号格式
- ✅ **灵活的流水号策略**：支持不循环、按日、按月、按年四种累计周期
- ✅ **补零支持**：流水号支持自动补零，可配置长度
- ✅ **唯一性保证**：基于数据库行级锁保证编号唯一性
- ✅ **顺序调整**：支持元素顺序上移、下移、删除
- ✅ **规则管理**：支持规则的增删改查、启用/停用

---

## 数据库设计

### 1. 编号规则主表 `sys_number_rule`

存储每条编号规则的基本信息。

```sql
CREATE TABLE [dbo].[sys_number_rule] (
    [rule_id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [rule_name] nvarchar(100) NOT NULL,
    [rule_code] nvarchar(64) NOT NULL,
    [description] nvarchar(500) NULL,
    [status] nchar(1) DEFAULT '0' NULL,
    [remark] nvarchar(500) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7) NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7) NULL
);

CREATE UNIQUE INDEX [uk_rule_code] ON [dbo].[sys_number_rule] ([rule_code] ASC);

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'编号规则表', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则ID', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule',
    @level2type = N'COLUMN', @level2name = N'rule_id';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则名称', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule',
    @level2type = N'COLUMN', @level2name = N'rule_name';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则编码（唯一标识）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule',
    @level2type = N'COLUMN', @level2name = N'rule_code';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则描述', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule',
    @level2type = N'COLUMN', @level2name = N'description';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'状态（0停用 1启用）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule',
    @level2type = N'COLUMN', @level2name = N'status';
```

### 2. 编号规则元素表 `sys_number_rule_item`

存储每条规则的元素配置（按顺序排列）。

```sql
CREATE TABLE [dbo].[sys_number_rule_item] (
    [item_id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [rule_id] bigint NOT NULL,
    [item_type] nchar(1) NOT NULL,
    [item_value] nvarchar(200) NULL,
    [date_format] nvarchar(32) NULL,
    [cycle_type] nchar(1) NULL,
    [serial_length] int NULL,
    [is_pad_zero] nchar(1) DEFAULT '0' NULL,
    [start_number] int DEFAULT 1 NULL,
    [sort_order] int DEFAULT 0 NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7) NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7) NULL
);

CREATE INDEX [idx_rule_id] ON [dbo].[sys_number_rule_item] ([rule_id] ASC);

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'编号规则元素表', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'元素ID', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'item_id';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则ID', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'rule_id';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'元素类型（1常量 2日期 3流水号）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'item_type';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'常量值（元素类型为1时使用）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'item_value';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'日期格式（元素类型为2时使用，如yyyyMMdd）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'date_format';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'累计周期（1不循环 2按日 3按月 4按年）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'cycle_type';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'流水号长度', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'serial_length';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否补零（0否 1是）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'is_pad_zero';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'起始流水号', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'start_number';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'排序号', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_rule_item',
    @level2type = N'COLUMN', @level2name = N'sort_order';
```

### 3. 流水号记录表 `sys_number_serial`

记录每个规则在各周期下的当前流水号值，用于生成自增流水号。

```sql
CREATE TABLE [dbo].[sys_number_serial] (
    [serial_id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [rule_id] bigint NOT NULL,
    [cycle_key] nvarchar(32) NOT NULL,
    [current_value] bigint DEFAULT 0 NULL,
    [create_time] datetime2(7) NULL,
    [update_time] datetime2(7) NULL
);

CREATE UNIQUE INDEX [uk_rule_cycle] ON [dbo].[sys_number_serial] ([rule_id] ASC, [cycle_key] ASC);

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'流水号记录表', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_serial';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'流水号ID', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_serial',
    @level2type = N'COLUMN', @level2name = N'serial_id';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'规则ID', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_serial',
    @level2type = N'COLUMN', @level2name = N'rule_id';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'周期键（不循环:ALL 按日:yyyyMMdd 按月:yyyyMM 按年:yyyy）', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_serial',
    @level2type = N'COLUMN', @level2name = N'cycle_key';

EXEC sp_addextendedproperty 
    @name = N'MS_Description', @value = N'当前流水号值', 
    @level0type = N'SCHEMA', @level0name = N'dbo', 
    @level1type = N'TABLE', @level1name = N'sys_number_serial',
    @level2type = N'COLUMN', @level2name = N'current_value';
```

---

## 后端架构设计

### 模块位置

放在 `ruoyi-system` 模块下（因为是系统级通用功能），包路径：`com.ruoyi.system`

### 核心类图

```
SysNumberRule (实体)
    ├── ruleId
    ├── ruleName
    ├── ruleCode
    ├── description
    ├── status
    ├── items (List<SysNumberRuleItem>)  // 组合元素列表
    └── ...

SysNumberRuleItem (实体)
    ├── itemId
    ├── ruleId
    ├── itemType (1=常量, 2=日期, 3=流水号)
    ├── itemValue (常量值)
    ├── dateFormat (日期格式)
    ├── cycleType (周期类型)
    ├── serialLength (流水号长度)
    ├── isPadZero (是否补零)
    ├── startNumber (起始流水号)
    └── sortOrder (排序号)

SysNumberSerial (实体)
    ├── serialId
    ├── ruleId
    ├── cycleKey
    └── currentValue
```

### 服务层设计

#### 1. ISysNumberRuleService

```java
public interface ISysNumberRuleService {
    // CRUD 操作
    List<SysNumberRule> selectRuleList(SysNumberRule rule);
    SysNumberRule selectRuleById(Long ruleId);
    int insertRule(SysNumberRule rule);
    int updateRule(SysNumberRule rule);
    int deleteRuleByIds(Long[] ruleIds);
    
    // 状态管理
    int updateRuleStatus(SysNumberRule rule);
    
    // 校验规则编码唯一性
    boolean checkRuleCodeUnique(SysNumberRule rule);
    
    // 生成编号（核心方法）
    String generateNumber(String ruleCode);
    
    // 预览编号格式（用于前端实时预览）
    String previewNumber(SysNumberRule rule);
}
```

#### 2. 编号生成核心逻辑

```
生成编号流程：
1. 根据 ruleCode 查询规则配置（含元素列表）
2. 按 sort_order 排序元素
3. 遍历元素，按类型生成各段内容：
   - 常量：直接取 itemValue
   - 日期：按 dateFormat 格式化当前日期
   - 流水号：
     a. 根据 cycleType 计算当前 cycleKey
     b. 查询/创建 sys_number_serial 记录
     c. 行级锁更新 current_value + 1
     d. 根据 serial_length 和 is_pad_zero 格式化流水号
4. 拼接所有元素，返回最终编号
```

#### 3. 流水号并发安全方案

**方案：数据库行级锁 + 唯一索引**

- 使用 `SELECT ... WITH (UPDLOCK, HOLDLOCK)` 获取行级锁
- 利用唯一索引 `uk_rule_cycle` 防止并发插入重复记录
- 首次生成时插入记录，后续更新自增

```java
@Transactional
public long getNextSerialNumber(Long ruleId, String cycleKey, int startNumber) {
    // 1. 尝试查询并锁定记录
    SysNumberSerial serial = serialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);
    
    if (serial == null) {
        // 2. 记录不存在，插入初始记录
        try {
            serial = new SysNumberSerial();
            serial.setRuleId(ruleId);
            serial.setCycleKey(cycleKey);
            serial.setCurrentValue((long) startNumber);
            serial.setCreateTime(DateUtils.getNowDate());
            serial.setUpdateTime(DateUtils.getNowDate());
            serialMapper.insertSerial(serial);
            return startNumber;
        } catch (DuplicateKeyException e) {
            // 3. 并发场景下可能已被其他线程插入，重新查询
            serial = serialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);
        }
    }
    
    // 4. 自增并更新
    long nextValue = serial.getCurrentValue() + 1;
    serial.setCurrentValue(nextValue);
    serial.setUpdateTime(DateUtils.getNowDate());
    serialMapper.updateSerial(serial);
    
    return nextValue;
}
```

### Controller 层设计

```java
@RestController
@RequestMapping("/system/numberRule")
public class SysNumberRuleController extends BaseController {
    
    // 列表查询
    @GetMapping("/list")
    public TableDataInfo list(SysNumberRule rule) { ... }
    
    // 详情
    @GetMapping("/{ruleId}")
    public AjaxResult getInfo(@PathVariable Long ruleId) { ... }
    
    // 新增
    @PostMapping
    public AjaxResult add(@RequestBody SysNumberRule rule) { ... }
    
    // 修改
    @PutMapping
    public AjaxResult edit(@RequestBody SysNumberRule rule) { ... }
    
    // 删除
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds) { ... }
    
    // 状态修改
    @PutMapping("/status")
    public AjaxResult changeStatus(@RequestBody SysNumberRule rule) { ... }
    
    // 预览编号
    @PostMapping("/preview")
    public AjaxResult preview(@RequestBody SysNumberRule rule) {
        String previewNumber = ruleService.previewNumber(rule);
        return success(previewNumber);
    }
    
    // 生成编号（测试用）
    @PostMapping("/generate/{ruleCode}")
    public AjaxResult generate(@PathVariable String ruleCode) {
        String number = ruleService.generateNumber(ruleCode);
        return success(number);
    }
}
```

---

## 前端设计

### 页面结构

```
┌─────────────────────────────────────────────────┐
│  编号规则管理（列表页）                              │
├─────────────────────────────────────────────────┤
│  搜索栏：规则名称、规则编码、状态                      │
│  操作栏：新增、修改、删除、导入、导出                   │
│  数据表格：规则列表                                   │
│    └── 操作列：修改、删除、启用/停用                   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  新增/修改规则（弹窗页）                            │
├─────────────────────────────────────────────────┤
│  基本信息：                                        │
│    - 规则名称 *                                    │
│    - 规则编码 *                                    │
│    - 规则描述                                      │
│    - 状态                                          │
├─────────────────────────────────────────────────┤
│  元素配置区：                                       │
│  ┌───────────────────────────────────────────┐  │
│  │  [常量] [日期] [流水号]  ← 顶部按钮组       │  │
│  ├───────────────────────────────────────────┤  │
│  │  编号组合队列：                              │  │
│  │  ┌─────────────────────────────────────┐ │  │
│  │  │  ○ 常量：SO-     [↑][↓][×]         │ │  │
│  │  ├─────────────────────────────────────┤ │  │
│  │  │  ● 日期：yyyyMMdd  [↑][↓][×]       │ │  │
│  │  ├─────────────────────────────────────┤ │  │
│  │  │  ○ 流水号：4位，按月  [↑][↓][×]     │ │  │
│  │  └─────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────┘  │
├─────────────────────────────────────────────────┤
│  元素配置表单区（根据选中元素类型动态展示）：           │
│  ┌───────────────────────────────────────────┐  │
│  │  常量配置：                                 │  │
│  │    - 常量值 [__________]                  │  │
│  └───────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────┐  │
│  │  日期配置：                                 │  │
│  │    - 日期格式 [yyyyMMdd ▼]                │  │
│  │      （下拉选项：yyyyMMdd、yyyy-MM-dd、     │  │
│  │        yyyyMM、yyyy、MMdd、HHmmss 等）     │  │
│  └───────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────┐  │
│  │  流水号配置：                               │  │
│  │    - 累计周期 [按日 ▼]                     │  │
│  │      （不循环 / 按日 / 按月 / 按年）        │  │
│  │    - 流水号长度 [4]                        │  │
│  │    - 是否补零 [是 ☑]                       │  │
│  │    - 起始流水号 [1]                        │  │
│  └───────────────────────────────────────────┘  │
├─────────────────────────────────────────────────┤
│  预览区：                                         │
│  编号预览：SO-202606260001                        │
├─────────────────────────────────────────────────┤
│  底部按钮：[确定] [取消]                           │
└─────────────────────────────────────────────────┘
```

### 前端文件结构

```
src/
├── api/
│   └── system/
│       └── numberRule.ts          // API 接口
├── types/
│   └── api/
│       └── system/
│           └── numberRule.ts      // 类型定义
└── views/
    └── system/
        └── numberRule/
            └── index.vue          // 管理页面
```

### 核心数据结构

```typescript
// 元素类型枚举
enum ItemType {
  CONSTANT = '1',    // 常量
  DATE = '2',        // 日期
  SERIAL = '3'       // 流水号
}

// 周期类型枚举
enum CycleType {
  NONE = '1',        // 不循环
  DAILY = '2',       // 按日
  MONTHLY = '3',     // 按月
  YEARLY = '4'       // 按年
}

// 规则元素
interface NumberRuleItem {
  itemId?: number
  ruleId?: number
  itemType: string      // 元素类型
  itemValue?: string    // 常量值
  dateFormat?: string   // 日期格式
  cycleType?: string    // 累计周期
  serialLength?: number // 流水号长度
  isPadZero?: string    // 是否补零
  startNumber?: number  // 起始流水号
  sortOrder?: number    // 排序号
}

// 编号规则
interface NumberRuleForm {
  ruleId?: number
  ruleName?: string
  ruleCode?: string
  description?: string
  status?: string
  remark?: string
  items?: NumberRuleItem[]  // 元素列表
}
```

### 前端核心交互逻辑

1. **添加元素**：点击顶部按钮，向队列中添加对应类型的元素
2. **选中元素**：点击队列中的元素，下方展示对应配置表单
3. **调整顺序**：点击上移/下移按钮，调整元素顺序
4. **删除元素**：点击删除按钮，从队列中移除元素
5. **实时预览**：监听元素列表变化，实时计算预览编号
6. **表单提交**：保存时将元素列表按顺序提交

---

## API 接口清单

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/system/numberRule/list` | 查询规则列表 |
| GET | `/system/numberRule/{ruleId}` | 获取规则详情 |
| POST | `/system/numberRule` | 新增规则 |
| PUT | `/system/numberRule` | 修改规则 |
| DELETE | `/system/numberRule/{ruleIds}` | 删除规则 |
| PUT | `/system/numberRule/status` | 修改规则状态 |
| POST | `/system/numberRule/preview` | 预览编号格式 |
| POST | `/system/numberRule/generate/{ruleCode}` | 生成编号（测试） |

### 新增/修改请求体示例

```json
{
  "ruleId": 1,
  "ruleName": "销售订单编号",
  "ruleCode": "SO_ORDER",
  "description": "销售订单单据编号规则",
  "status": "1",
  "remark": "备注",
  "items": [
    {
      "itemType": "1",
      "itemValue": "SO-",
      "sortOrder": 0
    },
    {
      "itemType": "2",
      "dateFormat": "yyyyMMdd",
      "sortOrder": 1
    },
    {
      "itemType": "3",
      "cycleType": "2",
      "serialLength": 4,
      "isPadZero": "1",
      "startNumber": 1,
      "sortOrder": 2
    }
  ]
}
```

### 生成编号调用示例

#### 1. 基础调用方式

```java
// 在业务代码中注入服务
@Autowired
private ISysNumberRuleService numberRuleService;

// 生成编号
String orderNo = numberRuleService.generateNumber("SO_ORDER");
// 输出示例：SO-202606260001
```

#### 2. 报价单场景调用示例（改造前 vs 改造后）

**场景说明**：报价单编号格式 `QT + yyyyMMdd + 4位流水号`，例如 `QT202606260001`

##### 第一步：在后台配置编号规则

在「系统管理 → 编号规则」中新增一条规则：

| 配置项 | 值 |
|--------|-----|
| 规则名称 | 报价单编号 |
| 规则编码 | `CRM_QUOTATION` |
| 状态 | 启用 |

**元素配置（按顺序）**：

1. **常量**：值为 `QT`
2. **日期**：格式为 `yyyyMMdd`
3. **流水号**：累计周期=按日，长度=4，补零=是，起始值=1

##### 第二步：改造业务代码

**改造前**（随机数方式）：

```java
// CrmQuotationServiceImpl.java 第149-159行
@Override
public String generateQuotationNo()
{
    // 格式：QT + yyyyMMdd + 6位随机数
    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
    String datePart = sdf.format(new Date());
    
    // 生成6位随机数
    int randomNum = (int) ((Math.random() * 900000) + 100000);
    
    return "QT" + datePart + randomNum;
}
```

**改造后**（使用编号规则服务）：

```java
// 1. 注入编号规则服务
@Autowired
private ISysNumberRuleService numberRuleService;

@Override
public String generateQuotationNo()
{
    // 使用统一的编号规则服务生成
    return numberRuleService.generateNumber("CRM_QUOTATION");
}
```

##### 第三步：在 insert 方法中调用

```java
@Override
@Transactional
public int insertQuotation(CrmQuotation quotation)
{
    if (quotation.getQuotationNo() == null || quotation.getQuotationNo().isEmpty()) {
        // 改造前：quotation.setQuotationNo(generateQuotationNo());
        // 改造后：直接调用服务生成
        quotation.setQuotationNo(numberRuleService.generateNumber("CRM_QUOTATION"));
    }
    
    // ... 其他业务逻辑不变
}
```

##### 生成效果

| 日期 | 第N张单 | 生成编号 |
|------|---------|----------|
| 2026-06-26 | 第1张 | QT202606260001 |
| 2026-06-26 | 第2张 | QT202606260002 |
| 2026-06-26 | 第100张 | QT202606260100 |
| 2026-06-27 | 第1张 | QT202606270001（按日重置，从1开始） |

#### 3. 其他业务场景调用示例

| 业务模块 | 规则编码 | 编号格式示例 |
|----------|----------|--------------|
| 客户档案 | `CRM_CUSTOMER` | CU-20260626-0001 |
| 商机管理 | `CRM_OPPORTUNITY` | OPP-202606-0001（按月重置） |
| 合同管理 | `CRM_CONTRACT` | HT-2026-00001（按年重置） |
| 产品物料 | `CRM_MATERIAL` | MAT-00001（不循环，永久递增） |

---

## 日期格式支持

预设常用日期格式选项：

| 格式 | 示例 | 说明 |
|------|------|------|
| `yyyyMMdd` | 20260626 | 年月日（无分隔） |
| `yyyy-MM-dd` | 2026-06-26 | 年月日（横杠分隔） |
| `yyyyMM` | 202606 | 年月（无分隔） |
| `yyyy` | 2026 | 年份 |
| `MMdd` | 0626 | 月日 |
| `yyMMdd` | 260626 | 两位年份月日 |
| `HHmmss` | 143000 | 时分秒 |
| `yyyyMMddHHmmss` | 20260626143000 | 完整时间戳 |

---

## 文件清单

### 后端文件

| 文件路径 | 说明 |
|----------|------|
| `ruoyi-system/src/main/java/com/ruoyi/system/domain/SysNumberRule.java` | 规则实体类 |
| `ruoyi-system/src/main/java/com/ruoyi/system/domain/SysNumberRuleItem.java` | 规则元素实体类 |
| `ruoyi-system/src/main/java/com/ruoyi/system/domain/SysNumberSerial.java` | 流水号记录实体类 |
| `ruoyi-system/src/main/java/com/ruoyi/system/mapper/SysNumberRuleMapper.java` | 规则 Mapper 接口 |
| `ruoyi-system/src/main/java/com/ruoyi/system/mapper/SysNumberRuleItemMapper.java` | 规则元素 Mapper 接口 |
| `ruoyi-system/src/main/java/com/ruoyi/system/mapper/SysNumberSerialMapper.java` | 流水号 Mapper 接口 |
| `ruoyi-system/src/main/resources/mapper/system/SysNumberRuleMapper.xml` | 规则 Mapper XML |
| `ruoyi-system/src/main/resources/mapper/system/SysNumberRuleItemMapper.xml` | 规则元素 Mapper XML |
| `ruoyi-system/src/main/resources/mapper/system/SysNumberSerialMapper.xml` | 流水号 Mapper XML |
| `ruoyi-system/src/main/java/com/ruoyi/system/service/ISysNumberRuleService.java` | 规则服务接口 |
| `ruoyi-system/src/main/java/com/ruoyi/system/service/impl/SysNumberRuleServiceImpl.java` | 规则服务实现 |
| `ruoyi-admin/src/main/java/com/ruoyi/web/controller/system/SysNumberRuleController.java` | 规则 Controller |

### 前端文件

| 文件路径 | 说明 |
|----------|------|
| `src/api/system/numberRule.ts` | API 接口定义 |
| `src/types/api/system/numberRule.ts` | TypeScript 类型定义 |
| `src/views/system/numberRule/index.vue` | 编号规则管理页面 |

### 数据库脚本

| 内容 | 说明 |
|------|------|
| 建表 SQL | 3 张表的创建语句 |
| 菜单 SQL | 插入菜单数据（系统管理 → 编号规则） |
| 字典 SQL | 插入字典数据（元素类型、周期类型等） |

---

## 设计亮点

1. **灵活组合**：支持三种元素任意组合、任意顺序
2. **实时预览**：配置过程中即可看到最终效果
3. **并发安全**：数据库行级锁保证编号唯一不重复
4. **周期重置**：流水号支持日/月/年周期自动重置
5. **易于扩展**：新增元素类型只需扩展 itemType 和对应逻辑
6. **统一调用**：业务方只需一行代码即可生成编号

---

## 后续可扩展方向

- [ ] 支持更多元素类型（如部门编码、用户编码等）
- [ ] 支持流水号步长配置
- [ ] 支持多环境隔离（测试/生产流水号分离）
- [ ] 支持编号规则导入导出
- [ ] 支持编号使用记录查询
