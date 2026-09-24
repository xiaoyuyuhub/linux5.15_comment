set confirm off

define lab-help
  echo Memory practice commands:\n
  echo   lab-init              - boot-time initialization breakpoints\n
  echo   lab-mmap              - mmap/VMA syscall path breakpoints\n
  echo   lab-fault ADDRESS     - fault path filtered by virtual address\n
  echo   lab-cow ADDRESS       - write-protect/COW path filtered by address\n
  echo   lab-buddy             - high-frequency allocator path; enable late\n
  echo   lab-unmap ADDRESS     - munmap filtered by start address\n
  echo Always replace ADDRESS with the BASE printed by this run.\n
end

define lab-clear
  delete breakpoints
end

define lab-init
  hbreak start_kernel
  hbreak setup_arch
  hbreak paging_init
  hbreak free_area_init
  hbreak build_all_zonelists
  hbreak memblock_free_all
  hbreak mem_init
  echo Boot breakpoints installed. Use info breakpoints and disable/delete each after it fires.\n
end

define lab-mmap
  break __x64_sys_mmap
  break ksys_mmap_pgoff
  break do_mmap
  break mmap_region
  echo mmap breakpoints installed. Enable only one or two at a time.\n
end

define lab-fault
  set $lab_addr = (unsigned long)$arg0
  break handle_mm_fault if address == $lab_addr
  echo Fault breakpoint installed for $lab_addr.\n
end

define lab-cow
  set $lab_addr = (unsigned long)$arg0
  break do_wp_page if vmf->address == $lab_addr
  break wp_page_copy if vmf->address == $lab_addr
  echo COW breakpoints installed for $lab_addr.\n
end

define lab-buddy
  break __alloc_pages
  break get_page_from_freelist
  break rmqueue
  echo WARNING: allocator breakpoints are global and frequent. Install only after stopping at the target fault.\n
end

define lab-unmap
  set $lab_addr = (unsigned long)$arg0
  break __do_munmap if start == $lab_addr
  echo Unmap breakpoint installed for $lab_addr.\n
end

lab-help
