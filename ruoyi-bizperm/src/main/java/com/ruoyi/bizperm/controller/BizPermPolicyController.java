/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.bizperm.domain.SysBizPermPolicy;
import com.ruoyi.bizperm.domain.bo.BizPermTreeChildrenQueryBo;
import com.ruoyi.bizperm.domain.bo.BizPermTreeQueryBo;
import com.ruoyi.bizperm.domain.bo.VisibleUsersQueryBo;
import com.ruoyi.bizperm.domain.vo.BizPermTreeNodeVo;
import com.ruoyi.bizperm.domain.vo.TreePageResult;
import com.ruoyi.bizperm.service.IBizPermPolicyService;
import com.ruoyi.bizperm.service.IBizPermQueryService;
import com.ruoyi.bizperm.service.IBizPermTreeService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;

/**
 * 业务权限结构树Controller
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@RestController
@RequestMapping("/bizperm/policy")
public class BizPermPolicyController extends BaseController
{
    @Autowired
    private IBizPermTreeService bizPermTreeService;

    @Autowired
    private IBizPermPolicyService bizPermPolicyService;

    @Autowired
    private IBizPermQueryService bizPermQueryService;

    /**
     * 查询策略列表
     *
     * @param query 查询条件
     * @return 策略分页列表
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysBizPermPolicy query)
    {
        startPage();
        List<SysBizPermPolicy> list = bizPermPolicyService.selectPolicyList(query);
        return getDataTable(list);
    }

    /**
     * 查询策略详情（含可见范围）
     *
     * @param id 策略主键
     * @return 策略
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:query')")
    @GetMapping("/{id}")
    public AjaxResult getInfo(@PathVariable Long id)
    {
        return success(bizPermPolicyService.selectPolicyById(id));
    }

    /**
     * 新增策略
     *
     * @param policy 策略
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:add')")
    @Log(title = "业务权限", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SysBizPermPolicy policy)
    {
        policy.setCreateBy(getUsername());
        return toAjax(bizPermPolicyService.insertPolicy(policy));
    }

    /**
     * 修改策略
     *
     * @param policy 策略
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:edit')")
    @Log(title = "业务权限", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SysBizPermPolicy policy)
    {
        policy.setUpdateBy(getUsername());
        return toAjax(bizPermPolicyService.updatePolicy(policy));
    }

    /**
     * 批量删除策略
     *
     * @param ids 策略主键集合
     * @return 操作结果
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:remove')")
    @Log(title = "业务权限", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@PathVariable Long[] ids)
    {
        return toAjax(bizPermPolicyService.deletePolicyByIds(ids));
    }

    /**
     * 查询权限结构树首屏
     *
     * @param query 查询参数
     * @return 首屏节点
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:list')")
    @GetMapping("/tree")
    public AjaxResult tree(BizPermTreeQueryBo query)
    {
        List<BizPermTreeNodeVo> nodes = bizPermTreeService.listTree(query);
        TreePageResult<BizPermTreeNodeVo> result = new TreePageResult<>(
                nodes == null ? 0L : nodes.size(), nodes);
        return success(result);
    }

    /**
     * 懒加载权限结构树子级
     *
     * @param query 节点与分页参数
     * @return 子节点
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:list')")
    @GetMapping("/tree/children")
    public AjaxResult children(BizPermTreeChildrenQueryBo query)
    {
        if (query == null || isEmpty(query.getNodeKey()) || isEmpty(query.getNodeType()))
        {
            return AjaxResult.error(400, "nodeKey 和 nodeType 不能为空");
        }
        if (!isValidNode(query.getNodeType(), query.getNodeKey()))
        {
            return AjaxResult.error(400, "nodeKey 与 nodeType 不匹配");
        }
        if (query.getPageSize() != null && query.getPageSize() > 200)
        {
            return AjaxResult.error(400, "分页大小超过上限");
        }
        return success(bizPermTreeService.listChildren(query));
    }

    /**
     * 查询指定员工的权限树
     *
     * @param userCode 员工工号
     * @param query 查询参数
     * @return 权限节点
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:query')")
    @GetMapping("/user/tree")
    public AjaxResult userTree(@RequestParam("userCode") String userCode, BizPermTreeQueryBo query)
    {
        if (isEmpty(userCode))
        {
            return AjaxResult.error(400, "userCode 不能为空");
        }
        if (!bizPermQueryService.existsActiveUser(userCode))
        {
            return AjaxResult.error(404, "人员不存在或已停用");
        }
        List<BizPermTreeNodeVo> nodes = bizPermTreeService.listMyTree(userCode, query);
        TreePageResult<BizPermTreeNodeVo> result = new TreePageResult<>(
                nodes == null ? 0L : nodes.size(), nodes);
        return success(result);
    }

    /**
     * 分页查询指定员工的可见员工
     *
     * @param userCode 员工工号
     * @param query 查询参数
     * @return 可见人员
     */
    @PreAuthorize("@ss.hasPermi('bizperm:policy:query')")
    @GetMapping("/user/visible-users")
    public AjaxResult userVisibleUsers(@RequestParam("userCode") String userCode, VisibleUsersQueryBo query)
    {
        if (isEmpty(userCode))
        {
            return AjaxResult.error(400, "userCode 不能为空");
        }
        if (!bizPermQueryService.existsActiveUser(userCode))
        {
            return AjaxResult.error(404, "人员不存在或已停用");
        }
        if (query == null || isEmpty(query.getPolicyCode()))
        {
            return AjaxResult.error(400, "policyCode 不能为空");
        }
        if (query.getPageSize() != null && query.getPageSize() > 200)
        {
            return AjaxResult.error(400, "分页大小超过上限");
        }
        query.setUserCode(userCode);
        return success(bizPermQueryService.queryVisibleUsers(query));
    }

    /**
     * 校验节点类型与 key 前缀是否匹配
     *
     * @param nodeType 节点类型
     * @param nodeKey 节点 key
     * @return true 合法
     */
    private boolean isValidNode(String nodeType, String nodeKey)
    {
        if (!"OWNER".equals(nodeType) && !"SCENE".equals(nodeType)
                && !"DEPT".equals(nodeType) && !"SCOPE".equals(nodeType))
        {
            return false;
        }
        return nodeKey.startsWith(nodeType + ":");
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
