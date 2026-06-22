package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;

/**
 * 用户最近信息关联对象 sys_user_recently
 * 
 * @author ruoyi
 * @date 2026-06-18
 */
public class SysUserRecently
{
    /** 用户ID */
    private Long userId;

    /** 选择ID */
    private Long selectId;

    /** 选择类型 */
    private Long type;

    /** 操作时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date time;

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setSelectId(Long selectId) 
    {
        this.selectId = selectId;
    }

    public Long getSelectId() 
    {
        return selectId;
    }

    public void setType(Long type) 
    {
        this.type = type;
    }

    public Long getType() 
    {
        return type;
    }

    public void setTime(Date time) 
    {
        this.time = time;
    }

    public Date getTime() 
    {
        return time;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("userId", getUserId())
            .append("selectId", getSelectId())
            .append("type", getType())
            .append("time", getTime())
            .toString();
    }
}
