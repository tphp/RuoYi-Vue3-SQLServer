package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SysCommonApi;

public interface ISysCommonApiService {
    public List<SysCommonApi> selectCommonApiList(SysCommonApi sysCommonApi);
    public SysCommonApi selectCommonApiById(Long id);
    public SysCommonApi selectCommonApiByKey(String apiKey);
    public int insertCommonApi(SysCommonApi sysCommonApi);
    public int updateCommonApi(SysCommonApi sysCommonApi);
    public int deleteCommonApiByIds(Long[] ids);
    public int deleteCommonApiById(Long id);
    public boolean checkApiKeyUnique(SysCommonApi sysCommonApi);
}
