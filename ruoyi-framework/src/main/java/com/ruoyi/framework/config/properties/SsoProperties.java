package com.ruoyi.framework.config.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * SSO 单点登录配置
 *
 * @author ruoyi
 */
@Configuration
@ConfigurationProperties(prefix = "sso")
public class SsoProperties
{
    /** OA 校验 token 接口 */
    private String oaUrl;

    /** OA 要求的 User-Agent */
    private String oaUserAgent;

    /** 连接超时时间（毫秒） */
    private int connectTimeout = 5000;

    /** 读取超时时间（毫秒） */
    private int readTimeout = 10000;

    public String getOaUrl()
    {
        return oaUrl;
    }

    public void setOaUrl(String oaUrl)
    {
        this.oaUrl = oaUrl;
    }

    public String getOaUserAgent()
    {
        return oaUserAgent;
    }

    public void setOaUserAgent(String oaUserAgent)
    {
        this.oaUserAgent = oaUserAgent;
    }

    public int getConnectTimeout()
    {
        return connectTimeout;
    }

    public void setConnectTimeout(int connectTimeout)
    {
        this.connectTimeout = connectTimeout;
    }

    public int getReadTimeout()
    {
        return readTimeout;
    }

    public void setReadTimeout(int readTimeout)
    {
        this.readTimeout = readTimeout;
    }
}
