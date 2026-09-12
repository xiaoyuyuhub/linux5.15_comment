# 08. GDB、QEMU 与动态跟踪实验手册

## 1. 目标与安全边界

最稳妥的内核源码调试环境是：调试主机上的 GDB + QEMU 虚拟机 + 与启动内核完全匹配、未剥离符号的 `vmlinux`。不要在生产/办公宿主机上直接用高风险 fault injection 或停住关键内核线程。

当前仓库 `.config` 已有：

```text
CONFIG_X86_64=y
CONFIG_DEBUG_INFO=y
CONFIG_GDB_SCRIPTS=y
CONFIG_SCHEDSTATS=y
CONFIG_FTRACE=y
```

建议另行确认：`CONFIG_FRAME_POINTER`、`CONFIG_KALLSYMS_ALL`、所需 tracepoint/debugfs；若采用 KGDB 才需要 `CONFIG_KGDB*`。本手册主线不要求 KGDB。

## 2. 构建与启动模板

在仓库根目录构建（并行数按内网机器调整）：

```bash
make olddefconfig
make -j8 bzImage
```

产物通常为：

- `vmlinux`：主机 GDB 使用，包含符号。
- `arch/x86/boot/bzImage`：QEMU 启动。

QEMU 模板（rootfs 路径按你的环境替换）：

```bash
qemu-system-x86_64 \
  -m 2G -smp 1 \
  -kernel arch/x86/boot/bzImage \
  -append "console=ttyS0 nokaslr maxcpus=1" \
  -initrd /absolute/path/to/initramfs.cpio.gz \
  -nographic -s -S
```

- `-s`：在 TCP 1234 开 GDB stub。
- `-S`：CPU 上电后先暂停，等 GDB。
- `nokaslr`：初学时让地址稳定；掌握后再启 KASLR。
- `-smp 1/maxcpus=1`：第一轮减少并发噪声，不代表生产行为。

如果没有 initramfs，可使用已有 qcow2/virtio 根盘，但要把 `root=`、驱动与控制台参数配齐。

## 3. GDB 连接

仓库内启动 GDB：

```gdb
gdb vmlinux
(gdb) set pagination off
(gdb) target remote :1234
(gdb) source scripts/gdb/vmlinux-gdb.py
(gdb) lx-symbols
```

本学习区提供 [labs/gdb/process-lifecycle.gdb](labs/gdb/process-lifecycle.gdb)，它只预置安全的断点清单与打印命令，不自动 continue。

## 4. 实验 A：看见 PID 0、1、2

建议断点：

```gdb
b start_kernel
b rest_init
b kernel_clone
b kernel_init
b kthreadd
b cpu_startup_entry
c
```

在 `rest_init`：

```gdb
p $lx_current().pid
p $lx_current().comm
p $lx_current().mm
p $lx_current().active_mm
```

进入两次 `kernel_clone` 时查看 `args->fn`。第一次应指向 `kernel_init`，第二次应指向 `kthreadd`。函数名/参数优化可能影响 GDB 可见性；若变量被优化掉，结合源代码行断点和寄存器 ABI 观察。

## 5. 实验 B：一次普通 fork

在 guest 运行 `labs/bin/fork_cow` 前设置：

```gdb
b kernel_clone
b copy_process
b copy_mm
b dup_mm
b wake_up_new_task
```

系统内 fork 很多，最好使用条件断点。目标程序启动后从 guest 获取 PID，例如 123：

```gdb
condition <breakpoint-number> $lx_current().pid == 123
```

在 `copy_process` 返回附近比较父/子：

```gdb
p $lx_current().pid
p p->pid
p $lx_current().mm
p p->mm
p/x clone_flags
```

## 6. 实验 C：观察 COW

在父子同步写入前后查看 `/proc/<pid>/smaps` 的 private/shared dirty 变化，或加断点：

```gdb
b do_user_addr_fault
b do_wp_page
```

这些断点极高频，必须用 PID、fault address 范围或实验阶段控制。更稳妥的是 trace/mm 统计 + 应用打印虚拟地址，把目标地址用于条件过滤。

虚拟地址相同不代表物理页仍相同；fork 后父子布局通常相同，而物理页共享/复制需要页表或内存统计证据。

## 7. 实验 D：exec 前后 PID 不变、mm 改变

运行 `labs/bin/fork_exec`，对子 PID 加条件断点：

```gdb
b do_execveat_common
b load_elf_binary
b begin_new_exec
b exec_mmap
```

在 `exec_mmap` 入口记录 `current->pid/current->mm`，单步越过 task 关联更新后再记录。不要在优化构建中执着于某个局部变量；观察 `current->mm` 最可靠。

## 8. 实验 E：调度与退出优先用 tracefs

guest 内：

```bash
mount -t tracefs nodev /sys/kernel/tracing 2>/dev/null || true
cd /sys/kernel/tracing
echo 0 > tracing_on
echo > trace
echo 1 > events/sched/sched_process_fork/enable
echo 1 > events/sched/sched_process_exec/enable
echo 1 > events/sched/sched_process_exit/enable
echo 1 > events/sched/sched_switch/enable
echo 1 > tracing_on
/path/to/fork_exec
echo 0 > tracing_on
cat trace
```

如果输出过大，使用 `set_event_pid` 过滤目标 PID，或只开一个事件。事件目录是否存在取决于配置。

## 9. function_graph 跟一条内核调用链

```bash
cd /sys/kernel/tracing
echo function_graph > current_tracer
echo kernel_clone > set_graph_function
echo 1 > tracing_on
/path/to/fork_cow
echo 0 > tracing_on
cat trace
```

递归、notrace、inline、编译优化会使动态图和源码静态调用树不完全一致，这不是必然的错误。先确认函数是否出现在 `available_filter_functions`。

## 10. 高频断点的控制策略

1. 先用 tracepoint 获取目标 PID/comm 和发生时间。
2. 再用条件断点限制 `$lx_current().pid`。
3. 调度切换可限制 `prev->pid == X || next->pid == X`。
4. 多 CPU 问题第二轮再开 SMP；第一轮保持单 CPU。
5. 每次只验证一个命题，不要同时断 20 个热函数。

## 11. 每日调试记录模板

```markdown
### YYYY-MM-DD：命题

- 内核 commit/config：
- guest/rootfs：
- 命题：例如“普通 fork 的 child->mm 与 parent->mm 不同”
- 断点/tracepoint：
- 输入程序与 PID：
- 观察值：
- 与源码对应的位置：
- 结论：已验证 / 被推翻 / 证据不足
- 下一步只追一个问题：
```

## 12. 常见失败定位

| 症状 | 高概率原因 | 检查 |
|---|---|---|
| breakpoint 地址不对 | `vmlinux` 与 bzImage 不匹配 | build-id、时间戳、重新构建 |
| 源码行跳来跳去 | 优化/inlining | 按函数断点、看反汇编、必要时降低优化做教学构建 |
| `current` 无法解析 | gdb scripts 未加载或符号问题 | `source scripts/gdb/vmlinux-gdb.py`、debug info |
| 一 continue 就反复停 | 热路径无条件断点 | 条件断点或改 tracepoint |
| 启动后找不到 init | rootfs/init 路径、驱动或权限错误 | console 日志、`rdinit=/bin/sh` |
| tracefs 无事件 | 配置未启/未挂载 | `.config` 与 `/sys/kernel/tracing/events` |
