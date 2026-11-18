package com.ruoyi.framework.config;

import java.util.Locale;
import org.springframework.context.i18n.LocaleContext;
import org.springframework.context.i18n.SimpleLocaleContext;
import org.springframework.web.servlet.i18n.AbstractLocaleContextResolver;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.ruoyi.common.constant.Constants;

/**
 * 基于请求头的语言解析器
 *
 * <p>本系统为无状态 JWT 架构（SessionCreationPolicy.STATELESS），不使用 Session 存储语言。
 * 前端每次请求通过 X-Lang 头传递当前语言（zh-cn / en），
 * 未携带该头时回退到 Accept-Language 头，最后回退到默认语言。
 *
 * <p>注意：浏览器不允许 JavaScript 覆盖 Accept-Language 头（fetch 规范保留头），
 * 因此使用自定义的 X-Lang 头承载语言标识。
 *
 * @author ruoyi
 */
public class HeaderLocaleResolver extends AbstractLocaleContextResolver
{
    /** 前端传递语言标识的请求头 */
    public static final String LANGUAGE_HEADER = "X-Lang";

    /** 中文（简体） */
    private static final Locale LOCALE_ZH_CN = new Locale("zh", "CN");

    /** 英文 */
    private static final Locale LOCALE_EN = new Locale("en");

    public HeaderLocaleResolver()
    {
        // 默认语言
        setDefaultLocale(Constants.DEFAULT_LOCALE);
    }

    @Override
    public LocaleContext resolveLocaleContext(HttpServletRequest request)
    {
        // 优先读取前端传递的 X-Lang 头
        Locale locale = parseLocale(request.getHeader(LANGUAGE_HEADER));
        if (locale != null)
        {
            return new SimpleLocaleContext(locale);
        }
        // 回退到 Accept-Language 头
        Locale requestLocale = request.getLocale();
        if (requestLocale != null && isSupported(requestLocale.getLanguage()))
        {
            return new SimpleLocaleContext(requestLocale);
        }
        // 最终回退到默认语言
        Locale defaultLocale = getDefaultLocale();
        return new SimpleLocaleContext(defaultLocale != null ? defaultLocale : Constants.DEFAULT_LOCALE);
    }

    @Override
    public void setLocaleContext(HttpServletRequest request, HttpServletResponse response, LocaleContext localeContext)
    {
        throw new UnsupportedOperationException(
                "本系统不支持通过 LocaleResolver 修改 Locale，请通过 " + LANGUAGE_HEADER + " 请求头指定语言");
    }

    /**
     * 解析语言标识，支持 zh-cn / zh_CN / zh / en / en-US 等形式
     *
     * @param lang 语言标识
     * @return 对应的 Locale，不支持时返回 null
     */
    private Locale parseLocale(String lang)
    {
        if (lang == null || lang.trim().isEmpty())
        {
            return null;
        }
        String value = lang.trim().toLowerCase(Locale.ROOT).replace('_', '-');
        if (value.startsWith("zh"))
        {
            return LOCALE_ZH_CN;
        }
        if (value.startsWith("en"))
        {
            return LOCALE_EN;
        }
        return null;
    }

    /**
     * 判断语言是否受支持
     *
     * @param language 语言代码
     * @return 是否支持
     */
    private boolean isSupported(String language)
    {
        return "zh".equalsIgnoreCase(language) || "en".equalsIgnoreCase(language);
    }
}
