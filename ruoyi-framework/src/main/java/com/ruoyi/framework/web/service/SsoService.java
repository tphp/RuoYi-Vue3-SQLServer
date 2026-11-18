package com.ruoyi.framework.web.service;

import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.domain.model.LoginUser;
import com.ruoyi.common.enums.UserStatus;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.MessageUtils;
import com.ruoyi.common.utils.ip.IpUtils;
import com.ruoyi.framework.manager.AsyncManager;
import com.ruoyi.framework.manager.factory.AsyncFactory;
import com.ruoyi.system.service.ISysUserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * SSO 单点登录业务处理
 *
 * <p>流程：调用 OA 校验 token 拿到 loginName ->
 *  根据 loginName 在本地查找用户 ->
 *  校验用户状态 ->
 *  生成 RuoYi Token 并返回。</p>
 *
 * @author ruoyi
 */
@Component
public class SsoService
{
    private static final Logger log = LoggerFactory.getLogger(SsoService.class);

    @Autowired
    private OaSsoClient oaSsoClient;

    @Autowired
    private TokenService tokenService;

    @Autowired
    private ISysUserService userService;

    @Autowired
    private SysPermissionService permissionService;

    /**
     * SSO 登录
     *
     * @param token 前端从 /sso?token=xxx 拿到的 token
     * @return RuoYi 令牌
     */
    public String ssoLogin(String token)
    {
        // 1) 调用 OA 拿到 loginName，失败时 OaSsoClient 抛出含 errorMsg 的 ServiceException
        String loginName = oaSsoClient.resolveLoginName(token);

        // 2) 在本地查找用户
        SysUser user = userService.selectUserByUserName(loginName);
        if (user == null)
        {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginName, Constants.LOGIN_FAIL,
                    MessageUtils.message("user.not.exists")));
            throw new ServiceException(MessageUtils.message("sso.user.not.exists", loginName));
        }
        if (UserStatus.DELETED.getCode().equals(user.getDelFlag()))
        {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginName, Constants.LOGIN_FAIL,
                    "用户已被删除"));
            throw new ServiceException(MessageUtils.message("sso.user.deleted"));
        }
        if (UserStatus.DISABLE.getCode().equals(user.getStatus()))
        {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginName, Constants.LOGIN_FAIL,
                    MessageUtils.message("user.blocked")));
            throw new ServiceException(MessageUtils.message("user.blocked"));
        }

        // 3) 构造 LoginUser（无密码模式，必须使用 4 参构造器，userId/deptId 与正常登录保持一致）
        LoginUser loginUser = new LoginUser(user.getUserId(), user.getDeptId(), user,
                permissionService.getMenuPermission(user));

        // 4) 记录登录信息并生成 token
        AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginName, Constants.LOGIN_SUCCESS,
                "SSO 登录成功"));
        recordLoginInfo(user.getUserId());
        String ruoYiToken = tokenService.createToken(loginUser);
        log.info("[SSO] 用户 {} 单点登录成功", loginName);
        return ruoYiToken;
    }

    /**
     * 记录登录信息
     */
    public void recordLoginInfo(Long userId)
    {
        if (userId == null)
        {
            return;
        }
        try
        {
            userService.updateLoginInfo(userId, IpUtils.getIpAddr(), DateUtils.getNowDate());
        }
        catch (Exception e)
        {
            log.warn("[SSO] 记录登录信息失败 userId={}, err={}", userId, e.getMessage());
        }
    }
}
