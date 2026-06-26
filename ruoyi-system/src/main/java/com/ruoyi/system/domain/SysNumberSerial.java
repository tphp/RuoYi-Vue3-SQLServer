/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 流水号记录对象 sys_number_serial
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public class SysNumberSerial
{
    private static final long serialVersionUID = 1L;

    /** 流水号ID */
    private Long serialId;

    /** 规则ID */
    private Long ruleId;

    /** 周期键 */
    private String cycleKey;

    /** 当前流水号值 */
    private Long currentValue;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    /** 更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date updateTime;

    public Long getSerialId()
    {
        return serialId;
    }

    public void setSerialId(Long serialId)
    {
        this.serialId = serialId;
    }

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public String getCycleKey()
    {
        return cycleKey;
    }

    public void setCycleKey(String cycleKey)
    {
        this.cycleKey = cycleKey;
    }

    public Long getCurrentValue()
    {
        return currentValue;
    }

    public void setCurrentValue(Long currentValue)
    {
        this.currentValue = currentValue;
    }

    public Date getCreateTime()
    {
        return createTime;
    }

    public void setCreateTime(Date createTime)
    {
        this.createTime = createTime;
    }

    public Date getUpdateTime()
    {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime)
    {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("serialId", getSerialId())
            .append("ruleId", getRuleId())
            .append("cycleKey", getCycleKey())
            .append("currentValue", getCurrentValue())
            .append("createTime", getCreateTime())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
