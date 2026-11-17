package com.ruoyi.system.mapper;

import java.util.List;
import com.ruoyi.system.domain.SysCommonApi;

public interface SysCommonApiMapper {
    public List<SysCommonApi> selectCommonApiList(SysCommonApi sysCommonApi);
    public SysCommonApi selectCommonApiById(Long id);
    public SysCommonApi selectCommonApiByKey(String apiKey);
    public int insertCommonApi(SysCommonApi sysCommonApi);
    public int updateCommonApi(SysCommonApi sysCommonApi);
    public int deleteCommonApiById(Long id);
    public int deleteCommonApiByIds(Long[] ids);
}
