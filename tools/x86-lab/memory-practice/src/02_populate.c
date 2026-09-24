/*
 * 实验 02：比较普通延迟映射和 MAP_POPULATE 预填充映射。
 *
 * 两段区域长度、权限都相同，唯一关键差别是第二次 mmap 多了
 * MAP_POPULATE。这样可以直接比较“mmap 返回后是否已经有驻留页”。
 */
#define _GNU_SOURCE
#include "lab.h"

int main(int argc, char **argv)
{
    /* 页面大小和总映射长度。 */
    long ps;
    size_t length;
    /*
     * void * 是“未指定所指数据类型的地址”，适合只保存映射首地址。
     * 真正按字节写入时，会临时转换为 volatile unsigned char *。
     */
    void *lazy;
    void *populated;

    lab_init(argc, argv);
    ps = page_size();
    /* 每段区域都是 4 页。 */
    length = 4 * (size_t)ps;
    printf("LAB=populate page_size=%ld length=%zu\n", ps, length);
    checkpoint("P0-before-mmap", "create lazy and MAP_POPULATE mappings");

    /* 普通匿名私有映射：通常只先建立 VMA，等访问时才逐页 fault-in。 */
    lazy = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    /*
     * MAP_POPULATE 要求内核在 mmap 返回前尽量预填充页表。对本实验的匿名
     * 可写映射，通常能看到 4 页都驻留。它不保证物理连续，也不等于 mlock。
     */
    populated = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                             MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
                             -1, 0);

    printf("LAZY_BASE=%p POPULATED_BASE=%p\n", lazy, populated);

    /* fputs 先打印标签，show_residency 再打印每页的 0/1。 */
    fputs("lazy ", stdout);
    show_residency(lazy, length);
    fputs("populate ", stdout);
    show_residency(populated, length);
    checkpoint("P1-after-both", "write the last page in both mappings");

    /*
     * 把 void * 转成字节指针后，数组下标才表示字节偏移。
     * [3 * ps] 是第 3 页（最后一页）的首字节。
     * lazy 的这次写可能触发缺页；populated 通常已有可写映射。
     */
    ((volatile unsigned char *)lazy)[3 * ps] = 1;
    ((volatile unsigned char *)populated)[3 * ps] = 2;

    /* 再次查询，预期 lazy 只有最后一页新驻留，populate 仍是四页。 */
    fputs("lazy ", stdout);
    show_residency(lazy, length);
    fputs("populate ", stdout);
    show_residency(populated, length);
    checkpoint("P2-after-write", "unmap both ranges");

    /*
     * || 是逻辑或，并且会短路：第一个 munmap 失败时第二个不会执行。
     * 对教学程序足够；真实资源清理代码通常会分别尝试并记录每个失败。
     */
    if (munmap(lazy, length) != 0 || munmap(populated, length) != 0) {
        perror("munmap");
        return EXIT_FAILURE;
    }
    puts("DONE populate");
    return 0;
}
