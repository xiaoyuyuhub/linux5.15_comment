CC := x86_64-linux-gnu-gcc
CFLAGS := -std=gnu11 -O0 -g3 -fno-omit-frame-pointer -fno-pie -Wall -Wextra -Werror
LDFLAGS := -static -no-pie
PROGRAMS := 00_memory_tour 01_anon_lazy 02_populate 03_malloc_brk 04_fork_cow 05_file_map

all: $(PROGRAMS)

%: src/%.c src/lab.h
	$(CC) $(CFLAGS) $< -o $@ $(LDFLAGS)

clean:
	rm -f $(PROGRAMS)

.PHONY: all clean
