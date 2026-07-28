package com.ruoyi.framework.web.service;

import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.framework.config.properties.SsoProperties;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;

import java.io.IOException;
import java.net.ConnectException;
import java.net.URI;
import java.net.UnknownHostException;
import java.net.http.HttpClient;
import java.net.http.HttpConnectTimeoutException;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpTimeoutException;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * OA 单点登录客户端
 *
 * <p>封装与 OA 系统的 HTTP 通讯：把前端拿到的 token 透传给 OA，
 * 解析 OA 返回的 loginName / errorMsg。</p>
 *
 * @author ruoyi
 */
@Component
public class OaSsoClient
{
    private static final Logger log = LoggerFactory.getLogger(OaSsoClient.class);

    @Autowired
    private SsoProperties ssoProperties;

    private volatile HttpClient httpClient;

    private HttpClient httpClient()
    {
        HttpClient client = httpClient;
        if (client == null)
        {
            synchronized (this)
            {
                client = httpClient;
                if (client == null)
                {
                    int connectTimeoutMs = Math.max(ssoProperties.getConnectTimeout(), 1000);
                    client = HttpClient.newBuilder()
                            .connectTimeout(Duration.ofMillis(connectTimeoutMs))
                            .followRedirects(HttpClient.Redirect.NORMAL)
                            .build();
                    httpClient = client;
                }
            }
        }
        return client;
    }

    /**
     * 调用 OA 接口，根据 token 解析出登录名
     *
     * @param token 前端从 URL 拿到的 token
     * @return loginName 登录成功返回用户名
     * @throws ServiceException 当 OA 返回错误或网络异常时抛出
     */
    public String resolveLoginName(String token)
    {
        if (token == null || token.isEmpty())
        {
            throw new ServiceException("SSO 登录凭证不能为空");
        }
        if (ssoProperties.getOaUrl() == null || ssoProperties.getOaUrl().isEmpty())
        {
            throw new ServiceException("未配置 SSO OA 接口地址 (sso.oa-url)");
        }

        String body = "token=" + urlEncode(token);
        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(ssoProperties.getOaUrl()))
                .timeout(Duration.ofMillis(Math.max(ssoProperties.getReadTimeout(), 1000)))
                .header("Content-Type", "application/x-www-form-urlencoded;charset=UTF-8")
                .POST(HttpRequest.BodyPublishers.ofString(body, StandardCharsets.UTF_8))
                .build();

        log.info("[SSO] 准备调用 OA url={}", ssoProperties.getOaUrl());

        HttpResponse<String> response;
        try
        {
            response = httpClient().send(request, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
        }
        catch (HttpConnectTimeoutException e)
        {
            log.error("[SSO] 连接 OA 超时 url={}, timeoutMs={}", ssoProperties.getOaUrl(), ssoProperties.getConnectTimeout(), e);
            throw new ServiceException("连接 OA 服务器超时（" + ssoProperties.getConnectTimeout()
                    + "ms），请检查网络或调大 sso.connect-timeout / sso.read-timeout");
        }
        catch (HttpTimeoutException e)
        {
            log.error("[SSO] 调用 OA 读取超时 url={}, readTimeoutMs={}", ssoProperties.getOaUrl(), ssoProperties.getReadTimeout(), e);
            throw new ServiceException("读取 OA 响应超时（" + ssoProperties.getReadTimeout()
                    + "ms），请检查网络或调大 sso.read-timeout");
        }
        catch (UnknownHostException e)
        {
            log.error("[SSO] 未知主机 url={}", ssoProperties.getOaUrl(), e);
            throw new ServiceException("无法解析 OA 主机地址：" + e.getMessage() + "，请检查 sso.oa-url");
        }
        catch (ConnectException e)
        {
            log.error("[SSO] 连接被拒绝 url={}", ssoProperties.getOaUrl(), e);
            throw new ServiceException("连接 OA 被拒绝（" + e.getMessage() + "），请确认 OA 服务已启动且端口可达");
        }
        catch (IOException e)
        {
            log.error("[SSO] 调用 OA I/O 异常 url={}", ssoProperties.getOaUrl(), e);
            throw new ServiceException("调用 OA 验证接口 I/O 异常 [" + e.getClass().getSimpleName()
                    + "]：" + safeMsg(e.getMessage()));
        }
        catch (InterruptedException e)
        {
            Thread.currentThread().interrupt();
            log.error("[SSO] 调用 OA 被中断", e);
            throw new ServiceException("调用 OA 验证接口被中断");
        }
        catch (Exception e)
        {
            log.error("[SSO] 调用 OA 未知异常 url={}", ssoProperties.getOaUrl(), e);
            throw new ServiceException("调用 OA 验证接口失败 [" + e.getClass().getSimpleName()
                    + "]：" + safeMsg(e.getMessage()));
        }

        int status = response.statusCode();
        String respBody = response.body() == null ? "" : response.body();
        log.debug("[SSO] OA 响应 status={}, body={}", status, respBody);
        if (status < 200 || status >= 300)
        {
            throw new ServiceException("OA 返回异常状态码：" + status);
        }

        JSONObject json;
        try
        {
            json = JSON.parseObject(respBody);
        }
        catch (Exception e)
        {
            // OA 可能返回纯文本错误，尝试从中提取
            log.warn("[SSO] OA 响应非 JSON 格式: {}", respBody);
            throw new ServiceException("OA 响应格式错误：" + truncate(respBody, 200));
        }
        if (json == null)
        {
            throw new ServiceException("OA 响应为空");
        }

        // 优先取 errorMsg
        String errorMsg = json.getString("errorMsg");
        if (errorMsg != null && !errorMsg.isEmpty() && !"null".equalsIgnoreCase(errorMsg))
        {
            throw new ServiceException(errorMsg);
        }

        String loginName = json.getString("loginName");
        if (loginName == null || loginName.isEmpty() || "null".equalsIgnoreCase(loginName))
        {
            throw new ServiceException("OA 未返回有效的 loginName");
        }
        return loginName.trim();
    }

    private static String urlEncode(String value)
    {
        return java.net.URLEncoder.encode(value, StandardCharsets.UTF_8);
    }

    private static String truncate(String s, int max)
    {
        if (s == null)
        {
            return "";
        }
        return s.length() > max ? s.substring(0, max) + "..." : s;
    }

    private static String safeMsg(String s)
    {
        return (s == null || s.isEmpty()) ? "(无详细描述)" : s;
    }
}
