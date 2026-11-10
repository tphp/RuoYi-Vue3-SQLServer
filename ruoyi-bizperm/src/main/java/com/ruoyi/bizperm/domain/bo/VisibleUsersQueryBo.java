/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.bo;

/**
 * 可见人员查询参数
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class VisibleUsersQueryBo
{
    /** 业务场景编码 */
    private String policyCode;

    /** 权限归属人工号 */
    private String userCode;

    /** 是否按部门分组 */
    private Boolean groupByDept = Boolean.FALSE;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页条数 */
    private Integer pageSize = 50;

    public String getPolicyCode()
    {
        return policyCode;
    }

    public void setPolicyCode(String policyCode)
    {
        this.policyCode = policyCode;
    }

    public String getUserCode()
    {
        return userCode;
    }

    public void setUserCode(String userCode)
    {
        this.userCode = userCode;
    }

    public Boolean getGroupByDept()
    {
        return groupByDept;
    }

    public void setGroupByDept(Boolean groupByDept)
    {
        this.groupByDept = groupByDept;
    }

    public Integer getPageNum()
    {
        return pageNum;
    }

    public void setPageNum(Integer pageNum)
    {
        this.pageNum = pageNum;
    }

    public Integer getPageSize()
    {
        return pageSize;
    }

    public void setPageSize(Integer pageSize)
    {
        this.pageSize = pageSize;
    }
}
