# 实施计划：为项目添加 Oracle 数据源

> 中文名称：Oracle数据源接入实施计划

## Context（背景）

当前项目 `smc-api`（基于若依 RuoYi 4.0.6 / Spring Boot 4 / MyBatis / Druid / MSSQL）已经内置动态数据源机制（master/slave 切换），但只有一个主库（MSSQL）。为支持后续业务接入外部 Oracle 系统（读 + 写），需要新增 Oracle 数据源，并让业务代码能通过 `@DataSource` 注解自由切换。

用户已**明确授权修改红色区域文件**（DataSourceType.java、DruidConfig.java）。

## 目标

- 新增 Oracle 数据源 Bean，注册到 `DynamicDataSource`
- 新增 `DataSourceType.ORACLE` 枚举
- 配置 Oracle JDBC 驱动
- 预留 Oracle 连接配置（占位符，用户稍后填真实值）
- 业务层使用 `@DataSource(DataSourceType.ORACLE)` 即可切换

## 关键技术决策

### 1. 驱动选择
- **ojdbc11**（`com.oracle.database.jdbc:ojdbc11`，23.x 版本）
- 理由：原生支持 JDK 17，与 Spring Boot 4 兼容；Oracle 官方推荐
- 同时引入 `orai18n`（`com.oracle.database.nls:orai18n`）处理 Oracle 多字节字符

### 2. 事务支持（"读写都要"）
- **不额外配置 Oracle 事务管理器**，复用 Spring Boot 默认 `DataSourceTransactionManager`
- 默认事务管理器绑定 @Primary 的 `dynamicDataSource`，调用 `getConnection()` 时按 ThreadLocal 路由
- `DataSourceAspect` 标注 `@Order(1)`，先于事务切面（`@Order(Integer.MAX_VALUE)`）执行，保证 ThreadLocal 先切到 ORACLE，再开始事务 → 事务拿到的就是 Oracle 连接
- **结论**：业务方法上同时加 `@DataSource(DataSourceType.ORACLE)` + `@Transactional` 即可保证 Oracle 单库事务正确性
- **限制**：禁止在同一方法内既操作 MSSQL 又操作 Oracle（跨库事务场景需要 JTA，不在本期范围）

### 3. PageHelper 分页方言
- 全局 `pagehelper.helperDialect: sqlserver` 保持不变（不影响现有 MSSQL 业务）
- Oracle 业务方法分页时，**显式指定方言**：`PageHelper.startPage(pageNum, pageSize, "oracle")`
- 不使用 `PageUtils.startPage()`（它走全局方言）

### 4. MyBatis Mapper XML
- Oracle 相关的 Mapper XML 放在 `ruoyi-crm/src/main/resources/mapper/crm/oracle/`（或按业务模块分类）
- 全局 `mapperLocations: classpath*:mapper/**/*Mapper.xml` 会自动扫描，无需改配置
- SQL 语法必须遵循 Oracle 规范（如 `ROWNUM`、`NVL`、序列 `seq.nextval`、无 `LIMIT`、`||` 拼接等）

## 修改清单

### 文件 1：`ruoyi-admin/pom.xml`（🟡 黄色区域）
在 MSSQL 驱动依赖下方新增 Oracle 驱动依赖。
```xml
<!--oracle驱动包-->
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc11</artifactId>
</dependency>
<dependency>
    <groupId>com.oracle.database.nls</groupId>
    <artifactId>orai18n</artifactId>
</dependency>
```

### 文件 2：`pom.xml`（顶级，🟡 黄色区域）
在 `<properties>` 新增 Oracle 驱动版本号；在 `<dependencyManagement>` 新增依赖声明（版本统一管理）。
```xml
<oracle.jdbc.version>23.5.0.24.07</oracle.jdbc.version>
```
```xml
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc11</artifactId>
    <version>${oracle.jdbc.version}</version>
</dependency>
<dependency>
    <groupId>com.oracle.database.nls</groupId>
    <artifactId>orai18n</artifactId>
    <version>${oracle.jdbc.version}</version>
</dependency>
```

### 文件 3：`ruoyi-common/src/main/java/com/ruoyi/common/enums/DataSourceType.java`（🔴 红色区域，已授权）
在 `SLAVE` 后追加 `ORACLE` 枚举值。
```java
public enum DataSourceType
{
    MASTER,
    SLAVE,
    /**
     * Oracle库
     */
    ORACLE
}
```

### 文件 4：`ruoyi-framework/src/main/java/com/ruoyi/framework/config/DruidConfig.java`（🔴 红色区域，已授权）
新增 `oracleDataSource` Bean（参照 slaveDataSource 模式，使用 `@ConditionalOnProperty` 控制开关），并在 `dataSource()` 方法中通过 `setDataSource(...)` 注册到 targetDataSources。
```java
@Bean
@ConfigurationProperties("spring.datasource.druid.oracle")
@ConditionalOnProperty(prefix = "spring.datasource.druid.oracle", name = "enabled", havingValue = "true")
public DataSource oracleDataSource(DruidProperties druidProperties)
{
    DruidDataSource dataSource = DruidDataSourceBuilder.create().build();
    return druidProperties.dataSource(dataSource);
}
```
在 `dataSource(...)` 方法体内追加：
```java
setDataSource(targetDataSources, DataSourceType.ORACLE.name(), "oracleDataSource");
```

### 文件 5：`ruoyi-admin/src/main/resources/application-druid.yml`（🟡 黄色区域）
在 slave 配置块后新增 oracle 配置块（占位符，等用户填真实值）。
```yaml
# Oracle数据源
oracle:
    # Oracle数据源开关/默认关闭，启用时设为 true
    enabled: false
    driverClassName: oracle.jdbc.OracleDriver
    url: jdbc:oracle:thin:@localhost:1521:orcl
    username: oracle_user
    password: oracle_password
```
> 注：Druid 的 `validationQuery: SELECT 1` 对 Oracle 11g+ 也可用，保持不变。

## 不修改的部分（避免扩大影响面）

- `application.yml` 中 `pagehelper.helperDialect: sqlserver` 保持不变
- `DruidProperties.java` 保持不变（Oracle 复用同一套池参数）
- `DynamicDataSource.java` / `DynamicDataSourceContextHolder.java` / `DataSourceAspect.java` 保持不变（机制通用，无需改）
- `@DataSource` 注解保持不变（默认值仍为 MASTER，新增 ORACLE 后天然可用）
- `PageUtils.startPage()` 保持不变

## 业务层使用示例（供后续开发参考）

```java
// ruoyi-crm 业务 Service 实现中
@Service
public class SomeServiceImpl implements ISomeService {

    @Autowired
    private SomeOracleMapper oracleMapper;

    // 查询（Oracle 分页，显式传方言）
    @DataSource(DataSourceType.ORACLE)
    @Override
    public List<Xxx> selectXxxList(XxxQuery query) {
        PageHelper.startPage(query.getPageNum(), query.getPageSize(), "oracle");
        return oracleMapper.selectXxxList(query);
    }

    // 增删改（Oracle 事务，@DataSource 先切，@Transactional 后开）
    @DataSource(DataSourceType.ORACLE)
    @Transactional
    @Override
    public int insertXxx(Xxx xxx) {
        return oracleMapper.insertXxx(xxx);
    }
}
```

## 验证步骤

### 1. 编译验证
```bash
cd <项目根目录>
mvn clean compile -DskipTests
```
预期：BUILD SUCCESS，无编译错误。

### 2. 配置验证（不启用 Oracle）
保持 `oracle.enabled: false`，启动应用：
```bash
cd <项目根目录>\ruoyi-admin
mvn spring-boot:run
```
预期：应用正常启动，`@ConditionalOnProperty` 让 oracleDataSource Bean 不创建，无副作用。

### 3. 启用验证（填入真实 Oracle 连接后）
- 用户填入真实 url/username/password
- 设置 `oracle.enabled: true`
- 启动应用，观察 Druid 监控页 `http://localhost:8080/druid/datasource.html` 应能看到三个数据源（Master / 动态 / Oracle）
- 在 ruoyi-crm 编写测试 Mapper，用 `@DataSource(DataSourceType.ORACLE)` 标注方法，执行一次查询验证连通性

### 4. 事务验证（后续业务开发时）
- 在 Oracle 方法上加 `@Transactional`，主动抛异常，验证数据未写入（回滚生效）