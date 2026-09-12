# 配套实验

这些程序只依赖 Linux + C 编译器，不修改内核。建议先在普通 Linux 用户态理解现象，再放入 QEMU guest，用内核 GDB/ftrace 对照内部调用链。

## 构建

```bash
make -C linux-process-learning/labs
```

产物在 `labs/bin/`：

| 程序 | 验证命题 |
|---|---|
| `fork_cow` | fork 后虚拟地址相同；子写不会改父值；父子 PID 不同 |
| `fork_exec` | 子先 fork 再 exec 自己；exec 后 PID 保持 |
| `thread_share` | pthread 的 TID 不同、PID/TGID 相同，且共享全局变量地址与内容 |

## 运行

```bash
./linux-process-learning/labs/bin/fork_cow
./linux-process-learning/labs/bin/fork_exec
./linux-process-learning/labs/bin/thread_share
```

程序带有短暂等待点，便于你查 `/proc/<pid>/status`、`maps`、`smaps` 或附加调试器。等待秒数可通过环境变量 `LAB_PAUSE_SECONDS` 调整，例如：

```bash
LAB_PAUSE_SECONDS=30 ./linux-process-learning/labs/bin/fork_cow
```

## `/proc` 观察建议

```bash
grep -E '^(Name|Pid|PPid|Tgid|Threads|State):' /proc/PID/status
cat /proc/PID/maps
grep -E '^(Private|Shared)_(Clean|Dirty):' /proc/PID/smaps_rollup
```

不要把 `smaps_rollup` 的一次统计当成精确物理页归属证明：运行库、写时复制、内核记账时机都会影响数字。它适合观察趋势；严格验证可以配合页表工具或内核断点。

## GDB 预置文件

`gdb/process-lifecycle.gdb` 提供分组断点命令：

```gdb
(gdb) source linux-process-learning/labs/gdb/process-lifecycle.gdb
(gdb) help process-boot-breaks
(gdb) process-boot-breaks
```

每组命令只负责下断点，不自动继续。对运行期断点务必按目标 PID 添加 condition。

## tracefs 辅助脚本

`trace/trace-process.sh PROGRAM [ARGS...]` 开启 fork/exec/exit/switch 事件、运行目标程序、关闭追踪并输出 trace。需要 root 且 guest 内已挂载 tracefs；它会在退出路径尽力关闭本次启用的事件，但不要在多人共享的 tracing 实例中直接使用。

```bash
sudo ./linux-process-learning/labs/trace/trace-process.sh \
  ./linux-process-learning/labs/bin/fork_exec
```

## 推荐实验记录

| 实验 | 用户态观察 | 内核断点/事件 | 结论 |
|---|---|---|---|
| fork | PID、地址、值 | `copy_process/copy_mm` | |
| COW write | 父子值、smaps | `do_wp_page` | |
| exec | exec 前后 PID | `exec_mmap` | |
| pthread | PID/TID、地址 | `copy_mm` + clone flags | |
| exit/wait | status State | exit/wait tracepoint | |
