/*
 * 实验 01：匿名私有 mmap 的延迟分配。
 *
 * 观察主线：
 *   mmap 建立 4 页 VMA
 *   → 只读第 0 页（可能映射共享零页）
 *   → 写第 1 页（需要私有匿名物理页）
 *   → 写第 3 页（证明中间页可不触碰）
 *   → MADV_DONTNEED 丢弃第 1 页内容
 *   → munmap 撤销整个虚拟区间。
 */
#define _GNU_SOURCE
#include "lab.h"

int main(int argc, char **argv)
{
    /* ps 保存一页的字节数；当前实验机通常打印 4096。 */
    long ps;
    /* length 是本次映射总字节数。 */
    size_t length;
    /*
     * p 指向映射首字节。unsigned char 每个元素恰好 1 字节，所以 p[n]
     * 就是“从 BASE 起第 n 个字节”。volatile 防止编译器删掉或合并这些
     * 为观察缺页而特意安排的读写；它不是线程同步手段。
     */
    volatile unsigned char *p;
    /* 保存第一次读取的字节，防止只读表达式没有可见用途。 */
    unsigned char value;

    lab_init(argc, argv);
    ps = page_size();
    /* 映射 4 个连续虚拟页。强制转换只是在整数类型之间对齐运算类型。 */
    length = 4 * (size_t)ps;
    printf("LAB=anon-lazy page_size=%ld length=%zu\n", ps, length);
    checkpoint("A0-before-mmap", "mmap reserves four anonymous pages");

    /*
     * NULL：让内核选择虚拟地址。
     * PROT_READ | PROT_WRITE：允许读和写；| 是按位或，用于组合标志位。
     * MAP_PRIVATE：本进程私有，修改不向其他映射共享。
     * MAP_ANONYMOUS：没有后备文件，所以 fd=-1、offset=0。
     * 成功返回时主要是地址范围/VMA 已建立，不代表 4 个数据页都已驻留。
     */
    p = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    /*
     * %p 要求 void *。p 是 volatile unsigned char *，因此仅为打印做类型转换。
     * 区间采用左闭右开形式：[BASE, END)，END 本身不属于映射。
     */
    printf("BASE=%p END=%p\n", (const void *)p,
           (const void *)((const char *)p + length));
    show_residency((void *)p, length);
    checkpoint("A1-after-mmap", "read page 0; a shared zero page may be used");

    /*
     * p[0] 解引用第 0 页第 0 字节。匿名新映射按语义读到 0；如果 PTE 尚未
     * 建立，CPU 触发读缺页，内核常可安装共享只读零页而不分配私有数据页。
     */
    value = p[0];
    printf("READ page=0 value=%u\n", value);
    show_residency((void *)p, length);
    checkpoint("A2-after-first-read", "write page 1; allocate a private page");

    /*
     * p[ps] 的地址是 BASE + 4096，即第 1 页（页号从 0 开始）的首字节。
     * 第一次写通常触发匿名写缺页：取私有物理页、清零并安装可写 PTE。
     */
    p[ps] = 0x5a;
    printf("WRITE page=1 value=%u\n", p[ps]);
    show_residency((void *)p, length);
    checkpoint("A3-after-first-write", "write page 3; page 2 stays untouched");

    /*
     * 直接跳到第 3 页；第 2 页从未访问，仍可没有数据页。这演示“虚拟地址
     * 区间连续”不等于“所有虚拟页已驻留”，也不要求物理页连续。
     */
    p[3 * ps] = 0xa5;
    printf("WRITE page=3 value=%u\n", p[3 * ps]);
    show_residency((void *)p, length);
    checkpoint("A4-sparse-pages", "MADV_DONTNEED discards page 1 contents");

    /*
     * p + ps 指向第 1 页首字节。对该一页声明 MADV_DONTNEED，表示旧内容
     * 不再需要；VMA 可继续存在，但相应 PTE/匿名页可以被撤销。成功返回 0。
     */
    if (madvise((void *)(p + ps), (size_t)ps, MADV_DONTNEED) != 0) {
        perror("madvise");
        return EXIT_FAILURE;
    }
    show_residency((void *)p, length);
    checkpoint("A5-after-madvise", "munmap removes the VMA and remaining PTEs");

    /* 撤销整个 [p, p+length)；成功后 p 还保存旧数值，但已不能再解引用。 */
    if (munmap((void *)p, length) != 0) {
        perror("munmap");
        return EXIT_FAILURE;
    }
    puts("DONE anon-lazy: old BASE is now invalid");
    checkpoint("A6-after-munmap", "exit");
    /* main 返回 0 表示程序成功。 */
    return 0;
}
