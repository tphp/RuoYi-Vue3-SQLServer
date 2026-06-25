package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysApiKey;

/**
 * @author Zhang zhan
 * @date 2026-06-24
 */
public interface ISysApiKeyService
{
    /**
     * 查询API密钥列表
     * 
     * @param sysApiKey API密钥信息
     * @return API密钥集合
     */
    public List<SysApiKey> selectApiKeyList(SysApiKey sysApiKey);

    /**
     * 通过ID查询API密钥
     * 
     * @param id API密钥ID
     * @return API密钥信息
     */
    public SysApiKey selectApiKeyById(Long id);

    /**
     * 通过API Key查询API密钥
     * 
     * @param apiKey API Key
     * @return API密钥信息
     */
    public SysApiKey selectApiKeyByKey(String apiKey);

    /**
     * 验证API Key和Secret
     * 
     * @param apiKey API Key
     * @param apiSecret API Secret
     * @return API密钥信息
     */
    public SysApiKey validateApiKey(String apiKey, String apiSecret);

    /**
     * 新增API密钥
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    public int insertApiKey(SysApiKey sysApiKey);

    /**
     * 修改API密钥
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    public int updateApiKey(SysApiKey sysApiKey);

    /**
     * 批量删除API密钥
     * 
     * @param ids 需要删除的API密钥ID
     * @return 结果
     */
    public int deleteApiKeyByIds(Long[] ids);

    /**
     * 删除API密钥信息
     * 
     * @param id API密钥ID
     * @return 结果
     */
    public int deleteApiKeyById(Long id);

    /**
     * 校验API Key是否唯一
     * 
     * @param sysApiKey API密钥信息
     * @return 结果
     */
    public boolean checkApiKeyUnique(SysApiKey sysApiKey);

    /**
     * 生成API Key
     * 
     * @return API Key
     */
    public String generateApiKey();

    /**
     * 生成API Secret
     * 
     * @return API Secret
     */
    public String generateApiSecret();
}
