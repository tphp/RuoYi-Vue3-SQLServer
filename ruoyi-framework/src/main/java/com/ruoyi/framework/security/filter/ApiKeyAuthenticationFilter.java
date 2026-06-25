package com.ruoyi.framework.security.filter;

import java.io.IOException;
import java.util.Date;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import com.alibaba.fastjson2.JSON;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.system.domain.SysApiKey;
import com.ruoyi.system.service.ISysApiKeyService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
@Component
public class ApiKeyAuthenticationFilter extends OncePerRequestFilter
{
    @Autowired
    private ISysApiKeyService apiKeyService;
    
    @Value("${token.secret}")
    private String secret;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException
    {
        // 只处理 /api/ 开头的请求（排除认证接口）
        String requestUri = request.getRequestURI();
        if (!requestUri.startsWith("/api/") || requestUri.startsWith("/api/auth/"))
        {
            chain.doFilter(request, response);
            return;
        }
        
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer "))
        {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(JSON.toJSONString(AjaxResult.error("缺少有效的认证令牌")));
            return;
        }
        
        String token = authHeader.substring(7);
        
        try
        {
            // 自己解析 JWT Token
            Claims claims = Jwts.parser()
                    .setSigningKey(secret)
                    .parseClaimsJws(token)
                    .getBody();
            
            String apiKey = claims.getSubject();
            if (apiKey == null)
            {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(JSON.toJSONString(AjaxResult.error("令牌中缺少API Key信息")));
                return;
            }
            
            // 验证 API Key 是否仍然有效
            SysApiKey sysApiKey = apiKeyService.selectApiKeyByKey(apiKey);
            if (sysApiKey == null)
            {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(JSON.toJSONString(AjaxResult.error("API Key不存在")));
                return;
            }
            
            if ("1".equals(sysApiKey.getStatus()))
            {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(JSON.toJSONString(AjaxResult.error("API Key已被停用")));
                return;
            }
            
            if (sysApiKey.getExpireTime() != null && sysApiKey.getExpireTime().before(new Date()))
            {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write(JSON.toJSONString(AjaxResult.error("API Key已过期")));
                return;
            }
            
            // 验证通过，将 API Key 信息放入请求属性，供后续使用
            request.setAttribute("apiKey", sysApiKey.getApiKey());
            request.setAttribute("appName", sysApiKey.getAppName());
            
            chain.doFilter(request, response);
        }
        catch (Exception e)
        {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(JSON.toJSONString(AjaxResult.error("令牌解析失败")));
        }
    }
}
