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

### 6. 在 CLion 中运行脚本

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
