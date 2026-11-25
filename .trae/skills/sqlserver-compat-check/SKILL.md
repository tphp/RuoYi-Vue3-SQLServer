---
name: "sqlserver-compat-check"
description: "检测 Mapper XML、Java 内嵌 SQL、DDL 建表脚本中的 MySQL 专属语法，统一适配 SQL Server 语法规范，并反向保护 Oracle 副库语句不被误改。【强制自动触发】只要涉及 mapper、xml、SQL、DDL、建表脚本、数据库相关代码生成/修改/审查，必须先调用本技能校验通过后再输出最终代码。"
---

> 中文名称：SQL Server 兼容性检查

# SQL Server 兼容性检查

## 0. 数据库边界（先看这里，避免改错）

本项目是**双数据源**，两套语法方向完全相反：

| 数据源 | 用途 | 语法要求 |
|--------|------|----------|
| 主库 **SQL Server** | 系统表、业务表、日志表，**所有写操作只能走主库** | `top` / `getdate()` / `isnull()`，禁 `limit`、`now()`、`date_format` |
| 副库 **Oracle** | 只用于查询外部系统数据 | `from dual` / `rownum` / `sysdate` / `to_char`，**禁用** `top`、`getdate()` |

**命中以下任一特征即为 Oracle 语句，本技能的 SQL Server 改写规则全部失效：**

1. 方法或类上标注 `@DataSource(DataSourceType.ORACLE)`
2. Mapper/Controller 位于 `com.ruoyi.web.controller.sales` 下的 Oracle 测试类
3. XML 中 `namespace` 或语句注释显式说明为外部系统 / Oracle 查询

> ⚠️ 违反本节的后果：把 Oracle 的 `sysdate` 改成 `getdate()`、把 `rownum` 改成 `top`，会直接导致线上查询失败。

---

## ⚠️ 最高强制规则（必须遵守）

### 自动触发条件（满足任意一条即触发，禁止跳过）

1. 生成/新增/修改/审查 MyBatis Mapper XML 文件（后缀 .xml）
2. 编写、优化、排查 Java 代码中内嵌 SQL、DAO 层、持久层 CRUD 数据库代码
3. 新增/修改 **DDL 建表脚本**、索引脚本、初始化数据脚本（`.sql`）
4. 对话/任务涉及数据库方言特征：`limit`、`now()`、`curdate`、`date_format`、`str_to_date`、`auto_increment`、`engine=`、反引号、`for update`、`on duplicate key`、`${}` 拼接
5. 目标文件为 `.xml`（MyBatis Mapper）或 `.sql`（DDL / 初始化脚本），或 Java 中存在内嵌 SQL 字符串
6. 用户需要修复 SQL 语法报错、改写数据库查询语句、新增表操作 SQL 等场景

> 仅出现 `select` / `insert` / `分页` 等通用词时不触发本技能，避免普通 CRUD 编码被无谓打断。

### 执行流程（严格按顺序执行）

1. **先判定数据源**：按第 0 节确认目标是 SQL Server 还是 Oracle；Oracle 语句走第 11 节，不走其余改写规则
2. **先生成代码草稿**：写出 Mapper XML / SQL / DDL 相关代码
3. **调用本技能全量校验**：逐项对照第 1~11 节检查清单验证
4. **修复所有问题**：发现不兼容语法立即修正
5. **再次校验**：修复后重新检查，确保全部通过
6. **输出最终代码 + 校验结论**：按第 14 节格式输出，确认全部兼容后再返回给用户

> ❌ **绝对禁止**：跳过兼容性校验直接返回 Mapper XML、SQL、DDL 相关代码

---

## 用途

本项目主库为 SQL Server，Mapper XML、Java 内嵌 SQL、建表脚本必须使用 SQL Server 语法；同时副库 Oracle 的现有语句不得按 SQL Server 规则改写。本 skill 同时覆盖「MySQL → SQL Server 纠正」与「Oracle 语句保护」两个方向。

## 检查清单

### 1. Mapper XML / Java 内嵌 SQL（MySQL 语法禁用）

#### ❌ 禁止使用（MySQL 语法）
```sql
-- 禁止：limit 分页
select * from table limit 1
select * from table limit 10, 20
```

#### ✅ 正确写法（SQL Server 语法）
```sql
-- 取前 N 条：使用 top N，且必须配合 order by 才有确定语义
select top 1 * from table order by id
select top 10 * from table order by create_time desc

-- 项目统一风格：定义 top1 的 sql 片段
<sql id="selectXxxVoTop1">
    select top 1 id, name, ...
    from table_name
    order by id desc
</sql>
```

- 条数为动态参数时用 `top (#{n})`，不要写 `top #{n}`（部分驱动会拼成非法语句）
- `top` 后没 `order by` 属于**语义不确定**，需提醒补排序

### 2. 日期/时间函数对照（含实测漏网项）

#### ❌ 禁止使用
```sql
select now()                                  -- MySQL
select sysdate()                              -- MySQL（注意：Oracle 的 sysdate 无括号，不要误判）
select curdate()
select date_format(create_time,'%Y%m%d')      -- MySQL，本仓库源码仍有 4 处（含 target 编译副本共 8 处，见第 12 节存量豁免）
select unix_timestamp()
select date_sub(create_time, interval 1 day)
select str_to_date('2026-01-01','%Y-%m-%d')
```

#### ✅ 正确写法（SQL Server 等价）

| MySQL 写法 | SQL Server 写法 |
|-----------|----------------|
| `now()` / `curdate()` | `getdate()` |
| `date_format(col,'%Y%m%d')` | `convert(varchar(8), col, 112)` |
| `date_format(col,'%Y-%m-%d')` | `convert(varchar(10), col, 23)` |
| `date_format(col,'%Y%m')` | `convert(varchar(6), col, 112)` |
| `date_sub(col, interval 1 day)` | `dateadd(day, -1, col)` |
| `datediff(a,b)` 求天数 | 同 `datediff(day, b, a)`（**参数顺序与 MySQL 相反**） |
| `str_to_date(x,'%Y-%m-%d')` | `convert(date, x, 23)` |
| `unix_timestamp()` | `datediff(second, '1970-01-01', getdate())` |

### 3. 常用函数对照表

| MySQL | SQL Server | 备注 |
|-------|-----------|------|
| `ifnull(a,b)` | `isnull(a,b)` | 参数顺序一致 |
| `group_concat(col)` | `string_agg(col, ',')`（2017+）或 `for xml path('')` | 注意去重与排序写法差异；`string_agg` 入参必须是字符类型，数值先 `cast(col as nvarchar(max))` |
| `find_in_set(x, col)` | `charindex(x, col) > 0` | 仅适用于简单子串匹配 |
| `instr(s, sub)` | `charindex(sub, s)` | **参数顺序相反** |
| `length(s)` | `len(s)` | `len` 不统计尾部空格 |
| `substring_index(s, ',', 1)` | `left(s, charindex(',', s + ',') - 1)` | 建议改业务逻辑 |
| `if(a,b,c)` | `iif(a,b,c)`（2012+）或 `case when` | 优先 `case when` 兼容性最好 |
| `select ... for update` | `select ... with (updlock, holdlock)` | 见第 6 节 |
| `insert ... on duplicate key update` | `merge into ... using ... when matched then update` | 需评估并发 |
| `insert into t values(1),(2),(3)` | 多条 `insert` 或 `insert ... select ... union all` | 2016 以下不支持多值 |

### 4. 分页查询

#### ❌ 禁止使用
```sql
-- MySQL limit 分页
select * from table limit #{offset}, #{pageSize}
```

#### ✅ 正确写法
- 使用 PageHelper 分页插件（项目已集成，配置 `helperDialect: sqlserver`）
- 不要手动写分页 SQL，交给 PageHelper 处理
- 列表接口必须保持 `startPage()` + `getDataTable()`，改造时不得改成手写分页
- 确需手写（如复杂统计）时用 SQL Server 2012+ 的 `order by <列> offset #{offset} rows fetch next #{size} rows only`，且 `order by` 必填

### 5. 自增主键返回

#### ✅ 正确写法（项目已统一使用）
```xml
<insert id="insertXxx" useGeneratedKeys="true" keyProperty="id">
```

### 6. 行级锁

#### ✅ SQL Server 写法
```sql
select * from table with (updlock, holdlock) where id = ?
```

MySQL 的 `for update` 一律改为 `with (updlock, holdlock)`；需要锁到事务结束再加 `holdlock`。

### 7. include 引用 sql 片段时注意 from 重复

#### ❌ 常见错误
```xml
<sql id="selectXxxVo">
    select id, name from table_name
</sql>

<select id="selectById" resultMap="XxxResult">
    <include refid="selectXxxVo"/>
    from table_name with (updlock, holdlock)
    where id = #{id}
</select>
<!-- 结果：select ... from table_name from table_name ... 出现两个 from，语法错误 -->
```

#### ✅ 正确写法
如果需要加行级锁等特殊语法，直接写完整 SQL，不要复用带 from 的 sql 片段：
```xml
<select id="selectByIdWithLock" resultMap="XxxResult">
    select id, name, ...
    from table_name with (updlock, holdlock)
    where id = #{id}
</select>
```

### 8. 保留字、布尔字面量、字符串拼接

- **保留字必须加方括号**：`[status]`、`[type]`、`[desc]`、`[user]`、`[key]`、`[order]`、`[group]`、`[percent]`；列名/别名命中时加 `[]`，避免语法错误
- **布尔值不用 `true/false`**：改为 `1` / `0`（SQL Server 的 `bit` 类型）；`where flag = true` 属错误写法
- **字符串拼接优先用 `+`**：`'%' + #{keyword} + '%'`；数字与字符串混拼需显式 `convert(varchar, col)`
- 慎用 `concat`：SQL Server 2012+ 支持但低版本不兼容，统一用 `+`
- **空值合并**：`isnull(a,b)` 的返回类型取第一个参数，`coalesce(a,b)` 按数据类型优先级推导；日期、`decimal` 场景优先 `coalesce` 或显式 `convert`，避免精度/类型截断
- **临时表**：SQL Server 用 `#临时表` / `##全局临时表`，禁止 MySQL 的 `create temporary table t(...)` 直接照搬（表名语义不同）
- **schema 前缀**：对象引用建议带 `dbo.`（如 `dbo.sys_number_rule`），避免用户默认 schema 变化后找不到对象

### 9. 参数绑定红线

- 业务参数一律 `#{}` 绑定，禁止 `${}` 拼接用户输入（注入风险）
- `${}` 仅允许用于数据权限等受控场景（如动态列、`order by` 白名单），且必须经过白名单校验
- 现状：30 个业务 mapper XML 中 `${}` 为 0 处，**新增 `${}` 视为违规**，需在评审中说明理由

### 10. DDL 建表 / 索引脚本（新增覆盖）

#### ❌ 禁止出现（MySQL DDL 特征）
```sql
id bigint auto_increment primary key
create_time datetime default current_timestamp on update current_timestamp
`name` varchar(64) comment '名称'
) engine=innodb default charset=utf8mb4;
key idx_name (`name`)
```

#### ✅ 正确写法
```sql
id bigint identity(1,1) primary key
name nvarchar(64) not null
create_time datetime2 default getdate()
create_by nvarchar(64)
-- 索引单独创建
create index idx_表名_字段名 on 表名(字段名)
```

DDL 要点：
- 自增用 `identity(1,1)`，禁止 `auto_increment`
- 字符串用 `nvarchar` / `nvarchar(max)`，禁止 `text`
- 时间用 `datetime2`，默认值 `default getdate()`，禁止 `current_timestamp` 与 `on update`
- 注释不用列级 `comment`，写在脚本注释里或用 `execute sp_addextendedproperty`（按项目现状，优先脚本注释）
- 禁止 `` ` `` 反引号、`engine=`、`charset=`
- 索引名 `idx_<表名>_<字段名>`，建表脚本文件名 = 表名（规则 §5）

### 11. Oracle 副库反向检查（防止误改）

命中第 0 节的 Oracle 特征时，**只做以下检查，不做 SQL Server 改写**：

#### ✅ Oracle 合法写法（不要改）
```sql
select 1 from dual                    -- 校验语句必须带 from dual
select sysdate from dual              -- 注意无括号
select nvl(a, 0) from t               -- 不要改成 isnull
select * from t where rownum <= 10    -- 不要改成 top 10
to_char(create_time,'yyyymmdd')       -- 不要改成 convert
```

#### ❌ 在 Oracle 语句中禁止出现（SQL Server 语法误入）
- `top N`、`getdate()`、`isnull()`、`with (updlock, holdlock)`、`[]` 方括号
- 出现即判定为**改错方向**，需回退并改用 Oracle 等价写法

---

## 12. 存量豁免（框架禁改区）

以下模块属于规则 §1 红区，**只报告、不修改**：

`ruoyi-framework`、`ruoyi-system`、`ruoyi-common`、`ruoyi-quartz`、`ruoyi-generator`、`ruoyi-admin/controller/system`、`ruoyi-admin/controller/monitor`

已知存量问题（实测，勿改，仅提示）：

| 文件 | 问题 |
|------|------|
| `ruoyi-generator/.../GenTableMapper.xml` 第 72、75 行 | `date_format(create_time,'%Y%m%d')` |
| `ruoyi-quartz/.../SysJobLogMapper.xml` 第 41、44 行 | `date_format(create_time,'%Y%m%d')` |

等价修正建议：`convert(varchar(8), create_time, 112) >= convert(varchar(8), #{params.beginTime}, 112)`。如需改动，先取得用户确认。

同时注意：`target/classes/**` 是编译产物，与源码重复，**不计入检查结果**。

## 13. 检查方法

1. 搜索所有 Mapper XML 中的 `limit` / `now()` / `date_format` 等 MySQL 关键字
2. 搜索 Java 代码中的 SQL 字符串是否有 MySQL 语法
3. 检查日期函数使用是否正确
4. 确认分页查询使用 PageHelper 而非手动写 limit
5. 检查 include 引用 sql 片段时是否出现重复的 from 子句
6. 检查 DDL 脚本是否有 `auto_increment` / `engine=` / 反引号 / `comment`
7. 检查是否误把 Oracle 语句按 SQL Server 规则改写（第 11 节）

### 搜索命令参考

使用 Grep 工具搜索以下关键字，**必须排除 `target/` 与 `node_modules/`**（建议 glob：`!**/target/**`）：

- `limit` / `LIMIT`
- `now()` / `curdate` / `date_format` / `str_to_date` / `unix_timestamp`
- `auto_increment` / `engine=` / `on update current_timestamp`
- `for update` / `on duplicate key`
- `from.*from`（检查重复 from）
- `\$\{`（检查非法拼接）
- `top ` / `getdate()` / `isnull(`（在 Oracle 文件中出现即为误改）

## 14. 输出格式要求

校验结论必须逐条列成表格，便于人工核对：

| 文件:行号 | 原文片段 | 问题类型 | 修正后写法 | 级别 |
|-----------|----------|----------|------------|------|
| `SysJobLogMapper.xml:41` | `date_format(create_time,'%Y%m%d')` | MySQL 日期函数 | `convert(varchar(8), create_time, 112)` | P0（禁改区：仅报告） |

级别定义：
- **P0**：会导致运行时报错 / 改错数据源方向，必须修复
- **P1**：语法可用但语义不确定或存在注入风险，建议修复
- **P2**：风格/兼容性提醒，可不改

全部通过时输出：`SQL Server 兼容性校验通过（检查项 1~11，未发现不兼容语法）`。

## 15. 修复原则

1. `limit N` → 改为 `top N` + `order by`
2. `limit offset, size` → 使用 PageHelper 分页
3. `now()` / `curdate()` → 改为 `getdate()`
4. `date_format` → 改为 `convert(varchar(n), col, style)`
5. 重复 from → 去掉 include，写完整 SQL
6. `for update` → `with (updlock, holdlock)`
7. DDL 的 `auto_increment` / 反引号 / `engine=` → 改 SQL Server DDL
8. Oracle 语句命中第 11 节禁入语法 → **回退改写**，不套用第 1~10 节
9. 红区文件只报告不修改
10. 保持与项目现有代码风格一致

## 16. 验证闭环

静态检查通过后，按需执行：

```bash
# 编译验证（JAVA_HOME 需指向 JDK17）
mvn -pl ruoyi-admin -am compile -DskipTests
```

- 涉及列表接口的改动：确认仍为 `startPage()` + `getDataTable()`，并用实际接口验证分页、排序
- 涉及 DDL 的改动：确认脚本可在 SQL Server 直接执行（`identity`、`nvarchar`、`getdate()`）
- 涉及 Oracle 的改动：仅做语法对照复核，不得用 SQL Server 语法试跑
