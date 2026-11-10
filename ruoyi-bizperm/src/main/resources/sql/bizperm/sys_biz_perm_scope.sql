-- =============================================================
-- 业务级权限：可见范围明细表
-- 数据库：SQL Server
-- 说明：一个策略可配置多个范围；跨部门即多条 DEPT 记录
-- =============================================================

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
GO

-- 同一策略下，同一范围只允许一行
CREATE UNIQUE INDEX [uk_biz_perm_scope]
    ON [dbo].[sys_biz_perm_scope] ([policy_id], [scope_type], [scope_value]);
GO

-- 树与可见范围展开
CREATE INDEX [idx_biz_perm_scope_policy]
    ON [dbo].[sys_biz_perm_scope] ([policy_id], [scope_type], [order_num]);
GO
