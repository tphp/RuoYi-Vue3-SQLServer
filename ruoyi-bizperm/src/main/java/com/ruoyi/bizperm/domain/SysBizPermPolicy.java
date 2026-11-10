/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain;

import java.util.List;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 业务权限策略对象 sys_biz_perm_policy
 *
 * 一行表示某业务场景下，一个权限归属人拥有哪些可见范围。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class SysBizPermPolicy extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 业务权限场景编码 */
    private String policyCode;

    /** 业务权限场景名称 */
    private String policyName;

    /** 权限归属人类型：USER / POST / DEPT */
    private String subjectType;

    /** 权限归属人值：工号 / 岗位ID / 部门ID */
    private String subjectValue;

    /** 权限归属人名称（冗余展示） */
    private String subjectName;

    /** 归属人为部门时是否含下级：0否 1是 */
    private String includeChild;

    /** 状态：0启用 1停用 */
    private String status;

    /** 可见范围明细（新增/修改时一并提交；为 null 表示本次不调整范围） */
    private List<SysBizPermScope> scopes;

    /** 非数据库字段：可见范围中是否存在含下级的部门（0否 1是），列表展示用 */
    private String scopeIncludeChild;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public String getPolicyCode()
    {
        return policyCode;
    }

    public void setPolicyCode(String policyCode)
    {
        this.policyCode = policyCode;
    }

    public String getPolicyName()
    {
        return policyName;
    }

    public void setPolicyName(String policyName)
    {
        this.policyName = policyName;
    }

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

    public String getSubjectName()
    {
        return subjectName;
    }

    public void setSubjectName(String subjectName)
    {
        this.subjectName = subjectName;
    }

    public String getIncludeChild()
    {
        return includeChild;
    }

    public void setIncludeChild(String includeChild)
    {
        this.includeChild = includeChild;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public List<SysBizPermScope> getScopes()
    {
        return scopes;
    }

    public void setScopes(List<SysBizPermScope> scopes)
    {
        this.scopes = scopes;
    }

    public String getScopeIncludeChild()
    {
        return scopeIncludeChild;
    }

    public void setScopeIncludeChild(String scopeIncludeChild)
    {
        this.scopeIncludeChild = scopeIncludeChild;
    }
}
