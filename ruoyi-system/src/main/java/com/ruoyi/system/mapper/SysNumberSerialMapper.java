/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.mapper;

import com.ruoyi.system.domain.SysNumberSerial;

/**
 * 流水号记录Mapper接口
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public interface SysNumberSerialMapper
{
    /**
     * 根据规则ID和周期键查询流水号记录（加行级锁）
     * 
     * @param ruleId 规则ID
     * @param cycleKey 周期键
     * @return 流水号记录
     */
    public SysNumberSerial selectByRuleIdAndCycleKeyWithLock(Long ruleId, String cycleKey);

    /**
     * 新增流水号记录
     * 
     * @param sysNumberSerial 流水号记录
     * @return 结果
     */
    public int insertSerial(SysNumberSerial sysNumberSerial);

    /**
     * 更新流水号记录
     * 
     * @param sysNumberSerial 流水号记录
     * @return 结果
     */
    public int updateSerial(SysNumberSerial sysNumberSerial);
}
