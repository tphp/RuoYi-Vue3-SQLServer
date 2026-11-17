package com.ruoyi.web.controller.system.api;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.framework.web.service.TokenService;
import com.ruoyi.system.domain.SysApiKey;
import com.ruoyi.system.service.ISysApiKeyService;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
@RestController
@RequestMapping("/api/auth")
public class ApiAuthController extends BaseController
{
    @Autowired
    private ISysApiKeyService apiKeyService;

    @Autowired
    private TokenService tokenService;
    
    /**
     * 获取访问令牌
     * 
     * @param params 包含 apiKey 和 apiSecret
     * @return 令牌信息
     */
    @PostMapping("/token")
    public AjaxResult getToken(@RequestBody Map<String, String> params)
    {
        String apiKey = params.get("apiKey");
        String apiSecret = params.get("apiSecret");
        
        if (apiKey == null || apiSecret == null)
        {
            return error("缺少API Key或Secret");
        }
        
        SysApiKey sysApiKey = apiKeyService.validateApiKey(apiKey, apiSecret);
        if (sysApiKey == null)
        {
            return error("API Key 或 Secret 错误");
        }
        
        // 创建 SysUser 和 LoginUser 并生成 JWT Token
        // userId 设为 1（admin），使数据权限切面跳过过滤，对外接口不受数据权限限制
        SysUser sysUser = new SysUser();
        sysUser.setUserId(1L);
        sysUser.setUserName(apiKey);
        
        LoginUser loginUser = new LoginUser(sysUser, null);
        
        String token = tokenService.createToken(loginUser);
        
        Map<String, Object> result = new HashMap<>();
        result.put("access_token", token);
        result.put("token_type", "bearer");
        result.put("expires_in", 1800);
        
        return success(result);
    }
}
