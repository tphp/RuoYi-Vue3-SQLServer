/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service;

import java.util.List;
import com.ruoyi.bizperm.domain.SysBizPermPolicy;

/**
 * 业务权限策略服务（配置维护入口）
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public interface IBizPermPolicyService
{
    /**
     * 查询策略列表
     *
     * @param query 查询条件
     * @return 策略集合
     */
    List<SysBizPermPolicy> selectPolicyList(SysBizPermPolicy query);

    /**
     * 查询策略详情（含可见范围）
     *
     * @param id 策略主键
     * @return 策略
     */
    SysBizPermPolicy selectPolicyById(Long id);

    /**
     * 新增策略及其可见范围
     *
     * @param policy 策略
     * @return 影响行数
     */
    int insertPolicy(SysBizPermPolicy policy);

    /**
     * 修改策略及其可见范围
     *
     * @param policy 策略
     * @return 影响行数
     */
    int updatePolicy(SysBizPermPolicy policy);

    /**
     * 批量删除策略及其可见范围
     *
     * @param ids 策略主键集合
     * @return 影响行数
     */
    int deletePolicyByIds(Long[] ids);
}
