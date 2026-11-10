/**
 * @author Zhang zhan
 * @date 2026-11-03
 */
package com.ruoyi.bizperm.domain.vo;

import java.util.ArrayList;
import java.util.List;

/**
 * 树节点分页结果
 *
 * @param <T> 节点类型
 * @author Zhang zhan
 * @date 2026-11-03
 */
public class TreePageResult<T>
{
    /** 子节点总数 */
    private long total;

    /** 当前页节点 */
    private List<T> nodes = new ArrayList<>();

    public TreePageResult()
    {
    }

    public TreePageResult(long total, List<T> nodes)
    {
        this.total = total;
        this.nodes = nodes;
    }

    /**
     * 构造空结果
     *
     * @param <T> 节点类型
     * @return 空结果
     */
    public static <T> TreePageResult<T> empty()
    {
        return new TreePageResult<>(0L, new ArrayList<>());
    }

    public long getTotal()
    {
        return total;
    }

    public void setTotal(long total)
    {
        this.total = total;
    }

    public List<T> getNodes()
    {
        return nodes;
    }

    public void setNodes(List<T> nodes)
    {
        this.nodes = nodes;
    }
}
