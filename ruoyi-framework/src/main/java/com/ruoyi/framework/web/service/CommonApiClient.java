package com.ruoyi.framework.web.service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.ServletUtils;
import com.ruoyi.system.domain.SysCommonApi;
import com.ruoyi.system.service.ISysCommonApiService;
import com.ruoyi.common.utils.MessageUtils;

/**
 * 通用接口调用客户端
 *
 * 根据接口关键字(apiKey)从 sys_common_api 表查询配置的 base URL，
 * 支持 GET 与 POST JSON Body 两种方式调用第三方接口，并携带配置的 Cookie 或透传浏览器 Cookie。
 */
@Component
public class CommonApiClient {
    private static final Logger log = LoggerFactory.getLogger(CommonApiClient.class);
    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    @Autowired
    private ISysCommonApiService commonApiService;

    /**
     * 根据关键字查询接口配置
     */
    public SysCommonApi getConfig(String apiKey) {
        return commonApiService.selectCommonApiByKey(apiKey);
    }

    /**
     * 通用 POST JSON 调用（与参考项目 EctsUtil.toDataPage / HttpUtil.getHtmlPost 模式一致）
     *
     * @param apiKey       接口关键字，对应 sys_common_api.api_key
     * @param params       所有请求参数（包含 method, fdKeyword, pageno, rowsize 等）
     * @param extraPath    base URL 后追加的路径片段（可为空，如 "/replalist"）
     * @return 原始HTTP响应字符串
     */
    public String callPost(String apiKey, Map<String, Object> params, String extraPath) {
        SysCommonApi cfg = requireConfig(apiKey);
        String url = cfg.getApiUrl();
        if (extraPath != null && !extraPath.isEmpty()) {
            url += extraPath;
        }
        JSONObject body = new JSONObject();
        if (params != null) {
            body.putAll(params);
        }
        String json = JSON.toJSONString(body);
        log.debug("[CommonApi] POST {} url={} body={}", apiKey, url, truncate(json));
        HttpRequest.Builder builder = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(30))
                .header("Content-Type", "application/json;charset=UTF-8");
        String cookie = resolveCookie(cfg);
        if (!cookie.isEmpty()) {
            builder.header("Cookie", cookie);
        }
        HttpRequest req = builder
                .POST(HttpRequest.BodyPublishers.ofString(json, StandardCharsets.UTF_8))
                .build();
        return send(req, apiKey, url);
    }

    /**
     * 通用 POST JSON 调用（不追加额外路径）
     */
    public String callPost(String apiKey, Map<String, Object> params) {
        return callPost(apiKey, params, null);
    }

    /**
     * 通用 GET 调用
     */
    public String callGet(String apiKey, Map<String, Object> queryParams) {
        SysCommonApi cfg = requireConfig(apiKey);
        String url = buildUrl(cfg.getApiUrl(), queryParams);
        log.info("[CommonApi] GET {} url={}", apiKey, url);
        HttpRequest.Builder builder = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .timeout(Duration.ofSeconds(30));
        String cookie = resolveCookie(cfg);
        if (!cookie.isEmpty()) {
            builder.header("Cookie", cookie);
        }
        HttpRequest req = builder.GET().build();
        String body = send(req, apiKey, url);
        log.info("[CommonApi] GET {} responseLen={}, first300={}", apiKey,
                body == null ? 0 : body.length(), truncate(body));
        return body;
    }

    /**
     * GET 调用并返回 JSONObject
     */
    public JSONObject callGetJson(String apiKey, Map<String, Object> queryParams) {
        String raw = callGet(apiKey, queryParams);
        try {
            return JSON.parseObject(raw);
        } catch (Exception e) {
            log.warn("[CommonApi] 接口[{}]返回非JSON, 原始响应前300字符: {}", apiKey, truncate(raw));
            throw new ServiceException(MessageUtils.message("commonApi.invalid.json", apiKey, truncate(raw)));
        }
    }

    /**
     * GET 调用并按参考项目格式解析 data.list 结构
     */
    public List<JSONObject> callGetList(String apiKey, Map<String, Object> queryParams) {
        return parseList(callGetJson(apiKey, queryParams));
    }

    /**
     * GET 调用并返回分页结构 { rows: [...], total: count }
     *
     * 兼容 LayUI 格式: { code: 0, msg, count, data: [...] }
     */
    public Map<String, Object> callGetPage(String apiKey, Map<String, Object> queryParams) {
        JSONObject json = callGetJson(apiKey, queryParams);
        Map<String, Object> page = new HashMap<>();
        page.put("rows", parseList(json));
        page.put("total", json.getLongValue("count"));
        return page;
    }

    /**
     * POST 调用并返回 JSONObject
     */
    public JSONObject callPostJson(String apiKey, Map<String, Object> params) {
        return callPostJson(apiKey, params, null);
    }

    /**
     * POST 调用并返回 JSONObject
     */
    public JSONObject callPostJson(String apiKey, Map<String, Object> params, String extraPath) {
        String raw = callPost(apiKey, params, extraPath);
        try {
            return JSON.parseObject(raw);
        } catch (Exception e) {
            throw new ServiceException(MessageUtils.message("commonApi.invalid.json", apiKey, truncate(raw)));
        }
    }

    /**
     * POST 调用并按参考项目格式解析 data.list 结构
     *
     * 参考 EctsUtil.toDataPage 返回格式: { data: { list: [...], total: ..., p: ..., psize: ... } }
     * 兼容 LayUI 格式: { code: 0, data: [...] }
     *
     * @param apiKey    接口关键字
     * @param params    请求参数（包含 method, fdKeyword 等）
     * @param extraPath 追加路径（可为空）
     * @return List<JSONObject> 列表数据
     */
    public List<JSONObject> callPostList(String apiKey, Map<String, Object> params, String extraPath) {
        return parseList(callPostJson(apiKey, params, extraPath));
    }

    /**
     * POST 调用并按参考项目格式解析列表（不追加额外路径）
     */
    public List<JSONObject> callPostList(String apiKey, Map<String, Object> params) {
        return callPostList(apiKey, params, null);
    }

    // ===== internal =====

    private List<JSONObject> parseList(JSONObject json) {
        List<JSONObject> list = new ArrayList<>();

        // 兼容 LayUI 格式: { code: 0, data: [...] }
        if (json.containsKey("code") && json.getInteger("code") == 0) {
            JSONArray arr = json.getJSONArray("data");
            if (arr != null) {
                for (int i = 0; i < arr.size(); i++) {
                    JSONObject o = arr.getJSONObject(i);
                    if (o != null) list.add(o);
                }
            }
            return list;
        }

        // 兼容参考项目格式: { data: { list: [...] } }
        Object dataObj = json.get("data");
        if (dataObj instanceof JSONObject) {
            JSONObject data = (JSONObject) dataObj;
            JSONArray arr = data.getJSONArray("list");
            if (arr != null) {
                for (int i = 0; i < arr.size(); i++) {
                    JSONObject o = arr.getJSONObject(i);
                    if (o != null) list.add(o);
                }
            }
        } else if (dataObj instanceof JSONArray) {
            JSONArray arr = (JSONArray) dataObj;
            for (int i = 0; i < arr.size(); i++) {
                JSONObject o = arr.getJSONObject(i);
                if (o != null) list.add(o);
            }
        } else if (json.containsKey("list")) {
            JSONArray arr = json.getJSONArray("list");
            if (arr != null) {
                for (int i = 0; i < arr.size(); i++) {
                    JSONObject o = arr.getJSONObject(i);
                    if (o != null) list.add(o);
                }
            }
        }

        return list;
    }

    private SysCommonApi requireConfig(String apiKey) {
        SysCommonApi cfg = commonApiService.selectCommonApiByKey(apiKey);
        if (cfg == null) {
            throw new ServiceException(MessageUtils.message("commonApi.not.configured", apiKey));
        }
        if (cfg.getApiUrl() == null || cfg.getApiUrl().isEmpty()) {
            throw new ServiceException(MessageUtils.message("commonApi.url.not.configured", apiKey));
        }
        return cfg;
    }

    private String resolveCookie(SysCommonApi cfg) {
        // 优先使用配置的 Cookie（临时方案），否则透传浏览器请求的 Cookie
        if (cfg.getCookie() != null && !cfg.getCookie().isEmpty()) {
            log.info("[CommonApi] 使用配置的 Cookie: {}", cookieNames(cfg.getCookie()));
            return cfg.getCookie();
        }
        return browserCookie();
    }

    private String browserCookie() {
        try {
            HttpServletRequest request = ServletUtils.getRequest();
            if (request != null) {
                String cookie = request.getHeader("Cookie");
                String result = cookie == null ? "" : cookie;
                log.info("[CommonApi] 透传浏览器 Cookie: {} {}", result.isEmpty() ? "无" : "有(" + result.length() + "字符)", cookieNames(result));
                return result;
            }
        } catch (Exception ignored) {
        }
        log.info("[CommonApi] 透传浏览器 Cookie: 无(无Request上下文)");
        return "";
    }

    private String cookieNames(String cookie) {
        if (cookie == null || cookie.isEmpty()) return "";
        StringBuilder names = new StringBuilder();
        for (String part : cookie.split(";")) {
            String trimmed = part.trim();
            if (trimmed.isEmpty()) continue;
            String name = trimmed.split("=", 2)[0].trim();
            if (names.length() > 0) names.append(", ");
            names.append(name);
        }
        return "[" + names + "]";
    }

    private String send(HttpRequest req, String apiKey, String url) {
        try {
            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            if (resp.statusCode() != 200) {
                log.error("[CommonApi] 接口[{}] HTTP {} url={} body={}", apiKey, resp.statusCode(), url,
                        resp.body() == null ? "" : resp.body().length() > 500 ? resp.body().substring(0, 500) : resp.body());
                throw new ServiceException(MessageUtils.message("commonApi.call.failed", apiKey, resp.statusCode()));
            }
            return resp.body() == null ? "" : resp.body();
        } catch (ServiceException se) {
            throw se;
        } catch (Exception e) {
            log.error("[CommonApi] 接口[{}]调用异常 url={} err={}", apiKey, url, e.getMessage(), e);
            throw new ServiceException(MessageUtils.message("commonApi.call.exception", apiKey, e.getMessage()));
        }
    }

    private String buildUrl(String baseUrl, Map<String, Object> params) {
        // 先清除 baseUrl 中已经存在的、会被 params 覆盖的参数（如 pageno/rowsize）
        // 避免重复参数导致服务器取第一个值而忽略分页
        String cleanUrl = stripOverlapParams(baseUrl, params);
        if (params == null || params.isEmpty()) return cleanUrl;
        String sep = cleanUrl.contains("?") ? "&" : "?";
        return cleanUrl + sep + encodeParams(params);
    }

    /**
     * 从 baseUrl 中移除与 params 中 key 重复的查询参数，避免产生重复参数
     */
    private String stripOverlapParams(String url, Map<String, Object> params) {
        if (params == null || params.isEmpty() || !url.contains("?")) return url;
        int qIdx = url.indexOf('?');
        String pathPart = url.substring(0, qIdx);
        String queryPart = url.substring(qIdx + 1);
        Set<String> paramKeys = params.keySet();
        StringBuilder filtered = new StringBuilder();
        for (String pair : queryPart.split("&")) {
            if (pair.isEmpty()) continue;
            String key = pair.split("=", 2)[0];
            if (!paramKeys.contains(key)) {
                if (filtered.length() > 0) filtered.append("&");
                filtered.append(pair);
            }
        }
        return filtered.length() > 0 ? pathPart + "?" + filtered : pathPart;
    }

    private String encodeParams(Map<String, Object> params) {
        if (params == null || params.isEmpty()) return "";
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : params.entrySet()) {
            Object v = entry.getValue();
            if (v == null) continue;
            if (sb.length() > 0) sb.append("&");
            // 参数名不编码（保留点号、下划线等，如 q._keyword）
            sb.append(entry.getKey()).append("=").append(urlEncode(String.valueOf(v)));
        }
        return sb.toString();
    }

    private static String urlEncode(String s) {
        try { return URLEncoder.encode(s, StandardCharsets.UTF_8); }
        catch (Exception e) { return s; }
    }

    private static String truncate(String s) {
        if (s == null) return "";
        return s.length() > 200 ? s.substring(0, 200) + "..." : s;
    }
}
