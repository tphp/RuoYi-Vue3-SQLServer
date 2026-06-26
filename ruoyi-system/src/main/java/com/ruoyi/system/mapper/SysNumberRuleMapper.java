/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysNumberRule;

/**
 * 编号规则Mapper接口
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public interface SysNumberRuleMapper
{
    /**
     * 查询编号规则列表
     * 
     * @param sysNumberRule 编号规则
     * @return 编号规则集合
     */
    public List<SysNumberRule> selectNumberRuleList(SysNumberRule sysNumberRule);

    /**
     * 通过ID查询编号规则
     * 
     * @param ruleId 编号规则ID
     * @return 编号规则
     */
    public SysNumberRule selectNumberRuleById(Long ruleId);

    /**
     * 通过规则编码查询编号规则
     * 
     * @param ruleCode 规则编码
     * @return 编号规则
     */
    public SysNumberRule selectNumberRuleByCode(String ruleCode);

    /**
     * 新增编号规则
     * 
     * @param sysNumberRule 编号规则
     * @return 结果
     */
    public int insertNumberRule(SysNumberRule sysNumberRule);

    /**
     * 修改编号规则
     * 
     * @param sysNumberRule 编号规则
     * @return 结果
     */
    public int updateNumberRule(SysNumberRule sysNumberRule);

    /**
     * 删除编号规则
     * 
     * @param ruleId 编号规则ID
     * @return 结果
     */
    public int deleteNumberRuleById(Long ruleId);

    /**
     * 批量删除编号规则
     * 
     * @param ruleIds 需要删除的数据ID
     * @return 结果
     */
    public int deleteNumberRuleByIds(Long[] ruleIds);

    /**
     * 校验规则编码是否唯一
     * 
     * @param ruleCode 规则编码
     * @return 结果
     */
    public SysNumberRule checkRuleCodeUnique(String ruleCode);
}
