package com.ruoyi.web.controller.sales;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.DataSource;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.DataSourceType;

/**
 * Oracle 数据源连通性测试
 *
 * 用于验证多数据源切换、Oracle 连接、JdbcTemplate 查询是否正常。
 * 测试前请确保 application-druid.yml 中 oracle.enabled=true 且连接信息正确。
 *
 * @author smc
 * @date 2026-08-20
 */
@RestController
@RequestMapping("/sales/oracle")
public class OracleTestController extends BaseController
{
    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 连通性测试：查询 Oracle 版本、当前库名、服务器时间
     * 调用示例：GET /sales/oracle/ping
     */
    @PreAuthorize("@ss.hasRole('sales')")
    @DataSource(DataSourceType.ORACLE)
    @GetMapping("/ping")
    public AjaxResult ping()
    {
        // 从 v$version 取 Oracle 版本，从 dual 取当前库名和服务器时间
        String sql = "SELECT b.banner AS version, "
                + "SYS_CONTEXT('USERENV','DB_NAME') AS db_name, "
                + "TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') AS server_time "
                + "FROM v$version b WHERE ROWNUM = 1 AND b.banner LIKE 'Oracle%'";
        Map<String, Object> info;
        try
        {
            info = jdbcTemplate.queryForMap(sql);
        }
        catch (Exception e)
        {
            info = new HashMap<>();
            info.put("connected", false);
            info.put("error", e.getMessage());
            return AjaxResult.error("Oracle 连接失败：" + e.getMessage(), info);
        }
        info.put("connected", true);
        return success(info);
    }

    /**
     * 指定业务表查询：返回该表前 10 条数据
     * 调用示例：GET /sales/oracle/list?table=CUSTOMER
     *
     * @param table 表名（只允许字母/数字/下划线，防止 SQL 注入）
     */
    @PreAuthorize("@ss.hasRole('sales')")
    @DataSource(DataSourceType.ORACLE)
    @GetMapping("/list")
    public AjaxResult list(@RequestParam("table") String table)
    {
        // 表名白名单校验：只能字母/数字/下划线，且必须字母开头
        if (!table.matches("^[a-zA-Z][a-zA-Z0-9_]*$"))
        {
            return AjaxResult.error("表名非法，只允许字母开头、字母/数字/下划线组合：" + table);
        }
        // Oracle 用 ROWNUM 限制行数（不能用 LIMIT）
        String sql = "SELECT * FROM (SELECT * FROM " + table + ") WHERE ROWNUM <= 10";
        List<Map<String, Object>> rows;
        try
        {
            rows = jdbcTemplate.queryForList(sql);
        }
        catch (Exception e)
        {
            Map<String, Object> err = new HashMap<>();
            err.put("table", table);
            err.put("error", e.getMessage());
            return AjaxResult.error("查询表 " + table + " 失败：" + e.getMessage(), err);
        }
        Map<String, Object> data = new HashMap<>();
        data.put("table", table);
        data.put("rowCount", rows.size());
        data.put("rows", rows);
        return success(data);
    }
}
