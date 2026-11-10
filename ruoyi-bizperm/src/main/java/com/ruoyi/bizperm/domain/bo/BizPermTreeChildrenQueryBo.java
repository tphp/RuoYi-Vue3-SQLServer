/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.bo;

/**
 * 权限结构树懒加载参数
 *
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class BizPermTreeChildrenQueryBo
{
    /** 父节点 key */
    private String nodeKey;

    /** 父节点类型：OWNER / SCENE / DEPT / SCOPE */
    private String nodeType;

    /** 员工姓名/工号关键字 */
    private String keyword;

    /** 页码 */
    private Integer pageNum = 1;

    /** 每页条数 */
    private Integer pageSize = 50;

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

    public String getKeyword()
    {
        return keyword;
    }

    public void setKeyword(String keyword)
    {
        this.keyword = keyword;
    }

    public Integer getPageNum()
    {
        return pageNum;
    }

    public void setPageNum(Integer pageNum)
    {
        this.pageNum = pageNum;
    }

    public Integer getPageSize()
    {
        return pageSize;
    }

    public void setPageSize(Integer pageSize)
    {
        this.pageSize = pageSize;
    }
}
