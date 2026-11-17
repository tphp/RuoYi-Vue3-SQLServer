# 需求文档目录（01-requirements）

存放产品需求文档（PRD）、需求澄清记录、验收标准等。

## 目录组织规范

按**业务模块**建立子目录归类，每个模块一个目录，模块内放该模块的所有需求文档。随着需求增多，只需新增对应模块子目录，不污染根目录。

```
01-requirements/
├── README.md                 # 本文件：规范 + 索引
├── _template-prd.md          # PRD 通用模板（勿删）
└── <模块名>/                 # 每个业务模块一个子目录
    └── <英文短横线名>.md      # 首行保留中文标题，并写明「中文名称：xxx」
```

### 命名规范

- 模块目录：英文小写、短横线分隔，与后端模块名 / 功能域对齐（如 `bizperm`、`apilog`、`number-rule`）
- 需求文档：文件名统一用**英文小写、短横线分隔**、以 `-prd` 结尾（如 `api-log-prd.md`）；文档首行保留中文标题，并在标题下写明「中文名称：接口日志功能需求文档」等中文名，便于对应查找
- 模板：`_template-prd.md`

### 新增需求文档步骤

1. 在 `01-requirements/` 下新建（或复用）对应模块子目录。
2. 复制 `_template-prd.md` 到该子目录，重命名为正式文档。
3. 补充背景、目标、范围、功能清单、验收标准。
4. 有歧义时在文档中记录待确认问题。
5. 更新下方「文档索引」表。

## 文档索引

| 模块 | 目录 | 文档 |
|------|------|------|
| 业务级权限体系 | `bizperm/` | [业务级权限体系需求开发方案](bizperm/permission-system-prd.md) |
| 接口日志 | `apilog/` | [接口日志功能需求文档](apilog/api-log-prd.md)（回溯补录） |
| 单据编号生成 | `number-rule/` | [单据编号生成功能需求文档](number-rule/number-generation-prd.md)（回溯补录） |
| 外部系统接口对接 | `external-api/` | [外部系统接口对接需求文档](external-api/external-integration-prd.md)（回溯补录） |
| 数据源接入 | `datasource/` | [Oracle副数据源接入需求文档](datasource/oracle-datasource-prd.md)（回溯补录） |
