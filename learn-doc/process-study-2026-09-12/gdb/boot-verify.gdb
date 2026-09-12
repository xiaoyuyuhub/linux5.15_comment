set pagination off
set confirm off
set architecture i386:x86-64
set auto-load off
file out/x86-lab/vmlinux
target remote 127.0.0.1:1235
hbreak rest_init
continue
printf "BOOT init_task pid=%d mm=%p active_mm=%p\n", init_task.pid, init_task.mm, init_task.active_mm
delete breakpoints
hbreak kernel_clone
continue
printf "CLONE_ONE flags=%#lx entry=%p\n", args->flags, args->stack
info symbol args->stack
continue
printf "CLONE_TWO flags=%#lx entry=%p\n", args->flags, args->stack
info symbol args->stack
delete breakpoints
hbreak kernel_init
continue
printf "KERNEL_INIT_HIT\n"
bt 4
delete breakpoints
detach
quit
