package com.ruoyi.system.domain;

/**
 * 数据字典外键信息对象 sys_data_dict_foreign_key（实时查询数据库系统视图，非物理表）
 *
 * @author ruoyi
 */
public class SysDataDictForeignKey
{
    /** 外键约束名称 */
    private String fkName;

    /** 当前表名称 */
    private String tableName;

    /** 当前表字段名称 */
    private String columnName;

    /** 引用表名称 */
    private String refTableName;

    /** 引用表字段名称 */
    private String refColumnName;

    public String getFkName()
    {
        return fkName;
    }

    public void setFkName(String fkName)
    {
        this.fkName = fkName;
    }

    public String getTableName()
    {
        return tableName;
    }

    public void setTableName(String tableName)
    {
        this.tableName = tableName;
    }

    public String getColumnName()
    {
        return columnName;
    }

    public void setColumnName(String columnName)
    {
        this.columnName = columnName;
    }

    public String getRefTableName()
    {
        return refTableName;
    }

    public void setRefTableName(String refTableName)
    {
        this.refTableName = refTableName;
    }

    public String getRefColumnName()
    {
        return refColumnName;
    }

    public void setRefColumnName(String refColumnName)
    {
        this.refColumnName = refColumnName;
    }
}
