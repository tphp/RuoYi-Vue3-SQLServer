/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysNumberRule;

/**
 * 编号规则Service接口
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public interface ISysNumberRuleService
{
    /**
     * 查询编号规则列表
     * 
     * @param sysNumberRule 编号规则
     * @return 编号规则集合
     */
    public List<SysNumberRule> selectNumberRuleList(SysNumberRule sysNumberRule);

    /**
     * 通过ID查询编号规则（含元素列表）
     * 
     * @param ruleId 编号规则ID
     * @return 编号规则
     */
    public SysNumberRule selectNumberRuleById(Long ruleId);

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
     * 批量删除编号规则
     * 
     * @param ruleIds 需要删除的编号规则ID
     * @return 结果
     */
    public int deleteNumberRuleByIds(Long[] ruleIds);

    /**
     * 删除编号规则信息
     * 
     * @param ruleId 编号规则ID
     * @return 结果
     */
    public int deleteNumberRuleById(Long ruleId);

    /**
     * 校验规则编码是否唯一
     * 
     * @param sysNumberRule 编号规则
     * @return 结果
     */
    public boolean checkRuleCodeUnique(SysNumberRule sysNumberRule);

    /**
     * 修改规则状态
     * 
     * @param sysNumberRule 编号规则
     * @return 结果
     */
    public int updateRuleStatus(SysNumberRule sysNumberRule);

    /**
     * 生成编号
     * 
     * @param ruleCode 规则编码
     * @return 生成的编号
     */
    public String generateNumber(String ruleCode);

    /**
     * 预览编号格式
     * 
     * @param sysNumberRule 编号规则
     * @return 预览的编号
     */
    public String previewNumber(SysNumberRule sysNumberRule);
}
