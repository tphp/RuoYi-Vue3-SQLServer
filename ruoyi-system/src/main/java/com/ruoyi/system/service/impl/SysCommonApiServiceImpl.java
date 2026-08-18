package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysCommonApi;
import com.ruoyi.system.mapper.SysCommonApiMapper;
import com.ruoyi.system.service.ISysCommonApiService;

@Service
public class SysCommonApiServiceImpl implements ISysCommonApiService {
    @Autowired
    private SysCommonApiMapper commonApiMapper;

    @Override
    public List<SysCommonApi> selectCommonApiList(SysCommonApi sysCommonApi) {
        return commonApiMapper.selectCommonApiList(sysCommonApi);
    }

    @Override
    public SysCommonApi selectCommonApiById(Long id) {
        return commonApiMapper.selectCommonApiById(id);
    }

    @Override
    public SysCommonApi selectCommonApiByKey(String apiKey) {
        return commonApiMapper.selectCommonApiByKey(apiKey);
    }

    @Override
    public int insertCommonApi(SysCommonApi sysCommonApi) {
        return commonApiMapper.insertCommonApi(sysCommonApi);
    }

    @Override
    public int updateCommonApi(SysCommonApi sysCommonApi) {
        return commonApiMapper.updateCommonApi(sysCommonApi);
    }

    @Override
    public int deleteCommonApiByIds(Long[] ids) {
        return commonApiMapper.deleteCommonApiByIds(ids);
    }

    @Override
    public int deleteCommonApiById(Long id) {
        return commonApiMapper.deleteCommonApiById(id);
    }

    @Override
    public boolean checkApiKeyUnique(SysCommonApi sysCommonApi) {
        Long id = sysCommonApi.getId() == null ? -1L : sysCommonApi.getId();
        SysCommonApi info = commonApiMapper.selectCommonApiByKey(sysCommonApi.getApiKey());
        if (info != null && info.getId().longValue() != id.longValue()) {
            return false;
        }
        return true;
    }
}
