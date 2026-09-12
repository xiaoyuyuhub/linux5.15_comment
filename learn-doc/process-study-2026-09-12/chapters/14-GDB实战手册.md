# 14 GDB 调试：从能连上到能证明一个命题

## 本项目实际环境

宿主机是 macOS；已有构建虚拟机 `linux-x86-builder` 是 ARM64 Linux；QEMU 在它内部通过 TCG 模拟 x86-64 Linux 5.15。GDB 要理解 x86-64 目标，使用 gdb-multiarch。宿主、构建机、目标 guest 三层的 PID 不在同一空间，别在构建机 /proc 查 QEMU guest 里的子 PID。

|文件/配置|本次核对结果|影响|
|---|---|---|
|根 Makefile|5.15.0|主线以此源码为准|
|根 .config|DEBUG_INFO_SPLIT=y|若按它构建，离线调试还可能需要 .dwo|
|out/x86-lab/kernel.config|DEBUG_INFO_SPLIT=n，DWARF4|已有产物对应配置与根配置不同|
|已有 kernel.config|GDB_SCRIPTS=y，EVENT_TRACING=y|可支持部分辅助/事件跟踪，但要有生成文件|
|已有 kernel.config|FUNCTION_TRACER=n，FTRACE_SYSCALLS=n|不能直接跑 function_graph/syscall tracer|
|根 .gdbinit|连接后给 0x7c00 下硬件断点|适合 MBR 学习，进程课用 -nx 避免自动干扰|
|源码 scripts/gdb/linux/constants.py.in|只有模板，未见生成 constants.py|只拷源码不等于辅助命令可直接加载|

源码注释变动不一定影响机器指令，却会使符号行号对应漂移。现有 vmlinux 与当前源码是否完全一致，要结合构建记录和实际断点验证。不能只看文件时间相同就确认配对。我们保存 SHA-256 和启动日志，以便迁移后至少确认使用了同一组二进制。

## 最快复现实验启动

以下在**Linux 构建机**的仓库根目录执行。内网纯 x86 Linux 也可用同样脚本，装有 x86_64-linux-gnu-gcc 或设置 CC=gcc。

```bash
bash process-study-2026-09-12/labs/build-initramfs.sh
DEBUG=1 bash process-study-2026-09-12/labs/run-qemu.sh
```

脚本使用 initramfs，不挂原 rootfs 磁盘；单 CPU，512M，nokaslr，GDB 仅监听构建机回环地址 1235。普通不带 DEBUG 启动会自动跑实验并关机。调试模式暂停在 CPU 上电初始状态。

另一个构建机终端：

```bash
cd /你的路径/linux5.15_comment
gdb-multiarch -nx out/x86-lab/vmlinux
```

```gdb
set pagination off
set architecture i386:x86-64
target remote 127.0.0.1:1235
hbreak rest_init
continue
p init_task.pid
p init_task.mm
p init_task.active_mm
```

早期 hbreak 避免在内核尚未装载时写软件断点被覆盖；CPU 硬件断点槽有限，按阶段删除，别同时放几十个。进入内核运行稳定阶段可按需使用普通 break。

本次符号中的编译源路径为 `/home/xuyu.guest/x86-linux-lab-work/linux-src`。迁移后若 GDB 找不到源码，可执行 `set substitute-path /home/xuyu.guest/x86-linux-lab-work/linux-src /你的路径/linux5.15_comment`；映射路径解决查找，不会自动修正源码版本差异。

macOS 连接需经 SSH 转发到 Lima，而不是直接认为 Mac 的 localhost:1235 就是虚拟机。可复用已有 SSH 配置，开独立终端：

```bash
ssh -F "$HOME/.lima/linux-x86-builder/ssh.config" \
  -N -L 127.0.0.1:1235:127.0.0.1:1235 lima-linux-x86-builder
```

该命令只负责隧道。GDB 在 Linux 构建机直接运行时不需要隧道。CLion 如连接 Mac 端口，符号文件选匹配的 out/x86-lab/vmlinux；内核 boot 路线用 -nx 风格独立配置，避免已有 MBR hook 抢占停点。

## 辅助脚本不要盲目 source

本版 `scripts/gdb/vmlinux-gdb.py` 会按自己的 `__file__` 拼 `scripts/gdb` 路径，设计上对应构建输出根的 vmlinux-gdb.py 布置。直接 source 源文件路径可能拼出重复目录，而且 linux.constants 需要构建生成。

在完整、匹配的内核构建目录中执行 `make scripts_gdb` 并保留生成文件，按 `Documentation/dev-tools/gdb-kernel-debugging.rst` 的布局加载构建根 vmlinux-gdb.py。自动加载被拒时，仅给自己信任的构建目录加入 safe-path；不要为了省事全面关闭限制。

辅助可用后：

```gdb
help lx-ps
lx-ps
p $lx_current().pid
p $lx_current().mm
```

本版 `$lx_current()` 返回 task_struct 的值语义，可用点号。在初始 BIOS、per-CPU 未就绪、切换中间态都应慎用。本次 `boot-verify.gdb` 特意只用静态符号和函数实参即可跑通，不依赖生成缺失的辅助文件。

## 实验 A：PID 0 创建谁

在 rest_init 看 init_task；删除该断点，然后停 kernel_clone。第一次打印 `args->flags` 和 `args->stack`，用 `info symbol args->stack` 得到 kernel_init；第二次得到 kthreadd。本树不是 args->fn。

可直接执行已附脚本（应先启动 DEBUG QEMU）：

```bash
gdb-multiarch -nx -batch -x process-study-2026-09-12/gdb/boot-verify.gdb
```

脚本最后 detach，目标继续执行自动实验和关机。它不证明 PID 1/2 的所有内部字段，证据范围是启动 task、两个创建入口以及 kernel_init 命中。若想看创建成功的新 PID，再停 `wake_up_new_task`，此时参数 p 已具备身份。

## 实验 B：fork 看完整的孩子

先准备交互 init（见下一章），guest 运行 `LAB_STEP=1 /process_lab cow`。打印父 PID 后在 GDB 设置目标 `$parent_pid`；辅助脚本可用时：

```gdb
set $parent_pid = 123
break copy_mm if $lx_current().pid == $parent_pid
continue
p/x clone_flags
set $child_task = tsk
p $lx_current().mm
finish
p $child_task->mm
```

注意 finish 后 tsk 局部变量可能已超出作用域。更可靠是在函数体中提前 `set $child_task=tsk`，finish 后打印 `$child_task->mm`，且在子任务被唤醒前观察；不要长时间保留可能释放的指针。

没有 lx_current 时，可用 `wake_up_new_task` 的实参条件，如 `p->real_parent->pid == 123`。每个断点先 `info args`，确认符号可见再编写条件。kernel_clone 入口没有 `p` 子任务局部对象可供过滤。

## 实验 C：锁定一个 COW 地址

记录 cow 程序打印的 address 和子 PID，在孩子 “before COW store” 暂停时设置：

```gdb
set $target_va = 0x12345000
set $child_pid = 124
break do_wp_page if $lx_current().pid == $child_pid && vmf->address == $target_va
continue
p vmf->address
p vmf->vma->vm_mm
p/x vmf->orig_pte
```

地址/PID 是示例，必须替换。若 vmf->address 含不同的页内偏移，应比较按 PAGE_SIZE 对齐的区间。若 do_wp_page 未命中，先排除实验已执行、进程过滤错误、巨页、不同 fault 分支及内联优化；再在 do_user_addr_fault 的 address 参数上观察。

## 实验 D：exec 的新旧 mm

对子任务 exec 前停点设置 `break exec_mmap`。在入口记录传入 `mm` 为新 mm，进入函数并给 tsk/old_mm 赋值后记录旧 mm。源码执行 `tsk->mm=mm` 后再看 task->mm。不要把整个函数 finish 后才拿失效局部变量当证据。

ELF 入口用 `break start_thread`、`info args` 检查 new_ip/new_sp；动态程序 new_ip 可能是解释器入口。主线自动实验是静态 ELF，更易读。

## 实验 E：切栈和回收

切栈选 `__switch_to_asm`，对 RDI/RSI 进行入口 task 指针转换并按 PID 过滤；仅在入口按该 ABI 解释寄存器。退出选 do_exit、exit_mm、exit_notify；回收选 wait_task_zombie、release_task。release_task 可能运行在父进程/其他回收上下文，所以 current==子PID 的条件会漏掉它，应按参数 p->pid 过滤。

## 断点排障表

|问题|先验证|下一步|
|---|---|---|
|停在 0x7c00|是否加载根 .gdbinit|用 -nx 独立启动|
|源码行对不上|vmlinux/bzImage/源码匹配|看函数反汇编与重建记录|
|No symbol optimized out|变量作用域、优化|函数入口参数或保存便利变量|
|没有 context_switch 符号|它是 always_inline|在 __schedule 调用行或汇编入口停|
|lx_current 不存在|脚本布局/生成 constants|先用参数/静态变量，补齐 scripts_gdb|
|GDB thread 与 PID 不符|thread 表示 vCPU|用 lx-ps 或任务参数|
|断点过于频繁|未过滤 PID/地址|每次只留 2～4 个关键点|
|continue 后 init 区断点异常|free_initmem 已回收|重启并在早期捕获，及时删除|

调试记录要写“我在这个函数哪一步、哪个 CPU、哪个 task、哪个 mm”。少一个维度，就很容易把不同执行流拼成错误因果链。
