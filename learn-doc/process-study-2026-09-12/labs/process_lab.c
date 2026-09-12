#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

/* 所有父子交接用 pipe/wait，线程交接用 join，不以 sleep 排序。 */
static void fail(const char *s) { perror(s); exit(1); }
static void check(int ok, const char *s) {
    if (!ok) { fprintf(stderr, "FAIL %s\n", s); exit(1); }
}
static void byte_write(int fd) {
    ssize_t r; do { r=write(fd,"x",1); } while(r<0 && errno==EINTR);
    if(r!=1) fail("write pipe");
}
static void byte_read(int fd) {
    char c; ssize_t r; do { r=read(fd,&c,1); } while(r<0 && errno==EINTR);
    check(r==1,"read pipe byte");
}
static void reap(pid_t p, int code) {
    int s; pid_t r; do { r=waitpid(p,&s,0); } while(r<0 && errno==EINTR);
    check(r==p && WIFEXITED(s) && WEXITSTATUS(s)==code,"wait status");
}
static void checkpoint(const char *s) {
    printf("CHECKPOINT %s pid=%ld tid=%ld\n",s,(long)getpid(),syscall(SYS_gettid));
    if(getenv("LAB_STEP")) { char c; printf("Press Enter to continue\n");
        while(read(STDIN_FILENO,&c,1)==1 && c!='\n') {} }
}
static void cow(void) {
    long n=sysconf(_SC_PAGESIZE); check(n>0,"pagesize");
    char *p=mmap(NULL,(size_t)n,PROT_READ|PROT_WRITE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0);
    if(p==MAP_FAILED) fail("mmap");
    p[0]='P'; /* fork 前先触页，避免零页分支干扰教学主路径。 */
    int a[2],b[2]; if(pipe(a)||pipe(b)) fail("pipe");
    checkpoint("before fork cow"); pid_t child=fork(); if(child<0) fail("fork");
    if(!child) {
        close(a[0]); close(b[1]);
        printf("child pid=%ld address=%p before=%c\n",(long)getpid(),(void*)p,p[0]);
        checkpoint("child before COW store"); p[0]='C'; byte_write(a[1]);
        byte_read(b[0]); check(p[0]=='C',"child value");
        close(a[1]); close(b[0]); _exit(0);
    }
    close(a[1]); close(b[0]); byte_read(a[0]);
    printf("parent pid=%ld child=%ld address=%p after child store=%c\n",
        (long)getpid(),(long)child,(void*)p,p[0]);
    check(p[0]=='P',"parent isolated"); checkpoint("parent after child COW");
    byte_write(b[1]); reap(child,0); close(a[0]); close(b[1]);
    if(munmap(p,(size_t)n)) fail("munmap");
    puts("PASS cow");
}
static int shared_value;
static void *worker(void *unused) {
    (void)unused;
    printf("thread pid=%ld tid=%ld shared_address=%p\n",(long)getpid(),syscall(SYS_gettid),(void*)&shared_value);
    shared_value=42; return NULL;
}
static void threads(void) {
    pthread_t t;
    printf("main pid=%ld tid=%ld shared_address=%p\n",(long)getpid(),syscall(SYS_gettid),(void*)&shared_value);
    int e=pthread_create(&t,NULL,worker,NULL); if(e) { errno=e; fail("pthread_create"); }
    e=pthread_join(t,NULL); if(e) { errno=e; fail("pthread_join"); }
    check(shared_value==42,"join synchronized value"); puts("PASS threads");
}
static void exec_child(char *pidtext) {
    check((long)getpid()==strtol(pidtext,NULL,10),"PID preserved by exec");
    printf("exec-child pid=%ld tid=%ld\n",(long)getpid(),syscall(SYS_gettid));
    checkpoint("after exec"); puts("PASS exec-child");
}
static void exec_lab(void) {
    checkpoint("before fork exec"); pid_t p=fork(); if(p<0) fail("fork");
    if(!p) {
        char id[32]; snprintf(id,sizeof(id),"%ld",(long)getpid());
        printf("before exec child pid=%s\n",id); checkpoint("child before exec");
        execl("/proc/self/exe","process_lab","exec-child",id,(char*)NULL);
        perror("execl"); _exit(127);
    }
    reap(p,0); puts("PASS exec");
}
static void fd_lab(void) {
    char name[]="/tmp/process-study-XXXXXX"; int fd=mkstemp(name); if(fd<0) fail("mkstemp");
    if(unlink(name)) fail("unlink");
    check(write(fd,"ABCDE",5)==5,"write file"); check(lseek(fd,0,SEEK_SET)==0,"rewind");
    pid_t p=fork(); if(p<0) fail("fork");
    if(!p) { char b[3]={0}; check(read(fd,b,2)==2,"child read");
        printf("child read=%s\n",b); check(strcmp(b,"AB")==0,"child AB"); _exit(0); }
    reap(p,0); char b[3]={0}; check(read(fd,b,2)==2,"parent read");
    printf("parent read=%s (shared open-file offset)\n",b);
    check(strcmp(b,"CD")==0,"shared f_pos"); close(fd); puts("PASS fd");
}
static void zombie(void) {
    /* 显式保持默认 SIGCHLD；排除父进程设置自动回收的实验干扰。 */
    signal(SIGCHLD,SIG_DFL);
    pid_t p=fork(); if(p<0) fail("fork"); if(!p) _exit(23);
    siginfo_t si; memset(&si,0,sizeof(si));
    int r; do { r=waitid(P_PID,(id_t)p,&si,WEXITED|WNOWAIT); } while(r<0 && errno==EINTR);
    if(r<0) fail("waitid");
    check(si.si_status==23,"WNOWAIT status");
    char path[80],line[256]; snprintf(path,sizeof(path),"/proc/%ld/status",(long)p);
    FILE *f=fopen(path,"r"); if(!f) fail("zombie status"); int z=0;
    while(fgets(line,sizeof(line),f)) if(!strncmp(line,"State:",6)) {
        printf("before waitpid child=%ld %s",(long)p,line); z=strchr(line,'Z')!=NULL; }
    fclose(f); check(z,"zombie visible"); checkpoint("zombie before reap");
    reap(p,23); errno=0; check(access(path,F_OK)==-1 && errno==ENOENT,"proc removed");
    puts("PASS zombie");
}
static void pipe_lab(void) {
    int f[2]; if(pipe(f)) fail("pipe"); pid_t p=fork(); if(p<0) fail("fork");
    if(!p) { close(f[1]); printf("child about to pipe read pid=%ld\n",(long)getpid());
        byte_read(f[0]); close(f[0]); _exit(0); }
    close(f[0]); checkpoint("parent before waking reader");
    /* 延迟只扩大 trace 观察窗口；正确性由管道与 wait 保证。 */
    sleep(1); byte_write(f[1]); close(f[1]); reap(p,0); puts("PASS pipe");
}
int main(int argc,char **argv) {
    setvbuf(stdout,NULL,_IONBF,0); prctl(PR_SET_NAME,"process_lab",0,0,0);
    if(argc<2) { fprintf(stderr,"usage: %s cow|exec|threads|fd|zombie|pipe|all\n",argv[0]); return 2; }
    if(!strcmp(argv[1],"exec-child") && argc==3) { exec_child(argv[2]); return 0; }
    if(!strcmp(argv[1],"cow")) cow();
    else if(!strcmp(argv[1],"exec")) exec_lab();
    else if(!strcmp(argv[1],"threads")) threads();
    else if(!strcmp(argv[1],"fd")) fd_lab();
    else if(!strcmp(argv[1],"zombie")) zombie();
    else if(!strcmp(argv[1],"pipe")) pipe_lab();
    else if(!strcmp(argv[1],"all")) { cow(); exec_lab(); threads(); fd_lab(); zombie(); pipe_lab(); }
    else return 2;
    return 0;
}
