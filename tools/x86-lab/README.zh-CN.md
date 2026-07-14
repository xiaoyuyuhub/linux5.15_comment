# Apple Silicon Mac 交叉编译并运行 x86_64 Linux 5.15

这套实验把三种架构角色明确分开：

- Mac 宿主：Apple Silicon arm64。
- 构建机：Lima + Apple Virtualization.framework 运行的 Ubuntu arm64。
- 目标机：GNU 交叉工具链生成的 x86_64 Linux 5.15 与 BusyBox，由 QEMU TCG 模拟。

之所以增加一个轻量 Linux 构建机，是因为 Linux 5.15 的 Kbuild 会先编译并运行若干 host tools；macOS 缺少这些工具依赖的 Linux/ELF 环境。构建机仍然是 ARM64，所以 `x86_64-linux-gnu-gcc` 确实在做交叉编译。

这份文档既是操作教程，也是本实验的设计记录。建议第一次按“首次完整搭建”顺序执行；以后按“常用场景速查”操作，遇到问题再查对应原理和故障排查章节。

## 目录

- [先建立正确的三层模型](#先建立正确的三层模型)
- [脚本与配置文件总览](#脚本与配置文件总览)
- [一键流程](#一键流程)
- [实际 QEMU 命令](#实际-qemu-命令)
- [构建产物](#构建产物)
- [手工理解构建步骤](#手工理解构建步骤)
- [使用 GDB / CLion 调试内核](#使用-gdb--clion-调试内核)
- [纯硬盘启动](#纯硬盘启动seabios--mbr--grub2--linux)
- [让 CLion 正确索引和跳转](#让-clion-正确索引和跳转-linux-源码)
- [调试这些 Bash 脚本](#调试这些-bash-脚本)
- [常用场景速查](#常用场景速查)
- [故障排查](#故障排查)

## 先建立正确的三层模型

```text
Apple Silicon Mac (arm64)
├── 保存并编辑源码：/Users/xuyu/Desktop/code/linux5.15_comment
├── 运行 CLion、Mac 版 GDB 客户端和 limactl
└── Apple Virtualization.framework / VZ
    └── Lima Ubuntu 22.04 (arm64)
        ├── 私有 ext4：/home/xuyu.guest/x86-linux-lab-work
        ├── x86_64-linux-gnu-gcc：ARM64 上生成 x86_64 代码
        └── qemu-system-x86_64 + TCG
            └── Linux 5.15 + BusyBox (x86_64 客体)
```

这里有两次架构转换，但性质不同：

1. `x86_64-linux-gnu-gcc` 是交叉编译：编译器进程运行在 ARM64 Linux，输出 x86_64 ELF。
2. `qemu-system-x86_64` 是指令模拟：TCG 在运行时把 x86 指令翻译成 ARM64 指令。

不能在 Apple Silicon 上对 x86 客体使用 KVM，因为 KVM 要求宿主和客体 CPU 架构匹配；这里使用 TCG 是正确方案。Lima 本身使用 VZ 快速运行 ARM64 Ubuntu，耗时的 Kbuild host tools 因而可以原生 ARM64 执行。

### 为什么 Mac 看不到 `/home/xuyu.guest`

`/home/xuyu.guest` 是 Lima 虚拟磁盘中 Ubuntu 的目录，不是 macOS 目录。Mac Finder、Terminal 和 CLion 的本地文件选择器自然看不到它。进入 VM 后才可查看：

```bash
~/.local/bin/limactl shell linux-x86-builder
pwd
ls -la /home/xuyu.guest/x86-linux-lab-work
```

反方向则不同：Lima 把 Mac 的 `/Users/xuyu/Desktop/code/linux5.15_comment` 共享进 VM，所以 VM 可以看到这个 Mac 路径。这不表示 Mac 也会自动挂载 VM 的 `/home`。

### 为什么 Remote Debug 仍要配置 Path Mapping

`vmlinux` 的 DWARF 调试信息记录的是编译时源文件名，例如：

```text
/home/xuyu.guest/x86-linux-lab-work/linux-src/init/main.c
```

CLion/GDB 客户端运行在 Mac，必须把这段“符号中的远端文件名”翻译成真实本地文件：

```text
远端前缀 /home/xuyu.guest/x86-linux-lab-work/linux-src
   ↓ Path Mapping
本地前缀 /Users/xuyu/Desktop/code/linux5.15_comment
```

Path Mapping 是字符串路径翻译规则，不是目录挂载，也不会在 Mac 创建 `/home/xuyu.guest`。因此“Mac 看不到远端目录”和“调试需要映射远端目录”完全不矛盾。

## 脚本与配置文件总览

| 文件 | 在哪运行 | 用途 |
|---|---|---|
| `debug-lib.sh` | Mac 或 Lima | 所有 Bash 脚本共用的 trace、变量快照、学习断点和错误现场函数 |
| `bootstrap-mac.sh` | Mac，部分命令下发到 VM | 安装 Lima、创建 ARM64 Ubuntu、安装交叉工具链/QEMU/GDB/镜像工具 |
| `build.sh` | Mac | 主构建包装器，把参数传给 Lima |
| `build-in-vm.sh` | Lima | 同步源码、编译内核/BusyBox、制作基础 ext4、导出产物 |
| `verify.sh` | Mac + Lima | 无人值守启动快速路径，验证架构、根盘和文件系统 |
| `run.sh` | Mac + Lima | 用 `-kernel` 快速进入内核与 BusyBox |
| `run-debug.sh` | Mac + Lima | 快速路径加 `-S/-gdb` 和 SSH 端口转发 |
| `build-grub-disk.sh` | Mac | 完整硬盘镜像包装器 |
| `build-grub-disk-in-vm.sh` | Lima | 分区、loop 挂载、复制系统、安装 GRUB BIOS |
| `run-grub.sh` | Mac + Lima | 只用 `-hda` 从完整硬盘启动 |
| `run-grub-debug.sh` | Mac + Lima | 从 reset vector 调试 BIOS/MBR/GRUB |
| `setup-clion.sh` | Mac + Lima | 生成并改写 Compilation Database，复制生成头文件 |
| `rootfs/init` | x86 客体 | 最小系统 PID 1，挂载伪文件系统并启动 shell |
| `grub.cfg` | GRUB | 串口菜单、内核位置和 `root=/dev/sda1` 参数 |

所有脚本都使用 `set -euo pipefail`：命令失败、未定义变量或管道中间失败都会让脚本停止。这样错误会尽量出现在真正失败的位置，而不是几十条命令后才表现为损坏的镜像。

## 一键流程

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment

# 1. 安装 Lima、创建 Ubuntu arm64 VM、安装交叉工具链和 QEMU
tools/x86-lab/bootstrap-mac.sh

# 2. 构建 x86_64 bzImage、静态 BusyBox 和 256 MiB ext4 镜像
tools/x86-lab/build.sh

# 3. 自动启动并验证 x86_64、/dev/sda 和内核命令行
tools/x86-lab/verify.sh

# 4. 进入交互式 BusyBox shell；退出 QEMU 用 Ctrl-A X
tools/x86-lab/run.sh
```

首次完整搭建建议继续生成两项派生产物：

```bash
# 让 CLion 获得跨文件跳转所需的真实 Kbuild 编译数据库
tools/x86-lab/setup-clion.sh

# 制作包含 MBR、GRUB、内核和 rootfs 的完整硬盘
tools/x86-lab/build-grub-disk.sh

# 从硬盘原生引导
tools/x86-lab/run-grub.sh
```

## 实际 QEMU 命令

`run.sh` 最终在 ARM64 Linux 构建机内执行：

```bash
qemu-system-x86_64 \
  -machine pc -accel tcg,thread=single \
  -cpu max -m 512M -smp 2 \
  -kernel out/x86-lab/bzImage \
  -hda out/x86-lab/rootfs.ext4 \
  -append "root=/dev/sda rw console=ttyS0 init=/init" \
  -nographic -no-reboot
```

关键点：

- `-kernel` 让 QEMU/SeaBIOS 直接加载 `bzImage`，本实验因此不需要 GRUB。
- `-hda` 把 ext4 镜像接到传统 PC 的 IDE 控制器，Linux 的 libata 将其识别为 `/dev/sda`。
- `-hda` 是兼容旧用法，QEMU 会提示 raw 格式由探测得出；本实验保留它是为了对应 Linux 上常见的教学命令。
- `root=/dev/sda rw` 指定硬盘根文件系统，而不是 initramfs。
- `console=ttyS0` 把内核日志和 BusyBox shell 放到串口终端。
- `init=/init` 运行镜像中的教学用启动脚本。
- `/init` 挂载 devtmpfs、proc、sysfs 和 tmpfs，随后通过 `setsid cttyhack` 启动带控制终端的 BusyBox shell。
- Apple Silicon 不能用 KVM 加速 x86，因此使用 QEMU TCG；构建由原生 ARM64 VM 完成，只有目标系统运行需要指令模拟。QEMU 6.2 在 ARM host 上对 x86 多线程 TCG 会提示强内存序风险，因此脚本使用更稳妥的 `thread=single`。

## 构建产物

产物位于 `out/x86-lab/`，该目录已被 Git 忽略：

- `bzImage`：Linux 5.15 x86_64 压缩内核。
- `vmlinux`：未压缩、带 DWARF4 调试信息的 x86_64 ELF，供 GDB/CLion 使用。
- `rootfs.ext4`：可通过 `-hda` 使用的 ext4 硬盘镜像。
- `busybox`：静态链接的 x86_64 BusyBox。
- `kernel.config`、`busybox.config`：本次可复现配置。
- `SHA256SUMS`：产物校验值。
- `qemu-boot.log`：自动启动验证记录。

## 手工理解构建步骤

内核构建的核心命令是：

```bash
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- x86_64_defconfig
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- olddefconfig
make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- -j6 bzImage
```

脚本只在 Lima 本地磁盘中的源码副本上先执行 `mrproper`。这是因为本教学仓库保存了一份顶层 `.config`，而 Kbuild 的 `O=...` 构建要求用于编译的源码副本不含旧配置；Mac 上的原始源码与注释不会被清理。

macOS 默认卷大小写不敏感，而内核同时存在 `xt_TCPMSS.c`/`xt_tcpmss.c` 等文件。脚本会从 Git 索引读取两个独立 blob，并在 Lima 的大小写敏感 ext4 中恢复它们；否则 Kbuild 会报 `No rule to make target 'net/netfilter/xt_TCPMSS.o'`。普通未提交源码修改仍由 `rsync` 同步。若确实要修改大小写冲突文件，建议直接在 Lima 的源码副本或大小写敏感 APFS 卷中操作。

默认构建保留 VM 中的目标文件以便失败后增量重试。需要完全清理时运行：

```bash
CLEAN_BUILD=1 tools/x86-lab/build.sh
```

BusyBox 使用同一交叉编译前缀，并启用 `CONFIG_STATIC=y`。静态链接避免 rootfs 还要复制 x86_64 glibc 动态加载器和共享库。

Ubuntu 22.04 的 `libc6-dev-amd64-cross` 有一个路径细节：`libm.a` linker script 引用 `/usr/lib/x86_64-linux-gnu`，实际归档却位于 `/usr/x86_64-linux-gnu/lib`。bootstrap/build 脚本只为 `libm-*.a` 和 `libmvec.a` 建立兼容软链接，使 BusyBox 能静态链接；不会替换宿主 ARM64 库。

镜像由 `mke2fs -d rootfs rootfs.ext4` 直接填充，不需要在 macOS 上挂载 ext4，也不会碰 macOS 的磁盘设备。

## 常用维护命令

```bash
# 查看构建 VM
~/.local/bin/limactl list

# 进入构建 VM
~/.local/bin/limactl shell linux-x86-builder

# 停止 VM（构建结果仍保留）
~/.local/bin/limactl stop linux-x86-builder

# 完全删除 VM
~/.local/bin/limactl delete linux-x86-builder
```

如果在中国大陆以外使用，可让 bootstrap 使用 Ubuntu 官方源：

```bash
APT_MIRROR='' tools/x86-lab/bootstrap-mac.sh
```

## 本机验证记录（2026-07-10）

- Mac：Apple Silicon arm64，24 GiB 内存。
- Lima：2.1.4，VZ arm64 VM，6 CPU / 10 GiB RAM。
- 交叉编译器：`x86_64-linux-gnu-gcc 11.4.0`，Binutils 2.38。
- QEMU：6.2.0，TCG single-thread。
- 内核：Linux 5.15.0 x86_64，`bzImage` 约 9.2 MiB。
- BusyBox：1.36.1，x86-64 静态 ELF，约 2.5 MiB。
- 磁盘：256 MiB raw ext4，QEMU IDE/libata 识别为 `/dev/sda`。
- 验证：成功挂载 ext4 root、执行 `/init`、输出 `x86_64` 并通过 ACPI S5 关机。

完整启动日志保存在 `out/x86-lab/qemu-boot.log`，构建产物哈希保存在 `out/x86-lab/SHA256SUMS`。

验证脚本使用 `poweroff -f` 结束最小系统。由于这里没有完整 init 系统负责卸载 `/`，脚本会在 QEMU 退出后对镜像执行离线 `e2fsck`，再重新生成 `SHA256SUMS`，保证交付镜像处于 clean 状态且哈希没有过期。

## 使用 GDB / CLion 调试内核

普通的 `bzImage` 用于启动；源码级调试使用构建脚本额外导出的 `out/x86-lab/vmlinux`。内核配置开启了 `CONFIG_DEBUG_INFO=y`、DWARF4 和 `CONFIG_GDB_SCRIPTS=y`，同时关闭 KASLR，避免运行地址与符号地址发生随机偏移。

先在终端启动暂停状态的 QEMU：

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment
tools/x86-lab/run-debug.sh
```

脚本会给 QEMU 增加 `-S -gdb tcp:127.0.0.1:1234`。QEMU 实际运行在 Lima 内，脚本同时建立 SSH 隧道，把 Mac 的 `127.0.0.1:1234` 转发到 Lima。终端必须保持运行。

在 CLion 中打开本仓库，然后选择 **Run | Edit Configurations | + | Remote Debug**：

- Debugger：`Bundled GDB`。CLion 的 bundled GDB 支持 `x86_64-linux-gnu` 远程目标。
- `target remote` args：`127.0.0.1:1234`。
- Symbol file：`/Users/xuyu/Desktop/code/linux5.15_comment/out/x86-lab/vmlinux`。
- Sysroot：内核本身不依赖用户态动态库，留空即可。
- Path mappings：远端 `/home/xuyu.guest/x86-linux-lab-work/linux-src` 映射到本地 `/Users/xuyu/Desktop/code/linux5.15_comment`。这是当前 Lima 实例写入 DWARF 的源码路径。

开始 Debug 后，先在 `init/main.c` 的 `start_kernel()` 设置断点，再点击 Resume。也可以在 GDB Console 中使用：

```gdb
break start_kernel
continue
info registers
bt
```

若要调试更晚的启动路径，可以在 `rest_init`、`kernel_init`、`do_mount_root` 或本仓库关注的函数处设置断点。`run-debug.sh` 使用 `-S`，所以每次重新调试都从 CPU 尚未执行的状态开始；不需要在 BusyBox 中运行 `gdbserver`。

结束时在 QEMU 终端按 `Ctrl-A X`。脚本退出后会自动关闭 SSH 隧道。若 1234 已被占用，可以让脚本与 CLion 同时改用其他端口，例如：

```bash
GDB_PORT=1235 tools/x86-lab/run-debug.sh
```

## 纯硬盘启动：SeaBIOS + MBR + GRUB2 + Linux

如果要研究传统 PC 从上电到 Linux 的完整启动链，应使用 GRUB 硬盘镜像，而不是 QEMU `-kernel` 快速加载：

```text
CPU reset → SeaBIOS → MBR(0x7c00) → GRUB2 core.img
          → /boot/grub/grub.cfg → /boot/bzImage
          → Linux → /dev/sda1 → /init → BusyBox
```

构建和运行：

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment

# 先确保 bzImage、BusyBox 和基础 rootfs 已存在
tools/x86-lab/build.sh

# 制作 512 MiB、MBR 分区表、GRUB2 i386-pc 的完整硬盘
tools/x86-lab/build-grub-disk.sh

# 只从硬盘启动；退出使用 Ctrl-A X
tools/x86-lab/run-grub.sh
```

实际 QEMU 命令的关键部分只有：

```bash
qemu-system-x86_64 \
  -machine pc -accel tcg,thread=single \
  -cpu max -m 512M -smp 2 \
  -hda out/x86-lab/grub-bios-disk.img \
  -boot c -nographic -no-reboot
```

这里没有 `-kernel`、`-append` 或 `-initrd`。内核参数来自硬盘中的 `/boot/grub/grub.cfg`，内核文件也位于第一分区的 `/boot/bzImage`。

磁盘布局：

```text
LBA 0             GRUB boot.img + MBR partition table + 0x55aa
LBA 1..2047       1 MiB embedding gap，GRUB core.img 位于其中
LBA 2048..end     bootable ext4 primary partition (/dev/sda1)
                   ├── /boot/bzImage
                   ├── /boot/grub/grub.cfg
                   ├── /bin/busybox
                   └── /init
```

ARM64 Ubuntu 没有发行 `grub-pc-bin` 包。脚本从 Ubuntu 官方仓库下载与本机 `grub-install 2.06` 匹配的 amd64 包，固定校验 SHA-256，只提取 `/usr/lib/grub/i386-pc` 平台模块；真正执行安装的是 ARM64 原生 `grub-install --target=i386-pc`。GRUB 安装到临时 loop 磁盘的 MBR，不会操作 Mac 或 Lima 的物理磁盘。

产物：

- `out/x86-lab/grub-bios-disk.img`：完整可启动 raw 硬盘。
- `out/x86-lab/grub-mbr.bin`：单独导出的 LBA 0，便于反汇编。
- `out/x86-lab/grub-boot-region.bin`：MBR 加前 1 MiB embedding 区域。
- `out/x86-lab/qemu-grub-boot.log`：SeaBIOS、GRUB、Linux 和 BusyBox 的完整串口日志。

### 从 reset vector 调试到 0x7c00

启动暂停态 QEMU：

```bash
tools/x86-lab/run-grub-debug.sh
```

此脚本同样把 Lima 中 QEMU 的 GDB Stub 转发到 Mac `127.0.0.1:1234`，但 QEMU 使用 `-S` 在 CPU reset vector 执行前暂停，并且仍然只提供 `-hda`。

#### CLion 连接后自动继续的问题

CLion Remote Debug 连接完成后可能立即继续目标。虽然 QEMU 的 `-S` 确实让 CPU 初始停在 reset vector，但如果等 CLion 界面可操作后再手工输入 `hbreak *0x7c00`，BIOS 往往已经越过 MBR 地址。

本项目通过根目录 `.gdbinit` 的连接后钩子解决这个竞态：

```gdb
define target hookpost-remote
  echo [x86-lab] remote connected; installing hardware breakpoint at 0x7c00\n
  hbreak *0x7c00
end
```

`hookpost-remote` 在 `target remote 127.0.0.1:1234` 成功之后、目标继续之前执行，因此断点不是由人手工抢时间设置。Mac 的 `~/.gdbinit` 只授权加载当前项目的初始化文件：

```gdb
set auto-load local-gdbinit on
add-auto-load-safe-path /Users/xuyu/Desktop/code/linux5.15_comment/.gdbinit
```

停止当前调试会话，再重新启动一次 CLion Remote Debug 后，正常顺序变成：

```text
run-grub-debug.sh 用 -S 暂停 QEMU
→ CLion target remote 连接
→ hookpost-remote 自动执行 hbreak *0x7c00
→ CLion 继续目标
→ BIOS 读取 MBR
→ CPU 在 0x7c00 首条指令前停止
```

GDB Console 应显示：

```text
[x86-lab] remote connected; installing hardware breakpoint at 0x7c00
Hardware assisted breakpoint 1 at 0x7c00
```

如果本次只想直接调试 Linux 内核，可在连接并命中 `0x7c00` 后执行 `delete 1` 再 `continue`；或者临时把项目 `.gdbinit` 中的 `hbreak` 注释掉。

在 CLion 新建一个 **Remote Debug**，Debugger 选择 Bundled GDB，连接 `127.0.0.1:1234`。Symbol file 可以先用 `out/x86-lab/vmlinux`；BIOS/MBR/GRUB 阶段没有对应的 Linux 源码符号，主要看寄存器、内存和原始指令。在 GDB Console 中：

```gdb
# BIOS 会把启动盘 LBA 0 读到物理地址 0x7c00
hbreak *0x7c00
continue

info registers
x/32bx 0x7c00
x/16i 0x7c00
```

本机验证时，GDB 初始停在 reset 状态的 `$pc=0xfff0`，随后硬件断点确实命中 `$pc=0x7c00`。QEMU GDB Stub 会把 CPU 描述为 x86-64，因此 GDB 对 16 位 MBR 的实时反汇编可能用错操作数宽度；查看原始字节没有问题，精确的 16 位离线反汇编使用：

```bash
~/.local/bin/limactl shell linux-x86-builder -- \
  x86_64-linux-gnu-objdump -D -b binary -m i8086 \
  /Users/xuyu/Desktop/code/linux5.15_comment/out/x86-lab/grub-mbr.bin
```

你提到的 `0x10000` 是传统 Image/zImage protected-mode 部分的加载地址。当前是 `bzImage` 且 `LOAD_HIGH=1`，Linux boot protocol 规定 protected-mode kernel 默认加载到 `0x100000`；real-mode setup/boot parameters 仍在低端内存，但 GRUB 的具体布局和跳转应结合 `boot_params.hdr.code32_start` 观察。因此后续可设置：

```gdb
hbreak *0x100000
break start_kernel
continue
```

相关内核协议以本仓库 `Documentation/x86/boot.rst` 和 `arch/x86/boot/header.S` 为准。

## 让 CLion 正确索引和跳转 Linux 源码

`vmlinux` 解决的是运行时调试符号，不能替代 CLion 的静态代码模型。Linux 使用 Kbuild，并且大量配置宏和头文件是在构建过程中生成的；如果只用 CLion 打开源码目录，IDE 不知道每个 `.c` 文件的真实编译参数，函数跳转、宏展开和条件编译识别都会不完整。

每次完整构建后运行：

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment
tools/x86-lab/setup-clion.sh
```

脚本完成三件事：

1. 使用内核自带的 `scripts/clang-tools/gen_compile_commands.py` 从真实 Kbuild `.cmd` 文件生成编译数据库。
2. 把 Lima 构建目录中的 generated headers 和交叉 GCC 内建头文件同步到 `out/x86-lab/clion-build/`。
3. 把数据库中的 Linux VM 路径改写为 Mac 本地路径，并生成项目根目录的 `compile_commands.json`。

首次配置时不要只是打开源码文件夹。在 CLion 中执行 **File | Close Project**，然后：

1. **File | Open**。
2. 选择 `/Users/xuyu/Desktop/code/linux5.15_comment/compile_commands.json`。
3. 点击 **Open as Project**。
4. 如果询问 Toolchain，选择 Mac 本机的默认 Clang toolchain。
5. 等待右下角索引完成，再测试 `Command-B`、`Command-点击`、**Go to Definition** 和 **Find Usages**。

以后重新构建或修改内核配置后，再运行一次 `setup-clion.sh`，随后在 CLion 选择 **Tools | Compilation Database | Reload Compilation Database Project**。也可以在 **Settings | Build, Execution, Deployment | Build Tools** 把自动同步改为 **Any changes**。

生成的根目录 `compile_commands.json` 和 `out/x86-lab/clion-build/` 都是本机路径相关的派生产物，已经被 Git 忽略，不应该提交。Compilation Database 模式用于导航和代码分析；真正编译仍使用 `tools/x86-lab/build.sh`，内核运行调试仍使用 `tools/x86-lab/run-debug.sh`。

### 只有当前文件能跳转、跨文件不能跳转时

这通常不是缺少 `vmlinux`，而是 CLion 没把项目加载为 Compilation Database 项目。`vmlinux` 服务于运行时 GDB；`compile_commands.json` 才告诉静态索引器每个 `.c` 文件使用哪些 `-I`、`-D`、生成头和架构参数。

按以下顺序彻底检查：

1. 先确认数据库确实有数千条记录，而不是空文件：

   ```bash
   python3 -c 'import json; d=json.load(open("compile_commands.json")); print(len(d))'
   ```

   当前验证结果是 2579 条命令；由于同一源码可能存在不同构建命令，CLion 最终显示的唯一源文件数略少属于正常现象。

2. 在 CLion 的项目设置中确认项目类型是 Compilation Database。若 `.idea/misc.xml` 中仍是 `MakefileSettings`，说明以前“打开源码文件夹”留下的 Makefile 项目配置正在覆盖新数据库。

3. 关闭项目，备份或移走旧 `.idea`，再直接选择 `compile_commands.json` 并点击 **Open as Project**。不要先打开源码目录后再双击 JSON。

4. 等待索引结束。右下角仍在 Indexing 时，跨文件跳转不完整是预期现象。

5. 用确定存在的符号测试：在 `init/main.c` 中对 `page_alloc_init()` 使用 `Command-B`，应跳到 `mm/page_alloc.c`。

6. 修改 `.config` 或重新构建后，再执行：

   ```bash
   tools/x86-lab/setup-clion.sh
   ```

   然后在 CLion 执行 **Tools | Compilation Database | Reload Compilation Database Project**。

当前机器上曾经出现的真实根因就是旧 `.idea/misc.xml` 中的 `MakefileSettings`。旧配置已备份到 `out/x86-lab/idea-backup-makefile-20260711-1028`，重新以 Compilation Database 项目打开后，跨文件 `page_alloc_init()` 跳转已经验证成功。

### CLion Remote Debug 推荐配置清单

| 设置项 | 值 |
|---|---|
| 配置类型 | Remote Debug |
| Debugger | Bundled GDB |
| Target | `127.0.0.1:1234` |
| Symbol file | `/Users/xuyu/Desktop/code/linux5.15_comment/out/x86-lab/vmlinux` |
| Sysroot | 留空 |
| 远端源码前缀 | `/home/xuyu.guest/x86-linux-lab-work/linux-src` |
| 本地源码前缀 | `/Users/xuyu/Desktop/code/linux5.15_comment` |

静态导航和远程调试是两套相互补充但互不替代的机制：

```text
compile_commands.json -> CLion 静态索引 -> 未运行也能跨文件跳转
vmlinux + GDB + Path Mapping -> 运行时调试 -> 断点、变量、寄存器、调用栈
```

## 调试这些 Bash 脚本

Bash 脚本是解释执行的，没有像 C/内核那样统一使用 GDB 的 DWARF 断点。CLion 可以编辑、运行和检查 Shell 脚本，但默认并不提供等价于 C/C++ Debugger 的 Bash 逐行断点、局部变量窗口。最可靠的方法是语法检查、执行跟踪、条件暂停和缩小到 VM 内脚本。

本目录所有 Bash 脚本已经接入 [debug-lib.sh](./debug-lib.sh)。正常运行时调试功能完全关闭；不需要改脚本，只需在原命令前增加环境变量。

### 调试框架的底层原理

先明确边界：这不是 GDB 那种机器指令级调试器。Bash 脚本由解释器读取、解析、展开并执行，本项目利用 Bash 自带的执行跟踪、变量反射、异常钩子、标准输入和文件描述符，组合成一套轻量调试框架：

```text
DEBUG_* 环境变量
        ↓
流程脚本 source debug-lib.sh
        ↓
xlab_debug_init
        ├── set -x + PS4        → 打印展开后的实际命令
        ├── declare -p          → 打印变量类型和值
        ├── read                → 在阶段边界模拟断点
        ├── trap ERR            → 捕获非预期失败
        ├── caller              → 打印 Bash 函数调用栈
        └── fd / tee            → 把调试输出保存到日志
```

#### 1. Bash 在什么时刻打印命令

Bash 不会先把整个脚本编译为机器码。对于下面的代码：

```bash
name="linux"
echo "hello $name"
```

解释器大致执行：

```text
读取命令 → 识别命令和引号 → 展开 $name → 得到 echo "hello linux" → 执行 echo
```

`set -x`，也叫 xtrace，会在参数展开完成后、命令真正执行前打印命令：

```bash
name="linux"
set -x
echo "hello $name"
set +x
```

输出类似：

```text
+ echo 'hello linux'
hello linux
+ set +x
```

第一行是 Bash 跟踪，第二行才是程序正常输出。因为跟踪中已经完成变量、命令替换和通配符展开，所以它非常适合发现空变量、错误路径和引号问题；也正因为如此，trace 可能暴露密码或 Token，分享日志前必须检查。

本项目在初始化函数中根据开关执行：

```bash
if [[ "${DEBUG_TRACE:-0}" == "1" ]]; then
  set -x
fi
```

`set +x` 则关闭后续跟踪。错误处理函数进入后会先关闭 xtrace，避免打印错误报告的命令本身形成大量噪声。

#### 2. `PS4` 如何加入文件、行号和函数

Bash 用 `PS4` 作为每条 xtrace 的前缀。公共库设置：

```bash
export PS4='+ [${BASH_SOURCE##*/}:${LINENO}:${FUNCNAME[0]:-main}] '
```

各部分含义：

- `BASH_SOURCE`：当前正在执行的脚本文件。
- `${BASH_SOURCE##*/}`：删除目录前缀，只留下文件名。
- `LINENO`：当前执行命令的行号。
- `FUNCNAME[0]`：当前 Bash 函数名。
- `${FUNCNAME[0]:-main}`：不在函数中时显示 `main`。

于是：

```text
+ [build-in-vm.sh:83:main] make -C /home/xuyu.guest/... bzImage
```

表示 `build-in-vm.sh` 第 83 行、脚本顶层即将执行展开后的 `make`。命令替换存在嵌套层次时可能出现 `++`、`+++`；加号越多通常表示当前 trace 越深，而不是命令内容的一部分。

#### 3. 环境变量为什么能控制一次运行

命令前的赋值：

```bash
DEBUG_TRACE=1 DEBUG_ERRORS=1 tools/x86-lab/build.sh
```

表示只为新启动的 `build.sh` 进程设置环境变量。它近似于先 `export` 再执行，但不会永久改变当前终端后续命令的环境。

脚本使用：

```bash
"${DEBUG_TRACE:-0}"
```

读取开关：变量已定义且非空就使用其值，否则使用默认值 `0`。公共库会验证四个布尔开关只能是 `0` 或 `1`，因此 `DEBUG_TRACE=yes` 不会被悄悄误判。

#### 4. `source` 为什么能安装调试函数

每个脚本开头执行：

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "$SCRIPT_DIR/debug-lib.sh"
xlab_debug_init
```

直接运行 `bash debug-lib.sh` 会创建子 Bash，子进程结束后函数随之消失；`source` 则让当前 Bash 直接读取文件，因此 `xlab_debug_init`、`xlab_debug_point`、`xlab_debug_error` 等函数进入当前脚本环境。

`BASH_SOURCE[0]` 比 `$0` 更适合定位被 source 的文件自身。公共库还用 `XLAB_DEBUG_LIB_LOADED` 防止同一进程重复 source 后重复安装 trap 或打开日志文件。

#### 5. `declare -p` 和间接变量展开如何打印变量

调试点传入的是变量名，不是已经展开的值：

```bash
xlab_debug_point "路径已解析" REPO_ROOT KERNEL_SRC JOBS
```

公共库可以使用间接展开：

```bash
name="DEBUG_TRACE"
value="${!name:-0}"
```

如果 `name` 的内容是 `DEBUG_TRACE`，`${!name}` 就会继续读取 `DEBUG_TRACE` 的值。

真正输出变量时使用：

```bash
declare -p "$name"
```

而不是 `echo`。`declare -p` 可以保留普通变量、数组、下标、引号、空格和特殊字符，例如：

```text
declare -- KERNEL_SRC="/home/xuyu.guest/x86-linux-lab-work/linux-src"
declare -a required='([0]="make" [1]="rsync")'
```

公共库先用正则表达式确认名称符合 Shell 变量命名规则，再读取变量，避免把任意字符串当成动态变量表达式。

#### 6. `read` 如何模拟学习断点

Shell 没有自动保存 CPU 状态的源码断点。`DEBUG_STEP=1` 在预先选择的阶段边界调用：

```bash
IFS= read -r answer
```

`read` 等待 stdin 输入，因此 Bash 暂停在这一行。按 Enter 后继续；输入 `q` 时函数返回 `130`，用常见的 SIGINT 风格退出码表示用户主动终止。

调用 `read` 前会检查：

```bash
[[ -t 0 ]]
```

文件描述符 `0` 是 stdin，`-t` 判断它是否连接真实终端。CI、输入重定向或某些 IDE Console 中没有交互终端，此时自动跳过暂停，避免脚本永久卡住。

这类断点只能停在脚本主动调用 `xlab_debug_point` 的位置，不能像 GDB 一样随意点击任意一行；优势是实现简单，并且暂停时可以另开终端检查目录、进程、loop 设备和挂载状态。

#### 7. `trap ERR` 如何捕获失败

开启错误调试后，公共库执行：

```bash
set -E
trap 'xlab_debug_error "$?" "$LINENO" "$BASH_COMMAND"' ERR
```

- `trap ... ERR`：Bash 判断命令失败时调用指定处理器。
- `$?`：刚刚失败命令的退出码，必须第一时间保存，否则会被下一条命令覆盖。
- `LINENO`：失败位置附近的行号。
- `BASH_COMMAND`：失败时 Bash 正在执行的命令。
- `set -E`：也叫 `errtrace`，让 ERR trap 更深入地继承到函数、子 shell 和命令替换。

错误函数使用 `BASH_SOURCE` 尽量找到真正的流程脚本，再循环调用：

```bash
caller 0
caller 1
caller 2
```

`caller` 返回调用者的行号、函数名和文件名，直到没有更上一层，从而形成简易调用栈。打印完成后函数使用：

```bash
return "$status"
```

返回原始错误码，避免调试输出成功后把真正的失败错误地变成成功。

常见退出码包括：

| 退出码 | 常见含义 |
|---:|---|
| `0` | 成功 |
| `1` | 普通失败，需要结合命令输出判断 |
| `2` | 参数或语法类错误 |
| `124` | `timeout` 超时 |
| `126` | 文件存在但不可执行 |
| `127` | 命令不存在 |
| `130` | Ctrl-C 或用户主动中止 |

ERR trap 有 Bash 语义上的例外：命令位于 `if`/`while` 条件、`&&`、`||` 等“脚本本来就在检查成功与否”的位置时，非零状态不一定触发 trap。它不是对所有非零返回值的无条件拦截。

#### 8. `set -euo pipefail` 如何帮助暴露错误

流程脚本通常以：

```bash
set -euo pipefail
```

开始：

- `set -e`：未被显式处理的失败通常会终止脚本。
- `set -u`：读取未定义变量时报错；可选值应写成 `${VALUE:-default}`。
- `set -o pipefail`：管道中间命令失败时，不再只看最后一个命令的成功状态。

例如默认情况下 `false | tee log` 可能因为 `tee` 成功而表现为成功；开启 `pipefail` 后，前面的失败可以向外传播。`verify.sh` 某些位置会有意识地临时 `set +e`，读取 `PIPESTATUS` 或保存退出码后再手工判断，这属于预期状态处理，不是忽略错误。

#### 9. 调试日志背后的文件描述符

在 Lima 的 Bash 4/5 中：

```bash
exec 9>>"$DEBUG_LOG"
export BASH_XTRACEFD=9
```

`exec 9>>file` 打开文件描述符 9 并追加写入；`BASH_XTRACEFD=9` 让 xtrace 单独写到 fd 9，因此 stdout/stderr 仍正常显示。

macOS 自带 Bash 3.2 不支持 `BASH_XTRACEFD`，所以退化为：

```bash
exec 2> >(tee -a "$DEBUG_LOG" >&2)
```

- `2>` 重定向 stderr。
- `>(...)` 是进程替换，创建通往 `tee` 的管道。
- `tee -a` 把内容追加到日志。
- `>&2` 再复制回终端原来的 stderr。

因此 Mac 日志会同时包含 xtrace 和普通 stderr；Lima 日志可以只包含 xtrace。两边都不会吞掉终端错误信息。

#### 10. 调试开关如何跨越 Mac 和 Lima

Mac 的 `build.sh` 与 VM 内的 `build-in-vm.sh` 是两个不同 Bash 进程，环境不会凭空跨虚拟机继承。包装脚本显式执行：

```bash
limactl shell "$INSTANCE" -- env \
  DEBUG_TRACE="${DEBUG_TRACE:-0}" \
  DEBUG_VARS="${DEBUG_VARS:-0}" \
  DEBUG_STEP="${DEBUG_STEP:-0}" \
  DEBUG_ERRORS="${DEBUG_ERRORS:-0}" \
  DEBUG_LOG="${DEBUG_VM_LOG:-}" \
  bash "$REPO_ROOT/tools/x86-lab/build-in-vm.sh"
```

传播链是：

```text
Mac 命令行 DEBUG_TRACE=1
        ↓
Mac build.sh 读取并启用 set -x
        ↓ limactl shell + env 显式传递
Lima build-in-vm.sh 收到 DEBUG_TRACE=1
        ↓
VM 内再次 source debug-lib.sh 并启用 set -x
```

`DEBUG_LOG` 记录 Mac 侧，`DEBUG_VM_LOG` 被转换成 VM 侧的 `DEBUG_LOG`。如果 VM 日志使用共享仓库里的绝对路径，Mac 可以直接打开它。

#### 11. BusyBox `/init` 为什么使用另一套办法

`rootfs/init` 的解释器是 BusyBox `ash`：

```bash
#!/bin/sh
```

它不是完整 Bash，不能依赖 Bash 数组、`BASH_SOURCE`、`FUNCNAME` 或 `BASH_XTRACEFD`，但支持基本的 `set -x`。因此 `/init` 挂载 `/proc` 后检查内核命令行：

```bash
case " $(cat /proc/cmdline) " in
  *" debug_init=1 "*)
    PS4='+ init:${LINENO}: '
    set -x
    ;;
esac
```

完整控制链是：

```text
GRUB 的 linux 行追加 debug_init=1
        ↓
Linux 把参数保存在 /proc/cmdline
        ↓
BusyBox /init 读取参数
        ↓
执行 set -x，打印后续启动命令
```

#### 12. Shell 调试与 GDB 调试的区别

| Shell 调试 | GDB/QEMU 内核调试 |
|---|---|
| 调试 Bash/ash 解释器执行的命令 | 调试 x86 CPU 执行的机器指令 |
| `set -x` 显示展开后的命令 | 单步源码或汇编 |
| `declare -p` 显示 Shell 变量 | 查看 C 变量、寄存器和内存 |
| `read` 模拟阶段断点 | 软件/硬件断点 |
| `trap ERR` 捕获命令失败 | 捕获断点、异常和信号 |
| 能看到 `make` 如何被调用，不能进入其内部 C 代码 | 能进入 `start_kernel` 等内核函数 |

所以 `DEBUG_TRACE=1 tools/x86-lab/run-debug.sh` 可以同时存在两层调试：Shell 层观察 SSH 隧道和 QEMU 如何启动，GDB 层连接 QEMU Stub 观察 x86 Linux 内核如何执行。

#### 13. 一次完整调试的执行顺序

执行：

```bash
DEBUG_TRACE=1 DEBUG_VARS=1 DEBUG_ERRORS=1 tools/x86-lab/build.sh
```

内部顺序如下：

```text
1. 终端为 build.sh 创建 Bash 进程并注入 DEBUG_* 环境变量
2. build.sh 执行 set -euo pipefail
3. source debug-lib.sh，把调试函数载入当前进程
4. xlab_debug_init 校验开关、设置 PS4、安装 ERR trap、执行 set -x
5. build.sh 解析 REPO_ROOT、LIMACTL、INSTANCE
6. xlab_debug_point 使用 declare -p 打印变量，并按需用 read 暂停
7. build.sh 通过 limactl shell + env 把开关传进 Lima
8. Lima 启动 build-in-vm.sh，再次初始化调试库
9. VM 脚本在内核、BusyBox、rootfs、产物导出前分别调用调试点
10. 如果 make 等命令失败，ERR trap 打印退出码、命令、位置和调用栈
11. 原始非零状态继续返回 VM Bash、limactl 和 Mac build.sh
```

这套框架的限制也要记住：它不能进入外部程序内部；阶段断点只能出现在预设位置；复杂管道或子 shell 的 trace 可能交错；`kill -9` 不会触发 `EXIT trap`；敏感环境变量可能出现在日志中。

### 统一调试开关

| 开关 | 默认值 | 作用 |
|---|---:|---|
| `DEBUG_TRACE=1` | `0` | 输出每条实际执行的命令，并显示脚本文件、行号、函数名 |
| `DEBUG_VARS=1` | `0` | 在脚本预设的阶段边界打印关键变量，数组也能完整显示 |
| `DEBUG_STEP=1` | `0` | 在阶段边界暂停；按 Enter 继续，输入 `q` 终止 |
| `DEBUG_ERRORS=1` | `0` | 失败时输出退出码、失败命令、源位置和 Bash 调用栈 |
| `DEBUG_LOG=/path/file` | 空 | 把 Mac 侧调试输出追加到文件；终端仍正常显示 |
| `DEBUG_VM_LOG=/path/file` | 空 | 把 Lima 内脚本的 xtrace 写入 VM 可见文件 |

这些变量可以组合：

```bash
# 初学推荐：先看阶段参数和错误现场，不打印海量命令
DEBUG_VARS=1 DEBUG_ERRORS=1 tools/x86-lab/build.sh

# 完整逐行跟踪 Mac 包装器和 VM 主构建脚本
DEBUG_TRACE=1 DEBUG_ERRORS=1 tools/x86-lab/build.sh

# 在每个主要阶段暂停，观察变量后按 Enter 继续
DEBUG_VARS=1 DEBUG_STEP=1 tools/x86-lab/build.sh

# Mac 与 VM 分开记录；VM 日志放共享仓库，所以 Mac 也能直接打开
DEBUG_TRACE=1 \
DEBUG_LOG=/tmp/x86-build-mac.trace \
DEBUG_VM_LOG=/Users/xuyu/Desktop/code/linux5.15_comment/out/x86-lab/build-vm.trace \
tools/x86-lab/build.sh
```

兼容性细节：Lima Ubuntu 的 Bash 5 支持 `BASH_XTRACEFD`，因此 `DEBUG_VM_LOG` 可以只收集 xtrace；macOS 自带 Bash 3.2 不支持该变量，`DEBUG_LOG` 会通过 `tee` 同时记录 xtrace 和 stderr。两种情况下终端输出都不会被吞掉。这个区别也是学习 Shell 时很典型的“同为 Bash，但版本能力不同”。

布尔值只能写 `0` 或 `1`。例如误写 `DEBUG_TRACE=yes` 时脚本会立即提示参数错误，避免你以为已经开启跟踪。

### 怎样阅读一条 trace

典型输出如下：

```text
+ [build-in-vm.sh:83:main] make -C /home/xuyu.guest/x86-linux-lab-work/linux-src ...
```

- 第一个 `+` 是 Bash xtrace 标志，不是命令内容。
- `build-in-vm.sh` 是正在执行的文件。
- `83` 是命令所在行号；脚本增加注释后行号会变化，以当前文件为准。
- `main` 表示当前在脚本顶层；函数内部会显示函数名。
- 后面是变量和命令替换完成后真正交给系统执行的命令。

因为 trace 显示展开后的参数，所以特别适合发现空变量、路径带空格、错误镜像名和远端/本地路径混淆。它也可能打印环境中的敏感值，分享日志前必须检查。

### 怎样理解变量快照

开启 `DEBUG_VARS=1` 后会看到：

```text
[XLAB-VARS] VM 构建路径和参数已解析
declare -- KERNEL_SRC="/home/xuyu.guest/x86-linux-lab-work/linux-src"
declare -- JOBS="6"
```

这里使用 `declare -p`，而不是简单的 `echo`：

- `declare --` 表示普通字符串。
- `declare -a` 表示索引数组。
- 引号和转义能准确显示空格、换行等特殊字符。
- `is unset` 表示变量尚未定义；这不一定是错误，例如 `CLEAN_BUILD` 本来就是可选值。

### 怎样使用学习断点

`DEBUG_STEP=1` 不是 CPU 机器指令断点，而是在危险操作或主要阶段之前调用 `read` 暂停：

```text
[XLAB-STEP] 阶段 2/5：准备配置和编译内核
[XLAB-STEP] Enter=继续，q=退出脚本：
```

暂停时可以另开一个 Mac 终端，并进入 Lima 查看现场：

```bash
~/.local/bin/limactl shell linux-x86-builder
ls -la ~/x86-linux-lab-work
ps aux | grep -E 'make|qemu|grub'
sudo losetup -a
mount | grep x86-linux-lab-work
```

如果 stdin 不是交互终端，例如 CI、重定向或某些 CLion Console，脚本会打印“跳过暂停”而不是永远卡住。

### 怎样阅读错误现场

开启 `DEBUG_ERRORS=1` 后，非预期失败会显示：

```text
[XLAB-ERROR] status=1 source=build-in-vm.sh line=...
[XLAB-ERROR] command: make ... bzImage
[XLAB-ERROR] call stack (newest first):
```

- `status=127` 通常表示命令不存在。
- `status=126` 通常表示文件存在但不可执行。
- `status=1` 是普通失败，需要结合命令自己的错误输出。
- `status=124` 常见于 `timeout` 超时；`verify.sh` 对预期超时有自己的判断。
- `command` 是失败时 Bash 正在执行的命令。
- 调用栈用于区分顶层失败和函数/子 shell 中的失败。

错误报告不会吞掉原退出码，脚本仍会按 `set -e` 原有规则结束。`verify.sh` 中为了检查 QEMU 和 `e2fsck` 而刻意使用的 `set +e` 属于预期错误处理，最终是否失败仍由后续状态判断决定。

### 每个脚本最值得观察什么

| 脚本 | 推荐命令 | 重点学习内容 |
|---|---|---|
| `bootstrap-mac.sh` | `DEBUG_VARS=1 DEBUG_STEP=1 ...` | 平台判断、下载校验、VM 创建、heredoc 下发 |
| `build.sh` | `DEBUG_TRACE=1 ...` | Mac 包装器如何用 `env` 向 Lima 传参 |
| `build-in-vm.sh` | `DEBUG_VARS=1 DEBUG_STEP=1 ...` | 数组、循环、rsync、管道、Kbuild、BusyBox、ext4 |
| `verify.sh` | `DEBUG_TRACE=1 DEBUG_ERRORS=1 ...` | `set +e`、`PIPESTATUS`、timeout、grep 断言 |
| `run.sh` | `DEBUG_VARS=1 ...` | 多行命令、QEMU 参数和引号 |
| `run-debug.sh` | `DEBUG_TRACE=1 DEBUG_ERRORS=1 ...` | 后台进程 `$!`、SSH 隧道、trap 清理 |
| `build-grub-disk.sh` | `DEBUG_VARS=1 ...` | 包装器与 VM 环境变量传递 |
| `build-grub-disk-in-vm.sh` | `DEBUG_VARS=1 DEBUG_STEP=1 ...` | 函数、EXIT trap、loop、mount、状态码 |
| `run-grub.sh` | `DEBUG_VARS=1 ...` | 纯 `-hda` QEMU 参数 |
| `run-grub-debug.sh` | `DEBUG_TRACE=1 ...` | 后台 SSH 与 BIOS GDB stub 生命周期 |
| `setup-clion.sh` | `DEBUG_TRACE=1 ...` | heredoc、Python、JSON、管道和路径改写 |

下面各小节是不依赖公共辅助库的 Bash 基础调试方法，也适用于你以后自己写的其他脚本。

### 1. 只做语法检查，不执行

```bash
bash -n tools/x86-lab/build.sh
bash -n tools/x86-lab/build-in-vm.sh

# 一次检查全部脚本
for f in tools/x86-lab/*.sh tools/x86-lab/rootfs/init; do
  echo "checking $f"
  bash -n "$f"
done
```

`bash -n` 能发现引号、`if/fi`、循环和 heredoc 结构错误，但不会发现命令不存在、路径错误或权限问题。

### 2. 显示“文件:行号:函数”和实际展开后的命令

```bash
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x tools/x86-lab/build.sh 2>&1 | tee /tmp/x86-build-trace.log
```

`-x` 会在执行每条命令前打印变量展开后的内容。`PS4` 给每行增加源文件、行号和函数名；`tee` 同时显示并保存日志。日志可能含本机路径和环境变量，分享前应检查是否包含敏感信息。

只跟踪一个关键区域时，可临时在脚本中加入：

```bash
set -x
# 需要观察的命令
set +x
```

### 3. 查看变量和数组

```bash
printf 'REPO_ROOT=%q\n' "$REPO_ROOT"
declare -p INSTANCE ARTIFACT_DIR
declare -p required
```

`%q` 会把空格和特殊字符转义出来，比普通 `echo` 更适合查路径问题；`declare -p` 会保留变量类型和数组结构。

### 4. 制作一个可控“断点”

需要在某一步停住并手工检查时，可临时添加：

```bash
if [[ "${DEBUG_PAUSE:-0}" == "1" ]]; then
  echo "paused at ${BASH_SOURCE[0]}:${LINENO}"
  declare -p REPO_ROOT INSTANCE
  read -r -p '按 Enter 继续...'
fi
```

然后这样运行：

```bash
DEBUG_PAUSE=1 tools/x86-lab/build.sh
```

这不是机器级断点，但对脚本最实用：暂停后可另开终端查看进程、目录、loop 设备和日志。

### 5. 直接调试 VM 内脚本

`build.sh` 和 `build-grub-disk.sh` 只是包装器。复杂逻辑发生在 Lima 的 `build-in-vm.sh` 与 `build-grub-disk-in-vm.sh`，要看真实 Linux 命令应直接进入 VM：

```bash
~/.local/bin/limactl shell linux-x86-builder

export REPO_ROOT=/Users/xuyu/Desktop/code/linux5.15_comment
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x "$REPO_ROOT/tools/x86-lab/build-in-vm.sh"
```

GRUB 脚本会使用 `sudo`、loop 设备和挂载点；脚本已有 `trap cleanup EXIT`。调试时不要随意 `kill -9`，因为 SIGKILL 无法触发清理。若异常中止，可检查：

```bash
mount | grep x86-linux-lab-work
sudo losetup -a
```

### 6. 调试 BusyBox `/init`

`rootfs/init` 运行在 x86 客体里，解释器是 BusyBox `ash`，不是 Mac/Lima 的 Bash，所以不能 source `debug-lib.sh`。它提供单独的内核参数开关 `debug_init=1`。

完整硬盘启动时：

1. 运行 `tools/x86-lab/run-grub.sh`。
2. GRUB 菜单出现时按 `e`。
3. 找到以 `linux /boot/bzImage` 开头的一行。
4. 在末尾追加 `debug_init=1`。
5. 按 `Ctrl-X` 或 `F10` 临时启动。

随后串口会打印 `/init` 中展开后的命令，例如挂载 `sysfs`、设置 hostname、解析 `/proc/cmdline`。这个修改只对本次启动有效，不会写回 `grub.cfg`。

快速 `-kernel` 路径可临时手工修改 `run.sh` 的 `-append`，在引号内追加 `debug_init=1`。学习完成后撤销该临时修改；或者直接复制 QEMU 命令到终端再追加参数。

`ash` 的调试能力比 Bash 少：没有 `BASH_SOURCE`、Bash 数组或 `FUNCNAME`。本项目使用 `PS4='+ init:${LINENO}: '` 和 `set -x`，因此至少能看到 `/init` 行号及展开后的命令。

### 7. 调试 `grub.cfg`

GRUB 使用自己的命令语言，既不是 Bash，也不能使用 `bash -x`。在 GRUB 菜单按 `c` 进入命令行，常用学习命令：

```text
set                         # 查看 GRUB 环境变量
ls                          # 查看磁盘和分区，如 (hd0) (hd0,msdos1)
ls (hd0,msdos1)/            # 查看根目录
ls (hd0,msdos1)/boot/       # 确认 bzImage 与 grub 目录
cat (hd0,msdos1)/boot/grub/grub.cfg
echo $root
set debug=all               # 打开非常详细的 GRUB 内部调试输出
set debug=                  # 关闭内部调试输出
```

`set debug=all` 输出量很大，建议只在定位 GRUB 模块或磁盘读取问题时短时开启。按 `Esc` 返回菜单；在菜单按 `e` 可以逐行修改当前菜单项，`Ctrl-X`/`F10` 执行，所有编辑都只影响本次启动。

### 8. 在 CLion 中运行脚本

可新建 **Shell Script** Run Configuration：

- Script path：选择例如 `tools/x86-lab/build.sh`。
- Working directory：`/Users/xuyu/Desktop/code/linux5.15_comment`。
- Interpreter path：`/bin/bash`。
- Environment variables：按需加入 `CLEAN_BUILD=1`、`GDB_PORT=1235` 等。

CLion 用于编辑、导航和启动脚本；需要“每行执行了什么、变量展开成什么”时仍以 `bash -x` 为准。若安装第三方 Bash debugger 插件，要单独评估其维护状态和与当前 CLion 版本的兼容性，不应让核心流程依赖它。

## 常用场景速查

### 第一次从零开始

```bash
cd /Users/xuyu/Desktop/code/linux5.15_comment
tools/x86-lab/bootstrap-mac.sh
tools/x86-lab/build.sh
tools/x86-lab/verify.sh
tools/x86-lab/setup-clion.sh
tools/x86-lab/build-grub-disk.sh
tools/x86-lab/run-grub.sh
```

### 只修改普通内核源码后

```bash
tools/x86-lab/build.sh
tools/x86-lab/setup-clion.sh
tools/x86-lab/run-debug.sh
```

### 修改内核配置或怀疑旧目标文件污染

```bash
CLEAN_BUILD=1 tools/x86-lab/build.sh
tools/x86-lab/setup-clion.sh
```

### 只修改 `/init` 或 `grub.cfg`

基础 `rootfs.ext4` 中的 `/init` 由 `build.sh` 写入，因此修改 `/init` 后要重跑 `build.sh`。完整硬盘里的 `/init`、`grub.cfg` 和 `bzImage` 由 GRUB 封装阶段复制，任何一个变化后都要重跑：

```bash
tools/x86-lab/build-grub-disk.sh
```

### 快速调试内核

```bash
tools/x86-lab/run-debug.sh
# CLion 连接 127.0.0.1:1234，break start_kernel，然后 Resume
```

### 调试 BIOS 到 MBR

```bash
tools/x86-lab/run-grub-debug.sh
```

```gdb
target remote 127.0.0.1:1234
hbreak *0x7c00
continue
info registers
x/32bx 0x7c00
```

## 故障排查

### `limactl` 找不到或 VM 没启动

```bash
ls -l ~/.local/bin/limactl
~/.local/bin/limactl list
~/.local/bin/limactl start linux-x86-builder
```

首次缺少命令时重跑 `tools/x86-lab/bootstrap-mac.sh`；脚本会复用已有实例和软件包。

### 下载 Ubuntu 包很慢或镜像不可达

```bash
# 使用官方 Ubuntu ports 源
APT_MIRROR='' tools/x86-lab/bootstrap-mac.sh
```

反之在中国大陆可保留默认 USTC 镜像。GRUB amd64 数据包固定从 Ubuntu 官方 archive 下载并校验 SHA256。

### Kbuild 报 `xt_TCPMSS.o` 或大小写相关文件不存在

不要在默认大小写不敏感 APFS 共享目录中直接构建。`build-in-vm.sh` 会同步到 Lima ext4，并从 Git index 恢复仅大小写不同的文件。确认仓库是 Git checkout，且相关文件仍在 index：

```bash
git ls-files | grep -i 'xt_tcpmss.c'
```

### BusyBox 静态链接找不到 `libm-*.a`/`libmvec.a`

重新执行 bootstrap。它会在 Lima 内建立以下兼容软链接，而不会修改 Mac 库：

```text
/usr/lib/x86_64-linux-gnu -> 使用 /usr/x86_64-linux-gnu/lib 中的交叉静态归档
```

### QEMU 启动后没有输出

确认同时具备：

- QEMU 使用 `-nographic` 或 `-serial stdio`。
- 内核参数含 `console=ttyS0`。
- GRUB 配置含 `terminal_output serial`。
- `/init` 最终使用 `setsid cttyhack /bin/sh`。

### 内核无法挂载根文件系统

快速路径根设备是整个无分区 ext4：`root=/dev/sda`。GRUB 完整硬盘有 MBR 分区表：`root=/dev/sda1`。两者写反会导致 `VFS: Unable to mount root fs`。

还应检查 `kernel.config` 中 ATA PIIX、SCSI disk、ext4 和 devtmpfs 是内建 `=y` 而不是模块；根文件系统挂载前没有 initramfs 帮助加载模块。

### GDB/CLion 连不上 1234

```bash
lsof -nP -iTCP:1234 -sTCP:LISTEN
GDB_PORT=1235 tools/x86-lab/run-debug.sh
```

若改端口，CLion Target 必须同步改成 `127.0.0.1:1235`。运行调试脚本的终端必须保持打开，因为该进程同时维护 SSH 隧道和 QEMU。

### 断点显示源码不存在

先在 CLion Remote Debug 检查 Path Mapping。也可在 GDB Console 手工验证：

```gdb
show substitute-path
set substitute-path /home/xuyu.guest/x86-linux-lab-work/linux-src /Users/xuyu/Desktop/code/linux5.15_comment
list start_kernel
```

如果 VM 用户 home 发生变化，运行下列命令获取实际编译路径，再更新映射：

```bash
~/.local/bin/limactl shell linux-x86-builder -- printenv HOME
```

### MBR 反汇编看起来不对

启动早期是 16 位实模式，而 QEMU GDB Stub 向 GDB 暴露完整 x86-64 CPU。实时 `x/i` 可能按错误宽度解码。寄存器、内存字节和断点仍可信；精确查看 MBR 使用本文前面的 `objdump -m i8086` 命令。

### 检查产物是否损坏

```bash
cd out/x86-lab
sha256sum -c SHA256SUMS
sha256sum -c grub-bios-disk.SHA256SUMS
file bzImage vmlinux busybox rootfs.ext4 grub-bios-disk.img
```

## 两条启动路径的最终对照

| 项目 | 快速内核路径 | 完整硬盘路径 |
|---|---|---|
| 启动脚本 | `run.sh` / `run-debug.sh` | `run-grub.sh` / `run-grub-debug.sh` |
| QEMU 内核加载 | `-kernel bzImage` | 无 |
| 硬盘 | `rootfs.ext4`，无分区表 | `grub-bios-disk.img`，MBR + ext4 分区 |
| 根设备 | `/dev/sda` | `/dev/sda1` |
| 内核参数来源 | QEMU `-append` | `/boot/grub/grub.cfg` |
| 能否观察 0x7c00 | 不能，已绕过硬盘引导 | 能 |
| 适合用途 | 快速改内核、源码级 GDB | 学习 BIOS/MBR/GRUB/完整启动链 |

两者并不是谁取代谁：日常内核开发使用快速路径节省时间；研究 bootloader 时使用完整硬盘路径保证启动过程原生、可观察。

## 官方参考

- [Lima 安装文档](https://lima-vm.io/docs/installation/)
- [QEMU system emulator invocation](https://www.qemu.org/docs/master/system/invocation.html)
- [QEMU GDB usage](https://www.qemu.org/docs/master/system/gdb.html)
- [GNU GRUB BIOS installation](https://www.gnu.org/software/grub/manual/grub/html_node/BIOS-installation.html)
- [GNU GRUB grub-install](https://www.gnu.org/software/grub/manual/grub/html_node/Invoking-grub_002dinstall.html)
- [CLion Remote Debug](https://www.jetbrains.com/help/clion/remote-debug.html)
- [BusyBox 下载目录](https://busybox.net/downloads/)
- 本仓库的 `Documentation/dev-tools/gdb-kernel-debugging.rst`：内核 GDB 配置、QEMU GDB Stub 和 `lx-*` 辅助命令。
- 本仓库的 `Documentation/kbuild/`：Linux Kbuild、Makefile 与交叉编译变量说明。
