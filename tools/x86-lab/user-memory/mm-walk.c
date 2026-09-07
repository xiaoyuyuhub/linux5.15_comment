#define _GNU_SOURCE
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

static void pause_at(const char *stage)
{
    printf("\n%s -- press Enter\n", stage);
    int c;
    do { c = getchar(); } while (c != '\n' && c != EOF);
    if (c == EOF) exit(EXIT_FAILURE);
}

static void residency(void *base, size_t bytes)
{
    unsigned char vec[3];
    if (mincore(base, bytes, vec) != 0) { perror("mincore"); exit(1); }
    printf("resident pages [0,1,2]: %d%d%d\n",
           !!(vec[0] & 1), !!(vec[1] & 1), !!(vec[2] & 1));
}

int main(int argc, char **argv)
{
    setvbuf(stdout, NULL, _IONBF, 0);
    long ps = sysconf(_SC_PAGESIZE);
    if (ps <= 0) return 1;
    int use_malloc = argc == 2 && strcmp(argv[1], "malloc") == 0;
    if (argc > 2 || (argc == 2 && !use_malloc && strcmp(argv[1], "mmap") != 0)) {
        fprintf(stderr, "usage: %s [mmap|malloc]\n", argv[0]);
        return 1;
    }
    size_t bytes = 3 * (size_t)ps;
    printf("PID=%ld page_size=%ld mode=%s bytes=%zu\n",
           (long)getpid(), ps, use_malloc ? "malloc" : "mmap", bytes);
    pause_at("S0: before allocation");
    void *base = use_malloc ? malloc(bytes) :
        mmap(NULL, bytes, PROT_READ | PROT_WRITE,
             MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (base == NULL || base == MAP_FAILED) { perror("allocation"); return 1; }
    printf("base=%p end(exclusive)=%p\n", base, (char *)base + bytes);
    if (!use_malloc) residency(base, bytes);
    pause_at("S1: allocated; next write offset 0");
    volatile unsigned char *p = base;
    p[0] = 'A';
    if (!use_malloc) residency(base, bytes);
    pause_at("S2: wrote offset 0; next write offset 2*page_size");
    p[2 * (size_t)ps] = 'B';
    if (!use_malloc) residency(base, bytes);
    pause_at("S3: wrote second location; next release");
    if (use_malloc) free(base);
    else if (munmap(base, bytes) != 0) { perror("munmap"); return 1; }
    puts("released; the old pointer must no longer be dereferenced");
    pause_at("S4: released; next exit");
    return 0;
}
