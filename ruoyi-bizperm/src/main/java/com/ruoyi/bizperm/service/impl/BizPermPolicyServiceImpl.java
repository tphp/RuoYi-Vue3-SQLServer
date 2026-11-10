/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionSynchronization;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import com.ruoyi.bizperm.domain.SysBizPermPolicy;
import com.ruoyi.bizperm.domain.SysBizPermScope;
import com.ruoyi.bizperm.mapper.BizPermPolicyMapper;
import com.ruoyi.bizperm.service.IBizPermPolicyService;
import com.ruoyi.bizperm.service.IBizPermQueryService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;

/**
 * 业务权限策略服务实现
 *
 * 所有写操作在事务提交后统一清理可见人员缓存，避免事务未提交时被回填脏数据。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@Service
public class BizPermPolicyServiceImpl implements IBizPermPolicyService
{
    /** 启用状态 */
    private static final String STATUS_ACTIVE = "0";

    /** 默认状态：启用 */
    private static final String STATUS_DEFAULT = "0";

    /** 是否含下级：否 */
    private static final String INCLUDE_CHILD_NO = "0";

    @Autowired
    private BizPermPolicyMapper bizPermPolicyMapper;

    @Autowired
    private IBizPermQueryService bizPermQueryService;

    @Override
    public List<SysBizPermPolicy> selectPolicyList(SysBizPermPolicy query)
    {
        if (query == null)
        {
            query = new SysBizPermPolicy();
        }
        return bizPermPolicyMapper.selectPolicyList(query);
    }

    @Override
    public SysBizPermPolicy selectPolicyById(Long id)
    {
        if (id == null)
        {
            return null;
        }
        SysBizPermPolicy policy = bizPermPolicyMapper.selectPolicyById(id);
        if (policy == null)
        {
            return null;
        }
        policy.setScopes(bizPermPolicyMapper.selectScopesByPolicyIds(Collections.singletonList(id)));
        return policy;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int insertPolicy(SysBizPermPolicy policy)
    {
        validatePolicy(policy, true);
        int rows = bizPermPolicyMapper.insertPolicy(policy);
        saveScopes(policy);
        evictVisibleUsersAfterCommit(Collections.singleton(policy.getPolicyCode()));
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int updatePolicy(SysBizPermPolicy policy)
    {
        validatePolicy(policy, false);
        SysBizPermPolicy exists = bizPermPolicyMapper.selectPolicyById(policy.getId());
        if (exists == null)
        {
            throw new ServiceException("权限策略不存在");
        }
        int rows = bizPermPolicyMapper.updatePolicy(policy);
        // scopes 为 null 表示本次不调整可见范围，仅修改策略主体信息
        if (policy.getScopes() != null)
        {
            bizPermPolicyMapper.deleteScopesByPolicyIds(new Long[] { policy.getId() });
            saveScopes(policy);
        }
        // 场景编码可能被修改，旧场景与新场景的缓存都要失效
        Set<String> policyCodes = new LinkedHashSet<>();
        policyCodes.add(exists.getPolicyCode());
        policyCodes.add(policy.getPolicyCode());
        evictVisibleUsersAfterCommit(policyCodes);
        return rows;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int deletePolicyByIds(Long[] ids)
    {
        if (ids == null || ids.length == 0)
        {
            return 0;
        }
        List<String> policyCodes = bizPermPolicyMapper.selectPolicyCodesByIds(ids);
        bizPermPolicyMapper.deleteScopesByPolicyIds(ids);
        int rows = bizPermPolicyMapper.deletePolicyByIds(ids);
        evictVisibleUsersAfterCommit(policyCodes);
        return rows;
    }

    /**
     * 校验策略必填项与唯一性
     *
     * @param policy   策略
     * @param isInsert 是否新增
     */
    private void validatePolicy(SysBizPermPolicy policy, boolean isInsert)
    {
        if (policy == null)
        {
            throw new ServiceException("权限策略不能为空");
        }
        if (isInsert && policy.getId() != null)
        {
            policy.setId(null);
        }
        if (!isInsert && policy.getId() == null)
        {
            throw new ServiceException("权限策略主键不能为空");
        }
        if (StringUtils.isEmpty(policy.getPolicyCode()))
        {
            throw new ServiceException("业务场景编码不能为空");
        }
        if (StringUtils.isEmpty(policy.getPolicyName()))
        {
            throw new ServiceException("业务场景名称不能为空");
        }
        if (StringUtils.isEmpty(policy.getSubjectType()))
        {
            throw new ServiceException("权限归属人类型不能为空");
        }
        if (StringUtils.isEmpty(policy.getSubjectValue()))
        {
            throw new ServiceException("权限归属人不能为空");
        }
        if (StringUtils.isEmpty(policy.getStatus()))
        {
            policy.setStatus(STATUS_DEFAULT);
        }
        if (StringUtils.isEmpty(policy.getIncludeChild()))
        {
            policy.setIncludeChild(INCLUDE_CHILD_NO);
        }
        // 唯一索引仅约束启用记录，停用记录不参与冲突判断
        if (STATUS_ACTIVE.equals(policy.getStatus())
                && bizPermPolicyMapper.countActivePolicy(policy) > 0)
        {
            throw new ServiceException("该业务场景下该权限归属人已存在启用中的策略");
        }
    }

    /**
     * 保存策略的可见范围明细
     *
     * @param policy 策略
     */
    private void saveScopes(SysBizPermPolicy policy)
    {
        List<SysBizPermScope> scopes = policy.getScopes();
        if (scopes == null || scopes.isEmpty())
        {
            return;
        }
        List<SysBizPermScope> rows = new ArrayList<>(scopes.size());
        int orderNum = 0;
        for (SysBizPermScope scope : scopes)
        {
            if (scope == null || StringUtils.isEmpty(scope.getScopeType())
                    || StringUtils.isEmpty(scope.getScopeValue()))
            {
                throw new ServiceException("可见范围类型和范围值不能为空");
            }
            scope.setPolicyId(policy.getId());
            if (StringUtils.isEmpty(scope.getIncludeChild()))
            {
                scope.setIncludeChild(INCLUDE_CHILD_NO);
            }
            if (scope.getOrderNum() == null)
            {
                scope.setOrderNum(orderNum);
            }
            if (StringUtils.isEmpty(scope.getCreateBy()))
            {
                scope.setCreateBy(policy.getCreateBy());
            }
            orderNum++;
            rows.add(scope);
        }
        bizPermPolicyMapper.insertScopes(rows);
    }

    /**
     * 事务提交后清理可见人员缓存，保证缓存及时失效
     *
     * @param policyCodes 业务场景编码集合
     */
    private void evictVisibleUsersAfterCommit(Collection<String> policyCodes)
    {
        if (policyCodes == null || policyCodes.isEmpty())
        {
            return;
        }
        final List<String> codes = new ArrayList<>();
        for (String policyCode : policyCodes)
        {
            if (!StringUtils.isEmpty(policyCode))
            {
                codes.add(policyCode);
            }
        }
        if (codes.isEmpty())
        {
            return;
        }
        if (TransactionSynchronizationManager.isSynchronizationActive())
        {
            TransactionSynchronizationManager.registerSynchronization(new TransactionSynchronization()
            {
                @Override
                public void afterCommit()
                {
                    codes.forEach(bizPermQueryService::evictVisibleUsers);
                }
            });
            return;
        }
        codes.forEach(bizPermQueryService::evictVisibleUsers);
    }
}
