package com.ruoyi.web.controller.system;

import java.util.List;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysCommonApi;
import com.ruoyi.system.service.ISysCommonApiService;

@RestController
@RequestMapping("/system/commonApi")
public class SysCommonApiController extends BaseController {
    @Autowired
    private ISysCommonApiService commonApiService;

    @PreAuthorize("@ss.hasPermi('system:commonApi:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysCommonApi sysCommonApi) {
        startPage();
        List<SysCommonApi> list = commonApiService.selectCommonApiList(sysCommonApi);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('system:commonApi:export')")
    @Log(title = "通用接口配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysCommonApi sysCommonApi) {
        List<SysCommonApi> list = commonApiService.selectCommonApiList(sysCommonApi);
        ExcelUtil<SysCommonApi> util = new ExcelUtil<SysCommonApi>(SysCommonApi.class);
        util.exportExcel(response, list, "通用接口配置数据");
    }

    @PreAuthorize("@ss.hasPermi('system:commonApi:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id) {
        return success(commonApiService.selectCommonApiById(id));
    }

    @PreAuthorize("@ss.hasPermi('system:commonApi:add')")
    @Log(title = "通用接口配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysCommonApi sysCommonApi) {
        if (!commonApiService.checkApiKeyUnique(sysCommonApi)) {
            return error("新增接口失败，接口关键字已存在");
        }
        sysCommonApi.setCreateBy(getLoginUser().getUser().getNickName());
        return toAjax(commonApiService.insertCommonApi(sysCommonApi));
    }

    @PreAuthorize("@ss.hasPermi('system:commonApi:edit')")
    @Log(title = "通用接口配置", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysCommonApi sysCommonApi) {
        if (!commonApiService.checkApiKeyUnique(sysCommonApi)) {
            return error("修改接口失败，接口关键字已存在");
        }
        sysCommonApi.setUpdateBy(getLoginUser().getUser().getNickName());
        return toAjax(commonApiService.updateCommonApi(sysCommonApi));
    }

    @PreAuthorize("@ss.hasPermi('system:commonApi:remove')")
    @Log(title = "通用接口配置", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids) {
        return toAjax(commonApiService.deleteCommonApiByIds(ids));
    }
}
