# Load this file from CLion's GDB console after Remote Debug connects:
#   source /Users/xuyu/Desktop/code/linux5.15_comment/tools/x86-lab/memory-practice/gdb/clion-tour.gdb
#
# vmlinux remains the main symbol file. add-symbol-file adds the fixed-address,
# non-PIE user ELF, so one debugger can resolve both kernel and tour functions.
add-symbol-file /Users/xuyu/Desktop/code/linux5.15_comment/out/x86-lab/memory-practice/00_memory_tour

define tour-help
  echo Unified memory tour commands:\n
  echo   tour-break-mmap     - user mmap wrapper and kernel mmap entry\n
  echo   tour-break-brk      - user brk branch and kernel brk entry\n
  echo   tour-break-malloc   - user malloc branch and kernel brk/mmap entries\n
  echo   tour-break-populate - MAP_POPULATE branch\n
  echo   tour-break-cow      - fork COW branch and kernel COW handlers\n
  echo   tour-break-file     - file mapping branch and file/COW fault handlers\n
  echo Use delete breakpoints before changing to another branch.\n
end

define tour-break-mmap
  hbreak tour_mmap_lazy
  hbreak checked_mmap
  hbreak __x64_sys_mmap
  echo Breakpoints: tour_mmap_lazy -> checked_mmap -> __x64_sys_mmap.\n
end

define tour-break-brk
  hbreak tour_brk_child
  hbreak __x64_sys_brk
  echo Breakpoints: tour_brk_child -> glibc sbrk/brk -> __x64_sys_brk.\n
end

define tour-break-malloc
  hbreak tour_malloc
  hbreak __x64_sys_brk
  hbreak __x64_sys_mmap
  hbreak __x64_sys_munmap
  echo Breakpoints: tour_malloc plus allocator kernel boundaries.\n
end

define tour-break-populate
  hbreak tour_populate
  hbreak __x64_sys_mmap
  hbreak __mm_populate
  echo Breakpoints: tour_populate -> mmap -> inline mm_populate -> __mm_populate.\n
end

define tour-break-cow
  hbreak tour_cow
  hbreak do_wp_page
  hbreak wp_page_copy
  echo Breakpoints: tour_cow and COW handlers; add address/PID conditions at C1.\n
end

define tour-break-file
  hbreak tour_file
  hbreak filemap_fault
  hbreak do_wp_page
  echo Breakpoints: tour_file, file-backed read fault and private-write COW.\n
end

tour-help
