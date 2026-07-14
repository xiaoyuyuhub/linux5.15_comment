# 本项目的 GDB 连接后钩子。
#
# CLion Remote Debug 在建立 target remote 连接后可能立即继续目标。QEMU 虽然
# 使用 -S 从 reset vector 暂停，但如果等 CLion UI 可操作后再手工输入断点，
# BIOS 往往已经越过 0x7c00。hookpost-remote 在连接刚完成、目标继续之前运行，
# 因此可以稳定地预先安装 MBR 硬件执行断点。
#
# 使用 hbreak 而不是 break：BIOS 尚未把 LBA 0 加载到 0x7c00，软件断点会
# 写目标内存，随后可能被 BIOS 的磁盘读取覆盖；硬件断点不会改写 MBR 字节。

define target hookpost-remote
  echo [x86-lab] remote connected; installing hardware breakpoint at 0x7c00\n
  hbreak *0x7c00
end
