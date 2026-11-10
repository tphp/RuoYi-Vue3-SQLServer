/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * 按部门分组的可见人员
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class VisibleDeptGroupVo
{
    /** 部门ID */
    private Long deptId;

    /** 部门名称 */
    private String deptName;

    /** 是否含下级：0否 1是 */
    private String includeChild;

    /** 部门可见人数（去重） */
    private Long userCount;

    /** 当前页返回人数 */
    private Integer returnedCount;

    /** 当前页人员 */
    private List<VisibleUserVo> users = new ArrayList<>();

    public Long getDeptId()
    {
        return deptId;
    }

    public void setDeptId(Long deptId)
    {
        this.deptId = deptId;
    }

    public String getDeptName()
    {
        return deptName;
    }

    public void setDeptName(String deptName)
    {
        this.deptName = deptName;
    }

    public String getIncludeChild()
    {
        return includeChild;
    }

    public void setIncludeChild(String includeChild)
    {
        this.includeChild = includeChild;
    }

    public Long getUserCount()
    {
        return userCount;
    }

    public void setUserCount(Long userCount)
    {
        this.userCount = userCount;
    }

    public Integer getReturnedCount()
    {
        return returnedCount;
    }

    public void setReturnedCount(Integer returnedCount)
    {
        this.returnedCount = returnedCount;
    }

    public List<VisibleUserVo> getUsers()
    {
        return users;
    }

    public void setUsers(List<VisibleUserVo> users)
    {
        this.users = users;
    }
}
