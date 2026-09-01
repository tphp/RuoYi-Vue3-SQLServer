package com.ruoyi.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.domain.SysDataDictColumn;
import com.ruoyi.system.domain.SysDataDictForeignKey;
import com.ruoyi.system.domain.SysDataDictIndex;
import com.ruoyi.system.domain.SysDataDictTable;
import com.ruoyi.system.mapper.SysDataDictMapper;
import com.ruoyi.system.service.ISysDataDictService;

/**
 * 数据字典 服务层实现
 *
 * 直接读取 SQL Server 系统视图，每开发一个新模块建表后字典自动可见，无需同步维护。
 *
 * @author ruoyi
 */
@Service
public class SysDataDictServiceImpl implements ISysDataDictService
{
    @Autowired
    private SysDataDictMapper dataDictMapper;

    /**
     * 查询数据库表列表（支持表名称、表描述模糊检索）
     *
     * @param dataDictTable 查询条件（表名称、表描述）
     * @return 表信息集合
     */
    @Override
    public List<SysDataDictTable> selectDictTableList(SysDataDictTable dataDictTable)
    {
        return dataDictMapper.selectDictTableList(dataDictTable);
    }

    /**
     * 根据表名称查询表基本信息
     *
     * @param tableName 表名称
     * @return 表信息
     */
    @Override
    public SysDataDictTable selectDictTableByName(String tableName)
    {
        return dataDictMapper.selectDictTableByName(tableName);
    }

    /**
     * 根据表名称查询字段明细（含类型、长度、精度、主键、自增、可空、默认值、注释）
     *
     * @param tableName 表名称
     * @return 字段信息集合
     */
    @Override
    public List<SysDataDictColumn> selectDictColumnListByTableName(String tableName)
    {
        return dataDictMapper.selectDictColumnListByTableName(tableName);
    }

    /**
     * 根据表名称查询外键明细（含外键约束名、引用表、引用字段）
     *
     * @param tableName 表名称（查询该表作为子表或父表的全部外键）
     * @return 外键信息集合
     */
    @Override
    public List<SysDataDictForeignKey> selectDictForeignKeyListByTableName(String tableName)
    {
        return dataDictMapper.selectDictForeignKeyListByTableName(tableName);
    }

    /**
     * 根据表名称查询索引明细（含索引类型、是否主键/唯一、索引字段）
     *
     * @param tableName 表名称
     * @return 索引信息集合
     */
    @Override
    public List<SysDataDictIndex> selectDictIndexListByTableName(String tableName)
    {
        return dataDictMapper.selectDictIndexListByTableName(tableName);
    }

    /**
     * 查询指定表集合（或按条件筛选）的字段明细，用于导出数据字典文档
     *
     * @param dataDictTable 查询条件（表名称、表描述）
     * @param tableNames 表名称集合（非空时仅导出这些表的字段明细）
     * @return 带归属表信息的字段明细集合
     */
    @Override
    public List<SysDataDictColumn> selectDictColumnExportList(SysDataDictTable dataDictTable, List<String> tableNames)
    {
        return dataDictMapper.selectDictColumnExportList(dataDictTable, tableNames);
    }
}
