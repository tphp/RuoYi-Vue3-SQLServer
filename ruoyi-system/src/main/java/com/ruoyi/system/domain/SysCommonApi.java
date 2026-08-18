package com.ruoyi.system.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 通用接口配置对象 sys_common_api
 * @author system
 */
public class SysCommonApi extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 主键ID */
    private Long id;

    /** 接口名称 */
    @Excel(name = "接口名称")
    private String apiName;

    /** 接口关键字 */
    @Excel(name = "接口关键字")
    private String apiKey;

    /** 接口地址 */
    @Excel(name = "接口地址")
    private String apiUrl;

    /** 请求Cookie（临时配置，SSO完成后移除） */
    private String cookie;

    /** 描述 */
    @Excel(name = "描述")
    private String description;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getApiName() { return apiName; }
    public void setApiName(String apiName) { this.apiName = apiName; }
    public String getApiKey() { return apiKey; }
    public void setApiKey(String apiKey) { this.apiKey = apiKey; }
    public String getApiUrl() { return apiUrl; }
    public void setApiUrl(String apiUrl) { this.apiUrl = apiUrl; }
    public String getCookie() { return cookie; }
    public void setCookie(String cookie) { this.cookie = cookie; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("apiName", getApiName())
            .append("apiKey", getApiKey())
            .append("apiUrl", getApiUrl())
            .append("cookie", getCookie())
            .append("description", getDescription())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
