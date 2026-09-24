/*
 * 实验 04：fork 后的写时复制（Copy-On-Write，COW）。
 *
 * 父进程先写好一页，再 fork。fork 后父子看到相同虚拟地址和初始内容，
 * 内核通常让双方暂时共享同一个物理页并把 PTE 设成只读。子进程第一次写
 * 时触发写保护缺页，内核复制页面；子看到 C，父仍看到 P。
 *
 * 两组 pipe 用来把执行顺序固定下来，否则父子并发运行，GDB 很难稳定地在
 * “子写入之前”和“子写入之后”观察同一个阶段。
 */
#define _GNU_SOURCE
/* pid_t 等进程相关类型。 */
#include <sys/types.h>
/* waitpid 和子进程状态。 */
#include <sys/wait.h>
#include "lab.h"

int main(int argc, char **argv)
{
    long ps;
    /* p 指向目标匿名页；volatile 保证教学用的读写实际发生。 */
    volatile unsigned char *p;

    /*
     * pipe(int fd[2]) 返回两个文件描述符：
     *   fd[0]：读端
     *   fd[1]：写端
     * go   由父写、子读，表示“子可以继续”。
     * done 由子写、父读，表示“子已经完成本阶段”。
     */
    int go[2];
    int done[2];

    /* fork 在父进程返回子 PID，在子进程返回 0；pid_t 专门保存 PID。 */
    pid_t child;

    /* 管道只需要传 1 字节作为信号，字节内容本身没有业务含义。 */
    char token = 'x';
    /* waitpid 把子进程退出状态写到这里。 */
    int status;

    lab_init(argc, argv);
    ps = page_size();

    /* 建立一页匿名私有映射。fork 后 MAP_PRIVATE 映射具备 COW 语义。 */
    p = checked_mmap(NULL, (size_t)ps, PROT_READ | PROT_WRITE,
                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    /* fork 前先写入 P，确保父进程已经有一个真实的私有匿名数据页。 */
    p[0] = 'P';

    /* 创建两条单向同步管道；任意一次失败都结束实验。 */
    if (pipe(go) != 0 || pipe(done) != 0) {
        perror("pipe");
        return EXIT_FAILURE;
    }
    printf("LAB=fork-cow PARENT_PID=%ld BASE=%p INITIAL=%c\n",
           (long)getpid(), (const void *)p, p[0]);
    checkpoint("C0-before-fork", "fork creates a child sharing COW mappings");

    /*
     * fork 从这一刻复制进程执行现场，所以父子都会从下一行继续：
     *   child < 0：创建失败；
     *   child == 0：当前正在子进程；
     *   child > 0：当前仍是父进程，数值是子 PID。
     */
    child = fork();
    if (child < 0) {
        perror("fork");
        return EXIT_FAILURE;
    }

    if (child == 0) {
        /*
         * 子进程只读 go[0]、只写 done[1]，所以关闭自己永远不用的另外两端。
         * 及时关闭无用端也能避免管道 EOF/生命周期判断被多余引用干扰。
         */
        close(go[1]);
        close(done[0]);

        /* p 的虚拟地址与父进程相同，初始值也应为 P。 */
        printf("CHILD_READY CHILD_PID=%ld BASE=%p VALUE=%c\n",
               (long)getpid(), (const void *)p, p[0]);

        /* read 在父进程尚未写 token 时阻塞，让子稳定停在 COW 写入之前。 */
        if (read(go[0], &token, 1) != 1)
            _exit(2);

        /*
         * 本实验核心语句。PTE 此时通常是 present 但不可写；CPU 触发写保护
         * fault，内核走 do_wp_page/wp_page_copy，为子进程建立可写私有副本。
         */
        p[0] = 'C';
        printf("CHILD_AFTER_WRITE CHILD_PID=%ld VALUE=%c\n",
               (long)getpid(), p[0]);

        /* 通知父进程：COW 写入已经完成，可以检查父视图。 */
        if (write(done[1], &token, 1) != 1)
            _exit(3);

        /* 再等父进程允许退出，使 C2 阶段仍能同时观察父子。 */
        if (read(go[0], &token, 1) != 1)
            _exit(4);

        /*
         * 子进程用 _exit，直接进入内核退出，不重复刷新继承的 stdio 状态。
         * 数字 0 是成功状态；2/3/4 用来区分前面哪个同步步骤失败。
         */
        _exit(0);
    }

    /* 下面只有父进程执行：父只写 go[1]、只读 done[0]。 */
    close(go[0]);
    close(done[1]);
    printf("PARENT_AFTER_FORK PARENT_PID=%ld CHILD_PID=%ld BASE=%p VALUE=%c\n",
           (long)getpid(), (long)child, (const void *)p, p[0]);
    checkpoint("C1-child-before-write", "release child to write the COW page");

    /*
     * 父先写 1 字节唤醒子，再读 done 等子写完。&&/|| 的短路性质让任一 I/O
     * 返回值不是 1 时立即进入错误分支。
     */
    if (write(go[1], &token, 1) != 1 || read(done[0], &token, 1) != 1) {
        perror("pipe synchronization");
        return EXIT_FAILURE;
    }

    /* 若 COW 正确，子写 C 后父自己的地址仍读到 P。 */
    printf("PARENT_AFTER_CHILD_WRITE VALUE=%c (must remain P)\n", p[0]);
    checkpoint("C2-after-cow", "allow child to exit and then reap it");

    /*
     * 再发一个 token 允许子 _exit，然后 waitpid 回收指定子进程。
     * waitpid 成功返回被回收的 child PID。
     */
    if (write(go[1], &token, 1) != 1 || waitpid(child, &status, 0) != child) {
        perror("finish child");
        return EXIT_FAILURE;
    }
    printf("CHILD_STATUS=%d PARENT_VALUE=%c\n", status, p[0]);

    /* 父进程最后撤销自己的那一页；子进程的 mm 已在退出路径中回收。 */
    if (munmap((void *)p, (size_t)ps) != 0) {
        perror("munmap");
        return EXIT_FAILURE;
    }
    puts("DONE fork-cow");
    return 0;
}
