/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.service.impl;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.apilog.domain.SysOutboundLog;
import com.ruoyi.apilog.mapper.SysOutboundLogMapper;
import com.ruoyi.apilog.service.ISysOutboundLogService;
import com.ruoyi.apilog.utils.ApiLogExecutor;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * 出站接口日志Service实现类
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@Service
public class SysOutboundLogServiceImpl implements ISysOutboundLogService
{
    private static final Logger log = LoggerFactory.getLogger(SysOutboundLogServiceImpl.class);

    @Autowired
    private SysOutboundLogMapper outboundLogMapper;

    @Autowired
    private ApiLogExecutor apiLogExecutor;

    @Override
    public List<SysOutboundLog> selectOutboundLogList(SysOutboundLog outboundLog)
    {
        return outboundLogMapper.selectOutboundLogList(outboundLog);
    }

    @Override
    public SysOutboundLog selectOutboundLogById(Long outboundId)
    {
        return outboundLogMapper.selectOutboundLogById(outboundId);
    }

    @Override
    @Transactional
    public int deleteOutboundLogByIds(Long[] outboundIds)
    {
        return outboundLogMapper.deleteOutboundLogByIds(outboundIds);
    }

    @Override
    @Transactional
    public int cleanOutboundLog()
    {
        return outboundLogMapper.cleanOutboundLog();
    }

    @Override
    public void record(SysOutboundLog outboundLog)
    {
        if (outboundLog == null)
        {
            return;
        }
        fillDefaults(outboundLog);
        apiLogExecutor.submit(() -> {
            try
            {
                outboundLogMapper.insertOutboundLog(outboundLog);
            }
            catch (Exception e)
            {
                log.warn("[ApiLog] 出站日志写入失败: {}", e.getMessage());
            }
        });
    }

    /**
     * 补全审计字段默认值
     *
     * @param outboundLog 日志对象
     */
    private void fillDefaults(SysOutboundLog outboundLog)
    {
        Date now = new Date();
        String operator = currentUsername();
        if (outboundLog.getRequestTime() == null)
        {
            outboundLog.setRequestTime(now);
        }
        if (outboundLog.getCreationDate() == null)
        {
            outboundLog.setCreationDate(now);
        }
        if (outboundLog.getObjectVersionNumber() == null)
        {
            outboundLog.setObjectVersionNumber(1L);
        }
        if (outboundLog.getRequestId() == null)
        {
            outboundLog.setRequestId(UUID.randomUUID().toString().replace("-", ""));
        }
        if (outboundLog.getProgramId() == null)
        {
            outboundLog.setProgramId("EBSP");
        }
        if (outboundLog.getCreatedBy() == null)
        {
            outboundLog.setCreatedBy(operator);
        }
        if (outboundLog.getLastUpdatedBy() == null)
        {
            outboundLog.setLastUpdatedBy(outboundLog.getCreatedBy());
        }
        if (outboundLog.getLastUpdateDate() == null)
        {
            outboundLog.setLastUpdateDate(outboundLog.getCreationDate());
        }
        if (outboundLog.getLastUpdateLogin() == null)
        {
            outboundLog.setLastUpdateLogin(outboundLog.getCreatedBy());
        }
    }

    /**
     * 获取当前登录用户名，未登录时返回 system
     *
     * @return 用户名
     */
    private String currentUsername()
    {
        try
        {
            String username = SecurityUtils.getUsername();
            return username == null ? "system" : username;
        }
        catch (Exception e)
        {
            return "system";
        }
    }
}
