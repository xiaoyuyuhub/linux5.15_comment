/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * native-loader Stage 2：最小 Linux x86 boot protocol 教学加载器。
 *
 * 入口环境：
 *   - Stage 1 已把本文件的固定 32 个扇区放到物理地址 0x8000；
 *   - CPU 仍处于 16 位实模式；
 *   - DL 保存 BIOS 启动磁盘号；
 *   - 中断关闭。
 *
 * 本阶段严格只完成 Linux 5.15 启动所必需的装载工作：
 *   1. 从固定 LBA 64 读取 bzImage 的前两个扇区；
 *   2. 验证 0xaa55、"HdrS"、protocol 和 LOAD_HIGH；
 *   3. 按 setup_sects 把 real-mode setup 完整放到 0x90000；
 *   4. 按 syssize 把 protected-mode compressed kernel 放到 0x100000；
 *   5. 写入最少的 type_of_loader、heap 和 command-line 字段；
 *   6. 设置 Linux boot protocol 要求的段寄存器和栈；
 *   7. 跳到 9020:0000，也就是物理地址 0x90200 的 start_of_setup。
 *
 * BIOS EDD 的普通 DAP 缓冲区只能方便地表示 1 MiB 以下地址。为了把约
 * 9 MiB 的 compressed kernel 放到 1 MiB 以上，本加载器反复执行：
 *
 *   硬盘 --INT 13h--> 0x10000 bounce buffer
 *        --unreal mode 32-bit copy--> 0x100000 以上
 *
 * 这里没有 GRUB、文件系统解析、菜单、initrd 或通用模块框架，目的是让
 * 每一步都能在 GDB 中用确定地址观察。
 */

    .section .text
    .code16
    .global _start

/* 固定磁盘布局，必须与 build-native-disk-in-vm.sh 保持一致。 */
    .equ KERNEL_LBA,             64

/* 内存布局。 */
    .equ SETUP_SEGMENT,          0x9000
    .equ SETUP_PHYSICAL,         0x00090000
    .equ SETUP_ENTRY_SEGMENT,    0x9020
    .equ SETUP_ENTRY_OFFSET,     0x0000
    .equ SETUP_STACK_TOP,        0x9800
    .equ COMMAND_LINE_OFFSET,    0x9800
    .equ COMMAND_LINE_PHYSICAL,  0x00099800
    .equ BOUNCE_SEGMENT,         0x1000
    .equ PROTECTED_TARGET,       0x00100000

/* 每次读 64 个扇区，即 32 KiB；不会跨越 bounce buffer 的 64 KiB 边界。 */
    .equ MAX_CHUNK_SECTORS,      64

/* Linux setup header 相对 real-mode image 起点的字段偏移。 */
    .equ HDR_SETUP_SECTS,        0x01f1
    .equ HDR_SYSSIZE,            0x01f4
    .equ HDR_VID_MODE,           0x01fa
    .equ HDR_BOOT_FLAG,          0x01fe
    .equ HDR_MAGIC,              0x0202
    .equ HDR_VERSION,            0x0206
    .equ HDR_TYPE_OF_LOADER,     0x0210
    .equ HDR_LOADFLAGS,          0x0211
    .equ HDR_RAMDISK_IMAGE,      0x0218
    .equ HDR_RAMDISK_SIZE,       0x021c
    .equ HDR_HEAP_END_PTR,       0x0224
    .equ HDR_CMD_LINE_PTR,       0x0228

/* Linux boot protocol flags。 */
    .equ LOAD_HIGH,              0x01
    .equ CAN_USE_HEAP,           0x80

/* COM1 16550 UART 端口。 */
    .equ COM1_BASE,              0x03f8
    .equ COM1_DATA,              COM1_BASE + 0
    .equ COM1_IER,               COM1_BASE + 1
    .equ COM1_FCR,               COM1_BASE + 2
    .equ COM1_LCR,               COM1_BASE + 3
    .equ COM1_MCR,               COM1_BASE + 4
    .equ COM1_LSR,               COM1_BASE + 5

_start:
    cli

    /* Stage 2 链接在物理 0x8000；CS=0、DS=0 时标签可直接访问。 */
    xorw    %ax, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %ss
    movw    $0x7c00, %sp
    cld

    movb    %dl, boot_drive
    call    serial_init
    movw    $msg_stage2, %si
    call    serial_puts

    /* 快速 A20 gate：设置 System Control Port A 的 bit1。 */
    call    enable_a20

    /*
     * 先读取 bzImage 前两个扇区到 0x90000。
     * 第一个扇区包含 setup_sects/syssize/55aa；第二个包含 HdrS。
     */
    movw    $2, dap_count
    movw    $0x0000, dap_offset
    movw    $SETUP_SEGMENT, dap_segment
    movl    $KERNEL_LBA, dap_lba_low
    movl    $0, dap_lba_high
    call    bios_read
    jc      fatal_disk

    /* ES 指向 Linux real-mode image，下面所有 header 访问都使用 ES override。 */
    movw    $SETUP_SEGMENT, %ax
    movw    %ax, %es

    cmpw    $0xaa55, %es:HDR_BOOT_FLAG
    jne     fatal_bad_boot_flag
    cmpl    $0x53726448, %es:HDR_MAGIC       /* little-endian "HdrS" */
    jne     fatal_bad_header
    cmpw    $0x0202, %es:HDR_VERSION
    jb      fatal_old_protocol
    testb   $LOAD_HIGH, %es:HDR_LOADFLAGS
    jz      fatal_not_bzimage

    /* setup_sects 为 0 时，协议规定实际值是 4；再加 boot sector 得总扇区数。 */
    movzbl  %es:HDR_SETUP_SECTS, %eax
    testl   %eax, %eax
    jnz     1f
    movl    $4, %eax
1:
    incl    %eax
    cmpw    $2, %ax
    jb      fatal_setup_size
    cmpw    $64, %ax
    ja      fatal_setup_size
    movw    %ax, setup_total_sectors

    /* 前两个扇区已经读完，从 LBA KERNEL_LBA+2 读取剩余 setup。 */
    subw    $2, %ax
    jz      setup_loaded
    movw    %ax, dap_count
    movw    $0x0400, dap_offset
    movw    $SETUP_SEGMENT, dap_segment
    movl    $(KERNEL_LBA + 2), dap_lba_low
    movl    $0, dap_lba_high
    call    bios_read
    jc      fatal_disk

setup_loaded:
    movw    $msg_setup_loaded, %si
    call    serial_puts

    /*
     * syssize 是 protected-mode 部分的 16-byte paragraph 数。
     * 一个 512-byte 扇区包含 32 个 paragraph，因此：
     *   sectors = ceil(syssize / 32) = (syssize + 31) >> 5
     */
    movl    %es:HDR_SYSSIZE, %eax
    testl   %eax, %eax
    jz      fatal_syssize
    addl    $31, %eax
    shrl    $5, %eax
    movl    %eax, remaining_sectors

    /* protected data 紧跟全部 setup 扇区之后。 */
    movzwl  setup_total_sectors, %eax
    addl    $KERNEL_LBA, %eax
    movl    %eax, current_lba
    movl    $PROTECTED_TARGET, destination_physical

    movw    $msg_loading_kernel, %si
    call    serial_puts

load_protected_loop:
    cmpl    $0, remaining_sectors
    je      protected_loaded

    /* chunk = min(remaining_sectors, MAX_CHUNK_SECTORS)。 */
    movl    remaining_sectors, %eax
    cmpl    $MAX_CHUNK_SECTORS, %eax
    jbe     2f
    movl    $MAX_CHUNK_SECTORS, %eax
2:
    movw    %ax, chunk_sectors

    /* BIOS 把本块读到 1000:0000，即物理地址 0x10000。 */
    movw    %ax, dap_count
    movw    $0x0000, dap_offset
    movw    $BOUNCE_SEGMENT, dap_segment
    movl    current_lba, %edx
    movl    %edx, dap_lba_low
    movl    $0, dap_lba_high
    call    bios_read
    jc      fatal_disk

    /* 进入短暂 unreal-mode 状态，把 bounce buffer 复制到 1 MiB 以上。 */
    call    copy_bounce_to_high

    /*
     * 更新三个循环量：
     *   current_lba += chunk sectors
     *   destination += chunk * 512 bytes
     *   remaining -= chunk sectors
     */
    movzwl  chunk_sectors, %eax
    addl    %eax, current_lba
    subl    %eax, remaining_sectors
    shll    $9, %eax
    addl    %eax, destination_physical

    /* 每 32 KiB 打印一个点，串口输出也可作为加载进度和卡点判断。 */
    movb    $'.', %al
    call    serial_putc
    jmp     load_protected_loop

protected_loaded:
    movw    $msg_kernel_loaded, %si
    call    serial_puts

    /*
     * 每次 unreal-mode 复制结束都会把 ES 恢复为 0，确保后续 BIOS 调用安全。
     * protected kernel 全部装载完以后，必须重新让 ES 指向 0x90000 的 Linux
     * real-mode image；否则下面的 header 字段会误写到物理低地址 0x0210 等处。
     */
    movw    $SETUP_SEGMENT, %ax
    movw    %ax, %es

    /*
     * 按 Linux boot protocol 填写最少字段。
     * 0xff 表示未分配的自定义 loader 类型；当前没有 initrd。
     */
    movb    $0xff, %es:HDR_TYPE_OF_LOADER
    orb     $CAN_USE_HEAP, %es:HDR_LOADFLAGS
    movw    $0x9600, %es:HDR_HEAP_END_PTR    /* heap end 0x9800 - 0x0200 */
    movl    $COMMAND_LINE_PHYSICAL, %es:HDR_CMD_LINE_PTR
    movl    $0, %es:HDR_RAMDISK_IMAGE
    movl    $0, %es:HDR_RAMDISK_SIZE
    movw    $0xffff, %es:HDR_VID_MODE         /* vga=normal */

    /* 把内核命令行复制到物理地址 0x99800（9000:9800）。 */
    movw    $kernel_command_line, %si
    movw    $COMMAND_LINE_OFFSET, %di
3:
    lodsb
    movb    %al, %es:(%di)
    incw    %di
    testb   %al, %al
    jnz     3b

    movw    $msg_jump_linux, %si
    call    serial_puts

    /*
     * Linux protocol 要求进入时 DS=ES=FS=GS=SS=real-mode image segment，
     * SP 指向 heap/stack 顶，中断关闭；DL 仍保存启动盘号。
     */
    cli
    movb    boot_drive, %dl
    movw    $SETUP_SEGMENT, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %fs
    movw    %ax, %gs
    movw    %ax, %ss
    movw    $SETUP_STACK_TOP, %sp

    /* 9020:0000 = physical 0x90200 = header.S:start_of_setup。 */
    ljmp    $SETUP_ENTRY_SEGMENT, $SETUP_ENTRY_OFFSET

/* ---------- BIOS、A20、unreal mode 和串口辅助函数 ---------- */

/*
 * 使用当前 dap_* 字段执行 INT 13h AH=42h。
 * 返回时保留 BIOS 设置的 CF：CF=0 成功，CF=1 失败。
 */
bios_read:
    pusha
    pushw   %ds
    xorw    %ax, %ax
    movw    %ax, %ds
    movw    $disk_address_packet, %si
    movb    boot_drive, %dl
    movb    $0x42, %ah
    int     $0x13
    popw    %ds
    popa
    ret

/* QEMU/现代 PC 支持 port 0x92 fast A20 gate；设置 bit1 且避免触发 reset bit0。 */
enable_a20:
    inb     $0x92, %al
    orb     $0x02, %al
    andb    $0xfe, %al
    outb    %al, $0x92
    ret

/*
 * 把 0x10000 的 chunk_sectors*512 字节复制到 destination_physical。
 *
 * unreal mode 原理：
 *   1. 临时设置 CR0.PE 进入保护模式；
 *   2. 给 ES 加载 base=0、limit=4 GiB 的数据段 descriptor；
 *   3. 清除 CR0.PE 回实模式，但不重载 ES；
 *   4. ES 的 hidden descriptor cache 暂时保留 4 GiB limit；
 *   5. 使用 32-bit EDI 和 address-size prefix 复制到 1 MiB 以上；
 *   6. 复制结束后把 DS/ES 恢复成普通实模式段，下一次循环重新建立。
 */
copy_bounce_to_high:
    cli
    lgdt    gdt_descriptor

    movl    %cr0, %eax
    orl     $0x00000001, %eax
    movl    %eax, %cr0
    ljmp    $0x08, $protected_mode_16

protected_mode_16:
    /* selector 0x10 指向 flat data descriptor。 */
    movw    $0x10, %ax
    movw    %ax, %es

    /* 清除 PE 并远跳转，重新装载实模式 CS。 */
    movl    %cr0, %eax
    andl    $0xfffffffe, %eax
    movl    %eax, %cr0
    ljmp    $0x0000, $unreal_mode_copy

unreal_mode_copy:
    /* 在重载 DS 之前，从 Stage 2 数据区取出 32-bit 目标和拷贝长度。 */
    movl    destination_physical, %edi
    movzwl  chunk_sectors, %ecx
    shll    $7, %ecx                    /* sectors * 512 / 4 = dword count */

    movw    $BOUNCE_SEGMENT, %ax
    movw    %ax, %ds
    xorl    %esi, %esi
    cld
    addr32 rep movsl                    /* DS:ESI=0x10000 → flat ES:EDI */

    /* BIOS 调用前恢复 DS=ES=0，避免把 unreal hidden state带进固件。 */
    xorw    %ax, %ax
    movw    %ax, %ds
    movw    %ax, %es
    ret

serial_init:
    movw    $COM1_IER, %dx
    xorb    %al, %al
    outb    %al, %dx
    movw    $COM1_LCR, %dx
    movb    $0x80, %al
    outb    %al, %dx
    movw    $COM1_DATA, %dx
    movb    $0x01, %al
    outb    %al, %dx
    movw    $COM1_IER, %dx
    xorb    %al, %al
    outb    %al, %dx
    movw    $COM1_LCR, %dx
    movb    $0x03, %al
    outb    %al, %dx
    movw    $COM1_FCR, %dx
    movb    $0xc7, %al
    outb    %al, %dx
    movw    $COM1_MCR, %dx
    movb    $0x0b, %al
    outb    %al, %dx
    ret

serial_putc:
    pushw   %ax
    pushw   %dx
    movb    %al, %ah
1:
    movw    $COM1_LSR, %dx
    inb     %dx, %al
    testb   $0x20, %al
    jz      1b
    movw    $COM1_DATA, %dx
    movb    %ah, %al
    outb    %al, %dx
    popw    %dx
    popw    %ax
    ret

serial_puts:
1:
    lodsb
    testb   %al, %al
    jz      2f
    call    serial_putc
    jmp     1b
2:
    ret

/* 所有 fatal 路径先恢复 DS=0，以便访问 Stage 2 中的错误字符串。 */
fatal_disk:
    movw    $msg_disk_error, %si
    jmp     fatal
fatal_bad_boot_flag:
    movw    $msg_bad_boot_flag, %si
    jmp     fatal
fatal_bad_header:
    movw    $msg_bad_header, %si
    jmp     fatal
fatal_old_protocol:
    movw    $msg_old_protocol, %si
    jmp     fatal
fatal_not_bzimage:
    movw    $msg_not_bzimage, %si
    jmp     fatal
fatal_setup_size:
    movw    $msg_setup_size, %si
    jmp     fatal
fatal_syssize:
    movw    $msg_syssize, %si

fatal:
    xorw    %ax, %ax
    movw    %ax, %ds
    movw    %ax, %es
    call    serial_puts
1:
    cli
    hlt
    jmp     1b

/* ---------- 数据区 ---------- */

boot_drive:
    .byte   0
setup_total_sectors:
    .word   0
chunk_sectors:
    .word   0
remaining_sectors:
    .long   0
current_lba:
    .long   0
destination_physical:
    .long   0

/* BIOS EDD 16-byte DAP。字段由每次读取前的代码更新。 */
    .balign 4
disk_address_packet:
    .byte   0x10
    .byte   0x00
dap_count:
    .word   0
dap_offset:
    .word   0
dap_segment:
    .word   0
dap_lba_low:
    .long   0
dap_lba_high:
    .long   0

/*
 * 16-bit protected-mode GDT：
 *   selector 0x08：base 0，4 GiB limit，16-bit code；
 *   selector 0x10：base 0，4 GiB limit，data。
 * flags 0x8f 表示 G=1、D/B=0、L=0，limit 高四位为 0xf。
 */
    .balign 8
gdt_start:
    .quad   0x0000000000000000
    .quad   0x008f9a000000ffff
    .quad   0x008f92000000ffff
gdt_end:

gdt_descriptor:
    .word   gdt_end - gdt_start - 1
    .long   gdt_start

kernel_command_line:
    /* 当前 kernel.config 已关闭 RANDOMIZE_BASE，不需要再传会被视为未知参数的 nokaslr。 */
    .asciz  "root=/dev/sda1 rw console=ttyS0,115200 init=/init debug"

msg_stage2:
    .asciz  "[NATIVE S2] 0x8000: parse bzImage\r\n"
msg_setup_loaded:
    .asciz  "[NATIVE S2] setup -> 0x90000\r\n"
msg_loading_kernel:
    .asciz  "[NATIVE S2] compressed kernel -> 0x100000\r\n"
msg_kernel_loaded:
    .asciz  "\r\n[NATIVE S2] compressed kernel loaded\r\n"
msg_jump_linux:
    .asciz  "[NATIVE S2] jump to Linux setup 0x90200\r\n"
msg_disk_error:
    .asciz  "\r\n[NATIVE S2] ERROR: INT 13h read failed\r\n"
msg_bad_boot_flag:
    .asciz  "[NATIVE S2] ERROR: missing 0xaa55\r\n"
msg_bad_header:
    .asciz  "[NATIVE S2] ERROR: missing HdrS\r\n"
msg_old_protocol:
    .asciz  "[NATIVE S2] ERROR: boot protocol older than 2.02\r\n"
msg_not_bzimage:
    .asciz  "[NATIVE S2] ERROR: LOAD_HIGH is not set\r\n"
msg_setup_size:
    .asciz  "[NATIVE S2] ERROR: invalid setup size\r\n"
msg_syssize:
    .asciz  "[NATIVE S2] ERROR: syssize is zero\r\n"
