/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 权限结构树节点
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class BizPermTreeNodeVo
{
    /** 节点唯一标识 */
    private String nodeKey;

    /** 节点类型：OWNER / SCENE / DEPT / SCOPE / EMPLOYEE */
    private String nodeType;

    /** 父节点标识 */
    private String parentKey;

    /** 显示名称 */
    private String label;

    /** 业务编码：工号 / 场景编码 / 部门ID */
    private String code;

    /** 是否还有子节点 */
    private Boolean hasChildren;

    /** 是否叶子节点 */
    private Boolean leaf;

    /** 是否停用 */
    private Boolean disabled;

    /** 扩展字段 */
    private Map<String, Object> extra = new HashMap<>();

    /** 子节点（首屏按 depth 组装，懒加载时为空） */
    private List<BizPermTreeNodeVo> children = new ArrayList<>();

    public String getNodeKey()
    {
        return nodeKey;
    }

    public void setNodeKey(String nodeKey)
    {
        this.nodeKey = nodeKey;
    }

    public String getNodeType()
    {
        return nodeType;
    }

    public void setNodeType(String nodeType)
    {
        this.nodeType = nodeType;
    }

    public String getParentKey()
    {
        return parentKey;
    }

    public void setParentKey(String parentKey)
    {
        this.parentKey = parentKey;
    }

    public String getLabel()
    {
        return label;
    }

    public void setLabel(String label)
    {
        this.label = label;
    }

    public String getCode()
    {
        return code;
    }

    public void setCode(String code)
    {
        this.code = code;
    }

    public Boolean getHasChildren()
    {
        return hasChildren;
    }

    public void setHasChildren(Boolean hasChildren)
    {
        this.hasChildren = hasChildren;
    }

    public Boolean getLeaf()
    {
        return leaf;
    }

    public void setLeaf(Boolean leaf)
    {
        this.leaf = leaf;
    }

    public Boolean getDisabled()
    {
        return disabled;
    }

    public void setDisabled(Boolean disabled)
    {
        this.disabled = disabled;
    }

    public Map<String, Object> getExtra()
    {
        return extra;
    }

    public void setExtra(Map<String, Object> extra)
    {
        this.extra = extra;
    }

    public List<BizPermTreeNodeVo> getChildren()
    {
        return children;
    }

    public void setChildren(List<BizPermTreeNodeVo> children)
    {
        this.children = children;
    }
}
