/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

/**
 * 按部门分组时的人员行
 *
 * 同时携带“归属分组部门”和“员工实际部门”，用于分组分页后回填。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class VisibleDeptUserVo
{
    /** 归属分组部门ID */
    private Long groupDeptId;

    /** 归属分组部门名称 */
    private String groupDeptName;

    /** 分组部门是否含下级：0否 1是 */
    private String includeChild;

    /** 工号 */
    private String userCode;

    /** 姓名 */
    private String nickName;

    /** 员工实际部门ID */
    private Long deptId;

    /** 员工实际部门名称 */
    private String deptName;

    public Long getGroupDeptId()
    {
        return groupDeptId;
    }

    public void setGroupDeptId(Long groupDeptId)
    {
        this.groupDeptId = groupDeptId;
    }

    public String getGroupDeptName()
    {
        return groupDeptName;
    }

    public void setGroupDeptName(String groupDeptName)
    {
        this.groupDeptName = groupDeptName;
    }

    public String getIncludeChild()
    {
        return includeChild;
    }

    public void setIncludeChild(String includeChild)
    {
        this.includeChild = includeChild;
    }

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
