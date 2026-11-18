-- ============================================================
-- sys_dict_data 增加字典标签英文名字段脚本（MSSQL）
--
-- 用途：为存量 sys_dict_data 表补充 dict_label_en 字段（字典标签英文名），
--       实现英文界面下字典文案（如「正常/停用」）显示为英文
-- 说明：
--   1. 本脚本可重复执行（幂等）：加列语句会先判断列是否存在，补数据只更新 dict_label_en 为空的记录
--   2. 执行前请先备份 sys_dict_data 表
--   3. 执行完成后需刷新字典缓存（前端「字典管理 → 刷新缓存」按钮，或重启后端）
--   4. 若数据库是用 sql/sqlserver.sql 全新重建的（已含该列与英文数据），加列与补数据步骤会自动跳过
--   5. 未在列表中的自定义字典保持为空，前端会自动回退显示中文标签
--
-- 注意：MSSQL 在编译期即校验列是否存在，因此「加列」与「补数据」必须用 GO 分成两个批次执行
-- ============================================================

SET NOCOUNT ON;

-- ============================================================
-- 步骤 1：增加 dict_label_en 字段（列不存在时才执行）
-- ============================================================
IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[sys_dict_data]')
      AND name = 'dict_label_en'
)
BEGIN
    PRINT '正在为 sys_dict_data 表增加 dict_label_en 字段...';
    ALTER TABLE [dbo].[sys_dict_data] ADD [dict_label_en] nvarchar(100) DEFAULT '' NULL;
    PRINT 'dict_label_en 字段添加完成。';
END
ELSE
BEGIN
    PRINT 'dict_label_en 字段已存在，跳过加列步骤。';
END

-- 添加字段注释（注释不存在时才执行）
IF NOT EXISTS (
    SELECT 1 FROM sys.extended_properties
    WHERE major_id = OBJECT_ID(N'[dbo].[sys_dict_data]')
      AND minor_id = COLUMNPROPERTY(OBJECT_ID(N'[dbo].[sys_dict_data]'), 'dict_label_en', 'ColumnId')
      AND name = 'MS_Description'
)
BEGIN
    EXEC sp_addextendedproperty 'MS_Description', N'字典标签（英文）', 'SCHEMA', N'dbo', 'TABLE', N'sys_dict_data', 'COLUMN', N'dict_label_en';
    PRINT 'dict_label_en 字段注释添加完成。';
END
ELSE
BEGIN
    PRINT 'dict_label_en 字段注释已存在，跳过。';
END

GO
-- ============================================================
-- 步骤 2：补全存量字典的英文标签（只更新为空的记录）
-- ============================================================

-- 用户性别
UPDATE sys_dict_data SET dict_label_en = 'Male'   WHERE dict_type = 'sys_user_sex' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Female' WHERE dict_type = 'sys_user_sex' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Unknown' WHERE dict_type = 'sys_user_sex' AND dict_value = '2' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 显示隐藏
UPDATE sys_dict_data SET dict_label_en = 'Show' WHERE dict_type = 'sys_show_hide' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Hide' WHERE dict_type = 'sys_show_hide' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 正常停用
UPDATE sys_dict_data SET dict_label_en = 'Normal'   WHERE dict_type = 'sys_normal_disable' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Disabled' WHERE dict_type = 'sys_normal_disable' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 任务状态
UPDATE sys_dict_data SET dict_label_en = 'Normal' WHERE dict_type = 'sys_job_status' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Paused' WHERE dict_type = 'sys_job_status' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 任务分组
UPDATE sys_dict_data SET dict_label_en = 'Default' WHERE dict_type = 'sys_job_group' AND dict_value = 'DEFAULT' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'System'  WHERE dict_type = 'sys_job_group' AND dict_value = 'SYSTEM'  AND (dict_label_en IS NULL OR dict_label_en = '');

-- 是否
UPDATE sys_dict_data SET dict_label_en = 'Yes' WHERE dict_type = 'sys_yes_no' AND dict_value = 'Y' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'No'  WHERE dict_type = 'sys_yes_no' AND dict_value = 'N' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 通知类型
UPDATE sys_dict_data SET dict_label_en = 'Notification'  WHERE dict_type = 'sys_notice_type' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Announcement' WHERE dict_type = 'sys_notice_type' AND dict_value = '2' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 通知状态
UPDATE sys_dict_data SET dict_label_en = 'Normal' WHERE dict_type = 'sys_notice_status' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Closed' WHERE dict_type = 'sys_notice_status' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 操作类型
UPDATE sys_dict_data SET dict_label_en = 'Other'         WHERE dict_type = 'sys_oper_type' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Insert'        WHERE dict_type = 'sys_oper_type' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Update'        WHERE dict_type = 'sys_oper_type' AND dict_value = '2' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Delete'        WHERE dict_type = 'sys_oper_type' AND dict_value = '3' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Grant'         WHERE dict_type = 'sys_oper_type' AND dict_value = '4' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Export'        WHERE dict_type = 'sys_oper_type' AND dict_value = '5' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Import'        WHERE dict_type = 'sys_oper_type' AND dict_value = '6' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Force Logout'  WHERE dict_type = 'sys_oper_type' AND dict_value = '7' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Generate Code' WHERE dict_type = 'sys_oper_type' AND dict_value = '8' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Clear Data'    WHERE dict_type = 'sys_oper_type' AND dict_value = '9' AND (dict_label_en IS NULL OR dict_label_en = '');

-- 通用状态
UPDATE sys_dict_data SET dict_label_en = 'Success' WHERE dict_type = 'sys_common_status' AND dict_value = '0' AND (dict_label_en IS NULL OR dict_label_en = '');
UPDATE sys_dict_data SET dict_label_en = 'Failed'  WHERE dict_type = 'sys_common_status' AND dict_value = '1' AND (dict_label_en IS NULL OR dict_label_en = '');

GO
-- ============================================================
-- 步骤 3：校验结果
-- ============================================================
SELECT dict_type, dict_value, dict_label, dict_label_en
FROM sys_dict_data
WHERE dict_label_en IS NOT NULL AND dict_label_en <> ''
ORDER BY dict_type, dict_sort;

GO
