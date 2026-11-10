# Bug / BadCase 文档目录（04-bugfix）

存放 Bug 修复记录、BadCase 分析与预防措施。

## 目录组织规范

按**业务模块 / 技术领域**建子目录归类，与 `01-requirements`、`02-development` 保持一致。

```
04-bugfix/
├── README.md                 # 本文件：规范 + 索引
├── _template-bugfix.md       # Bug 文档模板（勿删）
└── <模块名>/                 # 每个业务模块 / 技术领域一个子目录
    └── <问题简述>-bugfix.md
```

### 命名规范

- 模块目录：英文小写、短横线分隔，与后端模块名对齐（如 `bizperm`、`apilog`）
- Bug 文档：`<模块>-<问题简述>-bugfix.md`，例如 `apilog-响应丢失-bugfix.md`
- 模板：`_template-bugfix.md`

### 新增 Bug 文档步骤

1. 在 `04-bugfix/` 下新建（或复用）对应模块子目录。
2. 复制 `_template-bugfix.md` 到该子目录，重命名为正式文档。
3. 重点记录根因分析与预防措施，避免同类问题复发；标注严重程度（P0-P3）。
4. 更新下方「文档索引」。

## 文档索引

（暂无文档，待补充）

