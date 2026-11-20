# 全项目开发结构目录

> 中文名称：全项目结构说明
> 扫描时间：2026-11-17 | 扫描范围：全项目（基于磁盘实际结构，已排除 `target`/`node_modules` 等构建产物）

## 1. 顶层结构

```
<项目根目录>
├── pom.xml                   # Maven 聚合父工程（RuoYi-Vue 3.9.2 / Spring Boot 4 / JDK17）
├── ry.bat / ry.sh            # Windows/Linux 启动脚本
├── bin/                      # 打包与清理脚本（clean/package/run.bat）
├── doc/                      # 若依环境使用手册.docx（遗留文档）
├── docs/                     # 四类归档文档（01 需求 / 02 开发 / 03 优化 / 04 缺陷）
├── sql/                      # 框架初始化 SQL（sqlserver.sql、quartz_sqlserver.sql、datadict_menu.sql）
├── prompts/                  # 提示词说明（README）
├── .trae/                    # AI 工程配置：rules/ 规则、skills/ 技能
├── .github/                  # FUNDING.yml
├── ruoyi-admin/              # 🟡 Web 入口与监控/工具控制器
├── ruoyi-framework/          # 🔴 框架配置（安全、AOP、多数据源）
├── ruoyi-system/             # 🔴 系统管理（用户/角色/菜单/字典）
├── ruoyi-common/             # 🔴 公共工具、注解、枚举、核心基类
├── ruoyi-quartz/             # 🔴 定时任务
├── ruoyi-generator/          # 🔴 代码生成器
├── ruoyi-apilog/             # 🟢 接口日志模块（入站/出站）
├── ruoyi-bizperm/            # 🟢 业务级权限体系模块
└── ruoyi-ui/                 # 🟢 旧前端（Vue 2 + Element UI，存量维护）
```

> 红绿区边界见 `.trae/rules/project-rules.md` §1 模块表；不存在 `crm-web`、`ruoyi-crm`。
>
> **前后端定位（当前最新技术栈）**：后端为本仓库 `xxx-api`；前端为主前端 `xxx-web`（独立仓库、与本仓库平级，Vue 3.5 + TypeScript + Vite + Element Plus + Pinia）。本仓库内的 `ruoyi-ui` 为旧前端（Vue 2），仅存量维护。

## 2. 后端模块结构（关键路径）

```
ruoyi-admin/src/main/
├── java/com/ruoyi/web/
│   ├── controller/
│   │   ├── common/          # 通用控制器（验证码、文件等）
│   │   ├── monitor/         # 系统监控控制器 🔴
│   │   ├── system/          # 系统管理控制器 🔴（含 api/）
│   │   ├── tool/            # 工具控制器（含 DocCenterController 文档中心）
│   │   └── sales/           # Oracle 测试控制器（OracleTestController）
│   └── core/config/         # 模块级配置
└── resources/
    ├── application*.yml     # 启动配置、数据源配置
    ├── docview/             # 文档中心前端页面（index.html、view.html）
    ├── i18n/  mybatis/  static/  META-INF/
    └── static/docs/         # 文档中心静态副本

ruoyi-apilog/src/main/       # 接口日志模块（🟢）
├── java/com/ruoyi/apilog/
│   ├── controller/          # 日志查询控制器（inbound/outbound）
│   ├── domain/              # SysInboundLog / SysOutboundLog 实体
│   ├── mapper/              # Mapper 接口
│   ├── service/ + impl/     # 日志记录与查询服务（异步落库）
│   ├── utils/               # ApiLogUtils、ExternalApiClient 出站客户端
│   └── web/                 # ApiInboundLogFilter 入站全局过滤器
└── resources/
    ├── mapper/apilog/       # SysInboundLogMapper.xml、SysOutboundLogMapper.xml
    └── sql/apilog/          # sys_interface_log.sql、sys_interface_log_menu.sql

ruoyi-bizperm/src/main/      # 业务级权限模块（🟢）
├── java/com/ruoyi/bizperm/
│   ├── controller/  domain/{bo,vo,enums}  mapper/  service/{impl}
└── resources/
    ├── mapper/bizperm/      # BizPermPolicyMapper.xml
    └── sql/bizperm/         # bizperm_init_all.sql、sys_biz_perm_policy.sql、
                             # sys_biz_perm_scope.sql、sys_menu_bizperm.sql、sys_dict_bizperm.sql

ruoyi-{framework,system,common,quartz,generator}/src/main/java/com/ruoyi/<模块名>/
└── 框架红区，禁止新增业务代码（存量豁免见 project-rules §3.1）
```

## 3. 前端结构

### 3.1 主前端 xxx-web（Vue 3.5 + TypeScript，独立仓库）

> 独立仓库、与本仓库（`xxx-api`）平级；为当前使用的最新前端技术栈（Vue 3.5 + TypeScript + Vite + Element Plus + Pinia）。

```
xxx-web/
├── public/                  # 静态资源
├── vite.config.ts           # Vite 构建配置（/dev-api 代理到后端 8080）
└── src/
    ├── main.ts  App.vue     # 入口
    ├── permission.ts        # 路由守卫（登录鉴权）
    ├── settings.ts          # 系统配置
    ├── api/                 # ⚠️ 框架接口：monitor/ system/ tool/（业务接口新增 api/<module>/<feature>.ts）
    ├── types/api/           # ⚠️ 接口类型定义（TS），含 index.ts 聚合导出（业务类型新增 types/api/<module>.ts）
    ├── views/               # 🟢 页面：dashboard/ error/ monitor/ system/ tool/ bizperm/ apilog/…（业务页面新增 views/<module>/<feature>/index.vue）
    ├── components/          # 🔴 公共组件（Pagination、FileUpload、DictTag、TreePanel、RemoteSelect 等）
    ├── directive/           # 🔴 v-hasPermi / v-hasRole
    ├── layout/  router/     # 🔴 布局、动态路由
    ├── plugins/  store/     # 🔴 $modal 等插件、Pinia（store/modules/*.ts）
    └── utils/               # 🔴 request.ts、auth.ts、dict.ts、ruoyi.ts
```

### 3.2 旧前端 ruoyi-ui（Vue 2 + JavaScript，存量维护）

> 本仓库内旧前端，仅存量维护，不再新增业务功能；技术栈为 Vue 2.6 + Element UI + Options API。

```
ruoyi-ui/
├── public/                  # 静态资源（html、styles/theme-chalk）
├── build/  bin/             # 构建配置与脚本
└── src/
    ├── main.js  App.vue     # 入口
    ├── permission.js        # 路由守卫（登录鉴权）
    ├── settings.js          # 系统配置
    ├── api/  views/         # 业务接口与页面（目录约定同主前端，JS + Options API）
    ├── components/  directive/  layout/  router/  plugins/  store/  utils/  assets/
```

## 4. 文档与配置结构

```
docs/
├── README.md                # 全局文档索引（含文档中心入口）
├── 01-requirements/         # 01-需求：_template-prd.md + common/<模块>/…-prd.md
│   └── common/              # 通用能力文档（apilog/ bizperm/ datasource/ external-api/ mq/ number-rule/）
├── 02-development/          # 02-开发：_template-dev.md + common/<模块>/…-plan|dev|tasklist|checklist.md
│   └── common/              # 通用能力文档（apilog/ bizperm/ datasource/ external-api/ mq/ number-rule/ structure/）
├── 03-optimization/         # 03-优化：_template-optimize.md（暂无正式文档）
└── 04-bugfix/               # 04-bug修复：_template-bugfix.md（暂无正式文档）

.trae/
├── rules.md                 # 全局文档规则
├── rules/project-rules.md   # 技术基线规则（§0~§13，含纯 AI 开发 9 步流程）
├── rules/ai-workflow.md     # AI 开发协作指南（执行手册，原 docs/02-development/ai-dev/）
└── skills/
    ├── sqlserver-compat-check/  # SQL Server 兼容性检查（强制触发）
    └── dev-structure-doc/       # 开发结构目录文档生成
```

## 5. 目录职责表

| 目录 | 职责 | 改动边界 |
|------|------|----------|
| `ruoyi-admin/` | Web 入口、监控/工具控制器、文档中心 | 🟡 `controller/system`、`monitor` 禁止改 |
| `ruoyi-framework/` | 安全、AOP、多数据源装配 | 🔴 禁止修改 |
| `ruoyi-system/` | 用户/角色/菜单/字典等系统管理 | 🔴 禁改（存量豁免仅 Bug 修复） |
| `ruoyi-common/` | 工具类、注解、枚举、核心基类 | 🔴 禁止修改 |
| `ruoyi-quartz/` | 定时任务 | 🔴 禁止修改 |
| `ruoyi-generator/` | 代码生成器 | 🔴 禁止修改 |
| `ruoyi-apilog/` | 入站过滤器、出站客户端、日志落库与查询 | 🟢 可自由修改 |
| `ruoyi-bizperm/` | 业务级权限策略、范围、权限树、可见人员 | 🟢 可自由修改 |
| `xxx-web/`（独立仓库） | 主前端（Vue 3.5 + TS + Element Plus），当前最新技术栈 | 🟢 仅 `views/<模块>`、`api/<模块>`、`types/api/<模块>` |
| `ruoyi-ui/` | 旧前端（Vue 2 + Element UI），存量维护 | 🟢 仅 `views/<模块>`、`api/<模块>` |
| `docs/` | 四类归档文档 + 索引 | 🟢 按 §6 文档规范 |
| `sql/` | 框架初始化 SQL、菜单/字典基础数据 | 🟡 存量脚本不改名，新增按规范 |
| `.trae/` | 技术基线规则与 AI 技能 | 🟡 改规则需用户确认 |

## 6. 关键文件说明

| 文件 | 说明 |
|------|------|
| `pom.xml` | 聚合父工程，定义模块与依赖版本 |
| `ruoyi-admin/.../RuoYiApplication` | 启动入口，端口 8080 |
| `ruoyi-admin/.../tool/DocCenterController` | 文档中心接口（`/docs/api/tree`、`/docs/api/content`），匿名放行 |
| `ruoyi-admin/src/main/resources/docview/index.html` | 文档中心侧边栏（目录中文映射、中文名称显示） |
| `ruoyi-admin/src/main/resources/application.yml` | 端口、文档路径（`ruoyi.docPath`）等配置 |
| `ruoyi-apilog/.../utils/ExternalApiClient` | 统一出站 HTTP 客户端，自动记录 `sys_outbound_log` |
| `ruoyi-apilog/.../web/ApiInboundLogFilter` | 入站全局过滤器，异步写 `sys_inbound_log` |
| `ruoyi-apilog/.../resources/sql/apilog/sys_interface_log_menu.sql` | 入站/出站日志菜单数据（执行前注意无幂等保护） |
| `sql/sqlserver.sql` | 框架初始化脚本（含 `sys_menu` 等基础数据） |
| `.trae/rules/project-rules.md` | 技术基线规则（优先级与红绿区定义） |
| `xxx-web/src/utils/request.ts` | 主前端 axios 封装（`/dev-api` 代理、Token 注入） |
| `ruoyi-ui/src/utils/request.js` | 旧前端 axios 封装（`/dev-api` 代理、Token 注入，存量维护） |

## 7. 与规则的对应关系

- 模块红绿区：project-rules §1 模块表
- 后端包结构：project-rules §3.1（业务模块统一 controller/domain/mapper/service 分层）
- 前端目录边界：project-rules §4.1（仅 `views/<模块>`、`api/<模块>` 可新增业务代码；主前端 `xxx-web` 另含 `types/api/<模块>`）
- 文档归档与命名：project-rules §6
- 纯 AI 新增模块 9 步流程：project-rules §13
