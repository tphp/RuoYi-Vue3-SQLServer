/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.utils;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.Date;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.apilog.domain.SysOutboundLog;
import com.ruoyi.apilog.service.ISysOutboundLogService;
import com.ruoyi.common.exception.ServiceException;

/**
 * 外部接口调用工具类（带出站日志）
 *
 * 系统内所有对外部接口的调用统一通过本类发起，调用完成后自动记录：
 * 接口名称、接口地址、请求时间、请求参数、请求状态、响应内容、响应耗时（毫秒）、
 * HTTP状态码与错误堆栈，日志通过 Service 异步写入 sys_outbound_log。
 *
 * 使用示例：
 * String body = externalApiClient.postJson("用户中心-查询用户", url, headers, params);
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@Component
public class ExternalApiClient
{
    private static final Logger log = LoggerFactory.getLogger(ExternalApiClient.class);

    /** 连接超时时间 */
    private static final Duration CONNECT_TIMEOUT = Duration.ofSeconds(10);

    /** 请求超时时间 */
    private static final Duration REQUEST_TIMEOUT = Duration.ofSeconds(30);

    /** 默认JSON请求头 */
    private static final String JSON_CONTENT_TYPE = "application/json;charset=UTF-8";

    /** 默认表单请求头 */
    private static final String FORM_CONTENT_TYPE = "application/x-www-form-urlencoded;charset=UTF-8";

    /** 单字段最大保存长度 */
    @Value("${api-log.outbound.max-content-length:8000}")
    private int maxContentLength;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(CONNECT_TIMEOUT)
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    @Autowired
    private ISysOutboundLogService outboundLogService;

    /**
     * GET 调用
     *
     * @param interfaceName 接口名称
     * @param url           接口地址
     * @param headers       请求头（可为空）
     * @param queryParams   查询参数（可为空）
     * @return 响应报文
     */
    public String get(String interfaceName, String url, Map<String, String> headers, Map<String, Object> queryParams)
    {
        return execute(interfaceName, "GET", buildUrl(url, queryParams), headers, null,
                queryParams == null || queryParams.isEmpty() ? null : new JSONObject(queryParams));
    }

    /**
     * GET 调用（无请求头与查询参数）
     *
     * @param interfaceName 接口名称
     * @param url           接口地址
     * @return 响应报文
     */
    public String get(String interfaceName, String url)
    {
        return get(interfaceName, url, null, null);
    }

    /**
     * POST JSON 调用
     *
     * @param interfaceName 接口名称
     * @param url           接口地址
     * @param headers       请求头（可为空）
     * @param body          请求体对象，序列化为 JSON
     * @return 响应报文
     */
    public String postJson(String interfaceName, String url, Map<String, String> headers, Object body)
    {
        String json = body == null ? "{}" : JSON.toJSONString(body);
        return execute(interfaceName, "POST", url, headers, json, body);
    }

    /**
     * POST JSON 调用（无请求头）
     *
     * @param interfaceName 接口名称
     * @param url           接口地址
     * @param body          请求体对象
     * @return 响应报文
     */
    public String postJson(String interfaceName, String url, Object body)
    {
        return postJson(interfaceName, url, null, body);
    }

    /**
     * POST 表单调用
     *
     * @param interfaceName 接口名称
     * @param url           接口地址
     * @param headers       请求头（可为空）
     * @param formParams    表单参数
     * @return 响应报文
     */
    public String postForm(String interfaceName, String url, Map<String, String> headers, Map<String, Object> formParams)
    {
        String formBody = encodeParams(formParams);
        return execute(interfaceName, "FORM", url, headers, formBody, formParams);
    }

    /**
     * 执行 HTTP 调用并记录出站日志
     *
     * @param interfaceName 接口名称
     * @param method        请求方式（GET/POST/FORM）
     * @param url           接口地址
     * @param headers       请求头
     * @param body          请求体字符串
     * @param bodyForLog    用于日志记录的请求体对象
     * @return 响应报文
     */
    private String execute(String interfaceName, String method, String url, Map<String, String> headers,
            String body, Object bodyForLog)
    {
        long startTime = System.currentTimeMillis();
        SysOutboundLog outboundLog = new SysOutboundLog();
        outboundLog.setInterfaceName(interfaceName);
        outboundLog.setInterfaceUrl(ApiLogUtils.truncate(url, 1000));
        outboundLog.setRequestTime(new Date(startTime));
        outboundLog.setRequestParameter(buildRequestParameter(method, headers, bodyForLog));

        try
        {
            HttpRequest.Builder builder = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(REQUEST_TIMEOUT);
            String contentType = applyHeaders(builder, headers);
            if ("GET".equals(method))
            {
                builder.GET();
            }
            else
            {
                String finalContentType = contentType != null ? contentType
                        : ("FORM".equals(method) ? FORM_CONTENT_TYPE : JSON_CONTENT_TYPE);
                builder.header("Content-Type", finalContentType);
                builder.POST(HttpRequest.BodyPublishers.ofString(body == null ? "" : body, StandardCharsets.UTF_8));
            }
            HttpResponse<String> response = httpClient.send(builder.build(),
                    HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            int statusCode = response.statusCode();
            String responseBody = response.body() == null ? "" : response.body();
            outboundLog.setResponseCode(String.valueOf(statusCode));
            outboundLog.setResponseContent(ApiLogUtils.maskSensitive(
                    ApiLogUtils.truncate(responseBody, maxContentLength)));
            boolean success = statusCode >= 200 && statusCode < 300;
            outboundLog.setRequestStatus(success ? "SUCCESS" : "FAIL");
            if (!success)
            {
                throw new ServiceException("调用接口[" + interfaceName + "]失败：HTTP " + statusCode);
            }
            return responseBody;
        }
        catch (ServiceException serviceException)
        {
            throw serviceException;
        }
        catch (Exception e)
        {
            outboundLog.setRequestStatus("FAIL");
            outboundLog.setStacktrace(ApiLogUtils.stackTrace(e, maxContentLength));
            log.warn("[ExternalApi] 接口[{}]调用异常 url={} err={}", interfaceName, url, e.getMessage());
            throw new ServiceException("调用接口[" + interfaceName + "]异常：" + e.getMessage());
        }
        finally
        {
            outboundLog.setResponseTime(System.currentTimeMillis() - startTime);
            outboundLogService.record(outboundLog);
        }
    }

    /**
     * 应用请求头，返回显式指定的 Content-Type
     *
     * @param builder 请求构造器
     * @param headers 请求头
     * @return 请求头中的 Content-Type，未指定时返回 null
     */
    private String applyHeaders(HttpRequest.Builder builder, Map<String, String> headers)
    {
        if (headers == null || headers.isEmpty())
        {
            return null;
        }
        String contentType = null;
        for (Map.Entry<String, String> entry : headers.entrySet())
        {
            if (entry.getKey() == null || entry.getValue() == null)
            {
                continue;
            }
            if ("Content-Type".equalsIgnoreCase(entry.getKey()))
            {
                contentType = entry.getValue();
                continue;
            }
            builder.header(entry.getKey(), entry.getValue());
        }
        return contentType;
    }

    /**
     * 组装日志中的请求参数
     *
     * @param method     请求方式
     * @param headers    请求头
     * @param bodyForLog 请求体对象
     * @return 脱敏后的请求参数 JSON
     */
    private String buildRequestParameter(String method, Map<String, String> headers, Object bodyForLog)
    {
        JSONObject parameter = new JSONObject();
        parameter.put("method", method);
        if (headers != null && !headers.isEmpty())
        {
            parameter.put("headers", headers);
        }
        if (bodyForLog != null)
        {
            parameter.put("body", bodyForLog);
        }
        return ApiLogUtils.maskSensitive(ApiLogUtils.truncate(parameter.toJSONString(), maxContentLength));
    }

    /**
     * 拼接查询参数
     *
     * @param url    原始地址
     * @param params 查询参数
     * @return 完整地址
     */
    private String buildUrl(String url, Map<String, Object> params)
    {
        if (params == null || params.isEmpty())
        {
            return url;
        }
        String separator = url.contains("?") ? "&" : "?";
        return url + separator + encodeParams(params);
    }

    /**
     * 参数编码
     *
     * @param params 参数集合
     * @return 编码后的参数字符串
     */
    private String encodeParams(Map<String, Object> params)
    {
        if (params == null || params.isEmpty())
        {
            return "";
        }
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<String, Object> entry : params.entrySet())
        {
            if (entry.getValue() == null)
            {
                continue;
            }
            if (builder.length() > 0)
            {
                builder.append("&");
            }
            builder.append(entry.getKey()).append("=").append(urlEncode(String.valueOf(entry.getValue())));
        }
        return builder.toString();
    }

    /**
     * URL编码
     *
     * @param value 原始值
     * @return 编码后的值
     */
    private String urlEncode(String value)
    {
        try
        {
            return URLEncoder.encode(value, StandardCharsets.UTF_8);
        }
        catch (Exception e)
        {
            return value;
        }
    }
}
