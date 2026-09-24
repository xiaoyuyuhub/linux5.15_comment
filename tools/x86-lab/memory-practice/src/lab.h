/*
 * lab.h：五个内存实验共用的小工具。
 *
 * 这是“头文件”，不是一个单独运行的程序。每个 0x_*.c 都会通过
 * #include "lab.h" 把下面这些声明和小函数包含进去。这样各实验只需关注
 * 自己的内存操作，不必重复写暂停、错误检查和 mincore 输出代码。
 */

/*
 * 头文件保护（header guard）：同一个 .c 即使间接包含 lab.h 多次，也只展开
 * 一次，避免函数和变量被重复定义。
 */
#ifndef MEMORY_PRACTICE_LAB_H
#define MEMORY_PRACTICE_LAB_H

/* 标准输入输出：printf、fputs、getchar、perror。 */
#include <errno.h>
#include <stdio.h>
/* 通用工具：calloc、free、exit、EXIT_SUCCESS/EXIT_FAILURE。 */
#include <stdlib.h>
/* 字符串比较：strcmp。 */
#include <string.h>
/* 内存映射接口：mmap、mincore、MAP_FAILED 等。 */
#include <sys/mman.h>
/* POSIX 接口：sysconf、getpid。 */
#include <unistd.h>

/*
 * 0 表示交互学习模式：每个 CHECKPOINT 等待 Enter。
 * 1 表示自动模式：只打印阶段，不暂停，便于冒烟测试。
 *
 * static 让每个 .c 文件拥有自己的副本，不会导出同名全局符号。
 * 未显式初始化的静态存储期整数会由 C 语言保证初始化为 0。
 */
static int lab_auto;

/*
 * argc 是命令行参数个数；argv 是“字符串指针数组”。
 * 例如：./01_anon_lazy --auto
 *   argc == 2
 *   argv[0] == "./01_anon_lazy"
 *   argv[1] == "--auto"
 */
static inline void lab_init(int argc, char **argv)
{
    /* 只接受无参数的交互模式，或唯一参数 --auto。 */
    if (argc == 2 && strcmp(argv[1], "--auto") == 0) {
        lab_auto = 1;
    } else if (argc != 1) {
        /* stderr 是标准错误；即使 stdout 被重定向，错误仍可单独看到。 */
        fprintf(stderr, "usage: %s [--auto]\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    /*
     * 关闭 stdout 缓冲。实验一打印 PID/地址，观察终端和 GDB 就立即能看到；
     * 否则输出可能暂存在 libc 缓冲区，到换行、缓冲区满或退出时才显示。
     */
    setvbuf(stdout, NULL, _IONBF, 0);
}

/*
 * 教学暂停点。name 是当前阶段名，next 描述按 Enter 后执行的唯一关键动作。
 * const char * 表示“指向只读字符序列的指针”，函数不会修改传入字符串。
 */
static inline void checkpoint(const char *name, const char *next)
{
    /* getchar 返回 int，才能同时表示所有 unsigned char 值和特殊值 EOF。 */
    int ch;

    printf("\nCHECKPOINT %s pid=%ld\n", name, (long)getpid());
    printf("NEXT: %s\n", next);

    /* 单行 if 不强制写花括号；条件为真时直接返回调用者。 */
    if (lab_auto)
        return;

    fputs("Press Enter to continue...", stdout);

    /*
     * 丢弃 Enter 前可能输入的其他字符，一直读到换行或输入流关闭。
     * do...while 会先执行一次 getchar，再判断是否继续。
     */
    do {
        ch = getchar();
    } while (ch != '\n' && ch != EOF);

    /* EOF 表示 stdin 已关闭，程序无法再按阶段推进，因此明确失败退出。 */
    if (ch == EOF) {
        fputs("\nstdin closed\n", stderr);
        exit(EXIT_FAILURE);
    }
}

static inline long page_size(void)
{
    /* 向当前 Linux 查询运行时页大小，不把 4096 写死在 C 逻辑中。 */
    long value = sysconf(_SC_PAGESIZE);

    if (value <= 0) {
        /* perror 会把 errno 对应的系统错误文字附在参数后。 */
        perror("sysconf(_SC_PAGESIZE)");
        exit(EXIT_FAILURE);
    }
    return value;
}

static inline void show_residency(void *address, size_t length)
{
    long ps = page_size();
    /*
     * 向上取整得到覆盖 [address, address + length) 的页数。
     * 例如 length=4097、ps=4096 时：(4097+4095)/4096 == 2。
     * size_t 是专门表示对象大小和数组下标的无符号整数类型。
     */
    size_t pages = (length + (size_t)ps - 1) / (size_t)ps;

    /*
     * mincore 要求调用者提供结果数组，每页占一个字节。
     * calloc(pages, 1) 分配 pages 个字节并清零；vec 是首字节地址。
     * 这个小辅助数组属于观察开销，不是目标映射的数据页。
     */
    unsigned char *vec = calloc(pages, 1);
    size_t i;

    /* C 中空指针在条件判断里为假，所以 !vec 表示分配失败。 */
    if (!vec) {
        perror("calloc(mincore vector)");
        exit(EXIT_FAILURE);
    }

    /*
     * mincore 查询每个虚拟页当前是否驻留。成功返回 0，失败返回 -1。
     * address 使用 void *，表示这里只传地址，不在函数接口中规定数据类型。
     */
    if (mincore(address, length, vec) != 0) {
        perror("mincore");
        free(vec);
        exit(EXIT_FAILURE);
    }
    fputs("mincore resident=", stdout);

    /* vec[i] 最低位为 1 表示第 i 页驻留；?: 是三目条件表达式。 */
    for (i = 0; i < pages; ++i)
        putchar((vec[i] & 1) ? '1' : '0');
    putchar('\n');

    /* 观察结果打印完后释放辅助数组，避免工具自身泄漏。 */
    free(vec);
}

/*
 * 带统一错误检查的 mmap 包装器。参数与 mmap 完全对应：
 *   address：期望地址；NULL 表示让内核选择。
 *   length：字节长度。
 *   prot：允许读/写/执行的权限组合。
 *   flags：匿名/文件、私有/共享、是否预填充等策略。
 *   fd/offset：文件映射的文件描述符和文件偏移；匿名映射通常为 -1/0。
 */
static inline void *checked_mmap(void *address, size_t length, int prot,
                                 int flags, int fd, off_t offset)
{
    /* mmap 成功返回映射起始虚拟地址，失败返回特殊值 MAP_FAILED。 */
    void *result = mmap(address, length, prot, flags, fd, offset);

    /* MAP_FAILED 通常等价于 (void *)-1，不是 NULL，必须按接口约定判断。 */
    if (result == MAP_FAILED) {
        perror("mmap");
        exit(EXIT_FAILURE);
    }
    return result;
}

/* 与开头的 #ifndef/#define 配对，结束头文件保护。 */
#endif
