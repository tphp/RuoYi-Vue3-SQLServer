-- ============================================================
-- sys_user 增加上级工号字段脚本（MSSQL）
--
-- 用途：为存量 sys_user 表补充 fd_short_no 字段（上级工号 / 直接上级的 usercode）
-- 说明：
--   1. 本脚本可重复执行（幂等）：加列语句会先判断列是否存在
--   2. 执行前请先备份 sys_user 表
--   3. 若数据库是用 sql/sqlserver.sql 全新重建的（已含该列），加列步骤会自动跳过
--   4. 该列允许为空，历史用户数据无需回填
--
-- 注意：MSSQL 在编译期即校验列是否存在，因此「加列」与「后续引用新列」必须用 GO 分成两个批次执行
-- ============================================================

SET NOCOUNT ON;

-- ============================================================
-- 步骤 1：增加 fd_short_no 字段（列不存在时才执行）
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[sys_user]')
      AND name = 'fd_short_no'
)
BEGIN
    PRINT '正在为 sys_user 表增加 fd_short_no 字段...';
    ALTER TABLE [dbo].[sys_user] ADD [fd_short_no] nvarchar(50) NULL;
    PRINT 'fd_short_no 字段添加完成。';
END
ELSE
BEGIN
    PRINT 'fd_short_no 字段已存在，跳过加列步骤。';
END

-- 添加字段注释（注释不存在时才执行）
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'[dbo].[sys_user]')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[sys_user]'), 'fd_short_no', 'ColumnId')
      AND name = 'MS_Description'
)
BEGIN
    EXEC sp_addextendedproperty 'MS_Description', N'上级工号（直接上级的 usercode）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'fd_short_no';
    PRINT 'fd_short_no 字段注释添加完成。';
END
ELSE
BEGIN
    PRINT 'fd_short_no 字段注释已存在，跳过。';
END

GO
-- ============================================================
-- 步骤 2：校验列结构
-- ============================================================
SELECT c.name AS 列名,
       t.name AS 数据类型,
       c.max_length AS 字节长度,
       c.is_nullable AS 允许空
FROM sys.columns c
JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID(N'[dbo].[sys_user]')
  AND c.name = 'fd_short_no';

GO
