---
name: "input-select-picker"
description: "生成或改造「可输可选」选择器组件：文本框可自由输入并模糊建议，点击图标弹出表格选择。当用户需要输入+选择二合一、把这类组件抽成通用组件、或将其移植到 Vue2 项目时使用。"
---

> 中文名称：可输可选选择器组件

# 可输可选选择器组件（Input-Select Picker）

## 1. 组件定位

**适用场景**
- 值域较大（几百到几千条），用户可能记得名称，也可能只想浏览挑选
- 既要允许手工输入（如编码、名称），又要能从列表精确选取
- 需要一个统一的"选人 / 选部门 / 选物料 / 选编码"交互，多页面复用

**不适用（改用其他方案）**
| 场景 | 替代方案 |
|------|----------|
| 选项固定且少（<20） | `el-select` + `allow-create` + `default-first-option` |
| 从组织架构中选**用户 / 部门**（需最近联系人、组织树联动） | `user-dept-picker`（选人/选部门弹窗选择器） |
| 必须多选 | 需扩展为多选模式（见第 7 节） |
| 数据量超万条、需要服务端分页 | 改为远程 `remote-method` 搜索方案 |

**核心设计原则**：组件只做交互与过滤，**不绑定任何业务接口**；数据一律由调用方通过 `request` 属性注入。

> 现状：本组件已在 `main.ts` 全局注册为 `RemoteSelect`，但仓库内暂无业务页面引用；接入时按第 3 节契约传入 `request` / `columns` / `filters`，并自行监听 `select` 保存主键。

---

## 2. 组件结构解剖（四层）

```
┌─ 输入层  el-autocomplete（可输入、可清空）
│    └─ 建议层  #default 插槽：主字段 + 副字段（编码/编号）
│    └─ 入口层  #suffix 插槽：搜索图标 → 打开弹窗
└─ 弹窗层  el-dialog（append-to-body）
     ├─ 筛选区  filters 配置驱动，动态生成 el-input，AND 过滤
     └─ 结果区  columns 配置驱动，el-table 行点击即选中并关闭
```

| 层 | 职责 | 关键实现 |
|----|------|----------|
| 输入层 | 承载文本、回车/选择触发 | `v-model` 双向绑定父组件，`trigger-on-focus=false` 避免空输入弹全量 |
| 建议层 | 输入时展示模糊匹配 | `fetch-suggestions`，每条需带 `value` 字段供组件回填 |
| 入口层 | 大列表兜底选择 | `#suffix` 插槽 + `@click.stop`，避免触发输入框默认行为 |
| 弹窗层 | 多条件筛选 + 表格挑选 | `append-to-body`（防父容器 overflow 遮挡）；`highlight-current-row` |

---

## 3. 对外契约（必须保持一致）

### Props

| 属性 | 类型 | 默认 | 说明 |
|------|------|------|------|
| `modelValue` | `string` | `''` | 选中值，**存文本而非主键** |
| `request` | `Function` | `null` | 数据请求函数，返回数组或 `{data:[]}`/`{rows:[]}` |
| `valueField` | `string` | `'name'` | 回填到 `modelValue` 的字段 |
| `searchFields` | `string[]` | `[]` | 输入模糊匹配参与字段 |
| `suggestFields` | `string[]` | `[]` | 下拉建议显示 `[主字段, 副字段?]` |
| `columns` | `ColumnConfig[]` | `[]` | 弹窗表格列 `{prop,label,width?,minWidth?}` |
| `filters` | `FilterConfig[]` | `[]` | 弹窗筛选 `{field,label,placeholder?,fields?}` |
| `placeholder` / `title` / `disabled` | `string`/`string`/`boolean` | `translate('common.inputPlaceholder')` / `translate('common.selectPlaceholder')` / `false` | 文案与禁用；移植时需带上 `common.*` i18n key |

### Events

| 事件 | 载荷 | 用途 |
|------|------|------|
| `update:modelValue` | `string` | 支持 `v-model` |
| `select` | 整行对象 | 需要主键/编码时从整行取，**不要指望 `modelValue` 带 id** |

> ⚠️ 契约红线：`modelValue` 只存文本。若业务需要 id，必须监听 `select` 自行保存整行，不要改成存 id——否则输入框会显示成主键。

---

## 4. 数据流与缓存策略

```
request() ──► parseList() ──► list（全量）
                                ├─ filterByKeyword(kw) ──► 下拉建议（输入时）
                                └─ applyFilter()       ──► dialogList（弹窗内）
```

关键点：

1. **`parseList` 兼容三种返回结构**：`[]`、`{data:[]}`、`{rows:[]}`，避免调用方适配后端
2. **`WeakMap` 按 `request` 函数缓存全量数据**：同一页面多个实例共用同一 request 时只请求一次；`request` 作 key，组件销毁自动回收，无内存泄漏
3. **`pendingCache` 并发去重**：同一 request 并发调用时复用同一个 Promise，避免重复请求
4. **失败降级**：请求异常时 `list` 置空、`dialogList` 置空，不抛断页面（仅 `console.error` 记录）
5. **过滤统一小写 + `null` 安全**：`String(v).toLowerCase().includes(kw)`，`null`/`undefined` 直接跳过

---

## 5. 实现骨架（可直接复制改写）

```vue
<template>
  <div class="remote-select">
    <el-autocomplete
      v-model="inputValue"
      :fetch-suggestions="querySearch"
      :trigger-on-focus="false"
      :placeholder="placeholder"
      :disabled="disabled"
      clearable
      style="width: 100%"
      @select="handleSelect"
      @input="handleInput"
    >
      <template #default="{ item }">
        <div class="remote-select__option">
          <span>{{ item[suggestFields[0]] }}</span>
          <span v-if="suggestFields[1]" class="remote-select__code">{{ item[suggestFields[1]] }}</span>
        </div>
      </template>
      <template #suffix>
        <el-icon v-if="!disabled" class="remote-select__icon" @click.stop="openDialog">
          <Search />
        </el-icon>
      </template>
    </el-autocomplete>

    <el-dialog v-model="dialogVisible" :title="title" width="720px" append-to-body>
      <!-- 筛选区：filters 动态生成，AND 过滤 -->
      <!-- 结果区：columns 动态生成，row-click 选中 -->
    </el-dialog>
  </div>
</template>
```

核心函数职责（命名保持一致，便于后续替换实现）：

| 函数 | 职责 |
|------|------|
| `parseList(json)` | 统一响应结构为数组 |
| `loadData()` | 缓存命中 → 复用；pending → await；否则请求并写入缓存 |
| `filterByKeyword(kw)` | 空关键字返回 `[]`（**防止空输入弹全量**） |
| `querySearch(qs, cb)` | 映射为 `{value, ...item}` 交给 autocomplete |
| `handleSelect(item)` | 回填文本 + `emit('select', item)` |
| `handleInput(value)` | **唯一匹配自动回填**（`length === 1 && 值不同`） |
| `openDialog()` | 重置筛选 → 打开 → `loadData()` |
| `applyFilter()` | 按 `filters` 逐项 AND 过滤 |
| `handleRowClick(row)` | 选中并关闭弹窗 |

---

## 6. 迁移到其他项目时的适配点

| 项 | 本项目（Vue3 + Element Plus） | Vue2 + Element UI |
|----|------------------------------|-------------------|
| 组件写法 | `<script setup lang="ts">` | Options API：`data()` / `methods` / `props` / `$emit` |
| 双向绑定 | `computed` get/set + `update:modelValue` | `:value` + `@input`（或 `.sync`） |
| 清空/后缀图标 | `#suffix` 插槽 + `el-icon` | 无 suffix 插槽，用 `slot="suffix"` 或输入框后置按钮 |
| 图标 | `@element-plus/icons-vue` | `el-icon-search` 字体图标 |
| 弹窗 | `v-model` | `:visible.sync` |
| 表格行点击 | `@row-click` | `@row-click`（相同） |
| 多语言 | `translate()` / `useI18n` | `this.$t()` |
| 类型 | `interface` 描述配置对象 | 无 TS，用注释声明结构 |

> 移植时**只改语法层**，props 命名、数据流、缓存策略保持不变，保证两端行为一致。

---

## 7. 多选扩展（如业务需要）

1. `modelValue` 改为 `string[]`，或在组件内新增 `multiple` 开关
2. 弹窗表格加 `type="selection"`，底部加"确定"按钮，替代行点击即关闭
3. `emit('select', rows)` 返回数组
4. 输入框展示改为 `标签 + N` 形式（`el-tag` + `+N`）

---

## 8. 已知限制（使用前必须告知调用方）

1. **单选**，不支持多选与分组
2. **前端全量过滤**：数据量建议 ≤ 5000 条，超出改用远程搜索
3. **缓存不失效**：全量数据在页面生命周期内固定，数据频繁变更场景需扩展 `reload()`
4. **首屏预加载**：`onMounted` 即请求（已核实 [index.vue](file:///D:/ebs-web/src/components/RemoteSelect/index.vue#L351-L353)），接口慢会拖页面；改法：把 `loadData()` 从 `onMounted` 移到 `openDialog()` 首次调用，或增加 `lazy` 属性控制

---

## 9. 生成/改造时的检查清单

- [ ] `request` 未传时有空态处理，不报错
- [ ] `parseList` 兼容数组 / `{data}` / `{rows}`
- [ ] 使用 `WeakMap` 缓存 + pending 并发去重
- [ ] 空关键字返回空建议（不弹全量）
- [ ] 唯一匹配自动回填，且与当前值不同才回填
- [ ] 弹窗 `append-to-body`，行点击即选中并关闭
- [ ] `dialogList` 初始化与重置后与 `list` 同步
- [ ] 样式 `scoped`，根节点宽度 100%，不污染全局
- [ ] 不新增后端接口，直接复用已有列表查询接口
- [ ] 全部函数含中文注释，含 `@param` / `@returns`（项目规范）
- [ ] 输入侧过滤不区分大小写、`null` 安全

---

## 10. 质量要求

- **零额外依赖**：只依赖 Element Plus / Element UI 与图标库
- **无业务耦合**：组件内不得出现具体接口路径、字段名、权限串
- **可预测**：所有筛选均在内存完成，不产生额外请求
- **可观测**：请求失败仅 `console.error`，不打断父页面
- **类型友好**：配置对象（columns / filters）用 interface 描述字段含义
