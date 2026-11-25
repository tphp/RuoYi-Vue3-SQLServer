# AI 开发协作指南（开发者版）

> 中文名称：AI开发协作指南
> 生成时间：2026-11-17 | 适用：人类开发者与后续 AI 会话的统一入口
> 位置：`.trae/rules/ai-workflow.md`（与 [project-rules.md](project-rules.md) 同目录）
> 权威依据：[project-rules.md](project-rules.md)（技术基线，本文为导读与操作手册，冲突时以规则原文为准）

## 0. 一分钟上手（后续 AI 会话必读）

1. **先读规则**：[project-rules.md](project-rules.md)（技术基线，§0 定义优先级：人工指令 > 全局 rules > 技术基线 > docs 约定 > 业务 Prompt）
2. **再查记忆**：项目记忆 `project_memory.md` 中的 Hard Constraints / Engineering Conventions / Lessons Learned
3. **新增功能一律走 §13 九步强制流程**（见 §3），存疑即中断询问，禁止跳步直接写代码
4. **涉及 SQL 必触发技能**：`sqlserver-compat-check`（见 §4）
5. **文档先行**：PRD → 方案 → 任务 → 验收，全部归档 `docs/01-04`，首行中文标题 + `> 中文名称：xxx`

## 1. 项目与技术栈速览

- 基座：RuoYi-Vue 3.9.2 / Spring Boot 4.0.6 / JDK 17 / MyBatis / PageHelper / FastJSON2 / SQL Server 主库（Oracle 副库）
- 前端：**主前端 `xxx-web`**（独立仓库、与本仓库平级；Vue 3.5 + TypeScript + Vite + Element Plus + Pinia，当前使用的最新技术栈）。本仓库内 `ruoyi-ui`（Vue 2.6 + Element UI + Options API）为旧前端，仅存量维护，新功能优先在主前端实现
- 模块红绿区（详见规则 §1）：
  - 🔴 禁改：`ruoyi-framework`、`ruoyi-system`、`ruoyi-common`、`ruoyi-quartz`、`ruoyi-generator`
  - 🟡 受限：`ruoyi-admin`（`controller/system`、`monitor` 禁改）
  - 🟢 可改：`ruoyi-apilog`、`ruoyi-bizperm`；主前端 `xxx-web` 的 `views/<模块>`、`api/<模块>`、`types/api/<模块>`（旧前端 `ruoyi-ui` 同边界，仅存量维护）
  - **新增功能必须进自建模块**（新建 `ruoyi-xxx` 或复用上述 🟢 模块），禁止复制存量进 `ruoyi-system` 的旧模式
- 不存在 `crm-web`、`ruoyi-crm`，禁止引用

## 2. 文档体系与命名规范（2026-11-17 改造后）

### 2.1 四类归档

| 目录 | 显示名（文档中心） | 内容 | 模板 |
|------|------|------|------|
| `01-requirements/` | 01-需求 | PRD、需求对齐、共识 | `_template-prd.md` |
| `02-development/` | 02-开发 | 方案、任务、清单、结构文档 | `_template-dev.md` |
| `03-optimization/` | 03-优化 | 优化改造 | `_template-optimize.md` |
| `04-bugfix/` | 04-bug修复 | 缺陷、BadCase | `_template-bugfix.md` |

- 每类下按模块建子目录（英文小写短横线：`bizperm`、`apilog`、`number-rule`、`datasource`…）
- **禁止**在 `docs/` 根下平铺任务目录
- 本文件（AI 开发协作指南）属规则类文档，放在 `.trae/rules/`，不进 `docs/02-development/`

### 2.2 文件与内容规范

- **文件名**：英文小写、短横线；01 以 `-prd` 结尾，02 按性质 `-dev`/`-plan`/`-tasklist`/`-checklist`；禁中文文件名、空格、全角括号
- **首行**：中文 H1 标题；其下紧跟元信息行 `> 中文名称：xxx`（文档中心导航按此显示，未标注则回退显示文件名）
- **索引**：新建/重命名文档必须同步更新所属分类 `README.md` 与 `docs/README.md`
- 交叉引用用相对链接；改名/移动时全仓 grep 清理旧链接

### 2.3 文档中心（在线查阅）

- 入口：`http://localhost:8080/docs/index.html`（`DocCenterController`，匿名放行，无需登录）
- 侧边栏：卡片式根分组（项目文档 / 项目规则 / AI 技能），手风琴展开、层级缩进、蓝色高亮
- **目录中文映射**：`01-requirements→01-需求`、`02-development→02-开发`、`03-optimization→03-优化`、`04-bugfix→04-bug修复`
- **文档显示名**：后端读取文档首部前 10 行的 `中文名称：` 元信息；搜索同时匹配显示名与路径（中英文文件名均可搜）
- 实现：`ruoyi-admin/.../DocCenterController.java`（目录映射 `DIR_DISPLAY_NAMES`、显示名 `resolveDisplayName()`）+ `ruoyi-admin/src/main/resources/docview/index.html`
- 接口：`/docs/api/tree`、`/docs/api/content?path=...`；根目录探测失败时配 `ruoyi.docPath: <本项目根目录绝对路径>`（按各分支项目实际部署位置填写）

## 3. 纯 AI 新增功能九步强制流程（project-rules §13 摘要）

| 步骤 | 动作 | 产出 |
|------|------|------|
| 1 需求对齐 | 检索记忆与代码防重复；关键决策中断询问 | `01-requirements/<模块>/…-prd.md` |
| 2 方案设计 | 分层/接口/数据模型/异常；SQL 先过兼容校验 | `02-development/<模块>/…-plan|dev.md` |
| 3 任务拆分 | 按可独立编译粒度拆分，明确依赖与验收 | TASK 文档（复杂任务先确认） |
| 4 工程骨架 | 代码进 🟢 模块；SQL 按命名放 `resources/sql/<模块>/` | 目录与脚本骨架 |
| 5 后端实现 | 命名/`@PreAuthorize`/`@Transactional`/分页/文件头 | Controller/Service/Mapper |
| 6 前端实现 | 主前端 `xxx-web`：Vue3 `<script setup lang="ts">` + Element Plus；菜单组件路径与页面一一对应 | `views/<模块>` + `api/<模块>` + `types/api/<模块>` |
| 7 编译自测 | `mvn -pl ruoyi-admin -am compile -DskipTests`；对照 PRD 验收 | 编译通过 + 验收记录 |
| 8 文档同步 | 两级 README 索引、`中文名称` 元信息、缺陷入 04 | 文档索引更新 |
| 9 交付确认 | 变更清单、SQL 手工执行说明、Git 规范提交 | 交付说明 |

**豁免条款速查**（详见规则 §3.6/§3.7）：
- `@PreAuthorize` 可豁免：仅当前登录人自助型接口（身份从 `SecurityUtils` 取、无查他人能力）；写操作与接受任意 ID 的接口**不豁免**
- `@Transactional` 可豁免：单条 INSERT/DELETE 且无关联写、无跨表一致性（如日志 `record()`）

## 4. 强制技能（Skills）

| 技能 | 触发时机 | 位置 |
|------|----------|------|
| `sqlserver-compat-check` | **任何** Mapper XML / Java 内嵌 SQL / 建表脚本的生成、修改、审查（强制，禁跳过） | `.trae/skills/sqlserver-compat-check/SKILL.md` |
| `dev-structure-doc` | 生成/更新项目或模块结构文档 | `.trae/skills/dev-structure-doc/SKILL.md` |
| `skill-creator` | 创建新技能（必须先调用） | 内置技能 |

SQL Server 关键红线：`top N` 代替 `limit`、`getdate()` 代替 `now()/sysdate()`、拼接用 `+`、行锁 `with (updlock, holdlock)`、include 片段防重复 `from`、Oracle 语句带 `FROM DUAL`。

## 5. 常用命令与环境坑（Windows）

```bash
# 后端编译（JAVA_HOME 必须指向 JDK17；系统默认 java 是 1.8，会报「无效的目标发行版: 17」）
$env:JAVA_HOME="<IntelliJ IDEA 安装目录>\jbr"; $env:Path="$env:JAVA_HOME\bin;$env:Path"   # jbr 为 IDEA 自带 JDK17
mvn -pl ruoyi-admin -am compile -DskipTests
mvn clean package -DskipTests

# 前端（主前端 xxx-web，独立仓库，目录与后端仓库平级）
npm run dev            # Vite 启动，端口见 .env 的 VITE_APP_SERVER_PORT，/dev-api 代理到 8080
npm run build:prod

# 前端（旧前端 ruoyi-ui，存量维护）
npm run dev            # 端口 80，/dev-api 代理到 8080
npm run build:prod
```

- 启动：IDEA 运行 `ruoyi-admin` 的 `RuoYiApplication`（或根目录 `ry.bat`），后端 8080
- **已知坑**：Spring Boot 4 用 `spring-boot-starter-webmvc`（非 starter-web）；`ContentCachingRequestWrapper` 仅带参构造器；菜单脚本无幂等保护（重复执行产生重复菜单）；根目录 quartz 重建脚本含 DROP TABLE（勿随意执行）

## 6. 安全与质量红线（规则 §7/§8 摘要）

- 代码/文档/日志/提交信息禁出现数据库口令、密钥、Token；禁返回 `password`/`salt`；禁 `${}` 拼用户输入
- 列表必须分页（`startPage()+getDataTable()`），禁循环查库；大导出走异步
- 新 Java 文件头必带 `@author`/`@date`；方法写中文注释（功能 + 参数）
- Git：`<type>(<scope>): <subject>`；仅 `origin` 可推送；禁提交 `target/`、`.idea/`、口令配置

## 7. 关联入口

- 技术基线：[project-rules.md](project-rules.md)
- 全项目结构：[project-structure.md](../../docs/02-development/common/structure/project-structure.md)
- 文档总索引：[docs/README.md](../../docs/README.md)
- 接口日志示例（回溯补录范式）：[api-log-prd.md](../../docs/01-requirements/common/apilog/api-log-prd.md)、[api-log-dev.md](../../docs/02-development/common/apilog/api-log-dev.md)
