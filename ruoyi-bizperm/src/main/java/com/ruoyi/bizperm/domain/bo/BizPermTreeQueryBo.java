/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.bo;

/**
 * 权限结构树查询参数
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class BizPermTreeQueryBo
{
    /** 业务场景编码 */
    private String policyCode;

    /** 权限归属人工号（管理员筛选） */
    private String ownerUserCode;

    /** 关键字：归属人工号/姓名、场景编码/名称 */
    private String keyword;

    /** 状态：0启用 1停用 */
    private String status;

    /** 返回层级：1~3，默认 3 */
    private Integer depth = 3;

    /** 是否统计人数，默认 false */
    private Boolean withCount = Boolean.FALSE;

    public String getPolicyCode()
    {
        return policyCode;
    }

    public void setPolicyCode(String policyCode)
    {
        this.policyCode = policyCode;
    }

    public String getOwnerUserCode()
    {
        return ownerUserCode;
    }

    public void setOwnerUserCode(String ownerUserCode)
    {
        this.ownerUserCode = ownerUserCode;
    }

    public String getKeyword()
    {
        return keyword;
    }

    public void setKeyword(String keyword)
    {
        this.keyword = keyword;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public Integer getDepth()
    {
        return depth;
    }

    public void setDepth(Integer depth)
    {
        this.depth = depth;
    }

    public Boolean getWithCount()
    {
        return withCount;
    }

    public void setWithCount(Boolean withCount)
    {
        this.withCount = withCount;
    }
}
