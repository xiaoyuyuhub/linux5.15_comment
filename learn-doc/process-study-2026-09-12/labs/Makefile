CC ?= cc
CFLAGS = -O0 -g3 -Wall -Wextra -Werror -fno-omit-frame-pointer
LDFLAGS ?=
all: process_lab
process_lab: process_lab.c
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS) -pthread
clean:
	rm -f process_lab
.PHONY: all clean
