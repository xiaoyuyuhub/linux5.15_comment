# 实验入口

完整说明见 [第 15 章](../chapters/15-内网实验与跟踪.md)，本文件是启动速查。

## 在 Linux 构建机

```bash
bash build-initramfs.sh
bash run-qemu.sh
```

脚本自行定位仓库，不依赖当前工作目录；相对脚本路径要按你的目录调整。已有产物 `process_lab` 是 x86-64 静态 ELF。源码更新后 make 会重建；若改变 CC/CFLAGS/LDFLAGS，先 `make clean`，避免误用上次目标架构的二进制。

## GDB 模式

```bash
DEBUG=1 bash run-qemu.sh
```

在另一个构建机终端，从**仓库根目录**执行：

```bash
gdb-multiarch -nx -batch -x process-study-2026-09-12/gdb/boot-verify.gdb
```

## 使用独立 trace initramfs

以下从 labs 目录执行，不改默认 init：

```bash
INIT_SCRIPT="$PWD/init-trace.sh" \
INITRAMFS_OUTPUT="$PWD/trace-initramfs.cpio.gz" bash build-initramfs.sh
INITRD="$PWD/trace-initramfs.cpio.gz" bash run-qemu.sh
```

输出包括 TRACE_BEGIN、事件、TRACE_STATS 和 TRACE_RESULT。采用最小 BusyBox shell 方案；Bash 的 `trace.sh` 则适用于安装 bash 的实验 rootfs。

## 参数

|参数|作用|
|---|---|
|CC|构建实验的编译器，默认 x86_64-linux-gnu-gcc|
|BUSYBOX|x86-64 静态 BusyBox 路径|
|INIT_SCRIPT|打包为 /init 的脚本，默认本目录 init|
|INITRAMFS_OUTPUT|输出 initramfs 路径|
|KERNEL|启动内核，默认原项目 out/x86-lab/bzImage|
|INITRD|启动 initramfs，默认本目录 initramfs.cpio.gz|
|DEBUG=1|QEMU 上电暂停并打开回环 GDB 端口|
|GDB_PORT|调试端口，默认 1235|
|CPUS|vCPU 数量，默认 1，学习 SMP 时再提高|
|LAB_STEP=1|在 guest 单实验命令前设置，在 CHECKPOINT 等 Enter|

任何使用步骤都要分清 Mac、Linux 构建机、QEMU guest 三层；目标 PID 和 /proc 观察发生在 guest。
