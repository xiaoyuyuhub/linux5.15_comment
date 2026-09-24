/*
 * 00_memory_tour.c
 *
 * 一个文件走完“用户程序申请内存”的主要分支。
 *
 * 推荐不要第一次就运行 all。请按下面顺序逐个执行：
 *
 *   ./00_memory_tour mmap
 *   ./00_memory_tour brk
 *   ./00_memory_tour malloc
 *   ./00_memory_tour populate
 *   ./00_memory_tour cow
 *   ./00_memory_tour file
 *
 * 每个 tour_* 函数都是一节独立实验。程序使用 -O0、-g3、-fno-pie 编译，
 * 并用 TOUR_NOINLINE 阻止编译器把这些教学函数合并进 main，方便在 CLion
 * 中直接按函数名设置断点。
 *
 * 本文件关注从用户 API 到内核运行期内存管理，不再讲启动期初始化：
 *
 *   用户 C 代码
 *     → glibc 包装函数
 *     → syscall 指令
 *     → Linux 系统调用入口
 *     → 建立/修改 VMA
 *     → 用户访问地址
 *     → CPU 缺页异常
 *     → 分配物理页
 *     → 安装 PTE
 *     → 释放映射或交还用户态分配器
 */

#define _GNU_SOURCE

#include <fcntl.h>      /* open、O_CREAT、O_TRUNC、O_RDWR */
#include <malloc.h>     /* mallopt、malloc_trim */
#include <stdint.h>     /* uintptr_t */
#include <sys/types.h>  /* pid_t */
#include <sys/wait.h>   /* waitpid */

#include "lab.h"

/*
 * __attribute__((noinline)) 是 GCC 属性：即使以后改变优化参数，也尽量保留
 * 独立函数。这样 CLion/GDB 可以使用 hbreak tour_mmap_lazy 之类的名字。
 */
#define TOUR_NOINLINE __attribute__((noinline))

/* 打印每个分支的标题，让串口日志容易分段。 */
static void print_title(const char *name, const char *question)
{
    printf("\n============================================================\n");
    printf("TOUR %s pid=%ld\n", name, (long)getpid());
    printf("QUESTION: %s\n", question);
    printf("============================================================\n");
}

/*
 * 分支一：普通匿名 mmap。
 *
 * 这个分支特意把“取得地址”和“取得物理页”拆开：
 *
 *   L0：调用 mmap 前
 *   L1：mmap 已返回，只建立了合法虚拟区间
 *   L2：只读第 0 页，可能映射共享只读零页
 *   L3：再写第 0 页，触发写保护/COW，取得私有页
 *   L4：直接写第 2 页，触发首次匿名写缺页；第 1 页始终不访问
 *   L5：munmap 撤销整个区间
 */
static TOUR_NOINLINE void tour_mmap_lazy(void)
{
    long ps = page_size();
    size_t length = 3 * (size_t)ps;
    volatile unsigned char *p;
    unsigned char first_read;

    print_title("mmap", "mmap 返回地址时，物理页是否已经全部分配？");
    checkpoint("L0-before-mmap", "call glibc mmap, then enter __x64_sys_mmap");

    /*
     * 这是用户态 glibc mmap API。<sys/mman.h> 提供声明；静态链接把 glibc
     * 包装代码放进本 ELF。包装器准备寄存器并执行 syscall，内核才会操作 VMA。
     */
    p = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    printf("MMAP_BASE=%p MMAP_END=%p LENGTH=%zu\n",
           (const void *)p, (const void *)(p + length), length);
    show_residency((void *)p, length);
    checkpoint("L1-mmap-returned", "read page 0; expect a not-present read fault");

    /* 第一次读匿名页，内核可用共享只读 zero page 满足全零语义。 */
    first_read = p[0];
    printf("FIRST_READ=%u\n", first_read);
    show_residency((void *)p, length);
    checkpoint("L2-zero-page-read", "write page 0; expect write-protect/COW fault");

    /*
     * 如果上一步安装了共享只读零页，这次写会因 PTE 不可写再次 fault，
     * 常见路径进入 do_wp_page，为当前进程建立真正的私有匿名页。
     */
    p[0] = 0x11;
    printf("PAGE0_AFTER_WRITE=%u\n", p[0]);
    show_residency((void *)p, length);
    checkpoint("L3-private-page0", "write page 2; page 1 remains untouched");

    /*
     * p[2 * ps] 是第 2 页首字节。它之前从未读过，第一次就是写，常见路径
     * 直接进入 do_anonymous_page 分配清零页并建立可写 PTE。
     */
    p[2 * ps] = 0x22;
    printf("PAGE2_AFTER_WRITE=%u\n", p[2 * ps]);
    show_residency((void *)p, length);
    checkpoint("L4-sparse-touch", "munmap the complete virtual range");

    if (munmap((void *)p, length) != 0) {
        perror("munmap mmap tour");
        exit(EXIT_FAILURE);
    }
    puts("L5: mmap range removed; MMAP_BASE is no longer legal to access");
}

/*
 * brk 分支真正修改进程 program break。
 *
 * 直接改变 brk 可能与 glibc malloc 自己维护的 heap 状态冲突，所以实验让
 * 一个短命子进程执行这段操作。子进程结束时整个 mm 都会回收，主进程的
 * allocator 状态完全不受影响。
 */
static TOUR_NOINLINE void tour_brk_child(void)
{
    long ps = page_size();
    size_t length = 2 * (size_t)ps;
    void *old_break;
    void *returned;
    void *new_break;
    volatile unsigned char *p;

    print_title("brk-child", "brk 怎样扩大 [heap]，访问时又怎样得到物理页？");

    /* sbrk(0) 只查询当前 program break，不改变它。 */
    old_break = sbrk(0);
    printf("OLD_BREAK=%p REQUEST_BYTES=%zu\n", old_break, length);
    checkpoint("B0-before-sbrk", "glibc sbrk asks kernel brk to grow by two pages");

    /*
     * sbrk(length) 成功时返回增长前的 break；失败返回 (void *)-1。
     * glibc 的 sbrk 最终通过 brk 系统调用请求内核改变 mm->brk/heap VMA。
     */
    returned = sbrk((intptr_t)length);
    if (returned == (void *)-1) {
        perror("sbrk grow");
        _exit(20);
    }
    new_break = sbrk(0);
    p = returned;
    printf("SBRK_RETURNED=%p NEW_BREAK=%p\n", returned, new_break);
    checkpoint("B1-brk-grown", "touch the first byte of both new heap pages");

    /* brk 扩大的是合法地址范围；这两次首次写才通常触发匿名页分配。 */
    p[0] = 0x31;
    p[ps] = 0x32;
    printf("HEAP_PAGE0=%u HEAP_PAGE1=%u\n", p[0], p[ps]);
    checkpoint("B2-new-heap-touched", "shrink program break back to OLD_BREAK");

    /* brk(old_break) 直接指定新的 program break；成功返回 0。 */
    if (brk(old_break) != 0) {
        perror("brk shrink");
        _exit(21);
    }
    printf("B3: CURRENT_BREAK=%p; child will exit\n", sbrk(0));
    _exit(0);
}

static TOUR_NOINLINE void tour_brk(void)
{
    pid_t child;
    int status;

    print_title("brk", "为什么把直接 brk 实验放进独立子进程？");
    checkpoint("B-parent-before-fork", "fork a disposable child for the brk experiment");

    child = fork();
    if (child < 0) {
        perror("fork brk child");
        exit(EXIT_FAILURE);
    }
    if (child == 0)
        tour_brk_child();

    if (waitpid(child, &status, 0) != child) {
        perror("waitpid brk child");
        exit(EXIT_FAILURE);
    }
    printf("B-parent: child=%ld wait_status=%d\n", (long)child, status);
}

/*
 * 分支三：malloc 小对象和大对象。
 *
 * malloc/free 是用户态分配器接口，不是系统调用。我们比较 program break、
 * 返回地址和 /proc/PID/maps，判断这一次 glibc 是复用 heap 还是调用 mmap。
 */
static TOUR_NOINLINE void tour_malloc(void)
{
    const size_t small_size = 64;
    const size_t large_size = 1024 * 1024;
    volatile unsigned char *small;
    volatile unsigned char *large;
    void *break_before;
    void *break_after_small;
    void *break_after_large;
    void *break_after_free;
    int trim_result;

    print_title("malloc", "malloc 何时复用用户态 chunk，何时调用 brk 或 mmap？");

    /* 让 1 MiB 请求更稳定地展示 mmap；这是 glibc 策略，不是内核规则。 */
    if (mallopt(M_MMAP_THRESHOLD, 128 * 1024) == 0)
        fputs("warning: mallopt did not accept threshold\n", stderr);

    break_before = sbrk(0);
    printf("MALLOC_BREAK_BEFORE=%p\n", break_before);
    checkpoint("M0-before-small", "malloc 64 bytes; it may reuse an existing chunk");

    small = malloc(small_size);
    if (!small) {
        perror("malloc small");
        exit(EXIT_FAILURE);
    }
    break_after_small = sbrk(0);
    printf("SMALL=%p SIZE=%zu PAGE_OFFSET=%#lx BREAK=%p\n",
           (const void *)small, small_size,
           (unsigned long)((uintptr_t)small & (page_size() - 1)),
           break_after_small);
    checkpoint("M1-small-returned", "write the first byte of the small object");
    small[0] = 0x41;

    checkpoint("M2-before-large", "malloc 1 MiB; threshold encourages mmap");
    large = malloc(large_size);
    if (!large) {
        perror("malloc large");
        free((void *)small);
        exit(EXIT_FAILURE);
    }
    break_after_large = sbrk(0);
    printf("LARGE=%p SIZE=%zu PAGE_OFFSET=%#lx BREAK=%p\n",
           (const void *)large, large_size,
           (unsigned long)((uintptr_t)large & (page_size() - 1)),
           break_after_large);
    checkpoint("M3-large-returned", "write first and last byte; middle stays untouched");

    large[0] = 0x51;
    large[large_size - 1] = 0x52;
    checkpoint("M4-before-free", "free large then small; watch munmap and heap reuse");

    /* 大块可能 munmap；小块通常只回到 glibc 的空闲结构。 */
    free((void *)large);
    free((void *)small);
    trim_result = malloc_trim(0);
    break_after_free = sbrk(0);
    printf("M5: BREAK_AFTER_FREE=%p MALLOC_TRIM=%d\n",
           break_after_free, trim_result);
}

/* 比较普通 mmap 与 mmap(MAP_POPULATE)。 */
static TOUR_NOINLINE void tour_populate(void)
{
    long ps = page_size();
    size_t length = 3 * (size_t)ps;
    void *lazy;
    void *populated;

    print_title("populate", "物理页可以在 mmap 返回前主动准备吗？");
    checkpoint("P0-before-maps", "create lazy mapping, then MAP_POPULATE mapping");

    lazy = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    populated = checked_mmap(NULL, length, PROT_READ | PROT_WRITE,
                             MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
                             -1, 0);

    printf("LAZY=%p POPULATED=%p LENGTH=%zu\n", lazy, populated, length);
    fputs("LAZY_", stdout);
    show_residency(lazy, length);
    fputs("POPULATED_", stdout);
    show_residency(populated, length);
    checkpoint("P1-maps-returned", "write last page in both mappings");

    ((volatile unsigned char *)lazy)[2 * ps] = 0x61;
    ((volatile unsigned char *)populated)[2 * ps] = 0x62;
    fputs("LAZY_", stdout);
    show_residency(lazy, length);
    fputs("POPULATED_", stdout);
    show_residency(populated, length);

    if (munmap(lazy, length) != 0 || munmap(populated, length) != 0) {
        perror("munmap populate tour");
        exit(EXIT_FAILURE);
    }
}

/*
 * fork COW 分支使用两条管道固定父子顺序。go 由父通知子开始写，done 由子
 * 通知父写入完成。这样 C1 是稳定的“子写之前”，C2 是稳定的“子写之后”。
 */
static TOUR_NOINLINE void tour_cow(void)
{
    long ps = page_size();
    volatile unsigned char *p;
    int go[2];
    int done[2];
    char token = 'x';
    pid_t child;
    int status;

    print_title("cow", "fork 后相同虚拟地址何时得到不同物理页？");

    p = checked_mmap(NULL, (size_t)ps, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    p[0] = 'P';
    if (pipe(go) != 0 || pipe(done) != 0) {
        perror("pipe cow");
        exit(EXIT_FAILURE);
    }
    printf("COW_PARENT=%ld COW_BASE=%p VALUE=%c\n",
           (long)getpid(), (const void *)p, p[0]);
    checkpoint("C0-before-fork", "fork; parent and child initially share COW page");

    child = fork();
    if (child < 0) {
        perror("fork cow");
        exit(EXIT_FAILURE);
    }
    if (child == 0) {
        close(go[1]);
        close(done[0]);
        printf("COW_CHILD_READY=%ld COW_BASE=%p VALUE=%c\n",
               (long)getpid(), (const void *)p, p[0]);
        if (read(go[0], &token, 1) != 1)
            _exit(30);

        /* 本分支的核心语句：子写 present-but-read-only COW PTE。 */
        p[0] = 'C';
        printf("COW_CHILD_AFTER_WRITE=%c\n", p[0]);
        if (write(done[1], &token, 1) != 1)
            _exit(31);
        if (read(go[0], &token, 1) != 1)
            _exit(32);
        _exit(0);
    }

    close(go[0]);
    close(done[1]);
    printf("COW_CHILD_PID=%ld\n", (long)child);
    checkpoint("C1-child-before-write", "release child; break at do_wp_page/wp_page_copy");

    if (write(go[1], &token, 1) != 1 || read(done[0], &token, 1) != 1) {
        perror("synchronize cow");
        exit(EXIT_FAILURE);
    }
    printf("C2: PARENT_VALUE=%c (must remain P)\n", p[0]);
    checkpoint("C2-after-child-write", "let child exit and reap it");

    if (write(go[1], &token, 1) != 1 || waitpid(child, &status, 0) != child) {
        perror("finish cow child");
        exit(EXIT_FAILURE);
    }
    if (munmap((void *)p, (size_t)ps) != 0) {
        perror("munmap cow");
        exit(EXIT_FAILURE);
    }
    printf("C3: CHILD_STATUS=%d parent mapping removed\n", status);
}

/* 同一文件同时建立 MAP_SHARED 和 MAP_PRIVATE 映射。 */
static TOUR_NOINLINE void tour_file(void)
{
    long ps = page_size();
    char path[128];
    int fd;
    volatile unsigned char *shared;
    volatile unsigned char *private;
    unsigned char file_value;

    print_title("file", "文件共享映射和私有映射的写入为什么不同？");

    snprintf(path, sizeof(path), "/tmp/memory-tour-%ld", (long)getpid());
    fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0600);
    if (fd < 0 || ftruncate(fd, ps) != 0) {
        perror("prepare tour file");
        exit(EXIT_FAILURE);
    }

    shared = checked_mmap(NULL, (size_t)ps, PROT_READ | PROT_WRITE,
                          MAP_SHARED, fd, 0);
    private = checked_mmap(NULL, (size_t)ps, PROT_READ | PROT_WRITE,
                           MAP_PRIVATE, fd, 0);
    printf("FILE=%s SHARED=%p PRIVATE=%p\n",
           path, (const void *)shared, (const void *)private);
    checkpoint("F0-after-maps", "read both file mappings; enter filemap fault path");

    printf("F1: INITIAL_SHARED=%u INITIAL_PRIVATE=%u\n", shared[0], private[0]);
    checkpoint("F1-before-shared-write", "write S through MAP_SHARED and msync");

    shared[0] = 'S';
    if (msync((void *)shared, (size_t)ps, MS_SYNC) != 0 ||
        pread(fd, &file_value, 1, 0) != 1) {
        perror("shared write/msync/pread");
        exit(EXIT_FAILURE);
    }
    printf("F2: FILE=%c SHARED=%c PRIVATE_VIEW=%c\n",
           file_value, shared[0], private[0]);
    checkpoint("F2-before-private-write", "write P through MAP_PRIVATE; trigger COW");

    private[0] = 'P';
    if (pread(fd, &file_value, 1, 0) != 1) {
        perror("pread after private write");
        exit(EXIT_FAILURE);
    }
    printf("F3: FILE=%c SHARED=%c PRIVATE=%c\n",
           file_value, shared[0], private[0]);
    checkpoint("F3-before-cleanup", "unmap both views, close and unlink file");

    if (munmap((void *)shared, (size_t)ps) != 0 ||
        munmap((void *)private, (size_t)ps) != 0 ||
        close(fd) != 0 || unlink(path) != 0) {
        perror("cleanup tour file");
        exit(EXIT_FAILURE);
    }
}

static void usage(const char *program)
{
    fprintf(stderr,
            "usage: %s [all|mmap|brk|malloc|populate|cow|file] [--auto]\n",
            program);
}

/* 解析一个可选分支名和一个可选 --auto；不依赖复杂命令行库。 */
static const char *parse_mode(int argc, char **argv)
{
    const char *mode = "all";
    int mode_seen = 0;
    int i;

    for (i = 1; i < argc; ++i) {
        if (strcmp(argv[i], "--auto") == 0) {
            lab_auto = 1;
        } else if (!mode_seen) {
            mode = argv[i];
            mode_seen = 1;
        } else {
            usage(argv[0]);
            exit(EXIT_FAILURE);
        }
    }
    setvbuf(stdout, NULL, _IONBF, 0);
    return mode;
}

static int mode_is(const char *selected, const char *candidate)
{
    return strcmp(selected, "all") == 0 || strcmp(selected, candidate) == 0;
}

int main(int argc, char **argv)
{
    const char *mode = parse_mode(argc, argv);
    int matched = 0;

    printf("MEMORY_TOUR_START pid=%ld mode=%s page_size=%ld auto=%d\n",
           (long)getpid(), mode, page_size(), lab_auto);

    if (mode_is(mode, "mmap")) {
        matched = 1;
        tour_mmap_lazy();
    }
    if (mode_is(mode, "brk")) {
        matched = 1;
        tour_brk();
    }
    if (mode_is(mode, "malloc")) {
        matched = 1;
        tour_malloc();
    }
    if (mode_is(mode, "populate")) {
        matched = 1;
        tour_populate();
    }
    if (mode_is(mode, "cow")) {
        matched = 1;
        tour_cow();
    }
    if (mode_is(mode, "file")) {
        matched = 1;
        tour_file();
    }

    if (!matched) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    puts("\nMEMORY_TOUR_DONE");
    return EXIT_SUCCESS;
}
