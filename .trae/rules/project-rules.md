# 若依（RuoYi）二次开发项目规则（通用版）

> 中文名称：若依二次开发项目规则

> **项目根目录**: 当前仓库根目录
> **规则位置**: `.trae/rules/`（`rules.md` 为全局文档规则，本文件为技术基线）
> **规则版本**: v2.1（2026-11-18 双前端修订：新增主前端 `D:\ebs-web`（Vue3+TS），`ruoyi-ui` 改为并行维护，修订 §1/§2/§4；v2.0 为 2026-11-17 按实际代码库校正）
> **废弃声明**: v1.0 中出现的 `ruoyi-crm`、`crm-api/`、`crm-web/`、「ruoyi-ui 已作废」等描述均与当前仓库不符，**已作废，不得再作为路径依据**。

---

## 0. 规则体系定位

1. 本文件是项目【技术基线 Rules】，所有业务 Prompt、Skill 流程必须继承，禁止重复定义技术规范。
2. 优先级：**人工明确指令 > `.trae/rules.md`（全局文档规则） > 本技术基线 > `docs/` 既有文档约定 > 业务 Prompt > AI 自主优化**。
3. AI 不得突破本文件约束；确需突破时，必须先停止操作并向用户报告，获得明确指令后再执行。
4. 版本、模块、目录均以仓库实际情况为准；本文件与代码不一致时，**以代码为准并同步修正本文件**。

---

## 1. 项目概述

基于 **RuoYi-Vue 3.9.2** 的企业级管理系统，前后端分离。

| 模块 | 职责 | AI 改动边界 |
|------|------|-------------|
| `ruoyi-admin` | Web 入口、系统/监控/工具控制器（含 `DocCenterController`）、`sales` 下 Oracle 测试控制器 | 🟡 新增业务控制器需确认，`controller/system`、`controller/monitor` 禁止改 |
| `ruoyi-framework` | 框架配置、安全、AOP、多数据源装配（`DruidConfig`） | 🔴 禁止修改 |
| `ruoyi-system` | 系统管理（用户/角色/菜单/字典等） | 🔴 禁止修改 |
| `ruoyi-common` | 公共工具、注解、枚举、核心基类 | 🔴 禁止修改 |
| `ruoyi-quartz` | 定时任务 | 🔴 禁止修改 |
| `ruoyi-generator` | 代码生成器 | 🔴 禁止修改 |
| `ruoyi-apilog` | 接口日志：入站日志过滤器、出站接口客户端、日志落库、日志查询 | 🟢 可自由修改 |
| `ruoyi-bizperm` | 业务级权限体系（策略、范围、权限树、可见人员） | 🟢 可自由修改 |
| `ebs-web`（`D:\ebs-web`，独立仓库） | **主前端**（Vue 3 + TypeScript + Vite + Element Plus），含全部业务页面（bizperm/apilog/apiKey/numberRule/datadict 等），代理指向本后端 8080 | 🟢 `src/views/<模块>`、`src/api/<模块>`、`src/types/api/<模块>` 可改；其余目录见 §4 |
| `ruoyi-ui` | **旧前端（并行维护）**（Vue 2 + Element UI），仅框架页面，业务页面落后于主前端 | 🟢 `src/views/<模块>`、`src/api/<模块>` 可改；其余目录见 §4 |

> ⚠️ **双前端并行维护**：主前端 `D:\ebs-web`（Vue3+TS），旧前端 `ruoyi-ui`（Vue2），**同一业务功能两端均需实现**（分工与规范见 §4）。**不存在 `crm-web`**，禁止引用或新建 `crm-web`。

---

## 2. 技术栈（以 `pom.xml` / `package.json` 为准）

### 2.1 后端

| 层级 | 技术 | 版本 |
|------|------|------|
| 基础框架 | RuoYi-Vue | 3.9.2 |
| 后端框架 | Spring Boot | 4.0.6 |
| Java | JDK | 17 |
| ORM | MyBatis | 4.0.1（禁用 JPA） |
| 分页 | PageHelper | 4.1.0（`helperDialect: sqlserver`） |
| JSON | FastJSON2 | 2.0.62（禁混用 Jackson/Gson） |
| 权限 | Spring Security + JWT | - |
| 连接池 | Druid | 1.2.28 |
| 主数据库 | SQL Server | 主库（库名见 `application-druid.yml`） |
| 副数据库 | Oracle | 副库 / 外部系统数据源（按需启用） |

### 2.2 前端（双前端并行，规范分列）

**主前端 `D:\ebs-web`（Vue 3 + TypeScript，新业务默认落此端）**

| 层级 | 技术 | 版本 |
|------|------|------|
| 框架 | Vue | 3.5.26（`<script setup>` + Composition API） |
| 语言 | TypeScript | 5.6.3（业务代码必须带类型定义，`src/types/api/`） |
| UI 库 | Element Plus | 2.13.1（禁止引入其他 UI 库） |
| 状态管理 | Pinia | 3.0.4（禁用 Vuex） |
| 路由 | vue-router | 4.6.4 |
| 构建 | Vite | 6.4.1（禁用 vue-cli） |
| HTTP | axios | 1.13.2 |
| 样式 | Sass（sass-embedded） | 1.97.2 |

- 开发端口 5173，`/dev-api` 代理至后端 8080（`vite.config.ts` + `.env*`）
- **在 ebs-web 中禁止**回退 Vue2/Options API 主写法、Element UI、Vuex

**旧前端 `ruoyi-ui`（Vue 2，位于本仓库内，并行维护）**

| 层级 | 技术 | 版本 |
|------|------|------|
| 框架 | Vue | 2.6.12（Options API） |
| UI 库 | Element UI | 2.15.14（禁止引入其他 UI 库） |
| 状态管理 | Vuex | 3.6.0（禁用 Pinia） |
| 路由 | vue-router | 3.4.9 |
| 构建 | vue-cli（webpack） | 4.4.6（禁用 Vite） |
| HTTP | axios | 0.30.3 |
| 样式 | Sass | 1.32.13 |

> ⚠️ 技术栈**按目录严格隔离**：`ruoyi-ui` 内是 **Vue 2 + JavaScript**，禁止 Vue 3 语法、Composition API、TypeScript、Element Plus、Pinia、Vite；`D:\ebs-web` 内反向禁止 Vue2/Element UI 写法。写代码前先确认目标前端目录，禁止串栈。

---

## 3. 后端开发规范

### 3.1 业务模块包结构（强制）

新增业务代码统一放入**自建业务模块**（`ruoyi-bizperm`、`ruoyi-apilog` 或新建 `ruoyi-xxx`），**禁止放入 `ruoyi-admin`、`ruoyi-system` 等框架模块**。

> 📌 **存量豁免**：历史上已落在 `ruoyi-system` 等框架模块内的二开表与功能（如单据编号 `SysNumberRule*`、`SysApiKey`、`SysDataDict`、`SysNoticeRead`、`SysUserRecently` 等），按现状维护、不强制迁移（红区仍禁改，仅允许 Bug 修复级变更）；但**新增功能一律不得复制该模式**，必须进自建业务模块。

```
ruoyi-bizperm/
├── src/main/java/com/ruoyi/bizperm/
│   ├── controller/          # 控制器
│   ├── domain/              # 实体
│   │   ├── bo/              # 入参对象
│   │   ├── vo/              # 出参对象
│   │   └── enums/           # 枚举
│   ├── mapper/              # Mapper 接口
│   ├── service/             # 服务接口
│   │   └── impl/            # 服务实现
│   └── utils/               # 模块工具类（按需）
└── src/main/resources/
    ├── mapper/bizperm/      # Mapper XML
    └── sql/bizperm/         # 模块建表/初始化 SQL
```

`ruoyi-apilog` 同理（`resources/mapper/apilog/`），额外包含 `utils/`（接口客户端、日志工具）与 `web/`（过滤器）。

### 3.2 类与方法命名（强制）

| 类型 | 规则 | 示例 |
|------|------|------|
| Controller | `XxxController` | `BizPermPolicyController` |
| Service 接口 | `IXxxService` | `IBizPermPolicyService` |
| Service 实现 | `XxxServiceImpl` | `BizPermPolicyServiceImpl` |
| Mapper | `XxxMapper` | `BizPermPolicyMapper` |
| Entity / BO / VO | `Xxx` / `XxxBo` / `XxxVo` | `SysBizPermPolicy` / `BizPermTreeQueryBo` / `BizPermTreeNodeVo` |

方法命名：`selectXxxList` / `selectXxxById` / `insertXxx` / `updateXxx` / `deleteXxxByIds` / `checkXxxUnique`；禁用 `getXxxList`、`save`、`remove`、`Dao`、`DTO`。

### 3.3 Controller 规范（强制）

```java
/**
 * 业务权限策略Controller
 *
 * @author 张三
 * @date 2026-11-17
 */
@RestController
@RequestMapping("/bizperm/policy")
public class BizPermPolicyController extends BaseController
{
    @Autowired
    private IBizPermPolicyService bizPermPolicyService;

    @PreAuthorize("@ss.hasPermi('bizperm:policy:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysBizPermPolicy query)
    {
        startPage();
        return getDataTable(bizPermPolicyService.selectPolicyList(query));
    }
}
```

必须遵守：
- ✅ 继承 `BaseController`，`@RestController`
- ✅ 列表：`startPage()` + `getDataTable()`；单条/复杂结果：`success(...)` + `AjaxResult`
- ✅ 增删改：`toAjax(...)`，并按需加 `@Log`、`@PreAuthorize`、`@RepeatSubmit`
- ✅ 业务逻辑全部委托 Service，Controller 只做参数校验与结果包装
- ✅ 类/方法左大括号换行（与现有代码风格一致）

禁止：
- ❌ 直接返回 `List` / 实体
- ❌ 手写分页 SQL 或手动 `PageInfo`
- ❌ 在 Controller 里写数据库访问

**⚠️ `AjaxResult.success()` 重载坑点**

| 写法 | 结果 |
|------|------|
| `success(token)`（String） | 被当作 `msg`，`data` 为空 |
| `success((Object) token)` | 正确放入 `data` |

返回字符串且需要放 `data` 时，必须强转 `Object`。

### 3.4 Entity 规范

- 继承 `BaseEntity`（获得 `createBy/createTime/updateBy/updateTime/remark`）
- 字段驼峰命名，自动映射下划线；需要导出的字段加 `@Excel`
- 密码、盐值等敏感字段禁止导出
- 非数据库字段需在注释中标明

### 3.5 Mapper / XML / SQL 规范（强制）

- XML 放在模块 `src/main/resources/mapper/<module>/`，`namespace` 必须等于接口全限定名
- 参数绑定用 `#{}`；`${}` 仅限数据权限等受控场景
- 分页统一交给 PageHelper，禁止手写分页 SQL
- **SQL Server 语法**：
  - 取前 N 条用 `top N`，禁止 `limit`
  - 当前时间用 `getdate()`，禁止 `now()` / `sysdate()`
  - 字符串拼接优先用 `+`，慎用 `concat`（低版本不兼容）
  - 行级锁用 `with (updlock, holdlock)`；引用含 `from` 的 `<sql>` 片段时注意不要出现重复 `from`
- **Oracle 语法**（副库）：校验语句必须带 `FROM DUAL`（如 `select 1 from dual`）

> ⛔ **强制**：任何 Mapper XML、Java 内嵌 SQL、建表脚本的新增/修改，必须先执行 `.trae/skills/sqlserver-compat-check/SKILL.md` 校验清单，修复通过后再输出代码。

### 3.6 Service 规范

- 实现类加 `@Service`；增删改加 `@Transactional`，查询不加事务
- **事务豁免**：单条 INSERT/DELETE 且无关联写操作、无跨表一致性要求的方法，可不加 `@Transactional`（单条语句自动提交），如日志类 `record()` 落库方法；除此之外的写方法一律加事务
- 复杂业务、跨表组装、事务边界放 Service，不放 Controller/Mapper
- 数据权限需要时在 Service 或 Mapper 方法上加 `@DataScope`

### 3.7 注解使用

| 注解 | 位置 | 必须性 |
|------|------|--------|
| `@PreAuthorize` | Controller 方法 | MUST（豁免见下方） |
| `@Log` | Controller 敏感操作 | MUST |
| `@Transactional` | Service 增删改 | MUST |
| `@DataScope` | 需要数据权限的查询 | 按需 |
| `@DataSource(DataSourceType.ORACLE)` | 访问 Oracle 的方法（Mapper/Service，现有示例在 Controller） | 按需 |
| `@Excel` | Entity 字段 | 需要导出时 |
| `@RepeatSubmit` | 提交类接口 | 按需 |

**`@PreAuthorize` 豁免条款**（同时适用于 §3.3、§7 审查清单）：

1. **自助型接口可豁免**：仅操作**当前登录人自身数据**、且通过 `SecurityUtils` 强制绑定登录人工号/用户名（参数不可被外部指定）的接口，可不加 `@PreAuthorize`，登录态即为门槛。示例：`/bizperm/my/tree`、`/bizperm/my/visible-users`（对应 `BizPermMyController`）。
   - 判定标准（必须全部满足）：① 从登录上下文取身份，不信任入参；② 只读或只改当前用户自己的数据；③ 无批量查询他人数据的能力。
2. **匿名放行接口**：标注 `@Anonymous` 的公开接口（如验证码、登录、文档中心）天然豁免，但其内部不得泄露敏感数据。
3. **以下场景不豁免（仍必须加）**：
   - 接受**任意用户 ID/工号等入参**查询或操作他人数据的接口——即使需要登录也不豁免，必须配专用权限串（如 `bizperm:api:query`），或改用独立鉴权（签名/服务 Token）并在此处登记豁免；
   - 增删改等写操作接口一律不豁免。

> ⚠️ 待办：`ApiBizPermController`（`/api/bizperm/visible-users`，接受任意 userCode）**不符合豁免条件**，属于第 3 条范围，需补 `@PreAuthorize` 或独立鉴权后再更新本条。

### 3.8 双数据源使用约束

- **主库（SQL Server）**：系统表、业务表、日志表，所有写操作只能走主库
- **副库（Oracle）**：用于外部系统数据查询，通过 `@DataSource(DataSourceType.ORACLE)` 切换（见 `OracleTestController`）
- 禁止假设跨库分布式事务；跨库写操作必须拆分为"主库事务 + 幂等补偿"，并在方案文档中说明
- 数据库账号口令不得出现在代码、文档、日志、提交信息中

### 3.9 文件注释（强制）

所有 Java 类、接口、Mapper 顶部必须包含：

```java
/**
 * 功能说明
 *
 * @author 开发者姓名
 * @date yyyy-MM-dd
 */
```

---

## 4. 前端开发规范（双前端并行：主前端 `D:\ebs-web` / 旧前端 `ruoyi-ui`）

### 4.0 适用范围与分工（必读）

| 项 | 主前端 `D:\ebs-web` | 旧前端 `ruoyi-ui`（本仓库） |
|----|--------------------|---------------------------|
| 技术栈 | Vue 3.5 + TypeScript + Vite + Element Plus + Pinia（§2.2 上表） | Vue 2.6 + JavaScript + vue-cli + Element UI + Vuex（§2.2 下表） |
| 地位 | 含全部业务页面，联调代理指向本后端 8080 | 并行维护，业务页面落后，需补齐 |
| 业务代码边界 | `src/views/<模块>`、`src/api/<模块>`、`src/types/api/<模块>` | `src/views/<模块>`、`src/api/<模块>` |
| 规范章节 | §4.1（目录）、§4.4、§4.5 | §4.1（目录）、§4.2、§4.3 |

- **同一业务功能两端均需实现**（并行维护约定）：新增/改造业务时，先确认两端清单，后端接口共用，前端分别按各自技术栈落地
- **写代码前先判定目标目录**，严格按 §2.2 技术栈隔离，禁止串栈（在 ebs-web 写 Options API/Element UI、在 ruoyi-ui 写 `<script setup>`/TS 均属违规）
- 不确定落在哪端时，**中断询问用户**

### 4.1 目录与边界

```
ruoyi-ui/src/
├── api/            # ⚠️ 框架目录：system/、monitor/、tool/ 禁止改；业务接口放 api/<module>/
├── assets/         # 🔴 styles/icons/images 禁止随意改
├── components/     # 🔴 公共组件（PascalCase 目录，如 FileUpload/index.vue）
├── directive/      # 🔴 v-hasPermi / v-hasRole 等指令
├── layout/         # 🔴 布局
├── plugins/        # 🔴 全局插件（$modal / $tab / $auth / $dict）
├── router/         # 🔴 路由（菜单驱动的动态路由）
├── store/          # 🔴 Vuex 模块
├── utils/          # 🔴 request.js / auth.js / dict.js / ruoyi.js
└── views/          # 🟢 业务页面放 views/<module>/
```

- 业务页面：`src/views/<module>/index.vue`（子页面如 `detail.vue`）
- 业务接口：`src/api/<module>/<entity>.js`
- 当前 `views/` 下只有 `dashboard/error/monitor/system/tool`；`bizperm`、`apilog` 页面按需新增，不得改动框架页面

**主前端 `D:\ebs-web` 目录与边界**

```
ebs-web/src/
├── api/            # ⚠️ 框架接口：system/、monitor/、tool/ 等存量框架目录禁止改；业务接口放 api/<module>/
├── types/api/      # 🟢 业务接口类型定义（与 api/<module> 对应）
├── views/          # 🟢 业务页面放 views/<module>/
├── assets/  components/  layout/  directive/  # 🔴 框架目录，禁止改
├── plugins/  router/  store/  utils/           # 🔴 框架目录（request.ts/auth.ts/dict.ts 等禁改）
└── vite/  vite.config.ts  tsconfig.json        # 🔴 构建配置，改动需用户确认
```

- 业务页面：`src/views/<module>/index.vue`（已有 `bizperm/policy`、`apilog/*`、`system/apiKey|numberRule|datadict|commonApi`、`sale/order` 等可参考）
- 业务接口：`src/api/<module>/<entity>.ts` + 类型 `src/types/api/<module>/*.ts`

### 4.2 `ruoyi-ui` 页面规范（Vue 2 Options API）

```vue
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="关键字" prop="keyword">
        <el-input v-model="queryParams.keyword" placeholder="请输入关键字" clearable
                  @keyup.enter.native="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column label="名称" prop="name" />
    </el-table>

    <pagination v-show="total > 0" :total="total"
                :page.sync="queryParams.pageNum" :limit.sync="queryParams.pageSize"
                @pagination="getList" />
  </div>
</template>

<script>
import { listXxx } from "@/api/bizperm/xxx"

export default {
  name: "BizPermXxx",
  data() {
    return {
      loading: false,
      showSearch: true,
      list: [],
      total: 0,
      queryParams: { pageNum: 1, pageSize: 10 }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询列表 */
    getList() {
      this.loading = true
      listXxx(this.queryParams).then(res => {
        this.list = res.rows
        this.total = res.total
        this.loading = false
      })
    },
    /** 搜索按钮 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    }
  }
}
</script>
```

必须遵守：
- ✅ `<script>` 内使用 Options API：`data()`、`created()`、`methods`
- ✅ 根元素 `class="app-container"`；表格 `v-loading`；分页用 `<pagination>` 组件
- ✅ 按钮权限 `v-hasPermi="['bizperm:policy:add']"`
- ✅ 消息与弹窗用 `this.$modal.msgSuccess()` / `this.$modal.confirm()` / `this.$message`
- ✅ 字典用 `dicts: ['sys_yes_no']` + `dict.type.sys_yes_no`
- ❌ 禁止 `<script setup>`、`ref/reactive`、`Element Plus` 组件名、`import type`

### 4.3 `ruoyi-ui` API 文件规范（JS）

```javascript
import request from '@/utils/request'

/** 查询列表 */
export function listXxx(query) {
  return request({ url: '/bizperm/xxx/list', method: 'get', params: query })
}

/** 新增 */
export function addXxx(data) {
  return request({ url: '/bizperm/xxx', method: 'post', data: data })
}
```

- GET 用 `params`，POST/PUT 用 `data`
- 函数必须写中文注释（功能说明）
- 前端无 TypeScript，禁止 `.ts` 文件与类型声明文件

### 4.4 `ebs-web` 页面与 API 规范（Vue 3 + TypeScript）

```vue
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryFormRef" size="small" :inline="true" v-show="showSearch">
      <el-form-item label="关键字" prop="keyword">
        <el-input v-model="queryParams.keyword" placeholder="请输入关键字" clearable
                  @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="small" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="small" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table v-loading="loading" :data="list">
      <el-table-column label="名称" prop="name" />
    </el-table>

    <pagination v-show="total > 0" :total="total"
                v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize"
                @pagination="getList" />
  </div>
</template>

<script setup name="BizPermXxx">
import { listXxx } from "@/api/bizperm/xxx"
import type { Xxx } from "@/types/api/bizperm"

// 查询参数
const queryParams = ref<Xxx.Query>({ pageNum: 1, pageSize: 10 })
// 列表与加载
const list = ref<Xxx.Row[]>([])
const total = ref(0)
const loading = ref(false)

/** 查询列表 */
const getList = async () => {
  loading.value = true
  const res = await listXxx(queryParams.value)
  list.value = res.rows
  total.value = res.total
  loading.value = false
}
</script>
```

必须遵守：
- ✅ `<script setup name="Xxx">` + Composition API（`ref`/`reactive`/`computed`，auto-import 已配置）
- ✅ 接口类型定义放 `src/types/api/<模块>`，API 函数返回值与入参必须有类型
- ✅ 根元素 `class="app-container"`；表格 `v-loading`；分页用 `<pagination>`（Element Plus 4.x 写法 `v-model:page`）
- ✅ 按钮权限 `v-hasPermi="['bizperm:policy:add']"`；消息与弹窗用 `useMessage`/`$modal`（以 `plugins/modal.ts` 为准）
- ✅ 字典用 `useDict('sys_yes_no')`（以 `utils/dict.ts` 实际导出为准）
- ✅ 状态跨页面共享用 Pinia（`store/modules/`，框架目录禁改，业务 store 新增需确认）
- ❌ 禁止 Vue2/Options API 主写法、Element UI 组件名、Vuex、`.js` 业务接口文件（一律 `.ts`）

### 4.5 双端一致性要求（并行维护）

- **同一业务两端并行交付**：改动清单中必须同时列出 `ebs-web/src/views|api|types/<模块>` 与 `ruoyi-ui/src/views|api/<模块>`（若该功能已在 ruoyi-ui 存在）
- **接口契约共用**：两端调用同一后端路径与参数；后端接口变更须同步两端 API 文件
- **菜单/组件路径**：菜单 SQL 中的组件路径必须与**两端各自**实际页面文件一一对应，避免点击白屏
- **文案与交互对齐**：两端同一功能的字段、按钮、提示文案保持一致（按各自 UI 库习惯实现，不强制像素级相同）

---

## 5. 数据库规范

**表命名**
- 统一 `sys_` 前缀：系统表 `sys_user`，业务表 `sys_<模块>_<实体>`（如 `sys_biz_perm_policy`、`sys_interface_log`）
- 小写 + 下划线，禁止驼峰

**字段命名**
- 主键 `id` 或 `<表名>_id`
- 逻辑删除 `del_flag`：`0` 正常、`2` 删除（与若依一致）
- 状态 `status`：`0` 正常、`1` 停用
- 时间 `create_time` / `update_time`；操作人 `create_by` / `update_by`

**索引**
- 主键、外键、高频查询字段必须建索引
- 索引名 `idx_<表名>_<字段名>`

**SQL 文件位置**
- 框架初始化/系统表脚本：仓库根 `sql/`（如 `sqlserver.sql`、`quartz_sqlserver.sql`、`datadict_menu.sql`）
- 模块业务脚本：模块内 `src/main/resources/sql/<module>/`（如 `ruoyi-bizperm/.../sql/bizperm/`、`ruoyi-apilog/.../sql/apilog/`）

**SQL 脚本命名（按脚本类别，替代旧「文件名使用表名」单条表述）**
- **建表脚本（一表一名）**：文件名 = 表名，小写下划线，如 `sys_biz_perm_policy.sql`、`sys_interface_log.sql`
- **初始化脚本（多表/全量）**：`<范围>_init[_方言]`，如 `bizperm_init_all.sql`；**存量豁免**：根目录 `sqlserver.sql`、`quartz_sqlserver.sql` 沿用现名（已被 docs/规则引用，不改名）
- **数据脚本（菜单/字典等基础数据）**：`<功能>_menu.sql` / `<功能>_dict.sql`，如 `datadict_menu.sql`、`sys_interface_log_menu.sql`；**存量豁免**：`sys_menu_bizperm.sql`、`sys_dict_bizperm.sql` 沿用现名（docs 已引用），**新增一律用 `<功能>_menu` 风格**
- 通用：小写 + 下划线、后缀 `.sql`；禁止在 Java 代码中硬编码建表语句

---

## 6. 文档规范

- 文档统一放 `docs/`，按四类归档：`01-requirements/`、`02-development/`、`03-optimization/`、`04-bugfix/`
- 每类下按模块建子目录（英文小写、短横线分隔，如 `bizperm`、`number-rule`、`datasource`）；通用能力文档统一放 `common/<module>/`（需求/开发两侧结构一致）
- 新建文档使用 `_template-*.md` 模板，并同步更新所属分类目录 README 索引表与 `docs/README.md` 索引
- 6A 工作流产物同样归入上述分类目录：需求/对齐 → `01-requirements/common/<module>/`，设计/任务/验收/总结 → `02-development/common/<module>/`，缺陷 → `04-bugfix/<module>/`；**禁止在 `docs/` 根下新建 `任务名/` 平铺目录**
- 文档在线查阅：`http://localhost:8080/docs/index.html`（`DocCenterController`，匿名放行）

---

## 7. 代码审查清单

**后端**
- [ ] 业务代码是否放入自建业务模块（未改框架模块）
- [ ] 新增接口是否加 `@PreAuthorize`（豁免范围见 3.7 豁免条款），敏感操作是否加 `@Log`
- [ ] 增删改是否加 `@Transactional`（单条无关联写入豁免见 3.6）
- [ ] 列表是否 `startPage()` + `getDataTable()`
- [ ] SQL 是否兼容 SQL Server（top / getdate / 无 limit），Oracle 语句是否带 `FROM DUAL`
- [ ] 是否已过 `sqlserver-compat-check` 校验
- [ ] 是否使用 `#{}` 绑定，是否有 N+1 查询
- [ ] Java 文件顶部是否有 `@author` / `@date`

**前端**
- [ ] 是否与目标目录技术栈一致：`ruoyi-ui` 用 Vue 2 Options API、`ebs-web` 用 Vue3 `<script setup>`+TS（禁止串栈，§4.0）
- [ ] 表格 `v-loading`、分页 `<pagination>`、按钮 `v-hasPermi`
- [ ] 接口方法是否集中在 `src/api/<module>/`（ebs-web 另需 `src/types/api/<module>/` 类型）
- [ ] 字典与消息是否按各自端规范（ruoyi-ui：`dicts` + `this.$modal`；ebs-web：`useDict` + `$modal`/`useMessage`）
- [ ] 是否改动 `router/store/utils/layout/plugins` 等框架目录（应避免）
- [ ] 并行功能是否两端同步实现与联调（§4.5）

---

## 8. 安全红线与性能

**安全红线**
- ❌ 代码、文档、日志、提交信息中出现数据库口令、密钥、Token
- ❌ 返回 `password`、`salt` 等敏感字段
- ❌ 使用 `${}` 拼接用户输入
- ❌ 生产环境打印 SQL 参数与敏感日志

**性能**
- ✅ 列表必须分页，禁止全表查询
- ✅ 禁止循环内查库，改用批量/JOIN
- ✅ 大数据导出使用异步任务
- ✅ 前端大表格使用分页或虚拟滚动

---

## 9. Git 规范

- 提交信息：`<type>(<scope>): <subject>`，type ∈ `feat|fix|docs|style|refactor|perf|test|chore`
- 远程仓库：
  - `origin`：**唯一提交/推送目标**（主远程仓库）
  - 其他历史远程（如 `crm-api`）：**禁止 push / merge / pull**，如需查阅先与负责人确认
- 提交前确认当前分支（`master`）与变更范围，禁止提交 `target/`、`.idea/`、含口令的配置文件

---

## 10. 常用命令

**后端（仓库根目录）**

```bash
mvn clean package -DskipTests        # 打包
mvn clean install -DskipTests        # 安装到本地仓库
```

- 启动：IDEA 运行 `ruoyi-admin` 的 `RuoYiApplication`（Windows 也可用根目录 `ry.bat`）
- 端口：`8080`；配置：`ruoyi-admin/src/main/resources/application.yml`、`application-druid.yml`

**前端（按目标目录分栈，§4.0）**

```bash
# 主前端 D:\ebs-web（Vue3+TS，端口 5173）
npm install
npm run dev            # 开发，端口 5173，/dev-api 代理到 8080
npm run build:prod     # 生产构建（Vite）

# 旧前端 d:\ebs-api\ruoyi-ui（Vue2，端口 80）
npm run dev            # 开发，端口 80，/dev-api 代理到 8080
npm run build:prod     # 生产构建
```

---

## 11. 常用工具类

**后端**

| 类 | 路径 |
|---|---|
| StringUtils | `com.ruoyi.common.utils.StringUtils` |
| DateUtils | `com.ruoyi.common.utils.DateUtils` |
| SecurityUtils | `com.ruoyi.common.utils.SecurityUtils` |
| ServletUtils | `com.ruoyi.common.utils.ServletUtils` |
| ExcelUtil | `com.ruoyi.common.utils.poi.ExcelUtil` |
| RedisCache | `com.ruoyi.common.core.redis.RedisCache` |

**前端**

| 文件 | 路径 | 用途 |
|---|---|---|
| request.js | `src/utils/request.js` | HTTP 封装（ruoyi-ui） |
| auth.js | `src/utils/auth.js` | Token 管理（ruoyi-ui） |
| dict.js | `src/utils/dict.js` | 字典（ruoyi-ui） |
| ruoyi.js | `src/utils/ruoyi.js` | 通用工具（`parseTime`、`parseStrEmpty` 等，ruoyi-ui） |
| request.ts | `ebs-web/src/utils/request.ts` | HTTP 封装（主前端） |
| modal.ts | `ebs-web/src/plugins/modal.ts` | 消息与弹窗（主前端，`$modal`） |

---

## 12. 注意事项

1. **数据库**：主库 SQL Server（`SELECT TOP`、`getdate()`），副库 Oracle（`FROM DUAL`）；分页统一 PageHelper
2. **作者信息**：新文件顶部写 `@author` 与 `@date`，使用开发者本人姓名
3. **代码生成**：可用 `ruoyi-generator` 生成基础代码，但生成后须按本规则校正包名/模块位置
4. **权限**：后端 `@PreAuthorize`，前端 `v-hasPermi` / `v-hasRole`
5. **端口/代理**：后端 `8080`，主前端 ebs-web dev `5173`，旧前端 ruoyi-ui dev `80`，接口前缀均为 `/dev-api`
6. **前端双工程**：主前端 `D:\ebs-web`（Vue3+TS）+ 旧前端 `ruoyi-ui`（Vue2）并行维护，规范按 §4 分栈执行；`crm-web`、`ruoyi-crm` 不存在，禁止引用
7. **文档中心**：`http://localhost:8080/docs/index.html`；探测不到项目根目录时配置 `ruoyi.docPath`
8. **规则维护**：发现本文件与代码不一致，先按代码执行，并同步修订本文件（改规则需用户确认）

---

## 13. 纯 AI 新增项目/模块开发步骤（强制流程）

> 由 AI 独立完成的**新增功能/新增模块**，必须按以下顺序执行；任一步骤存疑先中断询问，禁止跳步直接写代码。

### 步骤1：需求对齐（文档先行）
- 先检索记忆与现有代码，确认无重复实现；产出 `docs/01-requirements/common/<module>/<名称>-prd.md`（复制 `_template-prd.md`），写清范围、验收标准、待确认问题
- 关键决策点（表结构、权限模型、外部接口范围）中断询问用户，共识后写入 PRD

### 步骤2：方案设计
- 产出 `docs/02-development/common/<module>/<名称>-plan.md` 或 `-dev.md`：分层架构、接口契约、数据模型、异常处理
- 涉及 SQL 的，方案中先过 `.trae/skills/sqlserver-compat-check/SKILL.md` 校验清单

### 步骤3：任务拆分与确认
- 按可独立编译验证的粒度拆子任务，明确依赖顺序与验收标准（6A 工作流的 TASK 文档可复用），复杂任务先请用户确认

### 步骤4：工程骨架
- 代码落位：新建 `ruoyi-xxx` 自建模块，或复用 `ruoyi-bizperm` / `ruoyi-apilog`，包结构按 §3.1；**禁止进框架红区**（§1 模块表）
- SQL 脚本落位：建表 `<表名>.sql`、菜单 `<功能>_menu.sql`、字典 `<功能>_dict.sql`，统一放 `src/main/resources/sql/<module>/`

### 步骤5：后端实现
- 按 §3.2~§3.9 编写 Controller/Service/Mapper：命名、`@PreAuthorize`（豁免见 §3.7）、`@Transactional`（豁免见 §3.6）、`startPage()+getDataTable()`、文件头 `@author/@date`、函数中文注释
- 所有 SQL 先过 sqlserver-compat-check 再输出

### 步骤6：前端实现（双端并行，按 §4.0 分栈）
- 主前端：`D:\ebs-web\src\views\<module>\index.vue`、`src/api\<module>\*.ts`、`src/types/api\<module>\*.ts`（Vue3 `<script setup>`+TS，§4.4）
- 旧前端（并行维护，同一功能需同步实现）：`ruoyi-ui/src/views/<module>/index.vue` 与 `src/api/<module>/*.js`（Vue 2 Options API，§4.2/§4.3）
- 通用要求：`<pagination>`、`v-hasPermi`；菜单 SQL 中的组件路径必须与**两端各自**实际页面文件一一对应，避免点击白屏

### 步骤7：编译与自测
- 后端：`mvn -pl ruoyi-admin -am compile -DskipTests`（本机需 `JAVA_HOME` 指向 JDK17；命令行默认 java 为 1.8 会报「无效的目标发行版 17」，可用 IDEA 自带 JBR：`D:\Idea 2024\JetBrains\IntelliJ IDEA 2024.3.7\jbr`）
- 前端：主前端 `D:\ebs-web` 下 `npm run dev`（5173），必要时旧前端 `ruoyi-ui` 下 `npm run dev`（80）；逐条对照 PRD 验收标准自测，失败项修复后重测

### 步骤8：文档与索引同步
- 更新 `docs/01-requirements|02-development/common/<module>/README.md` 索引与 `docs/README.md`；新文档首行保留中文标题并写明「中文名称：xxx」（文档中心按此显示）
- 缺陷记入 `docs/04-bugfix/<module>/`

### 步骤9：交付确认
- 输出变更清单（新增/修改文件、SQL 脚本执行方式、菜单/字典初始化步骤、启动与验证方式）
- 需要执行的 SQL（建表/菜单）明确告知用户手工执行；涉及本规则修订的，先取得用户确认再改
- 提交按 §9 规范，禁止提交 `target/`、`.idea/`、含口令配置
