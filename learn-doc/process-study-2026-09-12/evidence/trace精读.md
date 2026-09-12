# 本次 pipe trace 的一条完整因果链

摘自 qemu-trace.log。时间单位秒，为该次内核 trace 时钟；不是宿主墙钟。

```text
1.411312: sched_switch: prev_comm=process_lab prev_pid=77 prev_state=S
            ==> next_comm=swapper/0 next_pid=0
2.416489: sched_waking: comm=process_lab pid=77 target_cpu=000
2.416552: sched_wakeup: comm=process_lab pid=77 target_cpu=000
2.416839: sched_switch: prev_comm=process_lab prev_pid=76 prev_state=R
            ==> next_comm=process_lab next_pid=77
```

1. 孩子 PID 77 因空管道 read 等待，以 S 状态离开 CPU；CPU 随后进入 idle。这一行才是“本次确实睡眠”的直接证据。
2. 约一秒后，父 PID 76 的执行上下文记录了对 PID 77 的 waking/wakeup。孩子进入可运行状态。
3. 稍后发生从 76 到 77 的切换。父亲是 R，说明它此刻不必处于睡眠，也可以因为孩子需要运行而切出。
4. 孩子恢复原 read 所在的执行流、读到字节、退出；父亲 wait 完成。完整日志还包含中途 RCU 调度，不能把上述选段当成期间没有别的事件。

waking 到实际切入约 350 微秒，但这是开 trace、TCG 模拟、单 CPU、特定运行的一次观察，不能当作真实硬件的 Linux 调度性能结论。

trace 的 prev_state 文本是事件格式转换后的报告，不等于直接打印 task->__state 的数值；退出切出显示 Z 也不能反过来认为 EXIT_ZOMBIE 是普通睡眠状态。
