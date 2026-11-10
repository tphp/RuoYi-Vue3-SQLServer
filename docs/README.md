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
- 若运行时探测不到项目根目录，可在 `application.yml` 配置 `ruoyi.docPath: D:/ebs-api` 覆盖。

## 已归档文档

| 分类 | 文档 |
|------|------|
| `01-requirements/bizperm/` | [业务级权限体系需求开发方案](01-requirements/bizperm/业务级权限体系需求开发方案.md) |
| `02-development/bizperm/` | [业务级权限体系开发任务清单](02-development/bizperm/业务级权限体系开发任务清单.md) |
| `02-development/bizperm/` | [业务级权限策略CRUD落地清单](02-development/bizperm/业务级权限策略CRUD落地清单.md) |
| `02-development/number-rule/` | [单据编号生成配置功能方案](02-development/number-rule/单据编号生成配置功能方案.md) |
| `02-development/external-api/` | [外部系统接口对接方案](02-development/external-api/外部系统接口对接方案.md) |
| `02-development/datasource/` | [add-oracle-datasource（Oracle 数据源接入实施计划）](02-development/datasource/add-oracle-datasource.md) |

> 原 `.trae/docs/`、`.trae/documents/` 下的文档已完成迁移归档。
