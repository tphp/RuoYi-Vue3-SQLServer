/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.service;

import java.util.List;
import com.ruoyi.bizperm.domain.bo.BizPermTreeChildrenQueryBo;
import com.ruoyi.bizperm.domain.bo.BizPermTreeQueryBo;
import com.ruoyi.bizperm.domain.vo.BizPermTreeNodeVo;
import com.ruoyi.bizperm.domain.vo.TreePageResult;

/**
 * 权限结构树服务
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public interface IBizPermTreeService
{
    /**
     * 查询权限结构树首屏节点
     *
     * @param query 查询参数
     * @return 首屏节点
     */
    List<BizPermTreeNodeVo> listTree(BizPermTreeQueryBo query);

    /**
     * 懒加载树节点子级
     *
     * @param query 节点与分页参数
     * @return 子节点及总数
     */
    TreePageResult<BizPermTreeNodeVo> listChildren(BizPermTreeChildrenQueryBo query);

    /**
     * 查询“我的权限”树
     *
     * @param userCode 当前登录人工号
     * @param query    查询参数
     * @return 我的权限节点
     */
    List<BizPermTreeNodeVo> listMyTree(String userCode, BizPermTreeQueryBo query);
}
