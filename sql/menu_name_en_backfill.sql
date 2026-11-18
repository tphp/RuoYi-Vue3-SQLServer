-- ============================================================
-- sys_menu 菜单英文名补数据脚本（MSSQL）
--
-- 用途：为存量菜单补充英文名称 menu_name_en，实现英文界面下菜单显示英文
-- 说明：
--   1. 本脚本可重复执行（幂等）：加列语句会先判断列是否存在，补数据只更新 menu_name_en 为空的记录
--   2. 执行前请先备份 sys_menu 表
--   3. 如需回滚，请使用脚本末尾的反向 UPDATE 语句
--   4. 未在列表中的菜单（自定义菜单）保持为空，后端会自动回退显示中文名称
--   5. 若数据库是用 sql/sqlserver.sql 全新重建的（已含该列），加列步骤会自动跳过
--
-- 注意：MSSQL 在编译期即校验列是否存在，因此「加列」与「补数据」必须用 GO 分成两个批次执行
-- ============================================================

SET NOCOUNT ON;

-- ============================================================
-- 步骤 1：增加 menu_name_en 字段（列不存在时才执行）
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[sys_menu]')
      AND name = 'menu_name_en'
)
BEGIN
    PRINT '正在为 sys_menu 表增加 menu_name_en 字段...';
    ALTER TABLE [dbo].[sys_menu] ADD [menu_name_en] nvarchar(100) DEFAULT '' NULL;
    PRINT 'menu_name_en 字段添加完成。';
END
ELSE
BEGIN
    PRINT 'menu_name_en 字段已存在，跳过加列步骤。';
END

-- 添加字段注释（注释不存在时才执行）
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'[dbo].[sys_menu]')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[sys_menu]'), 'menu_name_en', 'ColumnId')
      AND name = 'MS_Description'
)
BEGIN
    EXEC sp_addextendedproperty 'MS_Description', N'菜单名称（英文）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'menu_name_en';
    PRINT 'menu_name_en 字段注释添加完成。';
END
ELSE
BEGIN
    PRINT 'menu_name_en 字段注释已存在，跳过。';
END

GO
-- ============================================================
-- 步骤 2：补全存量菜单的英文名称（只更新为空的记录）
-- ============================================================

-- 一级菜单
UPDATE sys_menu SET menu_name_en = 'System Management' WHERE menu_id = 1 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'System Monitoring' WHERE menu_id = 2 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'System Tools' WHERE menu_id = 3 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'SMC Website' WHERE menu_id = 4 AND (menu_name_en IS NULL OR menu_name_en = '');

-- 二级菜单
UPDATE sys_menu SET menu_name_en = 'User Management' WHERE menu_id = 100 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Management' WHERE menu_id = 101 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Menu Management' WHERE menu_id = 102 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Department Management' WHERE menu_id = 103 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Management' WHERE menu_id = 104 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Management' WHERE menu_id = 105 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Parameter Settings' WHERE menu_id = 106 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Notice Announcement' WHERE menu_id = 107 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Log Management' WHERE menu_id = 108 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Online Users' WHERE menu_id = 109 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Scheduled Jobs' WHERE menu_id = 110 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Data Monitoring' WHERE menu_id = 111 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Service Monitoring' WHERE menu_id = 112 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Cache Monitoring' WHERE menu_id = 113 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Cache List' WHERE menu_id = 114 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Form Builder' WHERE menu_id = 115 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Code Generator' WHERE menu_id = 116 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'System API' WHERE menu_id = 117 AND (menu_name_en IS NULL OR menu_name_en = '');

-- 三级菜单
UPDATE sys_menu SET menu_name_en = 'Operation Log' WHERE menu_id = 500 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Login Log' WHERE menu_id = 501 AND (menu_name_en IS NULL OR menu_name_en = '');

-- 按钮权限
UPDATE sys_menu SET menu_name_en = 'User Query' WHERE menu_id = 1000 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'User Add' WHERE menu_id = 1001 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'User Edit' WHERE menu_id = 1002 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'User Delete' WHERE menu_id = 1003 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'User Export' WHERE menu_id = 1004 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'User Import' WHERE menu_id = 1005 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Reset Password' WHERE menu_id = 1006 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Query' WHERE menu_id = 1007 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Add' WHERE menu_id = 1008 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Edit' WHERE menu_id = 1009 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Delete' WHERE menu_id = 1010 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Role Export' WHERE menu_id = 1011 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Menu Query' WHERE menu_id = 1012 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Menu Add' WHERE menu_id = 1013 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Menu Edit' WHERE menu_id = 1014 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Menu Delete' WHERE menu_id = 1015 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Department Query' WHERE menu_id = 1016 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Department Add' WHERE menu_id = 1017 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Department Edit' WHERE menu_id = 1018 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Department Delete' WHERE menu_id = 1019 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Query' WHERE menu_id = 1020 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Add' WHERE menu_id = 1021 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Edit' WHERE menu_id = 1022 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Delete' WHERE menu_id = 1023 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Post Export' WHERE menu_id = 1024 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Query' WHERE menu_id = 1025 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Add' WHERE menu_id = 1026 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Edit' WHERE menu_id = 1027 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Delete' WHERE menu_id = 1028 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Dictionary Export' WHERE menu_id = 1029 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Config Query' WHERE menu_id = 1030 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Config Add' WHERE menu_id = 1031 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Config Edit' WHERE menu_id = 1032 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Config Delete' WHERE menu_id = 1033 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Config Export' WHERE menu_id = 1034 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Notice Query' WHERE menu_id = 1035 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Notice Add' WHERE menu_id = 1036 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Notice Edit' WHERE menu_id = 1037 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Notice Delete' WHERE menu_id = 1038 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Operation Query' WHERE menu_id = 1039 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Operation Delete' WHERE menu_id = 1040 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Log Export' WHERE menu_id = 1041 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Login Query' WHERE menu_id = 1042 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Login Delete' WHERE menu_id = 1043 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Log Export' WHERE menu_id = 1044 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Unlock Account' WHERE menu_id = 1045 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Online Query' WHERE menu_id = 1046 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Force Logout' WHERE menu_id = 1047 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Force Logout Single' WHERE menu_id = 1048 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Query' WHERE menu_id = 1049 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Add' WHERE menu_id = 1050 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Edit' WHERE menu_id = 1051 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Delete' WHERE menu_id = 1052 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Status Change' WHERE menu_id = 1053 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Job Export' WHERE menu_id = 1054 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Gen Query' WHERE menu_id = 1055 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Gen Edit' WHERE menu_id = 1056 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Gen Delete' WHERE menu_id = 1057 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Import Code' WHERE menu_id = 1058 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Preview Code' WHERE menu_id = 1059 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Generate Code' WHERE menu_id = 1060 AND (menu_name_en IS NULL OR menu_name_en = '');

-- 人员选择与编号规则（业务自建菜单）
UPDATE sys_menu SET menu_name_en = 'Personnel Selection' WHERE menu_id = 1061 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule' WHERE menu_id = 10001 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule Query' WHERE menu_id = 10002 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule Add' WHERE menu_id = 10003 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule Edit' WHERE menu_id = 10004 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule Delete' WHERE menu_id = 10005 AND (menu_name_en IS NULL OR menu_name_en = '');
UPDATE sys_menu SET menu_name_en = 'Number Rule Export' WHERE menu_id = 10006 AND (menu_name_en IS NULL OR menu_name_en = '');

-- ============================================================
-- 步骤 3：校验补全情况
-- ============================================================
SELECT COUNT(*) AS total_count,
       SUM(CASE WHEN menu_name_en IS NULL OR menu_name_en = '' THEN 1 ELSE 0 END) AS missing_en_count
FROM sys_menu;

-- 抽查若干条菜单的中英文对照
SELECT menu_id, menu_name, menu_name_en
FROM sys_menu
WHERE menu_id IN (1, 100, 101, 102, 500, 1000, 1060)
ORDER BY menu_id;

-- ============================================================
-- 回滚脚本（按需执行）
--
-- 回滚 1：清空所有英文名（保留字段）
--   UPDATE sys_menu SET menu_name_en = '';
--
-- 回滚 2：删除字段（不可逆，请先备份）
--   ALTER TABLE [dbo].[sys_menu] DROP COLUMN [menu_name_en];
-- ============================================================
