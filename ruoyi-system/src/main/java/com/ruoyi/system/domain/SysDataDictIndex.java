package com.ruoyi.system.domain;

/**
 * 数据字典索引信息对象 sys_data_dict_index（实时查询数据库系统视图，非物理表）
 *
 * @author ruoyi
 */
public class SysDataDictIndex
{
    /** 索引名称 */
    private String indexName;

    /** 索引类型（CLUSTERED 聚集索引 / NONCLUSTERED 非聚集索引） */
    private String indexType;

    /** 是否主键索引（Y是 N否） */
    private String isPk;

    /** 是否唯一索引（Y是 N否） */
    private String isUnique;

    /** 索引包含字段（逗号分隔，按索引键顺序） */
    private String indexColumns;

    public String getIndexName()
    {
        return indexName;
    }

    public void setIndexName(String indexName)
    {
        this.indexName = indexName;
    }

    public String getIndexType()
    {
        return indexType;
    }

    public void setIndexType(String indexType)
    {
        this.indexType = indexType;
    }

    public String getIsPk()
    {
        return isPk;
    }

    public void setIsPk(String isPk)
    {
        this.isPk = isPk;
    }

    public String getIsUnique()
    {
        return isUnique;
    }

    public void setIsUnique(String isUnique)
    {
        this.isUnique = isUnique;
    }

    public String getIndexColumns()
    {
        return indexColumns;
    }

    public void setIndexColumns(String indexColumns)
    {
        this.indexColumns = indexColumns;
    }
}
