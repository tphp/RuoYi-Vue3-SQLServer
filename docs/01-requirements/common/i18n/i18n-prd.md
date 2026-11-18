# 需求文档（PRD） - 系统国际化（i18n）

> 中文名称：系统国际化功能需求文档

> 作者：AI 回溯补录（基于 `ruoyi-framework` / `ruoyi-common` / `ruoyi-admin` 代码梳理）| 日期：2026-11-18 | 状态：回溯补录（待业务确认）
>
> ⚠️ 本文档为事后回溯：功能已实现（后端框架级），需求描述以现有代码行为为准，待与业务方确认原始意图。

## 1. 需求背景

- 问题 / 机会描述：系统存在中/英文用户，接口返回的提示文案（登录失败、权限不足、参数校验失败、操作结果等）若在代码中硬编码中文，英文用户无法理解；且文案散落各处无法统一维护。
- 本系统为无状态 JWT 架构（`SessionCreationPolicy.STATELESS`），传统基于 Session 的语言切换方案不适用，需要与现有认证体系兼容的语言传递机制。

## 2. 需求目标

- 业务目标：系统级提示文案支持中文（简体）/ 英文双语，随用户请求语言动态返回，文案统一收敛到资源文件维护。
- 量化指标（如有）：
  - 中英文资源文件键（key）100% 对齐，不允许出现单边缺失；
  - 框架级统一入口（登录、鉴权、参数校验、全局异常）提示全部走国际化文案。

## 3. 需求范围

### 包含

- [x] 中英文资源文件维护（`i18n/messages.properties` + `i18n/messages_en.properties`，各 205 个 key，覆盖错误消息、上传、权限、公共操作、菜单/用户/角色/岗位/字典等系统模块）
- [x] 请求级语言解析：优先 `X-Lang` 自定义请求头，回退 `Accept-Language`，最终回退默认语言（简体中文）
- [x] 消息获取统一工具 `MessageUtils.message(code, args)`（委托 Spring `MessageSource`）
- [x] 全局异常处理、权限拦截、限流等框架级提示文案国际化
- [x] 各业务模块（用户/角色/菜单/岗位/字典/参数/编号规则等）服务层校验提示文案国际化
- [x] 占位符参数化文案（如 `密码输入错误{0}次`、`长度必须在{0}到{1}个字符之间`）
- [x] 菜单名称中英双语：`sys_menu.menu_name_en` 英文名列存储，路由接口同时下发中文 `title` 与英文 `titleEn`，英文名未配置时回退中文

### 不包含（Out of Scope）

- [ ] 前端页面静态文案（按钮、表格标题、表单标签、提示语等）的翻译——前端仓库（`xxx-web`）i18n 资源职责，本仓库仅提供 `X-Lang` 头约定与菜单名双语下发
- [ ] 除菜单名称外的业务数据多语言（如字典项 label、部门/岗位名称等存库字段）
- [ ] 第三方/外部系统交互报文的翻译
- [ ] 除简体中文、英文外的其他语种（如繁体、日文等）
- [ ] 用户个人语言偏好的持久化存储（无 Session，语言完全由前端每次请求决定）

## 4. 用户与角色

| 角色 | 使用场景 | 核心诉求 |
|------|----------|----------|
| 中文用户 | 正常操作系统 | 默认即中文，无感知 |
| 英文用户 | 切换界面语言为英文 | 后端提示、报错同步变为英文 |
| 业务后端开发 | 新增功能模块时输出提示文案 | 有统一的 key 命名与文案维护方式，不硬编码 |
| 前端开发 | 实现语言切换功能 | 有明确的语言传递协议（请求头），无需改造登录态 |
| 运维/排障人员 | 排查文案显示异常 | 文案集中在资源文件，可快速检索与修正 |

## 5. 功能需求

### 功能点1：语言标识传递与解析

- 描述：前端每次请求通过自定义 `X-Lang` 请求头携带当前语言（`zh-cn` / `en`），后端按三级回退链解析本次请求的 Locale。
- 交互 / 流程：
  ```
  前端请求（带 X-Lang 头）
      → HeaderLocaleResolver 解析 X-Lang（支持 zh-cn / zh_CN / zh / en / en-US 等形式）
      → 未携带时回退读取浏览器 Accept-Language 头
      → 仍无法识别时回退默认语言（简体中文）
      → 解析结果写入 LocaleContextHolder，本次请求内所有 MessageUtils 调用共用
  ```
- 约束条件：
  - 必须用自定义 `X-Lang` 头而非 `Accept-Language` 承载语言切换：浏览器禁止 JavaScript 覆盖 `Accept-Language`（fetch 规范保留头），前端无法主动设置该头；
  - 不使用 Session 存储语言，不使用 `LocaleChangeInterceptor`（该拦截器依赖 Session）；
  - 仅支持 `zh*` → 简体中文、`en*` → 英文，其余语言标识视为不支持，走回退链；
  - 不提供通过接口修改 Locale 的能力（`setLocaleContext` 明确抛出 `UnsupportedOperationException`）。

### 功能点2：资源文件统一维护

- 描述：提示文案统一收敛在 `ruoyi-admin/src/main/resources/i18n/` 下两个资源文件：`messages.properties`（中文，默认）与 `messages_en.properties`（英文）。
- 交互 / 流程：开发期维护两文件 → 启动时由 Spring `MessageSource` 加载（`spring.messages.basename: i18n/messages`）→ 运行时按 Locale 取值。
- 约束条件：
  - 两文件 key 必须一一对应，新增文案必须双文件同步；
  - key 命名按 `<模块>.<场景>` 分段（如 `user.not.exists`、`menu.add.name.exists`、`common.rate.limit`）；
  - 支持占位符 `{0}`、`{1}` 按参数顺序填充；
  - 文件编码 UTF-8。

### 功能点3：统一消息获取入口

- 描述：提供静态工具 `MessageUtils.message(code, args)`，任何层次（Controller / Service / 工具类）均可调用，内部委托 Spring `MessageSource` 并自动携带当前请求 Locale。
- 交互 / 流程：调用 `MessageUtils.message("user.not.exists")` → 取 `MessageSource` Bean → 按 `LocaleContextHolder` 当前 Locale 解析 → 返回对应语言文案。
- 约束条件：
  - key 不存在时 Spring 抛 `NoSuchMessageException`（视为开发错误，必须在上线前补齐 key）；
  - 占位符数量与传参一致，否则出现文案参数错乱。

### 功能点4：框架级提示国际化覆盖

- 描述：框架层（无需业务代码参与）的提示文案全部国际化，包括：
  - 全局异常处理：请求路径缺少路径变量、参数类型不匹配、无权限访问（403）、演示模式拦截等；
  - 认证链路：登录成功/失败、验证码错误/失效、账号锁定、密码重试超限、IP 黑名单等；
  - 权限注解拦截：`@PreAuthorize` 无权限时返回 `common.no.permission.contact.admin`；
  - 接口限流：`common.rate.limit` / `common.rate.limit.server`。
- 约束条件：框架层不得出现硬编码中文提示。

### 功能点5：业务模块提示国际化覆盖

- 描述：各业务模块服务层（用户、角色、菜单、岗位、字典、参数、部门、编号规则等）的数据校验与操作结果提示，统一通过 `MessageUtils.message()` 输出。
- 交互 / 流程：Service 校验失败 → `throw new ServiceException(MessageUtils.message("user.add.username.exists", username))` → 前端展示对应语言文案。
- 约束条件：新增业务模块（如 `ruoyi-mq`、`ruoyi-apilog`）的提示文案必须遵循同一模式，禁止在代码中硬编码用户可见文案。

### 功能点6：菜单名称中英双语

- 描述：菜单名称采用数据库双列存储——`sys_menu.menu_name`（中文，原有）+ `sys_menu.menu_name_en`（英文，`nvarchar(100)` 允许为空）。菜单管理界面维护英文名；动态路由接口对每个菜单同时下发 `meta.title`（中文）与 `meta.titleEn`（英文），前端按当前语言取用。
- 交互 / 流程：
  ```
  存量库升级：执行 sql/menu_name_en_backfill.sql（幂等：加列判断存在性，补数据只更新英文名为空的记录）
  日常维护：菜单管理新增/编辑时填写英文名 → getRouters 路由 meta 同时下发 title 与 titleEn → 前端按语言展示
  ```
- 约束条件：
  - 英文名未配置（空）时 `titleEn` 回退为中文名，保证英文界面不出现空白菜单；
  - 新库用 `sql/sqlserver.sql` 全量重建已含该列及系统菜单英文初始数据，升级脚本自动跳过加列；
  - 自定义/业务菜单默认英文为空，需在菜单管理中逐个补录；
  - 补数据脚本覆盖范围：系统目录/菜单/按钮（1~1060）及编号规则（10001~10006）、人员选择（1061）等既有菜单。

## 6. 验收标准

- [ ] **中文默认**：不带任何语言头的请求，所有提示返回中文
- [ ] **英文切换**：请求带 `X-Lang: en`，登录失败返回 `User does not exist / password is wrong`（对应英文文案）
- [ ] **X-Lang 优先**：`X-Lang: en` 且 `Accept-Language: zh-CN` 时返回英文（X-Lang 优先级最高）
- [ ] **Accept-Language 回退**：不带 `X-Lang`、仅 `Accept-Language: en-US` 的请求返回英文
- [ ] **不支持语言回退**：`X-Lang: ja` 视为不支持，回退默认中文
- [ ] **多形式兼容**：`X-Lang` 取 `zh_CN`、`zh`、`en-US` 均能正确解析
- [ ] **占位符填充**：密码重试提示 `密码输入错误{0}次` 参数正确填充次数
- [ ] **无状态兼容**：连续两次请求分别带 `X-Lang: zh-cn` / `X-Lang: en`，各自返回对应语言，互不串扰（不依赖 Session）
- [ ] **中英 key 对齐**：`messages.properties` 与 `messages_en.properties` 键集合完全一致（当前各 205 个）
- [ ] **框架级覆盖**：403 无权限、参数类型不匹配、验证码错误等框架提示均随语言切换
- [ ] **菜单双语下发**：`getRouters` 返回的菜单 `meta` 同时包含 `title`（中文）与 `titleEn`（英文）
- [ ] **菜单英文名回退**：未配置英文名的菜单（`menu_name_en` 为空），`titleEn` 等于中文 `title`，英文界面不出现空白
- [ ] **存量库升级幂等**：`menu_name_en_backfill.sql` 重复执行不报错、不覆盖已填英文名；新库全量重建后执行自动跳过加列

## 7. 已确认决策（回溯）

| 决策点 | 结论 | 说明 |
|--------|------|------|
| 语言承载方式 | 自定义 `X-Lang` 请求头 | 浏览器禁止 JS 覆盖 `Accept-Language`（fetch 保留头），且本系统无 Session，每次请求显式携带 |
| 默认语言 | 简体中文（`Locale.SIMPLIFIED_CHINESE`） | 未识别到有效语言标识时兜底 |
| 语言范围 | 仅中/英 | `zh*` 归并简中、`en*` 归并英文，其余不支持 |
| 文案存储 | 单套 properties 双文件 | 中文主文件（默认）+ 英文文件，不引入数据库存储 |
| 菜单名称双语 | `sys_menu.menu_name_en` 列 + 路由 meta 双 title 下发，空值回退中文 | 菜单名属系统级元数据走 DB 双列；提示文案走 properties；存量库用幂等补数据脚本升级（`sql/menu_name_en_backfill.sql`） |
| 修改语言接口 | 不提供 | `HeaderLocaleResolver.setLocaleContext` 抛 `UnsupportedOperationException`，语言由前端每次请求决定 |

## 8. 疑问与待确认

- [x] ~~是否需要持久化用户语言偏好（下次登录记住语言）~~——当前设计不持久化，由前端本地存储语言并在每次请求携带；若未来需要"记住偏好"，可在用户表加字段后由前端读取初始值，不影响本机制
- [ ] 英文文案质量是否需专业校对（当前英文文件为系统预置文案，未见业务方审校记录）

## 9. 关联文档

- 开发文档：[系统国际化开发文档](../../../02-development/common/i18n/i18n-dev.md)
- 使用文档：[系统国际化使用指南](../../../02-development/common/i18n/i18n-usage.md)
- 菜单英文补数据脚本：[sql/README.md](../../../../sql/README.md)（存量库升级脚本索引）
- 全项目结构说明：[全项目结构说明](../../../02-development/common/structure/project-structure.md)（含 `ruoyi-framework` / `ruoyi-common` 分层）
