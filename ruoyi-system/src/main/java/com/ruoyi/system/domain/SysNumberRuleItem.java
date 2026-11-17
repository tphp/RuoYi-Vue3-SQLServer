/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 编号规则元素对象 sys_number_rule_item
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public class SysNumberRuleItem extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 元素ID */
    private Long itemId;

    /** 规则ID */
    private Long ruleId;

    /** 元素类型（1常量 2日期 3流水号） */
    private String itemType;

    /** 常量值 */
    private String itemValue;

    /** 日期格式 */
    private String dateFormat;

    /** 累计周期（1不循环 2按日 3按月 4按年） */
    private String cycleType;

    /** 流水号长度 */
    private Integer serialLength;

    /** 是否补零（0否 1是） */
    private String isPadZero;

    /** 起始流水号 */
    private Integer startNumber;

    /** 排序号 */
    private Integer sortOrder;

    public Long getItemId()
    {
        return itemId;
    }

    public void setItemId(Long itemId)
    {
        this.itemId = itemId;
    }

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public String getItemType()
    {
        return itemType;
    }

    public void setItemType(String itemType)
    {
        this.itemType = itemType;
    }

    public String getItemValue()
    {
        return itemValue;
    }

    public void setItemValue(String itemValue)
    {
        this.itemValue = itemValue;
    }

    public String getDateFormat()
    {
        return dateFormat;
    }

    public void setDateFormat(String dateFormat)
    {
        this.dateFormat = dateFormat;
    }

    public String getCycleType()
    {
        return cycleType;
    }

    public void setCycleType(String cycleType)
    {
        this.cycleType = cycleType;
    }

    public Integer getSerialLength()
    {
        return serialLength;
    }

    public void setSerialLength(Integer serialLength)
    {
        this.serialLength = serialLength;
    }

    public String getIsPadZero()
    {
        return isPadZero;
    }

    public void setIsPadZero(String isPadZero)
    {
        this.isPadZero = isPadZero;
    }

    public Integer getStartNumber()
    {
        return startNumber;
    }

    public void setStartNumber(Integer startNumber)
    {
        this.startNumber = startNumber;
    }

    public Integer getSortOrder()
    {
        return sortOrder;
    }

    public void setSortOrder(Integer sortOrder)
    {
        this.sortOrder = sortOrder;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("itemId", getItemId())
            .append("ruleId", getRuleId())
            .append("itemType", getItemType())
            .append("itemValue", getItemValue())
            .append("dateFormat", getDateFormat())
            .append("cycleType", getCycleType())
            .append("serialLength", getSerialLength())
            .append("isPadZero", getIsPadZero())
            .append("startNumber", getStartNumber())
            .append("sortOrder", getSortOrder())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
