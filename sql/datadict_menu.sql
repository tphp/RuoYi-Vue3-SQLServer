-- ----------------------------
-- 数据字典功能菜单脚本（SQL Server）
-- 功能：实时查看数据库所有表结构、字段、类型、长度、外键、索引等信息
-- 使用：连接业务库后直接执行本脚本；重复执行会重复插入菜单，请勿重复执行
-- ----------------------------

-- 1. 数据字典菜单（挂在"系统管理"目录下，parent_id = 1）
INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('数据字典', 1, 12, 'datadict', 'system/datadict/index', '', '', 1, 0, 'C', '0', '0', 'system:datadict:list', 'dict', 'admin', getdate(), '数据库表结构数据字典菜单');

DECLARE @parentId bigint;
SELECT @parentId = SCOPE_IDENTITY();

-- 2. 数据字典查询按钮
INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('数据字典查询', @parentId, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:datadict:query', '#', 'admin', getdate(), '');

-- 3. 数据字典导出按钮
INSERT INTO [dbo].[sys_menu] ([menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [remark])
VALUES ('数据字典导出', @parentId, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:datadict:export', '#', 'admin', getdate(), '');

-- 4. 超级管理员角色默认拥有全部权限，无需授权；如需为其他角色授权，执行后可在【系统管理-角色管理】中勾选
