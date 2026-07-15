/* Stage 1 按 BIOS 实际加载地址 0x7c00 链接，入口符号为 _start。 */
OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)

SECTIONS
{
    . = 0x7c00;
    .text : { *(.text) }

    /DISCARD/ : {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}

