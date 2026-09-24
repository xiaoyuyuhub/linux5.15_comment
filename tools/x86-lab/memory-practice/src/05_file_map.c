/*
 * 实验 05：同一文件的 MAP_SHARED 与 MAP_PRIVATE 映射。
 *
 * 目标是区分：
 *   1. 文件页进入 page cache 后，不同映射可以读到同一文件内容；
 *   2. MAP_SHARED 写入会修改共享文件页，msync 可要求写回；
 *   3. MAP_PRIVATE 写入触发 COW，只改变当前进程的私有视图。
 */
#define _GNU_SOURCE
/* open、O_CREAT/O_TRUNC/O_RDWR。 */
#include <fcntl.h>
/* 文件类型和权限相关声明。 */
#include <sys/stat.h>
#include "lab.h"

int main(int argc, char **argv)
{
    long ps;
    /* 保存 /tmp/mm-file-PID 路径；128 字节足够当前固定格式。 */
    char path[128];
    /* fd 是 file descriptor，内核用这个小整数定位本进程打开的文件。 */
    int fd;
    /* 两个指针映射同一文件，但修改语义不同。 */
    volatile unsigned char *shared;
    volatile unsigned char *private;
    /* 用 pread 从文件接口读取一个字节，与映射视图进行对照。 */
    unsigned char disk_byte;

    lab_init(argc, argv);
    ps = page_size();

    /*
     * snprintf 最多写 sizeof(path) 字节，避免缓冲区越界。把 PID 放进文件名，
     * 多次运行时更容易区分，也减少与已有临时文件重名的机会。
     */
    snprintf(path, sizeof(path), "/tmp/mm-file-%ld", (long)getpid());

    /*
     * O_CREAT：不存在就创建；O_TRUNC：存在就截断为 0；O_RDWR：可读可写。
     * 0600 是八进制权限：仅文件所有者可读写。
     * open 成功返回非负 fd，失败返回 -1。
     */
    fd = open(path, O_CREAT | O_TRUNC | O_RDWR, 0600);

    /*
     * ftruncate 把文件长度设为两页。新扩展部分按文件语义读取为零。
     * || 会短路：fd<0 时不会拿无效 fd 调 ftruncate。
     */
    if (fd < 0 || ftruncate(fd, 2 * ps) != 0) {
        perror("prepare file");
        return EXIT_FAILURE;
    }

    /*
     * MAP_SHARED：对映射的修改作用于共享 page cache，能够反映到底层文件。
     * fd 指定后备文件，offset=0 表示从文件开头映射两页。
     */
    shared = checked_mmap(NULL, 2 * (size_t)ps, PROT_READ | PROT_WRITE,
                          MAP_SHARED, fd, 0);

    /*
     * MAP_PRIVATE：读取可利用文件 page cache；写入采用 COW 私有页，不应把
     * 私有修改写回文件。两个 mmap 返回不同的用户虚拟地址。
     */
    private = checked_mmap(NULL, 2 * (size_t)ps, PROT_READ | PROT_WRITE,
                           MAP_PRIVATE, fd, 0);
    printf("LAB=file-map PID=%ld FILE=%s SHARED=%p PRIVATE=%p\n",
           (long)getpid(), path, (const void *)shared, (const void *)private);
    checkpoint("F0-after-mmap", "read both mappings; file page cache supplies data");

    /*
     * 首次读取两个映射的第 0 字节，可能触发 file-backed page fault。
     * 文件刚扩展且尚未写数据，所以两个视图都应读到数值 0。
     */
    printf("INITIAL shared=%u private=%u\n", shared[0], private[0]);
    checkpoint("F1-after-read", "write MAP_SHARED and msync it to the file");

    /* 修改共享映射的第一个字节；字符 'S' 本质上也是一个整数编码。 */
    shared[0] = 'S';

    /*
     * MS_SYNC 要求同步完成后再返回。msync 成功返回 0；这里同步第一页。
     * “写映射”与“数据何时真正写到底层存储”是两个阶段。
     */
    if (msync((void *)shared, (size_t)ps, MS_SYNC) != 0) {
        perror("msync");
        return EXIT_FAILURE;
    }

    /*
     * pread(fd, buffer, count, offset) 从指定文件偏移读，不改变 fd 的当前偏移。
     * &disk_byte 取变量地址，让内核把 1 字节写进该变量；成功应返回 1。
     */
    if (pread(fd, &disk_byte, 1, 0) != 1) {
        perror("pread");
        return EXIT_FAILURE;
    }

    /* private 尚未私有写入，因此仍可从文件/page cache 观察到 S。 */
    printf("AFTER_SHARED file=%c private_view=%c\n", disk_byte, private[0]);
    checkpoint("F2-after-shared-write", "write MAP_PRIVATE; a COW page is created");

    /*
     * 核心 COW 写入：private[0] 变成 P，但 shared 和文件应继续是 S。
     * 这通常会触发写保护 fault，并为 private 映射建立匿名私有副本。
     */
    private[0] = 'P';
    if (pread(fd, &disk_byte, 1, 0) != 1) {
        perror("pread");
        return EXIT_FAILURE;
    }
    printf("AFTER_PRIVATE file=%c shared=%c private=%c\n",
           disk_byte, shared[0], private[0]);
    checkpoint("F3-after-private-write", "unmap, close, and unlink the file");

    /*
     * 依次撤销两个 VMA、关闭文件描述符、删除 /tmp 目录项。
     * unlink 删除名字；已经打开/映射的对象会按引用生命周期延后真正回收。
     */
    if (munmap((void *)shared, 2 * (size_t)ps) != 0 ||
        munmap((void *)private, 2 * (size_t)ps) != 0 || close(fd) != 0 ||
        unlink(path) != 0) {
        perror("cleanup");
        return EXIT_FAILURE;
    }
    puts("DONE file-map");
    return 0;
}
