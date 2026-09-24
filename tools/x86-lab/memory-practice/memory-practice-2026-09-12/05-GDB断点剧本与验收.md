# 05 GDB 断点剧本、排障与验收

## 1. 最稳的调试节奏

一次只证明一个命题：

1. 用户程序先停在 CHECKPOINT。
2. 抄 PID、BASE、长度和下一动作。
3. GDB `Ctrl-C` 暂停 guest。
4. 删除上一阶段断点，只下 1～3 个带地址条件的断点。
5. `continue`，回主终端按 Enter 触发唯一动作。
6. 命中后记录实参、VMA/mm、调用栈和源码行。
7. 删除高频断点并继续到下一个 CHECKPOINT。

这比开机就给 `__alloc_pages`、`handle_mm_fault`、`free_unref_page` 全下无条件断点更可靠。那些函数属于整台系统，不属于你的程序。

## 2. 已提供的 GDB 命令

`gdb-kernel.sh` 会加载 `gdb/mm-commands.gdb`：

```gdb
lab-help
lab-clear
lab-init
lab-mmap
lab-fault 0xADDRESS
lab-cow 0xADDRESS
lab-buddy
lab-unmap 0xADDRESS
```

它们只是教学快捷命令，不会自动替你判断命中是不是目标进程。地址必须使用本轮程序输出，绝不能照抄教程示例。`lab-buddy` 是高频断点组，只应在已经停于目标 fault 后短暂使用。

## 3. 五套最小剧本

### 剧本 A：启动期入 buddy

```gdb
delete breakpoints
hbreak mem_init
hbreak memblock_free_all
continue
bt 6
```

验收证据：`memblock_free_all` 的调用栈确实来自 x86 `mem_init`；能指出执行前后的页状态含义，而非只拍函数名。

### 剧本 B：mmap 只建立地址范围

在 A0：

```gdb
delete breakpoints
break do_mmap
continue
info args
bt 8
```

在 A1 用观察终端看 maps 与 mincore。验收证据：VMA 覆盖 BASE，但尚未触碰的页可显示不驻留。

### 剧本 C：匿名第一次写

在 A2，把地址设为 `BASE + 4096`：

```gdb
delete breakpoints
break handle_mm_fault if address == 0x实际地址
continue
p/x address
p/x vma->vm_start
p/x vma->vm_end
set $target_mm = vma->vm_mm
bt 8
```

随后单步到 `do_anonymous_page`，或先禁用入口断点再断该函数。验收证据：fault 地址落在目标 VMA，调用栈来自 x86 用户页故障，本次是写 fault，并看到分配页与安装 PTE 的先后位置。

### 剧本 D：fork COW

在 C1：

```gdb
delete breakpoints
lab-cow 0x实际BASE
continue
```

验收证据：命中发生在子写动作期间；`vmf->address` 对齐到 BASE；父最后仍读到 `P`，子读到 `C`。

### 剧本 E：解除映射

在 A5：

```gdb
delete breakpoints
lab-unmap 0x实际BASE
continue
p/x start
p len
bt 6
```

验收证据：start/len 与程序输出一致；返回 A6 后 maps 不再覆盖该区间。

## 4. 常用现场命令

```gdb
info breakpoints
disable BREAKPOINT_NUMBER
delete BREAKPOINT_NUMBER
info args
info locals
bt 8
list
disassemble /m FUNCTION
p/x EXPRESSION
x/8gx ADDRESS
```

查看用户页表时，优先使用匹配构建生成的 Linux GDB helper；若 `$lx_current()` 或 `lx-ps` 不存在，说明 helper 没加载完整。此时仍可用函数实参 `vma/vmf/mm/address/start` 完成核心验证，不要把 GDB thread number 当 Linux PID，也不要猜 `current` 的 per-CPU 实现。

## 5. 为什么断点可能不命中

| 现象 | 检查顺序 |
|---|---|
| `--debug` 后无启动输出 | QEMU 正等 GDB；连接后 `continue` |
| GDB 连接拒绝 | run 模式必须是 `--gdb/--debug`；本包端口默认 1236；旧 QEMU 是否占用 |
| mmap 断点没命中 | 动作是否已在下断点前执行；libc 是否复用；符号是否内联/改名 |
| fault 断点没命中 | 页是否已被程序/调试器触碰；地址是否本轮真实值；读/写是否走另一分支 |
| COW 断点没命中 | child 是否已写；地址条件是否页对齐；是否断了错误函数；是否过滤错 PID |
| `__alloc_pages` 命中过多 | 先停目标 fault，再启用；每次核对 bt；迅速 disable/delete |
| 源码行漂移 | vmlinux、bzImage 和当前源码是否同一次构建；看反汇编与 DWARF source path |
| 局部变量 optimized out | 换到参数仍有效的入口或目标赋值后的源码行；不要凭空补值 |
| 两个 guest 终端一起卡住 | GDB 暂停的是整台虚拟机，先看 GDB 提示符 |

## 6. 最终验收清单

- [ ] 能独立构建实验盘，确认五个文件是 x86-64 静态 ELF。
- [ ] 能解释 Mac、Lima、QEMU guest 的职责和 PID/localhost 差异。
- [ ] 能用主终端推进程序、第二终端观察同一个 guest PID、第三终端 GDB 调内核。
- [ ] 能用真实证据区分 VMA 已存在、PTE 已存在、物理页已分配三种状态。
- [ ] 能在启动期指出 `free_area_init` 与 `memblock_free_all` 的职责边界。
- [ ] 能捕获一次匿名写 fault，并说出 VMA 检查、物理页分配、PTE 安装的顺序。
- [ ] 能说明首次匿名读为何可能用共享零页。
- [ ] 能解释 PCP 命中为何看不到 buddy 拆分，以及 PCP 补货为何可能一次拿多页。
- [ ] 能用程序结果和 fault 现场解释 fork COW。
- [ ] 能区分文件 `MAP_SHARED` 写回和 `MAP_PRIVATE` COW。
- [ ] 能说明 `free`、`munmap`、物理页可重用不是同一个瞬时动作。
- [ ] 每条“实测”结论都带本轮 PID、地址、断点、参数或 `/proc` 证据，不把教程调用树冒充运行证据。

完成后，建议自己给 `01_anon_lazy` 加一个“先读第 2 页再写第 2 页”的阶段，预测它会先走零页、后走写保护路径，再用 GDB 验证。这个练习改动小，却能把匿名首次读和首次写真正串起来。
