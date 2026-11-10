-- =============================================================
-- 业务级权限：菜单与按钮权限
-- 数据库：SQL Server
-- 执行前请先确认菜单ID未被占用：
--   SELECT MAX(menu_id) FROM sys_menu;
-- =============================================================

SET IDENTITY_INSERT [dbo].[sys_menu] ON;

INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
VALUES ('2100', '业务权限', '1', '10', 'bizperm', 'bizperm/policy/index', '', '', 1, 0, 'C', '0', '0', 'bizperm:policy:list', 'lock', 'admin', getdate(), '', NULL, '业务级权限菜单');

INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
VALUES ('2101', '权限查询', '2100', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:query', '#', 'admin', getdate(), '', NULL, '');

INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
VALUES ('2102', '权限新增', '2100', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:add', '#', 'admin', getdate(), '', NULL, '');

INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
VALUES ('2103', '权限修改', '2100', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:edit', '#', 'admin', getdate(), '', NULL, '');

INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
VALUES ('2104', '权限删除', '2100', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:remove', '#', 'admin', getdate(), '', NULL, '');

SET IDENTITY_INSERT [dbo].[sys_menu] OFF;
GO
