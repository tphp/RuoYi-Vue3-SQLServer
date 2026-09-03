package com.ruoyi.quartz.task;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SysCommonApi;
import com.ruoyi.system.domain.SysUserRole;
import com.ruoyi.system.mapper.SysDeptMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.mapper.SysUserRoleMapper;
import com.ruoyi.system.service.ISysCommonApiService;

/**
 * 组织架构数据同步定时任务
 * 
 * <p>从通用接口 get_dept_info 同步部门、get_user_info 同步用户到 RuoYi 系统。</p>
 * 
 * <p>RuoYi 定时任务配置示例：</p>
 * <ul>
 *   <li>调用目标字符串: syncOrgTask.syncDept()</li>
 *   <li>调用目标字符串: syncOrgTask.syncUser()</li>
 * </ul>
 */
@Component("syncOrgTask")
public class SyncOrgTask
{
    private static final Logger log = LoggerFactory.getLogger(SyncOrgTask.class);

    /** 通用接口关键字 */
    public static final String API_KEY_DEPT = "get_dept_info";
    public static final String API_KEY_USER = "get_user_info";

    /** 同步创建人标识 */
    private static final String SYNC_BY = "system_sync";

    /** 默认根部门 parentId */
    private static final Long ROOT_PARENT_ID = 0L;

    /** 人员同步时默认分配的角色ID：common(普通用户) = 2 */
    private static final Long DEFAULT_COMMON_ROLE_ID = 2L;

    private final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(15))
            .followRedirects(HttpClient.Redirect.NORMAL)
            .build();

    @Autowired
    private ISysCommonApiService commonApiService;

    @Autowired
    private SysDeptMapper deptMapper;

    @Autowired
    private SysUserMapper userMapper;

    @Autowired
    private SysUserRoleMapper userRoleMapper;

    // ========================================================================
    //  部门同步
    // ========================================================================

    /**
     * 同步部门数据（upsert）
     * <p>从 get_dept_info 接口获取部门列表，按层级顺序写入 sys_dept 表。</p>
     * <p>已存在 → 更新（部门名称、父级、ancestors）；不存在 → 新增。</p>
     */
    public void syncDept()
    {
        log.info("========== 开始同步部门数据 ==========");
        try
        {
            JSONObject resp = callApi(API_KEY_DEPT, null);
            if (resp == null)
            {
                log.warn("[syncDept] 接口无响应，跳过");
                return;
            }
            int code = resp.getIntValue("code");
            if (code != 1)
            {
                log.warn("[syncDept] 接口返回 code={}, msg={}", code, resp.getString("msg"));
                return;
            }
            JSONArray data = resp.getJSONArray("data");
            if (data == null || data.isEmpty())
            {
                log.info("[syncDept] 无部门数据");
                return;
            }

            // 1. 解析接口数据: externalId -> JSONObject
            Map<String, JSONObject> externalDeptMap = new LinkedHashMap<>();
            for (int i = 0; i < data.size(); i++)
            {
                JSONObject item = data.getJSONObject(i);
                if (item == null) continue;
                String extId = item.getString("id");
                if (StringUtils.isEmpty(extId)) continue;
                externalDeptMap.put(extId, item);
            }
            log.info("[syncDept] 接口返回部门 {} 条", externalDeptMap.size());

            // 2. 预加载现有所有部门（name → 第一个匹配的 SysDept），用于 upsert 匹配
            List<SysDept> allExisting = deptMapper.selectDeptListAll(new SysDept());
            Map<String, SysDept> existingByName = new HashMap<>();
            for (SysDept d : allExisting)
            {
                existingByName.putIfAbsent(d.getDeptName(), d);
            }

            // 3. 外部ID → RuoYi deptId 映射
            Map<String, Long> extIdToRuoYiId = new HashMap<>();
            Map<String, Boolean> processed = new HashMap<>();

            // 4. 循环分层处理
            int round = 0;
            int totalInserted = 0;
            int totalUpdated = 0;
            while (processed.size() < externalDeptMap.size() && round < 20)
            {
                round++;
                int roundChange = 0;
                for (Map.Entry<String, JSONObject> entry : externalDeptMap.entrySet())
                {
                    String extId = entry.getKey();
                    if (processed.containsKey(extId)) continue;

                    JSONObject item = entry.getValue();
                    String fdname = item.getString("fdname");
                    String parentid = item.getString("parentid");

                    // 确定 parentId / ancestors
                    Long parentId;
                    String ancestors;
                    if (StringUtils.isEmpty(parentid) || !externalDeptMap.containsKey(parentid))
                    {
                        parentId = ROOT_PARENT_ID;
                        ancestors = "0";
                    }
                    else if (processed.containsKey(parentid))
                    {
                        Long ruoyiParentId = extIdToRuoYiId.get(parentid);
                        SysDept parentDept = deptMapper.selectDeptById(ruoyiParentId);
                        if (parentDept == null)
                        {
                            parentId = ROOT_PARENT_ID;
                            ancestors = "0";
                        }
                        else
                        {
                            parentId = parentDept.getDeptId();
                            ancestors = parentDept.getAncestors() + "," + parentDept.getDeptId();
                        }
                    }
                    else
                    {
                        continue; // 父部门还没处理，等下一轮
                    }

                    // 优先按 name+parentId 精确匹配；没找到再按 name 找同级已有的
                    SysDept existing = deptMapper.checkDeptNameUnique(fdname, parentId);
                    if (existing == null)
                    {
                        existing = existingByName.get(fdname);
                    }

                    if (existing != null)
                    {
                        // === 已存在 → 更新 ===
                        boolean needUpdate = false;
                        SysDept update = new SysDept();
                        update.setDeptId(existing.getDeptId());
                        update.setDeptName(fdname);
                        update.setUpdateBy(SYNC_BY);

                        // 父级变化才更新 parentId / ancestors
                        boolean parentChanged = !parentId.equals(existing.getParentId());
                        if (parentChanged)
                        {
                            update.setParentId(parentId);
                            update.setAncestors(ancestors);
                            needUpdate = true;
                            log.info("[syncDept] 部门 [{}] 父级变更: {} → {}", fdname, existing.getParentId(), parentId);
                        }

                        // 名称变化（理论上精确匹配时名称相同，但模糊匹配时可能不同）
                        if (!fdname.equals(existing.getDeptName()))
                        {
                            needUpdate = true;
                        }

                        if (needUpdate)
                        {
                            // updateDept 内部会校验父节点状态和重算子节点 ancestors
                            // 直接用 mapper.updateDept 避免 Service 层额外的 selectDeptById 对刚处理的父节点的问题
                            deptMapper.updateDept(update);
                            totalUpdated++;
                            log.info("[syncDept] 更新部门: {} → deptId={}, parentId={}, ancestors={}",
                                    fdname, existing.getDeptId(), parentId, ancestors);
                        }
                        else
                        {
                            log.info("[syncDept] 部门无变化，跳过: {} (deptId={})", fdname, existing.getDeptId());
                        }

                        extIdToRuoYiId.put(extId, existing.getDeptId());
                        processed.put(extId, true);
                        roundChange++;
                    }
                    else
                    {
                        // === 不存在 → 新增 ===
                        SysDept dept = new SysDept();
                        dept.setParentId(parentId);
                        dept.setDeptName(fdname);
                        dept.setAncestors(ancestors);
                        dept.setOrderNum(0);
                        dept.setStatus("0");
                        dept.setDelFlag("0");
                        dept.setCreateBy(SYNC_BY);

                        deptMapper.insertDept(dept);
                        // 同时更新 existingByName 缓存，后续同批次匹配可用
                        existingByName.put(fdname, dept);
                        extIdToRuoYiId.put(extId, dept.getDeptId());
                        processed.put(extId, true);
                        roundChange++;
                        totalInserted++;
                        log.info("[syncDept] 新增部门: {} → deptId={}, parentId={}, ancestors={}",
                                fdname, dept.getDeptId(), parentId, ancestors);
                    }
                }
                log.info("[syncDept] 第 {} 轮: 处理 {} 条, 累计 {}/{}",
                        round, roundChange, processed.size(), externalDeptMap.size());
                if (roundChange == 0) break;
            }

            if (processed.size() < externalDeptMap.size())
            {
                log.warn("[syncDept] 有 {} 条部门未能处理（可能存在循环引用或父节点不在数据集中）",
                        externalDeptMap.size() - processed.size());
            }

            log.info("========== 部门同步完成: 新增 {} 条, 更新 {} 条 ==========", totalInserted, totalUpdated);
        }
        catch (Exception e)
        {
            log.error("[syncDept] 同步部门异常", e);
        }
    }

    // ========================================================================
    //  用户同步
    // ========================================================================

    /**
     * 同步用户数据
     * <p>从 get_user_info 接口获取用户列表，按 usercode 作为登录账号写入 sys_user。</p>
     * <p>幂等：已存在用户则更新基本信息（密码不变），不存在则新增（默认密码 123456）。</p>
     */
    public void syncUser()
    {
        log.info("========== 开始同步用户数据 ==========");
        try
        {
            JSONObject resp = callApi(API_KEY_USER, null);
            if (resp == null)
            {
                log.warn("[syncUser] 接口无响应，跳过");
                return;
            }
            int code = resp.getIntValue("code");
            if (code != 1)
            {
                log.warn("[syncUser] 接口返回 code={}, msg={}", code, resp.getString("msg"));
                return;
            }
            JSONArray data = resp.getJSONArray("data");
            if (data == null || data.isEmpty())
            {
                log.info("[syncUser] 无用户数据");
                return;
            }
            log.info("[syncUser] 接口返回用户 {} 条", data.size());

            // 1. 预加载所有部门到内存，用于 detpname → deptId 匹配
            SysDept query = new SysDept();
            List<SysDept> allDepts = deptMapper.selectDeptListAll(query);
            // 以 dept_name 为 key（取第一个匹配）
            Map<String, Long> deptNameMap = new HashMap<>();
            for (SysDept d : allDepts)
            {
                if (!deptNameMap.containsKey(d.getDeptName()))
                {
                    deptNameMap.put(d.getDeptName(), d.getDeptId());
                }
            }
            log.info("[syncUser] 已加载部门 {} 条用于匹配", allDepts.size());

            // 2. 遍历用户数据
            int inserted = 0;
            int updated = 0;
            int skipped = 0;
            for (int i = 0; i < data.size(); i++)
            {
                JSONObject item = data.getJSONObject(i);
                if (item == null) continue;

                // 字段名按接口实际返回取值
                String usercode    = item.getString("fd_no");
                String username    = item.getString("fd_name");
                String email       = item.getString("fd_email");
                String mobileno    = item.getString("fd_mobile_no");
                String detpname    = item.getString("fd_dept_name");       // 接口侧需补：所属部门名称
                String leaderNo    = item.getString("fd_short_no");       // 直接上级工号
                String sexCn       = item.getString("fd_sex");            // "男"/"女"/空

                if (StringUtils.isEmpty(usercode))
                {
                    skipped++;
                    continue;
                }

                // 过滤混入的部门/机构数据：fd_name 像部门名，且 fd_sex 不是男/女
                // 接口侧最好 SQL 加 WHERE fd_org_type = 8 只查人员
                if (StringUtils.isEmpty(sexCn) || "男".equals(sexCn) || "女".equals(sexCn))
                {
                    // 有性别 → 是人员
                }
                else if (StringUtils.isNotEmpty(username) && (username.contains("部") || username.contains("组")
                        || username.contains("中心") || username.contains("公司") || username.contains("团")))
                {
                    log.info("[syncUser] 跳过疑似部门/机构数据: {} ({})", usercode, username);
                    skipped++;
                    continue;
                }

                // 性别映射：中文 → RuoYi 编码（0=男 1=女 2=未知）
                String sex = null;
                if ("男".equals(sexCn)) sex = "0";
                else if ("女".equals(sexCn)) sex = "1";
                else sex = "2";

                // 匹配部门
                Long deptId = null;
                if (StringUtils.isNotEmpty(detpname) && deptNameMap.containsKey(detpname))
                {
                    deptId = deptNameMap.get(detpname);
                }
                else if (StringUtils.isNotEmpty(detpname))
                {
                    deptId = findDeptIdFuzzy(detpname, deptNameMap);
                    if (deptId == null)
                    {
                        log.warn("[syncUser] 用户 [{}] 的部门 [{}] 未匹配到", usercode, detpname);
                    }
                }

                // 查用户是否已存在
                SysUser existing = userMapper.selectUserByUserName(usercode);
                if (existing != null)
                {
                    // 更新基本信息（密码不变）
                    SysUser update = new SysUser();
                    update.setUserId(existing.getUserId());
                    update.setNickName(username);
                    update.setSex(sex);
                    if (deptId != null) update.setDeptId(deptId);
                    if (StringUtils.isNotEmpty(email)) update.setEmail(email);
                    if (StringUtils.isNotEmpty(mobileno)) update.setPhonenumber(mobileno);
                    if (StringUtils.isNotEmpty(leaderNo)) update.setFdShortNo(leaderNo);
                    update.setUpdateBy(SYNC_BY);
                    userMapper.updateUser(update);
                    // 已有用户如果没有 common 角色，也补上（幂等）
                    ensureCommonRole(existing.getUserId());
                    updated++;
                    log.info("[syncUser] 更新用户: {} ({})", usercode, username);
                }
                else
                {
                    // 新增用户
                    SysUser user = new SysUser();
                    user.setUserName(usercode);
                    user.setNickName(username);
                    user.setEmail(email);
                    user.setPhonenumber(mobileno);
                    user.setDeptId(deptId);
                    user.setPassword(SecurityUtils.encryptPassword("123456"));
                    user.setStatus("0");
                    user.setSex(sex);
                    user.setDelFlag("0");
                    if (StringUtils.isNotEmpty(leaderNo)) user.setFdShortNo(leaderNo);
                    user.setCreateBy(SYNC_BY);
                    userMapper.insertUser(user);
                    // 分配默认角色：common(普通用户)
                    ensureCommonRole(user.getUserId());
                    inserted++;
                    log.info("[syncUser] 新增用户: {} ({}) → userId={}, deptId={}",
                            usercode, username, user.getUserId(), deptId);
                }
            }

            log.info("========== 用户同步完成: 新增 {} 条, 更新 {} 条, 跳过 {} 条 ==========",
                    inserted, updated, skipped);
        }
        catch (Exception e)
        {
            log.error("[syncUser] 同步用户异常", e);
        }
    }

    // ========================================================================
    //  工具方法
    // ========================================================================

    /**
     * 确保用户拥有 common（普通用户）角色，幂等。
     * <p>已存在则跳过，不存在则插入。</p>
     */
    private void ensureCommonRole(Long userId)
    {
        if (userId == null) return;
        int cnt = userRoleMapper.countUserRoleByUserIdAndRoleId(userId, DEFAULT_COMMON_ROLE_ID);
        if (cnt == 0)
        {
            SysUserRole ur = new SysUserRole();
            ur.setUserId(userId);
            ur.setRoleId(DEFAULT_COMMON_ROLE_ID);
            List<SysUserRole> list = new ArrayList<>();
            list.add(ur);
            userRoleMapper.batchUserRole(list);
            log.info("[syncUser] 为 userId={} 补充分配 common 角色", userId);
        }
    }

    /**
     * 模糊匹配部门名称（contains）
     */
    private Long findDeptIdFuzzy(String detpname, Map<String, Long> deptNameMap)
    {
        for (Map.Entry<String, Long> entry : deptNameMap.entrySet())
        {
            if (entry.getKey() != null && (
                    entry.getKey().contains(detpname) || detpname.contains(entry.getKey())))
            {
                return entry.getValue();
            }
        }
        return null;
    }

    /**
     * 调用通用接口（不依赖 CommonApiClient 的 Servlet 上下文，直接使用 java.net.http.HttpClient）
     *
     * @param apiKey  sys_common_api 表的 api_key
     * @param params  GET 查询参数（可为 null）
     * @return 接口返回的 JSONObject；调用失败返回 null
     */
    private JSONObject callApi(String apiKey, Map<String, Object> params)
    {
        SysCommonApi cfg = commonApiService.selectCommonApiByKey(apiKey);
        if (cfg == null)
        {
            log.error("[callApi] 通用接口配置不存在: apiKey={}", apiKey);
            return null;
        }
        String url = cfg.getApiUrl();
        if (StringUtils.isEmpty(url))
        {
            log.error("[callApi] 通用接口未配置 URL: apiKey={}", apiKey);
            return null;
        }
        // 拼接 GET 参数
        if (params != null && !params.isEmpty())
        {
            url += (url.contains("?") ? "&" : "?") + encodeParams(params);
        }
        log.info("[callApi] apiKey={} url={}", apiKey, url);

        try
        {
            HttpRequest.Builder builder = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .timeout(Duration.ofSeconds(30));

            // 附加 Cookie（从 sys_common_api 配置中读取）
            String cookie = cfg.getCookie();
            if (StringUtils.isNotEmpty(cookie))
            {
                builder.header("Cookie", cookie);
            }

            HttpRequest req = builder.GET().build();
            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
            int status = resp.statusCode();
            String body = resp.body();
            if (status != 200)
            {
                log.error("[callApi] HTTP {} apiKey={} body={}", status, apiKey, truncate(body));
                return null;
            }
            return JSON.parseObject(body);
        }
        catch (Exception e)
        {
            log.error("[callApi] 调用异常 apiKey={} url={}", apiKey, url, e);
            return null;
        }
    }

    private static String encodeParams(Map<String, Object> params)
    {
        StringBuilder sb = new StringBuilder();
        for (Map.Entry<String, Object> entry : params.entrySet())
        {
            Object v = entry.getValue();
            if (v == null) continue;
            if (sb.length() > 0) sb.append("&");
            sb.append(entry.getKey()).append("=").append(URLEncoder.encode(String.valueOf(v), StandardCharsets.UTF_8));
        }
        return sb.toString();
    }

    private static String truncate(String s)
    {
        if (s == null) return "";
        return s.length() > 300 ? s.substring(0, 300) + "..." : s;
    }
}
