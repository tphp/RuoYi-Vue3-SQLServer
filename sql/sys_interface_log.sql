-- ----------------------------
-- 通用接口日志表（SQL Server）
-- 1. sys_outbound_log 出站日志：本系统调用外部接口的记录
-- 2. sys_inbound_log  入站日志：外部系统调用本系统接口的记录
-- 使用：连接业务库后直接执行本脚本
-- ----------------------------

-- ============================
-- 1. 出站接口日志表
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_outbound_log')
BEGIN
CREATE TABLE [dbo].[sys_outbound_log] (
    [outbound_id]           bigint IDENTITY(1,1) NOT NULL,
    [interface_name]        nvarchar(200)   NULL,
    [interface_url]         nvarchar(1000)  NULL,
    [request_time]          datetime        NULL,
    [request_parameter]     nvarchar(max)   NULL,
    [request_status]        nvarchar(20)    NULL,
    [response_content]      nvarchar(max)   NULL,
    [response_time]         bigint          NULL,
    [response_code]         nvarchar(20)    NULL,
    [stacktrace]            nvarchar(max)   NULL,
    [object_version_number] bigint          NULL,
    [request_id]            nvarchar(64)    NULL,
    [program_id]            nvarchar(100)   NULL,
    [created_by]            nvarchar(64)    NULL,
    [creation_date]         datetime        NULL,
    [last_updated_by]       nvarchar(64)    NULL,
    [last_update_date]      datetime        NULL,
    [last_update_login]     nvarchar(64)    NULL,
    CONSTRAINT [PK_sys_outbound_log] PRIMARY KEY CLUSTERED ([outbound_id] ASC)
);
CREATE INDEX [idx_sys_outbound_log_time] ON [dbo].[sys_outbound_log] ([request_time] DESC);
CREATE INDEX [idx_sys_outbound_log_name] ON [dbo].[sys_outbound_log] ([interface_name] ASC);
END
GO

EXEC sp_addextendedproperty 'MS_Description', N'出站接口日志表', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log';
EXEC sp_addextendedproperty 'MS_Description', N'主键', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'outbound_id';
EXEC sp_addextendedproperty 'MS_Description', N'接口名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'interface_name';
EXEC sp_addextendedproperty 'MS_Description', N'接口地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'interface_url';
EXEC sp_addextendedproperty 'MS_Description', N'请求时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'request_time';
EXEC sp_addextendedproperty 'MS_Description', N'请求参数（请求头/查询条件/请求体）', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'request_parameter';
EXEC sp_addextendedproperty 'MS_Description', N'请求状态（SUCCESS/FAIL）', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'request_status';
EXEC sp_addextendedproperty 'MS_Description', N'响应内容', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'response_content';
EXEC sp_addextendedproperty 'MS_Description', N'响应耗时（毫秒）', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'response_time';
EXEC sp_addextendedproperty 'MS_Description', N'HTTP状态码', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'response_code';
EXEC sp_addextendedproperty 'MS_Description', N'错误堆栈', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'stacktrace';
EXEC sp_addextendedproperty 'MS_Description', N'版本号', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'object_version_number';
EXEC sp_addextendedproperty 'MS_Description', N'请求唯一标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'request_id';
EXEC sp_addextendedproperty 'MS_Description', N'调用方程序标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'program_id';
EXEC sp_addextendedproperty 'MS_Description', N'创建人', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'created_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'creation_date';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新人', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'last_updated_by';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'last_update_date';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新登录ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_outbound_log', 'COLUMN', N'last_update_login';
GO

-- ============================
-- 2. 入站接口日志表
-- ============================
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'sys_inbound_log')
BEGIN
CREATE TABLE [dbo].[sys_inbound_log] (
    [inbound_id]               bigint IDENTITY(1,1) NOT NULL,
    [interface_name]           nvarchar(200)   NULL,
    [interface_url]            nvarchar(1000)  NULL,
    [request_time]             datetime        NULL,
    [request_header_parameter] nvarchar(2000)  NULL,
    [request_body_parameter]   nvarchar(max)   NULL,
    [request_method]           nvarchar(10)    NULL,
    [request_status]           nvarchar(20)    NULL,
    [response_content]         nvarchar(max)   NULL,
    [response_time]            bigint          NULL,
    [stacktrace]               nvarchar(max)   NULL,
    [ip]                       nvarchar(64)    NULL,
    [referer]                  nvarchar(500)   NULL,
    [user_agent]               nvarchar(500)   NULL,
    [object_version_number]    bigint          NULL,
    [request_id]               nvarchar(64)    NULL,
    [program_id]               nvarchar(100)   NULL,
    [created_by]               nvarchar(64)    NULL,
    [creation_date]            datetime        NULL,
    [last_updated_by]          nvarchar(64)    NULL,
    [last_update_date]         datetime        NULL,
    [last_update_login]        nvarchar(64)    NULL,
    CONSTRAINT [PK_sys_inbound_log] PRIMARY KEY CLUSTERED ([inbound_id] ASC)
);
CREATE INDEX [idx_sys_inbound_log_time] ON [dbo].[sys_inbound_log] ([request_time] DESC);
CREATE INDEX [idx_sys_inbound_log_name] ON [dbo].[sys_inbound_log] ([interface_name] ASC);
END
GO

EXEC sp_addextendedproperty 'MS_Description', N'入站接口日志表', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log';
EXEC sp_addextendedproperty 'MS_Description', N'主键', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'inbound_id';
EXEC sp_addextendedproperty 'MS_Description', N'接口名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'interface_name';
EXEC sp_addextendedproperty 'MS_Description', N'接口地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'interface_url';
EXEC sp_addextendedproperty 'MS_Description', N'请求时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_time';
EXEC sp_addextendedproperty 'MS_Description', N'请求Header参数', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_header_parameter';
EXEC sp_addextendedproperty 'MS_Description', N'请求Body参数', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_body_parameter';
EXEC sp_addextendedproperty 'MS_Description', N'请求方式', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_method';
EXEC sp_addextendedproperty 'MS_Description', N'请求状态（SUCCESS/FAIL）', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_status';
EXEC sp_addextendedproperty 'MS_Description', N'响应内容', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'response_content';
EXEC sp_addextendedproperty 'MS_Description', N'响应耗时（毫秒）', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'response_time';
EXEC sp_addextendedproperty 'MS_Description', N'错误堆栈', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'stacktrace';
EXEC sp_addextendedproperty 'MS_Description', N'调用方IP', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'ip';
EXEC sp_addextendedproperty 'MS_Description', N'来源页面', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'referer';
EXEC sp_addextendedproperty 'MS_Description', N'客户端标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'user_agent';
EXEC sp_addextendedproperty 'MS_Description', N'版本号', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'object_version_number';
EXEC sp_addextendedproperty 'MS_Description', N'请求唯一标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'request_id';
EXEC sp_addextendedproperty 'MS_Description', N'调用方程序标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'program_id';
EXEC sp_addextendedproperty 'MS_Description', N'创建人', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'created_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'creation_date';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新人', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'last_updated_by';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'last_update_date';
EXEC sp_addextendedproperty 'MS_Description', N'最后更新登录ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_inbound_log', 'COLUMN', N'last_update_login';
GO
