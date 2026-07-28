package com.ruoyi.web.controller.system.api;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.framework.web.service.SsoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * SSO 单点登录接口
 *
 * <p>对接 OA 系统，验证 token 后完成无密码登录，
 * 并返回 RuoYi 自身的 token。</p>
 *
 * @author ruoyi
 */
@Anonymous
@RestController
@RequestMapping("/sso")
public class SsoController extends BaseController
{
    @Autowired
    private SsoService ssoService;

    /**
     * SSO 登录
     *
     * @param token OA 颁发的 token，从 /sso?token=xxx 传入
     * @return AjaxResult 包含 RuoYi 自身 token
     */
    @PostMapping("/login")
    public AjaxResult login(@RequestParam("token") String token)
    {
        AjaxResult ajax = AjaxResult.success();
        String ruoYiToken = ssoService.ssoLogin(token);
        ajax.put(Constants.TOKEN, ruoYiToken);
        return ajax;
    }
}

