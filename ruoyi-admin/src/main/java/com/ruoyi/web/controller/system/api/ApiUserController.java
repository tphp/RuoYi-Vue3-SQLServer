package com.ruoyi.web.controller.system.api;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.service.ISysUserService;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
@RestController
@RequestMapping("/api/system")
public class ApiUserController extends BaseController
{
    @Autowired
    private ISysUserService userService;

    /**
     * 获取用户列表
     * 
     * @return 用户列表
     */
    @GetMapping("/user/list")
    public AjaxResult userList()
    {
        List<SysUser> list = userService.selectUserList(new SysUser());
        return success(list);
    }
}
