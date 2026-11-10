-- =============================================================
-- 业务级权限：权限策略主表
-- 数据库：SQL Server
-- 说明：一行表示“某场景下，某个权限归属人拥有哪些可见范围”
-- =============================================================

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
GO

-- 同一场景下，同一权限归属人只允许一条“启用”记录
-- 增加 status 过滤，避免停用记录占用唯一键，导致无法重新新增
CREATE UNIQUE INDEX [uk_biz_perm_policy]
    ON [dbo].[sys_biz_perm_policy] ([policy_code], [subject_type], [subject_value])
    WHERE [status] = '0';
GO

-- 按归属人反查策略（登录人计算可见范围）
CREATE INDEX [idx_biz_perm_policy_subject]
    ON [dbo].[sys_biz_perm_policy] ([subject_type], [subject_value], [status]);
GO

-- 按场景查询策略（树、列表）
CREATE INDEX [idx_biz_perm_policy_code]
    ON [dbo].[sys_biz_perm_policy] ([policy_code], [status]);
GO
