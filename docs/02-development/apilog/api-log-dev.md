# 开发文档 - 接口日志（ruoyi-apilog）

> 中文名称：接口日志功能开发文档

> 作者：AI 回溯补录（基于 `ruoyi-apilog` 模块代码）| 日期：2026-11-17 | 关联需求：[接口日志功能需求文档](../../01-requirements/apilog/api-log-prd.md)
>
> ⚠️ 本文档为事后回溯：模块已实现，本文描述以现有代码为准。

## 1. 技术方案概述

- 方案简述：独立业务模块 `ruoyi-apilog` 双向采集接口报文——**入站**由全局过滤器 `ApiInboundLogFilter` 拦截请求记录，**出站**由统一客户端 `ExternalApiClient` 调用时记录；两者均经 `ApiLogExecutor` 线程池**异步落库**，敏感字段脱敏、超长截断；管理端在「系统监控」下分页查询、删除、清空。

## 2. 架构 / 模块设计

- 涉及模块（包结构按 project-rules §3.1）：

```
ruoyi-apilog/
├── controller/  SysInboundLogController、SysOutboundLogController   # 查询/删除（BaseController）
├── domain/      SysInboundLog、SysOutboundLog
├── mapper/      SysInboundLogMapper、SysOutboundLogMapper           # XML 在 resources/mapper/apilog/
├── service/     IXxxService + Impl（record 走异步线程池）
├── utils/       ApiLogExecutor（线程池）、ApiLogUtils（脱敏/截断/JSON/堆栈）、ExternalApiClient（HTTP 客户端）
└── web/         ApiInboundLogFilter（OncePerRequestFilter，@Component + @Order(LOWEST_PRECEDENCE)）
```

- 依赖关系：依赖 `ruoyi-common`（BaseController、SecurityUtils 等）；框架不反向依赖本模块。
- 数据流向：

```
入站：请求 → ApiInboundLogFilter（排除路径过滤 → ApiLogUtils 脱敏/截断 → 组装 SysInboundLog）
         → ISysInboundLogService.record → ApiLogExecutor.submit(异步) → INSERT sys_inbound_log

出站：业务代码 → ExternalApiClient.get/postJson/postForm → execute()（HttpClient 收响应/捕获异常）
         → ISysOutboundLogService.record → ApiLogExecutor.submit(异步) → INSERT sys_outbound_log
         → 非 2xx 抛 ServiceException("调用接口[接口名]失败：HTTP xxx")
```

## 3. 接口设计

入站（`/monitor/inboundLog`，监控目录菜单 `apilog/inboundLog/index`）：

| 接口 | 方法 | 路径 | 说明 |
|------|------|------|------|
| 列表 | GET | /monitor/inboundLog/list | 分页，`monitor:inboundLog:list` |
| 详情 | GET | /monitor/inboundLog/{inboundId} | `:query` |
| 删除 | DELETE | /monitor/inboundLog/{inboundIds} | 逗号分隔多 ID，`:remove`，`@Log` |
| 清空 | DELETE | /monitor/inboundLog/clean | 全量清空，`:remove`，`@Log` |

出站（`/monitor/outboundLog`，菜单 `apilog/outboundLog/index`）：路径与入站对称（`/{outboundId}`、`/{outboundIds}`、`/clean`），权限串 `monitor:outboundLog:*`。

## 4. 数据模型

`sys_inbound_log`（入站，主键 `inbound_id` IDENTITY）关键字段：

| 字段 | 类型 | 说明 |
|------|------|------|
| interface_name / interface_url | nvarchar(200/1000) | 接口名、完整 URL（截断 1000） |
| request_header_parameter | nvarchar(2000) | 白名单请求头 JSON |
| request_body_parameter | nvarchar(max) | 请求体（脱敏 + 按 max-content-length 截断） |
| request_method / request_status | nvarchar(10/20) | HTTP 方法、状态 |
| response_content / response_time | nvarchar(max) / bigint | 响应体（脱敏截断）、耗时 |
| stacktrace | nvarchar(max) | 异常堆栈（截断） |
| ip / referer / user_agent | nvarchar | 客户端信息（referer/UA 截断 500） |
| object_version_number / request_id / program_id / created_by… | — | EBS 风格审计字段 |

`sys_outbound_log`（出站，主键 `outbound_id` IDENTITY）：`interface_name`、`interface_url`、`request_time`、`request_parameter`、`request_status`、`response_content`、`response_time`、`response_code`、`stacktrace` 及同款审计字段。

- 索引：`idx_sys_outbound_log_time(request_time DESC)`、`idx_sys_outbound_log_name(interface_name)`；入站同构（按时间/接口名建索引）。
- 建表脚本：[sys_interface_log.sql](../../../ruoyi-apilog/src/main/resources/sql/apilog/sys_interface_log.sql)；菜单：[sys_interface_log_menu.sql](../../../ruoyi-apilog/src/main/resources/sql/apilog/sys_interface_log_menu.sql)（挂在系统监控父目录 108 下）。

## 5. 关键实现要点

- **异步落库**：`record()` 单条 INSERT 无事务（规则 §3.6 事务豁免），提交至 `ApiLogExecutor`（ArrayBlockingQueue 线程池，`@PreDestroy` 平滑关闭），主线程不等待——日志失败不影响业务响应。
- **配置开关**：`api-log.inbound.enabled`、`api-log.inbound.max-content-length`（默认 8000 字符）。
- **排除路径**：`EXCLUDE_PREFIXES` 覆盖 `/login`、`/logout`、`/captchaImage`、`/getInfo`、静态资源、`/error`、`/actuator`、`/druid`、日志接口自身（`/monitor/inboundLog`、`/monitor/outboundLog`）等，避免日志记录日志查询本身造成噪音/递归。
- **安全脱敏**：`ApiLogUtils.maskSensitive` 对请求体、响应体统一脱敏后再落库（安全红线：日志不得出现明文口令/密钥）。
- **报文保护**：`truncate` 统一按阈值截断（URL 1000、头 2000、体 max-content-length），防止 nvarchar(max) 膨胀与页面卡顿。
- **出站错误语义**：`ExternalApiClient` 非 2xx 抛 `ServiceException`（含接口名），异常同时落 `stacktrace`——日志与向上抛互不吞并。

## 6. 异常与边界处理

- 过滤器内部任何异常不得中断请求链路（记录失败降级为告警日志）。
- 线程池队列打满：`submit` 按拒绝策略处理（以代码为准，必要时监控队列水位）。
- 响应体读取采用包装流方式，不破坏原响应写出。
- 非 2xx / 网络异常 / 超时：出站日志分别记录 `response_code` 或堆栈后抛业务异常。
- **已知缺口**：菜单组件 `apilog/inboundLog/index`、`apilog/outboundLog/index` 对应前端页面与 API JS 尚未开发，当前点击菜单白屏（见 §8 待办）。

## 7. 测试要点

- [ ] 正常流程：调业务接口后 `sys_inbound_log` 有记录；`ExternalApiClient` 调通后 `sys_outbound_log` 有记录
- [ ] 边界条件：超长请求体被截断且落库成功；排除路径（登录等）不产生记录；`api-log.inbound.enabled=false` 时不采集
- [ ] 异常情况：接口 500 时堆栈入日志且业务返回不受影响；出站非 2xx 抛 `ServiceException`；日志查询/删除/清空按权限生效
- [ ] 安全：响应中的密码类字段以脱敏形态落库
- [ ] 性能：日志写入开启时接口 RT 无可感知劣化（异步生效）

## 8. 关联文档

- 需求：[接口日志功能需求文档](../../01-requirements/apilog/api-log-prd.md)
- 相关方案：[外部系统接口对接方案](../external-api/external-integration-plan.md)
- **待办**：
  1. 补前端 `ruoyi-ui/src/views/apilog/inboundLog/index.vue`、`outboundLog/index.vue` 及 `src/api` 对应接口文件（Vue2 + Element UI 规范）
  2. `ExternalApiClient` 首批业务接入点确认
  3. 日志定时清理任务（quartz）评估
