/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 业务权限可见范围对象 sys_biz_perm_scope
 *
 * 一个策略可配置多个范围；跨部门即多条 DEPT 记录。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class SysBizPermScope extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 主键 */
    private Long id;

    /** 关联策略主表 */
    private Long policyId;

    /** 范围类型：USER / POST / DEPT */
    private String scopeType;

    /** 范围值：工号 / 岗位ID / 部门ID */
    private String scopeValue;

    /** 范围名称（冗余展示） */
    private String scopeName;

    /** 部门范围是否含下级：0否 1是 */
    private String includeChild;

    /** 排序 */
    private Integer orderNum;

    public Long getId()
    {
        return id;
    }

    public void setId(Long id)
    {
        this.id = id;
    }

    public Long getPolicyId()
    {
        return policyId;
    }

    public void setPolicyId(Long policyId)
    {
        this.policyId = policyId;
    }

    public String getScopeType()
    {
        return scopeType;
    }

    public void setScopeType(String scopeType)
    {
        this.scopeType = scopeType;
    }

    public String getScopeValue()
    {
        return scopeValue;
    }

    public void setScopeValue(String scopeValue)
    {
        this.scopeValue = scopeValue;
    }

    public String getScopeName()
    {
        return scopeName;
    }

    public void setScopeName(String scopeName)
    {
        this.scopeName = scopeName;
    }

    public String getIncludeChild()
    {
        return includeChild;
    }

    public void setIncludeChild(String includeChild)
    {
        this.includeChild = includeChild;
    }

    public Integer getOrderNum()
    {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum)
    {
        this.orderNum = orderNum;
    }
}
