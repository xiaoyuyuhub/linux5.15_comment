# Linux 5.15 内存管理：边运行、边观察、边调源码

这是一套面向当前 Apple Silicon Mac → Lima ARM64 构建机 → QEMU x86_64 guest 的实践课。它不替代已有三篇原理文，而是把原理变成可以重复执行的实验。

## 和已有材料的关系

先把三份已有教程当作“源码地图”：

1. [`MM-ZONE-BUDDY-INIT-STUDY.md`](../MM-ZONE-BUDDY-INIT-STUDY.md)：启动时 RAM 怎样成为 buddy 库存。
2. [`MM-USER-ALLOC-FREE-STUDY.md`](../MM-USER-ALLOC-FREE-STUDY.md)：`malloc → VMA → fault → page → PTE → free` 全链路。
本实践包不修改原 `tools/x86-lab/user-memory`。当前主学习入口是一个统一大程序 [`00_memory_tour.c`](../../tools/x86-lab/memory-practice/src/00_memory_tour.c)：mmap、brk、malloc、MAP_POPULATE、fork COW 和文件映射都在同一源码里。原来的五个小程序保留为对照。

## 推荐学习顺序

```text
第 0 轮：配置三终端和 CLion，只跑 00_memory_tour mmap
   ↓
第 1 轮：用户 checked_mmap → glibc mmap → syscall → 内核 VMA
   ↓
第 2 轮：用户读/写 → #PF → 匿名页/zero page → PTE
   ↓
第 3 轮：统一程序的 brk 与 malloc 分支
   ↓
第 4 轮：populate、fork COW、文件映射分支
   ↓
第 5 轮：按需回看启动初始化附录，理解 buddy 库存从哪里来
```

| 章节 | 实践目标 |
|---|---|
| [01-环境与三终端](01-环境与三终端.md) | 构建、启动、挂盘、主终端推进、观察终端取证、GDB 控制 |
| [统一大程序调试主线](00-统一大程序调试主线.md) | 从一个用户程序连续跨过 libc、syscall、VMA、fault、page、PTE 和释放 |
| [03-匿名映射到物理页](03-匿名映射到物理页.md) | 捕获 mmap、读零页、写缺页、buddy、PTE 和解除映射 |
| [04-申请方式逐项对比](04-申请方式逐项对比.md) | 比较 malloc/brk、populate、COW、文件共享/私有映射 |
| [05-GDB断点剧本与验收](05-GDB断点剧本与验收.md) | 用最少断点完成可复核记录，排查不命中和高频断点 |
| [启动期内存初始化（可选附录）](02-启动期内存初始化.md) | 只在你想回查 buddy 库存怎样建立时阅读，不是用户程序实验前置课 |

## 先记住四个不同的“申请”

```mermaid
flowchart LR
    A[用户分配器选择对象块] --> B[brk/mmap 建立或扩大地址范围]
    B --> C[首次访问触发缺页]
    C --> D[PCP/buddy 提供物理页]
    D --> E[页表写入 PTE]
```

- `malloc` 返回不证明发生系统调用。
- `mmap` 返回通常证明 VMA 合法，不证明每个数据页已分配。
- `mincore=1` 表示驻留，不等于“这个进程独占一个匿名私有页”。首次只读可能是共享零页。
- `free` 返回不证明物理页立即回到 buddy；用户分配器可以缓存，内核释放也可能先经过 TLB/PCP 等阶段。

## 本轮边界

本轮覆盖普通 4 KiB 页、匿名私有映射、普通 glibc 静态程序、文件 page cache、COW 和 x86_64 单 CPU 调试。THP 在当前构建中关闭；NUMA 多节点、swap、reclaim、OOM、hugetlb、DAX、GPU 内存、内核 `kmalloc/vmalloc/slab` 是后续专题，不把它们硬塞进第一轮实践。
