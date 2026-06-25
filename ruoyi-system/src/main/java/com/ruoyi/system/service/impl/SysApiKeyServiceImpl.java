package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysApiKey;
import com.ruoyi.system.mapper.SysApiKeyMapper;
import com.ruoyi.system.service.ISysApiKeyService;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
@Service
public class SysApiKeyServiceImpl implements ISysApiKeyService
{
    @Autowired
    private SysApiKeyMapper apiKeyMapper;

    /**
     * 查询API密钥列表
     * 
     * @param sysApiKey API密钥信息
     * @return API密钥集合
     */
    @Override
    public List<SysApiKey> selectApiKeyList(SysApiKey sysApiKey)
    {
        return apiKeyMapper.selectApiKeyList(sysApiKey);
    }

    /**
     * 通过ID查询API密钥
     * 
     * @param id API密钥ID
     * @return API密钥信息
     */
    @Override
    public SysApiKey selectApiKeyById(Long id)
    {
        return apiKeyMapper.selectApiKeyById(id);
    }

    /**
     * 通过API Key查询API密钥
     * 
     * @param apiKey API Key
     * @return API密钥信息
     */
    @Override
    public SysApiKey selectApiKeyByKey(String apiKey)
    {
        return apiKeyMapper.selectApiKeyByKey(apiKey);
    }

    /**
     * 验证API Key和Secret
     * 
     * @param apiKey API Key
     * @param apiSecret API Secret
     * @return API密钥信息
     */
    @Override
    public SysApiKey validateApiKey(String apiKey, String apiSecret)
    {
        SysApiKey sysApiKey = apiKeyMapper.selectApiKeyByKey(apiKey);
        if (sysApiKey == null)
        {
            return null;
        }
        if (!sysApiKey.getApiSecret().equals(apiSecret))
        {
            return null;
        }
        if ("1".equals(sysApiKey.getStatus()))
        {
            return null;
        }
        return sysApiKey;
    }

    /**
     * 新增API密钥
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    @Override
    public int insertApiKey(SysApiKey sysApiKey)
    {
        return apiKeyMapper.insertApiKey(sysApiKey);
    }

    /**
     * 修改API密钥
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    @Override
    public int updateApiKey(SysApiKey sysApiKey)
    {
        return apiKeyMapper.updateApiKey(sysApiKey);
    }

    /**
     * 批量删除API密钥
     * 
     * @param ids 需要删除的API密钥ID
     * @return 结果
     */
    @Override
    public int deleteApiKeyByIds(Long[] ids)
    {
        return apiKeyMapper.deleteApiKeyByIds(ids);
    }

    /**
     * 删除API密钥信息
     * 
     * @param id API密钥ID
     * @return 结果
     */
    @Override
    public int deleteApiKeyById(Long id)
    {
        return apiKeyMapper.deleteApiKeyById(id);
    }

    /**
     * 校验API Key是否唯一
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    @Override
    public boolean checkApiKeyUnique(SysApiKey sysApiKey)
    {
        Long id = StringUtils.isNull(sysApiKey.getId()) ? -1L : sysApiKey.getId();
        SysApiKey info = apiKeyMapper.selectApiKeyByKey(sysApiKey.getApiKey());
        if (StringUtils.isNotNull(info) && info.getId().longValue() != id.longValue())
        {
            return false;
        }
        return true;
    }

    /**
     * 生成API Key
     * 
     * @return API Key
     */
    @Override
    public String generateApiKey()
    {
        return "ak_" + UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * 生成API Secret
     * 
     * @return API Secret
     */
    @Override
    public String generateApiSecret()
    {
        return "sk_" + UUID.randomUUID().toString().replace("-", "");
    }
}
