/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service;

import java.util.Set;
import com.ruoyi.bizperm.domain.bo.VisibleUsersQueryBo;
import com.ruoyi.bizperm.domain.vo.VisibleUsersResultVo;

/**
 * 可见人员计算服务
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public interface IBizPermQueryService
{
    /**
     * 计算某人在某场景下的可见人员工号集合
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 去重后的工号集合；未配置时返回空集合
     */
    Set<String> getVisibleUserCodes(String policyCode, String userCode);

    /**
     * 按业务场景清理可见人员缓存（权限配置变更后调用）
     *
     * @param policyCode 业务场景编码
     */
    void evictVisibleUsers(String policyCode);

    /**
     * 查询可见人员结果（平铺或按部门分组）
     *
     * @param query 查询参数
     * @return 查询结果
     */
    VisibleUsersResultVo queryVisibleUsers(VisibleUsersQueryBo query);

    /**
     * 统计可见人员数量
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 去重后人数
     */
    long countVisibleUsers(String policyCode, String userCode);

    /**
     * 判断人员是否存在且启用
     *
     * @param userCode 工号
     * @return true 存在且启用
     */
    boolean existsActiveUser(String userCode);

    /**
     * 判断业务场景是否已在字典中登记
     *
     * @param policyCode 业务场景编码
     * @return true 已登记
     */
    boolean existsPolicyScene(String policyCode);
}
