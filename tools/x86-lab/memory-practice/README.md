# Linux 5.15 内存管理可调试实验包

本目录是现有 `tools/x86-lab` 的独立扩展：复用已经构建好的 `bzImage`、`vmlinux`、BusyBox 根盘和 Lima，不修改内核源码、基础 rootfs、GRUB 或 native 启动链。它只生成 `out/x86-lab/memory-practice/` 下的程序和一块单独实验盘。

第一次学习请以 `src/00_memory_tour.c` 为主：所有用户态申请分支都在这个带详细中文注释的大程序中，函数名稳定，适合 CLion 用户态断点与内核断点连续调试。原来的 `01`～`05` 保留为单项精简对照。

完整教程入口：[`learn-doc/memory-practice-2026-09-12/README.md`](../../../learn-doc/memory-practice-2026-09-12/README.md)。

## 三步启动

Mac 终端 A：

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment
bash tools/x86-lab/memory-practice/build.sh
bash tools/x86-lab/memory-practice/run.sh --gdb
```

进入 guest 后：

```sh
mkdir -p /mnt/mm
mount -o ro /dev/sdb /mnt/mm
/mnt/mm/start-observer-console
/mnt/mm/bin/00_memory_tour mmap
```

Mac 终端 B：

```bash
bash tools/x86-lab/memory-practice/connect-observer.sh
```

终端 B 的 guest shell 中，把程序输出的 PID 代入：

```sh
/mnt/mm/mm-observe PID
cat /proc/PID/maps
cat /proc/PID/smaps_rollup
```

Mac 终端 C（内核源码 GDB）：

```bash
bash tools/x86-lab/memory-practice/gdb-kernel.sh
```

`--gdb` 让 guest 正常启动并在独立端口 1236 等待 GDB 随时附加；`--debug` 让 QEMU 在第一条 CPU 指令前暂停，适合启动期初始化。普通 `run.sh` 不开放 GDB。1236 特意避开现有 direct Lab 的 1234 和旧 user-memory Lab 的 1235。

## 一个主程序，五个对照程序

| 程序 | 观察重点 |
|---|---|
| `00_memory_tour` | 主学习入口；一个源码文件包含 mmap、brk、malloc、populate、fork COW、文件映射 |
| `01_anon_lazy` | `mmap` 先建 VMA、读零页、写缺页、稀疏触页、`MADV_DONTNEED`、`munmap` |
| `02_populate` | 普通 lazy mapping 与 `MAP_POPULATE` 的驻留差异 |
| `03_malloc_brk` | 小对象与大对象、program break、allocator 复用、`free` 不等于必然系统调用 |
| `04_fork_cow` | fork 后父子初始共享、子进程写保护缺页、复制页、父值不变 |
| `05_file_map` | page cache、`MAP_SHARED` 写回、`MAP_PRIVATE` 文件页 COW |

所有程序默认停在 `CHECKPOINT`。统一程序用法：

```sh
/mnt/mm/bin/00_memory_tour mmap
/mnt/mm/bin/00_memory_tour brk
/mnt/mm/bin/00_memory_tour malloc
/mnt/mm/bin/00_memory_tour populate
/mnt/mm/bin/00_memory_tour cow
/mnt/mm/bin/00_memory_tour file
/mnt/mm/bin/00_memory_tour all --auto
```

传 `--auto` 可自动跑完，用于构建后冒烟验证。

## 退出和安全边界

- QEMU 两块磁盘都以 snapshot 模式运行；guest 的修改不会写回基础镜像或实验镜像。
- 实验盘在 guest 中按只读挂载；文件映射实验只写 `/tmp`。
- 退出 QEMU：按 `Ctrl-A`，松开，再按 `x`。
- GDB 通过 QEMU stub 控制整台虚拟机；GDB 停住时，两个 guest 终端都会停住，这是正常现象。
