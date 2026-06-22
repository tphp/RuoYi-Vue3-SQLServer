package com.ruoyi.web.controller.system;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SysUserRecently;
import com.ruoyi.system.service.ISysUserRecentlyService;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 用户最近信息关联Controller
 * 
 * @author ruoyi
 * @date 2026-06-18
 */
@RestController
@RequestMapping("/system/recently")
public class SysUserRecentlyController extends BaseController
{
    @Autowired
    private ISysUserRecentlyService sysUserRecentlyService;

    /**
     * 查询用户最近信息关联列表
     */
    @GetMapping("/list/{type}")
    public TableDataInfo list(@PathVariable("type") int type)
    {
        startPage();
        List<SysUserRecently> list = sysUserRecentlyService.selectSysUserRecentlyList(type, getUserId());
        return getDataTable(list);
    }

    /**
     * 新增用户最近信息关联
     */
    @Log(title = "用户最近信息关联", businessType = BusinessType.INSERT)
    @PostMapping("/update/{type}")
    public AjaxResult update(@PathVariable("type") int type, @RequestBody Map<String, Object> userInfo)
    {
        Object userIds = userInfo.get("userIds");
        if (userIds instanceof ArrayList<?>) {
            int count = sysUserRecentlyService.updateSysUserRecently((ArrayList<?>) userIds, getUserId(), type);
            if (count >= 0) {
                return success();
            }
        }
        return error();
    }

    /**
     * 清空用户最近信息关联
     */
    @Log(title = "清空最近信息关联", businessType = BusinessType.DELETE)
    @DeleteMapping("/clear/{type}")
    public AjaxResult clear(@PathVariable("type") int type)
    {
        int count = sysUserRecentlyService.clearSysUserRecently(type, getUserId());
        return count >= 0 ? AjaxResult.success() : AjaxResult.error();
    }
}
