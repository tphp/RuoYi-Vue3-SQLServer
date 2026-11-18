package com.ruoyi.framework.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;

/**
 * 资源文件配置加载
 *
 * <p>本系统为无状态 JWT 架构，语言由前端通过 X-Lang 请求头指定，
 * 不使用 Session 存储，也不使用 LocaleChangeInterceptor（该拦截器依赖 Session）。
 *
 * @author ruoyi
 */
@Configuration
public class I18nConfig
{
    @Bean
    public LocaleResolver localeResolver()
    {
        return new HeaderLocaleResolver();
    }
}
