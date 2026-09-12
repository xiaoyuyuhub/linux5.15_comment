#define _GNU_SOURCE
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

static volatile int shared_by_cow = 100;

static unsigned int pause_seconds(void)
{
	const char *value = getenv("LAB_PAUSE_SECONDS");
	char *end = NULL;
	unsigned long seconds;

	if (!value || !*value)
		return 2;
	errno = 0;
	seconds = strtoul(value, &end, 10);
	if (errno || *end != '\0' || seconds > 3600)
		return 2;
	return (unsigned int)seconds;
}

int main(void)
{
	int child_ready[2];
	int child_continue[2];
	char token = 'x';
	pid_t child;
	int status;

	setvbuf(stdout, NULL, _IONBF, 0);
	if (pipe(child_ready) || pipe(child_continue)) {
		perror("pipe");
		return EXIT_FAILURE;
	}

	printf("[parent before fork] pid=%ld ppid=%ld address=%p value=%d\n",
	       (long)getpid(), (long)getppid(), (void *)&shared_by_cow,
	       shared_by_cow);

	child = fork();
	if (child < 0) {
		perror("fork");
		return EXIT_FAILURE;
	}

	if (child == 0) {
		close(child_ready[0]);
		close(child_continue[1]);
		printf("[child before write] pid=%ld ppid=%ld address=%p value=%d\n",
		       (long)getpid(), (long)getppid(), (void *)&shared_by_cow,
		       shared_by_cow);
		if (write(child_ready[1], &token, 1) != 1 ||
		    read(child_continue[0], &token, 1) != 1) {
			perror("child synchronization");
			_exit(2);
		}
		shared_by_cow = 200;
		printf("[child after write]  pid=%ld address=%p value=%d\n",
		       (long)getpid(), (void *)&shared_by_cow, shared_by_cow);
		sleep(pause_seconds());
		_exit(42);
	}

	close(child_ready[1]);
	close(child_continue[0]);
	if (read(child_ready[0], &token, 1) != 1) {
		perror("parent synchronization read");
		return EXIT_FAILURE;
	}
	printf("[parent after fork]  pid=%ld child=%ld address=%p value=%d\n",
	       (long)getpid(), (long)child, (void *)&shared_by_cow,
	       shared_by_cow);
	printf("Inspect /proc/%ld and /proc/%ld now; child writes after release.\n",
	       (long)getpid(), (long)child);
	sleep(pause_seconds());
	if (write(child_continue[1], &token, 1) != 1) {
		perror("parent synchronization write");
		return EXIT_FAILURE;
	}
	if (waitpid(child, &status, 0) < 0) {
		perror("waitpid");
		return EXIT_FAILURE;
	}
	printf("[parent after wait]  value=%d child_exit=%d\n", shared_by_cow,
	       WIFEXITED(status) ? WEXITSTATUS(status) : -1);
	return EXIT_SUCCESS;
}
