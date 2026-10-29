-- ----------------------------
-- 接口日志功能菜单脚本（SQL Server）
-- 功能：出站接口日志（调用外部接口）、入站接口日志（外部调用本系统）
-- 说明：挂在"日志管理"目录下（parent_id = 108）；重复执行会重复插入菜单，请勿重复执行
-- ----------------------------

-- 1. 出站接口日志菜单
INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('出站接口日志', 108, 3, 'outboundLog', 'apilog/outboundLog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:outboundLog:list', 'upload', 'admin', getdate(), '本系统调用外部接口的日志');

DECLARE @outboundParentId bigint;
SELECT @outboundParentId = SCOPE_IDENTITY();

INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('出站日志查询', @outboundParentId, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'monitor:outboundLog:query', '#', 'admin', getdate(), '');

INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('出站日志删除', @outboundParentId, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'monitor:outboundLog:remove', '#', 'admin', getdate(), '');

-- 2. 入站接口日志菜单
INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('入站接口日志', 108, 4, 'inboundLog', 'apilog/inboundLog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:inboundLog:list', 'download', 'admin', getdate(), '外部系统调用本系统接口的日志');

DECLARE @inboundParentId bigint;
SELECT @inboundParentId = SCOPE_IDENTITY();

INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('入站日志查询', @inboundParentId, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'monitor:inboundLog:query', '#', 'admin', getdate(), '');

INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('入站日志删除', @inboundParentId, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'monitor:inboundLog:remove', '#', 'admin', getdate(), '');

-- 说明：超级管理员角色默认拥有全部权限，无需授权；其他角色请在【系统管理-角色管理】中勾选授权
