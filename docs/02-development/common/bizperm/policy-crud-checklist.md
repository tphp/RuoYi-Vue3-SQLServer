# 业务级权限 · 策略 CRUD 落地清单

> 中文名称：业务级权限策略CRUD落地清单

> 版本：v1.0（2026-11-03）
> 对应模块：`ruoyi-bizperm`
> 适用数据库：SQL Server
> 关联文档：`permission-system-prd.md`（业务级权限体系需求开发方案）、`permission-system-tasklist.md`（业务级权限体系开发任务清单）

---

## 1. 落地顺序（按此顺序执行）

| 步骤 | 内容 | 产出物 | 是否可跳过 |
|---|---|---|---|
| 1 | 执行 4 个 SQL 脚本 | 表、索引、菜单、字典 | 否 |
| 2 | 放入后端 Java 文件 | 7 个类（见第 3 节） | 否 |
| 3 | 编译模块 | `ruoyi-bizperm` 编译通过 | 否 |
| 4 | 分配菜单权限 | 角色勾选「业务权限配置」 | 联调必做 |
| 5 | 按第 6 节逐项自测 | 接口返回 + Redis 缓存观察 | 否 |

---

## 2. SQL 脚本清单

### 2.1 执行顺序

| 序号 | 文件路径 | 作用 | 备注 |
|---|---|---|---|
| 1 | `ruoyi-bizperm/src/main/resources/sql/bizperm/sys_biz_perm_policy.sql` | 策略主表 + 索引 | 先建主表 |
| 2 | `ruoyi-bizperm/src/main/resources/sql/bizperm/sys_biz_perm_scope.sql` | 可见范围明细表 + 索引 | 依赖主表 id（逻辑关联） |
| 3 | `ruoyi-bizperm/src/main/resources/sql/bizperm/sys_menu_bizperm.sql` | 菜单 2100 + 按钮 2101~2104 | 执行前查 `MAX(menu_id)` 防冲突 |
| 4 | `ruoyi-bizperm/src/main/resources/sql/bizperm/sys_dict_bizperm.sql` | 场景字典 `biz_perm_policy` | 场景编码需在此登记，否则外部查询接口返回 404 |

### 2.2 关键结构约束

**策略主表 `sys_biz_perm_policy`**

| 字段 | 类型 | 说明 |
|---|---|---|
| id | bigint IDENTITY | 主键 |
| policy_code | nvarchar(64) | 业务场景编码，如 `customer:view` |
| policy_name | nvarchar(100) | 场景名称 |
| subject_type | nvarchar(16) | 权限归属人类型：USER / POST / DEPT |
| subject_value | nvarchar(64) | 工号 / 岗位ID / 部门ID |
| subject_name | nvarchar(100) | 归属人名称（冗余展示） |
| include_child | nchar(1) | 归属人为部门时是否含下级：0否 1是 |
| status | nchar(1) | 0启用 1停用 |
| create_by / create_time / update_by / update_time / remark | - | 审计字段 |

**唯一索引（重要）**

```sql
CREATE UNIQUE INDEX [uk_biz_perm_policy]
    ON [dbo].[sys_biz_perm_policy] ([policy_code], [subject_type], [subject_value])
    WHERE [status] = '0';
```

- 只约束「启用」记录。停用记录不占用唯一键，可以重复新增。
- 服务层 `countActivePolicy` 与之口径一致：仅当 `status='0'` 时才做重复校验，避免出现「索引允许但接口报错」或「接口放过但插入报唯一键冲突」。

**范围表 `sys_biz_perm_scope`**

| 字段 | 类型 | 说明 |
|---|---|---|
| policy_id | bigint | 关联策略 id |
| scope_type | nvarchar(16) | USER / POST / DEPT |
| scope_value | nvarchar(64) | 工号 / 岗位ID / 部门ID |
| scope_name | nvarchar(100) | 范围名称 |
| include_child | nchar(1) | 部门范围是否含下级 |
| order_num | int | 排序，同时决定分组归属优先级 |

- 唯一索引 `uk_biz_perm_scope (policy_id, scope_type, scope_value)`：同一策略下同一范围只允许一行。
- 跨部门 = 多条 DEPT 记录。
- 主表与范围表**无外键**，删除主表时由业务层先删范围（`deleteScopesByPolicyIds`）。

**菜单与权限字符串**

| menu_id | 名称 | 类型 | perms |
|---|---|---|---|
| 2100 | 业务权限配置 | C 菜单 | `bizperm:policy:list` |
| 2101 | 权限查询 | F 按钮 | `bizperm:policy:query` |
| 2102 | 权限新增 | F 按钮 | `bizperm:policy:add` |
| 2103 | 权限修改 | F 按钮 | `bizperm:policy:edit` |
| 2104 | 权限删除 | F 按钮 | `bizperm:policy:remove` |

---

## 3. Java 文件清单

| 类型 | 文件 | 说明 |
|---|---|---|
| 实体 | `ruoyi-bizperm\src\main\java\com\ruoyi\bizperm\domain\SysBizPermPolicy.java` | 增加 `List<SysBizPermScope> scopes`，新增/修改时一并提交范围 |
| 实体 | `...\domain\SysBizPermScope.java` | 已存在，无需改动 |
| Mapper 接口 | `...\mapper\BizPermPolicyMapper.java` | 新增 7 个方法（见第 5 节） |
| Mapper XML | `ruoyi-bizperm\src\main\resources\mapper\bizperm\BizPermPolicyMapper.xml` | 新增 7 条语句（见第 5 节） |
| Service 接口 | `...\service\IBizPermPolicyService.java` | **新增** |
| Service 实现 | `...\service\impl\BizPermPolicyServiceImpl.java` | **新增**，写操作带 `@Transactional` + 提交后清缓存 |
| Controller | `...\controller\BizPermPolicyController.java` | 在原树接口基础上新增 5 个 CRUD 接口 |
| 缓存服务 | `...\service\IBizPermQueryService.java` / `BizPermQueryServiceImpl.java` | 提供 `evictVisibleUsers(policyCode)` |

---

## 4. 接口清单（对照开发）

统一前缀：`/bizperm/policy`，返回体为若依标准 `AjaxResult` / `TableDataInfo`。

| # | 方法 | 路径 | 权限 | 入参 | 返回 | 触发缓存失效 |
|---|---|---|---|---|---|---|
| 1 | GET | `/bizperm/policy/list` | `bizperm:policy:list` | `SysBizPermPolicy` 查询条件 + `pageNum/pageSize` | `TableDataInfo`（`rows` + `total`） | 否 |
| 2 | GET | `/bizperm/policy/{id}` | `bizperm:policy:query` | 路径参数 `id` | `AjaxResult.data` = 策略 + `scopes` | 否 |
| 3 | POST | `/bizperm/policy` | `bizperm:policy:add` | JSON 策略 + `scopes` | `AjaxResult`（影响行数） | 是：新增的 `policyCode` |
| 4 | PUT | `/bizperm/policy` | `bizperm:policy:edit` | JSON 策略 + `scopes`（可缺省） | `AjaxResult`（影响行数） | 是：旧 `policyCode` + 新 `policyCode` |
| 5 | DELETE | `/bizperm/policy/{ids}` | `bizperm:policy:remove` | 路径参数，逗号分隔 id | `AjaxResult`（影响行数） | 是：被删记录涉及的每个 `policyCode` |

> 路由说明：`/{id}` 为 `Long`，与已有的 `/tree`、`/tree/children` 共存时，Spring 优先匹配字面量路径，不会互相截获。

### 4.1 请求示例

**新增（POST `/bizperm/policy`）**

```json
{
  "policyCode": "customer:view",
  "policyName": "客户查看范围",
  "subjectType": "USER",
  "subjectValue": "E1001",
  "subjectName": "张三",
  "includeChild": "0",
  "status": "0",
  "remark": "华东销售组",
  "scopes": [
    { "scopeType": "DEPT", "scopeValue": "103", "scopeName": "华东大区", "includeChild": "1", "orderNum": 0 },
    { "scopeType": "DEPT", "scopeValue": "208", "scopeName": "华南大区", "includeChild": "0", "orderNum": 1 },
    { "scopeType": "POST", "scopeValue": "5", "scopeName": "销售经理", "includeChild": "0", "orderNum": 2 }
  ]
}
```

**修改（PUT `/bizperm/policy`）**

```json
{
  "id": 12,
  "policyCode": "customer:view",
  "policyName": "客户查看范围",
  "subjectType": "USER",
  "subjectValue": "E1001",
  "subjectName": "张三",
  "includeChild": "0",
  "status": "0",
  "scopes": [
    { "scopeType": "DEPT", "scopeValue": "103", "scopeName": "华东大区", "includeChild": "1", "orderNum": 0 }
  ]
}
```

**查询列表（GET `/bizperm/policy/list?policyCode=customer&subjectType=USER&pageNum=1&pageSize=10`）**

```json
{
  "total": 1,
  "rows": [
    {
      "id": 12,
      "policyCode": "customer:view",
      "policyName": "客户查看范围",
      "subjectType": "USER",
      "subjectValue": "E1001",
      "subjectName": "张三",
      "includeChild": "0",
      "status": "0",
      "createBy": "admin",
      "createTime": "2026-11-03 10:00:00",
      "updateBy": "admin",
      "updateTime": "2026-11-03 10:20:00"
    }
  ],
  "code": 200,
  "msg": "查询成功"
}
```

**详情（GET `/bizperm/policy/12`）**

```json
{
  "code": 200,
  "msg": "操作成功",
  "data": {
    "id": 12,
    "policyCode": "customer:view",
    "policyName": "客户查看范围",
    "subjectType": "USER",
    "subjectValue": "E1001",
    "subjectName": "张三",
    "includeChild": "0",
    "status": "0",
    "scopes": [
      { "id": 31, "policyId": 12, "scopeType": "DEPT", "scopeValue": "103", "scopeName": "华东大区", "includeChild": "1", "orderNum": 0 }
    ]
  }
}
```

**删除（DELETE `/bizperm/policy/12,13`）**

```json
{ "code": 200, "msg": "操作成功" }
```

### 4.2 错误返回

| 场景 | code | msg |
|---|---|---|
| 必填项缺失 | 500（`ServiceException`） | 业务场景编码不能为空 / 权限归属人不能为空 等 |
| 同场景同归属人已有启用策略 | 500（`ServiceException`） | 该业务场景下该权限归属人已存在启用中的策略 |
| 修改时 id 不存在 | 500（`ServiceException`） | 权限策略不存在 |
| 范围行缺少类型或值 | 500（`ServiceException`） | 可见范围类型和范围值不能为空 |
| 无权限 | 403 | 无权限访问（`@PreAuthorize`） |

---

## 5. Mapper SQL 对照表

方法名 ↔ XML statement id ↔ 用途 ↔ 注意点：

| # | Mapper 方法 | statement id | 用途 | SQL Server 注意点 |
|---|---|---|---|---|
| 1 | `selectPolicyList` | `selectPolicyList` | 列表分页（PageHelper） | 模糊匹配用 `'%' + #{x} + '%'`，不用 `concat` |
| 2 | `selectPolicyById` | `selectPolicyById` | 按 id 查策略 | - |
| 3 | `selectScopesByPolicyIds` | `selectScopesByPolicyIds` | 详情/批量取范围 | `foreach` 拼 `in` |
| 4 | `insertPolicy` | `insertPolicy` | 新增策略 | `useGeneratedKeys="true" keyProperty="id"` 回填主键；时间用 `getdate()` |
| 5 | `updatePolicy` | `updatePolicy` | 修改策略 | `<set>` 动态列；强制刷新 `update_time = getdate()` |
| 6 | `deletePolicyByIds` | `deletePolicyByIds` | 物理删除策略 | 无 `limit`，用 `foreach` |
| 7 | `deleteScopesByPolicyIds` | `deleteScopesByPolicyIds` | 删除策略下所有范围 | 先删子表再删主表 |
| 8 | `insertScopes` | `insertScopes` | 批量插入范围 | 单条 `insert ... values (...),(...)`，`getdate()` |
| 9 | `selectPolicyCodesByIds` | `selectPolicyCodesByIds` | 删除前取场景编码用于清缓存 | `select distinct` |
| 10 | `countActivePolicy` | `countActivePolicy` | 启用策略唯一性校验 | `<if test="id != null"> and id != #{id}`，修改时排除自身 |

> 已按 `sqlserver-compat-check` 校验：无 `limit`、无 `now()/sysdate()`、日期统一 `getdate()`、`foreach` 用法正确、XML 解析通过。

---

## 6. 缓存失效规则（核心）

**缓存 key**：`bizperm:visible:{policyCode}:{userCode}`，TTL 30 分钟。

| 操作 | 失效范围 | 时机 |
|---|---|---|
| 新增策略 | 该策略的 `policyCode` 下所有 key | 事务提交后 |
| 修改策略 | 旧 `policyCode` + 新 `policyCode`（场景编码可能被改） | 事务提交后 |
| 删除策略 | 被删记录涉及的每个 `policyCode` | 事务提交后 |
| 停用策略 | 同「修改」 | 事务提交后 |

**实现方式**（`BizPermPolicyServiceImpl#evictVisibleUsersAfterCommit`）：

- 事务活跃：`TransactionSynchronizationManager.registerSynchronization(...)`，在 `afterCommit()` 中调用 `evictVisibleUsers`。
- 无事务：直接调用。
- 好处：事务回滚不会误清缓存；并发读也不会在提交前把旧数据重新写回缓存。
- 实际删除：`bizperm:visible:{policyCode}:*` 批量 `keys` + `deleteObject`，Redis 异常只记录 `warn`，不影响主流程。

**需要在写操作里遵守的约定**：
1. 删除策略时必须先 `selectPolicyCodesByIds` 拿到编码，再删数据；否则删完查不到编码，缓存会残留。
2. 修改策略时必须同时清「旧编码」和「新编码」。
3. 不要在外层 Controller 提前清缓存（那时事务还没提交）。

---

## 7. 业务规则速查

| 规则 | 实现位置 | 说明 |
|---|---|---|
| 新增强制 id 置空 | `validatePolicy(true)` | 防止前端误传 id 变成更新 |
| 状态默认启用 | `validatePolicy` | 未传 `status` 默认 `0` |
| 含下级默认否 | `validatePolicy` / `saveScopes` | `includeChild` 为空默认 `0` |
| 启用唯一性校验 | `countActivePolicy` | 仅 `status='0'` 校验，与过滤唯一索引一致 |
| 范围整体替换 | `updatePolicy` | `scopes != null` 时先删后插；传 `null` 表示本次不改范围 |
| 范围排序 | `saveScopes` | 未传 `orderNum` 按数组顺序 0,1,2… 递增 |
| 删除为物理删除 | `deletePolicyByIds` | 如需停用请改状态而非删除 |
| 分页 | Controller `startPage()` | 必须在查询前调用 |

---

## 8. 联调自测清单

- [ ] 执行 4 个 SQL 脚本无报错；`SELECT * FROM sys_biz_perm_policy` 表存在。
- [ ] `sys_dict_data` 中 `biz_perm_policy` 已登记待测场景编码（如 `customer:view`）。
- [ ] 角色勾选菜单 2100 及按钮 2101~2104，重新登录。
- [ ] `POST /bizperm/policy` 新增 1 条策略（2 个 DEPT 范围，其中 1 个含下级），返回 code=200。
- [ ] `GET /bizperm/policy/{id}` 能看到 `scopes` 两条且 `orderNum` 为 0、1。
- [ ] 同场景同归属人再新增一条启用策略 → 返回「已存在启用中的策略」。
- [ ] 把上一条改成 `status=1` 再新增 → 成功（验证过滤唯一索引口径）。
- [ ] `POST` 时故意不传 `policyCode` → 返回「业务场景编码不能为空」。
- [ ] `PUT` 只传 1 个范围 → 详情只剩 1 条（验证整体替换）。
- [ ] `PUT` 不传 `scopes` → 详情范围保持不变。
- [ ] 调用 `/bizperm/policy/tree?depth=3`，新增的策略能在树中出现。
- [ ] 调用 `/bizperm/my/visible-users?policyCode=xxx&groupByDept=true`，人数与配置部门一致。
- [ ] Redis 执行 `keys bizperm:visible:xxx:*`：
  - [ ] 查询后出现缓存 key；
  - [ ] 新增/修改/删除后再查 `keys`，旧 key 已消失（说明提交后失效生效）；
  - [ ] 再请求可见人员，人数随配置变化。
- [ ] `DELETE /bizperm/policy/{ids}` 后，`sys_biz_perm_scope` 中对应 `policy_id` 已无残留。
- [ ] 删除全部策略后，`/bizperm/my/visible-users` 返回 0 条（场景仍在字典中，不返回 404）。

---

## 9. 编译与部署

```bash
# 本机 PATH 只有 JDK 8，使用 IDEA 自带 JBR 21 时需显式指定 release
mvn -pl ruoyi-bizperm compile -DskipTests -o "-Dmaven.compiler.release=17"

# 打包（跳过测试）
mvn clean package -DskipTests
```

- 前端代理：`/dev-api` → 后端 `8080`。
- 接口路径前缀已在 `@RequestMapping("/bizperm/policy")` 中固定，前端请求写 `/bizperm/policy/...` 即可。

---

## 10. 遗留与注意事项

| # | 事项 | 说明 |
|---|---|---|
| 1 | 前端页面未生成 | 菜单 2100 指向 `bizperm/policy/index`，需补 Vue 页面（列表 + 树 + 范围编辑） |
| 2 | 新增接口不返回主键 | 当前返回影响行数；如前端新增后需跳详情，可改为返回 `policy.getId()` |
| 3 | 未做数据权限 `@DataScope` | 策略配置属于后台配置，未加部门数据权限，如需限制请补充 |
| 4 | 未做操作人隔离 | 任何有按钮权限的人都能改所有策略，如需「只能改自己配置的」需加 `create_by` 校验 |
| 5 | 场景编码变更影响面 | 修改 `policyCode` 会立即清旧/新两个场景缓存，但外部系统若已按旧编码调用需同步通知 |
| 6 | 缓存 key 清理由 `keys` 扫描 | 数据量大时建议改为维护 `bizperm:visible:index:{policyCode}` 集合，避免 `keys` 阻塞 |
| 7 | 删除为主表物理删除 | 历史审计依赖 `@Log` 操作日志（`sys_oper_log`），表内不留痕 |
