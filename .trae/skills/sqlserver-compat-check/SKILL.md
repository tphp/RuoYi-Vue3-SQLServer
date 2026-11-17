---
name: "sqlserver-compat-check"
description: "检测 Mapper XML、Java 内嵌 SQL 中 MySQL 专属语法，统一适配 SQL Server 语法规范。【强制自动触发】只要涉及 mapper、xml、SQL、数据库相关代码生成/修改/审查，必须先调用本技能校验通过后再输出最终代码。"
---

# SQL Server 兼容性检查

## ⚠️ 最高强制规则（必须遵守）

### 自动触发条件（满足任意一条即触发，禁止跳过）

1. 生成/新增/修改/审查 MyBatis Mapper XML 文件（后缀 .xml）
2. 编写、优化、排查 Java 代码中内嵌 SQL、DAO 层、持久层 CRUD 数据库代码
3. 对话出现关键词：mapper、xml、MyBatis、SQL、select、insert、update、delete、limit、top、now、sysdate、getdate、分页、foreach、if test、数据库
4. 用户需要修复 SQL 语法报错、改写数据库查询语句、新增表操作 SQL 等场景

### 执行流程（严格按顺序执行）

1. **先生成代码草稿**：写出 Mapper XML 或 SQL 相关代码
2. **调用本技能全量校验**：逐项对照检查清单验证
3. **修复所有问题**：发现不兼容语法立即修正
4. **再次校验**：修复后重新检查，确保全部通过
5. **输出最终代码**：确认全部兼容后再返回给用户

> ❌ **绝对禁止**：跳过兼容性校验直接返回 Mapper XML、SQL、数据库相关代码

---

## 用途

本项目使用 SQL Server 数据库，所有 SQL 语句必须兼容 SQL Server 语法。本 skill 用于检查代码中是否存在 MySQL 等其他数据库的语法，确保代码在 SQL Server 环境下正常运行。

## 检查清单

### 1. Mapper XML 检查

#### ❌ 禁止使用（MySQL 语法）
```sql
-- 禁止：limit 分页
select * from table limit 1
select * from table limit 10, 20
```

#### ✅ 正确写法（SQL Server 语法）
```sql
-- 取前 N 条：使用 top N
select top 1 * from table
select top 10 * from table

-- 项目统一风格：定义 top1 的 sql 片段
<sql id="selectXxxVoTop1">
    select top 1 id, name, ...
    from table_name
</sql>
```

### 2. 日期函数检查

#### ❌ 禁止使用
```sql
-- MySQL 的 now()
select now()
-- MySQL 的 sysdate()
select sysdate()
```

#### ✅ 正确写法
```sql
-- SQL Server
select getdate()
```

### 3. 字符串拼接函数

#### ❌ 禁止使用
```sql
-- MySQL 的 concat 可能在某些场景有差异（注意：SQL Server 2012+ 也支持 concat，但低版本不支持）
-- 尽量使用 + 号拼接，或确认项目兼容
```

### 4. 分页查询

#### ❌ 禁止使用
```sql
-- MySQL limit 分页
select * from table limit #{offset}, #{pageSize}
```

#### ✅ 正确写法
- 使用 PageHelper 分页插件（项目已集成，配置 `helperDialect: sqlserver`）
- 不要手动写分页 SQL，交给 PageHelper 处理

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

## 检查方法

1. 搜索所有 Mapper XML 文件中的 `limit` 关键字
2. 搜索 Java 代码中的 SQL 字符串是否有 MySQL 语法
3. 检查日期函数使用是否正确
4. 确认分页查询使用 PageHelper 而非手动写 limit
5. 检查 include 引用 sql 片段时是否出现重复的 from 子句
6. 检查所有 SQL 函数是否为 SQL Server 支持的

## 搜索命令参考

使用 Grep 工具搜索以下关键字（搜索范围：mapper 目录）：
- `limit` / `LIMIT`
- `now()`
- `sysdate()`
- `from.*from`（检查重复 from）

## 修复原则

1. `limit N` → 改为 `top N`
2. `limit offset, size` → 使用 PageHelper 分页
3. `now()` → 改为 `getdate()`
4. 重复 from → 去掉 include，写完整 SQL
5. 保持与项目现有代码风格一致
