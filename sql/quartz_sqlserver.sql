/**
 * @author Zhang zhan
 * @date 2026-06-17
 */
-- Quartz SQL Server 脚本

-- 删除已存在的表（注意顺序，先删除有外键依赖的表）
IF OBJECT_ID('QRTZ_FIRED_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_FIRED_TRIGGERS;
IF OBJECT_ID('QRTZ_PAUSED_TRIGGER_GRPS') IS NOT NULL DROP TABLE QRTZ_PAUSED_TRIGGER_GRPS;
IF OBJECT_ID('QRTZ_SCHEDULER_STATE') IS NOT NULL DROP TABLE QRTZ_SCHEDULER_STATE;
IF OBJECT_ID('QRTZ_LOCKS') IS NOT NULL DROP TABLE QRTZ_LOCKS;
IF OBJECT_ID('QRTZ_SIMPLE_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_SIMPLE_TRIGGERS;
IF OBJECT_ID('QRTZ_SIMPROP_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_SIMPROP_TRIGGERS;
IF OBJECT_ID('QRTZ_CRON_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_CRON_TRIGGERS;
IF OBJECT_ID('QRTZ_BLOB_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_BLOB_TRIGGERS;
IF OBJECT_ID('QRTZ_TRIGGERS') IS NOT NULL DROP TABLE QRTZ_TRIGGERS;
IF OBJECT_ID('QRTZ_JOB_DETAILS') IS NOT NULL DROP TABLE QRTZ_JOB_DETAILS;
IF OBJECT_ID('QRTZ_CALENDARS') IS NOT NULL DROP TABLE QRTZ_CALENDARS;
GO

-- ----------------------------
-- 1、存储每一个已配置的 jobDetail 的详细信息
-- ----------------------------
CREATE TABLE QRTZ_JOB_DETAILS (
    sched_name           NVARCHAR(120)    NOT NULL,
    job_name             NVARCHAR(200)    NOT NULL,
    job_group            NVARCHAR(200)    NOT NULL,
    description          NVARCHAR(250)    NULL,
    job_class_name       NVARCHAR(250)    NOT NULL,
    is_durable           NVARCHAR(1)      NOT NULL,
    is_nonconcurrent     NVARCHAR(1)      NOT NULL,
    is_update_data       NVARCHAR(1)      NOT NULL,
    requests_recovery    NVARCHAR(1)      NOT NULL,
    job_data             VARBINARY(MAX)   NULL,
    PRIMARY KEY (sched_name, job_name, job_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'相关介绍', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'description';
EXEC sp_addextendedproperty 'MS_Description', N'执行任务类名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'job_class_name';
EXEC sp_addextendedproperty 'MS_Description', N'是否持久化', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'is_durable';
EXEC sp_addextendedproperty 'MS_Description', N'是否并发', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'is_nonconcurrent';
EXEC sp_addextendedproperty 'MS_Description', N'是否更新数据', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'is_update_data';
EXEC sp_addextendedproperty 'MS_Description', N'是否接受恢复执行', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'requests_recovery';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化job对象', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', 'COLUMN', 'job_data';
EXEC sp_addextendedproperty 'MS_Description', N'任务详细信息表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_JOB_DETAILS', NULL, NULL;
GO

-- ----------------------------
-- 2、 存储已配置的 Trigger 的信息
-- ----------------------------
CREATE TABLE QRTZ_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    job_name             NVARCHAR(200)    NOT NULL,
    job_group            NVARCHAR(200)    NOT NULL,
    description          NVARCHAR(250)    NULL,
    next_fire_time       BIGINT           NULL,
    prev_fire_time       BIGINT           NULL,
    priority             INT              NULL,
    trigger_state        NVARCHAR(16)     NOT NULL,
    trigger_type         NVARCHAR(8)      NOT NULL,
    start_time           BIGINT           NOT NULL,
    end_time             BIGINT           NULL,
    calendar_name        NVARCHAR(200)    NULL,
    misfire_instr        SMALLINT         NULL,
    job_data             VARBINARY(MAX)   NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, job_name, job_group) REFERENCES QRTZ_JOB_DETAILS(sched_name, job_name, job_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发器的名字', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发器所属组的名字', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_job_details表job_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_job_details表job_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'相关介绍', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'description';
EXEC sp_addextendedproperty 'MS_Description', N'上一次触发时间（毫秒）', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'next_fire_time';
EXEC sp_addextendedproperty 'MS_Description', N'下一次触发时间（默认为-1表示不触发）', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'prev_fire_time';
EXEC sp_addextendedproperty 'MS_Description', N'优先级', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'priority';
EXEC sp_addextendedproperty 'MS_Description', N'触发器状态', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'trigger_state';
EXEC sp_addextendedproperty 'MS_Description', N'触发器的类型', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'trigger_type';
EXEC sp_addextendedproperty 'MS_Description', N'开始时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'start_time';
EXEC sp_addextendedproperty 'MS_Description', N'结束时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'end_time';
EXEC sp_addextendedproperty 'MS_Description', N'日程表名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'calendar_name';
EXEC sp_addextendedproperty 'MS_Description', N'补偿执行的策略', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'misfire_instr';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化job对象', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', 'COLUMN', 'job_data';
EXEC sp_addextendedproperty 'MS_Description', N'触发器详细信息表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_TRIGGERS', NULL, NULL;
GO

-- ----------------------------
-- 3、 存储简单的 Trigger，包括重复次数，间隔，以及已触发的次数
-- ----------------------------
CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    repeat_count         BIGINT           NOT NULL,
    repeat_interval      BIGINT           NOT NULL,
    times_triggered      BIGINT           NOT NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'重复的次数统计', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'repeat_count';
EXEC sp_addextendedproperty 'MS_Description', N'重复的间隔时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'repeat_interval';
EXEC sp_addextendedproperty 'MS_Description', N'已经触发的次数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', 'COLUMN', 'times_triggered';
EXEC sp_addextendedproperty 'MS_Description', N'简单触发器的信息表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPLE_TRIGGERS', NULL, NULL;
GO

-- ----------------------------
-- 4、 存储 Cron Trigger，包括 Cron 表达式和时区信息
-- ----------------------------
CREATE TABLE QRTZ_CRON_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    cron_expression      NVARCHAR(200)    NOT NULL,
    time_zone_id         NVARCHAR(80)     NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'cron表达式', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', 'COLUMN', 'cron_expression';
EXEC sp_addextendedproperty 'MS_Description', N'时区', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', 'COLUMN', 'time_zone_id';
EXEC sp_addextendedproperty 'MS_Description', N'Cron类型的触发器表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CRON_TRIGGERS', NULL, NULL;
GO

-- ----------------------------
-- 5、 Trigger 作为 Blob 类型存储(用于 Quartz 用户用 JDBC 创建他们自己定制的 Trigger 类型，JobStore 并不知道如何存储实例的时候)
-- ----------------------------
CREATE TABLE QRTZ_BLOB_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    blob_data            VARBINARY(MAX)   NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_BLOB_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_BLOB_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_BLOB_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化Trigger对象', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_BLOB_TRIGGERS', 'COLUMN', 'blob_data';
EXEC sp_addextendedproperty 'MS_Description', N'Blob类型的触发器表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_BLOB_TRIGGERS', NULL, NULL;
GO

-- ----------------------------
-- 6、 以 Blob 类型存储存放日历信息， quartz可配置一个日历来指定一个时间范围
-- ----------------------------
CREATE TABLE QRTZ_CALENDARS (
    sched_name           NVARCHAR(120)    NOT NULL,
    calendar_name        NVARCHAR(200)    NOT NULL,
    calendar             VARBINARY(MAX)   NOT NULL,
    PRIMARY KEY (sched_name, calendar_name)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CALENDARS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'日历名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CALENDARS', 'COLUMN', 'calendar_name';
EXEC sp_addextendedproperty 'MS_Description', N'存放持久化calendar对象', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CALENDARS', 'COLUMN', 'calendar';
EXEC sp_addextendedproperty 'MS_Description', N'日历信息表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_CALENDARS', NULL, NULL;
GO

-- ----------------------------
-- 7、 存储已暂停的 Trigger 组的信息
-- ----------------------------
CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    PRIMARY KEY (sched_name, trigger_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_PAUSED_TRIGGER_GRPS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_PAUSED_TRIGGER_GRPS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'暂停的触发器表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_PAUSED_TRIGGER_GRPS', NULL, NULL;
GO

-- ----------------------------
-- 8、 存储与已触发的 Trigger 相关的状态信息，以及相联 Job 的执行信息
-- ----------------------------
CREATE TABLE QRTZ_FIRED_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    entry_id             NVARCHAR(95)     NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    instance_name        NVARCHAR(200)    NOT NULL,
    fired_time           BIGINT           NOT NULL,
    sched_time           BIGINT           NOT NULL,
    priority             INT              NOT NULL,
    state                NVARCHAR(16)     NOT NULL,
    job_name             NVARCHAR(200)    NULL,
    job_group            NVARCHAR(200)    NULL,
    is_nonconcurrent     NVARCHAR(1)      NULL,
    requests_recovery    NVARCHAR(1)      NULL,
    PRIMARY KEY (sched_name, entry_id)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'调度器实例id', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'entry_id';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'调度器实例名', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'instance_name';
EXEC sp_addextendedproperty 'MS_Description', N'触发的时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'fired_time';
EXEC sp_addextendedproperty 'MS_Description', N'定时器制定的时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'sched_time';
EXEC sp_addextendedproperty 'MS_Description', N'优先级', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'priority';
EXEC sp_addextendedproperty 'MS_Description', N'状态', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'state';
EXEC sp_addextendedproperty 'MS_Description', N'任务名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'job_name';
EXEC sp_addextendedproperty 'MS_Description', N'任务组名', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'job_group';
EXEC sp_addextendedproperty 'MS_Description', N'是否并发', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'is_nonconcurrent';
EXEC sp_addextendedproperty 'MS_Description', N'是否接受恢复执行', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', 'COLUMN', 'requests_recovery';
EXEC sp_addextendedproperty 'MS_Description', N'已触发的触发器表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_FIRED_TRIGGERS', NULL, NULL;
GO

-- ----------------------------
-- 9、 存储少量的有关 Scheduler 的状态信息，假如是用于集群中，可以看到其他的 Scheduler 实例
-- ----------------------------
CREATE TABLE QRTZ_SCHEDULER_STATE (
    sched_name           NVARCHAR(120)    NOT NULL,
    instance_name        NVARCHAR(200)    NOT NULL,
    last_checkin_time    BIGINT           NOT NULL,
    checkin_interval     BIGINT           NOT NULL,
    PRIMARY KEY (sched_name, instance_name)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SCHEDULER_STATE', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'实例名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SCHEDULER_STATE', 'COLUMN', 'instance_name';
EXEC sp_addextendedproperty 'MS_Description', N'上次检查时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SCHEDULER_STATE', 'COLUMN', 'last_checkin_time';
EXEC sp_addextendedproperty 'MS_Description', N'检查间隔时间', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SCHEDULER_STATE', 'COLUMN', 'checkin_interval';
EXEC sp_addextendedproperty 'MS_Description', N'调度器状态表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SCHEDULER_STATE', NULL, NULL;
GO

-- ----------------------------
-- 10、 存储程序的悲观锁的信息(假如使用了悲观锁)
-- ----------------------------
CREATE TABLE QRTZ_LOCKS (
    sched_name           NVARCHAR(120)    NOT NULL,
    lock_name            NVARCHAR(40)     NOT NULL,
    PRIMARY KEY (sched_name, lock_name)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_LOCKS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'悲观锁名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_LOCKS', 'COLUMN', 'lock_name';
EXEC sp_addextendedproperty 'MS_Description', N'存储的悲观锁信息表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_LOCKS', NULL, NULL;
GO

-- ----------------------------
-- 11、 Quartz集群实现同步机制的行锁表
-- ----------------------------
CREATE TABLE QRTZ_SIMPROP_TRIGGERS (
    sched_name           NVARCHAR(120)    NOT NULL,
    trigger_name         NVARCHAR(200)    NOT NULL,
    trigger_group        NVARCHAR(200)    NOT NULL,
    str_prop_1           NVARCHAR(512)    NULL,
    str_prop_2           NVARCHAR(512)    NULL,
    str_prop_3           NVARCHAR(512)    NULL,
    int_prop_1           INT              NULL,
    int_prop_2           INT              NULL,
    long_prop_1          BIGINT           NULL,
    long_prop_2          BIGINT           NULL,
    dec_prop_1           DECIMAL(13,4)    NULL,
    dec_prop_2           DECIMAL(13,4)    NULL,
    bool_prop_1          NVARCHAR(1)      NULL,
    bool_prop_2          NVARCHAR(1)      NULL,
    PRIMARY KEY (sched_name, trigger_name, trigger_group),
    FOREIGN KEY (sched_name, trigger_name, trigger_group) REFERENCES QRTZ_TRIGGERS(sched_name, trigger_name, trigger_group)
);
GO

EXEC sp_addextendedproperty 'MS_Description', N'调度名称', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'sched_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_name的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'trigger_name';
EXEC sp_addextendedproperty 'MS_Description', N'qrtz_triggers表trigger_group的外键', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'trigger_group';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第一个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'str_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第二个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'str_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'String类型的trigger的第三个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'str_prop_3';
EXEC sp_addextendedproperty 'MS_Description', N'int类型的trigger的第一个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'int_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'int类型的trigger的第二个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'int_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'long类型的trigger的第一个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'long_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'long类型的trigger的第二个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'long_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'decimal类型的trigger的第一个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'dec_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'decimal类型的trigger的第二个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'dec_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'Boolean类型的trigger的第一个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'bool_prop_1';
EXEC sp_addextendedproperty 'MS_Description', N'Boolean类型的trigger的第二个参数', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', 'COLUMN', 'bool_prop_2';
EXEC sp_addextendedproperty 'MS_Description', N'同步机制的行锁表', 'SCHEMA', 'dbo', 'TABLE', 'QRTZ_SIMPROP_TRIGGERS', NULL, NULL;
GO