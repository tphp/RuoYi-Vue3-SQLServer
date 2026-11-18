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
import com.ruoyi.system.domain.SysApiKey;
import com.ruoyi.system.service.ISysApiKeyService;
import com.ruoyi.common.utils.MessageUtils;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
@RestController
@RequestMapping("/system/apiKey")
public class SysApiKeyController extends BaseController
{
    @Autowired
    private ISysApiKeyService apiKeyService;

    /**
     * 查询API密钥列表
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysApiKey sysApiKey)
    {
        startPage();
        List<SysApiKey> list = apiKeyService.selectApiKeyList(sysApiKey);
        return getDataTable(list);
    }

    /**
     * 导出API密钥列表
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:export')")
    @Log(title = "API密钥管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysApiKey sysApiKey)
    {
        List<SysApiKey> list = apiKeyService.selectApiKeyList(sysApiKey);
        ExcelUtil<SysApiKey> util = new ExcelUtil<SysApiKey>(SysApiKey.class);
        util.exportExcel(response, list, "API密钥数据");
    }

    /**
     * 获取API密钥详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:query')")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@PathVariable("id") Long id)
    {
        return success(apiKeyService.selectApiKeyById(id));
    }

    /**
     * 新增API密钥
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:add')")
    @Log(title = "API密钥管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysApiKey sysApiKey)
    {
        if (!apiKeyService.checkApiKeyUnique(sysApiKey))
        {
            return error(MessageUtils.message("apiKey.add.exists"));
        }
        sysApiKey.setCreateBy(getUsername());
        return toAjax(apiKeyService.insertApiKey(sysApiKey));
    }

    /**
     * 修改API密钥
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:edit')")
    @Log(title = "API密钥管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysApiKey sysApiKey)
    {
        if (!apiKeyService.checkApiKeyUnique(sysApiKey))
        {
            return error(MessageUtils.message("apiKey.edit.exists"));
        }
        sysApiKey.setUpdateBy(getUsername());
        return toAjax(apiKeyService.updateApiKey(sysApiKey));
    }

    /**
     * 删除API密钥
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:remove')")
    @Log(title = "API密钥管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(apiKeyService.deleteApiKeyByIds(ids));
    }

    /**
     * 生成API Key
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:add')")
    @GetMapping("/generateApiKey")
    public AjaxResult generateApiKey()
    {
        return AjaxResult.success((Object) apiKeyService.generateApiKey());
    }

    /**
     * 生成API Secret
     */
    @PreAuthorize("@ss.hasPermi('system:apiKey:add')")
    @GetMapping("/generateApiSecret")
    public AjaxResult generateApiSecret()
    {
        return AjaxResult.success((Object) apiKeyService.generateApiSecret());
    }
}
