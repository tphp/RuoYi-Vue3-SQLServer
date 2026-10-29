/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.mapper;

import java.util.List;
import com.ruoyi.apilog.domain.SysOutboundLog;

/**
 * 出站接口日志Mapper接口
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
public interface SysOutboundLogMapper
{
    /**
     * 查询出站接口日志列表
     *
     * @param outboundLog 查询条件
     * @return 日志集合
     */
    public List<SysOutboundLog> selectOutboundLogList(SysOutboundLog outboundLog);

    /**
     * 根据主键查询出站接口日志
     *
     * @param outboundId 主键
     * @return 日志详情
     */
    public SysOutboundLog selectOutboundLogById(Long outboundId);

    /**
     * 新增出站接口日志
     *
     * @param outboundLog 日志对象
     * @return 影响行数
     */
    public int insertOutboundLog(SysOutboundLog outboundLog);

    /**
     * 批量删除出站接口日志
     *
     * @param outboundIds 主键数组
     * @return 影响行数
     */
    public int deleteOutboundLogByIds(Long[] outboundIds);

    /**
     * 清空出站接口日志
     *
     * @return 影响行数
     */
    public int cleanOutboundLog();
}
