/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * 可见人员查询结果
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class VisibleUsersResultVo
{
    /** 业务场景编码 */
    private String policyCode;

    /** 权限归属人工号 */
    private String userCode;

    /** 可见人数（去重） */
    private Long total;

    /** 可见工号集合（平铺模式返回） */
    private List<String> userCodes = new ArrayList<>();

    /** 可见人员（平铺模式返回） */
    private List<VisibleUserVo> users = new ArrayList<>();

    /** 按部门分组结果（分组模式返回） */
    private List<VisibleDeptGroupVo> departments = new ArrayList<>();

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

    public Long getTotal()
    {
        return total;
    }

    public void setTotal(Long total)
    {
        this.total = total;
    }

    public List<String> getUserCodes()
    {
        return userCodes;
    }

    public void setUserCodes(List<String> userCodes)
    {
        this.userCodes = userCodes;
    }

    public List<VisibleUserVo> getUsers()
    {
        return users;
    }

    public void setUsers(List<VisibleUserVo> users)
    {
        this.users = users;
    }

    public List<VisibleDeptGroupVo> getDepartments()
    {
        return departments;
    }

    public void setDepartments(List<VisibleDeptGroupVo> departments)
    {
        this.departments = departments;
    }
}
