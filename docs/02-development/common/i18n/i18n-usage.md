# 使用指南 - 系统国际化（i18n）

> 中文名称：系统国际化使用指南

> 作者：AI 回溯补录 | 日期：2026-11-18 | 适用：本后端仓库（各分支项目通用）
>
> 面向对象：业务后端开发（加 key、取文案）、前端开发（语言传递）、联调排障人员。

## 1. 机制速览

```
前端请求带 X-Lang: zh-cn / en
  → 后端 HeaderLocaleResolver 解析本次请求语言（未带则回退 Accept-Language → 默认中文）
  → 代码 MessageUtils.message("key", 参数…) 从 i18n/messages[_en].properties 取对应语言文案
  → 前端展示
```

- 提示文案：资源文件 `ruoyi-admin/src/main/resources/i18n/messages.properties`（中文）+ `messages_en.properties`（英文）
- 菜单名称：走数据库双列（`sys_menu.menu_name` 中文 / `menu_name_en` 英文），路由接口 `meta.title` / `meta.titleEn` 同时下发，英文名空自动回退中文（见第 4 节）
- 文案 key 命名：`<模块>.<场景>`，如 `user.not.exists`、`common.rate.limit`

## 2. 业务后端：如何新增文案

### 步骤 1：双文件同步加 key（缺一不可）

```
# messages.properties（中文）
mq.message.not.exists=消息记录不存在
mq.message.processing=消息处理中，请稍后重试

# messages_en.properties（英文）
mq.message.not.exists=Message record does not exist
mq.message.processing=Message is processing, please try later
```

- key 按模块前缀分段，与所在模块对齐（如 ruoyi-mq 用 `mq.*`，避免与他人冲突）。
- 占位符用 `{0}`、`{1}`，与传参顺序一致：
  ```
  # zh
  mq.retry.limit.count=重试次数已达{0}次
  # en
  mq.retry.limit.count=Retry count has reached {0}
  ```

### 步骤 2：代码中取文案

```java
// 校验失败抛业务异常（最常见用法）
throw new ServiceException(MessageUtils.message("mq.message.not.exists"));

// 带参数
throw new ServiceException(MessageUtils.message("mq.retry.limit.count", retryCount));

// 普通返回文案
String tip = MessageUtils.message("user.logout.success");
```

### 规则（强约束）

1. **禁止硬编码用户可见文案**：新代码不允许 `throw new ServiceException("中文写死")`。
2. **双文件 key 必须对齐**：中文加了英文漏加，英文请求会抛 `NoSuchMessageException`（启动不报错，调用时才炸）。
3. **文件编码 UTF-8**：IDEA 右下角确认；若见 `\uXXXX` 转义可读性差，改用 UTF-8 明文。
4. **改文案只需改 properties，不动 Java 代码**（重启生效；`spring.devtools.restart.enabled: true` 开发环境热加载）。

### 模板速查（复制即用）

| 场景 | 中文 key/文案 | 英文文案 |
|------|--------------|----------|
| 记录不存在 | `xxx.not.exists=记录不存在` | `Record does not exist` |
| 名称已存在 | `xxx.add.name.exists=新增''{0}''失败，名称已存在` | `Add ''{0}'' failed, name already exists` |
| 无权操作 | `xxx.no.permission=没有权限，请联系管理员授权` | `No permission, please contact administrator` |
| 状态不允许 | `xxx.status.not.allow=当前状态不允许该操作` | `Current status does not allow this operation` |

## 3. 前端：如何传语言

- **每个请求**携带自定义头 `X-Lang`，值 `zh-cn`（中文）或 `en`（英文），在 axios/fetch 拦截器统一注入：

```javascript
// 伪代码示例（主前端 xxx-web 仓库实现）
import axios from 'axios'

const instance = axios.create({ baseURL: '/api' })

instance.interceptors.request.use(config => {
  const lang = localStorage.getItem('lang') || 'zh-cn'   // 用户切换语言后存本地
  config.headers['X-Lang'] = lang                         // 自定义头，浏览器可设置
  return config
})
```

- 语言切换 = 改本地存储值，下一次请求生效，无需调后端接口。
- **为什么不改 `Accept-Language`**：fetch 规范保留头，浏览器禁止 JS 覆盖；必须用自定义 `X-Lang`。
- 不传 `X-Lang` 的调用方（Postman、第三方直连）：会回退读 `Accept-Language`，仍为中/英时可用；建议统一带上 `X-Lang` 消除歧义。
- 菜单名称（侧边栏/面包屑，来自动态路由）：前端**无需自己翻译**——`getRouters` 已同时下发 `meta.title`（中文）与 `meta.titleEn`（英文，空自动回退中文），按当前语言取用即可。
- 页面静态文案（按钮、表格标题、表单标签、提示语）：由前端仓库（`xxx-web`）的 i18n 资源维护，本仓库只负责**接口返回文案与菜单名双语下发**。

## 4. 菜单英文名维护（管理员 / DBA）

- **存量库升级**：执行 [`sql/menu_name_en_backfill.sql`](../../../../sql/menu_name_en_backfill.sql)——幂等脚本，先判 `menu_name_en` 列存在才加列、只补英文名为空的记录，可重复执行；用 `sqlserver.sql` 全量重建的新库已含列与英文数据，会自动跳过。
- **日常维护**：系统管理 → 菜单管理 → 新增/编辑菜单时填写「英文名」（`menu_name_en`），目录/菜单/按钮权限同理；补数据脚本未覆盖的自定义菜单也在此补录。
- **空值行为**：未配置英文名的菜单，`getRouters` 下发的 `titleEn` 自动回退为中文名，英文界面显示中文、不会空白。
- **前端取用**：英文界面读 `meta.titleEn`，中文界面读 `meta.title`；脚本说明见 [sql/README.md](../../../../sql/README.md)。

## 5. 排障 FAQ

| 现象 | 原因 | 处理 |
|------|------|------|
| 响应文案显示 key 原文或抛 `NoSuchMessageException` | key 不存在（中文文件漏加） | 补 key，双文件同步 |
| 英文请求报 `NoSuchMessageException`，中文正常 | 英文文件漏加同名 key | 在 `messages_en.properties` 补同名 key |
| 切换英文后文案仍是中文 | 请求未带 `X-Lang`，回退到了浏览器/默认中文 | 检查前端拦截器是否对所有请求统一注入头 |
| `X-Lang` 设置不生效 | 头名拼写错误（大小写不敏感但拼写需 `X-Lang`）、值传了 `ja` 等不支持语言 | 传 `zh-cn` / `en` |
| 中文文案乱码 / 显示 `\uXXXX` | properties 文件编码不是 UTF-8 | IDEA `File Encodings` 统一 UTF-8，另存后重启 |
| 占位符 `{0}` 原样出现在文案里 | 调用未传参或传参数量不符 | 核对 `MessageUtils.message(key, args)` 参数个数与占位符数量 |
| **异步线程/线程池里的文案变成默认中文** | `LocaleContextHolder` 按线程隔离，异步任务不继承请求线程语言 | 异步前在提交处显式传入语言并临时 `setLocale`；或异步逻辑内不拼用户文案，回写时再翻译（推荐） |

## 6. 验证清单（改动后自测）

- [ ] 同一接口分别用 `X-Lang: zh-cn` / `X-Lang: en` 调用，文案均正确
- [ ] 不带 `X-Lang` 直接调用，返回中文（默认语言兜底）
- [ ] 占位符参数填充正确
- [ ] `grep` 确认新代码无硬编码用户可见文案（`ServiceException("中文")` 直接字符串）
- [ ] 双文件 key 数量一致（或用比对脚本全量校验）

## 7. 关联文档

- 需求文档：[系统国际化功能需求文档](../../../01-requirements/common/i18n/i18n-prd.md)
- 开发文档：[系统国际化开发文档](i18n-dev.md)（解析器实现细节、架构说明）
