# 项目文档索引

> AI 与团队成员协作的文档管理中心。任务开始前请先浏览本目录。

## 目录结构

| 目录 | 用途 | 入口 |
|------|------|------|
| `01-requirements/` | 需求文档（PRD） | [README](01-requirements/README.md) |
| `02-development/`  | 开发 / 设计文档 | [README](02-development/README.md) |
| `03-optimization/`  | 优化改造文档 | [README](03-optimization/README.md) |
| `04-bugfix/`        | Bug / BadCase 记录 | [README](04-bugfix/README.md) |

## 在线查阅（文档中心）

服务启动后，浏览器访问以下地址即可在线浏览本目录文档（含 `docs/`、`.trae/rules/`、`.trae/skills/`），无需登录：

```
http://localhost:8080/docs/index.html
```

- 左侧为文档树（项目文档 / 项目规则 / AI 技能），支持按名称搜索。
- 右侧 iframe 内联渲染 Markdown。
- 后端接口：`/docs/api/tree`（文档树）、`/docs/api/content?path=...`（读取内容）。
- 若运行时探测不到项目根目录，可在 `application.yml` 配置 `ruoyi.docPath: <本项目根目录绝对路径>` 覆盖（按各分支项目的实际部署位置填写）。

## 已归档文档

| 分类 | 文档 |
|------|------|
| `01-requirements/common/bizperm/` | [业务级权限体系需求开发方案](01-requirements/common/bizperm/permission-system-prd.md) |
| `01-requirements/common/apilog/` | [接口日志功能需求文档](01-requirements/common/apilog/api-log-prd.md)（回溯补录） |
| `01-requirements/common/number-rule/` | [单据编号生成功能需求文档](01-requirements/common/number-rule/number-generation-prd.md)（回溯补录） |
| `01-requirements/common/external-api/` | [外部系统接口对接需求文档](01-requirements/common/external-api/external-integration-prd.md)（回溯补录） |
| `01-requirements/common/datasource/` | [Oracle副数据源接入需求文档](01-requirements/common/datasource/oracle-datasource-prd.md)（回溯补录） |
| `01-requirements/common/mq/` | [RabbitMQ 外部接口失败重试需求文档](01-requirements/common/mq/rabbitmq-prd.md) |
| `02-development/common/bizperm/` | [业务级权限体系开发任务清单](02-development/common/bizperm/permission-system-tasklist.md) |
| `02-development/common/bizperm/` | [业务级权限策略CRUD落地清单](02-development/common/bizperm/policy-crud-checklist.md) |
| `02-development/common/apilog/` | [接口日志功能开发文档](02-development/common/apilog/api-log-dev.md)（回溯补录） |
| `02-development/common/number-rule/` | [单据编号生成配置功能方案](02-development/common/number-rule/number-generation-config-plan.md) |
| `02-development/common/external-api/` | [外部系统接口对接方案](02-development/common/external-api/external-integration-plan.md) |
| `02-development/common/datasource/` | [Oracle数据源接入实施计划](02-development/common/datasource/oracle-datasource-plan.md) |
| `02-development/common/mq/` | [RabbitMQ 接入方案（外部接口失败重试）](02-development/common/mq/rabbitmq-plan.md) |
| `02-development/common/structure/` | [全项目结构说明](02-development/common/structure/project-structure.md)（含前后端定位：后端 `xxx-api` 本仓库 + 主前端 `xxx-web` 独立仓库平级，Vue3+TS） |
| `02-development/ai-dev/` | [AI开发协作指南](02-development/ai-dev/ai-workflow.md) |

> 原 `.trae/docs/`、`.trae/documents/` 下的文档已完成迁移归档。
