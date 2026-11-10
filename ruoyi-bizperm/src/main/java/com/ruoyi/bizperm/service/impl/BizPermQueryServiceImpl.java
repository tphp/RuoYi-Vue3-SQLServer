/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service.impl;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.common.core.redis.RedisCache;
import com.ruoyi.bizperm.domain.bo.VisibleUsersQueryBo;
import com.ruoyi.bizperm.domain.vo.VisibleDeptGroupVo;
import com.ruoyi.bizperm.domain.vo.VisibleDeptUserVo;
import com.ruoyi.bizperm.domain.vo.VisibleUserVo;
import com.ruoyi.bizperm.domain.vo.VisibleUsersResultVo;
import com.ruoyi.bizperm.mapper.BizPermPolicyMapper;
import com.ruoyi.bizperm.service.IBizPermQueryService;

/**
 * 可见人员计算服务实现
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@Service
public class BizPermQueryServiceImpl implements IBizPermQueryService
{
    private static final Logger log = LoggerFactory.getLogger(BizPermQueryServiceImpl.class);

    /** 可见人员缓存 key 前缀：bizperm:visible:{policyCode}:{userCode} */
    private static final String CACHE_KEY_PREFIX = "bizperm:visible:";

    /** 可见人员缓存有效期（分钟） */
    private static final int CACHE_EXPIRE_MINUTES = 30;

    @Autowired
    private BizPermPolicyMapper bizPermPolicyMapper;

    @Autowired
    private RedisCache redisCache;

    /**
     * 计算某人在某场景下的可见人员工号集合（带 Redis 缓存）
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 去重后的工号集合；未配置时返回空集合
     */
    @Override
    public Set<String> getVisibleUserCodes(String policyCode, String userCode)
    {
        if (isEmpty(policyCode) || isEmpty(userCode))
        {
            return Collections.emptySet();
        }
        String cacheKey = buildCacheKey(policyCode, userCode);
        List<String> cached = readCache(cacheKey);
        if (cached != null)
        {
            return toUserCodeSet(cached);
        }
        List<String> userCodes = bizPermPolicyMapper.selectVisibleUserCodes(policyCode, userCode);
        if (userCodes == null)
        {
            userCodes = Collections.emptyList();
        }
        writeCache(cacheKey, userCodes);
        return toUserCodeSet(userCodes);
    }

    /**
     * 按业务场景清理可见人员缓存
     *
     * @param policyCode 业务场景编码
     */
    @Override
    public void evictVisibleUsers(String policyCode)
    {
        if (isEmpty(policyCode))
        {
            return;
        }
        try
        {
            Collection<String> keys = redisCache.keys(CACHE_KEY_PREFIX + policyCode + ":*");
            if (keys != null && !keys.isEmpty())
            {
                redisCache.deleteObject(keys);
            }
        }
        catch (Exception e)
        {
            // 缓存不可用时忽略，避免影响权限配置主流程
            log.warn("清理可见人员缓存失败, policyCode={}", policyCode, e);
        }
    }

    /**
     * 组装可见人员缓存 key
     *
     * @param policyCode 业务场景编码
     * @param userCode   权限归属人工号
     * @return 缓存 key
     */
    private String buildCacheKey(String policyCode, String userCode)
    {
        return CACHE_KEY_PREFIX + policyCode + ":" + userCode;
    }

    /**
     * 读取可见人员缓存
     *
     * @param cacheKey 缓存 key
     * @return 缓存值；未命中或缓存异常时返回 null
     */
    private List<String> readCache(String cacheKey)
    {
        try
        {
            List<String> cached = redisCache.getCacheObject(cacheKey);
            return cached;
        }
        catch (Exception e)
        {
            log.warn("读取可见人员缓存失败, key={}", cacheKey, e);
            return null;
        }
    }

    /**
     * 写入可见人员缓存
     *
     * @param cacheKey  缓存 key
     * @param userCodes 可见人员工号列表
     */
    private void writeCache(String cacheKey, List<String> userCodes)
    {
        try
        {
            redisCache.setCacheObject(cacheKey, userCodes, CACHE_EXPIRE_MINUTES, TimeUnit.MINUTES);
        }
        catch (Exception e)
        {
            log.warn("写入可见人员缓存失败, key={}", cacheKey, e);
        }
    }

    /**
     * 工号列表转换为去重集合
     *
     * @param userCodes 工号列表
     * @return 去重后的工号集合
     */
    private Set<String> toUserCodeSet(List<String> userCodes)
    {
        if (userCodes == null || userCodes.isEmpty())
        {
            return Collections.emptySet();
        }
        return new HashSet<>(userCodes);
    }

    @Override
    public VisibleUsersResultVo queryVisibleUsers(VisibleUsersQueryBo query)
    {
        VisibleUsersResultVo result = new VisibleUsersResultVo();
        if (query == null)
        {
            return result;
        }
        result.setPolicyCode(query.getPolicyCode());
        result.setUserCode(query.getUserCode());
        if (isEmpty(query.getPolicyCode()) || isEmpty(query.getUserCode()))
        {
            result.setTotal(0L);
            return result;
        }

        if (Boolean.TRUE.equals(query.getGroupByDept()))
        {
            result.setTotal(countVisibleUsers(query.getPolicyCode(), query.getUserCode()));
            result.setDepartments(queryDeptGroups(query));
            return result;
        }

        // 分页必须在真正的人员查询前启动，避免前面的 count 查询提前消费分页参数
        PageHelper.startPage(normalizePageNum(query.getPageNum()), normalizePageSize(query.getPageSize()));
        List<VisibleUserVo> users = bizPermPolicyMapper.selectVisibleUserPage(query.getPolicyCode(), query.getUserCode());
        if (users == null)
        {
            users = new ArrayList<>();
        }
        result.setTotal(new PageInfo<>(users).getTotal());
        List<String> userCodes = new ArrayList<>(users.size());
        for (VisibleUserVo user : users)
        {
            userCodes.add(user.getUserCode());
        }
        result.setUsers(users);
        result.setUserCodes(userCodes);
        return result;
    }

    @Override
    public long countVisibleUsers(String policyCode, String userCode)
    {
        if (isEmpty(policyCode) || isEmpty(userCode))
        {
            return 0L;
        }
        return bizPermPolicyMapper.countVisibleUsers(policyCode, userCode);
    }

    @Override
    public boolean existsActiveUser(String userCode)
    {
        if (isEmpty(userCode))
        {
            return false;
        }
        return bizPermPolicyMapper.countActiveUserByCode(userCode) > 0;
    }

    @Override
    public boolean existsPolicyScene(String policyCode)
    {
        if (isEmpty(policyCode))
        {
            return false;
        }
        return bizPermPolicyMapper.countSceneDict(policyCode) > 0;
    }

    /**
     * 查询按部门分组的可见人员（分页作用于员工总数）
     *
     * @param query 查询参数
     * @return 当前页命中的部门分组
     */
    private List<VisibleDeptGroupVo> queryDeptGroups(VisibleUsersQueryBo query)
    {
        int pageNum = normalizePageNum(query.getPageNum());
        int pageSize = normalizePageSize(query.getPageSize());
        int offset = (pageNum - 1) * pageSize;

        // 部门去重总数，用于回填 userCount
        List<VisibleDeptGroupVo> groups = bizPermPolicyMapper.selectVisibleDeptGroups(query.getPolicyCode(),
                query.getUserCode());
        Map<Long, VisibleDeptGroupVo> groupMap = new HashMap<>();
        if (groups != null)
        {
            for (VisibleDeptGroupVo group : groups)
            {
                groupMap.put(group.getDeptId(), group);
            }
        }

        List<VisibleDeptUserVo> rows = bizPermPolicyMapper.selectVisibleDeptUserPage(query.getPolicyCode(),
                query.getUserCode(), offset, pageSize);
        List<VisibleDeptGroupVo> result = new ArrayList<>();
        Map<Long, VisibleDeptGroupVo> pageGroupMap = new HashMap<>();
        if (rows != null)
        {
            for (VisibleDeptUserVo row : rows)
            {
                VisibleDeptGroupVo group = pageGroupMap.get(row.getGroupDeptId());
                if (group == null)
                {
                    group = groupMap.get(row.getGroupDeptId());
                    if (group == null)
                    {
                        group = new VisibleDeptGroupVo();
                        group.setDeptId(row.getGroupDeptId());
                        group.setDeptName(row.getGroupDeptName());
                        group.setIncludeChild(row.getIncludeChild());
                        group.setUserCount(0L);
                    }
                    group.setReturnedCount(0);
                    pageGroupMap.put(group.getDeptId(), group);
                    result.add(group);
                }
                group.getUsers().add(toUserVo(row));
                group.setReturnedCount(group.getReturnedCount() + 1);
            }
        }
        return result;
    }

    /**
     * 分组人员行转换为可见人员
     *
     * @param row 分组人员行
     * @return 可见人员
     */
    private VisibleUserVo toUserVo(VisibleDeptUserVo row)
    {
        VisibleUserVo user = new VisibleUserVo();
        user.setUserCode(row.getUserCode());
        user.setNickName(row.getNickName());
        user.setDeptId(row.getDeptId());
        user.setDeptName(row.getDeptName());
        return user;
    }

    /**
     * 规范化页码
     *
     * @param pageNum 页码
     * @return 有效页码，最小为 1
     */
    private int normalizePageNum(Integer pageNum)
    {
        return pageNum == null || pageNum < 1 ? 1 : pageNum;
    }

    /**
     * 规范化每页条数
     *
     * @param pageSize 每页条数
     * @return 有效每页条数，范围 1~200
     */
    private int normalizePageSize(Integer pageSize)
    {
        if (pageSize == null || pageSize < 1)
        {
            return 50;
        }
        return Math.min(pageSize, 200);
    }

    /**
     * 判断字符串是否为空
     *
     * @param value 字符串
     * @return true 为空
     */
    private boolean isEmpty(String value)
    {
        return value == null || value.trim().isEmpty();
    }
}
