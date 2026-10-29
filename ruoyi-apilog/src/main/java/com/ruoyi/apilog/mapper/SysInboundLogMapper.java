/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.mapper;

import java.util.List;
import com.ruoyi.apilog.domain.SysInboundLog;

/**
 * 入站接口日志Mapper接口
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
public interface SysInboundLogMapper
{
    /**
     * 查询入站接口日志列表
     *
     * @param inboundLog 查询条件
     * @return 日志集合
     */
    public List<SysInboundLog> selectInboundLogList(SysInboundLog inboundLog);

    /**
     * 根据主键查询入站接口日志
     *
     * @param inboundId 主键
     * @return 日志详情
     */
    public SysInboundLog selectInboundLogById(Long inboundId);

    /**
     * 新增入站接口日志
     *
     * @param inboundLog 日志对象
     * @return 影响行数
     */
    public int insertInboundLog(SysInboundLog inboundLog);

    /**
     * 批量删除入站接口日志
     *
     * @param inboundIds 主键数组
     * @return 影响行数
     */
    public int deleteInboundLogByIds(Long[] inboundIds);

    /**
     * 清空入站接口日志
     *
     * @return 影响行数
     */
    public int cleanInboundLog();
}
