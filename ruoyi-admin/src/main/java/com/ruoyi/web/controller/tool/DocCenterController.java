package com.ruoyi.web.controller.tool;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.util.StreamUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.domain.R;

/**
 * 技术文档中心 Controller
 * <p>
 * 服务启动后访问 {@code http://localhost:8080/docs/index.html} 即可在线查阅项目文档，
 * 覆盖 docs/（四类文档）、.trae/rules/（项目规则）、.trae/skills/（AI 技能）。
 * </p>
 * <p>
 * 说明：HTML 页面也通过本 Controller 返回（而非静态资源），
 * 借助 {@code @Anonymous} 注解匿名放行，避免被 Spring Security 拦截（不改动框架核心 SecurityConfig）。
 * </p>
 *
 * @author Zhang zhan
 * @date 2026-11-10
 */
@Anonymous
@RestController
@RequestMapping("/docs")
public class DocCenterController
{
    /**
     * 文档根目录（项目根目录），可通过配置 {@code ruoyi.docPath} 覆盖。
     * 为空时自动探测当前运行目录。
     */
    @Value("${ruoyi.docPath:}")
    private String docPath;

    /**
     * 允许访问的目录定义：{相对项目根目录的路径, 导航显示名}。
     * 同时作为防目录遍历的白名单，content 接口只能读取这些目录下的文件。
     */
    private static final List<DocRoot> DOC_ROOTS = Arrays.asList(
            new DocRoot("docs", "项目文档"),
            new DocRoot(".trae/rules", "项目规则"),
            new DocRoot(".trae/skills", "AI 技能")
    );

    /**
     * 返回文档中心首页（导航树 + 搜索）
     *
     * @return index.html 页面内容
     */
    @GetMapping(value = {"/", "/index.html"}, produces = "text/html;charset=UTF-8")
    public String index() throws IOException
    {
        return readClasspathHtml("docview/index.html");
    }

    /**
     * 返回文档查看页（Markdown 渲染）
     *
     * @return view.html 页面内容
     */
    @GetMapping(value = "/view.html", produces = "text/html;charset=UTF-8")
    public String view() throws IOException
    {
        return readClasspathHtml("docview/view.html");
    }

    /**
     * 获取文档导航树
     *
     * @return 三个根目录下的 Markdown 文档树
     */
    @GetMapping("/api/tree")
    public R<List<DocNode>> tree()
    {
        String projectRoot = resolveProjectRoot();
        List<DocNode> roots = new ArrayList<>();
        for (DocRoot docRoot : DOC_ROOTS)
        {
            File dir = new File(projectRoot, docRoot.path);
            if (dir.exists() && dir.isDirectory())
            {
                DocNode node = buildNode(dir, docRoot.path, docRoot.displayName);
                if (node != null)
                {
                    roots.add(node);
                }
            }
        }
        return R.ok(roots);
    }

    /**
     * 读取指定文档内容
     *
     * @param path 文档相对项目根目录的路径，如 {@code docs/02-development/bizperm/xxx.md}
     * @return 文档原始 Markdown 文本
     */
    @GetMapping("/api/content")
    public R<String> content(@RequestParam("path") String path)
    {
        File file = resolveSafeFile(path);
        if (file == null || !file.exists() || !file.isFile())
        {
            return R.fail("文件不存在或路径非法: " + path);
        }
        try
        {
            String content = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);
            return R.ok(content);
        }
        catch (IOException e)
        {
            return R.fail("读取文件失败: " + e.getMessage());
        }
    }

    /**
     * 读取 classpath 下的 HTML 页面内容
     *
     * @param location classpath 相对路径，如 {@code docview/index.html}
     * @return HTML 文本
     */
    private String readClasspathHtml(String location) throws IOException
    {
        ClassPathResource resource = new ClassPathResource(location);
        try (InputStream in = resource.getInputStream())
        {
            return StreamUtils.copyToString(in, StandardCharsets.UTF_8);
        }
    }

    /**
     * 探测项目根目录
     * <p>
     * 优先使用配置 {@code ruoyi.docPath}；否则依次探测当前目录、上级目录，
     * 以存在 {@code docs} 目录为准（兼容在项目根目录或 ruoyi-admin 模块目录下启动）。
     * </p>
     */
    private String resolveProjectRoot()
    {
        if (docPath != null && !docPath.trim().isEmpty())
        {
            File configured = new File(docPath.trim());
            if (configured.exists())
            {
                return configured.getAbsolutePath();
            }
        }
        String userDir = System.getProperty("user.dir");
        if (new File(userDir, "docs").exists())
        {
            return userDir;
        }
        File parent = new File(userDir).getParentFile();
        if (parent != null && new File(parent, "docs").exists())
        {
            return parent.getAbsolutePath();
        }
        return userDir;
    }

    /**
     * 递归构建目录树，仅收录 Markdown 文件
     */
    private DocNode buildNode(File dir, String relativePath, String displayName)
    {
        DocNode node = new DocNode();
        node.setName(displayName);
        node.setPath(relativePath);
        node.setType("dir");

        List<DocNode> children = new ArrayList<>();
        File[] files = dir.listFiles();
        if (files != null)
        {
            // 目录在前，文件在后，均按名称排序
            Arrays.sort(files, Comparator.comparing(File::isDirectory).reversed().thenComparing(File::getName));
            for (File f : files)
            {
                if (f.getName().startsWith("."))
                {
                    continue; // 跳过隐藏文件
                }
                String childPath = relativePath + "/" + f.getName();
                if (f.isDirectory())
                {
                    DocNode child = buildNode(f, childPath, f.getName());
                    if (child != null)
                    {
                        children.add(child);
                    }
                }
                else if (isMarkdown(f))
                {
                    DocNode child = new DocNode();
                    child.setName(stripExtension(f.getName()));
                    child.setPath(childPath);
                    child.setType("file");
                    children.add(child);
                }
            }
        }
        node.setChildren(children);
        return node;
    }

    /**
     * 校验并解析文件路径，防止目录遍历（如 ../ 越权访问）
     *
     * @param path 请求参数中的相对路径
     * @return 校验通过后的文件对象；非法路径返回 null
     */
    private File resolveSafeFile(String path)
    {
        if (path == null || path.trim().isEmpty())
        {
            return null;
        }
        String projectRoot = resolveProjectRoot();
        Path rootPath = Paths.get(projectRoot).normalize();
        Path target = rootPath.resolve(path.trim().replace('\\', '/')).normalize();

        // 必须仍位于项目根目录之内
        if (!target.startsWith(rootPath))
        {
            return null;
        }
        // 必须位于白名单目录之内
        for (DocRoot docRoot : DOC_ROOTS)
        {
            Path allowed = rootPath.resolve(docRoot.path).normalize();
            if (target.startsWith(allowed))
            {
                return target.toFile();
            }
        }
        return null;
    }

    private boolean isMarkdown(File file)
    {
        return file.getName().toLowerCase().endsWith(".md");
    }

    private String stripExtension(String fileName)
    {
        int idx = fileName.lastIndexOf('.');
        return idx > 0 ? fileName.substring(0, idx) : fileName;
    }

    /**
     * 目录定义：相对路径 + 导航显示名
     */
    private static class DocRoot
    {
        final String path;
        final String displayName;

        DocRoot(String path, String displayName)
        {
            this.path = path;
            this.displayName = displayName;
        }
    }

    /**
     * 文档树节点
     */
    public static class DocNode
    {
        private String name;
        private String path;
        private String type;
        private List<DocNode> children;

        public String getName()
        {
            return name;
        }

        public void setName(String name)
        {
            this.name = name;
        }

        public String getPath()
        {
            return path;
        }

        public void setPath(String path)
        {
            this.path = path;
        }

        public String getType()
        {
            return type;
        }

        public void setType(String type)
        {
            this.type = type;
        }

        public List<DocNode> getChildren()
        {
            return children;
        }

        public void setChildren(List<DocNode> children)
        {
            this.children = children;
        }
    }
}
