-- ============================================================
-- sys_dept / sys_user 增加英文名列脚本（MSSQL）
--
-- 用途：为存量部门表与用户表补充英文名列，实现英文界面下
--       部门名称、用户昵称显示为英文
--       - sys_dept.dept_name_en  部门名称（英文）
--       - sys_user.nick_name_en  用户昵称（英文）
-- 说明：
--   1. 本脚本可重复执行（幂等）：加列语句会先判断列是否存在，补数据只更新英文名为空的记录
--   2. 执行前请先备份 sys_dept、sys_user 表
--   3. 执行完成后需重启后端（部门树、部门下拉等带缓存），并刷新字典缓存
--   4. 若数据库是用 sql/sqlserver.sql 全新重建的（已含该列与英文数据），加列与补数据步骤会自动跳过
--   5. 未在列表中的记录保持为空，前端会自动回退显示中文名称
--
-- 注意：MSSQL 在编译期即校验列是否存在，因此「加列」与「补数据」必须用 GO 分成两个批次执行
-- ============================================================

SET NOCOUNT ON;

-- ============================================================
-- 步骤 1：增加 dept_name_en / nick_name_en 字段（列不存在时才执行）
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[sys_dept]')
      AND name = 'dept_name_en'
)
BEGIN
    PRINT '正在为 sys_dept 表增加 dept_name_en 字段...';
    ALTER TABLE [dbo].[sys_dept] ADD [dept_name_en] nvarchar(100) DEFAULT '' NULL;
    PRINT 'dept_name_en 字段添加完成。';
END
ELSE
BEGIN
    PRINT 'dept_name_en 字段已存在，跳过加列步骤。';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'[dbo].[sys_dept]')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[sys_dept]'), 'dept_name_en', 'ColumnId')
      AND name = 'MS_Description'
)
BEGIN
    EXEC sp_addextendedproperty 'MS_Description', N'部门名称（英文）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'dept_name_en';
    PRINT 'dept_name_en 字段注释添加完成。';
END
ELSE
BEGIN
    PRINT 'dept_name_en 字段注释已存在，跳过。';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[sys_user]')
      AND name = 'nick_name_en'
)
BEGIN
    PRINT '正在为 sys_user 表增加 nick_name_en 字段...';
    ALTER TABLE [dbo].[sys_user] ADD [nick_name_en] nvarchar(100) DEFAULT '' NULL;
    PRINT 'nick_name_en 字段添加完成。';
END
ELSE
BEGIN
    PRINT 'nick_name_en 字段已存在，跳过加列步骤。';
END

IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'[dbo].[sys_user]')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[sys_user]'), 'nick_name_en', 'ColumnId')
      AND name = 'MS_Description'
)
BEGIN
    EXEC sp_addextendedproperty 'MS_Description', N'用户昵称（英文）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'nick_name_en';
    PRINT 'nick_name_en 字段注释添加完成。';
END
ELSE
BEGIN
    PRINT 'nick_name_en 字段注释已存在，跳过。';
END

GO
-- ============================================================
-- 步骤 2：补全存量部门与用户的英文名（只更新为空的记录）
-- ============================================================

-- 部门
UPDATE sys_dept SET dept_name_en = 'SMC Technology'      WHERE dept_name = 'SMC科技'   AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Shenzhen Head Office' WHERE dept_name = '深圳总公司' AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Changsha Branch'      WHERE dept_name = '长沙分公司' AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'R&D Department'       WHERE dept_name = '研发部门'   AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Marketing Department' WHERE dept_name = '市场部门'   AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Testing Department'   WHERE dept_name = '测试部门'   AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Finance Department'   WHERE dept_name = '财务部门'   AND (dept_name_en IS NULL OR dept_name_en = '');
UPDATE sys_dept SET dept_name_en = 'Operations Department' WHERE dept_name = '运维部门'  AND (dept_name_en IS NULL OR dept_name_en = '');

-- 用户
UPDATE sys_user SET nick_name_en = 'RuoYi'        WHERE nick_name = '若依'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Zhang San'    WHERE nick_name = '张三'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Zhang Si'     WHERE nick_name = '张四'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Sun Xiaoxiao' WHERE nick_name = '孙小小'   AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Bao Zungong'  WHERE nick_name = '包租公'   AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Tom'          WHERE nick_name = '汤姆'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Jack'         WHERE nick_name = '杰克'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Xu Laozu'     WHERE nick_name = '徐老祖'   AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Li Tiegui'    WHERE nick_name = '李铁拐'   AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Supervisor'  WHERE nick_name = '主管'     AND (nick_name_en IS NULL OR nick_name_en = '');
UPDATE sys_user SET nick_name_en = 'Yu Xing'      WHERE nick_name = '余星'     AND (nick_name_en IS NULL OR nick_name_en = '');

GO
-- ============================================================
-- 步骤 3：校验结果
-- ============================================================
SELECT dept_id, dept_name, dept_name_en FROM sys_dept WHERE del_flag = '0' ORDER BY parent_id, order_num;
GO
SELECT user_id, user_name, nick_name, nick_name_en FROM sys_user WHERE del_flag = '0' ORDER BY user_id;
GO
