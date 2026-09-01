package com.ruoyi.web.controller.system;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysDataDictColumn;
import com.ruoyi.system.domain.SysDataDictTable;
import com.ruoyi.system.service.ISysDataDictService;

/**
 * 数据字典（数据库表结构）查询
 *
 * 实时读取 SQL Server 系统视图，每开发一个新模块建表后，
 * 表结构、字段、类型、长度、主键、外键、索引等信息自动可查。
 *
 * @author ruoyi
 */
@RestController
@RequestMapping("/system/datadict")
public class SysDataDictController extends BaseController
{
    @Autowired
    private ISysDataDictService dataDictService;

    /**
     * 查询数据库表列表（分页，支持表名称、表描述模糊检索）
     *
     * @param dataDictTable 查询条件（表名称 tableName、表描述 tableComment）
     * @return 表信息分页数据
     */
    @PreAuthorize("@ss.hasPermi('system:datadict:list')")
    @GetMapping("/table/list")
    public TableDataInfo tableList(SysDataDictTable dataDictTable)
    {
        startPage();
        List<SysDataDictTable> list = dataDictService.selectDictTableList(dataDictTable);
        return getDataTable(list);
    }

    /**
     * 查询表结构详情（表基本信息 + 字段明细 + 外键 + 索引）
     *
     * @param tableName 表名称
     * @return 表结构详情（info：表信息；columns：字段；foreignKeys：外键；indexes：索引）
     */
    @PreAuthorize("@ss.hasPermi('system:datadict:query')")
    @GetMapping("/table/{tableName}")
    public AjaxResult tableInfo(@PathVariable String tableName)
    {
        Map<String, Object> map = new HashMap<>();
        map.put("info", dataDictService.selectDictTableByName(tableName));
        map.put("columns", dataDictService.selectDictColumnListByTableName(tableName));
        map.put("foreignKeys", dataDictService.selectDictForeignKeyListByTableName(tableName));
        map.put("indexes", dataDictService.selectDictIndexListByTableName(tableName));
        return success(map);
    }

    /**
     * 查询指定表的字段明细列表
     *
     * @param tableName 表名称
     * @return 字段信息集合（含类型、长度、精度、主键、自增、可空、默认值、注释）
     */
    @PreAuthorize("@ss.hasPermi('system:datadict:query')")
    @GetMapping("/column/list")
    public AjaxResult columnList(String tableName)
    {
        return success(dataDictService.selectDictColumnListByTableName(tableName));
    }

    /**
     * 导出数据字典文档（Excel）
     * tableNames 非空时仅导出指定表集合的字段明细（导出选中）；
     * tableNames 为空时按搜索条件导出全部匹配表（导出所有/全库）
     *
     * @param response HTTP 响应对象（用于写出文件流）
     * @param dataDictTable 查询条件（表名称 tableName、表描述 tableComment）
     * @param tableNames 表名称集合（逗号分隔，前端"导出选中"传入）
     */
    @Log(title = "数据字典", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:datadict:export')")
    @PostMapping("/table/export")
    public void export(HttpServletResponse response, SysDataDictTable dataDictTable, String tableNames)
    {
        List<String> tableNameList = StringUtils.isBlank(tableNames)
                ? new ArrayList<>() : Arrays.asList(StringUtils.split(tableNames, ","));
        List<SysDataDictColumn> list = dataDictService.selectDictColumnExportList(dataDictTable, tableNameList);
        ExcelUtil<SysDataDictColumn> util = new ExcelUtil<SysDataDictColumn>(SysDataDictColumn.class);
        util.exportExcel(response, list, "数据字典");
    }
}
