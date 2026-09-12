define process-show-current
  printf "current pid=%d tgid=%d comm=", $lx_current().pid, $lx_current().tgid
  output $lx_current().comm
  printf "\n"
  printf "mm=%p active_mm=%p parent_pid=%d\n", $lx_current().mm, $lx_current().active_mm, $lx_current().real_parent->pid
end
document process-show-current
Print the current task's core identity and address-space pointers.
end

define process-boot-breaks
  break start_kernel
  break rest_init
  break kernel_clone
  break kernel_init
  break kthreadd
end
document process-boot-breaks
Set low-frequency breakpoints for the PID 0/1/2 boot path.
end

define process-fork-breaks
  break kernel_clone
  break copy_process
  break copy_mm
  break dup_mm
  break wake_up_new_task
end
document process-fork-breaks
Set process creation breakpoints. Add PID conditions before continuing.
end

define process-exec-breaks
  break do_execveat_common
  break load_elf_binary
  break begin_new_exec
  break exec_mmap
end
document process-exec-breaks
Set exec breakpoints. Add a $lx_current().pid condition before continuing.
end

define process-exit-breaks
  break do_exit
  break release_task
end
document process-exit-breaks
Set exit/reap breakpoints. These may be frequent; add PID conditions.
end

define process-switch-breaks
  break context_switch
  break __switch_to
end
document process-switch-breaks
Set very hot context-switch breakpoints. Do not continue before adding PID conditions.
end

echo Loaded process lifecycle helpers. Run "help user-defined" to list them.\n
