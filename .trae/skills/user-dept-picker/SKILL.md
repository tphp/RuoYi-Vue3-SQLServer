---
name: "user-dept-picker"
description: "生成或改造「选人 / 选部门」弹窗选择器组件：el-select 触发，弹窗内含最近联系人、组织架构树、用户表格三区联动，支持单选/多选/部门模式与快速模式。当用户需要人员或部门选择框、复用 UserSelect、或把该组件移植到其他项目时使用。"
---

> 中文名称：选人选部门弹窗选择器组件

# 选人 / 选部门弹窗选择器组件（User-Dept Picker）

## 1. 组件定位

**适用场景**
- 需要从组织架构中挑选**用户**或**部门**，且值域大（组织全员/全部门）
- 需要"最近联系人"快速回选、按部门树浏览、关键词搜索三种入口
- 单选 / 多选都要支持，且选人与选部门共用一个组件（`department` 开关切换）

**不适用（改用其他方案）**
| 场景 | 替代方案 |
|------|----------|
| 只需一个部门下拉树 | `el-tree-select` + `deptTreeSelect()` 接口（轻量，无弹窗） |
| 只需远程搜索姓名下拉 | `el-select` + `filterable remote` + `:remote-method` |
| 只是大列表文本输入+挑选 | `input-select-picker`（RemoteSelect，非人员场景） |

**核心设计原则**
- 组件不写死业务字段：用户与部门共用一套字典结构 `dict[id] = {userId, userName, nickName, deptName, avatar, sex}`，`department=true` 时字典切到 `deptDict`
- 值（`modelValue`）只存 **id**（单选 number / 多选 number[]），显示靠字典反查

---

## 2. 组件结构解剖（五层）

```
┌─ 触发层  el-select（multiple + filterable + remote + prefix 图标）
│    └─ 本地过滤：remoteMethod 在已加载字典中模糊匹配 userName/nickName
└─ 弹窗层  el-dialog（1024px，append-to-body，高度随窗口自适应）
     ├─ 页签层  el-tabs
     │    ├─ 最近联系人页签  recently：局部搜索框 + user-table（split 模式）
     │    └─ 组织架构页签    organization：TreePanel 树 + 搜索框 + user-table 联动
     ├─ 已选层  头像墙（avatar + 名称 + 关闭图标，点击即删）
     └─ 按钮层  清空 / 确认(带数量) / 取消
```

| 层 | 职责 | 关键实现 |
|----|------|----------|
| 触发层 | 承载已选值、回车搜索 | `multiple` 恒为 true（单选靠 `updateValue` 只放一个 id）；`#label` 插槽用字典反查显示名，字典缺失时红字提示 |
| 页签层 | 快速 / 浏览两种路径 | `tagName` 默认 `recently`；`quick=true` 且单选时不显示"确认"按钮（点行即确认） |
| 树联动层 | 按部门过滤列表 | `TreePanel @node-click` → `queryParams.deptId` → `getListDeptTree` 过滤（**部门列表由树本地推导，不发请求**） |
| 已选层 | 可视化已选项、单个删除 | `userCheck` 是 **对象 map**（`U${id}` 作 key），不是数组——去重靠 map 天然幂等 |
| 按钮层 | 确认写回 + 更新最近联系人 | `confirmClick()`：map → id 数组 → `update:modelValue` → POST `/system/recently/update/{dataType}` |

---

## 3. 对外契约（必须保持一致）

### Props

| 属性 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `modelValue` | `any` | — | 单选 `number` / 多选 `number[]`；组件内兼容字符串 id，打开时 `getInt()` 转换 |
| `title` | `string` | `user.selectPerson` | 弹窗标题，支持 `update:title` |
| `multiple` | `boolean` | `false` | 多选开关 |
| `quick` | `boolean` | `true` | 快速模式：单选时点行即确认，隐藏确认按钮 |
| `department` | `boolean` | `false` | `false`=选人，`true`=选部门（切换字典、接口 dataType、树页签数据源） |
| `maxCollapseTags` | `number` | `-1` | >0 时触发层启用 `collapse-tags` 折叠展示 |

> ⚠️ 所有 props 通过 `emitRef(props, emit, key)` 封装成可写 ref（见第 6 节），父组件双向绑定。

### Events

| 事件 | 载荷 | 用途 |
|------|------|------|
| `update:modelValue` | id 或 id[] | `v-model` 主绑定 |
| `update:title` / `update:multiple` / `update:quick` / `update:department` / `update:maxCollapseTags` | 对应类型 | 双向同步 |

### 内部接口依赖（移植时需对应替换）

| 用途 | 本项目接口 |
|------|-----------|
| 最近联系人列表 | `GET /system/recently/list/{dataType}`（dataType: 0=人 1=部门） |
| 更新最近联系人 | `POST /system/recently/update/{dataType}`，body `{userIds}` |
| 用户分页列表 | `listUserTop` → `GET /system/user/listTop`（带 `addDateRange`） |
| 部门树全量 | `deptTreeSelectAll` → `GET /system/user/deptTreeAll`（经 `cache()` 10 秒缓存） |

---

## 4. 数据流与三大字典

```
deptTreeSelectAll ──cache──► deptOptions ──filterDisabledDept──► enabledDeptOptions（树数据）
        │
        └── setListDeptTree(扁平化) ──► deptDict（id→部门信息）
                                    userListCache = JSON 快照（搜索回退用）

listUserTop ──► userList（表格数据）──► setUserDict ──► userDict（id→用户信息）

字典是唯一事实来源：
  触发层显示   getTagName(id)          = dict[id].nickName ?? dict[id].userName
  本地搜索     remoteMethod(keyword)   = 在 dict.values 上按 userName/nickName 过滤
  已选墙       userCheck["U"+id]       = dict[id]
  已选回填     onOpen()                = modelValue 的每个 id → dict 反查 → userCheck
```

**关键缓存与容错**
1. `cache(key, func)`：`cache.ts` 提供 10 秒 TTL + lock 并发去重，key 用 `USER_SELECT_USER` / `USER_SELECT_DEPT`
2. `userListCache` / `userRecentlyListCache`：JSON 字符串快照，搜索清空后可回退
3. 字典缺失（id 查不到对象）时：触发层 `#label` 插槽红字显示原值（[select.vue](file:///D:/ebs-web/src/components/User/select.vue#L136-L139)），不报错
4. `filterDisabledDept`：递归剔除 `disabled=true` 的部门，子树一并处理

---

## 5. 核心交互逻辑（易错点）

| 交互 | 实现 |
|------|------|
| 打开弹窗 | `clickOpen()` → `onOpen()`（modelValue 规整为 id 数组）→ 拉最近联系人 → `setUserCheck()` 回填已选 → 树 `checkNode()` 同步勾选 |
| 树节点点击 | `handleNodeClick` → `queryParams.deptId` → `getListDeptTree(allList)`：**从扁平化列表里按 parentId 过滤**（含选中节点自身），零请求 |
| 确认 | `confirmClick()`：遍历 `userCheck` 取 `userId` → `updateValue` → emit → POST 更新最近联系人 → 关弹窗 |
| 快速单选 | `quick && !multiple` 时隐藏确认按钮；行点击直接走确认流程 |
| 删除已选 | 已选墙点击图标 `delete userCheck[index]`（map 直接删，响应式生效） |
| 弹窗高度 | `onWindowResize()`：`window.innerHeight - 360`，钳制 `[200, 500]`；**必须在 `onBeforeUnmount` 移除监听** |
| 类型兼容 | `onOpen()` 对字符串 id 调 `getInt()` 转数字（历史数据容错） |

---

## 6. 双向绑定工具 `emitRef`

[emit_ref.ts](file:///D:/ebs-web/src/utils/emit_ref.ts)：用 `customRef` 把 `props[key]` 包成可写 ref，set 时 `emit('update:key', val)`。

```ts
const emitValue = emitRef(props, emit, "modelValue")   // 读 props.modelValue，写触发 update:modelValue
const emitMultiple = emitRef(props, emit, "multiple")
// 移植到其他项目时：若 Vue 版本无 customRef，改用 computed get/set 等价实现
```

---

## 7. 迁移 / 移植适配点

| 项 | 本项目（Vue3 + Element Plus） | Vue2 + Element UI |
|----|------------------------------|-------------------|
| 双向绑定 | `emitRef`（customRef） | Options API：`modelValue` + `this.$emit('update:modelValue')` 或 `.sync` |
| 弹窗 | `v-model` + `append-to-body` | `:visible.sync` |
| 页签 | `el-tabs` / `el-tab-pane` | 相同 |
| 树组件 | `TreePanel`（项目自研） | 需一并移植 `TreePanel`，或换 `el-tree` 内联 |
| 图标 | `@element-plus/icons-vue` | 字体图标 `el-icon-xxx` |
| 多语言 | `$t()` / `translate()` | `this.$t()` |
| 本地缓存 | `@/utils/cache`（TTL+lock） | 需一并移植或换 localStorage 封装 |
| 接口层 | `@/api/system/user` + `request` | 换 `src/utils/request.js` |

**移植清单（缺一不可）**：`User/select.vue`、`User/table.vue`、`TreePanel/index.vue`、`utils/emit_ref.ts`、`utils/cache.ts`、接口函数、i18n 的 `user.*` / `dept.*` / `demo.*` 文案、`sys_user` 与 `sys_dept` 的读取权限（对应 `/system/user/list`、`/system/user/deptTreeAll`、`/system/recently/*`）。

`TreePanel` 必须带全三项能力，否则树联动会残缺：关键字搜索、全展开/收起、拖拽调宽；列表联动依赖其 `@node-click` 事件，若替换为原生 `el-tree`，需自行补齐同名事件契约。

---

## 8. 已知限制（使用前必须告知调用方）

1. **非纯组件**：强依赖 `/system/recently/*`、`/system/user/listTop`、`/system/user/deptTreeAll` 三组后端接口，移植必须带后端
2. **部门模式的列表不走接口**：由部门树本地扁平化推导，仅支持"当前选中节点 + 直接子级"（`getListDeptTree`），无分页
3. **`userCheck` 是对象 map**：遍历顺序按 key 插入序，不要改成数组（会丢去重语义）
4. **触发层恒为 `multiple`**：单选靠内部只放一个 id，别改成 `multiple=false`（会导致回显与 `collapse-tags` 逻辑错乱）
5. **`quick` 单选无确认步骤**：点行即提交并写最近联系人，误触成本高，慎重默认开启
6. **窗口 resize 监听**：新增类似监听必须在 `onBeforeUnmount` 清理
7. **最近联系人按 `dataType` 分池**：选人与选部门各自独立记忆

---

## 9. 生成 / 改造时的检查清单

- [ ] 六个 props 全部通过 `emitRef`（或等价 computed）双向绑定
- [ ] `department` 切换时：字典源、`dataType`、树数据源、表格 `user-dict` 四处同步切换
- [ ] `onOpen()` 做了字符串→数字 id 规整，兼容混用类型
- [ ] 已选用 map（`U${id}` key）实现去重与单个删除
- [ ] 字典反查失败时红字回显原值，不抛异常
- [ ] 树点击→列表过滤为本地推导，无额外请求
- [ ] 确认后 POST 更新最近联系人，失败不阻塞关弹窗
- [ ] `quick && !multiple` 隐藏确认按钮、点行即确认
- [ ] 弹窗高度自适应 + resize 监听已清理
- [ ] 部门树经 `filterDisabledDept` 递归剔除禁用项
- [ ] 10 秒 TTL 缓存（`cache`）与并发 lock
- [ ] 全部函数含中文注释（含 `@param`/`@returns`，项目规范）
- [ ] i18n 文案齐全（`user.*`、`dept.*`、`common.*`）

---

## 10. 质量要求

- **单一事实来源**：所有显示/搜索/回填都从字典反查，禁止在模板里直接访问原始行数据
- **零重复请求**：`cache()` + 快照回退，打开弹窗不重复拉部门树
- **类型容错**：id 允许 string/number 混用，入口统一 `getInt`
- **可配置**：单/多选、人/部门、快速模式、折叠标签数全部由 props 控制
- **无业务耦合**：组件内不出现具体部门名、岗位名、权限串；接口通过函数注入或集中于 `api/` 层
- **生命周期干净**：resize 监听、弹窗状态在卸载时释放
