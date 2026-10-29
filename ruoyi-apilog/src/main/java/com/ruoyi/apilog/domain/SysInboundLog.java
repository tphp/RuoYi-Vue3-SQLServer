/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.domain;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;

/**
 * 入站接口日志对象 sys_inbound_log
 *
 * 用于记录外部系统调用本系统接口的请求地址、请求头、请求体、请求方式、响应内容、耗时、IP、UA 与错误堆栈。
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
public class SysInboundLog
{
    /** 主键 */
    private Long inboundId;

    /** 接口名称 */
    private String interfaceName;

    /** 接口地址 */
    private String interfaceUrl;

    /** 请求时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date requestTime;

    /** 请求Header参数 */
    private String requestHeaderParameter;

    /** 请求Body参数 */
    private String requestBodyParameter;

    /** 请求方式 */
    private String requestMethod;

    /** 请求状态（SUCCESS/FAIL） */
    private String requestStatus;

    /** 响应内容 */
    private String responseContent;

    /** 响应耗时（毫秒） */
    private Long responseTime;

    /** 错误堆栈 */
    private String stacktrace;

    /** 调用方IP */
    private String ip;

    /** 来源页面 */
    private String referer;

    /** 客户端标识 */
    private String userAgent;

    /** 版本号 */
    private Long objectVersionNumber;

    /** 请求唯一标识 */
    private String requestId;

    /** 调用方程序标识 */
    private String programId;

    /** 创建人 */
    private String createdBy;

    /** 创建时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date creationDate;

    /** 最后更新人 */
    private String lastUpdatedBy;

    /** 最后更新时间 */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date lastUpdateDate;

    /** 最后更新登录ID */
    private String lastUpdateLogin;

    /** 查询条件-请求开始时间（非数据库字段） */
    private String beginTime;

    /** 查询条件-请求结束时间（非数据库字段） */
    private String endTime;

    public Long getInboundId() { return inboundId; }
    public void setInboundId(Long inboundId) { this.inboundId = inboundId; }
    public String getInterfaceName() { return interfaceName; }
    public void setInterfaceName(String interfaceName) { this.interfaceName = interfaceName; }
    public String getInterfaceUrl() { return interfaceUrl; }
    public void setInterfaceUrl(String interfaceUrl) { this.interfaceUrl = interfaceUrl; }
    public Date getRequestTime() { return requestTime; }
    public void setRequestTime(Date requestTime) { this.requestTime = requestTime; }
    public String getRequestHeaderParameter() { return requestHeaderParameter; }
    public void setRequestHeaderParameter(String requestHeaderParameter) { this.requestHeaderParameter = requestHeaderParameter; }
    public String getRequestBodyParameter() { return requestBodyParameter; }
    public void setRequestBodyParameter(String requestBodyParameter) { this.requestBodyParameter = requestBodyParameter; }
    public String getRequestMethod() { return requestMethod; }
    public void setRequestMethod(String requestMethod) { this.requestMethod = requestMethod; }
    public String getRequestStatus() { return requestStatus; }
    public void setRequestStatus(String requestStatus) { this.requestStatus = requestStatus; }
    public String getResponseContent() { return responseContent; }
    public void setResponseContent(String responseContent) { this.responseContent = responseContent; }
    public Long getResponseTime() { return responseTime; }
    public void setResponseTime(Long responseTime) { this.responseTime = responseTime; }
    public String getStacktrace() { return stacktrace; }
    public void setStacktrace(String stacktrace) { this.stacktrace = stacktrace; }
    public String getIp() { return ip; }
    public void setIp(String ip) { this.ip = ip; }
    public String getReferer() { return referer; }
    public void setReferer(String referer) { this.referer = referer; }
    public String getUserAgent() { return userAgent; }
    public void setUserAgent(String userAgent) { this.userAgent = userAgent; }
    public Long getObjectVersionNumber() { return objectVersionNumber; }
    public void setObjectVersionNumber(Long objectVersionNumber) { this.objectVersionNumber = objectVersionNumber; }
    public String getRequestId() { return requestId; }
    public void setRequestId(String requestId) { this.requestId = requestId; }
    public String getProgramId() { return programId; }
    public void setProgramId(String programId) { this.programId = programId; }
    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
    public Date getCreationDate() { return creationDate; }
    public void setCreationDate(Date creationDate) { this.creationDate = creationDate; }
    public String getLastUpdatedBy() { return lastUpdatedBy; }
    public void setLastUpdatedBy(String lastUpdatedBy) { this.lastUpdatedBy = lastUpdatedBy; }
    public Date getLastUpdateDate() { return lastUpdateDate; }
    public void setLastUpdateDate(Date lastUpdateDate) { this.lastUpdateDate = lastUpdateDate; }
    public String getLastUpdateLogin() { return lastUpdateLogin; }
    public void setLastUpdateLogin(String lastUpdateLogin) { this.lastUpdateLogin = lastUpdateLogin; }
    public String getBeginTime() { return beginTime; }
    public void setBeginTime(String beginTime) { this.beginTime = beginTime; }
    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }
}
