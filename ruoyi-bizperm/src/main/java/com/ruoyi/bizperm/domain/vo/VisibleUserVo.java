/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

/**
 * 可见人员
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class VisibleUserVo
{
    /** 工号 */
    private String userCode;

    /** 姓名 */
    private String nickName;

    /** 部门ID */
    private Long deptId;

    /** 部门名称 */
    private String deptName;

    public String getUserCode()
    {
        return userCode;
    }

    public void setUserCode(String userCode)
    {
        this.userCode = userCode;
    }

    public String getNickName()
    {
        return nickName;
    }

    public void setNickName(String nickName)
    {
        this.nickName = nickName;
    }

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
}
