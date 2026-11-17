package com.ruoyi.system.service.impl;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SysUserRecentlyMapper;
import com.ruoyi.system.domain.SysUserRecently;
import com.ruoyi.system.service.ISysUserRecentlyService;

/**
 * 用户最近信息关联Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-06-18
 */
@Service
public class SysUserRecentlyServiceImpl implements ISysUserRecentlyService 
{
    @Autowired
    private SysUserRecentlyMapper sysUserRecentlyMapper;

    /**
     * 查询用户最近信息关联列表
     * 
     * @param type 用户最近信息关联
     * @return 用户最近信息关联
     */
    @Override
    public List<SysUserRecently> selectSysUserRecentlyList(int type, Long userId)
    {
        return sysUserRecentlyMapper.selectSysUserRecentlyList(type, userId);
    }

    /**
     * 新增用户最近信息关联
     * 
     * @param userIds 用户最近信息关联
     * @return 结果
     */
    @Override
    public int updateSysUserRecently(ArrayList<?> userIds, Long userId, int type)
    {
        return sysUserRecentlyMapper.updateSysUserRecently(userIds, userId, type);
    }

    /**
     * 批量删除用户最近信息关联
     * 
     * @param userId 需要删除的用户最近信息关联主键
     * @return 结果
     */
    @Override
    public int clearSysUserRecently(int type, Long userId)
    {
        return sysUserRecentlyMapper.clearSysUserRecently(type, userId);
    }
}
