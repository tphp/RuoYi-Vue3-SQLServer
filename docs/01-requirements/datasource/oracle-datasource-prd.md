# 需求文档（PRD） - Oracle 副数据源接入

> 中文名称：Oracle副数据源接入需求文档

> 作者：AI 回溯补录（基于《Oracle数据源接入实施计划》与当前配置）| 日期：2026-11-17 | 状态：回溯补录（待业务确认）
>
> ⚠️ 本文档为事后回溯：实施计划已落地（双数据源可用），需求描述以实施文档与代码行为为准。

## 1. 需求背景

- 问题 / 机会描述：项目主库为 MSSQL，后续业务需要读写外部 Oracle 系统的数据，现有动态数据源机制（master/slave）只有主库，无法接入第二套异构数据库。

## 2. 需求目标

- 业务目标：业务代码通过 `@DataSource(DataSourceType.ORACLE)` 注解即可切换到 Oracle 数据源，读写均可用，且不影响现有 MSSQL 业务。
- 量化指标（如有）：不填 Oracle 配置时系统可正常启动（占位符不影响运行）；Oracle 单库事务正确生效。

## 3. 需求范围

### 包含

- [x] 引入 ojdbc11 + orai18n 驱动（JDK 17 / Spring Boot 4 兼容）
- [x] 新增 `DataSourceType.ORACLE` 枚举与 Druid Oracle 连接池 Bean，注册进 `DynamicDataSource`
- [x] `application-druid.yml` Oracle 连接配置（真实连接按环境填写）
- [x] 事务方案：复用默认 `DataSourceTransactionManager`，切面顺序保证 `@DataSource(ORACLE)` + `@Transactional` 单库事务正确
- [x] 分页方案：Oracle 方法显式 `PageHelper.startPage(pageNum, pageSize, "oracle")`，全局方言保持 sqlserver
- [x] Oracle Mapper 规范：SQL 遵循 Oracle 语法（`ROWNUM`/`NVL`/`seq.nextval`/`FROM DUAL`，禁 `LIMIT`）

### 不包含（Out of Scope）

- [ ] 跨库分布式事务（同一方法内 MSSQL + Oracle 混写，需 JTA，本期不做）
- [ ] Oracle 数据同步/建表工具
- [ ] 多 Oracle 实例路由

## 4. 用户与角色

| 角色 | 使用场景 | 核心诉求 |
|------|----------|----------|
| 开发人员 | 编写访问 Oracle 的业务查询/写入 | 注解切换简单、分页与事务行为正确 |
| 运维/实施 | 按环境配置 Oracle 连接 | 配置集中于 yml、缺配置不炸启动 |
| 审计/DBA | 核查跨库访问行为 | 写操作只落对应库、无跨库脏事务 |

## 5. 功能需求

### 功能点1：数据源装配

- 描述：`DruidConfig` 注册 oracle 数据源并入动态数据源路由表；`DataSourceType` 增加 `ORACLE` 枚举。
- 约束条件：属框架红区改动，已获授权实施，后续不得随意再动。

### 功能点2：注解切换与切面顺序

- 描述：`DataSourceAspect`（`@Order(1)`）先于事务切面执行，保证事务开始前 ThreadLocal 已切到 ORACLE。
- 约束条件：`@DataSource(DataSourceType.ORACLE)` 与 `@Transactional` 可在方法上叠加；同方法禁止混操作两个库。

### 功能点3：分页方言隔离

- 描述：全局 `pagehelper.helperDialect: sqlserver` 不变；Oracle 业务方法显式指定 `oracle` 方言，不走 `PageUtils.startPage()`。

### 功能点4：连接配置

- 描述：`application-druid.yml` 提供 Oracle url/username/password 配置段，按环境填写。
- 约束条件：真实口令不得提交 Git（安全红线）。

## 6. 验收标准

- [ ] `mvn clean package -DskipTests` 编译通过
- [ ] 不填 Oracle 连接信息时应用正常启动，MSSQL 业务不受影响
- [ ] 填入有效配置后，标注 `@DataSource(DataSourceType.ORACLE)` 的方法读写 Oracle 成功
- [ ] Oracle 方法内 `@Transactional` 回滚行为正确（单库事务）
- [ ] Oracle 方法分页结果正确，MSSQL 现有分页不受影响

## 7. 疑问与待确认

- [ ] 各环境（dev/test/prod）的 Oracle 连接信息是否已在 `application-druid.yml` 配置齐全？
- [ ] 实施计划中提到 Oracle Mapper 放 `ruoyi-crm/.../mapper/crm/oracle/` —— 该路径已过期（见规则废弃声明），**实际 Oracle Mapper 应按现行规范放入自建业务模块** `ruoyi-<模块>/resources/mapper/<module>/`，首个 Oracle 业务接入时按此执行并回填至此。
- [ ] 首批接入 Oracle 的业务场景（读 or 写）与数据表清单？
- [ ] 是否需要对 Oracle 连接池配置独立监控（Druid 监控页已区分数据源）？

## 8. 关联文档

- [Oracle数据源接入实施计划（02-development/datasource）](../../02-development/datasource/oracle-datasource-plan.md)
