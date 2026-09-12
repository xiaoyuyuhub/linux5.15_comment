#define _GNU_SOURCE
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/syscall.h>
#include <unistd.h>

static int shared_value = 100;

static long gettid_linux(void)
{
	return syscall(SYS_gettid);
}

static void *worker(void *unused)
{
	(void)unused;
	printf("[worker before] pid/tgid=%ld tid=%ld address=%p value=%d\n",
	       (long)getpid(), gettid_linux(), (void *)&shared_value,
	       shared_value);
	shared_value = 300;
	printf("[worker after]  pid/tgid=%ld tid=%ld address=%p value=%d\n",
	       (long)getpid(), gettid_linux(), (void *)&shared_value,
	       shared_value);
	return NULL;
}

int main(void)
{
	pthread_t thread;
	int error;

	setvbuf(stdout, NULL, _IONBF, 0);
	printf("[main before]   pid/tgid=%ld tid=%ld address=%p value=%d\n",
	       (long)getpid(), gettid_linux(), (void *)&shared_value,
	       shared_value);
	error = pthread_create(&thread, NULL, worker, NULL);
	if (error) {
		errno = error;
		perror("pthread_create");
		return EXIT_FAILURE;
	}
	error = pthread_join(thread, NULL);
	if (error) {
		errno = error;
		perror("pthread_join");
		return EXIT_FAILURE;
	}
	printf("[main after]    pid/tgid=%ld tid=%ld address=%p value=%d\n",
	       (long)getpid(), gettid_linux(), (void *)&shared_value,
	       shared_value);
	return EXIT_SUCCESS;
}
