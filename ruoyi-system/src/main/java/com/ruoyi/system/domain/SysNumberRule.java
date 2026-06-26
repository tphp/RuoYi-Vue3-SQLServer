/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.domain;

import java.util.List;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 编号规则对象 sys_number_rule
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public class SysNumberRule extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 规则ID */
    private Long ruleId;

    /** 规则名称 */
    @Excel(name = "规则名称")
    private String ruleName;

    /** 规则编码 */
    @Excel(name = "规则编码")
    private String ruleCode;

    /** 规则描述 */
    @Excel(name = "规则描述")
    private String description;

    /** 状态（0停用 1启用） */
    @Excel(name = "状态", readConverterExp = "0=停用,1=启用")
    private String status;

    /** 规则元素列表 */
    private List<SysNumberRuleItem> items;

    public Long getRuleId()
    {
        return ruleId;
    }

    public void setRuleId(Long ruleId)
    {
        this.ruleId = ruleId;
    }

    public String getRuleName()
    {
        return ruleName;
    }

    public void setRuleName(String ruleName)
    {
        this.ruleName = ruleName;
    }

    public String getRuleCode()
    {
        return ruleCode;
    }

    public void setRuleCode(String ruleCode)
    {
        this.ruleCode = ruleCode;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public List<SysNumberRuleItem> getItems()
    {
        return items;
    }

    public void setItems(List<SysNumberRuleItem> items)
    {
        this.items = items;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("ruleId", getRuleId())
            .append("ruleName", getRuleName())
            .append("ruleCode", getRuleCode())
            .append("description", getDescription())
            .append("status", getStatus())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
