/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.apilog.domain.SysInboundLog;
import com.ruoyi.apilog.service.ISysInboundLogService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;

/**
 * 入站接口日志Controller
 *
 * 提供外部系统调用本系统接口的日志查询、详情、删除与清空能力。
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@RestController
@RequestMapping("/monitor/inboundLog")
public class SysInboundLogController extends BaseController
{
    @Autowired
    private ISysInboundLogService inboundLogService;

    /**
     * 查询入站接口日志列表
     *
     * @param inboundLog 查询条件
     * @return 分页日志列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:inboundLog:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysInboundLog inboundLog)
    {
        startPage();
        List<SysInboundLog> list = inboundLogService.selectInboundLogList(inboundLog);
        return getDataTable(list);
    }

    /**
     * 获取入站接口日志详情
     *
     * @param inboundId 主键
     * @return 日志详情
     */
    @PreAuthorize("@ss.hasPermi('monitor:inboundLog:query')")
    @GetMapping("/{inboundId}")
    public AjaxResult getInfo(@PathVariable("inboundId") Long inboundId)
    {
        return success(inboundLogService.selectInboundLogById(inboundId));
    }

    /**
     * 批量删除入站接口日志
     *
     * @param inboundIds 主键数组
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('monitor:inboundLog:remove')")
    @Log(title = "入站接口日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{inboundIds}")
    public AjaxResult remove(@PathVariable Long[] inboundIds)
    {
        return toAjax(inboundLogService.deleteInboundLogByIds(inboundIds));
    }

    /**
     * 清空入站接口日志
     *
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('monitor:inboundLog:remove')")
    @Log(title = "入站接口日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean")
    public AjaxResult clean()
    {
        inboundLogService.cleanInboundLog();
        return success();
    }
}
