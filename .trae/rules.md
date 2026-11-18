# Trae AI 全局规则

> 本文件为项目全局规则，AI 在每次任务开始时必须优先读取并遵守。
> 技术基线见 `.trae/rules/project-rules.md`（v2.0，已按当前代码库校正）；SQL 语法校验见 `.trae/skills/sqlserver-compat-check/SKILL.md`。

## 强制规则（MUST）

1. **优先读取上下文**：执行任何开发任务前，必须先阅读 `.trae/rules/project-rules.md`，并检索 `docs/` 下相关文档，理解既有需求、方案与约定后再动手。
2. **文档先行**：新需求/新功能开发前，先在 `docs/01-requirements/` 产出需求文档；方案确定后在 `docs/02-development/` 产出开发文档。
3. **分类归档**：所有文档必须归入对应目录，禁止散落：
   - `docs/01-requirements/` — 需求文档（PRD）
   - `docs/02-development/` — 开发 / 设计文档
   - `docs/03-optimization/` — 优化改造文档
   - `docs/04-bugfix/` — Bug / BadCase 记录
4. **模块子目录归类**：在上述四类目录下，按业务模块 / 技术领域建子目录归档（目录名英文小写、短横线分隔，与后端模块名对齐，如 `bizperm`、`number-rule`、`datasource`）。通用能力文档统一放 `common/<module>/`（需求与开发两侧一致）。禁止把多份文档直接平铺在根目录。
5. **复用模板**：新建文档优先使用各目录下的 `_template-*.md` 模板，保持结构一致。
6. **维护索引**：新建文档后同步更新对应目录 README 的「文档索引」表，以及顶层 `docs/README.md`。
7. **遵守技术基线**：同时遵守 `.trae/rules/project-rules.md` 中的框架、编码、数据库与前端规范（含 `ruoyi-ui` 为唯一前端、SQL Server + Oracle 双数据源等约束）。
8. **强制 SQL 校验**：新增/修改 Mapper XML、Java 内嵌 SQL、建表脚本前，必须按 `.trae/skills/sqlserver-compat-check/SKILL.md` 检查清单校验通过后再输出代码。
9. **6A 工作流归档映射**：6A 各阶段产物统一落入上述四类目录，不得在 `docs/` 根下新建 `任务名/` 目录：
   - 对齐 / 需求 → `01-requirements/common/<module>/`
   - 设计 / 任务 / 验收 / 总结 → `02-development/common/<module>/`
   - 优化 → `03-optimization/<module>/`
   - 缺陷 → `04-bugfix/<module>/`
10. **Git 目标**：提交与推送仅使用 `origin`（主远程仓库）；其他历史远程（如 `crm-api`）禁止 push / merge / pull。

## 相关入口

- 技术基线：[`.trae/rules/project-rules.md`](rules/project-rules.md)
- AI 技能：[`.trae/skills/`](skills/)
- 文档索引：[`docs/README.md`](../docs/README.md)
- 在线文档中心：`http://localhost:8080/docs/index.html`（`DocCenterController`）

## 优先级

人工明确指令 > 本全局规则 > `project-rules.md` 技术基线 > `docs/` 既有文档约定 > 业务 Prompt > AI 自主优化
