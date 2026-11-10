-- =============================================================
-- 业务级权限：初始化合并脚本（可重复执行 / 幂等）
-- 数据库：SQL Server（目标库 smc_ebs）
-- 来源：sys_biz_perm_policy.sql、sys_biz_perm_scope.sql、
--       sys_menu_bizperm.sql、sys_dict_bizperm.sql
-- 说明：
--   1. 每一步都做了存在性判断，重复执行不会报错、不会产生重复数据
--   2. 菜单 ID 2100~2104 若已被占用，会自动跳过对应行（执行后请核对）
--   3. 建议先在测试库执行；执行前请备份
--
-- 执行方式：
--   A) SSMS：打开本文件，确认当前库为 smc_ebs，直接执行（SSMS 默认 QUOTED_IDENTIFIER ON）
--   B) sqlcmd：必须带 -I（QUOTED_IDENTIFIER ON）和 -f 65001（UTF-8，否则中文注释会导致解析错误）
--      sqlcmd -S 192.168.99.34 -d smc_ebs -U ekp -P "密码" -I -f 65001 -i "本文件路径"
-- =============================================================

SET NOCOUNT ON;
SET XACT_ABORT ON;
-- 筛选唯一索引要求以下 SET 选项为指定值（sqlcmd 默认 QUOTED_IDENTIFIER 为 OFF，必须显式打开）
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
SET ANSI_PADDING ON;
SET ANSI_WARNINGS ON;
SET ARITHABORT ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET NUMERIC_ROUNDABORT OFF;
GO

/* -------------------------------------------------------------
   1. 权限策略主表 sys_biz_perm_policy
   ------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_biz_perm_policy' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE [dbo].[sys_biz_perm_policy] (
        [id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [policy_code] nvarchar(64) NOT NULL,
        [policy_name] nvarchar(100) NOT NULL,
        [subject_type] nvarchar(16) NOT NULL,           -- USER / POST / DEPT
        [subject_value] nvarchar(64) NOT NULL,          -- 工号 / 岗位ID / 部门ID
        [subject_name] nvarchar(100) NULL,
        [include_child] nchar(1) NOT NULL DEFAULT '0',  -- 归属人为部门时是否含下级
        [status] nchar(1) NOT NULL DEFAULT '0',         -- 0启用 1停用
        [remark] nvarchar(500) NULL,
        [create_by] nvarchar(64) NULL,
        [create_time] datetime2(7) NULL DEFAULT getdate(),
        [update_by] nvarchar(64) NULL,
        [update_time] datetime2(7) NULL
    );
    PRINT 'created table: sys_biz_perm_policy';
END
ELSE
    PRINT 'exists table: sys_biz_perm_policy';
GO

-- 同一场景下，同一权限归属人只允许一条“启用”记录（停用记录不占唯一键）
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'uk_biz_perm_policy'
               AND object_id = OBJECT_ID('dbo.sys_biz_perm_policy'))
BEGIN
    CREATE UNIQUE INDEX [uk_biz_perm_policy]
        ON [dbo].[sys_biz_perm_policy] ([policy_code], [subject_type], [subject_value])
        WHERE [status] = '0';
    PRINT 'created index: uk_biz_perm_policy';
END
ELSE
    PRINT 'exists index: uk_biz_perm_policy';
GO

-- 按归属人反查策略（登录人计算可见范围）
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_biz_perm_policy_subject'
               AND object_id = OBJECT_ID('dbo.sys_biz_perm_policy'))
BEGIN
    CREATE INDEX [idx_biz_perm_policy_subject]
        ON [dbo].[sys_biz_perm_policy] ([subject_type], [subject_value], [status]);
    PRINT 'created index: idx_biz_perm_policy_subject';
END
ELSE
    PRINT 'exists index: idx_biz_perm_policy_subject';
GO

-- 按场景查询策略（树、列表）
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_biz_perm_policy_code'
               AND object_id = OBJECT_ID('dbo.sys_biz_perm_policy'))
BEGIN
    CREATE INDEX [idx_biz_perm_policy_code]
        ON [dbo].[sys_biz_perm_policy] ([policy_code], [status]);
    PRINT 'created index: idx_biz_perm_policy_code';
END
ELSE
    PRINT 'exists index: idx_biz_perm_policy_code';
GO

/* -------------------------------------------------------------
   2. 可见范围明细表 sys_biz_perm_scope
   ------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_biz_perm_scope' AND schema_id = SCHEMA_ID('dbo'))
BEGIN
    CREATE TABLE [dbo].[sys_biz_perm_scope] (
        [id] bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
        [policy_id] bigint NOT NULL,
        [scope_type] nvarchar(16) NOT NULL,             -- USER / POST / DEPT
        [scope_value] nvarchar(64) NOT NULL,            -- 工号 / 岗位ID / 部门ID
        [scope_name] nvarchar(100) NULL,
        [include_child] nchar(1) NOT NULL DEFAULT '0',  -- 部门范围是否含下级
        [order_num] int NOT NULL DEFAULT 0,
        [create_by] nvarchar(64) NULL,
        [create_time] datetime2(7) NULL DEFAULT getdate(),
        [update_by] nvarchar(64) NULL,
        [update_time] datetime2(7) NULL
    );
    PRINT 'created table: sys_biz_perm_scope';
END
ELSE
    PRINT 'exists table: sys_biz_perm_scope';
GO

-- 同一策略下，同一范围只允许一行
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'uk_biz_perm_scope'
               AND object_id = OBJECT_ID('dbo.sys_biz_perm_scope'))
BEGIN
    CREATE UNIQUE INDEX [uk_biz_perm_scope]
        ON [dbo].[sys_biz_perm_scope] ([policy_id], [scope_type], [scope_value]);
    PRINT 'created index: uk_biz_perm_scope';
END
ELSE
    PRINT 'exists index: uk_biz_perm_scope';
GO

-- 树与可见范围展开
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_biz_perm_scope_policy'
               AND object_id = OBJECT_ID('dbo.sys_biz_perm_scope'))
BEGIN
    CREATE INDEX [idx_biz_perm_scope_policy]
        ON [dbo].[sys_biz_perm_scope] ([policy_id], [scope_type], [order_num]);
    PRINT 'created index: idx_biz_perm_scope_policy';
END
ELSE
    PRINT 'exists index: idx_biz_perm_scope_policy';
GO

/* -------------------------------------------------------------
   3. 菜单与按钮权限 sys_menu（2100 菜单 + 2101~2104 按钮）
   ------------------------------------------------------------- */
SET IDENTITY_INSERT [dbo].[sys_menu] ON;
GO

IF NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2100)
BEGIN
    INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
    VALUES ('2100', '业务权限', '1', '10', 'bizperm', 'bizperm/policy/index', '', '', 1, 0, 'C', '0', '0', 'bizperm:policy:list', 'lock', 'admin', getdate(), '', NULL, '业务级权限菜单');
    PRINT 'inserted menu: 2100';
END
ELSE
    PRINT 'skipped menu 2100: id already exists';
GO

-- 菜单名称统一调整为「业务权限」
UPDATE [dbo].[sys_menu] SET [menu_name] = '业务权限' WHERE [menu_id] = 2100 AND [menu_name] <> '业务权限';
GO

IF NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2101)
BEGIN
    INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
    VALUES ('2101', '权限查询', '2100', '1', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:query', '#', 'admin', getdate(), '', NULL, '');
    PRINT 'inserted menu: 2101';
END
ELSE
    PRINT 'skipped menu 2101: id already exists';
GO

IF NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2102)
BEGIN
    INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
    VALUES ('2102', '权限新增', '2100', '2', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:add', '#', 'admin', getdate(), '', NULL, '');
    PRINT 'inserted menu: 2102';
END
ELSE
    PRINT 'skipped menu 2102: id already exists';
GO

IF NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2103)
BEGIN
    INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
    VALUES ('2103', '权限修改', '2100', '3', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:edit', '#', 'admin', getdate(), '', NULL, '');
    PRINT 'inserted menu: 2103';
END
ELSE
    PRINT 'skipped menu 2103: id already exists';
GO

IF NOT EXISTS (SELECT 1 FROM sys_menu WHERE menu_id = 2104)
BEGIN
    INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark])
    VALUES ('2104', '权限删除', '2100', '4', '', '', '', '', 1, 0, 'F', '0', '0', 'bizperm:policy:remove', '#', 'admin', getdate(), '', NULL, '');
    PRINT 'inserted menu: 2104';
END
ELSE
    PRINT 'skipped menu 2104: id already exists';
GO

SET IDENTITY_INSERT [dbo].[sys_menu] OFF;
GO

/* -------------------------------------------------------------
   4. 业务场景字典 biz_perm_policy
   ------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM sys_dict_type WHERE dict_type = 'biz_perm_policy')
BEGIN
    INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
    VALUES (N'业务权限场景', N'biz_perm_policy', '0', N'admin', getdate(), N'业务级权限场景编码');
    PRINT 'inserted dict_type: biz_perm_policy';
END
ELSE
    PRINT 'exists dict_type: biz_perm_policy';
GO

IF NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_perm_policy' AND dict_value = N'customer:view')
BEGIN
    INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
    VALUES (1, N'客户查看范围', N'customer:view', N'biz_perm_policy', '', 'primary', 'N', '0', N'admin', getdate(), N'');
    PRINT 'inserted dict_data: customer:view';
END
ELSE
    PRINT 'exists dict_data: customer:view';
GO

IF NOT EXISTS (SELECT 1 FROM sys_dict_data WHERE dict_type = 'biz_perm_policy' AND dict_value = N'contract:view')
BEGIN
    INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
    VALUES (2, N'合同查看范围', N'contract:view', N'biz_perm_policy', '', 'primary', 'N', '0', N'admin', getdate(), N'');
    PRINT 'inserted dict_data: contract:view';
END
ELSE
    PRINT 'exists dict_data: contract:view';
GO

/* -------------------------------------------------------------
   5. 执行结果自检（把这段的查询结果贴回来即可核对）
   ------------------------------------------------------------- */
PRINT '===== 1) 业务表 =====';
SELECT 'sys_biz_perm_policy' AS expected_table, CASE WHEN EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_biz_perm_policy' AND schema_id = SCHEMA_ID('dbo')) THEN 'OK' ELSE 'MISSING' END AS result
UNION ALL
SELECT 'sys_biz_perm_scope', CASE WHEN EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_biz_perm_scope' AND schema_id = SCHEMA_ID('dbo')) THEN 'OK' ELSE 'MISSING' END;
GO

PRINT '===== 2) 索引 =====';
SELECT OBJECT_NAME(object_id) AS table_name, name AS index_name,
       CASE WHEN is_unique = 1 THEN 'UNIQUE' ELSE 'NON-UNIQUE' END AS kind,
       CASE WHEN has_filter = 1 THEN filter_definition ELSE '' END AS filter
FROM sys.indexes
WHERE name IN ('uk_biz_perm_policy', 'idx_biz_perm_policy_subject', 'idx_biz_perm_policy_code',
               'uk_biz_perm_scope', 'idx_biz_perm_scope_policy')
ORDER BY table_name, index_name;
GO

PRINT '===== 3) 菜单与按钮 =====';
SELECT menu_id, menu_name, parent_id, menu_type, perms, status
FROM sys_menu WHERE menu_id BETWEEN 2100 AND 2104 ORDER BY menu_id;
GO

PRINT '===== 4) 场景字典 =====';
SELECT dict_type, dict_name, status FROM sys_dict_type WHERE dict_type = 'biz_perm_policy';
SELECT dict_sort, dict_label, dict_value, status FROM sys_dict_data
WHERE dict_type = 'biz_perm_policy' ORDER BY dict_sort;
GO

PRINT '===== 全部脚本执行结束 =====';
GO
