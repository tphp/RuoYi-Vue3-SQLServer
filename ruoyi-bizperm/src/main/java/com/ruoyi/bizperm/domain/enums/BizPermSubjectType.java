/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.enums;

/**
 * 权限归属人类型
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public enum BizPermSubjectType
{
    /** 人员 */
    USER("USER", "人员"),
    /** 岗位 */
    POST("POST", "岗位"),
    /** 部门 */
    DEPT("DEPT", "部门");

    private final String code;

    private final String label;

    BizPermSubjectType(String code, String label)
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

    /**
     * 根据编码解析枚举
     *
     * @param code 编码
     * @return 枚举，未匹配时返回 null
     */
    public static BizPermSubjectType fromCode(String code)
    {
        for (BizPermSubjectType type : values())
        {
            if (type.code.equals(code))
            {
                return type;
            }
        }
        return null;
    }
}
