# 开发文档目录（02-development）

存放技术方案、架构设计、接口设计、数据模型等开发文档。

## 目录组织规范

按**业务模块 / 技术领域**建立子目录归类，每个模块一个目录。随文档增多，只需新增对应子目录，不污染根目录。

```
02-development/
├── README.md                 # 本文件：规范 + 索引
├── _template-dev.md          # 开发文档通用模板（勿删）
├── common/                   # 通用能力文档（各分支项目共用）
│   └── <模块名>/             # 每个业务模块 / 技术领域一个子目录
│       └── <英文短横线名>.md  # 首行保留中文标题，并写明「中文名称：xxx」
└── ai-dev/                   # AI 开发协作指南
```

### 命名规范

- 模块目录：英文小写、短横线分隔，与后端模块名 / 功能领域对齐（如 `bizperm`、`number-rule`、`external-api`、`datasource`）
- 开发文档：文件名统一用**英文小写、短横线分隔**描述文档性质（如 `api-log-dev.md`、`external-integration-plan.md`、`oracle-datasource-plan.md`、`policy-crud-checklist.md`）；文档首行保留中文标题，并在标题下写明「中文名称：接口日志功能开发文档」等中文名，便于对应查找
- 模板：`_template-dev.md`

### 新增开发文档步骤

1. 在 `02-development/common/` 下新建（或复用）对应模块子目录。
2. 复制 `_template-dev.md` 到该子目录，重命名为正式文档。
3. 涉及 SQL / Mapper 时，需遵守 SQL Server 语法规范。
4. 接口设计需包含请求/响应格式与错误处理。
5. 更新下方「文档索引」表。

## 文档索引

| 模块 | 目录 | 文档 |
|------|------|------|
| 业务级权限体系 | `common/bizperm/` | [业务级权限体系开发任务清单](common/bizperm/permission-system-tasklist.md) |
| 业务级权限体系 | `common/bizperm/` | [业务级权限策略CRUD落地清单](common/bizperm/policy-crud-checklist.md) |
| 单据编号生成 | `common/number-rule/` | [单据编号生成配置功能方案](common/number-rule/number-generation-config-plan.md) |
| 外部系统接口对接 | `common/external-api/` | [外部系统接口对接方案](common/external-api/external-integration-plan.md) |
| 数据源接入 | `common/datasource/` | [Oracle数据源接入实施计划](common/datasource/oracle-datasource-plan.md) |
| 接口日志 | `common/apilog/` | [接口日志功能开发文档](common/apilog/api-log-dev.md)（回溯补录） |
| 消息队列 | `common/mq/` | [RabbitMQ 接入方案（外部接口失败重试）](common/mq/rabbitmq-plan.md) |
| 全项目结构 | `common/structure/` | [全项目结构说明](common/structure/project-structure.md) |
| AI 开发协作 | `ai-dev/` | [AI开发协作指南](ai-dev/ai-workflow.md) |
