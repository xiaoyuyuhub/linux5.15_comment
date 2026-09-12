CC ?= cc
CFLAGS ?= -O0 -g3 -Wall -Wextra -Wpedantic
LDFLAGS ?=
BIN_DIR := bin
PROGRAMS := $(BIN_DIR)/fork_cow $(BIN_DIR)/fork_exec $(BIN_DIR)/thread_share

.PHONY: all clean

all: $(PROGRAMS)

$(BIN_DIR):
	mkdir -p $@

$(BIN_DIR)/fork_cow: src/fork_cow.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

$(BIN_DIR)/fork_exec: src/fork_exec.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

$(BIN_DIR)/thread_share: src/thread_share.c | $(BIN_DIR)
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS) -pthread

clean:
	$(RM) $(PROGRAMS)
