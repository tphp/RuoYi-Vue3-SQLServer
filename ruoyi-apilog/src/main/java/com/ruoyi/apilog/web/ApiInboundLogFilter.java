/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.web;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Enumeration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.util.ContentCachingRequestWrapper;
import org.springframework.web.util.ContentCachingResponseWrapper;
import com.ruoyi.apilog.domain.SysInboundLog;
import com.ruoyi.apilog.service.ISysInboundLogService;
import com.ruoyi.apilog.utils.ApiLogUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.ip.IpUtils;

/**
 * 入站接口日志过滤器
 *
 * 全局拦截本系统对外提供的接口请求，记录请求地址、请求方式、请求头、请求体、
 * 响应内容、响应耗时、调用方IP、Referer、User-Agent 及异常堆栈，异步入库。
 *
 * 可通过配置开关与报文长度控制：
 * api-log.inbound.enabled=true
 * api-log.inbound.max-content-length=8000
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@Component
@Order(Ordered.LOWEST_PRECEDENCE)
public class ApiInboundLogFilter extends OncePerRequestFilter
{
    private static final Logger log = LoggerFactory.getLogger(ApiInboundLogFilter.class);

    /** 不记录日志的路径前缀（登录、静态资源、日志自身查询接口等） */
    private static final String[] EXCLUDE_PREFIXES = {
            "/login", "/logout", "/register", "/captchaImage", "/getInfo", "/getRouters",
            "/profile/", "/common/", "/error", "/actuator", "/swagger", "/v3/api-docs",
            "/favicon.ico", "/websocket", "/druid", "/monitor/inboundLog", "/monitor/outboundLog"
    };

    /** 不记录日志的路径关键字（文件上传下载、导出导入） */
    private static final String[] EXCLUDE_KEYWORDS = { "/export", "/download", "/importTemplate" };

    /** 忽略的静态资源后缀 */
    private static final String[] EXCLUDE_SUFFIXES = {
            ".js", ".css", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg",
            ".woff", ".woff2", ".ttf", ".map", ".html"
    };

    /** 是否启用入站日志 */
    @Value("${api-log.inbound.enabled:true}")
    private boolean enabled;

    /** 单字段最大保存长度 */
    @Value("${api-log.inbound.max-content-length:8000}")
    private int maxContentLength;

    @Autowired
    private ISysInboundLogService inboundLogService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException
    {
        if (!enabled || shouldSkip(request))
        {
            filterChain.doFilter(request, response);
            return;
        }
        ContentCachingRequestWrapper requestWrapper = new ContentCachingRequestWrapper(request, maxContentLength);
        ContentCachingResponseWrapper responseWrapper = new ContentCachingResponseWrapper(response);
        long startTime = System.currentTimeMillis();
        Throwable error = null;
        try
        {
            filterChain.doFilter(requestWrapper, responseWrapper);
        }
        catch (Throwable throwable)
        {
            error = throwable;
            throw throwable;
        }
        finally
        {
            try
            {
                record(requestWrapper, responseWrapper, startTime, error);
            }
            catch (Exception e)
            {
                log.warn("[ApiLog] 入站日志记录失败: {}", e.getMessage());
            }
            try
            {
                responseWrapper.copyBodyToResponse();
            }
            catch (Exception e)
            {
                // 响应已提交（如异常重定向）时忽略
            }
        }
    }

    /**
     * 判断当前请求是否跳过日志记录
     *
     * @param request 请求
     * @return true-跳过
     */
    private boolean shouldSkip(HttpServletRequest request)
    {
        if ("OPTIONS".equalsIgnoreCase(request.getMethod()))
        {
            return true;
        }
        String uri = request.getRequestURI();
        if (uri == null)
        {
            return true;
        }
        String lowerUri = uri.toLowerCase();
        for (String prefix : EXCLUDE_PREFIXES)
        {
            if (lowerUri.startsWith(prefix))
            {
                return true;
            }
        }
        for (String keyword : EXCLUDE_KEYWORDS)
        {
            if (lowerUri.contains(keyword.toLowerCase()))
            {
                return true;
            }
        }
        for (String suffix : EXCLUDE_SUFFIXES)
        {
            if (lowerUri.endsWith(suffix))
            {
                return true;
            }
        }
        String contentType = request.getContentType();
        return contentType != null && contentType.toLowerCase().startsWith("multipart/");
    }

    /**
     * 组装并异步入库入站日志
     *
     * @param request   请求包装对象
     * @param response  响应包装对象
     * @param startTime 请求开始时间（毫秒）
     * @param error     业务异常
     */
    private void record(ContentCachingRequestWrapper request, ContentCachingResponseWrapper response,
            long startTime, Throwable error)
    {
        SysInboundLog inboundLog = new SysInboundLog();
        inboundLog.setInterfaceName(request.getRequestURI());
        inboundLog.setInterfaceUrl(buildFullUrl(request));
        inboundLog.setRequestTime(new Date(startTime));
        inboundLog.setRequestMethod(request.getMethod());
        inboundLog.setRequestHeaderParameter(ApiLogUtils.headersToJson(collectHeaders(request), 2000));
        inboundLog.setRequestBodyParameter(ApiLogUtils.maskSensitive(
                ApiLogUtils.truncate(readRequestBody(request), maxContentLength)));
        inboundLog.setResponseContent(ApiLogUtils.maskSensitive(
                ApiLogUtils.truncate(readResponseBody(response), maxContentLength)));
        inboundLog.setResponseTime(System.currentTimeMillis() - startTime);
        inboundLog.setRequestStatus(error == null && response.getStatus() < 400 ? "SUCCESS" : "FAIL");
        inboundLog.setStacktrace(ApiLogUtils.stackTrace(error, maxContentLength));
        inboundLog.setIp(IpUtils.getIpAddr(request));
        inboundLog.setReferer(ApiLogUtils.truncate(request.getHeader("Referer"), 500));
        inboundLog.setUserAgent(ApiLogUtils.truncate(request.getHeader("User-Agent"), 500));
        inboundLog.setRequestId(headerOrDefault(request, "X-Request-Id"));
        inboundLog.setProgramId(request.getHeader("X-Program-Id"));
        inboundLog.setCreatedBy(currentUsername());
        inboundLogService.record(inboundLog);
    }

    /**
     * 读取请求体（表单请求取参数拼接，其余取缓存字节）
     *
     * @param request 请求包装对象
     * @return 请求体字符串
     */
    private String readRequestBody(ContentCachingRequestWrapper request)
    {
        byte[] content = request.getContentAsByteArray();
        if (content.length > 0)
        {
            return new String(content, StandardCharsets.UTF_8);
        }
        String contentType = request.getContentType();
        if (contentType != null && contentType.toLowerCase().contains("application/x-www-form-urlencoded"))
        {
            return ApiLogUtils.toJson(request.getParameterMap(), maxContentLength);
        }
        return null;
    }

    /**
     * 读取响应体（仅文本/JSON 类型）
     *
     * @param response 响应包装对象
     * @return 响应体字符串
     */
    private String readResponseBody(ContentCachingResponseWrapper response)
    {
        byte[] content = response.getContentAsByteArray();
        if (content.length == 0)
        {
            return null;
        }
        String contentType = response.getContentType();
        if (contentType != null)
        {
            String lowerType = contentType.toLowerCase();
            if (!lowerType.contains("json") && !lowerType.startsWith("text/"))
            {
                return "[非文本响应，contentType=" + contentType + "]";
            }
        }
        return new String(content, StandardCharsets.UTF_8);
    }

    /**
     * 收集请求头
     *
     * @param request 请求
     * @return 请求头Map
     */
    private Map<String, String> collectHeaders(HttpServletRequest request)
    {
        Map<String, String> headerMap = new LinkedHashMap<>();
        Enumeration<String> names = request.getHeaderNames();
        while (names != null && names.hasMoreElements())
        {
            String name = names.nextElement();
            if ("content-length".equalsIgnoreCase(name))
            {
                continue;
            }
            headerMap.put(name, request.getHeader(name));
        }
        return headerMap;
    }

    /**
     * 拼接完整请求地址
     *
     * @param request 请求
     * @return 完整URL（含查询串）
     */
    private String buildFullUrl(HttpServletRequest request)
    {
        StringBuilder url = new StringBuilder(request.getRequestURL());
        if (request.getQueryString() != null)
        {
            url.append("?").append(request.getQueryString());
        }
        return ApiLogUtils.truncate(url.toString(), 1000);
    }

    /**
     * 取请求头，为空时生成 UUID
     *
     * @param request 请求
     * @param name    请求头名称
     * @return 请求唯一标识
     */
    private String headerOrDefault(HttpServletRequest request, String name)
    {
        String value = request.getHeader(name);
        if (ApiLogUtils.isEmpty(value))
        {
            value = UUID.randomUUID().toString().replace("-", "");
        }
        return value;
    }

    /**
     * 获取当前登录用户名
     *
     * @return 用户名
     */
    private String currentUsername()
    {
        try
        {
            String username = SecurityUtils.getUsername();
            return username == null ? "anonymous" : username;
        }
        catch (Exception e)
        {
            return "anonymous";
        }
    }
}
