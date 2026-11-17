/**
 * @author Zhang zhan
 * @date 2026-06-26
 */
package com.ruoyi.system.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysNumberRule;
import com.ruoyi.system.domain.SysNumberRuleItem;
import com.ruoyi.system.domain.SysNumberSerial;
import com.ruoyi.system.mapper.SysNumberRuleItemMapper;
import com.ruoyi.system.mapper.SysNumberRuleMapper;
import com.ruoyi.system.mapper.SysNumberSerialMapper;
import com.ruoyi.system.service.ISysNumberRuleService;

/**
 * 编号规则Service实现类
 * 
 * @author Zhang zhan
 * @date 2026-06-26
 */
@Service
public class SysNumberRuleServiceImpl implements ISysNumberRuleService
{
    @Autowired
    private SysNumberRuleMapper numberRuleMapper;

    @Autowired
    private SysNumberRuleItemMapper numberRuleItemMapper;

    @Autowired
    private SysNumberSerialMapper numberSerialMapper;

    /**
     * 元素类型常量
     */
    private static final String ITEM_TYPE_CONSTANT = "1";
    private static final String ITEM_TYPE_DATE = "2";
    private static final String ITEM_TYPE_SERIAL = "3";

    /**
     * 周期类型常量
     */
    private static final String CYCLE_TYPE_NONE = "1";
    private static final String CYCLE_TYPE_DAY = "2";
    private static final String CYCLE_TYPE_MONTH = "3";
    private static final String CYCLE_TYPE_YEAR = "4";

    /**
     * 周期键常量
     */
    private static final String CYCLE_KEY_ALL = "ALL";

    @Override
    public List<SysNumberRule> selectNumberRuleList(SysNumberRule sysNumberRule)
    {
        return numberRuleMapper.selectNumberRuleList(sysNumberRule);
    }

    @Override
    public SysNumberRule selectNumberRuleById(Long ruleId)
    {
        SysNumberRule rule = numberRuleMapper.selectNumberRuleById(ruleId);
        if (rule != null)
        {
            List<SysNumberRuleItem> items = numberRuleItemMapper.selectRuleItemsByRuleId(ruleId);
            rule.setItems(items);
        }
        return rule;
    }

    @Override
    @Transactional
    public int insertNumberRule(SysNumberRule sysNumberRule)
    {
        sysNumberRule.setCreateBy(SecurityUtils.getUsername());
        int result = numberRuleMapper.insertNumberRule(sysNumberRule);
        
        if (result > 0 && sysNumberRule.getItems() != null && !sysNumberRule.getItems().isEmpty())
        {
            for (SysNumberRuleItem item : sysNumberRule.getItems())
            {
                item.setRuleId(sysNumberRule.getRuleId());
                item.setCreateBy(SecurityUtils.getUsername());
            }
            numberRuleItemMapper.batchInsertRuleItems(sysNumberRule.getItems());
        }
        return result;
    }

    @Override
    @Transactional
    public int updateNumberRule(SysNumberRule sysNumberRule)
    {
        sysNumberRule.setUpdateBy(SecurityUtils.getUsername());
        int result = numberRuleMapper.updateNumberRule(sysNumberRule);
        
        if (result > 0)
        {
            numberRuleItemMapper.deleteRuleItemsByRuleId(sysNumberRule.getRuleId());
            
            if (sysNumberRule.getItems() != null && !sysNumberRule.getItems().isEmpty())
            {
                for (SysNumberRuleItem item : sysNumberRule.getItems())
                {
                    item.setRuleId(sysNumberRule.getRuleId());
                    item.setCreateBy(SecurityUtils.getUsername());
                }
                numberRuleItemMapper.batchInsertRuleItems(sysNumberRule.getItems());
            }
        }
        return result;
    }

    @Override
    @Transactional
    public int deleteNumberRuleByIds(Long[] ruleIds)
    {
        numberRuleItemMapper.deleteRuleItemsByRuleIds(ruleIds);
        return numberRuleMapper.deleteNumberRuleByIds(ruleIds);
    }

    @Override
    @Transactional
    public int deleteNumberRuleById(Long ruleId)
    {
        numberRuleItemMapper.deleteRuleItemsByRuleId(ruleId);
        return numberRuleMapper.deleteNumberRuleById(ruleId);
    }

    @Override
    public boolean checkRuleCodeUnique(SysNumberRule sysNumberRule)
    {
        Long ruleId = StringUtils.isNull(sysNumberRule.getRuleId()) ? -1L : sysNumberRule.getRuleId();
        SysNumberRule info = numberRuleMapper.checkRuleCodeUnique(sysNumberRule.getRuleCode());
        if (StringUtils.isNotNull(info) && info.getRuleId().longValue() != ruleId.longValue())
        {
            return false;
        }
        return true;
    }

    @Override
    public int updateRuleStatus(SysNumberRule sysNumberRule)
    {
        sysNumberRule.setUpdateBy(SecurityUtils.getUsername());
        return numberRuleMapper.updateNumberRule(sysNumberRule);
    }

    @Override
    @Transactional
    public String generateNumber(String ruleCode)
    {
        SysNumberRule rule = numberRuleMapper.selectNumberRuleByCode(ruleCode);
        if (rule == null)
        {
            throw new RuntimeException("编号规则不存在：" + ruleCode);
        }
        if (!"0".equals(rule.getStatus()))
        {
            throw new RuntimeException("编号规则已停用：" + ruleCode);
        }

        List<SysNumberRuleItem> items = numberRuleItemMapper.selectRuleItemsByRuleId(rule.getRuleId());
        if (items == null || items.isEmpty())
        {
            throw new RuntimeException("编号规则未配置元素：" + ruleCode);
        }

        StringBuilder sb = new StringBuilder();
        for (SysNumberRuleItem item : items)
        {
            sb.append(generateItemValue(item, rule.getRuleId()));
        }

        return sb.toString();
    }

    @Override
    public String previewNumber(SysNumberRule sysNumberRule)
    {
        List<SysNumberRuleItem> items = sysNumberRule.getItems();
        if (items == null || items.isEmpty())
        {
            return "";
        }

        StringBuilder sb = new StringBuilder();
        for (SysNumberRuleItem item : items)
        {
            sb.append(previewItemValue(item));
        }

        return sb.toString();
    }

    /**
     * 生成元素值（真实生成）
     */
    private String generateItemValue(SysNumberRuleItem item, Long ruleId)
    {
        String itemType = item.getItemType();
        
        if (ITEM_TYPE_CONSTANT.equals(itemType))
        {
            return StringUtils.nvl(item.getItemValue(), "");
        }
        else if (ITEM_TYPE_DATE.equals(itemType))
        {
            String dateFormat = StringUtils.nvl(item.getDateFormat(), "yyyyMMdd");
            SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
            return sdf.format(new Date());
        }
        else if (ITEM_TYPE_SERIAL.equals(itemType))
        {
            int startNumber = item.getStartNumber() != null ? item.getStartNumber() : 1;
            int serialLength = item.getSerialLength() != null ? item.getSerialLength() : 4;
            boolean isPadZero = "1".equals(item.getIsPadZero());
            String cycleType = StringUtils.nvl(item.getCycleType(), CYCLE_TYPE_NONE);
            
            String cycleKey = generateCycleKey(cycleType);
            long serialNumber = getNextSerialNumber(ruleId, cycleKey, startNumber);
            
            return formatSerialNumber(serialNumber, serialLength, isPadZero);
        }
        
        return "";
    }

    /**
     * 预览元素值（模拟生成，用于预览）
     */
    private String previewItemValue(SysNumberRuleItem item)
    {
        String itemType = item.getItemType();
        
        if (ITEM_TYPE_CONSTANT.equals(itemType))
        {
            return StringUtils.nvl(item.getItemValue(), "");
        }
        else if (ITEM_TYPE_DATE.equals(itemType))
        {
            String dateFormat = StringUtils.nvl(item.getDateFormat(), "yyyyMMdd");
            SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
            return sdf.format(new Date());
        }
        else if (ITEM_TYPE_SERIAL.equals(itemType))
        {
            int startNumber = item.getStartNumber() != null ? item.getStartNumber() : 1;
            int serialLength = item.getSerialLength() != null ? item.getSerialLength() : 4;
            boolean isPadZero = "1".equals(item.getIsPadZero());
            
            return formatSerialNumber(startNumber, serialLength, isPadZero);
        }
        
        return "";
    }

    /**
     * 生成周期键
     */
    private String generateCycleKey(String cycleType)
    {
        SimpleDateFormat sdf;
        switch (cycleType)
        {
            case CYCLE_TYPE_DAY:
                sdf = new SimpleDateFormat("yyyyMMdd");
                return sdf.format(new Date());
            case CYCLE_TYPE_MONTH:
                sdf = new SimpleDateFormat("yyyyMM");
                return sdf.format(new Date());
            case CYCLE_TYPE_YEAR:
                sdf = new SimpleDateFormat("yyyy");
                return sdf.format(new Date());
            case CYCLE_TYPE_NONE:
            default:
                return CYCLE_KEY_ALL;
        }
    }

    /**
     * 获取下一个流水号
     */
    @Transactional
    public long getNextSerialNumber(Long ruleId, String cycleKey, int startNumber)
    {
        SysNumberSerial serial = numberSerialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);

        if (serial == null)
        {
            try
            {
                serial = new SysNumberSerial();
                serial.setRuleId(ruleId);
                serial.setCycleKey(cycleKey);
                serial.setCurrentValue((long) startNumber);
                serial.setCreateTime(DateUtils.getNowDate());
                serial.setUpdateTime(DateUtils.getNowDate());
                numberSerialMapper.insertSerial(serial);
                return startNumber;
            }
            catch (DuplicateKeyException e)
            {
                serial = numberSerialMapper.selectByRuleIdAndCycleKeyWithLock(ruleId, cycleKey);
            }
        }

        long nextValue = serial.getCurrentValue() + 1;
        serial.setCurrentValue(nextValue);
        serial.setUpdateTime(DateUtils.getNowDate());
        numberSerialMapper.updateSerial(serial);

        return nextValue;
    }

    /**
     * 格式化流水号
     */
    private String formatSerialNumber(long serialNumber, int length, boolean isPadZero)
    {
        String serialStr = String.valueOf(serialNumber);
        
        if (!isPadZero)
        {
            return serialStr;
        }
        
        if (serialStr.length() >= length)
        {
            return serialStr;
        }
        
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length - serialStr.length(); i++)
        {
            sb.append("0");
        }
        sb.append(serialStr);
        return sb.toString();
    }
}
