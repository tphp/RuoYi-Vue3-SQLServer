/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service.impl;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ruoyi.bizperm.domain.bo.BizPermTreeChildrenQueryBo;
import com.ruoyi.bizperm.domain.bo.BizPermTreeQueryBo;
import com.ruoyi.bizperm.domain.vo.BizPermSceneCountVo;
import com.ruoyi.bizperm.domain.vo.BizPermTreeNodeVo;
import com.ruoyi.bizperm.domain.vo.TreePageResult;
import com.ruoyi.bizperm.domain.vo.VisibleUserVo;
import com.ruoyi.bizperm.mapper.BizPermPolicyMapper;
import com.ruoyi.bizperm.service.IBizPermTreeService;

/**
 * 权限结构树服务实现
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@Service
public class BizPermTreeServiceImpl implements IBizPermTreeService
{
    /** 懒加载非员工层最大节点数 */
    private static final int MAX_NODE_SIZE = 200;

    @Autowired
    private BizPermPolicyMapper bizPermPolicyMapper;

    @Override
    public List<BizPermTreeNodeVo> listTree(BizPermTreeQueryBo query)
    {
        BizPermTreeQueryBo actual = query == null ? new BizPermTreeQueryBo() : query;
        normalizeDepth(actual);
        List<BizPermTreeNodeVo> owners = bizPermPolicyMapper.selectOwnerNodes(actual);
        if (owners == null || owners.isEmpty())
        {
            return new ArrayList<>();
        }
        if (actual.getDepth() < 2)
        {
            return owners;
        }

        // 批量加载场景，避免逐归属人查询
        Map<String, BizPermTreeNodeVo> ownerMap = indexByKey(owners);
        List<BizPermTreeNodeVo> scenes = bizPermPolicyMapper.selectSceneNodes(actual);
        List<BizPermTreeNodeVo> attachedScenes = new ArrayList<>();
        if (scenes != null)
        {
            for (BizPermTreeNodeVo scene : scenes)
            {
                BizPermTreeNodeVo owner = ownerMap.get(scene.getParentKey());
                if (owner != null)
                {
                    owner.getChildren().add(scene);
                    attachedScenes.add(scene);
                }
            }
        }
        markLeafIfNoChildren(owners);

        if (actual.getDepth() < 3)
        {
            return owners;
        }

        // depth=3 时批量加载部门与人员/岗位范围节点
        Map<String, BizPermTreeNodeVo> sceneMap = indexByKey(attachedScenes);
        List<BizPermTreeNodeVo> depthNodes = new ArrayList<>();
        List<BizPermTreeNodeVo> depts = bizPermPolicyMapper.selectDeptNodes(actual);
        List<BizPermTreeNodeVo> scopes = bizPermPolicyMapper.selectScopeNodes(actual);
        if (depts != null)
        {
            depthNodes.addAll(depts);
        }
        if (scopes != null)
        {
            depthNodes.addAll(scopes);
        }
        for (BizPermTreeNodeVo node : depthNodes)
        {
            BizPermTreeNodeVo scene = sceneMap.get(node.getParentKey());
            if (scene != null)
            {
                scene.getChildren().add(node);
            }
        }
        markLeafIfNoChildren(attachedScenes);

        if (Boolean.TRUE.equals(actual.getWithCount()))
        {
            fillSceneUserCount(actual, owners, attachedScenes);
        }
        return owners;
    }

    @Override
    public TreePageResult<BizPermTreeNodeVo> listChildren(BizPermTreeChildrenQueryBo query)
    {
        if (query == null || isEmpty(query.getNodeKey()) || isEmpty(query.getNodeType()))
        {
            return TreePageResult.empty();
        }
        String[] parts = parseNodeKey(query.getNodeType(), query.getNodeKey());
        if (parts == null)
        {
            return TreePageResult.empty();
        }

        if ("OWNER".equals(query.getNodeType()))
        {
            List<BizPermTreeNodeVo> scenes = bizPermPolicyMapper.selectSceneNodesByOwner(parts[1], parts[2]);
            return pageResult(scenes);
        }
        if ("SCENE".equals(query.getNodeType()))
        {
            List<BizPermTreeNodeVo> nodes = new ArrayList<>();
            List<BizPermTreeNodeVo> depts = bizPermPolicyMapper.selectDeptNodesByOwnerScene(parts[1], parts[2], parts[3]);
            List<BizPermTreeNodeVo> scopes = bizPermPolicyMapper.selectScopeNodesByOwnerScene(parts[1], parts[2], parts[3]);
            if (depts != null)
            {
                nodes.addAll(depts);
            }
            if (scopes != null)
            {
                nodes.addAll(scopes);
            }
            return pageResult(nodes);
        }
        if ("DEPT".equals(query.getNodeType()))
        {
            Long policyId = parseLong(parts[1]);
            if (policyId == null)
            {
                return TreePageResult.empty();
            }
            return employeePage(policyId, "DEPT", parts[2], query);
        }
        if ("SCOPE".equals(query.getNodeType()))
        {
            Long policyId = parseLong(parts[1]);
            if (policyId == null)
            {
                return TreePageResult.empty();
            }
            return employeePage(policyId, parts[2], parts[3], query);
        }
        return TreePageResult.empty();
    }

    @Override
    public List<BizPermTreeNodeVo> listMyTree(String userCode, BizPermTreeQueryBo query)
    {
        if (isEmpty(userCode))
        {
            return Collections.emptyList();
        }
        BizPermTreeQueryBo actual = query == null ? new BizPermTreeQueryBo() : query;
        // 我的权限只展示当前登录人作为归属人的启用策略，忽略前端传入的归属人
        actual.setOwnerUserCode(userCode);
        actual.setStatus("0");
        if (actual.getWithCount() == null)
        {
            actual.setWithCount(Boolean.TRUE);
        }
        return listTree(actual);
    }

    /**
     * 分页查询部门/范围下的员工并组装员工节点
     *
     * @param policyId 策略主键
     * @param scopeType 范围类型
     * @param scopeValue 范围值
     * @param query 懒加载参数
     * @return 员工节点分页结果
     */
    private TreePageResult<BizPermTreeNodeVo> employeePage(Long policyId, String scopeType, String scopeValue,
            BizPermTreeChildrenQueryBo query)
    {
        int pageNum = query.getPageNum() == null || query.getPageNum() < 1 ? 1 : query.getPageNum();
        int pageSize = query.getPageSize() == null || query.getPageSize() < 1 ? 50
                : Math.min(query.getPageSize(), MAX_NODE_SIZE);
        PageHelper.startPage(pageNum, pageSize);
        List<VisibleUserVo> users = bizPermPolicyMapper.selectEmployeePage(policyId, scopeType, scopeValue,
                query.getKeyword());
        if (users == null)
        {
            users = new ArrayList<>();
        }
        PageInfo<VisibleUserVo> pageInfo = new PageInfo<>(users);
        List<BizPermTreeNodeVo> nodes = new ArrayList<>(users.size());
        for (VisibleUserVo user : users)
        {
            nodes.add(toEmployeeNode(user, query.getNodeKey()));
        }
        return new TreePageResult<>(pageInfo.getTotal(), nodes);
    }

    /**
     * 组装员工节点
     *
     * @param user 员工
     * @param parentKey 父节点 key
     * @return 员工节点
     */
    private BizPermTreeNodeVo toEmployeeNode(VisibleUserVo user, String parentKey)
    {
        BizPermTreeNodeVo node = new BizPermTreeNodeVo();
        node.setNodeKey("EMP:" + user.getUserCode());
        node.setNodeType("EMPLOYEE");
        node.setParentKey(parentKey);
        node.setLabel(user.getNickName() + "（" + user.getUserCode() + "）");
        node.setCode(user.getUserCode());
        node.setHasChildren(Boolean.FALSE);
        node.setLeaf(Boolean.TRUE);
        node.setDisabled(Boolean.FALSE);
        node.getExtra().put("userCode", user.getUserCode());
        node.getExtra().put("nickName", user.getNickName());
        node.getExtra().put("deptId", user.getDeptId());
        node.getExtra().put("deptName", user.getDeptName());
        return node;
    }

    /**
     * 批量回填场景与归属人的可见人数（一次查询，避免 N+1）
     *
     * @param query 查询条件
     * @param owners 归属人节点
     * @param scenes 已挂载的场景节点
     */
    private void fillSceneUserCount(BizPermTreeQueryBo query, List<BizPermTreeNodeVo> owners,
            List<BizPermTreeNodeVo> scenes)
    {
        List<BizPermSceneCountVo> counts = bizPermPolicyMapper.selectSceneUserCounts(query);
        Map<String, Long> countMap = new HashMap<>();
        if (counts != null)
        {
            for (BizPermSceneCountVo count : counts)
            {
                String key = "SCENE:" + count.getSubjectType() + ":" + count.getSubjectValue() + ":"
                        + count.getPolicyCode();
                countMap.put(key, count.getUserCount());
            }
        }
        for (BizPermTreeNodeVo scene : scenes)
        {
            Long count = countMap.get(scene.getNodeKey());
            if (count != null)
            {
                scene.getExtra().put("userCount", count);
            }
        }
        for (BizPermTreeNodeVo owner : owners)
        {
            int deptCount = 0;
            long userCount = 0L;
            for (BizPermTreeNodeVo scene : owner.getChildren())
            {
                Object sceneCount = scene.getExtra().get("userCount");
                if (sceneCount instanceof Number)
                {
                    userCount += ((Number) sceneCount).longValue();
                }
                for (BizPermTreeNodeVo child : scene.getChildren())
                {
                    if ("DEPT".equals(child.getNodeType()))
                    {
                        deptCount++;
                    }
                }
            }
            owner.getExtra().put("policyCount", owner.getChildren().size());
            owner.getExtra().put("deptCount", deptCount);
            owner.getExtra().put("userCount", userCount);
        }
    }

    /**
     * 将节点列表转换为分页结果
     *
     * @param nodes 节点列表
     * @return 分页结果
     */
    private TreePageResult<BizPermTreeNodeVo> pageResult(List<BizPermTreeNodeVo> nodes)
    {
        if (nodes == null)
        {
            return TreePageResult.empty();
        }
        return new TreePageResult<>(nodes.size(), nodes);
    }

    /**
     * 按 nodeKey 建立索引
     *
     * @param nodes 节点列表
     * @return key -> 节点
     */
    private Map<String, BizPermTreeNodeVo> indexByKey(List<BizPermTreeNodeVo> nodes)
    {
        Map<String, BizPermTreeNodeVo> map = new HashMap<>();
        for (BizPermTreeNodeVo node : nodes)
        {
            map.put(node.getNodeKey(), node);
        }
        return map;
    }

    /**
     * 没有子节点的节点标记为叶子
     *
     * @param nodes 节点列表
     */
    private void markLeafIfNoChildren(List<BizPermTreeNodeVo> nodes)
    {
        for (BizPermTreeNodeVo node : nodes)
        {
            if (node.getChildren().isEmpty())
            {
                node.setLeaf(Boolean.TRUE);
                node.setHasChildren(Boolean.FALSE);
            }
        }
    }

    /**
     * 解析节点 key，并校验前缀与类型一致
     *
     * @param nodeType 节点类型
     * @param nodeKey 节点 key
     * @return 解析结果；非法返回 null
     */
    private String[] parseNodeKey(String nodeType, String nodeKey)
    {
        if ("OWNER".equals(nodeType))
        {
            String[] parts = nodeKey.split(":", 3);
            return parts.length == 3 && "OWNER".equals(parts[0]) ? parts : null;
        }
        if ("SCENE".equals(nodeType))
        {
            String[] parts = nodeKey.split(":", 4);
            return parts.length == 4 && "SCENE".equals(parts[0]) ? parts : null;
        }
        if ("DEPT".equals(nodeType))
        {
            String[] parts = nodeKey.split(":", 3);
            return parts.length == 3 && "DEPT".equals(parts[0]) ? parts : null;
        }
        if ("SCOPE".equals(nodeType))
        {
            String[] parts = nodeKey.split(":", 4);
            return parts.length == 4 && "SCOPE".equals(parts[0]) ? parts : null;
        }
        return null;
    }

    /**
     * 转换为 Long
     *
     * @param value 字符串
     * @return 数值；非法返回 null
     */
    private Long parseLong(String value)
    {
        try
        {
            return Long.valueOf(value);
        }
        catch (Exception e)
        {
            return null;
        }
    }

    /**
     * 规范化树层级，未指定时默认 3，限制在 1~3
     *
     * @param query 查询参数
     */
    private void normalizeDepth(BizPermTreeQueryBo query)
    {
        if (query.getDepth() == null || query.getDepth() < 1)
        {
            query.setDepth(3);
        }
        else if (query.getDepth() > 3)
        {
            query.setDepth(3);
        }
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
