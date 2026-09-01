package com.ruoyi.system.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * 数据字典字段信息对象 sys_data_dict_column（实时查询数据库系统视图，非物理表）
 *
 * @author ruoyi
 */
public class SysDataDictColumn
{
    /** 归属表名称（仅导出数据字典文档时填充） */
    @Excel(name = "表名称")
    private String tableName;

    /** 归属表描述（仅导出数据字典文档时填充） */
    @Excel(name = "表描述")
    private String tableComment;

    /** 字段名称 */
    @Excel(name = "字段名称")
    private String columnName;

    /** 字段描述 */
    @Excel(name = "字段描述")
    private String columnComment;

    /** 数据类型（如 varchar、numeric） */
    @Excel(name = "数据类型")
    private String dataType;

    /** 长度（字符型为长度，nvarchar/nchar 按字符数折算，-1 表示 MAX 类型） */
    @Excel(name = "长度")
    private Long dataLength;

    /** 小数精度（numeric/decimal 有效位数） */
    @Excel(name = "精度")
    private Long dataPrecision;

    /** 小数位数（numeric/decimal 标度） */
    @Excel(name = "小数位")
    private Long dataScale;

    /** 是否主键（Y是 N否） */
    @Excel(name = "主键", readConverterExp = "Y=是,N=否")
    private String isPk;

    /** 是否自增（Y是 N否） */
    @Excel(name = "自增", readConverterExp = "Y=是,N=否")
    private String isIncrement;

    /** 是否允许空（Y是 N否） */
    @Excel(name = "允许空", readConverterExp = "Y=是,N=否")
    private String isNullable;

    /** 默认值定义 */
    @Excel(name = "默认值")
    private String columnDefault;

    /** 排序号（字段在表中的物理顺序） */
    private Long sort;

    public String getTableName()
    {
        return tableName;
    }

    public void setTableName(String tableName)
    {
        this.tableName = tableName;
    }

    public String getTableComment()
    {
        return tableComment;
    }

    public void setTableComment(String tableComment)
    {
        this.tableComment = tableComment;
    }

    public String getColumnName()
    {
        return columnName;
    }

    public void setColumnName(String columnName)
    {
        this.columnName = columnName;
    }

    public String getColumnComment()
    {
        return columnComment;
    }

    public void setColumnComment(String columnComment)
    {
        this.columnComment = columnComment;
    }

    public String getDataType()
    {
        return dataType;
    }

    public void setDataType(String dataType)
    {
        this.dataType = dataType;
    }

    public Long getDataLength()
    {
        return dataLength;
    }

    public void setDataLength(Long dataLength)
    {
        this.dataLength = dataLength;
    }

    public Long getDataPrecision()
    {
        return dataPrecision;
    }

    public void setDataPrecision(Long dataPrecision)
    {
        this.dataPrecision = dataPrecision;
    }

    public Long getDataScale()
    {
        return dataScale;
    }

    public void setDataScale(Long dataScale)
    {
        this.dataScale = dataScale;
    }

    public String getIsPk()
    {
        return isPk;
    }

    public void setIsPk(String isPk)
    {
        this.isPk = isPk;
    }

    public String getIsIncrement()
    {
        return isIncrement;
    }

    public void setIsIncrement(String isIncrement)
    {
        this.isIncrement = isIncrement;
    }

    public String getIsNullable()
    {
        return isNullable;
    }

    public void setIsNullable(String isNullable)
    {
        this.isNullable = isNullable;
    }

    public String getColumnDefault()
    {
        return columnDefault;
    }

    public void setColumnDefault(String columnDefault)
    {
        this.columnDefault = columnDefault;
    }

    public Long getSort()
    {
        return sort;
    }

    public void setSort(Long sort)
    {
        this.sort = sort;
    }
}
