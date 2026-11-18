# 开发文档 - 系统国际化（i18n）

> 中文名称：系统国际化功能开发文档

> 作者：AI 回溯补录（基于 `ruoyi-framework` / `ruoyi-common` / `ruoyi-admin` 代码梳理）| 日期：2026-11-18 | 关联需求：[系统国际化功能需求文档](../../../01-requirements/common/i18n/i18n-prd.md)
>
> ⚠️ 本文档为事后回溯：功能已实现，本文描述以现有代码为准。日常使用（加 key、调用、前端配合）请看 [使用指南](i18n-usage.md)。

## 1. 技术方案概述

- 方案简述：基于 Spring `MessageSource` 标准国际化体系，以**请求头解析器**替代 Session 方案适配无状态 JWT 架构——自定义 `HeaderLocaleResolver` 每次请求从 `X-Lang` 头解析语言写入 `LocaleContextHolder`，业务代码经静态工具 `MessageUtils` 按 key 取文案；资源文件中英双份，key 一一对应。

## 2. 架构 / 模块设计

- 涉及模块与职责（框架红区只读，参考 project-rules §2）：

| 模块 | 类 / 文件 | 职责 |
|------|-----------|------|
| `ruoyi-admin` | `src/main/resources/i18n/messages.properties` | 中文资源文件（默认语言，205 key） |
| `ruoyi-admin` | `src/main/resources/i18n/messages_en.properties` | 英文资源文件（205 key，与中文对齐） |
| `ruoyi-admin` | `src/main/resources/application.yml` | `spring.messages.basename: i18n/messages` 装配资源 |
| `ruoyi-framework` | `config/I18nConfig` | 注册 `LocaleResolver` Bean（`HeaderLocaleResolver`） |
| `ruoyi-framework` | `config/HeaderLocaleResolver` | 请求头语言解析（`X-Lang` → `Accept-Language` → 默认） |
| `ruoyi-common` | `utils/MessageUtils` | 静态消息获取入口，委托 Spring `MessageSource` |
| `ruoyi-common` | `constant/Constants.DEFAULT_LOCALE` | 默认语言常量 `Locale.SIMPLIFIED_CHINESE` |
| `ruoyi-common` | `core/domain/entity/SysMenu`（`menuNameEn` 字段） | 菜单实体含英文名，供 `ruoyi-system` 路由构建读取 |
| `ruoyi-system` | `mapper/system/SysMenuMapper.xml` | `menu_name_en` 全链路映射（resultMap / selectVo / 树查询 / insert / update） |
| `ruoyi-system` | `service/impl/SysMenuServiceImpl` + `domain/vo/MetaVo` | 路由构建时 `getMenuTitleEn()` 回退逻辑 + `meta.titleEn` 双语下发 |

- 依赖关系：`ruoyi-framework` → `ruoyi-common`（单向）；业务模块（`ruoyi-system`、`ruoyi-apilog` 等）只依赖 `ruoyi-common` 的 `MessageUtils`，与框架配置解耦。
- 调用链路：

```
前端请求（X-Lang: en）
  → HeaderLocaleResolver.resolveLocaleContext()            # 解析并写入 LocaleContextHolder
  → Controller / Service 校验失败
  → MessageUtils.message("user.not.exists")                # 静态入口
  → SpringUtils.getBean(MessageSource.class)                # 取容器内 MessageSource
  → getMessage(code, args, LocaleContextHolder.getLocale()) # 按 Locale 取 i18n/messages[_en].properties
  → 返回英文文案 → ServiceException / AjaxResult → 前端展示
```

## 3. 接口设计

无新增 REST 接口。国际化为横切能力，通过以下既有出口生效：

| 出口 | 示例代码位置 | 文案来源 |
|------|--------------|----------|
| 全局异常处理 | `GlobalExceptionHandler`（无权限 403、缺路径变量、参数类型不匹配、演示模式等） | `common.*`、`no.*` 系列 key |
| 认证与用户链路 | `SysUserServiceImpl`（登录校验、密码重试锁定、账号封禁） | `user.*`、`login.blocked` 系列 |
| 业务增删改校验 | 各 `SysXxxServiceImpl`（用户/角色/菜单/岗位/字典/参数重名校验） | `user.*`、`menu.*`、`role.*` 等 |
| 接口响应包装 | `AjaxResult`（统一 code/msg） | 调用方传入的已翻译文案 |
| 限流切面 | `RateLimiterAspect` | `common.rate.limit` / `common.rate.limit.server` |
| Excel 导入导出 | `ExcelUtil`（文件名、注解文案相关提示） | `common.*`、`upload.*` 系列 |
| 动态路由（菜单双语） | `SysLoginController#getRouters` → `SysMenuServiceImpl`（`MetaVo.titleEn`） | `sys_menu.menu_name_en`，空值回退 `menu_name` |

## 4. 数据模型

提示文案无数据库表，数据载体为两个 properties 资源文件；菜单名称双语另有一列 DB 字段：

**（1）资源文件**

| 项 | 值 |
|----|----|
| 文件位置 | `ruoyi-admin/src/main/resources/i18n/` |
| 基础名 | `messages`（中文默认）/ `messages_en`（英文） |
| 键数量 | 各 205 个，集合完全一致（比对脚本验证 `KEYS FULLY MATCHED`） |
| 键命名 | `<模块>.<场景>[.<细分>`，如 `common.rate.limit`、`user.add.username.exists`、`menu.edit.parent.self` |
| 占位符 | `{0}`、`{1}` 按传参顺序填充，如 `length.not.valid=长度必须在{min}到{max}个字符之间` |
| 编码 | UTF-8（IDEA properties 文件需确认非 ISO-8859-1 转义存储，中文直接可读） |
| 加载配置 | `application.yml` → `spring.messages.basename: i18n/messages` |

key 分组概览：错误消息、文件上传、权限（`no.create/update/delete/export/view.permission`）、公共操作（`common.*`）、菜单管理（`menu.*`）、用户管理（`user.*`）及角色/岗位/字典/参数等系统模块。

**（2）菜单英文名列（sys_menu.menu_name_en）**

| 项 | 值 |
|----|----|
| 表 / 列 | `sys_menu.menu_name_en`，`nvarchar(100)` 允许为空，注释「菜单名称（英文）」 |
| 全量脚本 | `sql/sqlserver.sql` 已含列定义 + 系统菜单英文初始数据（新库一步到位） |
| 存量升级 | `sql/menu_name_en_backfill.sql`（幂等：`sys.columns` 判存在才加列；补数据只更新英文名为空的记录；GO 分批规避 MSSQL 编译期列校验；含回滚语句） |
| 菜单管理 | 新增/编辑菜单时维护英文名（`SysMenuMapper.xml` insert / update 条件写入） |

## 5. 关键实现要点

### 5.1 HeaderLocaleResolver（核心解析器）

- 继承 `AbstractLocaleContextResolver`，注册于 `I18nConfig#localeResolver`（Bean 名 `localeResolver` 即被 Spring MVC 自动启用）。
- 三级回退链：

```
1. X-Lang 头        parseLocale("zh-cn"/"zh_CN"/"zh"/"en"/"en-US"…)  命中即用
2. Accept-Language  request.getLocale() 且语言为 zh/en               浏览器默认头
3. 默认语言          Constants.DEFAULT_LOCALE（SIMPLIFIED_CHINESE）  兜底
```

- 归并规则：`zh*` → `Locale("zh","CN")`，`en*` → `Locale("en")`，其余返回 null 视为不支持。
- `setLocaleContext()` 抛 `UnsupportedOperationException`：无状态架构不支持运行期改写 Locale，语言由前端每次请求决定。

### 5.2 为什么是 X-Lang 而不是 Accept-Language

- fetch 规范将 `Accept-Language` 列为**保留头**，浏览器禁止 JavaScript 覆盖；前端语言切换必须走自定义头。
- 同时保留 `Accept-Language` 作为第二优先级，兼容不传 `X-Lang` 的调用方（如 Postman、第三方直连）。

### 5.3 MessageUtils（统一入口）

- 静态方法 `message(String code, Object... args)`：`SpringUtils.getBean(MessageSource.class)` 取容器 Bean，以 `LocaleContextHolder.getLocale()` 为当前语言，`getMessage(code, args, locale)` 解析。
- 不缓存 MessageSource 引用，每次从 `SpringUtils` 取——与项目其他静态工具（`SysNoticeService` 桥接等）一致，规避容器刷新期的陈旧引用。
- key 缺失时 Spring 抛 `NoSuchMessageException`：属开发期错误，必须在联调前补齐对应语言 key。

### 5.4 与无状态 JWT 架构的适配

- 不使用 `LocaleChangeInterceptor`（依赖 Session 的 `HttpSessionLocaleResolver`，与 `STATELESS` 冲突）。
- 语言不落库、不落 Session，完全由请求头驱动；同一用户两次请求可分别用不同语言，互不串扰。

### 5.5 新模块接入约定（如 ruoyi-mq / ruoyi-apilog）

- 提示文案一律 `MessageUtils.message("mq.xxx.key", args)`，key 双文件同步维护；
- 禁止 `throw new ServiceException("硬编码中文")`（现有调用方存在少量历史硬编码，新代码零容忍）；
- 详见[使用指南](i18n-usage.md)第 2 节。

### 5.6 菜单英文名回退（getMenuTitleEn）

- `SysMenuServiceImpl#getMenuTitleEn(SysMenu)`：`menuNameEn` 非空取英文名，否则回退 `menuName`（中文），保证英文界面不出现空白标题。
- 路由构建 `buildMenus` 时 `MetaVo` 同时写入 `title`（中文原值）与 `titleEn`（回退后的英文值），语言选择交给前端按当前语言取用，后端不感知语言。
- 菜单名走 DB 双列而非 properties：菜单是系统级元数据，需菜单管理界面可视化维护 + 每库独立扩展（业务菜单），与提示文案的 key 体系解耦。

## 6. 异常与边界处理

| 场景 | 行为 | 定性 |
|------|------|------|
| `X-Lang` 值不支持（如 `ja`） | parseLocale 返回 null → 走 Accept-Language → 走默认中文 | 符合预期回退 |
| `X-Lang` 值格式多样（`zh_CN`、`en-US`） | 统一 toLowerCase、`_` 转 `-` 后前缀匹配 | 符合预期归并 |
| key 在中文存在、英文缺失 | Spring 按 Locale 解析失败抛 `NoSuchMessageException` | 开发错误，双文件 key 必须对齐 |
| 占位符与传参数量不符 | 文案中残留 `{0}` 原样或参数错位 | 开发错误，联调期暴露 |
| 双语言并发请求 | Locale 绑定请求线程（LocaleContextHolder 线程隔离），互不影响 | 符合预期 |
| 异步线程内取文案（线程池/`@Async`） | `LocaleContextHolder` 默认不传递，异步内 MessageUtils 会拿默认语言 | 已知边界，见使用指南 FAQ |
| 菜单英文名为空（自定义菜单未补录） | `titleEn` 回退中文 `menu_name`，英文界面显示中文 | 符合预期回退 |
| `menu_name_en_backfill.sql` 重复执行 | 加列判存在跳过；补数据只更新空值记录，不覆盖人工已填英文名 | 幂等设计 |

## 7. 测试要点

- [ ] 正常流程：默认中文、`X-Lang: en` 英文、`X-Lang: zh-cn` 中文
- [ ] 回退链：仅 Accept-Language 英文 → 英文；两者冲突 → X-Lang 优先
- [ ] 边界条件：`X-Lang` 空串 / 空格 / 不支持语言 / 多种书写形式（`zh_CN`、`en-US`）
- [ ] 异常情况：key 单边缺失（英文文件漏加）时启动后调用即暴露；占位符参数数量不匹配
- [ ] 并发隔离：两线程分别以中/英 Locale 同时请求，响应各自正确
- [ ] 菜单双语：`getRouters` 的 `meta` 同时含 `title` / `titleEn`；`menu_name_en` 为空的菜单 `titleEn` 等于中文；补数据脚本重复执行无副作用
- [ ] 覆盖抽查：`common.no.permission.contact.admin`、`user.password.retry.limit.count`、`menu.edit.parent.self` 等代表 key 中英值均非 key 原文

## 8. 关联文档

- 需求文档：[系统国际化功能需求文档](../../../01-requirements/common/i18n/i18n-prd.md)
- 使用文档：[系统国际化使用指南](i18n-usage.md)（加 key / 调用 / 前端配合 / FAQ）
- 菜单英文补数据脚本：[sql/README.md](../../../../sql/README.md)（存量库升级脚本索引）
- AI 开发协作指南：[AI 开发协作指南](../../ai-dev/ai-workflow.md)（模块分层、静态桥接模式与本项目一致）
