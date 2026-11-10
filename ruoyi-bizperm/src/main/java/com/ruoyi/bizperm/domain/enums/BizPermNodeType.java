/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.enums;

/**
 * 权限结构树节点类型
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public enum BizPermNodeType
{
    /** 权限归属人 */
    OWNER("OWNER", "权限归属人"),
    /** 业务场景 */
    SCENE("SCENE", "业务场景"),
    /** 部门范围 */
    DEPT("DEPT", "部门范围"),
    /** 人员/岗位范围 */
    SCOPE("SCOPE", "其他范围"),
    /** 员工 */
    EMPLOYEE("EMPLOYEE", "员工");

    private final String code;

    private final String label;

    BizPermNodeType(String code, String label)
    {
        this.code = code;
        this.label = label;
    }

    public String getCode()
    {
        return code;
    }

    public String getLabel()
    {
        return label;
    }
}
