/* SPDX-License-Identifier: GPL-2.0-only */
/*
 * native-loader Stage 1：传统 BIOS 加载到物理地址 0x7c00 的 MBR 程序。
 *
 * 这个文件故意保持职责极小：
 *   1. 建立确定的 16 位实模式段寄存器和栈；
 *   2. 初始化 COM1，便于 QEMU -nographic 下观察错误；
 *   3. 检查 BIOS 是否支持 INT 13h Extensions（EDD）；
 *   4. 从固定 LBA 1 读取 32 个扇区的 Stage 2 到物理地址 0x8000；
 *   5. 保留 BIOS 传入的启动磁盘号 DL，并跳转到 0000:8000。
 *
 * Stage 1 不理解 Linux、bzImage、分区或文件系统。所有复杂工作都交给
 * Stage 2，这样 0x7c00 附近的每条指令都容易单步和解释。
 *
 * 构建脚本只把本文件生成结果的前 446 字节写到最终 MBR，从而保留 parted
 * 生成的 64 字节分区表；最后两个 0x55aa 字节单独写入偏移 510。
 */

    .section .text
    .code16
    .global _start

/* Stage 2 在磁盘和内存中的固定教学布局。 */
    .equ STAGE2_LBA,       1
    .equ STAGE2_SECTORS,  32
    .equ STAGE2_SEGMENT,   0x0000
    .equ STAGE2_OFFSET,    0x8000

/* 16550 UART 的 COM1 I/O 端口。 */
    .equ COM1_BASE,        0x03f8
    .equ COM1_DATA,        COM1_BASE + 0
    .equ COM1_IER,         COM1_BASE + 1
    .equ COM1_FCR,         COM1_BASE + 2
    .equ COM1_LCR,         COM1_BASE + 3
    .equ COM1_MCR,         COM1_BASE + 4
    .equ COM1_LSR,         COM1_BASE + 5

_start:
    /*
     * BIOS 可能以 0000:7c00 或 07c0:0000 进入。远跳转把 CS 规范化为 0，
     * 后续所有标签都能直接作为物理地址使用。
     */
    ljmp    $0x0000, $stage1_start

stage1_start:
    cli

    /* DS/ES/SS 全部归零，栈从 0x7c00 向低地址增长，不覆盖 MBR 自身。 */
    xorw    %ax, %ax
    movw    %ax, %ds
    movw    %ax, %es
    movw    %ax, %ss
    movw    $0x7c00, %sp
    cld

    /* BIOS 在 DL 中传入启动磁盘号，0x80 通常表示第一块硬盘。 */
    movb    %dl, boot_drive

    call    serial_init
    movw    $msg_stage1, %si
    call    serial_puts

    /*
     * INT 13h AH=41h：检查 EDD 扩展。
     * 输入 BX=55aa；成功时 CF=0、BX=aa55，并且 CX bit0 表示支持扩展读。
     */
    movw    $0x55aa, %bx
    movb    $0x41, %ah
    movb    boot_drive, %dl
    int     $0x13
    jc      stage1_no_edd
    cmpw    $0xaa55, %bx
    jne     stage1_no_edd
    testw   $0x0001, %cx
    jz      stage1_no_edd

    /*
     * INT 13h AH=42h 使用下面的 Disk Address Packet。
     * BIOS 将 LBA 1 开始的 32 个扇区复制到 0000:8000，即物理 0x8000。
     */
    movw    $stage2_dap, %si
    movb    boot_drive, %dl
    movb    $0x42, %ah
    int     $0x13
    jc      stage1_disk_error

    movw    $msg_stage2, %si
    call    serial_puts

    /* 恢复启动磁盘号，Stage 2 会在入口第一时间保存 DL。 */
    movb    boot_drive, %dl
    ljmp    $STAGE2_SEGMENT, $STAGE2_OFFSET

stage1_no_edd:
    movw    $msg_no_edd, %si
    jmp     stage1_fatal

stage1_disk_error:
    movw    $msg_disk_error, %si

stage1_fatal:
    call    serial_puts

    /* 失败后停机；循环 hlt 便于 GDB 保留现场。 */
1:
    cli
    hlt
    jmp     1b

/*
 * 初始化 COM1 为 115200 8N1：
 *   divisor=1，8 data bits，no parity，1 stop bit；
 *   FIFO 打开并清空；DTR/RTS/OUT2 置位。
 */
serial_init:
    movw    $COM1_IER, %dx
    xorb    %al, %al
    outb    %al, %dx                 /* 禁止 UART 中断 */

    movw    $COM1_LCR, %dx
    movb    $0x80, %al
    outb    %al, %dx                 /* DLAB=1，可写波特率除数 */

    movw    $COM1_DATA, %dx
    movb    $0x01, %al
    outb    %al, %dx                 /* divisor low = 1 */

    movw    $COM1_IER, %dx
    xorb    %al, %al
    outb    %al, %dx                 /* divisor high = 0 */

    movw    $COM1_LCR, %dx
    movb    $0x03, %al
    outb    %al, %dx                 /* DLAB=0，8N1 */

    movw    $COM1_FCR, %dx
    movb    $0xc7, %al
    outb    %al, %dx                 /* FIFO 开启、清空，14-byte threshold */

    movw    $COM1_MCR, %dx
    movb    $0x0b, %al
    outb    %al, %dx                 /* DTR + RTS + OUT2 */
    ret

/* AL 为待发送字符；轮询 LSR bit5，直到发送保持寄存器为空。 */
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

/* DS:SI 指向以零结尾的字符串。 */
serial_puts:
1:
    lodsb
    testb   %al, %al
    jz      2f
    call    serial_putc
    jmp     1b
2:
    ret

boot_drive:
    .byte   0

/* EDD 16-byte Disk Address Packet，必须位于 1 MiB 以下。 */
    .balign 4
stage2_dap:
    .byte   0x10                      /* packet size */
    .byte   0x00                      /* reserved */
    .word   STAGE2_SECTORS            /* sector count */
    .word   STAGE2_OFFSET             /* destination offset */
    .word   STAGE2_SEGMENT            /* destination segment */
    .quad   STAGE2_LBA                /* starting 64-bit LBA */

msg_stage1:
    .asciz  "\r\n[NATIVE S1] 0x7c00: loading Stage 2...\r\n"
msg_stage2:
    .asciz  "[NATIVE S1] jump to 0x8000\r\n"
msg_no_edd:
    .asciz  "[NATIVE S1] ERROR: BIOS EDD unavailable\r\n"
msg_disk_error:
    .asciz  "[NATIVE S1] ERROR: INT 13h read failed\r\n"

/*
 * MBR 分区表固定从文件偏移 446 开始。若上面代码超过 446 字节，汇编器
 * 会因 .org 试图向后移动而失败，这比生成一个悄悄覆盖分区表的镜像安全。
 */
    .org    446
    .space  64, 0                     /* 最终镜像中由 parted 的分区表替换 */
    .word   0xaa55                    /* 磁盘中的字节顺序为 55 aa */

