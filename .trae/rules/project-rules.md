# 若依CRM项目规则

> **项目根目录**: `<workspace>/ruoyi-crm`
> **规则位置**: `crm-api/.trae/rules/` (前后端规则统一放在后端目录下)
> **规则版本**: v1.0

---

## 0. 规则体系定位（MUST AI强制遵守）

> 本文档为项目【全局固定 Rules 基线】

1. 本文档永久固定、团队统一、无业务属性、AI 最高优先级约束
2. 所有业务 Prompt 必须继承本规则，禁止重复定义技术规范
3. 所有自动化 Skill 流程必须全程遵守本规则
4. 优先级：**人工明确指令 > 本 Rules 基线 > 业务 Prompt > AI 自主优化**
5. **AI 禁止突破本规则任何约束**

---

## 项目概述

本项目是基于**若依(RuoYi)框架**的企业级CRM管理系统，采用前后端分离架构。

| 端 | 相对路径 | 技术栈 | 状态 |
|---|----------|--------|------|
| **后端** | `crm-api/` | Spring Boot + MyBatis + MSSQL | ✅ 使用中 |
| **前端** | `crm-web/` | Vue 3 + TypeScript + Vite + Element Plus | ✅ 使用中 |
| ~~前端~~ | ~~`crm-api/ruoyi-ui/`~~ | ~~Vue 2~~ | ❌ **已作废** |

> **⚠️ 警告**: `crm-api/ruoyi-ui` 目录已作废，前端开发请在 `crm-web` 目录下进行！

---

## 第一部分：框架刚性规则（MUST）

### 1. 技术栈约束

#### 1.1 后端技术栈

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 后端框架 | Spring Boot | 4.0.6 | 禁止修改核心依赖版本 |
| Java版本 | Java | 17 | 语言级别固定 |
| ORM框架 | MyBatis | 4.0.1 | 必须使用 MyBatis，禁止 JPA |
| 分页插件 | PageHelper | 4.1.0 | 统一分页方式 |
| JSON处理 | FastJSON | 2.0.62 | 禁止混用 Jackson/Gson |
| 权限认证 | Spring Security + JWT | - | 安全框架不可替换 |
| 数据库 | MSSQL | - | 使用 `SELECT TOP` 分页语法 |
| 连接池 | Druid | 1.2.28 | 阿里数据库连接池 |

#### 1.2 前端技术栈

| 层级 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 前端框架 | Vue | 3.5.26 | 必须使用 Composition API |
| 前端语言 | TypeScript | 5.6.3 | 禁止纯 JavaScript |
| UI组件库 | Element Plus | 2.13.1 | 禁止引入其他 UI 库 |
| 状态管理 | Pinia | 3.0.4 | 禁止 Vuex |
| 构建工具 | Vite | 6.4.1 | - |
| HTTP请求 | Axios | 1.13.2 | - |

---

### 2. 后端架构约束

#### 2.1 模块结构约束（强制）

```
crm-api/
├── ruoyi-admin/              # Web服务入口（仅系统Controller，禁止修改）
│   └── src/main/java/com/ruoyi/web/controller/system/   # 系统控制器（禁止修改）
├── ruoyi-framework/          # 框架核心配置（禁止修改）
│   ├── config/               # 配置类
│   ├── security/             # 安全配置
│   └── aspectj/              # AOP切面
├── ruoyi-system/             # 系统管理模块（禁止修改）
│   ├── domain/               # 实体类
│   ├── mapper/               # Mapper接口
│   └── service/              # 服务层
├── ruoyi-common/             # 公共模块（禁止修改）
│   ├── core/                 # 核心类
│   ├── utils/                # 工具类
│   └── annotation/           # 注解
├── ruoyi-generator/          # 代码生成器（禁止修改）
├── ruoyi-quartz/             # 定时任务（禁止修改）
└── ruoyi-crm/                # CRM业务模块（✅ 业务代码存放位置）
    ├── src/main/java/com/ruoyi/crm/
    │   ├── controller/       # ✅ 业务Controller
    │   ├── domain/           # ✅ 业务实体类
    │   ├── mapper/           # ✅ 业务Mapper接口
    │   └── service/          # ✅ 业务服务层
    │       └── impl/         # ✅ 业务服务实现
    └── src/main/resources/
    │   ├── mapper/crm/       # ✅ Mapper XML文件
    │   └── sql/crm/          # ✅ 建表SQL文件
    └── pom.xml
```

> **⚠️ 重要说明**：
> - `ruoyi-admin`、`ruoyi-framework`、`ruoyi-system`、`ruoyi-common`、`ruoyi-generator`、`ruoyi-quartz` 都是框架核心，**禁止修改**
> - 所有 CRM 业务代码（Controller、Domain、Mapper、Service）必须放在 `ruoyi-crm` 模块
> - Controller 放在 `ruoyi-crm/src/main/java/com/ruoyi/crm/controller/` 目录下

#### 2.2 包结构约束（强制）

**系统模块包结构（禁止修改）：**
```
com.ruoyi.system/             # 系统模块（禁止修改）
├── domain/                   # 实体类
├── mapper/                   # Mapper接口
└── service/                  # 服务层
    └── impl/                 # 服务实现
```

**CRM业务模块包结构（业务代码）：**
```
com.ruoyi.crm/                # CRM业务模块（✅ 业务代码）
├── controller/               # ✅ 业务Controller
├── domain/                   # ✅ 实体类
│   ├── bo/                   # 业务对象（参数接收）
│   └── vo/                   # 视图对象（响应返回）
├── mapper/                   # ✅ Mapper接口
├── service/                  # ✅ 业务接口
│   └── impl/                 # ✅ 业务实现
└── utils/                    # 模块工具类
```

**禁止行为：**
- ❌ 包名不使用 `com.ruoyi` 前缀
- ❌ 在 domain 包外定义实体类
- ❌ Service 实现不放在 `impl` 子包
- ❌ Controller 放在 `ruoyi-admin` 模块（系统模块禁止修改）
- ❌ 修改 `ruoyi-system`、`ruoyi-framework`、`ruoyi-common` 等框架核心模块

#### 2.3 类命名约束（强制）

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| Controller | `XxxController` | `SysUserController` |
| Service接口 | `IXxxService` | `ISysUserService` |
| Service实现 | `XxxServiceImpl` | `SysUserServiceImpl` |
| Mapper | `XxxMapper` | `SysUserMapper` |
| Entity | `Xxx` | `SysUser` |
| BO | `XxxBo` | `SysUserBo` |
| VO | `XxxVo` | `SysUserVo` |

**禁止行为：**
- ❌ Service 接口不以 `I` 开头
- ❌ 使用 `Dao` 代替 `Mapper`
- ❌ 使用 `DTO` 代替 `Bo/Vo`

#### 2.4 方法命名约束（强制）

| 操作类型 | 方法名 | 返回值 |
|------|------|--------|
| 查询列表 | `selectXxxList` | `List<Xxx>` |
| 分页查询 | `selectXxxList` | `List<Xxx>`（配合 `startPage()`） |
| 根据ID查询 | `selectXxxById` | `Xxx` |
| 新增 | `insertXxx` | `int`（影响行数） |
| 修改 | `updateXxx` | `int`（影响行数） |
| 删除 | `deleteXxxById` | `int`（影响行数） |
| 批量删除 | `deleteXxxByIds` | `int`（影响行数） |
| 校验唯一性 | `checkXxxUnique` | `boolean` / `String` |

**禁止行为：**
- ❌ 使用 `getXxxList` 代替 `selectXxxList`
- ❌ 使用 `save` 代替 `insert/update`
- ❌ 使用 `remove` 代替 `delete`

#### 2.5 Controller 规范（强制）

```java
/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
@RestController
@RequestMapping("/system/user")
public class SysUserController extends BaseController {

    @Autowired
    private ISysUserService userService;

    // 列表查询必须调用 startPage()
    @PreAuthorize("@ss.hasPermi('system:user:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user) {
        startPage();  // MUST: 分页查询必须调用
        List<SysUser> list = userService.selectUserList(user);
        return getDataTable(list);  // MUST: 返回 TableDataInfo
    }

    // 单条查询返回 AjaxResult
    @PreAuthorize("@ss.hasPermi('system:user:query')")
    @GetMapping(value = "/{userId}")
    public AjaxResult getInfo(@PathVariable Long userId) {
        return success(userService.selectUserById(userId));
    }

    // 新增必须加 @Log 和 @PreAuthorize
    @PreAuthorize("@ss.hasPermi('system:user:add')")
    @Log(title = "用户管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysUser user) {
        return toAjax(userService.insertUser(user));
    }

    // 修改
    @PreAuthorize("@ss.hasPermi('system:user:edit')")
    @Log(title = "用户管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysUser user) {
        return toAjax(userService.updateUser(user));
    }

    // 删除
    @PreAuthorize("@ss.hasPermi('system:user:remove')")
    @Log(title = "用户管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds) {
        return toAjax(userService.deleteUserByIds(userIds));
    }
}
```

**必须遵守：**
- ✅ 继承 `BaseController`
- ✅ 使用 `@RestController`，不用 `@Controller`
- ✅ 路径使用小写，单词间用连字符 `/system/user`
- ✅ 列表查询调用 `startPage()` + `getDataTable()`
- ✅ 增删改返回 `AjaxResult`，使用 `toAjax()` 包装
- ✅ 敏感操作加 `@PreAuthorize` 权限控制
- ✅ 敏感操作加 `@Log` 操作日志

**禁止行为：**
- ❌ 直接返回 `List` 或 `Entity`（必须用 `AjaxResult` / `TableDataInfo` 包装）
- ❌ 在 Controller 写业务逻辑（必须委托给 Service）
- ❌ 手动处理分页（必须用 `startPage()`）

**⚠️ 重要坑点：AjaxResult.success() 重载问题**

若依的 `AjaxResult` 有两个容易混淆的重载：
- `success(String msg)` —— 字符串参数会被当成 **消息文本**
- `success(Object data)` —— 对象参数会被当成 **数据对象**

由于 Java 重载优先级，当传入 `String` 类型时，会优先匹配 `success(String msg)`，导致字符串被放到 `msg` 字段而不是 `data` 字段。

**正确写法：** 如果返回值是 String 类型但要放到 data 里，必须强转 Object：
```java
// ❌ 错误：字符串被当成 msg
return success(token);
return success(number);

// ✅ 正确：强转 Object，放到 data 字段
return success((Object) token);
return success((Object) number);
```

#### 2.6 Entity 规范（强制）

```java
/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
public class SysUser extends BaseEntity {
    
    @Excel(name = "用户序号", cellType = Excel.ColumnType.NUMERIC)
    private Long userId;
    
    @Excel(name = "用户名称")
    private String userName;
    
    @Excel(name = "用户性别", readConverterExp = "0=男,1=女,2=未知")
    private String sex;
    
    // 敏感字段不导出
    private String password;
    
    // 非数据库字段
    @Excel(name = "部门名称", sort = 10)
    private String deptName;
    
    // getter / setter
}
```

**必须遵守：**
- ✅ 继承 `BaseEntity`（自动获得 createBy, createTime, updateBy, updateTime, remark）
- ✅ 数据库字段使用驼峰命名（自动映射下划线）
- ✅ 需要导出的字段加 `@Excel` 注解
- ✅ 文件顶部添加 `@author` 和 `@date` 注释

#### 2.7 Mapper 规范（强制）

```java
/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
public interface SysUserMapper {
    
    // 列表查询必须加 @DataScope（如果需要数据权限）
    @DataScope(deptAlias = "d", userAlias = "u")
    List<SysUser> selectUserList(SysUser user);
    
    SysUser selectUserById(Long userId);
    
    int insertUser(SysUser user);
    
    int updateUser(SysUser user);
    
    int deleteUserById(Long userId);
    
    int deleteUserByIds(Long[] userIds);
    
    SysUser checkUserNameUnique(String userName);
}
```

**XML 约束：**

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ruoyi.system.mapper.SysUserMapper">
    
    <resultMap type="com.ruoyi.system.domain.SysUser" id="SysUserResult">
        <id property="userId" column="user_id"/>
        <result property="deptId" column="dept_id"/>
        <result property="userName" column="user_name"/>
    </resultMap>
    
    <sql id="selectUserVo">
        select u.user_id, u.dept_id, u.user_name, u.nick_name
        from sys_user u
        left join sys_dept d on u.dept_id = d.dept_id
    </sql>
    
    <select id="selectUserList" parameterType="com.ruoyi.system.domain.SysUser" resultMap="SysUserResult">
        <include refid="selectUserVo"/>
        where u.del_flag = '0'
        ${params.dataScope}
        <if test="userName != null and userName != ''">
            AND u.user_name like concat('%', #{userName}, '%')
        </if>
    </select>
    
</mapper>
```

**必须遵守：**
- ✅ Mapper 接口不写 `@Repository`（MyBatis 自动扫描）
- ✅ 需要数据权限的方法加 `@DataScope`
- ✅ XML 文件放在 `resources/mapper/xxx/` 目录
- ✅ XML namespace 必须等于接口全限定名
- ✅ MSSQL 使用 `SELECT TOP n` 语法

**禁止行为：**
- ❌ 使用 `${}` 拼接参数（必须用 `#{}`，除非数据权限）
- ❌ 在 XML 写复杂业务逻辑（只能用 SQL）
- ❌ 手写分页 SQL（用 PageHelper）

#### 2.8 Service 规范（强制）

```java
/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
public interface ISysUserService {
    List<SysUser> selectUserList(SysUser user);
    SysUser selectUserById(Long userId);
    int insertUser(SysUser user);
    int updateUser(SysUser user);
    int deleteUserByIds(Long[] userIds);
}

/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
@Service
public class SysUserServiceImpl implements ISysUserService {
    
    @Autowired
    private SysUserMapper userMapper;

    // 查询不加事务
    @Override
    @DataScope(deptAlias = "d", userAlias = "u")
    public List<SysUser> selectUserList(SysUser user) {
        return userMapper.selectUserList(user);
    }
    
    // 增删改必须加事务
    @Override
    @Transactional
    public int insertUser(SysUser user) {
        int rows = userMapper.insertUser(user);
        // 关联操作
        insertUserPost(user);
        insertUserRole(user);
        return rows;
    }
    
    @Override
    @Transactional
    public int updateUser(SysUser user) {
        return userMapper.updateUser(user);
    }
    
    @Override
    @Transactional
    public int deleteUserByIds(Long[] userIds) {
        return userMapper.deleteUserByIds(userIds);
    }
}
```

**必须遵守：**
- ✅ Service 实现加 `@Service`
- ✅ 增删改方法加 `@Transactional`
- ✅ 查询方法不加事务
- ✅ 复杂业务在 Service 层处理，不在 Mapper/Controller
- ✅ 文件顶部添加 `@author` 和 `@date` 注释

#### 2.9 注解使用规范（强制）

| 注解 | 使用位置 | 作用 | 必须性 |
|------|----------|------|--------|
| `@PreAuthorize` | Controller 方法 | 权限控制 | MUST |
| `@Log` | Controller 方法 | 操作日志 | MUST（敏感操作） |
| `@DataScope` | Mapper/Service 方法 | 数据权限 | MUST（需要时） |
| `@Transactional` | Service 增删改方法 | 事务管理 | MUST |
| `@Excel` | Entity 字段 | Excel 导出 | SHOULD（需要导出时） |
| `@RepeatSubmit` | Controller 方法 | 防重复提交 | SHOULD |

---

### 3. 前端架构约束

#### 3.1 目录结构约束（强制）

```
crm-web/src/
├── api/                    # API 接口
│   ├── system/             # 系统管理接口
│   ├── monitor/            # 监控接口
│   └── xxx/                # 业务模块接口
├── assets/                 # 静态资源
│   ├── icons/svg/          # SVG 图标
│   ├── images/             # 图片
│   └── styles/             # 样式
├── components/             # 公共组件
├── directive/              # 自定义指令
├── layout/                 # 布局组件
├── plugins/                # 插件
├── router/                 # 路由配置
├── store/                  # Pinia 状态管理
│   └── modules/            # store 模块
├── types/                  # TypeScript 类型
│   └── api/                # API 类型定义
├── utils/                  # 工具函数
└── views/                  # 页面视图
    ├── system/             # 系统管理页面
    ├── monitor/            # 监控页面
    └── xxx/                # 业务页面
```

**禁止行为：**
- ❌ 在 `views` 外写页面组件
- ❌ 在 `api` 外定义接口
- ❌ 在 `components` 写页面级组件

#### 3.2 文件命名约束（强制）

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| Vue 组件 | 小写，连字符分隔 | `user-list.vue`, `user-form.vue` |
| API 文件 | 小驼峰 | `user.ts` |
| 类型定义 | 小驼峰 | `user.ts` |
| Store 模块 | 小驼峰 | `user.ts` |

**禁止行为：**
- ❌ Vue 文件使用大驼峰（`UserList.vue`）
- ❌ 使用下划线分隔（`user_list.vue`）

#### 3.3 Vue 组件规范（强制）

```vue
<template>
  <div class="app-container">
    <!-- 搜索表单 -->
    <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch">
      <el-form-item label="用户名称" prop="userName">
        <el-input v-model="queryParams.userName" placeholder="请输入用户名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    
    <!-- 操作按钮 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['system:user:add']">新增</el-button>
      </el-col>
    </el-row>
    
    <!-- 数据表格 -->
    <el-table v-loading="loading" :data="userList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="用户编号" align="center" prop="userId" />
      <el-table-column label="操作" align="center" width="150">
        <template #default="scope">
          <el-button type="primary" link icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:user:edit']">修改</el-button>
          <el-button type="primary" link icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:user:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 分页 -->
    <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum" v-model:limit="queryParams.pageSize" @pagination="getList" />
    
    <!-- 添加/修改对话框 -->
    <el-dialog :title="title" v-model="open" width="600px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户名称" prop="userName">
          <el-input v-model="form.userName" placeholder="请输入用户名称" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { listUser, getUser, addUser, updateUser, delUser } from '@/api/system/user'
import type { UserQuery, UserForm, UserVO } from '@/types'

const { proxy } = getCurrentInstance()!

const loading = ref(false)
const showSearch = ref(true)
const userList = ref<UserVO[]>([])
const total = ref(0)
const open = ref(false)
const title = ref('')
const queryParams = reactive<UserQuery>({ pageNum: 1, pageSize: 10 })
const form = reactive<UserForm>({})
const rules = {
  userName: [{ required: true, message: '用户名称不能为空', trigger: 'blur' }]
}

const getList = async () => {
  loading.value = true
  const res = await listUser(queryParams)
  userList.value = res.rows
  total.value = res.total
  loading.value = false
}

const handleQuery = () => {
  queryParams.pageNum = 1
  getList()
}

const resetQuery = () => {
  proxy!.$refs.queryRef?.resetFields()
  handleQuery()
}

const handleAdd = () => {
  form.value = {}
  open.value = true
  title.value = '添加用户'
}

const handleUpdate = async (row: UserVO) => {
  const res = await getUser(row.userId)
  form.value = res.data
  open.value = true
  title.value = '修改用户'
}

const submitForm = async () => {
  await proxy!.$refs.formRef.validate()
  if (form.value.userId) {
    await updateUser(form.value)
    proxy!.$modal.msgSuccess('修改成功')
  } else {
    await addUser(form.value)
    proxy!.$modal.msgSuccess('新增成功')
  }
  open.value = false
  getList()
}

const handleDelete = async (row: UserVO) => {
  await proxy!.$modal.confirm('是否确认删除用户编号为"' + row.userId + '"的数据项？')
  await delUser(row.userId)
  getList()
  proxy!.$modal.msgSuccess('删除成功')
}

onMounted(() => {
  getList()
})
</script>
```

**必须遵守：**
- ✅ 使用 `<script setup lang="ts">` 语法
- ✅ 根元素使用 `class="app-container"`
- ✅ 表格必须加 `v-loading`
- ✅ 分页使用 `<pagination>` 组件
- ✅ 按钮权限使用 `v-hasPermi`
- ✅ 消息提示使用 `proxy!.$modal` 或 `proxy!.$message`

#### 3.4 API 接口规范（强制）

```typescript
// api/system/user.ts
import request from '@/utils/request'
import type { UserQuery, UserForm, UserVO, TableDataInfo, AjaxResult } from '@/types'

export function listUser(query: UserQuery): Promise<TableDataInfo<UserVO[]>> {
  return request({
    url: '/system/user/list',
    method: 'get',
    params: query
  })
}

export function getUser(userId: number): Promise<AjaxResult<UserVO>> {
  return request({
    url: '/system/user/' + userId,
    method: 'get'
  })
}

export function addUser(data: UserForm): Promise<AjaxResult> {
  return request({
    url: '/system/user',
    method: 'post',
    data: data
  })
}

export function updateUser(data: UserForm): Promise<AjaxResult> {
  return request({
    url: '/system/user',
    method: 'put',
    data: data
  })
}

export function delUser(userId: number | number[]): Promise<AjaxResult> {
  return request({
    url: '/system/user/' + userId,
    method: 'delete'
  })
}
```

**必须遵守：**
- ✅ 使用 `request` 封装函数
- ✅ 定义完整的 TypeScript 类型
- ✅ GET 请求用 `params`，POST/PUT 用 `data`

#### 3.5 类型定义规范（强制）

```typescript
// types/system/user.ts

export interface UserQuery {
  pageNum?: number
  pageSize?: number
  userName?: string
  status?: string
  [key: string]: any
}

export interface UserForm {
  userId?: number
  userName?: string
  nickName?: string
  email?: string
  status?: string
  remark?: string
}

export interface UserVO {
  userId: number
  userName: string
  nickName: string
  email: string
  status: string
  createTime: string
}
```

**必须遵守：**
- ✅ 查询参数、表单、视图对象分开定义
- ✅ 可选字段用 `?` 标记
- ✅ 后端返回的字段用 `VO` 后缀

---

## 第二部分：AI 开发边界控制（MUST）

### 1. 区域划分

#### 🔴 红色区域 - 框架核心（禁止修改）

**范围：**

```
后端：
- ruoyi-framework/              # 框架核心模块
- ruoyi-common/                 # 公共工具模块
- ruoyi-system/                 # 系统管理模块
- ruoyi-quartz/                 # 定时任务模块
- ruoyi-generator/              # 代码生成器模块
- ruoyi-admin/src/main/java/com/ruoyi/web/controller/system/  # 系统控制器

前端：
- src/components/               # 公共组件
- src/directive/                # 自定义指令
- src/layout/                   # 布局组件
- src/plugins/                  # 插件
- src/router/                   # 路由配置
- src/store/modules/            # 状态管理模块
- src/utils/                    # 工具函数
```

**约束：**
- ❌ **绝对禁止** AI 自动修改
- ⚠️ 如果业务需求确实需要修改，AI 必须**停止操作**并**向用户报告**
- ✅ 用户明确指令后，方可修改

#### 🟡 黄色区域 - 公共工具（提醒确认）

**范围：**

```
后端：
- ruoyi-admin/src/main/java/com/ruoyi/web/controller/common/  # 通用控制器
- ruoyi-admin/src/main/java/com/ruoyi/web/core/config/       # 配置类
- 各模块的 utils/ 包                                        # 模块工具类

前端：
- src/assets/styles/            # 全局样式
- src/types/                    # 全局类型定义（非业务）
- .env.*                        # 环境配置文件
```

**约束：**
- ⚠️ AI 可以修改，但**必须先提醒用户确认**
- ✅ 用户确认后，方可执行修改

#### 🟢 绿色区域 - 业务模块（自由修改）

**范围：**

```
后端：
- ruoyi-crm/                    # CRM 业务模块（自定义）
- ruoyi-xxx/                    # 其他自定义业务模块

前端：
- src/views/crm/                # CRM 页面
- src/views/xxx/                # 其他业务页面
- src/api/crm/                  # CRM API
- src/types/crm/                # CRM 类型定义
```

**约束：**
- ✅ AI 可以自由修改
- ✅ 必须遵守 Rules 中的技术规范

---

## 第三部分：项目自定义规则（SHOULD）

### 1. 代码审查清单

#### 1.1 后端审查项

- [ ] 新增接口是否添加了 `@PreAuthorize` 权限控制
- [ ] 敏感操作是否添加了 `@Log` 操作日志
- [ ] 需要数据权限的查询是否添加了 `@DataScope`
- [ ] 增删改操作是否添加了 `@Transactional`
- [ ] Controller 是否继承了 `BaseController`
- [ ] 列表查询是否调用了 `startPage()`
- [ ] 返回结果是否使用了 `AjaxResult` / `TableDataInfo`
- [ ] SQL 是否使用了 `#{}` 参数绑定（非 `${}`）
- [ ] 是否避免了 N+1 查询问题
- [ ] 是否处理了空指针和边界情况

#### 1.2 前端审查项

- [ ] 是否使用了 TypeScript 类型定义
- [ ] API 接口是否定义了完整的返回类型
- [ ] 表格是否添加了 `v-loading`
- [ ] 分页是否使用了 `<pagination>` 组件
- [ ] 按钮权限是否使用了 `v-hasPermi`
- [ ] 字典数据是否使用了 `useDict`
- [ ] 表单是否添加了验证规则
- [ ] 是否处理了接口错误情况

### 2. 安全红线

**绝对禁止：**

- ❌ 在代码中硬编码密码、密钥、Token
- ❌ 在生产环境开启 SQL 日志打印参数
- ❌ 返回敏感字段给前端（如 password、salt）
- ❌ 使用 `${}` 拼接用户输入的参数
- ❌ 在日志中打印敏感信息

### 3. 性能约束

**必须遵守：**

- ✅ 列表查询必须分页，禁止查询全表数据
- ✅ 循环中禁止查询数据库（先查询再循环处理）
- ✅ 避免 N+1 查询（使用 JOIN 或批量查询）
- ✅ 大数据量导出使用异步任务
- ✅ 前端表格大数据量使用虚拟滚动

### 4. Git 提交规范

**Commit Message 格式：**

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type 类型：**

- `feat`: 新功能
- `fix`: 修复
- `docs`: 文档
- `style`: 格式（不影响代码运行的变动）
- `refactor`: 重构
- `perf`: 性能优化
- `test`: 测试
- `chore`: 构建过程或辅助工具的变动

**示例：**

```
feat(user): 新增用户批量导入功能

- 支持 Excel 模板下载
- 支持批量校验和导入
- 导入结果异步通知

Closes #123
```

### 5. 数据库规范

**表命名：**

- 使用小写字母，下划线分隔
- 业务表以模块前缀开头，如 `crm_customer`
- 系统表以 `sys_` 开头

**字段命名：**

- 使用小写字母，下划线分隔
- 主键统一为 `id` 或 `表名_id`
- 逻辑删除字段统一为 `del_flag`（0-正常，1-删除）
- 状态字段统一为 `status`（0-正常，1-停用）
- 时间字段：`create_time`, `update_time`
- 操作人字段：`create_by`, `update_by`

**索引规范：**

- 主键必须建索引
- 外键必须建索引
- 查询频繁的字段必须建索引
- 索引名：`idx_表名_字段名`

---

## 第四部分：开发流程与规范

### Java文件注释规范

**所有Java类、接口、Mapper文件顶部必须添加注释：**

```java
/**
 * @author ${USER_NAME}
 * @date ${CURRENT_DATE}
 */
```

> **说明**: 
> - `${USER_NAME}` - 填写开发者姓名
> - `${CURRENT_DATE}` - 填写当前日期，格式 `yyyy-MM-dd`
>
> **示例**:
> ```java
> /**
>  * @author Zhang san
>  * @date 2026-06-16
>  */
> ```

### 新增功能模块步骤

1. **数据库**: 创建表结构 (MSSQL)
2. **后端开发** (crm-api):
   - Domain实体类 (`ruoyi-system/.../domain/`)
   - Mapper接口 + XML (`ruoyi-system/.../mapper/`)
   - Service接口 + 实现 (`ruoyi-system/.../service/`)
   - Controller控制器 (`ruoyi-admin/.../controller/`)
3. **前端开发** (crm-web):
   - 类型定义 (`src/types/模块/`)
   - API接口 (`src/api/模块/`)
   - 页面组件 (`src/views/模块/`)

---

## 第五部分：常用命令与工具

### 常用命令

#### 后端 (crm-api)
```bash
# 进入目录
cd crm-api

# 打包
mvn clean package

# 运行
mvn spring-boot:run

# 跳过测试打包
mvn clean package -DskipTests

# 跳过测试安装到本地仓库
mvn clean install -DskipTests
```

#### 前端 (crm-web)
```bash
# 进入目录
cd crm-web

# 安装依赖
npm install

# 开发运行
npm run dev

# 生产构建
npm run build:prod

# 预览构建结果
npm run preview
```

### 附录：常用工具类

#### 后端工具类

| 类名 | 路径 | 用途 |
|------|------|------|
| StringUtils | `com.ruoyi.common.utils.StringUtils` | 字符串处理 |
| DateUtils | `com.ruoyi.common.utils.DateUtils` | 日期处理 |
| SecurityUtils | `com.ruoyi.common.utils.SecurityUtils` | 获取当前用户 |
| ServletUtils | `com.ruoyi.common.utils.ServletUtils` | Servlet 工具 |
| ExcelUtil | `com.ruoyi.common.utils.poi.ExcelUtil` | Excel 导入导出 |
| RedisCache | `com.ruoyi.common.core.redis.RedisCache` | Redis 操作 |

#### 前端工具类

| 文件 | 路径 | 用途 |
|------|------|------|
| request.ts | `src/utils/request.ts` | HTTP 请求封装 |
| auth.ts | `src/utils/auth.ts` | Token 管理 |
| dict.ts | `src/utils/dict.ts` | 字典工具 |
| ruoyi.ts | `src/utils/ruoyi.ts` | 若依通用工具 |

---

## 注意事项

1. **数据库**: 使用MSSQL，注意SQL语法差异
   - 分页使用 `SELECT TOP n` 而非 `LIMIT`
   - 字符串拼接使用 `concat()` 函数

2. **作者信息**: 新文件顶部添加注释，使用开发者自己的姓名

3. **代码生成**: 可使用 ruoyi-generator 模块生成基础代码

4. **权限控制**: 
   - 后端: Spring Security + JWT + `@PreAuthorize`
   - 前端: 指令 `v-hasPermi` / `v-hasRole`

5. **路径映射**:
   - 后端端口: `8080`
   - 前端代理: `/dev-api` 转发到后端

6. **文件位置**:
   - 规则文档: `crm-api/.trae/rules/project-rules.md`
   - 其他文档: `crm-api/.trae/docs/`

7. **作废目录警告**:
   - `crm-api/ruoyi-ui/` **已作废**，请勿在此目录下编写任何前端代码
   - 前端开发请统一在 `crm-web/` 目录下进行

8. **SQL 文件存放规范**:
   - 所有初始化、建表 SQL 文件统一放在 `src/main/resources/sql/` 目录下
   - 按模块分类存放，目录结构如下：
     ```
     src/main/resources/sql/
     ├── system/                 # 系统模块 SQL
     │   ├── sys_user.sql        # 用户表
     │   ├── sys_role.sql        # 角色表
     │   └── sys_menu.sql        # 菜单表
     ├── crm/                    # CRM 业务模块 SQL
     │   ├── customer/           # 客户管理
     │   │   ├── crm_customer_report.sql      # 客户报备表
     │   │   ├── crm_customer_archive.sql     # 客户档案表
     │   │   └── crm_customer_contact.sql     # 客户联系人表
     │   ├── opportunity/        # 商机管理
     │   │   └── crm_opportunity.sql          # 商机表
     │   ├── brand/              # 品牌管理
     │   │   └── crm_brand.sql                # 品牌表
     │   ├── material/           # 物料管理
     │   │   └── crm_material.sql             # 物料表
     │   └── quotation/          # 报价单管理
     │   │   ├── crm_quotation.sql            # 报价单主表
     │   │   └── crm_quotation_detail.sql     # 报价单明细表
     └── init/                   # 初始化 SQL
         └── init_data.sql       # 初始化数据
     ```
   - SQL 文件命名规范：`表名.sql`（如 `crm_customer_archive.sql`）
   - 每个 SQL 文件包含：建表语句、索引、初始数据（如有）
   - **禁止**在代码中硬编码建表 SQL，必须使用独立 SQL 文件
