/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
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
import com.ruoyi.system.domain.SysNumberRule;
import com.ruoyi.system.service.ISysNumberRuleService;

/**
 * 编号规则Controller
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
@RestController
@RequestMapping("/system/numberRule")
public class SysNumberRuleController extends BaseController
{
    @Autowired
    private ISysNumberRuleService numberRuleService;

    /**
     * 查询编号规则列表
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysNumberRule sysNumberRule)
    {
        startPage();
        List<SysNumberRule> list = numberRuleService.selectNumberRuleList(sysNumberRule);
        return getDataTable(list);
    }

    /**
     * 导出编号规则列表
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:export')")
    @Log(title = "编号规则", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysNumberRule sysNumberRule)
    {
        List<SysNumberRule> list = numberRuleService.selectNumberRuleList(sysNumberRule);
        ExcelUtil<SysNumberRule> util = new ExcelUtil<SysNumberRule>(SysNumberRule.class);
        util.exportExcel(response, list, "编号规则数据");
    }

    /**
     * 获取编号规则详细信息（含元素列表）
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:query')")
    @GetMapping(value = "/{ruleId}")
    public AjaxResult getInfo(@PathVariable("ruleId") Long ruleId)
    {
        return success(numberRuleService.selectNumberRuleById(ruleId));
    }

    /**
     * 新增编号规则
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:add')")
    @Log(title = "编号规则", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysNumberRule sysNumberRule)
    {
        if (!numberRuleService.checkRuleCodeUnique(sysNumberRule))
        {
            return error("新增编号规则'" + sysNumberRule.getRuleName() + "'失败，规则编码已存在");
        }
        return toAjax(numberRuleService.insertNumberRule(sysNumberRule));
    }

    /**
     * 修改编号规则
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:edit')")
    @Log(title = "编号规则", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysNumberRule sysNumberRule)
    {
        if (!numberRuleService.checkRuleCodeUnique(sysNumberRule))
        {
            return error("修改编号规则'" + sysNumberRule.getRuleName() + "'失败，规则编码已存在");
        }
        return toAjax(numberRuleService.updateNumberRule(sysNumberRule));
    }

    /**
     * 删除编号规则
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:remove')")
    @Log(title = "编号规则", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ruleIds}")
    public AjaxResult remove(@PathVariable Long[] ruleIds)
    {
        return toAjax(numberRuleService.deleteNumberRuleByIds(ruleIds));
    }

    /**
     * 修改规则状态
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:edit')")
    @Log(title = "编号规则", businessType = BusinessType.UPDATE)
    @PutMapping("/status")
    public AjaxResult changeStatus(@RequestBody SysNumberRule sysNumberRule)
    {
        return toAjax(numberRuleService.updateRuleStatus(sysNumberRule));
    }

    /**
     * 预览编号格式
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:query')")
    @PostMapping("/preview")
    public AjaxResult preview(@RequestBody SysNumberRule sysNumberRule)
    {
        String previewNumber = numberRuleService.previewNumber(sysNumberRule);
        return success((Object) previewNumber);
    }

    /**
     * 生成编号（测试用）
     */
    @PreAuthorize("@ss.hasPermi('system:numberRule:edit')")
    @PostMapping("/generate/{ruleCode}")
    public AjaxResult generate(@PathVariable String ruleCode)
    {
        String number = numberRuleService.generateNumber(ruleCode);
        return success((Object) number);
    }
}
