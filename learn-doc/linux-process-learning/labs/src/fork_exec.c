#define _GNU_SOURCE
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

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

int main(int argc, char **argv)
{
	char executable[PATH_MAX];
	ssize_t length;
	pid_t child;
	int status;

	setvbuf(stdout, NULL, _IONBF, 0);
	if (argc == 2 && strcmp(argv[1], "--after-exec") == 0) {
		printf("[after exec] pid=%ld ppid=%ld program-image=replaced\n",
		       (long)getpid(), (long)getppid());
		sleep(pause_seconds());
		return 17;
	}

	length = readlink("/proc/self/exe", executable, sizeof(executable) - 1);
	if (length < 0 || (size_t)length >= sizeof(executable) - 1) {
		perror("readlink /proc/self/exe");
		return EXIT_FAILURE;
	}
	executable[length] = '\0';

	printf("[parent] pid=%ld about to fork\n", (long)getpid());
	child = fork();
	if (child < 0) {
		perror("fork");
		return EXIT_FAILURE;
	}
	if (child == 0) {
		printf("[before exec] pid=%ld ppid=%ld executable=%s\n",
		       (long)getpid(), (long)getppid(), executable);
		sleep(pause_seconds());
		execl(executable, executable, "--after-exec", (char *)NULL);
		perror("execl");
		_exit(127);
	}

	if (waitpid(child, &status, 0) < 0) {
		perror("waitpid");
		return EXIT_FAILURE;
	}
	printf("[parent] child=%ld exit=%d\n", (long)child,
	       WIFEXITED(status) ? WEXITSTATUS(status) : -1);
	return EXIT_SUCCESS;
}
