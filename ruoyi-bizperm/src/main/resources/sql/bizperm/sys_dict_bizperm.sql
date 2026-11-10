-- =============================================================
-- 业务级权限：场景字典
-- 数据库：SQL Server
-- 说明：场景编码可按实际业务继续补充
-- =============================================================

INSERT INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark)
VALUES (N'业务权限场景', N'biz_perm_policy', '0', N'admin', getdate(), N'业务级权限场景编码');

INSERT INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark)
VALUES
(1, N'客户查看范围', N'customer:view', N'biz_perm_policy', '', 'primary', 'N', '0', N'admin', getdate(), N''),
(2, N'合同查看范围', N'contract:view', N'biz_perm_policy', '', 'primary', 'N', '0', N'admin', getdate(), N'');
GO
