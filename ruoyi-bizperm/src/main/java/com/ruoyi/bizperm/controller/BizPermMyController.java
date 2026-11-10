/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.bizperm.domain.bo.BizPermTreeQueryBo;
import com.ruoyi.bizperm.domain.bo.VisibleUsersQueryBo;
import com.ruoyi.bizperm.domain.vo.BizPermTreeNodeVo;
import com.ruoyi.bizperm.domain.vo.TreePageResult;
import com.ruoyi.bizperm.service.IBizPermQueryService;
import com.ruoyi.bizperm.service.IBizPermTreeService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.SecurityUtils;

/**
 * 我的权限Controller
 *
 * 仅允许当前登录人查看自己的权限结构与可见员工。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@RestController
@RequestMapping("/bizperm/my")
public class BizPermMyController extends BaseController
{
    @Autowired
    private IBizPermTreeService bizPermTreeService;

    @Autowired
    private IBizPermQueryService bizPermQueryService;

    /**
     * 查询我的权限树
     *
     * @param query 查询参数
     * @return 我的权限节点
     */
    @GetMapping("/tree")
    public AjaxResult tree(BizPermTreeQueryBo query)
    {
        String userCode = currentUserCode();
        if (userCode == null)
        {
            return AjaxResult.error(401, "登录状态已失效");
        }
        List<BizPermTreeNodeVo> nodes = bizPermTreeService.listMyTree(userCode, query);
        TreePageResult<BizPermTreeNodeVo> result = new TreePageResult<>(
                nodes == null ? 0L : nodes.size(), nodes);
        return success(result);
    }

    /**
     * 分页查询我的可见员工
     *
     * @param query 查询参数
     * @return 可见人员
     */
    @GetMapping("/visible-users")
    public AjaxResult visibleUsers(VisibleUsersQueryBo query)
    {
        String userCode = currentUserCode();
        if (userCode == null)
        {
            return AjaxResult.error(401, "登录状态已失效");
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
        // 分页在 Service 层启动，避免 count 查询提前消费分页参数
        return success(bizPermQueryService.queryVisibleUsers(query));
    }

    /**
     * 获取当前登录人工号
     *
     * @return 工号，未登录返回 null
     */
    private String currentUserCode()
    {
        try
        {
            String username = SecurityUtils.getUsername();
            return isEmpty(username) ? null : username;
        }
        catch (Exception e)
        {
            return null;
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
