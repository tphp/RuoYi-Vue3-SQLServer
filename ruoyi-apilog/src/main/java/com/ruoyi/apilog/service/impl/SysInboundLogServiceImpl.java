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
import com.ruoyi.apilog.domain.SysInboundLog;
import com.ruoyi.apilog.mapper.SysInboundLogMapper;
import com.ruoyi.apilog.service.ISysInboundLogService;
import com.ruoyi.apilog.utils.ApiLogExecutor;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * 入站接口日志Service实现类
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@Service
public class SysInboundLogServiceImpl implements ISysInboundLogService
{
    private static final Logger log = LoggerFactory.getLogger(SysInboundLogServiceImpl.class);

    @Autowired
    private SysInboundLogMapper inboundLogMapper;

    @Autowired
    private ApiLogExecutor apiLogExecutor;

    @Override
    public List<SysInboundLog> selectInboundLogList(SysInboundLog inboundLog)
    {
        return inboundLogMapper.selectInboundLogList(inboundLog);
    }

    @Override
    public SysInboundLog selectInboundLogById(Long inboundId)
    {
        return inboundLogMapper.selectInboundLogById(inboundId);
    }

    @Override
    @Transactional
    public int deleteInboundLogByIds(Long[] inboundIds)
    {
        return inboundLogMapper.deleteInboundLogByIds(inboundIds);
    }

    @Override
    @Transactional
    public int cleanInboundLog()
    {
        return inboundLogMapper.cleanInboundLog();
    }

    @Override
    public void record(SysInboundLog inboundLog)
    {
        if (inboundLog == null)
        {
            return;
        }
        fillDefaults(inboundLog);
        apiLogExecutor.submit(() -> {
            try
            {
                inboundLogMapper.insertInboundLog(inboundLog);
            }
            catch (Exception e)
            {
                log.warn("[ApiLog] 入站日志写入失败: {}", e.getMessage());
            }
        });
    }

    /**
     * 补全审计字段默认值
     *
     * @param inboundLog 日志对象
     */
    private void fillDefaults(SysInboundLog inboundLog)
    {
        Date now = new Date();
        String operator = currentUsername();
        if (inboundLog.getRequestTime() == null)
        {
            inboundLog.setRequestTime(now);
        }
        if (inboundLog.getCreationDate() == null)
        {
            inboundLog.setCreationDate(now);
        }
        if (inboundLog.getObjectVersionNumber() == null)
        {
            inboundLog.setObjectVersionNumber(1L);
        }
        if (inboundLog.getRequestId() == null)
        {
            inboundLog.setRequestId(UUID.randomUUID().toString().replace("-", ""));
        }
        if (inboundLog.getProgramId() == null)
        {
            inboundLog.setProgramId("EBSP");
        }
        if (inboundLog.getCreatedBy() == null)
        {
            inboundLog.setCreatedBy(operator);
        }
        if (inboundLog.getLastUpdatedBy() == null)
        {
            inboundLog.setLastUpdatedBy(inboundLog.getCreatedBy());
        }
        if (inboundLog.getLastUpdateDate() == null)
        {
            inboundLog.setLastUpdateDate(inboundLog.getCreationDate());
        }
        if (inboundLog.getLastUpdateLogin() == null)
        {
            inboundLog.setLastUpdateLogin(inboundLog.getCreatedBy());
        }
    }

    /**
     * 获取当前登录用户名，未登录时返回 anonymous
     *
     * @return 用户名
     */
    private String currentUsername()
    {
        try
        {
            String username = SecurityUtils.getUsername();
            return username == null ? "anonymous" : username;
        }
        catch (Exception e)
        {
            return "anonymous";
        }
    }
}
