/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.utils;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import com.alibaba.fastjson2.JSON;

/**
 * 接口日志工具类
 *
 * 提供敏感信息脱敏、报文字符串截断、异常堆栈提取、请求头序列化等能力，
 * 供入站日志过滤器与出站调用工具类共用。
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
public class ApiLogUtils
{
    /** 默认单字段最大保存长度 */
    public static final int DEFAULT_MAX_LENGTH = 8000;

    /** 需要脱敏的请求头名称（小写） */
    private static final List<String> SENSITIVE_HEADERS = new ArrayList<>();

    /** 需要脱敏的 JSON/表单字段名 */
    private static final Pattern SENSITIVE_FIELD_PATTERN = Pattern.compile(
            "(\"(?:password|oldPassword|newPassword|pwd|token|accessToken|refreshToken|authorization|secret|appSecret|cookie)\"\\s*:\\s*)\"([^\"]*)\"",
            Pattern.CASE_INSENSITIVE);

    static
    {
        SENSITIVE_HEADERS.add("cookie");
        SENSITIVE_HEADERS.add("set-cookie");
        SENSITIVE_HEADERS.add("authorization");
        SENSITIVE_HEADERS.add("token");
        SENSITIVE_HEADERS.add("x-token");
        SENSITIVE_HEADERS.add("proxy-authorization");
    }

    private ApiLogUtils()
    {
    }

    /**
     * 判断字符串是否为空
     *
     * @param value 字符串
     * @return true-为空
     */
    public static boolean isEmpty(String value)
    {
        return value == null || value.isEmpty();
    }

    /**
     * 对报文中的敏感字段进行脱敏（如 password、token、cookie 等）
     *
     * @param content 原始报文
     * @return 脱敏后的报文
     */
    public static String maskSensitive(String content)
    {
        if (isEmpty(content))
        {
            return content;
        }
        return SENSITIVE_FIELD_PATTERN.matcher(content).replaceAll("$1\"******\"");
    }

    /**
     * 截断超长字符串
     *
     * @param content   原始内容
     * @param maxLength 最大长度，小于等于0时使用默认长度
     * @return 截断后的内容
     */
    public static String truncate(String content, int maxLength)
    {
        if (content == null)
        {
            return null;
        }
        int limit = maxLength > 0 ? maxLength : DEFAULT_MAX_LENGTH;
        if (content.length() <= limit)
        {
            return content;
        }
        return content.substring(0, limit) + "...(已截断,共" + content.length() + "字符)";
    }

    /**
     * 提取异常堆栈字符串
     *
     * @param throwable 异常对象
     * @param maxLength 最大长度
     * @return 堆栈字符串，无异常时返回 null
     */
    public static String stackTrace(Throwable throwable, int maxLength)
    {
        if (throwable == null)
        {
            return null;
        }
        try (StringWriter stringWriter = new StringWriter();
                PrintWriter printWriter = new PrintWriter(stringWriter))
        {
            throwable.printStackTrace(printWriter);
            printWriter.flush();
            return truncate(stringWriter.toString(), maxLength);
        }
        catch (Exception e)
        {
            return throwable.toString();
        }
    }

    /**
     * 序列化请求头（自动剔除 Cookie、Authorization 等敏感头）
     *
     * @param headers   请求头集合
     * @param maxLength 最大长度
     * @return JSON 字符串
     */
    public static String headersToJson(Map<String, String> headers, int maxLength)
    {
        if (headers == null || headers.isEmpty())
        {
            return null;
        }
        Map<String, String> safeHeaders = new LinkedHashMap<>();
        for (Map.Entry<String, String> entry : headers.entrySet())
        {
            String name = entry.getKey();
            boolean sensitive = name != null && SENSITIVE_HEADERS.contains(name.toLowerCase());
            safeHeaders.put(name, sensitive ? "******" : entry.getValue());
        }
        return truncate(JSON.toJSONString(safeHeaders), maxLength);
    }

    /**
     * 序列化任意对象为 JSON 字符串，失败时返回其 toString
     *
     * @param value     待序列化对象
     * @param maxLength 最大长度
     * @return JSON 字符串
     */
    public static String toJson(Object value, int maxLength)
    {
        if (value == null)
        {
            return null;
        }
        try
        {
            return truncate(JSON.toJSONString(value), maxLength);
        }
        catch (Exception e)
        {
            return truncate(String.valueOf(value), maxLength);
        }
    }
}
