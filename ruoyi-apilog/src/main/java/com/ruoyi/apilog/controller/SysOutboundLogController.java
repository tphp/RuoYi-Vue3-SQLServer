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
import com.ruoyi.apilog.domain.SysOutboundLog;
import com.ruoyi.apilog.service.ISysOutboundLogService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;

/**
 * 出站接口日志Controller
 *
 * 提供本系统调用外部接口的日志查询、详情、删除与清空能力。
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@RestController
@RequestMapping("/monitor/outboundLog")
public class SysOutboundLogController extends BaseController
{
    @Autowired
    private ISysOutboundLogService outboundLogService;

    /**
     * 查询出站接口日志列表
     *
     * @param outboundLog 查询条件
     * @return 分页日志列表
     */
    @PreAuthorize("@ss.hasPermi('monitor:outboundLog:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysOutboundLog outboundLog)
    {
        startPage();
        List<SysOutboundLog> list = outboundLogService.selectOutboundLogList(outboundLog);
        return getDataTable(list);
    }

    /**
     * 获取出站接口日志详情
     *
     * @param outboundId 主键
     * @return 日志详情
     */
    @PreAuthorize("@ss.hasPermi('monitor:outboundLog:query')")
    @GetMapping("/{outboundId}")
    public AjaxResult getInfo(@PathVariable("outboundId") Long outboundId)
    {
        return success(outboundLogService.selectOutboundLogById(outboundId));
    }

    /**
     * 批量删除出站接口日志
     *
     * @param outboundIds 主键数组
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('monitor:outboundLog:remove')")
    @Log(title = "出站接口日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{outboundIds}")
    public AjaxResult remove(@PathVariable Long[] outboundIds)
    {
        return toAjax(outboundLogService.deleteOutboundLogByIds(outboundIds));
    }

    /**
     * 清空出站接口日志
     *
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('monitor:outboundLog:remove')")
    @Log(title = "出站接口日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean")
    public AjaxResult clean()
    {
        outboundLogService.cleanOutboundLog();
        return success();
    }
}
