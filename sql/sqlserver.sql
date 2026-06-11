-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[gen_table]') AND type IN ('U'))
    DROP TABLE [dbo].[gen_table];

CREATE TABLE [dbo].[gen_table] (
    [table_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [table_name] nvarchar(200) NULL,
    [table_comment] nvarchar(500) NULL,
    [sub_table_name] nvarchar(64) NULL,
    [sub_table_fk_name] nvarchar(64) NULL,
    [class_name] nvarchar(100) NULL,
    [tpl_category] nvarchar(200) NULL,
    [tpl_web_type] nvarchar(30) NULL,
    [package_name] nvarchar(100) NULL,
    [module_name] nvarchar(30) NULL,
    [business_name] nvarchar(30) NULL,
    [function_name] nvarchar(50) NULL,
    [function_author] nvarchar(50) NULL,
    [form_col_num] nvarchar(50) DEFAULT 1 NULL,
    [gen_type] nchar(1) NULL,
    [gen_path] nvarchar(200) NULL,
    [options] nvarchar(1000) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[gen_table] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'编号', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'table_id';
EXEC sp_addextendedproperty 'MS_Description', N'表名称', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'table_name';
EXEC sp_addextendedproperty 'MS_Description', N'表描述', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'table_comment';
EXEC sp_addextendedproperty 'MS_Description', N'关联子表的表名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'sub_table_name';
EXEC sp_addextendedproperty 'MS_Description', N'子表关联的外键名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'sub_table_fk_name';
EXEC sp_addextendedproperty 'MS_Description', N'实体类名称', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'class_name';
EXEC sp_addextendedproperty 'MS_Description', N'使用的模板（crud单表操作 tree树表操作）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'tpl_category';
EXEC sp_addextendedproperty 'MS_Description', N'前端模板类型（element-ui模版 element-plus模版）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'tpl_web_type';
EXEC sp_addextendedproperty 'MS_Description', N'生成包路径', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'package_name';
EXEC sp_addextendedproperty 'MS_Description', N'生成模块名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'module_name';
EXEC sp_addextendedproperty 'MS_Description', N'生成业务名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'business_name';
EXEC sp_addextendedproperty 'MS_Description', N'生成功能名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'function_name';
EXEC sp_addextendedproperty 'MS_Description', N'生成功能作者', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'function_author';
EXEC sp_addextendedproperty 'MS_Description', N'生成代码方式（0zip压缩包 1自定义路径）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'gen_type';
EXEC sp_addextendedproperty 'MS_Description', N'生成路径（不填默认项目路径）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'gen_path';
EXEC sp_addextendedproperty 'MS_Description', N'其它生成选项', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'options';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'gen_table', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'代码生成业务表', 'SCHEMA', N'dbo', 'TABLE', N'gen_table';

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[gen_table_column]') AND type IN ('U'))
    DROP TABLE [dbo].[gen_table_column];

CREATE TABLE [dbo].[gen_table_column] (
    [column_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [table_id] bigint  NULL,
    [column_name] nvarchar(200) NULL,
    [column_comment] nvarchar(500) NULL,
    [column_type] nvarchar(100) NULL,
    [java_type] nvarchar(500) NULL,
    [java_field] nvarchar(200) NULL,
    [is_pk] nchar(1) NULL,
    [is_increment] nchar(1) NULL,
    [is_required] nchar(1) NULL,
    [is_insert] nchar(1) NULL,
    [is_edit] nchar(1) NULL,
    [is_list] nchar(1) NULL,
    [is_query] nchar(1) NULL,
    [query_type] nvarchar(200) NULL,
    [html_type] nvarchar(200) NULL,
    [dict_type] nvarchar(200) NULL,
    [sort] int  NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL
);

ALTER TABLE [dbo].[gen_table_column] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'编号', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'column_id';
EXEC sp_addextendedproperty 'MS_Description', N'归属表编号', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'table_id';
EXEC sp_addextendedproperty 'MS_Description', N'列名称', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'column_name';
EXEC sp_addextendedproperty 'MS_Description', N'列描述', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'column_comment';
EXEC sp_addextendedproperty 'MS_Description', N'列类型', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'column_type';
EXEC sp_addextendedproperty 'MS_Description', N'JAVA类型', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'java_type';
EXEC sp_addextendedproperty 'MS_Description', N'JAVA字段名', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'java_field';
EXEC sp_addextendedproperty 'MS_Description', N'是否主键（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_pk';
EXEC sp_addextendedproperty 'MS_Description', N'是否自增（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_increment';
EXEC sp_addextendedproperty 'MS_Description', N'是否必填（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_required';
EXEC sp_addextendedproperty 'MS_Description', N'是否为插入字段（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_insert';
EXEC sp_addextendedproperty 'MS_Description', N'是否编辑字段（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_edit';
EXEC sp_addextendedproperty 'MS_Description', N'是否列表字段（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_list';
EXEC sp_addextendedproperty 'MS_Description', N'是否查询字段（1是）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'is_query';
EXEC sp_addextendedproperty 'MS_Description', N'查询方式（等于、不等于、大于、小于、范围）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'query_type';
EXEC sp_addextendedproperty 'MS_Description', N'显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'html_type';
EXEC sp_addextendedproperty 'MS_Description', N'字典类型', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'dict_type';
EXEC sp_addextendedproperty 'MS_Description', N'排序', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'sort';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'代码生成业务表字段', 'SCHEMA', N'dbo', 'TABLE', N'gen_table_column';

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
SET IDENTITY_INSERT [dbo].[gen_table_column] ON;
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'1', N'2', N'id', N'ID', N'int', N'Long', N'id', N'1', NULL, NULL, N'1', NULL, NULL, NULL, N'EQ', N'input', NULL, N'1', N'admin', N'2024-08-12 11:20:20.1200000', NULL, N'2024-08-12 14:57:47.8370000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'2', N'2', N'metric_name', N'指标名称', N'varchar', N'String', N'metricName', NULL, NULL, NULL, N'1', N'1', N'1', N'1', N'LIKE', N'input', NULL, N'2', N'admin', N'2024-08-12 11:20:20.1330000', NULL, N'2024-08-12 14:57:47.8570000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'3', N'2', N'month_amount_incurred', N'本月发生额', N'float', N'Long', N'monthAmountIncurred', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'3', N'admin', N'2024-08-12 11:20:20.1430000', NULL, N'2024-08-12 14:57:47.8600000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'4', N'2', N'percentage_of_the_month', N'环比比例', N'varchar', N'String', N'percentageOfTheMonth', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'4', N'admin', N'2024-08-12 11:20:20.1670000', NULL, N'2024-08-12 14:57:47.8700000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'5', N'2', N'cumulative_amount_for_the_year', N'本年累计额', N'float', N'Long', N'cumulativeAmountForTheYear', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'5', N'admin', N'2024-08-12 11:20:20.1730000', NULL, N'2024-08-12 14:57:47.8730000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'6', N'2', N'cumulative_amount_for_the_prev', N'上年同期累计额', N'float', N'Long', N'cumulativeAmountForThePrev', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'6', N'admin', N'2024-08-12 11:20:20.1800000', NULL, N'2024-08-12 14:57:47.8830000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'7', N'2', N'year_on_year_comparison', N'上年同比', N'varchar', N'String', N'yearOnYearComparison', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'7', N'admin', N'2024-08-12 11:20:20.1900000', NULL, N'2024-08-12 14:57:47.8900000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'8', N'2', N'budget_for_the_current_year', N'本年预算额', N'float', N'Long', N'budgetForTheCurrentYear', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'8', N'admin', N'2024-08-12 11:20:20.1970000', NULL, N'2024-08-12 14:57:47.8970000');
INSERT INTO [dbo].[gen_table_column] ([column_id], [table_id], [column_name], [column_comment], [column_type], [java_type], [java_field], [is_pk], [is_increment], [is_required], [is_insert], [is_edit], [is_list], [is_query], [query_type], [html_type], [dict_type], [sort], [create_by], [create_time], [update_by], [update_time]) VALUES (N'9', N'2', N'percentage_of_budget_completio', N'预算完成比例', N'varchar', N'String', N'percentageOfBudgetCompletio', NULL, NULL, NULL, N'1', N'1', N'1', N'0', N'EQ', N'input', NULL, N'9', N'admin', N'2024-08-12 11:20:20.2030000', NULL, N'2024-08-12 14:57:47.9000000');
SET IDENTITY_INSERT [dbo].[gen_table_column] OFF;

GO

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_blob_triggers]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_blob_triggers];

CREATE TABLE [dbo].[qrtz_blob_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [blob_data] varbinary(max)  NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group)
);

ALTER TABLE [dbo].[qrtz_blob_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_blob_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_blob_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_blob_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化Trigger对象', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_blob_triggers', 'COLUMN', N'blob_data';
EXEC sp_addextendedproperty 'MS_Description', N'Blob类型的触发器表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_blob_triggers';

GO

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_calendars]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_calendars];

CREATE TABLE [dbo].[qrtz_calendars] (
    [sched_name] nvarchar(120) NOT NULL,
    [calendar_name] nvarchar(200) NOT NULL,
    [calendar] varbinary(max)  NOT NULL,
    PRIMARY KEY CLUSTERED (sched_name, calendar_name)
);

ALTER TABLE [dbo].[qrtz_calendars] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_calendars', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'日历名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_calendars', 'COLUMN', N'calendar_name';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化calendar对象', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_calendars', 'COLUMN', N'calendar';
EXEC sp_addextendedproperty 'MS_Description', N'日历信息表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_calendars';

GO

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_cron_triggers]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_cron_triggers];

CREATE TABLE [dbo].[qrtz_cron_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [cron_expression] nvarchar(200) NOT NULL,
    [time_zone_id] nvarchar(80) NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group)
);

ALTER TABLE [dbo].[qrtz_cron_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'cron表达式', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers', 'COLUMN', N'cron_expression';
EXEC sp_addextendedproperty 'MS_Description', N'时区', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers', 'COLUMN', N'time_zone_id';
EXEC sp_addextendedproperty 'MS_Description', N'Cron类型的触发器表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_cron_triggers';

GO

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_fired_triggers]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_fired_triggers];

CREATE TABLE [dbo].[qrtz_fired_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [entry_id] nvarchar(95) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [instance_name] nvarchar(200) NOT NULL,
    [fired_time] bigint  NOT NULL,
    [sched_time] bigint  NOT NULL,
    [priority] int  NOT NULL,
    [state] nvarchar(16) NOT NULL,
    [job_name] nvarchar(200) NULL,
    [job_group] nvarchar(200) NULL,
    [is_nonconcurrent] nvarchar(1) NULL,
    [requests_recovery] nvarchar(1) NULL,
    PRIMARY KEY CLUSTERED (sched_name, entry_id)
);

ALTER TABLE [dbo].[qrtz_fired_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'调度器实例id', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'entry_id';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'调度器实例名', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'instance_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发的时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'fired_time';
EXEC sp_addextendedproperty 'MS_Description', N'定时器制定的时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'sched_time';
EXEC sp_addextendedproperty 'MS_Description', N'优先级', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'priority';
EXEC sp_addextendedproperty 'MS_Description', N'状态', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'state';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'是否并发', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'is_nonconcurrent';
EXEC sp_addextendedproperty 'MS_Description', N'是否接受恢复执行', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers', 'COLUMN', N'requests_recovery';
EXEC sp_addextendedproperty 'MS_Description', N'已触发的触发器表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_fired_triggers';

GO

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_job_details]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_job_details];

CREATE TABLE [dbo].[qrtz_job_details] (
    [sched_name] nvarchar(120) NOT NULL,
    [job_name] nvarchar(200) NOT NULL,
    [job_group] nvarchar(200) NOT NULL,
    [description] nvarchar(250) NULL,
    [job_class_name] nvarchar(250) NOT NULL,
    [is_durable] nvarchar(1) NOT NULL,
    [is_nonconcurrent] nvarchar(1) NOT NULL,
    [is_update_data] nvarchar(1) NOT NULL,
    [requests_recovery] nvarchar(1) NOT NULL,
    [job_data] varbinary(max)  NULL,
    PRIMARY KEY CLUSTERED (sched_name, job_name, job_group)
);

ALTER TABLE [dbo].[qrtz_job_details] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'相关介绍', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'description';
EXEC sp_addextendedproperty 'MS_Description', N'执行任务类名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'job_class_name';
EXEC sp_addextendedproperty 'MS_Description', N'是否持久化', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'is_durable';
EXEC sp_addextendedproperty 'MS_Description', N'是否并发', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'is_nonconcurrent';
EXEC sp_addextendedproperty 'MS_Description', N'是否更新数据', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'is_update_data';
EXEC sp_addextendedproperty 'MS_Description', N'是否接受恢复执行', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'requests_recovery';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化job对象', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details', 'COLUMN', N'job_data';
EXEC sp_addextendedproperty 'MS_Description', N'任务详细信息表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_job_details';

GO

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_locks]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_locks];

CREATE TABLE [dbo].[qrtz_locks] (
    [sched_name] nvarchar(120) NOT NULL,
    [lock_name] nvarchar(40) NOT NULL,
    PRIMARY KEY CLUSTERED (sched_name, lock_name)
);

ALTER TABLE [dbo].[qrtz_locks] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_locks', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'悲观锁名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_locks', 'COLUMN', N'lock_name';
EXEC sp_addextendedproperty 'MS_Description', N'存储的悲观锁信息表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_locks';

GO

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_paused_trigger_grps]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_paused_trigger_grps];

CREATE TABLE [dbo].[qrtz_paused_trigger_grps] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_group)
);

ALTER TABLE [dbo].[qrtz_paused_trigger_grps] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_paused_trigger_grps', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_paused_trigger_grps', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'暂停的触发器表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_paused_trigger_grps';

GO

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_scheduler_state]') AND type IN ('U'))
    DROP TABLE [dbo].[qrtz_scheduler_state];

CREATE TABLE [dbo].[qrtz_scheduler_state] (
    [sched_name] nvarchar(120) NOT NULL,
    [instance_name] nvarchar(200) NOT NULL,
    [last_checkin_time] bigint  NOT NULL,
    [checkin_interval] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (sched_name, instance_name)
);

ALTER TABLE [dbo].[qrtz_scheduler_state] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_scheduler_state', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'实例名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_scheduler_state', 'COLUMN', N'instance_name';
EXEC sp_addextendedproperty 'MS_Description', N'上次检查时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_scheduler_state', 'COLUMN', N'last_checkin_time';
EXEC sp_addextendedproperty 'MS_Description', N'检查间隔时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_scheduler_state', 'COLUMN', N'checkin_interval';
EXEC sp_addextendedproperty 'MS_Description', N'调度器状态表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_scheduler_state';

GO

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_simple_triggers]') AND type IN ('U'))
	DROP TABLE [dbo].[qrtz_simple_triggers];

CREATE TABLE [dbo].[qrtz_simple_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [repeat_count] bigint  NOT NULL,
    [repeat_interval] bigint  NOT NULL,
    [times_triggered] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group)
);

ALTER TABLE [dbo].[qrtz_simple_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'重复的次数统计', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'repeat_count';
EXEC sp_addextendedproperty 'MS_Description', N'重复的间隔时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'repeat_interval';
EXEC sp_addextendedproperty 'MS_Description', N'已经触发的次数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers', 'COLUMN', N'times_triggered';
EXEC sp_addextendedproperty 'MS_Description', N'简单触发器的信息表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simple_triggers';

GO

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_simprop_triggers]') AND type IN ('U'))
	DROP TABLE [dbo].[qrtz_simprop_triggers];

CREATE TABLE [dbo].[qrtz_simprop_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [str_prop_1] nvarchar(512) NULL,
    [str_prop_2] nvarchar(512) NULL,
    [str_prop_3] nvarchar(512) NULL,
    [int_prop_1] int  NULL,
    [int_prop_2] int  NULL,
    [long_prop_1] bigint  NULL,
    [long_prop_2] bigint  NULL,
    [dec_prop_1] decimal(13,4)  NULL,
    [dec_prop_2] decimal(13,4)  NULL,
    [bool_prop_1] nvarchar(1) NULL,
    [bool_prop_2] nvarchar(1) NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES qrtz_triggers(sched_name, trigger_name, trigger_group)
);

ALTER TABLE [dbo].[qrtz_simprop_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第一个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'str_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第二个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'str_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第三个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'str_prop_3';
EXEC sp_addextendedproperty 'MS_Description', N'int类型的trigger的第一个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'int_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'int类型的trigger的第二个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'int_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'long类型的trigger的第一个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'long_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'long类型的trigger的第二个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'long_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'decimal类型的trigger的第一个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'dec_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'decimal类型的trigger的第二个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'dec_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'Boolean类型的trigger的第一个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'bool_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'Boolean类型的trigger的第二个参数', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers', 'COLUMN', N'bool_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'同步机制的行锁表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_simprop_triggers';

GO

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[qrtz_triggers]') AND type IN ('U'))
	DROP TABLE [dbo].[qrtz_triggers];

CREATE TABLE [dbo].[qrtz_triggers] (
    [sched_name] nvarchar(120) NOT NULL,
    [trigger_name] nvarchar(200) NOT NULL,
    [trigger_group] nvarchar(200) NOT NULL,
    [job_name] nvarchar(200) NOT NULL,
    [job_group] nvarchar(200) NOT NULL,
    [description] nvarchar(250) NULL,
    [next_fire_time] bigint  NULL,
    [prev_fire_time] bigint  NULL,
    [priority] int  NULL,
    [trigger_state] nvarchar(16) NOT NULL,
    [trigger_type] nvarchar(8) NOT NULL,
    [start_time] bigint  NOT NULL,
    [end_time] bigint  NULL,
    [calendar_name] nvarchar(200) NULL,
    [misfire_instr] smallint  NULL,
    [job_data] varbinary(max)  NULL,
    PRIMARY KEY CLUSTERED (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, job_name, job_group) REFERENCES qrtz_job_details(sched_name, job_name, job_group)
);

ALTER TABLE [dbo].[qrtz_triggers] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发器的名字', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发器所属组的名字', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_job_details表job_name的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_job_details表job_group的外键', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'相关介绍', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'description';
EXEC sp_addextendedproperty 'MS_Description', N'上一次触发时间（毫秒）', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'next_fire_time';
EXEC sp_addextendedproperty 'MS_Description', N'下一次触发时间（默认为-1表示不触发）', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'prev_fire_time';
EXEC sp_addextendedproperty 'MS_Description', N'优先级', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'priority';
EXEC sp_addextendedproperty 'MS_Description', N'触发器状态', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'trigger_state';
EXEC sp_addextendedproperty 'MS_Description', N'触发器的类型', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'trigger_type';
EXEC sp_addextendedproperty 'MS_Description', N'开始时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'start_time';
EXEC sp_addextendedproperty 'MS_Description', N'结束时间', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'end_time';
EXEC sp_addextendedproperty 'MS_Description', N'日程表名称', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'calendar_name';
EXEC sp_addextendedproperty 'MS_Description', N'补偿执行的策略', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'misfire_instr';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化job对象', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers', 'COLUMN', N'job_data';
EXEC sp_addextendedproperty 'MS_Description', N'触发器详细信息表', 'SCHEMA', N'dbo', 'TABLE', N'qrtz_triggers';

GO

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_config]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_config];

CREATE TABLE [dbo].[sys_config] (
    [config_id] int  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [config_name] nvarchar(100) NULL,
    [config_key] nvarchar(100) NULL,
    [config_value] nvarchar(500) NULL,
    [config_type] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_config] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'参数主键', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'config_id';
EXEC sp_addextendedproperty 'MS_Description', N'参数名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'config_name';
EXEC sp_addextendedproperty 'MS_Description', N'参数键名', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'config_key';
EXEC sp_addextendedproperty 'MS_Description', N'参数键值', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'config_value';
EXEC sp_addextendedproperty 'MS_Description', N'系统内置（Y是 N否）', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'config_type';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_config', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'参数配置表', 'SCHEMA', N'dbo', 'TABLE', N'sys_config';


-- ----------------------------
-- Records of sys_config
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_config] ON;
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'1', N'主框架页-默认皮肤样式名称', N'sys.index.skinName', N'skin-blue', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'2', N'用户管理-账号初始密码', N'sys.user.initPassword', N'123456', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'初始化密码 123456');
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'3', N'主框架页-侧边栏主题', N'sys.index.sideTheme', N'theme-dark', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'深色主题theme-dark，浅色主题theme-light');
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'4', N'账号自助-验证码开关', N'sys.account.captchaEnabled', N'true', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'是否开启验证码功能（true开启，false关闭）');
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'5', N'账号自助-是否开启用户注册功能', N'sys.account.registerUser', N'false', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'是否开启注册用户功能（true开启，false关闭）');
INSERT INTO [dbo].[sys_config] ([config_id], [config_name], [config_key], [config_value], [config_type], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'6', N'用户登录-黑名单列表', N'sys.login.blackIPList', N'', N'Y', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
SET IDENTITY_INSERT [dbo].[sys_config] OFF;

GO

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_dept]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_dept];

CREATE TABLE [dbo].[sys_dept] (
    [dept_id] bigint  IDENTITY(100,1) NOT NULL PRIMARY KEY,
    [parent_id] bigint  NULL,
    [ancestors] nvarchar(50) NULL,
    [dept_name] nvarchar(30) NULL,
    [order_num] int  NULL,
    [leader] nvarchar(20) NULL,
    [phone] nvarchar(11) NULL,
    [email] nvarchar(50) NULL,
    [status] nchar(1) NULL,
    [del_flag] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL
);

ALTER TABLE [dbo].[sys_dept] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'部门id', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'dept_id';
EXEC sp_addextendedproperty 'MS_Description', N'父部门id', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'parent_id';
EXEC sp_addextendedproperty 'MS_Description', N'祖级列表', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'ancestors';
EXEC sp_addextendedproperty 'MS_Description', N'部门名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'dept_name';
EXEC sp_addextendedproperty 'MS_Description', N'显示顺序', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'order_num';
EXEC sp_addextendedproperty 'MS_Description', N'负责人', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'leader';
EXEC sp_addextendedproperty 'MS_Description', N'联系电话', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'phone';
EXEC sp_addextendedproperty 'MS_Description', N'邮箱', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'email';
EXEC sp_addextendedproperty 'MS_Description', N'部门状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'删除标志（0代表存在 2代表删除）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'del_flag';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'部门表', 'SCHEMA', N'dbo', 'TABLE', N'sys_dept';

-- ----------------------------
-- 初始化-部门表数据
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_dept] ON;
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(100,  0,   '0',          '若依科技',   0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(101,  100, '0,100',      '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(102,  100, '0,100',      '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(103,  101, '0,100,101',  '研发部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(104,  101, '0,100,101',  '市场部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(105,  101, '0,100,101',  '测试部门',   3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(106,  101, '0,100,101',  '财务部门',   4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(107,  101, '0,100,101',  '运维部门',   5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(108,  102, '0,100,102',  '市场部门',   1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
INSERT INTO [dbo].[sys_dept] ([dept_id], [parent_id], [ancestors], [dept_name], [order_num], [leader], [phone], [email], [status], [del_flag], [create_by], [create_time], [update_by], [update_time]) values(109,  102, '0,100,102',  '财务部门',   2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', getdate(), '', null);
SET IDENTITY_INSERT [dbo].[sys_dept] OFF;

GO

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_dict_data]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_dict_data];

CREATE TABLE [dbo].[sys_dict_data] (
    [dict_code] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [dict_sort] int  NULL,
    [dict_label] nvarchar(100) NULL,
    [dict_value] nvarchar(100) NULL,
    [dict_type] nvarchar(100) NULL,
    [css_class] nvarchar(100) NULL,
    [list_class] nvarchar(100) NULL,
    [is_default] nchar(1) NULL,
    [status] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_dict_data] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'字典编码', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_code';
EXEC sp_addextendedproperty 'MS_Description', N'字典排序', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_sort';
EXEC sp_addextendedproperty 'MS_Description', N'字典标签', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_label';
EXEC sp_addextendedproperty 'MS_Description', N'字典键值', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_value';
EXEC sp_addextendedproperty 'MS_Description', N'字典类型', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_type';
EXEC sp_addextendedproperty 'MS_Description', N'样式属性（其他样式扩展）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'css_class';
EXEC sp_addextendedproperty 'MS_Description', N'表格回显样式', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'list_class';
EXEC sp_addextendedproperty 'MS_Description', N'是否默认（Y是 N否）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'is_default';
EXEC sp_addextendedproperty 'MS_Description', N'状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'字典数据表', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data';


-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_dict_data] ON;
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(1,  1,  '男',       '0',       'sys_user_sex',        '',   '',        'Y', '0', 'admin', getdate(), '', null, '性别男');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(2,  2,  '女',       '1',       'sys_user_sex',        '',   '',        'N', '0', 'admin', getdate(), '', null, '性别女');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(3,  3,  '未知',     '2',       'sys_user_sex',        '',   '',        'N', '0', 'admin', getdate(), '', null, '性别未知');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(4,  1,  '显示',     '0',       'sys_show_hide',       '',   'primary', 'Y', '0', 'admin', getdate(), '', null, '显示菜单');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(5,  2,  '隐藏',     '1',       'sys_show_hide',       '',   'danger',  'N', '0', 'admin', getdate(), '', null, '隐藏菜单');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(6,  1,  '正常',     '0',       'sys_normal_disable',  '',   'primary', 'Y', '0', 'admin', getdate(), '', null, '正常状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(7,  2,  '停用',     '1',       'sys_normal_disable',  '',   'danger',  'N', '0', 'admin', getdate(), '', null, '停用状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(8,  1,  '正常',     '0',       'sys_job_status',      '',   'primary', 'Y', '0', 'admin', getdate(), '', null, '正常状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(9,  2,  '暂停',     '1',       'sys_job_status',      '',   'danger',  'N', '0', 'admin', getdate(), '', null, '停用状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(10, 1,  '默认',     'DEFAULT', 'sys_job_group',       '',   '',        'Y', '0', 'admin', getdate(), '', null, '默认分组');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(11, 2,  '系统',     'SYSTEM',  'sys_job_group',       '',   '',        'N', '0', 'admin', getdate(), '', null, '系统分组');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(12, 1,  '是',       'Y',       'sys_yes_no',          '',   'primary', 'Y', '0', 'admin', getdate(), '', null, '系统默认是');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(13, 2,  '否',       'N',       'sys_yes_no',          '',   'danger',  'N', '0', 'admin', getdate(), '', null, '系统默认否');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(14, 1,  '通知',     '1',       'sys_notice_type',     '',   'warning', 'Y', '0', 'admin', getdate(), '', null, '通知');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(15, 2,  '公告',     '2',       'sys_notice_type',     '',   'success', 'N', '0', 'admin', getdate(), '', null, '公告');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(16, 1,  '正常',     '0',       'sys_notice_status',   '',   'primary', 'Y', '0', 'admin', getdate(), '', null, '正常状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(17, 2,  '关闭',     '1',       'sys_notice_status',   '',   'danger',  'N', '0', 'admin', getdate(), '', null, '关闭状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(18, 99, '其他',     '0',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', getdate(), '', null, '其他操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(19, 1,  '新增',     '1',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', getdate(), '', null, '新增操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(20, 2,  '修改',     '2',       'sys_oper_type',       '',   'info',    'N', '0', 'admin', getdate(), '', null, '修改操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(21, 3,  '删除',     '3',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', getdate(), '', null, '删除操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(22, 4,  '授权',     '4',       'sys_oper_type',       '',   'primary', 'N', '0', 'admin', getdate(), '', null, '授权操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(23, 5,  '导出',     '5',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', getdate(), '', null, '导出操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(24, 6,  '导入',     '6',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', getdate(), '', null, '导入操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(25, 7,  '强退',     '7',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', getdate(), '', null, '强退操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(26, 8,  '生成代码', '8',       'sys_oper_type',       '',   'warning', 'N', '0', 'admin', getdate(), '', null, '生成操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(27, 9,  '清空数据', '9',       'sys_oper_type',       '',   'danger',  'N', '0', 'admin', getdate(), '', null, '清空操作');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(28, 1,  '成功',     '0',       'sys_common_status',   '',   'primary', 'N', '0', 'admin', getdate(), '', null, '正常状态');
INSERT INTO [dbo].[sys_dict_data] ([dict_code], [dict_sort], [dict_label], [dict_value], [dict_type], [css_class], [list_class], [is_default], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(29, 2,  '失败',     '1',       'sys_common_status',   '',   'danger',  'N', '0', 'admin', getdate(), '', null, '停用状态');
SET IDENTITY_INSERT [dbo].[sys_dict_data] OFF;

GO

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_dict_type]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_dict_type];

CREATE TABLE [dbo].[sys_dict_type] (
    [dict_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [dict_name] nvarchar(100) NULL,
    [dict_type] nvarchar(100) NULL,
    [status] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_dict_type] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'字典主键', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'dict_id';
EXEC sp_addextendedproperty 'MS_Description', N'字典名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'dict_name';
EXEC sp_addextendedproperty 'MS_Description', N'字典类型', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'dict_type';
EXEC sp_addextendedproperty 'MS_Description', N'状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'字典类型表', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_type';


-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_dict_type] ON;
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(1,  '用户性别', 'sys_user_sex',        '0', 'admin', getdate(), '', null, '用户性别列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(2,  '菜单状态', 'sys_show_hide',       '0', 'admin', getdate(), '', null, '菜单状态列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(3,  '系统开关', 'sys_normal_disable',  '0', 'admin', getdate(), '', null, '系统开关列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(4,  '任务状态', 'sys_job_status',      '0', 'admin', getdate(), '', null, '任务状态列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(5,  '任务分组', 'sys_job_group',       '0', 'admin', getdate(), '', null, '任务分组列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(6,  '系统是否', 'sys_yes_no',          '0', 'admin', getdate(), '', null, '系统是否列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(7,  '通知类型', 'sys_notice_type',     '0', 'admin', getdate(), '', null, '通知类型列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(8,  '通知状态', 'sys_notice_status',   '0', 'admin', getdate(), '', null, '通知状态列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(9,  '操作类型', 'sys_oper_type',       '0', 'admin', getdate(), '', null, '操作类型列表');
INSERT INTO [dbo].[sys_dict_type] ([dict_id], [dict_name], [dict_type], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(10, '系统状态', 'sys_common_status',   '0', 'admin', getdate(), '', null, '登录状态列表');
SET IDENTITY_INSERT [dbo].[sys_dict_type] OFF;

GO

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_job]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_job];

CREATE TABLE [dbo].[sys_job] (
    [job_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [job_name] nvarchar(64) NOT NULL,
    [job_group] nvarchar(64) NOT NULL,
    [invoke_target] nvarchar(500) NOT NULL,
    [cron_expression] nvarchar(255) NULL,
    [misfire_policy] nvarchar(20) NULL,
    [concurrent] nchar(1) NULL,
    [status] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_job] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'任务ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'job_id';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'调用目标字符串', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'invoke_target';
EXEC sp_addextendedproperty 'MS_Description', N'cron执行表达式', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'cron_expression';
EXEC sp_addextendedproperty 'MS_Description', N'计划执行错误策略（1立即执行 2执行一次 3放弃执行）', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'misfire_policy';
EXEC sp_addextendedproperty 'MS_Description', N'是否并发执行（0允许 1禁止）', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'concurrent';
EXEC sp_addextendedproperty 'MS_Description', N'状态（0正常 1暂停）', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注信息', 'SCHEMA', N'dbo', 'TABLE', N'sys_job', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'定时任务调度表', 'SCHEMA', N'dbo', 'TABLE', N'sys_job';


-- ----------------------------
-- Records of sys_job
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_job] ON;
INSERT INTO [dbo].[sys_job] ([job_id], [job_name], [job_group], [invoke_target], [cron_expression], [misfire_policy], [concurrent], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(1, '系统默认（无参）', 'DEFAULT', 'ryTask.ryNoParams',        '0/10 * * * * ?', '3', '1', '1', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_job] ([job_id], [job_name], [job_group], [invoke_target], [cron_expression], [misfire_policy], [concurrent], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(2, '系统默认（有参）', 'DEFAULT', 'ryTask.ryParams(''ry'')',  '0/15 * * * * ?', '3', '1', '1', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_job] ([job_id], [job_name], [job_group], [invoke_target], [cron_expression], [misfire_policy], [concurrent], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(3, '系统默认（多参）', 'DEFAULT', 'ryTask.ryMultipleParams(''ry'', true, 2000L, 316.50D, 100)',  '0/20 * * * * ?', '3', '1', '1', 'admin', getdate(), '', null, '');
SET IDENTITY_INSERT [dbo].[sys_job] OFF;

GO

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_job_log]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_job_log];

CREATE TABLE [dbo].[sys_job_log] (
    [job_log_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [job_name] nvarchar(64) NOT NULL,
    [job_group] nvarchar(64) NOT NULL,
    [invoke_target] nvarchar(500) NOT NULL,
    [job_message] nvarchar(500) NULL,
    [status] nchar(1) NULL,
    [exception_info] nvarchar(2000) NULL,
    [create_time] datetime2(7)  NULL
);

ALTER TABLE [dbo].[sys_job_log] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'任务日志ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'job_log_id';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'调用目标字符串', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'invoke_target';
EXEC sp_addextendedproperty 'MS_Description', N'日志信息', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'job_message';
EXEC sp_addextendedproperty 'MS_Description', N'执行状态（0正常 1失败）', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'异常信息', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'exception_info';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'定时任务调度日志表', 'SCHEMA', N'dbo', 'TABLE', N'sys_job_log';


-- ----------------------------
-- Records of sys_job_log
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_job_log] ON;
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'1', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：13毫秒', N'0', N'', N'2024-07-16 13:46:00.0000000');
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'2', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：1毫秒', N'0', N'', N'2024-07-16 13:46:10.0000000');
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'3', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：0毫秒', N'0', N'', N'2024-07-16 13:46:20.0000000');
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'4', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：0毫秒', N'0', N'', N'2024-07-16 13:46:30.0000000');
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'5', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：0毫秒', N'0', N'', N'2024-07-16 13:46:40.0000000');
INSERT INTO [dbo].[sys_job_log] ([job_log_id], [job_name], [job_group], [invoke_target], [job_message], [status], [exception_info], [create_time]) VALUES (N'6', N'系统默认（无参）', N'DEFAULT', N'ryTask.ryNoParams', N'系统默认（无参） 总共耗时：0毫秒', N'0', N'', N'2024-07-16 13:46:50.0000000');
SET IDENTITY_INSERT [dbo].[sys_job_log] OFF;

GO

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_logininfor]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_logininfor];

CREATE TABLE [dbo].[sys_logininfor] (
    [info_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [user_name] nvarchar(50) NULL,
    [ipaddr] nvarchar(128) NULL,
    [login_location] nvarchar(255) NULL,
    [browser] nvarchar(50) NULL,
    [os] nvarchar(50) NULL,
    [status] nchar(1) NULL,
    [msg] nvarchar(255) NULL,
    [login_time] datetime2(7)  NULL
);

CREATE INDEX idx_sys_logininfor_s ON sys_logininfor(status);
CREATE INDEX idx_sys_logininfor_lt ON sys_logininfor(login_time);

ALTER TABLE [dbo].[sys_logininfor] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'访问ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'info_id';
EXEC sp_addextendedproperty 'MS_Description', N'用户账号', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'user_name';
EXEC sp_addextendedproperty 'MS_Description', N'登录IP地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'ipaddr';
EXEC sp_addextendedproperty 'MS_Description', N'登录地点', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'login_location';
EXEC sp_addextendedproperty 'MS_Description', N'浏览器类型', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'browser';
EXEC sp_addextendedproperty 'MS_Description', N'操作系统', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'os';
EXEC sp_addextendedproperty 'MS_Description', N'登录状态（0成功 1失败）', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'提示消息', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'msg';
EXEC sp_addextendedproperty 'MS_Description', N'访问时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor', 'COLUMN', N'login_time';
EXEC sp_addextendedproperty 'MS_Description', N'系统访问记录', 'SCHEMA', N'dbo', 'TABLE', N'sys_logininfor';

GO

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_menu]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_menu];

CREATE TABLE [dbo].[sys_menu] (
    [menu_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [menu_name] nvarchar(50) NOT NULL,
    [parent_id] bigint DEFAULT 0 NULL,
    [order_num] int  NULL,
    [path] nvarchar(200) NULL,
    [component] nvarchar(255) DEFAULT '' NULL,
    [query] nvarchar(255) DEFAULT '' NULL,
    [route_name] nvarchar(50) DEFAULT '' NULL,
    [is_frame] int  NULL,
    [is_cache] int  NULL,
    [menu_type] nchar(1) NULL,
    [visible] nchar(1) NULL,
    [status] nchar(1) NULL,
    [perms] nvarchar(100) DEFAULT '' NULL,
    [icon] nvarchar(100) NULL,
    [create_by] nvarchar(64) DEFAULT '' NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) DEFAULT '' NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) DEFAULT '' NULL
);

ALTER TABLE [dbo].[sys_menu] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'菜单ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'menu_id';
EXEC sp_addextendedproperty 'MS_Description', N'菜单名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'menu_name';
EXEC sp_addextendedproperty 'MS_Description', N'父菜单ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'parent_id';
EXEC sp_addextendedproperty 'MS_Description', N'显示顺序', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'order_num';
EXEC sp_addextendedproperty 'MS_Description', N'路由地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'path';
EXEC sp_addextendedproperty 'MS_Description', N'组件路径', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'component';
EXEC sp_addextendedproperty 'MS_Description', N'路由参数', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'query';
EXEC sp_addextendedproperty 'MS_Description', N'路由名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'route_name';
EXEC sp_addextendedproperty 'MS_Description', N'是否为外链（0是 1否）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'is_frame';
EXEC sp_addextendedproperty 'MS_Description', N'是否缓存（0缓存 1不缓存）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'is_cache';
EXEC sp_addextendedproperty 'MS_Description', N'菜单类型（M目录 C菜单 F按钮）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'menu_type';
EXEC sp_addextendedproperty 'MS_Description', N'菜单状态（0显示 1隐藏）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'visible';
EXEC sp_addextendedproperty 'MS_Description', N'菜单状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'权限标识', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'perms';
EXEC sp_addextendedproperty 'MS_Description', N'菜单图标', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'icon';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'菜单权限表', 'SCHEMA', N'dbo', 'TABLE', N'sys_menu';

-- ----------------------------
-- 初始化-菜单信息表数据
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_menu] ON;
-- 一级菜单
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1', '系统管理', '0', '1', 'system',           null, '', '', 1, 0, 'M', '0', '0', '', 'system',   'admin', getdate(), '', null, '系统管理目录');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('2', '系统监控', '0', '2', 'monitor',          null, '', '', 1, 0, 'M', '0', '0', '', 'monitor',  'admin', getdate(), '', null, '系统监控目录');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('3', '系统工具', '0', '3', 'tool',             null, '', '', 1, 0, 'M', '0', '0', '', 'tool',     'admin', getdate(), '', null, '系统工具目录');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('4', '若依官网', '0', '4', 'http://ruoyi.vip', null, '', '', 0, 0, 'M', '0', '0', '', 'guide',    'admin', getdate(), '', null, '若依官网地址');
-- 二级菜单
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('100',  '用户管理', '1',   '1', 'user',       'system/user/index',        '', '', 1, 0, 'C', '0', '0', 'system:user:list',        'user',          'admin', getdate(), '', null, '用户管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('101',  '角色管理', '1',   '2', 'role',       'system/role/index',        '', '', 1, 0, 'C', '0', '0', 'system:role:list',        'peoples',       'admin', getdate(), '', null, '角色管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('102',  '菜单管理', '1',   '3', 'menu',       'system/menu/index',        '', '', 1, 0, 'C', '0', '0', 'system:menu:list',        'tree-table',    'admin', getdate(), '', null, '菜单管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('103',  '部门管理', '1',   '4', 'dept',       'system/dept/index',        '', '', 1, 0, 'C', '0', '0', 'system:dept:list',        'tree',          'admin', getdate(), '', null, '部门管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('104',  '岗位管理', '1',   '5', 'post',       'system/post/index',        '', '', 1, 0, 'C', '0', '0', 'system:post:list',        'post',          'admin', getdate(), '', null, '岗位管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('105',  '字典管理', '1',   '6', 'dict',       'system/dict/index',        '', '', 1, 0, 'C', '0', '0', 'system:dict:list',        'dict',          'admin', getdate(), '', null, '字典管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('106',  '参数设置', '1',   '7', 'config',     'system/config/index',      '', '', 1, 0, 'C', '0', '0', 'system:config:list',      'edit',          'admin', getdate(), '', null, '参数设置菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('107',  '通知公告', '1',   '8', 'notice',     'system/notice/index',      '', '', 1, 0, 'C', '0', '0', 'system:notice:list',      'message',       'admin', getdate(), '', null, '通知公告菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('108',  '日志管理', '1',   '9', 'log',        '',                         '', '', 1, 0, 'M', '0', '0', '',                        'log',           'admin', getdate(), '', null, '日志管理菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('109',  '在线用户', '2',   '1', 'online',     'monitor/online/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:online:list',     'online',        'admin', getdate(), '', null, '在线用户菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('110',  '定时任务', '2',   '2', 'job',        'monitor/job/index',        '', '', 1, 0, 'C', '0', '0', 'monitor:job:list',        'job',           'admin', getdate(), '', null, '定时任务菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('111',  '数据监控', '2',   '3', 'druid',      'monitor/druid/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list',      'druid',         'admin', getdate(), '', null, '数据监控菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('112',  '服务监控', '2',   '4', 'server',     'monitor/server/index',     '', '', 1, 0, 'C', '0', '0', 'monitor:server:list',     'server',        'admin', getdate(), '', null, '服务监控菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('113',  '缓存监控', '2',   '5', 'cache',      'monitor/cache/index',      '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis',         'admin', getdate(), '', null, '缓存监控菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('114',  '缓存列表', '2',   '6', 'cacheList',  'monitor/cache/list',       '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list',      'redis-list',    'admin', getdate(), '', null, '缓存列表菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('115',  '表单构建', '3',   '1', 'build',      'tool/build/index',         '', '', 1, 0, 'C', '0', '0', 'tool:build:list',         'build',         'admin', getdate(), '', null, '表单构建菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('116',  '代码生成', '3',   '2', 'gen',        'tool/gen/index',           '', '', 1, 0, 'C', '0', '0', 'tool:gen:list',           'code',          'admin', getdate(), '', null, '代码生成菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('117',  '系统接口', '3',   '3', 'swagger',    'tool/swagger/index',       '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list',       'swagger',       'admin', getdate(), '', null, '系统接口菜单');
-- 三级菜单
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('500',  '操作日志', '108', '1', 'operlog',    'monitor/operlog/index',    '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list',    'form',          'admin', getdate(), '', null, '操作日志菜单');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('501',  '登录日志', '108', '2', 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor',    'admin', getdate(), '', null, '登录日志菜单');
-- 用户管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1000', '用户查询', '100', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1001', '用户新增', '100', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1002', '用户修改', '100', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1003', '用户删除', '100', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1004', '用户导出', '100', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1005', '用户导入', '100', '6',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1006', '重置密码', '100', '7',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd',       '#', 'admin', getdate(), '', null, '');
-- 角色管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1007', '角色查询', '101', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1008', '角色新增', '101', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1009', '角色修改', '101', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1010', '角色删除', '101', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1011', '角色导出', '101', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export',         '#', 'admin', getdate(), '', null, '');
-- 菜单管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1012', '菜单查询', '102', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1013', '菜单新增', '102', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1014', '菜单修改', '102', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1015', '菜单删除', '102', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove',         '#', 'admin', getdate(), '', null, '');
-- 部门管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1016', '部门查询', '103', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1017', '部门新增', '103', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1018', '部门修改', '103', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1019', '部门删除', '103', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove',         '#', 'admin', getdate(), '', null, '');
-- 岗位管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1020', '岗位查询', '104', '1',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1021', '岗位新增', '104', '2',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1022', '岗位修改', '104', '3',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1023', '岗位删除', '104', '4',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1024', '岗位导出', '104', '5',  '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export',         '#', 'admin', getdate(), '', null, '');
-- 字典管理按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1025', '字典查询', '105', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1026', '字典新增', '105', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1027', '字典修改', '105', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1028', '字典删除', '105', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1029', '字典导出', '105', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export',         '#', 'admin', getdate(), '', null, '');
-- 参数设置按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1030', '参数查询', '106', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query',        '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1031', '参数新增', '106', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1032', '参数修改', '106', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1033', '参数删除', '106', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove',       '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1034', '参数导出', '106', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export',       '#', 'admin', getdate(), '', null, '');
-- 通知公告按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1035', '公告查询', '107', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query',        '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1036', '公告新增', '107', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1037', '公告修改', '107', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1038', '公告删除', '107', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove',       '#', 'admin', getdate(), '', null, '');
-- 操作日志按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1039', '操作查询', '500', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query',      '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1040', '操作删除', '500', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove',     '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1041', '日志导出', '500', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export',     '#', 'admin', getdate(), '', null, '');
-- 登录日志按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1042', '登录查询', '501', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query',   '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1043', '登录删除', '501', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove',  '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1044', '日志导出', '501', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export',  '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1045', '账户解锁', '501', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock',  '#', 'admin', getdate(), '', null, '');
-- 在线用户按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1046', '在线查询', '109', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query',       '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1047', '批量强退', '109', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1048', '单条强退', '109', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', getdate(), '', null, '');
-- 定时任务按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1049', '任务查询', '110', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query',          '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1050', '任务新增', '110', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1051', '任务修改', '110', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1052', '任务删除', '110', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove',         '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1053', '状态修改', '110', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus',   '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1054', '任务导出', '110', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export',         '#', 'admin', getdate(), '', null, '');
-- 代码生成按钮
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1055', '生成查询', '116', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query',             '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1056', '生成修改', '116', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit',              '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1057', '生成删除', '116', '3', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1058', '导入代码', '116', '4', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import',            '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1059', '预览代码', '116', '5', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview',           '#', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_menu] ([menu_id], [menu_name], [parent_id], [order_num], [path], [component], [query], [route_name], [is_frame], [is_cache], [menu_type], [visible], [status], [perms], [icon], [create_by], [create_time], [update_by], [update_time], [remark]) values('1060', '生成代码', '116', '6', '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code',              '#', 'admin', getdate(), '', null, '');;
SET IDENTITY_INSERT [dbo].[sys_menu] OFF;

GO

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_notice]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_notice];

CREATE TABLE [dbo].[sys_notice] (
    [notice_id] int  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [notice_title] nvarchar(50) NOT NULL,
    [notice_type] nchar(1) NOT NULL,
    [notice_content] varbinary(max)  NULL,
    [status] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(255) NULL
);

ALTER TABLE [dbo].[sys_notice] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'公告ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'notice_id';
EXEC sp_addextendedproperty 'MS_Description', N'公告标题', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'notice_title';
EXEC sp_addextendedproperty 'MS_Description', N'公告类型（1通知 2公告）', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'notice_type';
EXEC sp_addextendedproperty 'MS_Description', N'公告内容', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'notice_content';
EXEC sp_addextendedproperty 'MS_Description', N'公告状态（0正常 1关闭）', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'通知公告表', 'SCHEMA', N'dbo', 'TABLE', N'sys_notice';


-- ----------------------------
-- Records of sys_notice
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_notice] ON;
INSERT INTO [dbo].[sys_notice] ([notice_id], [notice_title], [notice_type], [notice_content], [status], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'1', N'温馨提醒：2018-07-01 若依新版本发布啦', N'2', 0xE696B0E78988E69CACE58685E5AEB9, N'0', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'管理员');
INSERT INTO [dbo].[sys_notice] ([notice_id], [notice_title], [notice_type], [notice_content], [status], [create_by], [create_time], [update_by], [update_time], [remark]) VALUES (N'2', N'维护通知：2018-07-01 若依系统凌晨维护', N'1', 0xE7BBB4E68AA4E58685E5AEB9, N'0', N'admin', N'2024-07-16 11:25:56.0000000', N'', NULL, N'管理员');
SET IDENTITY_INSERT [dbo].[sys_notice] OFF;

GO

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_notice_read]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_notice_read];
CREATE TABLE [dbo].[sys_notice_read] (
    [read_id]          bigint          NOT NULL IDENTITY(1,1) PRIMARY KEY,
    [notice_id]        int             NOT NULL,
    [user_id]          bigint          NOT NULL,
    [read_time]        datetime2(0)    NOT NULL
);;
CREATE UNIQUE INDEX uk_user_notice ON sys_notice_read(user_id, notice_id);

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_oper_log]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_oper_log];

CREATE TABLE [dbo].[sys_oper_log] (
    [oper_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [title] nvarchar(50) NULL,
    [business_type] int  NULL,
    [method] nvarchar(200) NULL,
    [request_method] nvarchar(10) NULL,
    [operator_type] int  NULL,
    [oper_name] nvarchar(50) NULL,
    [dept_name] nvarchar(50) NULL,
    [oper_url] nvarchar(255) NULL,
    [oper_ip] nvarchar(128) NULL,
    [oper_location] nvarchar(255) NULL,
    [oper_param] nvarchar(2000) NULL,
    [json_result] nvarchar(2000) NULL,
    [status] int  NULL,
    [error_msg] nvarchar(2000) NULL,
    [oper_time] datetime2(7)  NULL,
    [cost_time] bigint  NULL
);

CREATE INDEX idx_sys_oper_log_bt ON sys_oper_log(business_type);
CREATE INDEX idx_sys_oper_log_s ON sys_oper_log(status);
CREATE INDEX idx_sys_oper_log_ot ON sys_oper_log(oper_time);

ALTER TABLE [dbo].[sys_oper_log] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'日志主键', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_id';
EXEC sp_addextendedproperty 'MS_Description', N'模块标题', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'title';
EXEC sp_addextendedproperty 'MS_Description', N'业务类型（0其它 1新增 2修改 3删除）', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'business_type';
EXEC sp_addextendedproperty 'MS_Description', N'方法名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'method';
EXEC sp_addextendedproperty 'MS_Description', N'请求方式', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'request_method';
EXEC sp_addextendedproperty 'MS_Description', N'操作类别（0其它 1后台用户 2手机端用户）', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'operator_type';
EXEC sp_addextendedproperty 'MS_Description', N'操作人员', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_name';
EXEC sp_addextendedproperty 'MS_Description', N'部门名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'dept_name';
EXEC sp_addextendedproperty 'MS_Description', N'请求URL', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_url';
EXEC sp_addextendedproperty 'MS_Description', N'主机地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_ip';
EXEC sp_addextendedproperty 'MS_Description', N'操作地点', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_location';
EXEC sp_addextendedproperty 'MS_Description', N'请求参数', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_param';
EXEC sp_addextendedproperty 'MS_Description', N'返回参数', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'json_result';
EXEC sp_addextendedproperty 'MS_Description', N'操作状态（0正常 1异常）', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'错误消息', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'error_msg';
EXEC sp_addextendedproperty 'MS_Description', N'操作时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'oper_time';
EXEC sp_addextendedproperty 'MS_Description', N'消耗时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log', 'COLUMN', N'cost_time';
EXEC sp_addextendedproperty 'MS_Description', N'操作日志记录', 'SCHEMA', N'dbo', 'TABLE', N'sys_oper_log';

GO

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_post]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_post];

CREATE TABLE [dbo].[sys_post] (
    [post_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [post_code] nvarchar(64) NOT NULL,
    [post_name] nvarchar(50) NOT NULL,
    [post_sort] int  NOT NULL,
    [status] nchar(1) NOT NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_post] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'岗位ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'post_id';
EXEC sp_addextendedproperty 'MS_Description', N'岗位编码', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'post_code';
EXEC sp_addextendedproperty 'MS_Description', N'岗位名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'post_name';
EXEC sp_addextendedproperty 'MS_Description', N'显示顺序', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'post_sort';
EXEC sp_addextendedproperty 'MS_Description', N'状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_post', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'岗位信息表', 'SCHEMA', N'dbo', 'TABLE', N'sys_post';

-- ----------------------------
-- 初始化-岗位信息表数据
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_post] ON;
INSERT INTO [dbo].[sys_post] ([post_id], [post_code], [post_name], [post_sort], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(1, 'ceo',  '董事长',    1, '0', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_post] ([post_id], [post_code], [post_name], [post_sort], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(2, 'se',   '项目经理',  2, '0', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_post] ([post_id], [post_code], [post_name], [post_sort], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(3, 'hr',   '人力资源',  3, '0', 'admin', getdate(), '', null, '');
INSERT INTO [dbo].[sys_post] ([post_id], [post_code], [post_name], [post_sort], [status], [create_by], [create_time], [update_by], [update_time], [remark]) values(4, 'user', '普通员工',  4, '0', 'admin', getdate(), '', null, '');
SET IDENTITY_INSERT [dbo].[sys_post] OFF;

GO

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_role]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_role];

CREATE TABLE [dbo].[sys_role] (
    [role_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [role_name] nvarchar(30) NOT NULL,
    [role_key] nvarchar(100) NOT NULL,
    [role_sort] int  NOT NULL,
    [data_scope] nchar(1) NULL,
    [menu_check_strictly] tinyint  NULL,
    [dept_check_strictly] tinyint  NULL,
    [status] nchar(1) NOT NULL,
    [del_flag] nchar(1) NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_role] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'角色ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'role_id';
EXEC sp_addextendedproperty 'MS_Description', N'角色名称', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'role_name';
EXEC sp_addextendedproperty 'MS_Description', N'角色权限字符串', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'role_key';
EXEC sp_addextendedproperty 'MS_Description', N'显示顺序', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'role_sort';
EXEC sp_addextendedproperty 'MS_Description', N'数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'data_scope';
EXEC sp_addextendedproperty 'MS_Description', N'菜单树选择项是否关联显示', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'menu_check_strictly';
EXEC sp_addextendedproperty 'MS_Description', N'部门树选择项是否关联显示', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'dept_check_strictly';
EXEC sp_addextendedproperty 'MS_Description', N'角色状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'删除标志（0代表存在 2代表删除）', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'del_flag';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_role', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'角色信息表', 'SCHEMA', N'dbo', 'TABLE', N'sys_role';

-- ----------------------------
-- 初始化-角色信息表数据
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_role] ON;
INSERT INTO [dbo].[sys_role] ([role_id], [role_name], [role_key], [role_sort], [data_scope], [menu_check_strictly], [dept_check_strictly], [status], [del_flag], [create_by], [create_time], [update_by], [update_time], [remark]) values('1', '超级管理员',  'admin',  1, 1, 1, 1, '0', '0', 'admin', getdate(), '', null, '超级管理员');
INSERT INTO [dbo].[sys_role] ([role_id], [role_name], [role_key], [role_sort], [data_scope], [menu_check_strictly], [dept_check_strictly], [status], [del_flag], [create_by], [create_time], [update_by], [update_time], [remark]) values('2', '普通角色',    'common', 2, 2, 1, 1, '0', '0', 'admin', getdate(), '', null, '普通角色');
SET IDENTITY_INSERT [dbo].[sys_role] OFF;

GO

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_role_dept]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_role_dept];

CREATE TABLE [dbo].[sys_role_dept] (
    [role_id] bigint  NOT NULL,
    [dept_id] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (role_id, dept_id)
);

ALTER TABLE [dbo].[sys_role_dept] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'角色ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_dept', 'COLUMN', N'role_id';
EXEC sp_addextendedproperty 'MS_Description', N'部门ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_dept', 'COLUMN', N'dept_id';
EXEC sp_addextendedproperty 'MS_Description', N'角色和部门关联表', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_dept';


-- ----------------------------
-- 初始化-角色和部门关联表数据
-- ----------------------------
INSERT INTO [dbo].[sys_role_dept] ([role_id], [dept_id]) values ('2', '100');
INSERT INTO [dbo].[sys_role_dept] ([role_id], [dept_id]) values ('2', '101');
INSERT INTO [dbo].[sys_role_dept] ([role_id], [dept_id]) values ('2', '105');

GO

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_role_menu]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_role_menu];

CREATE TABLE [dbo].[sys_role_menu] (
    [role_id] bigint  NOT NULL,
    [menu_id] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (role_id, menu_id)
);

ALTER TABLE [dbo].[sys_role_menu] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'角色ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_menu', 'COLUMN', N'role_id';
EXEC sp_addextendedproperty 'MS_Description', N'菜单ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_menu', 'COLUMN', N'menu_id';
EXEC sp_addextendedproperty 'MS_Description', N'角色和菜单关联表', 'SCHEMA', N'dbo', 'TABLE', N'sys_role_menu';

-- ----------------------------
-- 初始化-角色和菜单关联表数据
-- ----------------------------
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '2');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '3');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '4');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '100');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '101');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '102');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '103');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '104');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '105');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '106');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '107');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '108');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '109');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '110');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '111');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '112');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '113');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '114');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '115');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '116');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '117');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '500');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '501');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1000');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1001');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1002');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1003');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1004');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1005');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1006');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1007');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1008');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1009');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1010');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1011');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1012');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1013');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1014');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1015');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1016');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1017');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1018');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1019');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1020');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1021');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1022');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1023');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1024');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1025');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1026');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1027');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1028');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1029');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1030');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1031');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1032');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1033');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1034');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1035');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1036');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1037');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1038');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1039');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1040');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1041');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1042');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1043');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1044');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1045');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1046');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1047');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1048');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1049');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1050');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1051');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1052');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1053');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1054');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1055');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1056');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1057');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1058');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1059');
INSERT INTO [dbo].[sys_role_menu] ([role_id], [menu_id]) values ('2', '1060');

GO

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_user]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_user];

CREATE TABLE [dbo].[sys_user] (
    [user_id] bigint  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [dept_id] bigint  NULL,
    [user_name] nvarchar(30) NOT NULL,
    [nick_name] nvarchar(30) NOT NULL,
    [user_type] nvarchar(2) NULL,
    [email] nvarchar(50) NULL,
    [phonenumber] nvarchar(11) NULL,
    [sex] nchar(1) NULL,
    [avatar] nvarchar(100) NULL,
    [password] nvarchar(100) NULL,
    [status] nchar(1) NULL,
    [del_flag] nchar(1) DEFAULT '0' NULL,
    [login_ip] nvarchar(128) NULL,
    [login_date] datetime2(7)  NULL,
    [pwd_update_date] datetime2(7)  NULL,
    [create_by] nvarchar(64) NULL,
    [create_time] datetime2(7)  NULL,
    [update_by] nvarchar(64) NULL,
    [update_time] datetime2(7)  NULL,
    [remark] nvarchar(500) NULL
);

ALTER TABLE [dbo].[sys_user] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'用户ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'user_id';
EXEC sp_addextendedproperty 'MS_Description', N'部门ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'dept_id';
EXEC sp_addextendedproperty 'MS_Description', N'用户账号', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'user_name';
EXEC sp_addextendedproperty 'MS_Description', N'用户昵称', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'nick_name';
EXEC sp_addextendedproperty 'MS_Description', N'用户类型（00系统用户）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'user_type';
EXEC sp_addextendedproperty 'MS_Description', N'用户邮箱', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'email';
EXEC sp_addextendedproperty 'MS_Description', N'手机号码', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'phonenumber';
EXEC sp_addextendedproperty 'MS_Description', N'用户性别（0男 1女 2未知）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'sex';
EXEC sp_addextendedproperty 'MS_Description', N'头像地址', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'avatar';
EXEC sp_addextendedproperty 'MS_Description', N'密码', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'password';
EXEC sp_addextendedproperty 'MS_Description', N'帐号状态（0正常 1停用）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'status';
EXEC sp_addextendedproperty 'MS_Description', N'删除标志（0代表存在 2代表删除）', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'del_flag';
EXEC sp_addextendedproperty 'MS_Description', N'最后登录IP', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'login_ip';
EXEC sp_addextendedproperty 'MS_Description', N'最后登录时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'login_date';
EXEC sp_addextendedproperty 'MS_Description', N'创建者', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'create_by';
EXEC sp_addextendedproperty 'MS_Description', N'创建时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'create_time';
EXEC sp_addextendedproperty 'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'update_by';
EXEC sp_addextendedproperty 'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'update_time';
EXEC sp_addextendedproperty 'MS_Description', N'备注', 'SCHEMA', N'dbo', 'TABLE', N'sys_user', 'COLUMN', N'remark';
EXEC sp_addextendedproperty 'MS_Description', N'用户信息表', 'SCHEMA', N'dbo', 'TABLE', N'sys_user';

-- ----------------------------
-- 初始化-用户信息表数据
-- ----------------------------
SET IDENTITY_INSERT [dbo].[sys_user] ON;
INSERT INTO [dbo].[sys_user] ([user_id], [dept_id], [user_name], [nick_name], [user_type], [email], [phonenumber], [sex], [avatar], [password], [status], [del_flag], [login_ip], [login_date], [pwd_update_date], [create_by], [create_time], [update_by], [update_time], [remark]) values(1,  103, 'admin', '若依', '00', 'ry@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', getdate(), getdate(), 'admin', getdate(), '', null, '管理员');
INSERT INTO [dbo].[sys_user] ([user_id], [dept_id], [user_name], [nick_name], [user_type], [email], [phonenumber], [sex], [avatar], [password], [status], [del_flag], [login_ip], [login_date], [pwd_update_date], [create_by], [create_time], [update_by], [update_time], [remark]) values(2,  105, 'ry',    '若依', '00', 'ry@qq.com',  '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', getdate(), getdate(), 'admin', getdate(), '', null, '测试员');
SET IDENTITY_INSERT [dbo].[sys_user] OFF;

GO

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_user_post]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_user_post];

CREATE TABLE [dbo].[sys_user_post] (
    [user_id] bigint  NOT NULL,
    [post_id] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (user_id, post_id)
);

ALTER TABLE [dbo].[sys_user_post] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'用户ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_post', 'COLUMN', N'user_id';
EXEC sp_addextendedproperty 'MS_Description', N'岗位ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_post', 'COLUMN', N'post_id';
EXEC sp_addextendedproperty 'MS_Description', N'用户与岗位关联表', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_post';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO [dbo].[sys_user_post] ([user_id], [post_id]) VALUES (N'1', N'1');
INSERT INTO [dbo].[sys_user_post] ([user_id], [post_id]) VALUES (N'2', N'2');

GO

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[sys_user_role]') AND type IN ('U'))
    DROP TABLE [dbo].[sys_user_role];

CREATE TABLE [dbo].[sys_user_role] (
    [user_id] bigint  NOT NULL,
    [role_id] bigint  NOT NULL,
    PRIMARY KEY CLUSTERED (user_id, role_id)
);

ALTER TABLE [dbo].[sys_user_role] SET (LOCK_ESCALATION = TABLE);
EXEC sp_addextendedproperty 'MS_Description', N'用户ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_role', 'COLUMN', N'user_id';
EXEC sp_addextendedproperty 'MS_Description', N'角色ID', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_role', 'COLUMN', N'role_id';
EXEC sp_addextendedproperty 'MS_Description', N'用户和角色关联表', 'SCHEMA', N'dbo', 'TABLE', N'sys_user_role';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO [dbo].[sys_user_role] ([user_id], [role_id]) VALUES (N'1', N'1');
INSERT INTO [dbo].[sys_user_role] ([user_id], [role_id]) VALUES (N'2', N'2');

GO

-- ----------------------------
-- Table structure for voucher
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[voucher]') AND type IN ('U'))
    DROP TABLE [dbo].[voucher];

CREATE TABLE [dbo].[voucher] (
    [f_voucher_id] int  IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [f_date] datetime2(7)  NOT NULL,
    [f_bus_date] datetime2(7)  NOT NULL,
    [f_period] int  NOT NULL,
    [f_voucher_group_no] nvarchar(50) NOT NULL,
    [entry_no] int  NOT NULL,
    [f_explanation] nvarchar(255) NOT NULL,
    [f_account_id] nvarchar(20) NOT NULL,
    [direction] int  NOT NULL,
    [f_amount_for] int  NOT NULL,
    [f_attachments] int  NOT NULL,
    [f_detail] nvarchar(255) NULL
);

ALTER TABLE [dbo].[voucher] SET (LOCK_ESCALATION = TABLE);


-- ----------------------------
-- Records of voucher
-- ----------------------------
SET IDENTITY_INSERT [dbo].[voucher] ON;
INSERT INTO [dbo].[voucher] ([f_voucher_id], [f_date], [f_bus_date], [f_period], [f_voucher_group_no], [entry_no], [f_explanation], [f_account_id], [direction], [f_amount_for], [f_attachments], [f_detail]) VALUES (N'1', N'2023-01-05 00:00:00.0000000', N'2023-01-05 00:00:00.0000000', N'1', N'00001', N'1', N'0509-CL-202210-0107/廖伟/与垫江试验人员对接，完成配备调试、设备更换等工作', N'5101.05.01.03', N'1', N'50', N'4', N'部门--05090205--1B6A汽车电子及信息测试研究事业部');
SET IDENTITY_INSERT [dbo].[voucher] OFF;
