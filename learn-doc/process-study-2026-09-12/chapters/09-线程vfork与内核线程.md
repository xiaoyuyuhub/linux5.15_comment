# 09 同一个创建引擎，四种不同的资源协议

## clone flags 是资源开关，不是额外几种神秘实体

|标志|关键效果|关联|
|---|---|---|
|CLONE_VM|共享 mm|改映射会作用于共同地址空间|
|CLONE_FILES|共享文件描述符表|close/dup 改的是同一张表|
|CLONE_FS|共享 root/pwd/umask|chdir 对共享者可见|
|CLONE_SIGHAND|共享信号处理表|要求 CLONE_VM|
|CLONE_THREAD|同线程组|要求 CLONE_SIGHAND，继而要求 VM|
|CLONE_SETTLS|设置新线程 TLS|x86 FS base 等架构路径|
|CLONE_CHILD_CLEARTID|退出时清 TID 并唤醒 futex 等待|pthread join 协议的重要内核部分|
|CLONE_VFORK|父调用者等待子释放旧 VM 使用|通常与 CLONE_VM 配合|
|CLONE_NEWPID|为孩子建立新 PID namespace|不把调用者自己移入新 PID namespace|

pthread_create 还包含用户栈分配、线程描述符、TLS、启动 trampoline 和库内同步，不能缩写为“内核调用某用户函数”。内核负责新 task 和返回现场；用户库 trampoline 才调用你给的线程函数。

## 为什么线程切换也可能很贵

同 mm 的线程之间通常可以避免更换用户地址空间，但仍需调度、内核栈切换、寄存器/TLS/架构状态处理，还可能有缓存影响、跨 CPU 迁移和锁竞争。不能说线程共享内存，所以不需要上下文切换。

## vfork 等待的是地址空间使用结束

```text
父：kernel_clone
      创建共享 VM 的孩子
      设置 p->vfork_done 指向 completion
      wake_up_new_task
      wait_for_vfork_done  ─────────── 等待
子：首次运行 → exec 或 exit
      exec_mm_release / exit_mm_release
      mm_release → complete_vfork_done ── 唤醒父
父：返回用户态
```

vfork 父等待不意味着孩子整个新程序运行完。孩子成功 exec 释放旧 VM 使用后，父就可以继续，而新程序可能还要跑很久。多线程父进程中通常只是调用线程被挂起，不是所有兄弟线程都冻结。

因为共享旧用户地址空间和栈，vfork 子分支不适合随意调用 printf、修改局部变量或从调用函数返回。此教程不提供不安全的“花式 vfork”程序；先读源码协议，需要执行演示时用严格受控的立即 exec/_exit 小程序。

## kthreadd 的请求队列

```text
某内核调用者：kthread_create / kthread_create_on_node
  → __kthread_create_on_node
      分配 kthread_create_info
      把请求挂到 kthread_create_list
      wake_up_process(kthreadd_task)
      等待 completion 获取新 task

PID 2：kthreadd
  → 睡眠等待创建队列非空
  → 取出请求 → create_kthread
      → kernel_thread(kthread, create, flags)

新内核线程：kthread 包装器
  → 初始化私有 kthread 结构
  → 发布创建结果、complete
  → 初始睡眠，等待调用者安排启动
  → 被唤醒后执行 threadfn(data)
  → do_exit(ret)
```

`kthread_create` 建立线程后通常还需 `wake_up_process`；`kthread_run` 是“创建并唤醒”的便利封装。创建结果传回和业务函数真正执行是两个阶段。

普通 kthread 的 mm 为 NULL，它可以借 active_mm 保持地址翻译上下文；这不赋予它随意访问那个用户空间的语义。涉及用户 mm 的专项操作有显式 `kthread_use_mm/kthread_unuse_mm`，属于受控例外。

## 停止协议不是硬杀

`kthread_stop` 设置停止请求并唤醒目标，等待它退出；线程函数要定期检查 `kthread_should_stop`，适当退出并释放自身资源。若线程永远不检查且不退出，调用者可能一直等。工作队列线程也不是每来一个 work 就新建一个进程；多个 work 通常由池中 worker 执行。

阅读分支：`kernel/kthread.c` 看请求和包装器；`include/linux/kthread.h` 看 kthread_run 宏；`kernel/workqueue.c` 看 work 与 worker 的关系。本套实验不加载教学内核模块，避免让模块 ABI/构建占据基础课主线。

验收：你应能画出 fork、pthread、vfork、kthread 四张“task/mm/父等待”图，而不是只背四个 API 名字。
