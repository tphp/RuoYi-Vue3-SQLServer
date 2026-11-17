# sql/ 脚本索引

> **目录定位**：仓库根 `sql/` 只存放**框架初始化 / 系统表**脚本；业务模块脚本放各模块 `src/main/resources/sql/<module>/`（规则见 `.trae/rules/project-rules.md` §5）。
> **方言约束**：主库为 SQL Server，新脚本必须先过 `.trae/skills/sqlserver-compat-check/SKILL.md` 校验；表名 `sys_` 前缀，索引名 `idx_<表名>_<字段名>`。

## 根目录脚本（按执行顺序）

| 顺序 | 脚本 | 方言 | 用途 | 注意 |
|---|---|---|---|---|
| 1 | `sqlserver.sql` | SQL Server | 新库全量初始化：若依框架表 + 系统菜单/字典/岗位 + Quartz 调度表（小写 `qrtz_*`）+ `sys_api_key`（末尾） | 仅空库首次执行 |
| 2 | `quartz_sqlserver.sql` | SQL Server | Quartz 调度表 `QRTZ_*` 独立脚本 | ⚠️ **开头含 DROP TABLE**，会删除已存在的调度表并重建，仅在需重建时执行，执行前确认无运行中的调度 |
| 3 | `datadict_menu.sql` | SQL Server | 「数据字典」功能菜单（挂系统管理下，`system:datadict`，组件 `system/datadict/index`） | 纯增量脚本，**重复执行会插重菜单** |

## 模块业务脚本

| 位置 | 脚本 | 用途 |
|---|---|---|
| `ruoyi-bizperm/src/main/resources/sql/bizperm/` | `bizperm_init_all.sql`（一键初始化合并脚本）、`sys_biz_perm_policy.sql`（策略主表）、`sys_biz_perm_scope.sql`（可见范围表）、`sys_menu_bizperm.sql`（菜单 2100~2104）、`sys_dict_bizperm.sql`（场景字典） | 业务权限 2 表设计（policy + scope），菜单与字典数据 |
| `ruoyi-apilog/src/main/resources/sql/apilog/` | `sys_interface_log.sql` | 出站 `sys_outbound_log` / 入站 `sys_inbound_log` 接口日志表 |
| 同上 | `sys_interface_log_menu.sql` | 接口日志菜单（挂「日志管理」108 下，`monitor:outboundLog` / `monitor:inboundLog`） |

## 历史变更

- **2026-11-17**
  - `sys_interface_log.sql`、`sys_interface_log_menu.sql` 从根目录移入 `ruoyi-apilog` 模块（符合 §5「模块业务脚本进模块」）
  - 删除 MySQL 方言的 `ry_20260417.sql`、`quartz.sql`（含 `ENGINE=`、反引号、`now()/sysdate()`，与 SQL Server 主库不兼容且全仓库无引用；如需查阅用 `git log -- sql/` 找回）
