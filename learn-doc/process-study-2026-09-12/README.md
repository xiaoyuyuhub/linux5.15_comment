# Linux 5.15 进程全链路学习包 · 2026-09-12

专为当前 `linux5.15_comment` 项目整理，独立放在根目录 `process-study-2026-09-12`。主线是 x86-64 Linux 5.15.0，从你已学的内存管理接到进程创建、执行、调度、退出与回收。

**先打开 [离线网页版 index.html](index.html)**：无需联网、无需安装依赖，含章节导航、按全文筛选章节、代码复制、可折叠原码和 9 张 SVG。也可以用 Markdown 编辑器从下面目录阅读。整份 HTML 自带图与源码摘录，单独拷走也能读正文；实验、日志和原仓库文件跳转需要携带相应文件。

## 材料规模与学习方式

- 18 章：17 章讲解/实践，加 1 章当前源码原文。
- 9 张全景、对象关系、流程与时序图；8 棵生命周期主调用树。
- 56 份源码摘录（包含 2 份完整初始化源文件和 54 个函数/汇编入口），保留分支和错误路径。
- 六个可运行实验、GDB 自动启动验证、trace 方案、15 次学习安排及 24 道自测。
- 所有实测结果与未覆盖内容记录在 [验证报告](evidence/验证报告.md)，不把预期写成已经完成的观察。

**建议今天先读 00 → 01 → 02 → 03**，弄清 init_task、初始化设施、PID 1/2 和第一次进入用户态。第二轮学 04～07，从资源关系追到 fork 与 COW。不要第一天展开 copy_process 全部 551 行死磕。

## 按章节阅读

|章节|内容|
|---|---|
|[00 阅读地图](chapters/00-阅读地图.md)|概念对齐、学习顺序、证据约定|
|[01 全链路与内存桥梁](chapters/01-全链路与内存桥梁.md)|身份、资源、执行、生命周期四条线|
|[02 零号任务与初始化设施](chapters/02-零号任务与初始化设施.md)|静态 init_task、sched_init、fork_init、资源缓存、SMP idle|
|[03 一号二号与首次用户态](chapters/03-一号二号与首次用户态.md)|rest_init、kthreadd_done、kernel_init、kernel_execve|
|[04 task_struct 逐层拆解](chapters/04-task_struct逐层拆解.md)|字段、PID/TGID、文件与信号、mm 引用|
|[05 fork 创建事务](chapters/05-fork创建事务精读.md)|copy_process 八阶段、flags、错误回滚、发布与唤醒|
|[06 第一次运行](chapters/06-第一次运行与两个返回值.md)|copy_thread、内核栈框架、RAX=0、ret_from_fork|
|[07 mm 与写时复制](chapters/07-mm与写时复制.md)|mm/VMA/PTE/物理页、COW 与复用、malloc 关联|
|[08 exec 与 ELF](chapters/08-exec与ELF装载.md)|程序文件变执行映像、新 mm、动态解释器、用户入口|
|[09 线程/vfork/kthread](chapters/09-线程vfork与内核线程.md)|资源协议、TLS、clear_child_tid、创建队列|
|[10 调度状态与 CFS](chapters/10-调度状态与CFS.md)|运行队列、5.15 CFS、抢占配置、SMP|
|[11 上下文切换](chapters/11-上下文切换拆到汇编.md)|active_mm、TLB、switch_to、两条 mov 切栈|
|[12 睡眠唤醒](chapters/12-睡眠唤醒和等待条件.md)|pipe、waitqueue、防丢唤醒、completion/futex|
|[13 退出与回收](chapters/13-退出僵尸与回收.md)|do_exit、mmput、zombie、wait、孤儿和 subreaper|
|[14 GDB 实战](chapters/14-GDB实战手册.md)|本项目环境、启动/fork/COW/exec/切换/回收断点|
|[15 内网实验](chapters/15-内网实验与跟踪.md)|六个实验、initramfs、trace、携带清单、每日记录|
|[16 调用树与自测](chapters/16-总调用树与自测.md)|八棵总树、24 题及后续学习入口|
|[17 关键源码原文](chapters/17-关键源码原文.md)|真实工作树摘录、文件行号与 SHA-256 索引|

## 本次已经运行的内容

使用项目已有 `out/x86-lab/bzImage` 和 `vmlinux`，通过 Linux 构建虚拟机中的 QEMU TCG 跑 x86-64 guest；新 initramfs 不挂接已有 rootfs 磁盘。

- [六实验日志](evidence/qemu-lifecycle.log)：全部 PASS，结果码 0。
- [GDB 启动日志](evidence/gdb-boot.log)：PID 0 的 mm/active_mm、两次 kernel_clone 入口、kernel_init 与 ret_from_fork 调用栈。
- [调度跟踪日志](evidence/qemu-trace.log)：pipe 读任务睡眠、唤醒、切入与退出；没有 buffer overrun/dropped events。

逐地址 PFN/COW 页表替换、所有 exec 内部断点、切栈逐指令和 SMP 并发未在本次全部逐项实测，对应章节给出后续实验步骤。

## 在当前 Mac 复现

先确保现有 Lima 构建机在运行，再从项目根目录执行：

```bash
"$HOME/.local/bin/limactl" shell linux-x86-builder -- \
  bash "$PWD/process-study-2026-09-12/labs/build-initramfs.sh"
"$HOME/.local/bin/limactl" shell linux-x86-builder -- \
  bash "$PWD/process-study-2026-09-12/labs/run-qemu.sh"
```

内网 Linux 直接执行两个脚本即可，不需要 Lima 包装；编译器、QEMU 和 BusyBox 要已准备。更多调试命令见 14/15 章。

## 目录约定

`chapters/` 是教材；`diagrams/` 是可放大的离线图；`labs/` 是实验源码与独立产物；`gdb/` 是断点脚本；`evidence/` 是真实记录与索引；`tools/build_book.py` 从 MD 和当前原码生成网页。

修改讲解后，在仓库根执行 `python3 process-study-2026-09-12/tools/build_book.py`。该工具只使用 Python 标准库；第 17 章自动生成，不要手工编辑后期待重建保留。源码文件的许可继续适用于原文摘录。
