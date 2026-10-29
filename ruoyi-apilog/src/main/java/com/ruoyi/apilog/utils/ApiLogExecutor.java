/**
 * @author Zhang zhan
 * @date 2026-10-29
 */
package com.ruoyi.apilog.utils;

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import jakarta.annotation.PreDestroy;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * 接口日志异步写入执行器
 *
 * 使用单线程守护线程池异步落库，避免日志写入阻塞主业务流程；
 * 队列满时直接丢弃并打印告警，保证业务接口不受日志功能影响。
 *
 * @author Zhang zhan
 * @date 2026-10-29
 */
@Component
public class ApiLogExecutor
{
    private static final Logger log = LoggerFactory.getLogger(ApiLogExecutor.class);

    /** 队列容量 */
    private static final int QUEUE_CAPACITY = 5000;

    private final ThreadPoolExecutor executor;

    public ApiLogExecutor()
    {
        ThreadFactory threadFactory = new ThreadFactory()
        {
            private final AtomicInteger index = new AtomicInteger(1);

            @Override
            public Thread newThread(Runnable runnable)
            {
                Thread thread = new Thread(runnable, "api-log-writer-" + index.getAndIncrement());
                thread.setDaemon(true);
                return thread;
            }
        };
        this.executor = new ThreadPoolExecutor(1, 1, 0L, TimeUnit.MILLISECONDS,
                new ArrayBlockingQueue<>(QUEUE_CAPACITY), threadFactory,
                (runnable, pool) -> log.warn("[ApiLog] 日志写入队列已满，丢弃本次接口日志记录"));
    }

    /**
     * 提交异步任务
     *
     * @param task 任务
     */
    public void submit(Runnable task)
    {
        try
        {
            executor.execute(task);
        }
        catch (Exception e)
        {
            log.warn("[ApiLog] 提交日志写入任务失败: {}", e.getMessage());
        }
    }

    /**
     * 容器关闭时释放线程池
     */
    @PreDestroy
    public void shutdown()
    {
        executor.shutdown();
    }
}
