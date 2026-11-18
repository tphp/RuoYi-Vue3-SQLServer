# sql/ 脚本索引

> **目录定位**：仓库根 `sql/` 只存放**框架初始化 / 系统表**脚本；业务模块脚本放各模块 `src/main/resources/sql/<module>/`（规则见 `.trae/rules/project-rules.md` §5）。
> **方言约束**：主库为 SQL Server，新脚本必须先过 `.trae/skills/sqlserver-compat-check/SKILL.md` 校验；表名 `sys_` 前缀，索引名 `idx_<表名>_<字段名>`。

## 根目录脚本（按执行顺序）

| 顺序 | 脚本 | 方言 | 用途 | 注意 |
|---|---|---|---|---|
| 1 | `sqlserver.sql` | SQL Server | 新库全量初始化：若依框架表 + 系统菜单/字典/岗位 + Quartz 调度表（小写 `qrtz_*`）+ `sys_api_key`（末尾） | 仅空库首次执行 |
| 2 | `quartz_sqlserver.sql` | SQL Server | Quartz 调度表 `QRTZ_*` 独立脚本 | ⚠️ **开头含 DROP TABLE**，会删除已存在的调度表并重建，仅在需重建时执行，执行前确认无运行中的调度 |
| 3 | `datadict_menu.sql` | SQL Server | 「数据字典」功能菜单（挂系统管理下，`system:datadict`，组件 `system/datadict/index`） | 纯增量脚本，**重复执行会插重菜单** |

## 存量库升级脚本（幂等，可重复执行）

针对**已有存量库**的增量升级脚本，均先判断列是否存在再加列，可放心重复执行；用 `sqlserver.sql` 全量重建的新库已含对应列，脚本会自动跳过。

| 脚本 | 用途 | 注意 |
|---|---|---|
| `menu_name_en_backfill.sql` | `sys_menu` 增加 `menu_name_en`（菜单英文名）列，并为存量系统菜单（目录/菜单/按钮、编号规则等）补全英文名，实现英文界面下菜单双语 | 补数据只更新英文名为空的记录；未覆盖的自定义菜单英文保持为空，后端路由自动回退中文名（见 [系统国际化功能需求文档](../docs/01-requirements/common/i18n/i18n-prd.md)）；含回滚语句 |
| `sys_user_fd_short_no_backfill.sql` | `sys_user` 增加 `fd_short_no`（上级工号，直接上级的 usercode）列 | 列允许为空，历史用户数据无需回填 |

## 参考脚本（MySQL 方言，不在主库执行）

| 脚本 | 方言 | 用途 | 注意 |
|---|---|---|---|
| `ry_20260417.sql` | MySQL | 若依官方全量建表脚本的对照参考版，已同步本仓库最新结构（`menu_name_en` 菜单英文列及初始数据、`fd_short_no` 上级工号列） | ⚠️ 含 `ENGINE=innodb`、`auto_increment`、`sysdate()` 等 MySQL 专属语法，**禁止在 SQL Server 主库执行**；主库初始化/升级一律用 `sqlserver.sql` 与上述幂等脚本 |

## 模块业务脚本

| 位置 | 脚本 | 用途 |
|---|---|---|
| `ruoyi-bizperm/src/main/resources/sql/bizperm/` | `bizperm_init_all.sql`（一键初始化合并脚本）、`sys_biz_perm_policy.sql`（策略主表）、`sys_biz_perm_scope.sql`（可见范围表）、`sys_menu_bizperm.sql`（菜单 2100~2104）、`sys_dict_bizperm.sql`（场景字典） | 业务权限 2 表设计（policy + scope），菜单与字典数据 |
| `ruoyi-apilog/src/main/resources/sql/apilog/` | `sys_interface_log.sql` | 出站 `sys_outbound_log` / 入站 `sys_inbound_log` 接口日志表 |
| 同上 | `sys_interface_log_menu.sql` | 接口日志菜单（挂「日志管理」108 下，`monitor:outboundLog` / `monitor:inboundLog`） |

## 历史变更

- **2026-11-18**
  - 新增 `menu_name_en_backfill.sql`：`sys_menu` 菜单英文名列 + 存量菜单英文补全（幂等）
  - 新增 `sys_user_fd_short_no_backfill.sql`：`sys_user` 上级工号列（幂等）
  - `sqlserver.sql` 全量脚本已包含 `menu_name_en`、`fd_short_no` 列定义、注释及系统菜单英文初始数据
  - `ry_20260417.sql` 经使用方提交恢复为最新版（同步 `menu_name_en` 列及菜单英文初始数据、`fd_short_no` 列），登记为 **MySQL 方言参考脚本**（不用于 SQL Server 主库执行；此前 2026-11-17 曾随 MySQL 方言清理删除）
- **2026-11-17**
  - `sys_interface_log.sql`、`sys_interface_log_menu.sql` 从根目录移入 `ruoyi-apilog` 模块（符合 §5「模块业务脚本进模块」）
  - 删除 MySQL 方言的 `ry_20260417.sql`、`quartz.sql`（含 `ENGINE=`、反引号、`now()/sysdate()`，与 SQL Server 主库不兼容且全仓库无引用；如需查阅用 `git log -- sql/` 找回）
