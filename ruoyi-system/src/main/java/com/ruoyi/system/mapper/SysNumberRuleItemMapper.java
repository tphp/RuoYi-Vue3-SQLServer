/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysNumberRuleItem;

/**
 * 编号规则元素Mapper接口
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
public interface SysNumberRuleItemMapper
{
    /**
     * 根据规则ID查询元素列表
     * 
     * @param ruleId 规则ID
     * @return 元素列表
     */
    public List<SysNumberRuleItem> selectRuleItemsByRuleId(Long ruleId);

    /**
     * 新增规则元素
     * 
     * @param sysNumberRuleItem 规则元素
     * @return 结果
     */
    public int insertRuleItem(SysNumberRuleItem sysNumberRuleItem);

    /**
     * 批量新增规则元素
     * 
     * @param ruleItems 规则元素列表
     * @return 结果
     */
    public int batchInsertRuleItems(List<SysNumberRuleItem> ruleItems);

    /**
     * 根据规则ID删除元素
     * 
     * @param ruleId 规则ID
     * @return 结果
     */
    public int deleteRuleItemsByRuleId(Long ruleId);

    /**
     * 批量删除规则元素
     * 
     * @param ruleIds 需要删除的规则ID
     * @return 结果
     */
    public int deleteRuleItemsByRuleIds(Long[] ruleIds);
}
