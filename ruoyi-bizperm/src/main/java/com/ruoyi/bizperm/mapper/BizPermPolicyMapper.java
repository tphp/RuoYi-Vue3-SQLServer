/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import com.ruoyi.bizperm.domain.SysBizPermPolicy;
import com.ruoyi.bizperm.domain.SysBizPermScope;
import com.ruoyi.bizperm.domain.bo.BizPermTreeQueryBo;
import com.ruoyi.bizperm.domain.vo.BizPermSceneCountVo;
import com.ruoyi.bizperm.domain.vo.BizPermTreeNodeVo;
import com.ruoyi.bizperm.domain.vo.VisibleDeptGroupVo;
import com.ruoyi.bizperm.domain.vo.VisibleDeptUserVo;
import com.ruoyi.bizperm.domain.vo.VisibleUserVo;

/**
 * 业务权限Mapper接口
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public interface BizPermPolicyMapper
{
    /**
     * 查询策略列表
     *
     * @param query 查询条件
     * @return 策略集合
     */
    List<SysBizPermPolicy> selectPolicyList(SysBizPermPolicy query);

    /**
     * 根据主键查询策略
     *
     * @param id 主键
     * @return 策略
     */
    SysBizPermPolicy selectPolicyById(Long id);

    /**
     * 批量查询策略下的可见范围
     *
     * @param policyIds 策略主键集合
     * @return 范围集合
     */
    List<SysBizPermScope> selectScopesByPolicyIds(@Param("policyIds") List<Long> policyIds);

    /**
     * 查询当前人作为权限归属人的启用策略
     *
     * @param policyCode   业务场景编码
     * @param subjectType  归属人类型
     * @param subjectValue 归属人值
     * @return 策略集合
     */
    List<SysBizPermPolicy> selectActivePoliciesBySubject(@Param("policyCode") String policyCode,
            @Param("subjectType") String subjectType, @Param("subjectValue") String subjectValue);

    /**
     * 查询可见人员工号集合
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 工号集合
     */
    List<String> selectVisibleUserCodes(@Param("policyCode") String policyCode,
            @Param("userCode") String userCode);

    /**
     * 统计可见人员数量
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 人数
     */
    long countVisibleUsers(@Param("policyCode") String policyCode, @Param("userCode") String userCode);

    /**
     * 分页查询可见人员（由 PageHelper 分页）
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 人员集合
     */
    List<VisibleUserVo> selectVisibleUserPage(@Param("policyCode") String policyCode,
            @Param("userCode") String userCode);

    /**
     * 查询按部门分组的可见人数
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 部门分组（不含人员明细）
     */
    List<VisibleDeptGroupVo> selectVisibleDeptGroups(@Param("policyCode") String policyCode,
            @Param("userCode") String userCode);

    /**
     * 分页查询按部门分组后的人员明细
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @param offset     偏移量
     * @param pageSize   每页条数
     * @return 人员行（含归属分组部门）
     */
    List<VisibleDeptUserVo> selectVisibleDeptUserPage(@Param("policyCode") String policyCode,
            @Param("userCode") String userCode, @Param("offset") int offset,
            @Param("pageSize") int pageSize);

    /**
     * 查询权限结构树归属人节点
     *
     * @param query 查询条件
     * @return 节点集合
     */
    List<BizPermTreeNodeVo> selectOwnerNodes(BizPermTreeQueryBo query);

    /**
     * 批量查询权限结构树场景节点
     *
     * @param query 查询条件
     * @return 场景节点集合（parentKey 指向归属人）
     */
    List<BizPermTreeNodeVo> selectSceneNodes(BizPermTreeQueryBo query);

    /**
     * 批量查询权限结构树部门节点
     *
     * @param query 查询条件
     * @return 部门节点集合（parentKey 指向场景）
     */
    List<BizPermTreeNodeVo> selectDeptNodes(BizPermTreeQueryBo query);

    /**
     * 批量查询权限结构树人员/岗位范围节点
     *
     * @param query 查询条件
     * @return 范围节点集合（parentKey 指向场景）
     */
    List<BizPermTreeNodeVo> selectScopeNodes(BizPermTreeQueryBo query);

    /**
     * 批量统计场景级可见人数
     *
     * @param query 查询条件
     * @return 场景人数集合
     */
    List<BizPermSceneCountVo> selectSceneUserCounts(BizPermTreeQueryBo query);

    /**
     * 查询指定归属人的场景节点
     *
     * @param subjectType  归属人类型
     * @param subjectValue 归属人值
     * @return 场景节点集合
     */
    List<BizPermTreeNodeVo> selectSceneNodesByOwner(@Param("subjectType") String subjectType,
            @Param("subjectValue") String subjectValue);

    /**
     * 查询指定归属人+场景下的部门节点
     *
     * @param subjectType  归属人类型
     * @param subjectValue 归属人值
     * @param policyCode   业务场景编码
     * @return 部门节点集合
     */
    List<BizPermTreeNodeVo> selectDeptNodesByOwnerScene(@Param("subjectType") String subjectType,
            @Param("subjectValue") String subjectValue, @Param("policyCode") String policyCode);

    /**
     * 查询指定归属人+场景下的人员/岗位范围节点
     *
     * @param subjectType  归属人类型
     * @param subjectValue 归属人值
     * @param policyCode   业务场景编码
     * @return 范围节点集合
     */
    List<BizPermTreeNodeVo> selectScopeNodesByOwnerScene(@Param("subjectType") String subjectType,
            @Param("subjectValue") String subjectValue, @Param("policyCode") String policyCode);

    /**
     * 分页查询部门/范围下的员工（由 PageHelper 分页）
     *
     * @param policyId   策略主键
     * @param scopeType  范围类型：DEPT/POST/USER
     * @param scopeValue 范围值
     * @param keyword    姓名/工号关键字
     * @return 员工集合
     */
    List<VisibleUserVo> selectEmployeePage(@Param("policyId") Long policyId,
            @Param("scopeType") String scopeType, @Param("scopeValue") String scopeValue,
            @Param("keyword") String keyword);

    /**
     * 统计启用状态的人员数量
     *
     * @param userCode 工号
     * @return 数量
     */
    int countActiveUserByCode(@Param("userCode") String userCode);

    /**
     * 统计已登记的业务场景数量
     *
     * @param policyCode 业务场景编码
     * @return 数量
     */
    int countSceneDict(@Param("policyCode") String policyCode);

    /**
     * 新增策略
     *
     * @param policy 策略
     * @return 影响行数
     */
    int insertPolicy(SysBizPermPolicy policy);

    /**
     * 修改策略
     *
     * @param policy 策略
     * @return 影响行数
     */
    int updatePolicy(SysBizPermPolicy policy);

    /**
     * 批量删除策略
     *
     * @param ids 策略主键集合
     * @return 影响行数
     */
    int deletePolicyByIds(@Param("ids") Long[] ids);

    /**
     * 按策略主键批量删除可见范围
     *
     * @param policyIds 策略主键集合
     * @return 影响行数
     */
    int deleteScopesByPolicyIds(@Param("policyIds") Long[] policyIds);

    /**
     * 批量新增可见范围
     *
     * @param scopes 可见范围集合
     * @return 影响行数
     */
    int insertScopes(@Param("scopes") List<SysBizPermScope> scopes);

    /**
     * 按主键批量查询策略所属场景编码（用于缓存失效）
     *
     * @param ids 策略主键集合
     * @return 场景编码集合
     */
    List<String> selectPolicyCodesByIds(@Param("ids") Long[] ids);

    /**
     * 统计同场景同归属人的启用策略数量（排除自身）
     *
     * @param policy 策略
     * @return 数量
     */
    int countActivePolicy(SysBizPermPolicy policy);
}
