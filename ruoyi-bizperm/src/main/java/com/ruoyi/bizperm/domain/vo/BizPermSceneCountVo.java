/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

/**
 * 场景级可见人数统计
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class BizPermSceneCountVo
{
    /** 归属人类型 */
    private String subjectType;

    /** 归属人值 */
    private String subjectValue;

    /** 业务场景编码 */
    private String policyCode;

    /** 可见人数（去重） */
    private Long userCount;

    public String getSubjectType()
    {
        return subjectType;
    }

    public void setSubjectType(String subjectType)
    {
        this.subjectType = subjectType;
    }

    public String getSubjectValue()
    {
        return subjectValue;
    }

    public void setSubjectValue(String subjectValue)
    {
        this.subjectValue = subjectValue;
    }

    public String getPolicyCode()
    {
        return policyCode;
    }

    public void setPolicyCode(String policyCode)
    {
        this.policyCode = policyCode;
    }

    public Long getUserCount()
    {
        return userCount;
    }

    public void setUserCount(Long userCount)
    {
        this.userCount = userCount;
    }
}
