/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.bizperm.domain.bo.VisibleUsersQueryBo;
import com.ruoyi.bizperm.service.IBizPermQueryService;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;

/**
 * 业务权限对外接口Controller
 *
 * 供外部系统或后端服务按工号查询可见人员。
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
@RestController
@RequestMapping("/api/bizperm")
public class ApiBizPermController extends BaseController
{
    @Autowired
    private IBizPermQueryService bizPermQueryService;

    /**
     * 查询某人某场景下的可见人员
     *
     * @param query 查询参数
     * @return 可见人员
     */
    @GetMapping("/visible-users")
    public AjaxResult visibleUsers(VisibleUsersQueryBo query)
    {
        if (query == null || isEmpty(query.getPolicyCode()) || isEmpty(query.getUserCode()))
        {
            return AjaxResult.error(400, "参数不完整");
        }
        if (query.getPageSize() != null && query.getPageSize() > 200)
        {
            return AjaxResult.error(400, "分页大小超过上限");
        }
        if (!bizPermQueryService.existsPolicyScene(query.getPolicyCode()))
        {
            return AjaxResult.error(404, "业务权限场景不存在");
        }
        if (!bizPermQueryService.existsActiveUser(query.getUserCode()))
        {
            return AjaxResult.error(404, "人员不存在或已停用");
        }
        // 分页在 Service 层启动，避免 count 查询提前消费分页参数
        return success(bizPermQueryService.queryVisibleUsers(query));
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
