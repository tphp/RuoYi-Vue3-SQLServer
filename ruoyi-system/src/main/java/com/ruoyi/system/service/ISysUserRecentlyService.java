package com.ruoyi.system.service;

import java.util.ArrayList;
import java.util.List;
import com.ruoyi.system.domain.SysUserRecently;

/**
 * 用户最近信息关联Service接口
 * 
 * @author ruoyi
 * @date 2026-06-18
 */
public interface ISysUserRecentlyService 
{
    /**
     * 查询用户最近信息关联列表
     * 
     * @param type 用户最近信息关联
     * @return 用户最近信息关联集合
     */
    public List<SysUserRecently> selectSysUserRecentlyList(int type, Long userId);

    /**
     * 新增用户最近信息关联
     * 
     * @param userIds 用户最近信息关联
     * @return 结果
     */
    public int updateSysUserRecently(ArrayList<?> userIds, Long userId, int type);

    /**
     * 批量删除用户最近信息关联
     * 
     * @param userId 需要删除的用户最近信息关联主键集合
     * @return 结果
     */
    public int clearSysUserRecently(int type, Long userId);
}
