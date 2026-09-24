/*
 * 实验 03：观察 glibc malloc 的小对象、大对象与 program break。
 *
 * 重要边界：malloc/free 是 libc 用户态分配器接口，不是系统调用。libc 可以
 * 复用已有 chunk，也可能用 brk 扩展传统 heap，或用 mmap 建独立大映射。
 */
#define _GNU_SOURCE
/* glibc 专用的 mallopt、malloc_trim 和 M_MMAP_THRESHOLD。 */
#include <malloc.h>
/* uintptr_t 是能够无损保存指针数值的无符号整数类型。 */
#include <stdint.h>
#include "lab.h"

int main(int argc, char **argv)
{
    /* const 表示这两个局部变量初始化后不再修改。 */
    const size_t small_size = 64;
    const size_t large_size = 1024 * 1024;
    /*
     * malloc 返回 void *，C 会转换为这里的字节指针。volatile 保证后面的
     * 教学触碰不会被编译器优化掉；malloc 对象本身并没有 volatile 属性。
     */
    volatile unsigned char *small;
    volatile unsigned char *large;

    /* 分别记录各阶段的 program break，用来观察传统 [heap] 顶端是否变化。 */
    void *brk0;
    void *brk1;
    void *brk2;
    void *brk_after_free;
    /* malloc_trim 返回非零表示成功向系统归还了一些 heap 顶端空间。 */
    int trim_result;

    lab_init(argc, argv);

    /*
     * 请求 glibc 把 128 KiB 作为 mmap 阈值。本实验的 1 MiB 请求因而更容易
     * 走独立 mmap。它只是本次 libc 策略提示，不是 Linux 内核的固定规则。
     */
    if (mallopt(M_MMAP_THRESHOLD, 128 * 1024) == 0)
        fputs("warning: mallopt did not accept M_MMAP_THRESHOLD\n", stderr);

    /*
     * sbrk(0) 不增长 heap，只查询当前 program break，即传统堆的逻辑末端。
     * 返回的是地址数值，所以用 void * 保存并以 %p 打印。
     */
    brk0 = sbrk(0);
    printf("LAB=malloc-brk page_size=%ld INITIAL_BRK=%p\n", page_size(), brk0);
    checkpoint("M0-before-malloc", "malloc 64 bytes; allocator may grow or reuse heap");

    /*
     * 请求 64 字节。成功时 small 指向至少 64 个可供本程序使用的字节；
     * 该指针前后可能还有 glibc chunk 元数据，但程序不应访问它们。
     */
    small = malloc(small_size);
    /* malloc 失败返回 NULL；!small 就是 small == NULL。 */
    if (!small) {
        perror("malloc small");
        return EXIT_FAILURE;
    }

    /* malloc 返回后再次查询 break，判断 allocator 是否扩展了传统 heap。 */
    brk1 = sbrk(0);
    printf("SMALL=%p SIZE=%zu PAGE_OFFSET=%#lx BRK=%p\n",
           (const void *)small, small_size,
           /*
            * 地址 & (page_size-1) 取页内低位偏移。4 KiB 页时掩码为 0xfff。
            * 指针先转 uintptr_t，才能执行整数按位与运算。
            */
           (unsigned long)((uintptr_t)small & (page_size() - 1)), brk1);
    checkpoint("M1-small-returned", "touch small object");

    /* 真正写对象首字节；malloc 自身也可能已经因管理元数据触碰过所在页。 */
    small[0] = 0x11;

    checkpoint("M2-small-touched", "malloc 1 MiB; threshold encourages mmap");

    /* 请求 1 MiB。结合上面的阈值，它通常比 64 B 请求更容易走 mmap。 */
    large = malloc(large_size);
    if (!large) {
        perror("malloc large");
        /* 大对象失败时仍释放已经成功取得的小对象。 */
        free((void *)small);
        return EXIT_FAILURE;
    }

    brk2 = sbrk(0);
    printf("LARGE=%p SIZE=%zu PAGE_OFFSET=%#lx BRK=%p\n",
           (const void *)large, large_size,
           (unsigned long)((uintptr_t)large & (page_size() - 1)), brk2);
    checkpoint("M3-large-returned", "touch first and last bytes of large object");

    /*
     * 只写 1 MiB 对象的首、尾字节，中间页面不一定被触碰。
     * large_size - 1 是最后一个合法下标；large[large_size] 会越界。
     */
    large[0] = 0x22;
    large[large_size - 1] = 0x33;

    checkpoint("M4-large-touched", "free large then small; observe maps and brk");

    /*
     * free 把对象交还给 glibc。大 mmap 块可能触发 munmap；小块通常进入
     * allocator 的空闲结构供以后复用，不能假定每次 free 都进入内核。
     * free 参数的 void * 转换去掉 volatile 限定，只用于调用标准接口。
     */
    free((void *)large);
    free((void *)small);

    /* 尝试把传统 heap 顶部未用空间归还内核，再记录最终 break。 */
    trim_result = malloc_trim(0);
    brk_after_free = sbrk(0);
    printf("AFTER_FREE_BRK=%p malloc_trim=%d\n", brk_after_free, trim_result);
    checkpoint("M5-after-free", "exit");
    puts("DONE malloc-brk");
    return 0;
}
