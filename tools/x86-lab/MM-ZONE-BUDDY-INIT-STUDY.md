---
title: Linux 5.15 x86_64 内存初始化：从 start_kernel 到 zone/buddy 与启动收尾
tags:
  - linux
  - memory-management
  - memblock
  - buddy-allocator
  - x86_64
---

# Linux 5.15 x86_64 内存初始化：从 `start_kernel()` 到 zone/buddy 与启动收尾

> **目标**：按启动顺序讲清“物理内存如何变成 buddy 可分配页”，并接到上层分配器、正式 PCP、水位线和启动内存释放，形成初始化闭环。
> **范围**：当前仓库的 Linux 5.15、x86_64、`CONFIG_SPARSEMEM_VMEMMAP=y` 路径；从 `start_kernel()` 开始，到进入用户态 init 前的核心 MM 收尾。进入 C 入口前已有启动页表；启动汇编、所有配置分支及页故障、回收、SLUB 的运行期算法不在本篇展开。
>
> **阅读方式**：先看总览和第 2 节时序，再按第 3–7 节顺序读。第 1 节详细调用树用于回查；第 8–10 节用于理解结构、对照日志和调试。

---

## 一句话总览

> 下图是**对象状态交接图，不是函数调用图**；箭头只表示“前一阶段产物被后一阶段使用”。具体函数边只看第 1 节的调用树。

```mermaid
flowchart LR
    A[E820 固件内存图] --> B[memblock.memory<br/>memblock.reserved]
    B --> C[direct mapping<br/>内核可访问物理 RAM]
    C --> D[sparse/vmemmap<br/>PFN 和 struct page]
    D --> E[pgdat / zone / free_area<br/>空的 buddy 容器]
    E --> Z[zonelist<br/>填好分配搜索路线]
    Z --> F[memblock_free_all<br/>未保留页入 buddy]
    F --> G[SLUB / vmalloc<br/>上层分配设施]
    G --> H[正式 PCP / 晚期 initcall<br/>策略与启动内存收尾]
```

```text
固件 E820 内存图
  → memblock 记录 RAM 与保留区
  → x86 建立 direct mapping
  → sparse/vmemmap 建立 PFN → struct page 框架
  → zone/buddy 建立空的分配容器
  → build_all_zonelists() 将已有 zone 组织成搜索路线
  → memblock_free_all() 将未保留页投放给 buddy，页分配有了库存
  → kmem_cache_init() / vmalloc_init() 准备上层分配设施
  → setup_per_cpu_pageset() 建正式每 CPU 页缓存
  → PID 1 中进行页分配器晚期收尾、initcall、init 段释放
```

最容易混淆的一点：

> `page_alloc_init()` **不会**把内存放进 buddy；首次批量将未保留 RAM 交给 buddy 的是 `memblock_free_all()`；部分暂时保留的内存还会更晚释放。

---

## 目录

- [0. 先区分四种“内存已经初始化”的状态](#0-先区分四种内存已经初始化的状态)
- [1. 读图规则与精确调用树](#1-读图规则与精确调用树)
- [2. 入口：start_kernel 的真实时间线](#2-入口start_kernel-的真实时间线)
- [3. 阶段 A：setup_arch 建立早期内存模型](#3-阶段-asetup_arch-建立早期内存模型)
- [4. 阶段 B：paging_init 建立 page/zone 框架](#4-阶段-bpaging_init-建立-pagezone-框架)
- [5. 阶段 C：返回 start_kernel，建立分配路线](#5-阶段-c返回-start_kernel建立分配路线)
- [6. 阶段 D：memblock_free_all 把页正式交给 buddy](#6-阶段-dmemblock_free_all-把页正式交给-buddy)
- [7. 阶段 E：上层分配、正式 PCP 与晚期收尾](#stage-e)
- [8. 关键数据结构对应表](#8-关键数据结构对应表)
- [9. 当前 512 MiB QEMU 实验机如何落到这些结构上](#9-当前-512-mib-qemu-实验机如何落到这些结构上)
- [10. 推荐源码阅读和 GDB 断点顺序](#10-推荐源码阅读和-gdb-断点顺序)
- [11. 最终速记](#11-最终速记)

---

<a id="0-先区分四种内存已经初始化的状态"></a>

## 0. 先区分四种“内存已经初始化”的状态

一句“内存初始化完成”在不同阶段含义不同。读源码时先问：**此刻这些页只是被发现、被描述，还是已经可分配？**

| 阶段 | 内核已经拥有的东西 | 这些页可由 buddy 分配吗？ |
|---|---|---:|
| E820 | 固件报告的物理内存地图 | 否 |
| memblock | `memory` RAM 区间和 `reserved` 保留区间 | 否 |
| `free_area_init()` / `memmap_init()` | node、zone、`struct page`、空的 buddy 链表 | 否 |
| `memblock_free_all()` 后 | 未保留页进入 `zone->free_area[]` | 是 |

可以把启动期的角色分工理解成：

```text
E820       = 固件说“机器物理地址空间是什么样”
memblock   = 早期内核说“哪些 RAM 存在，哪些绝对不能碰”
vmemmap    = 内核说“每个 PFN 的 struct page 账本在哪里”
zone       = 内核说“该页的地址能力/NUMA 归属是什么”
buddy      = 内核说“哪些连续块现在可供分配”
```

---

<a id="1-读图规则与精确调用树"></a>

## 1. 读图规则与精确调用树

这份文档有意把两类关系分开，避免单步调试时“图上能连上、代码里却找不到调用点”。

| 标记 | 含义 | 能否在当前函数体中直接下断点/单步进入？ |
|---|---|---:|
| `├─` / `└─` | **直接调用**；子节点就是父函数体内的一次调用 | 能 |
| `⇢` | 前一函数已经返回；**同一个调用者**随后执行下一句 | 不能把它当作前者调用后者 |
| `[条件]` | 编译配置或运行条件决定是否执行 | 取决于条件 |
| `for_each_...` | 循环宏；循环体内的调用对每个匹配对象发生 | 能 |

本次对照仓库根目录 [`.config`](../../.config) 核实：`CONFIG_X86_64=y`、`CONFIG_NUMA=y`、`CONFIG_SPARSEMEM=y`、`CONFIG_SPARSEMEM_VMEMMAP=y`、`CONFIG_ZONE_DMA=y`、`CONFIG_ZONE_DMA32=y`、`CONFIG_SLUB=y`；`CONFIG_DEFERRED_STRUCT_PAGE_INIT` 和 `CONFIG_CMA` 未启用。下文 CMA 只作条件分支说明。因此下面是**这个内核、x86_64 native 路径**的主线，而不是把所有架构/配置的分支拼到一起。

### 1.1 直接调用树：只保留 zone/buddy 主线的核心调用

<details>
<summary>展开详细调用树（第一次阅读可先跳到第 2 节）</summary>

> **树内旁注读法**：每个 `#` 后面都是“这个函数在这一刻做什么”的一句话摘要，**不是额外调用**。因此既可以从上向下获得全局图，也可以只盯着没有省略的函数名逐层 `step` 进入源码。

```text
start_kernel()                                      # 内核 C 入口；按启动顺序编排各子系统
│
├─ setup_arch(&command_line)                        # x86 入口：完成物理内存视图、映射及 page/zone 骨架
│  ├─ early_reserve_memory()                         # 先记录内核等绝不能覆盖的早期区域
│  ├─ e820__memory_setup()                           # 读取、规范化固件 E820 物理内存图
│  ├─ e820__memblock_setup()                         # 将 RAM/soft-reserved 写入 memblock 两张账本
│  ├─ init_mem_mapping()                             # 扩展内核 direct mapping，以访问物理 RAM
│  ├─ initmem_init()                                 # 调 x86_numa_init，建立 node 拓扑并给 RAM 归属 node
│  └─ paging_init() [经 x86_init.paging.pagetable_init 回调]
│      ├─ sparse_init()                          # 建 section/vmemmap，使 PFN 可定位 struct page
│      ├─ node_clear_state(0, N_MEMORY)          # 清除 bootstrap 默认的“node 0 有内存”标记
│      ├─ node_clear_state(0, N_NORMAL_MEMORY)   # 同样清除 bootstrap 默认的 normal-memory 标记
│      └─ zone_sizes_init()                      # 填 max_zone_pfns[]，给 DMA/DMA32/NORMAL 定上界
│          └─ free_area_init(max_zone_pfns)      # 建每 node/zone 骨架并初始化每个 struct page
│              ├─ find_min_pfn_with_active_regions() # 找第一个存在 RAM 的 PFN，作为 zone 切分起点
│              ├─ find_zone_movable_pfns_for_nodes() # 计算每 node 的 ZONE_MOVABLE 起点
│              ├─ for_each_mem_pfn_range: subsection_map_init() # 标记 active subsection
│              ├─ mminit_verify_pageflags_layout() # 校验 struct page flags 的位布局
│              ├─ setup_nr_node_ids()            # 固化系统需要支持的 node ID 数量
│              ├─ for_each_online_node: free_area_init_node(nid) # 对每个 online node 完善已有 pgdat/zone（含 memoryless 情形）
│              │  ├─ get_pfn_range_for_nid()     # 取得该 node 的 PFN 首尾范围
│              │  ├─ calculate_node_totalpages() # 算每个 zone 的范围及 spanned/present 页数
│              │  ├─ alloc_node_mem_map()        # FLATMEM 分配 mem_map；本 SPARSEMEM 配置为空 inline
│              │  ├─ pgdat_set_deferred_range()  # 记录延迟初始化起点；本配置为空 inline
│              │  └─ free_area_init_core()       # 初始化 pgdat 与每个 zone 的内部控制结构
│              │      ├─ pgdat_init_internals()  # 初始化 node 锁、等待队列、LRU 向量等
│              │      └─ for_each_zone:
│              │          ├─ zone_init_internals() # 初始化 zone 身份、锁、PCP、初始 managed_pages
│              │          └─ [zone->spanned_pages != 0]
│              │              ├─ set_pageblock_order() # 确定 pageblock 的页数/阶数
│              │              ├─ setup_usemap()   # 本 SPARSEMEM 配置为空 inline；位图由 sparse 阶段承载
│              │              └─ init_currently_empty_zone() # 设起始 PFN、置 initialized
│              │                  └─ zone_init_free_lists() # 各 order/type 链表置空，nr_free=0
│              ├─ [每个 node 初始化后，若有 present 页] node_set_state(nid, N_MEMORY) # 标记 node 真有 RAM
│              ├─ check_for_memory(pgdat, nid)    # 同在每个 node 的循环内：标 regular memory
│              └─ memmap_init()                   # 给实际 PFN 的每个 struct page 填基础元数据
│                  ├─ for_each memory range/zone: memmap_init_zone_range() # 将范围裁到当前 zone
│                  │  ├─ memmap_init_range()      # 逐 PFN 初始化本段的 page 描述符
│                  │  │   └─ __init_single_page() # 写 page 的 zone/node/PFN、refcount、链表初值
│                  │  └─ [段前存在 hole] init_unavailable_range() # 标记可描述的洞为不可用
│                  └─ [SPARSEMEM 且末尾存在 hole] init_unavailable_range() # 将洞标成不可用
│
├─ [setup_arch 已返回；中间还有命令行、per-CPU 等初始化]
├─ build_all_zonelists(NULL)                         # 为每个 node 预计算分配时的 zone/node 回退路线
│  └─ build_all_zonelists_init()                     # 启动期分支：同时建立 boot pageset
│      └─ __build_all_zonelists(NULL)                # 全量刷新所有 online node 的 zonelist
│          └─ for_each_online_node: build_zonelists(pgdat) # 填 node_zonelists[]._zonerefs[]
├─ page_alloc_init()                                 # 注册每 CPU 页缓存（PCP）的 CPU 上下线回调
│  └─ cpuhp_setup_state_nocalls(...,
│       page_alloc_cpu_online, page_alloc_cpu_dead)  # 只登记；当前不会执行 online 回调
├─ [参数、异常、VFS early 初始化]
└─ mm_init()                                         # 通用 MM 收尾；其中 mem_init 完成 early→buddy 的交接
   ├─ page_ext_init_flatmem()                        # 初始化可选 page extension 的早期存储
   ├─ init_mem_debugging_and_hardening()             # 应用页初始化/硬化等内存调试策略
   ├─ kfence_alloc_pool()                            # 为 KFENCE 分配调试用保护池（未启用时为空操作）
   ├─ report_meminit()                               # 输出内存初始化/硬化相关配置
   ├─ stack_depot_init()                             # 初始化调试功能复用的栈轨迹仓库
   ├─ mem_init()                                     # x86 收尾：最关键的是释放 memblock 的可用页
   │  ├─ pci_iommu_alloc()                           # 先分配 PCI/IOMMU 必须保留的早期资源
   │  ├─ memblock_free_all()                         # 交接点：将未保留页投放到 buddy
   │  │  ├─ free_unused_memmap()                     # 本 VMEMMAP 配置直接返回，不执行回收
   │  │  ├─ reset_all_zones_managed_pages()          # 先清零统计，随后按真正释放页重新累计
   │  │  ├─ free_low_memory_core_early()             # 标好保留页，并遍历所有可释放 memblock 区间
   │  │  │  ├─ memblock_clear_hotplug(0, -1)         # 清除 early memblock 的 hotplug 属性
   │  │  │  ├─ memmap_init_reserved_pages()          # 将 reserved/NOMAP 对应的 page 标为 PageReserved
   │  │  │  └─ for_each_free_mem_range: __free_memory_core() # 每段未保留 RAM 的入口
   │  │  │      └─ __free_pages_memory()             # 将范围切成尽可能大的对齐 order 块
   │  │  │          └─ memblock_free_pages()         # 延迟初始化页跳过；本配置会继续 core free
   │  │  │              └─ __free_pages_core()       # 清 PageReserved/refcount，累加 managed_pages
   │  │  │                  └─ __free_pages_ok()     # 准备页、取 zone 锁，进入正常 buddy free 路径
   │  │  │                      └─ __free_one_page() # 与 buddy 合并后确定最终 order
   │  │  │                          └─ add_to_free_list_tail() [FPI_TO_TAIL] # 实际挂入 free_area 空闲链表
   │  │  └─ totalram_pages_add()                     # 将本次入库页数加入全局 totalram 统计
   │  ├─ register_page_bootmem_info()                # 注册启动期页信息，供后续内存管理查询
   │  └─ preallocate_vmalloc_pages()                 # 预建 vmalloc 区所需的页表页
   ├─ mem_init_print_info()                          # 打印此时的内存统计；后续仍有分配和释放
   ├─ page_ext_init_flatmem_late()                   # buddy 可用后补齐 page extension 的晚期部分
   ├─ kmem_cache_init()                              # 启动 SLUB，令 kmalloc 等对象分配器可用
   ├─ kmemleak_init()                                # 启用 kmemleak 跟踪
   ├─ pgtable_init()                                 # 初始化体系结构相关页表管理设施
   ├─ debug_objects_mem_init()                       # 让 debugobjects 改用正常内存分配
   ├─ vmalloc_init()                                 # 初始化 vmalloc 的虚拟区管理
   ├─ init_espfix_bsp()                              # 设置 x86 ESPFIX 保护映射
   └─ pti_init()                                     # 初始化 x86 KPTI 隔离相关状态
```

</details>

这棵树展开到 `mm_init()`；其后的正式 PCP、PID 1 和 initcall 收尾按第 2 节总时间线继续，详见阶段 E。

#### 把整棵树压缩成三个记忆锚点

| 树中的区段 | 一句话职责 | 此时页的真实状态 | 记忆画面 |
|---|---|---|---|
| `setup_arch()` → `free_area_init()` → `memmap_init()` | **发现并描述内存**：RAM 在哪、每页属于谁、容器怎么摆。 | `struct page`、`pgdat`、`zone->free_area[]` 已存在；页仍未进入 buddy。 | 仓库地址、货架、货号都建好了，但货物没入库。 |
| `build_all_zonelists()` / `page_alloc_init()` | **建立分配路线与 CPU 接口**：将来分配该先找哪个 zone/node、CPU 如何接入 PCP。 | zonelist 与 boot pageset 已可用；buddy 库存仍未由此产生。 | 写好“找货路线图”，并给每个收银台登记好接口。 |
| `memblock_free_all()` → `__free_one_page()` | **把可用页真正入库**：跳过保留区，按 order 切块、合并、挂到 free list。 | `PageReserved` 被清除，`managed_pages` 累加，块存在于 `free_area[order]`。 | 货物按整箱规格上架，buddy 可开始出库。 |

> `__free_one_page()` 的最后一步会根据 `FPI_TO_TAIL` 选择 `add_to_free_list_tail()`；普通运行期释放才可能走 `add_to_free_list()`。启动期 `__free_pages_core()` 传入 `FPI_TO_TAIL | FPI_SKIP_KASAN_POISON`，所以这张树特意写出实际分支。

### 1.2 三个最容易画错的关系

```text
不是调用：memmap_init() → build_all_zonelists()
真实时序：free_area_init() 返回 ⇢ zone_sizes_init() 返回 ⇢ paging_init() 返回
          ⇢ setup_arch() 返回 ⇢ start_kernel() 调用 build_all_zonelists()

不是调用：build_all_zonelists() → page_alloc_init()
真实时序：两者都是 start_kernel() 的直接调用；前者返回后，start_kernel() 再调用后者。

不能跳过：__free_pages_core() → __free_one_page()
真实调用：__free_pages_core() → __free_pages_ok() → __free_one_page()
```

最重要的阶段边界仍是：

```text
free_area_init() / memmap_init()：建立“描述、归属与空容器”
memblock_free_all()             ：把未保留页真正送入 buddy 空闲链表
```

---

<a id="2-入口start_kernel-的真实时间线"></a>

## 2. 入口：`start_kernel()` 的真实时间线

源码入口是 [`init/main.c:start_kernel()`](../../init/main.c#L931)。下面是同一函数体里的**真实先后顺序**，因此使用 `⇢`，不把相邻语句伪装成互相调用。

```c
start_kernel()                                      // 内核总调度入口
  ├─ setup_arch(&command_line)                      // 产出 memblock、映射、page/zone 空骨架
  │    返回：E820/memblock/direct map/struct page/zone 空容器已经建立
  ⇢ setup_boot_config()、setup_command_line()       // 固定启动配置与命令行
  ⇢ setup_nr_cpu_ids()、setup_per_cpu_areas()、smp_prepare_boot_cpu() // 准备 CPU 本地内存
  ⇢ build_all_zonelists(NULL)                       // 生成分配搜索路线
  ⇢ page_alloc_init()                               // 注册 PCP 的 CPU 生命周期回调
  ⇢ jump_label_init()、parse_early_param()、parse_args() // 生效会改变初始化行为的参数
  ⇢ setup_log_buf(0)、vfs_caches_init_early()、trap_init() // 完成 mm_init 前的依赖
  ⇢ mm_init()                                       // 释放可用页给 buddy，并启动上层分配器
  │    返回：buddy、SLUB、vmalloc 的基础分配设施已就绪
  ⇢ [调度、计时等其他启动工作]
  ⇢ setup_per_cpu_pageset()                        // 为 populated zone 建正式每 CPU 页缓存
  ⇢ [其余启动工作，随后创建 PID 1]

PID 1：kernel_init()                               // 后续在线程上下文中执行
  ├─ kernel_init_freeable()
  │    ├─ page_alloc_init_late()                   // 页分配器晚期收尾
  │    └─ do_basic_setup()                         // 经 initcall 设置水位线、启动后台线程等
  ⇢ async_synchronize_full()                       // 等异步初始化完成；中间另有清理
  ⇢ free_initmem()                                 // 归还不再需要的 init 段
  ⇢ mark_readonly()、pti_finalize()                // 收紧/完成内核映射
  ⇢ [随后执行用户态 init]
```

这条时间线解释了为什么单步时会看到大量“内存无关”的函数夹在中间；它们没有改变下面四个关键因果关系：

1. `setup_arch()` 必须先回答“有哪些物理 RAM、哪些被占用”。
2. 之后才有条件建立 zone/node/page 描述符。
3. `build_all_zonelists()` 在已有 zone 后预先计算分配时的搜索路线。
4. `mm_init()` 才将未保留页真正交给 buddy，并继续启动 slab/vmalloc 等上层能力。

---

<a id="3-阶段-asetup_arch-建立早期内存模型"></a>

## 3. 阶段 A：`setup_arch()` 建立早期内存模型

在 x86 中，`setup_arch()` 是很长的体系结构初始化函数。这里也不能用一条 `A → B → C` 表示调用链：这些函数多数都是 `setup_arch()` 的直接调用。下表按源代码行号给出本主题的**完整关键里程碑顺序**；“中间关键操作”列专门列出会影响内存可用集合或地址访问的调用，避免把它们藏进省略号。

| 顺序 | `setup_arch()` 中的直接调用/赋值 | 中间关键操作（同样在 `setup_arch()` 中） | 对 zone/buddy 的意义 |
|---:|---|---|---|
| 1 | `early_reserve_memory()` | — | 在 E820 变成 memblock 前，先记录绝不能覆盖的早期区间。 |
| 2 | `e820__memory_setup()` | `parse_setup_data()`、`e820__reserve_setup_data()`、`e820__finish_early_params()`、`e820_add_kernel_range()` | 形成并修正 E820 视图；内核自身、setup data 等已反映到保留逻辑。 |
| 3 | `max_pfn = e820__end_of_ram_pfn()` | `mtrr_trim_uncached_memory()` 可能重新计算 `max_pfn`；随后确定 `max_low_pfn` | 给后续 zone 上界和可直接映射范围提供 PFN 上限。 |
| 4 | `early_alloc_pgt_buf()` ⇢ `reserve_brk()` | 随后 `cleanup_highmap()`、`memblock_set_current_limit(ISA_END_ADDRESS)` | 先取早期页表缓冲，再将 brk 已使用范围登记保留，避免后续分配覆盖。 |
| 5 | `e820__memblock_setup()` | `sev_setup_arch()`、EFI boot services/mptable 保留 | 补入 RAM 和 soft-reserved；其他早期保留已由各处 `memblock_reserve()` 记录，并非这里统一搬入。 |
| 6 | `reserve_real_mode()`、`init_mem_mapping()` | `memblock_set_current_limit(get_max_mapped())` | 建立/扩展 direct mapping；后续可以用内核虚拟地址访问相应物理内存。 |
| 7 | `reserve_initrd()`、`acpi_boot_table_init()`、`early_acpi_boot_init()` | — | 把 initrd、ACPI 等后发现的占用加入保留集合；ACPI 也提供 NUMA 拓扑输入。 |
| 8 | `initmem_init()` | `dma_contiguous_reserve()`、`reserve_crashkernel()`、`memblock_find_dma_reserve()` | 处理 node/内存块框架及 CMA/crashkernel 等最终保留，决定后面哪些页不能释放。 |
| 9 | `x86_init.paging.pagetable_init()` | 随后才是 `kasan_init()` 等 | native x86_64 回调解析为 `paging_init()`，进入 sparse/zone/`struct page` 初始化。 |

所以真实阅读方式是：**沿着 `setup_arch()` 逐行走到第 9 步**；而不是从 `early_reserve_memory()` 单步“进入” `e820__memory_setup()`。

### A1. `early_reserve_memory()`：先划红线

它先通过 `memblock_reserve()` 保留内核镜像、低端 64 KiB、initrd 及相关启动/固件数据等，见 [`early_reserve_memory()`](../../arch/x86/kernel/setup.c#L690)。早期 `brk` 已用范围由后面的 `reserve_brk()` 单独登记，不能全部归到这个函数。

```text
RAM 中的一部分
├─ kernel text/data/bss      已占用
├─ 初期页表                 已占用
├─ boot 参数/固件数据        已占用
└─ 其余范围                 候选可用内存
```

此时只是登记保留，尚未把页交给 buddy。**memblock 的 `reserved` 可以先有记录，`memory` 随后再由 E820 补入；两张表不必同时建立。**

### A2. `e820__memory_setup()`：获得固件内存图

调用位置在 [`arch/x86/kernel/setup.c`](../../arch/x86/kernel/setup.c#L956)。E820 只是固件 ABI 数据，表达的是：

```text
[physical start, physical end) 是 RAM
[physical start, physical end) 是 reserved / ACPI / device / firmware
```

它不知道 `zone`、`struct page`、buddy，也不负责分配。

### A3. `e820__memblock_setup()`：E820 转为内核早期账本

核心实现见 [`arch/x86/kernel/e820.c`](../../arch/x86/kernel/e820.c#L1295)。它遍历 E820 条目：

```text
RAM / RESERVED_KERN
  → memblock_add(addr, size)
  → 加入 memblock.memory

SOFT_RESERVED
  → memblock_reserve(addr, size)
  → 加入 memblock.reserved
```

因此后续真正可释放给 buddy 的候选集合是：

```text
memblock.memory - memblock.reserved
```

这里还要回答一个启动期的依赖问题：**buddy 尚未可用，页表、`pgdat`、页描述符占用的内存从哪里来？**

- 最早的页表可以使用启动时预留的空间和 `brk` 缓冲。
- memblock 就绪后，早期分配器从 RAM 中找合适区间，并将分配结果登记到 `reserved`，供页表、节点信息和 vmemmap 等使用。
- 这些管理数据自己也占物理 RAM，因此阶段 D 不会再把它们作为空闲页交出去。

**memblock 既是区间账本，也是早期分配器；它不需要先有 buddy 空闲链表。**

### A4. `init_mem_mapping()`：让内核能够访问物理 RAM

调用点在 [`arch/x86/kernel/setup.c`](../../arch/x86/kernel/setup.c#L1346)。它扩展内核 direct mapping；执行到 `start_kernel()` 时已经有早期页表，这里不是第一次开启分页：

```text
软件计算：物理地址 PA → 对应直接映射虚拟地址 __va(PA)
硬件访问：CPU 使用这个虚拟地址 → 经页表翻译 → 访问物理地址 PA
```

它解决的是内核怎样访问 RAM 中的页、页表和元数据。`init_mem_mapping()` 按范围建立映射，可采用大页映射；早期页表页通过缓冲或 memblock 获得。见 [`alloc_low_pages()`](../../arch/x86/mm/init.c#L114) 与 [`init_mem_mapping()`](../../arch/x86/mm/init.c#L749)。

**“映射了这段地址”只说明可以按页表访问，不代表其中每页都是普通可分配 RAM，也不代表它已经空闲。**

### A5. `initmem_init()`：给物理 RAM 赋 NUMA node

在 NUMA 机器上，memblock 的各段物理范围会被标记为 Node 0、Node 1 等。当前 QEMU 实验虽然开启了 `CONFIG_NUMA=y`，实际仍只有 Node 0。

```text
真实 NUMA：PFN range A → node 0；PFN range B → node 1
当前 QEMU：全部 RAM → node 0
```

此外，在 NUMA 初始化过程中，[`alloc_node_data()`](../../arch/x86/mm/numa.c#L196) 会通过 memblock 为 `pg_data_t` 分配存储、清零，并把它登记到 `node_data[nid]`。

所以节点结构有两个不同时间点：**阶段 A 取得并清零 `pgdat` 存储；阶段 B 的 `free_area_init_node()` 拿到这个已有结构，再填节点和 zone 管理内容。**

### A6. `x86_init.paging.pagetable_init()`：进入 `paging_init()`

`setup_arch()` 通过架构回调调用最终页表/页管理初始化入口。[调用点](../../arch/x86/kernel/setup.c#L1493) 在当前 native x86_64 路径会进入 `paging_init()`。`native_pagetable_init` 在 x86_64 被宏定义为 `paging_init`，所以这里是**函数指针解析到该函数**，不是再多调用一层包装函数，见 [`pgtable_types.h`](../../arch/x86/include/asm/pgtable_types.h#L532)。

---

<a id="4-阶段-bpaging_init-建立-pagezone-框架"></a>

## 4. 阶段 B：`paging_init()` 建立 page/zone 框架

阶段 A 返回的早期内存信息已准备好；本阶段继续在 `setup_arch()` 内执行，走 x86_64 的 [`arch/x86/mm/init_64.c:paging_init()`](../../arch/x86/mm/init_64.c#L847)：

```text
paging_init()                         # x86_64 的 page/zone 建模入口
├─ sparse_init()                      # 先建 PFN → struct page 的承载框架
├─ node_clear_state(...)              # 移除 bootstrap 预设的 node 0 状态
└─ zone_sizes_init()                  # 由地址能力算各 zone 的 PFN 上界
   └─ free_area_init(max_zone_pfns)   # 建 zone/pgdat/free_area，并初始化 memmap
```

### B1. `sparse_init()`：先让 PFN 能找到 `struct page`

当前启用 `CONFIG_SPARSEMEM_VMEMMAP=y`：按 memory section 组织内存的存在性和相关元数据，同时提供**虚拟地址连续**的 vmemmap 描述符空间。其后备物理内存不要求整体连续。

它建立的核心能力是：

```text
pfn_to_page(PFN) → struct page *
page_to_pfn(page) → PFN
```

在本配置中，换算实际就是 `vmemmap + PFN` 与 `page - vmemmap`，见 [`memory_model.h`](../../include/asm-generic/memory_model.h#L23)。能写出这个地址计算式，不意味着任意不存在的 PFN 都有可安全访问的描述符。

内部核心顺序是：`sparse_init()` 标记 memblock 中存在的 section，再按 node 调用 `sparse_init_nid()`，为 section 准备 usage 信息和描述符后备存储。pageblock 迁移类型位图也由这里的 section usage 承载，见 [`sparse_init_nid()`](../../mm/sparse.c#L505)。

> **两次初始化的分工**：`sparse_init()` 先解决“描述符放在哪里、怎样找到”；后面的 `memmap_init()` 才给每个描述符填 node/zone、引用计数等内容。两者都不等于物理页已进入 buddy。

### B2. `zone_sizes_init()`：给 zone 定 PFN 边界

见 [`arch/x86/mm/init.c`](../../arch/x86/mm/init.c#L1188)。它构造 `max_zone_pfns[]`，DMA/DMA32 的上界都取地址能力上限与 `max_low_pfn` 的较小值。下图表示通常的地址能力划分，不是承诺每台机器都有完整的这些范围：

```text
ZONE_DMA    : [0, 16 MiB) 的可寻址范围
ZONE_DMA32  : [16 MiB, 4 GiB) 的可寻址范围
ZONE_NORMAL : [4 GiB, max_low_pfn)；512 MiB 实验机上为空
```

各 node 的实际范围还要与这些边界相交，并扣除 hole。`ZONE_MOVABLE` 则按 `kernelcore` / `movablecore` 等条件计算，不是固定从某个硬件地址开始；x86_64 本篇不走 32 位 HIGHMEM 路径。

然后调用：

```text
free_area_init(max_zone_pfns)
```

### B3. `free_area_init()`：zone/buddy 的总初始化入口

入口在 [`mm/page_alloc.c`](../../mm/page_alloc.c#L10509)。下图将“函数调用”与“函数内部工作”分开写：带 `()` 的节点是直接调用；“计算”是该函数自身的顺序工作。

```text
free_area_init()                                  # 统筹全局 zone 边界、node 骨架与 memmap 初始化
├─ [函数内部] 计算各 zone 的 possible PFN 边界、movable PFN # 先回答“每类地址能力覆盖哪里”
├─ [直接调用] 对每个 online node：free_area_init_node(nid) # 再建立各 node 的 pgdat/zone 容器
└─ [直接调用] memmap_init()                        # 最后初始化每个 PFN 对应的 struct page
```

#### B3-a. `free_area_init_node(nid)`

调用链：

```text
free_area_init_node(nid)                         # 初始化一个 NUMA node 的页分配器根对象
├─ get_pfn_range_for_nid()                        # 从早期内存图取该 node 的 PFN 首尾
├─ calculate_node_totalpages()                    # 逐 zone 设置范围并统计 spanned/present 页
├─ alloc_node_mem_map()                           # FLATMEM 分配 mem_map；本机 SPARSEMEM 不走它
├─ pgdat_set_deferred_range()                     # 记录延迟页初始化起点；本配置为空 inline
└─ free_area_init_core()                          # 初始化 pgdat、zone 锁、PCP 与空 free_area
```

这里要区分“范围统计”与“管理页数”。`calculate_node_totalpages()` 设置前三项；`managed_pages` 的初始估算值由后面的 `free_area_init_core()` → `zone_init_internals()` 写入：

| 字段 | 含义 |
|---|---|
| `zone_start_pfn` | 该 zone 的起始 PFN |
| `spanned_pages` | PFN 地址范围覆盖的页数，包含 hole |
| `present_pages` | 真实存在的 RAM 页数，去掉 hole |
| `managed_pages` | 最终交给 buddy 管理的页数；释放页时才校准 |

#### B3-b. `free_area_init_core()`：先建空仓库

它初始化每个 zone 的锁、统计字段，并让 PCP 指针先指向 boot pageset；对于有跨度的 zone，还初始化 buddy 空链表。这里只摘出需要看的成员：

```c
struct zone {
    struct free_area free_area[MAX_ORDER];
    spinlock_t lock;
};
```

`free_area` 的定义在 [`include/linux/mmzone.h`](../../include/linux/mmzone.h#L97)：

```c
struct free_area {
    struct list_head free_list[MIGRATE_TYPES];
    unsigned long nr_free;
};
```

此时可把它理解成已经创建的空货架：

```text
ZONE_DMA32
├─ free_area[0]  空
├─ free_area[1]  空
├─ ...
└─ free_area[10] 空
```

两个实现边界要记住：

- [`init_currently_empty_zone()`](../../mm/page_alloc.c#L9554) 设置起始 PFN、调用 `zone_init_free_lists()` 并标记 initialized。**它不设置运行期水位线**；水位线见阶段 E。
- [`setup_usemap()`](../../mm/page_alloc.c#L9863) 在本 SPARSEMEM 配置下为空 inline。位图存储已由 sparse 阶段准备，后续 `memmap_init_range()` 设置 pageblock 的初始迁移类型。

`free_area[order].nr_free` 数的是**这个 order 的空闲块数**，不是页数；一个块对应 `2^order` 页。链表初始化时各项都为零。

#### B3-c. `memmap_init()`：初始化每一个 `struct page`

`memmap_init()` 逐个 PFN 初始化对应描述符，最终走到 `__init_single_page()`。它建立页的 node/zone 归属、flags、初始引用计数、pageblock migratetype 等。

对普通早期页，`__init_single_page()` 会把引用计数设为 1，保持“尚未空闲”的状态。`memmap_init_zone_range()` 还会处理段前的 hole，`memmap_init()` 最后处理末尾对齐留下的 hole；只对具有可用描述符的相应范围标记不可用。

**初始化的是 `struct page` 管理记录，不是给它所描述的整页 RAM 逐字节清零。** 此时内核、页表、vmemmap 等占用仍须保留，其余可用页也尚未正式送入 buddy。到阶段 D，保留范围会进一步通过 `memmap_init_reserved_pages()` 标记为 `PageReserved`；不能认为“引用计数为 1”就等于“所有页都已置 PageReserved”。

---

<a id="5-阶段-c返回-start_kernel建立分配路线"></a>

## 5. 阶段 C：返回 `start_kernel()`，建立分配路线

`setup_arch()` 返回后，[`start_kernel()`](../../init/main.c#L966) 经过 per-CPU 等初始化，再依次执行下面两句。它们是**同级直接调用**，不是前者调用后者：

```text
start_kernel()
  ├─ build_all_zonelists(NULL)  返回
  ⇢ page_alloc_init()
```

### C1. `build_all_zonelists(NULL)`：决定“去哪找页”

阶段 B 已经把 node、zone 和页描述符准备好。这里接着解决一个新问题：**将来申请页时，从哪个 node 的哪个 zone 开始找，不够时再到哪里找？**

先把这一步和前后两步连起来：

```text
阶段 B：free_area_init()
        建好各个 zone 的管理信息，以及空的 buddy 链表
                 ⇢
阶段 C：build_all_zonelists(NULL)
        引用这些已有 zone，填出分配时的候选搜索顺序
                 ⇢
阶段 D：memblock_free_all()
        把未保留的可用页放进各 zone 的 buddy 空闲链表
```

这里的 `⇢` 表示阶段先后，不是直接调用。**先有 zone 实体，再建立搜索它们的路线，最后首次批量交入可用页。**

#### C1-a. 输入是什么：已经存在的 `node_zones[]`

一个 NUMA node 由一个 `pg_data_t` 描述，`pgdat` 通常是指向这个结构的指针。最需要区分的是它的两个成员，见 [`include/linux/mmzone.h`](../../include/linux/mmzone.h#L800)：

```c
/* 只摘出两个成员，省略其他字段 */
struct zone node_zones[MAX_NR_ZONES];
struct zonelist node_zonelists[MAX_ZONELISTS];
```

| 成员 | 装的是什么 | 进入阶段 C 时的状态 |
|---|---|---|
| `node_zones[]` | **本 node 的 zone 实体**，包含各自的范围、统计、锁和 buddy 空闲链表等 | 阶段 B 已建立基础管理信息；非零跨度 zone 的 buddy 链表已初始化为空。 |
| `node_zonelists[]` | **分配搜索表**，条目引用本地或其他 node 的 zone | 数组空间随 `pgdat` 一起存在，但分配搜索序列还没有构建。 |

因此，“前面 zonelist 还没初始化”应准确理解为：**它的存储空间已存在，但有意义的 zone 引用及其先后顺序尚未填好。** 不能推成“zone 内的所有链表都还没初始化”。

#### C1-b. 输出是什么：有序的 zone 引用数组

虽然叫 `zonelist`，这里的实现是数组，并不是带 `next/prev` 的双向链表。定义见 [`include/linux/mmzone.h`](../../include/linux/mmzone.h#L754)：

```c
struct zoneref {
    struct zone *zone;  /* 指向一个已经存在的 zone */
    int zone_idx;      /* 保存该 zone 的类型索引 */
};

struct zonelist {
    struct zoneref _zonerefs[MAX_ZONES_PER_ZONELIST + 1];
};
```

构建时做的是按顺序填写 `_zonerefs[]`，最后写一个 `zone == NULL` 的终止项。**没有复制或重建 zone，也没有把物理页放进这个数组。**

#### C1-c. 按调用顺序看：从“所有节点”走到“填一个引用”

下面沿当前 `CONFIG_NUMA=y` 的启动路径展开。树枝表示直接调用；循环和条件写在旁注中。

```text
build_all_zonelists(NULL)
└─ build_all_zonelists_init()                 # SYSTEM_BOOTING 分支
   ├─ __build_all_zonelists(NULL)
   │  └─ build_zonelists(pgdat)               # 对每个 online node 调用
   │     ├─ find_next_best_node(...)         # 循环选择候选 node，填 node_order[]
   │     ├─ build_zonelists_in_node_order(...) # 按 node_order[] 填默认回退表
   │     │  └─ build_zonerefs_node(...)      # 对每个候选 node，追加其合适的 zone
   │     │     └─ zoneref_set_zone(...)      # 真正写入 zone 指针和 zone_idx
   │     └─ build_thisnode_zonelists(pgdat)   # 再填只包含本地 node 的表
   │        └─ build_zonerefs_node(...)
   │           └─ zoneref_set_zone(...)
   ├─ per_cpu_pages_init(...)                # 对每个 possible CPU 初始化 boot pageset
   ├─ mminit_verify_zonelist()               # 检验搜索表
   └─ cpuset_init_current_mems_allowed()     # 初始化当前任务允许使用的 node 集
```

按下面三个动作读，最容易抓住内部顺序：

1. **先排 node。** [`build_zonelists()`](../../mm/page_alloc.c#L8016) 通过 `find_next_best_node()` 逐个选候选节点，记录到 `node_order[]`。有本地内存时优先本地，再结合 NUMA 距离及负载权重等选择回退节点。
2. **再排每个 node 的 zone。** [`build_zonelists_in_node_order()`](../../mm/page_alloc.c#L7893) 按刚得到的 node 顺序调用 `build_zonerefs_node()`。后者按 zone 索引从高到低遍历 `node_zones[]`，只加入满足 `managed_zone(zone)` 的 zone，并逐项写入引用。全部追加完毕后，调用者写入 `NULL` 终止项。
3. **另外填只允许本地的表。** [`build_thisnode_zonelists()`](../../mm/page_alloc.c#L7982) 只追加当前 node 的 zone，同样在末尾写入终止项。

因此，当前 NUMA 路径下会得到 `ZONELIST_FALLBACK`（允许跨节点回退）和 `ZONELIST_NOFALLBACK`（只包含本地节点）两类表。每个 node 都有自己的表；默认表中的引用可以指向其他 node 的 `node_zones[]`。

#### C1-d. 对照原文的单节点实验，数组最后是什么样

按第 9 节记录的 512 MiB 实验布局，Node 0 的 DMA、DMA32 有内存，Normal 为空；若没有额外划出其他可管理 zone，默认表的内容可表示为：

```text
Node 0 的 pgdat
│
├─ node_zones[]                         前面已准备好的实体
│    ├─ [ZONE_DMA]    DMA zone
│    ├─ [ZONE_DMA32]  DMA32 zone
│    └─ [ZONE_NORMAL] 空 zone
│
└─ node_zonelists[ZONELIST_FALLBACK]._zonerefs[]
     ├─ [0] { zone = &node_zones[ZONE_DMA32], zone_idx = ZONE_DMA32 }
     ├─ [1] { zone = &node_zones[ZONE_DMA],   zone_idx = ZONE_DMA   }
     └─ [2] { zone = NULL,                  zone_idx = 0          }
```

Normal 的结构槽位仍存在，但它不满足加入条件，所以不会占用一个有效搜索条目。单内存节点的这个例子里，两类表可以包含相同的 zone 序列；它们的用途仍不同。

**表中的顺序是候选顺序。** 真正分配时，还要结合 GFP 所允许的 zone 类型、节点限制等筛选。例如只允许 DMA 的请求，会跳过 DMA32 条目；并非每个请求都能使用整张表。

#### C1-e. 此时还没释放页，为什么能判断 `managed_zone()`？

因为阶段 B 的 `free_area_init_core()` 已通过 `zone_init_internals()` 给 `managed_pages` 写入过一个初始估算值，构建搜索表时可以据此选择候选 zone。

这个值**不等于当前 buddy 空闲页数**。到阶段 D，`memblock_free_all()` 还会先清零管理页统计，再按真正交出的页重新累计。因此，`managed_pages > 0` 和“buddy 空闲链表已经有页”不能画等号。

#### C1-f. 从这个函数返回时，哪些东西变了？

| 观察对象 | 调用前 | 调用后 |
|---|---|---|
| `node_zones[]` | zone 实体已建立 | 被搜索表引用；没有重新创建 zone。 |
| `node_zonelists[]._zonerefs[]` | 搜索序列未构建 | zone 指针、索引、先后顺序和终止项已填好。 |
| buddy 的 `free_area[].free_list[]` | 已初始化为空链表，尚未首次批量入库 | 本次构建没有向其中释放物理页。 |
| boot pageset | 前面 `zone_pcp_init()` 已让 zone 指向早期 pageset | 本次启动 helper 调用 `per_cpu_pages_init()` 初始化这些早期 pageset。 |

正式的每 zone、每 CPU 页缓存，要等后续 `setup_per_cpu_pageset()` 建立；不要把它和这里的 boot pageset 混为一件事。

另外，`build_all_zonelists()` 从启动 helper 返回后，还调用 `nr_free_zone_pages()` 计算 `vm_total_pages`，据此设置 `page_group_by_mobility_disabled`。这个规模估计使用所遍历 zone 的 `managed_pages` 与高水位，**不是数刚刚放入 buddy 的空闲页**；本次并没有这样的入库动作。

到这里，阶段 C 的核心结果就是：**把阶段 B 已有的 zone，组织成后续分配能扫描的路线。下一阶段才开始首次批量交接可用页。**

### C2. `page_alloc_init()`：注册 CPU/PCP 初始化回调

在当前 `CONFIG_NUMA=y` 的代码中，它先在单内存节点时置 `hashdist = 0`，然后执行 `cpuhp_setup_state_nocalls(CPUHP_PAGE_ALLOC, ..., page_alloc_cpu_online, page_alloc_cpu_dead)` 注册 CPU online/offline 时 page allocator 的回调。`_nocalls` 是关键——**本次注册不会立刻调用** `page_alloc_cpu_online()`；后者以后才对每个 populated zone 执行 `zone_pcp_update(zone, 1)`。

这里再次强调三者不同：

```text
free_area_init()       建 buddy 的容器
build_all_zonelists()  建“找哪个 zone/node”的路线
page_alloc_init()      接入 CPU/PCP 生命周期
```

三者完成时，页面仍没有被大规模投放到 buddy。

> 对照源码时注意：`start_kernel()` 调用 `page_alloc_init()` 旁的中文“buddy allocator 起床”只是笼统注释；此处应以函数体的回调注册行为为准，不能据此判断页已入库。

---

<a id="6-阶段-dmemblock_free_all-把页正式交给-buddy"></a>

## 6. 阶段 D：`memblock_free_all()` 把页正式交给 buddy

在 `start_kernel()` 的 `mm_init()` 中，通用初始化调用 x86 的 `mem_init()`。通用调用位置在 [`init/main.c`](../../init/main.c#L836)。

x86_64 的 [`mem_init()`](../../arch/x86/mm/init_64.c#L1479) 中最关键的一句是：

```c
memblock_free_all();
```

这就是早期分配器向运行期 buddy 的交接点。

### D1. 完整释放调用链

```text
memblock_free_all()                              # 未保留 RAM 首次批量交给 buddy 的关键交接点
├─ free_unused_memmap()                          # 本 VMEMMAP 配置直接返回，不执行回收
├─ reset_all_zones_managed_pages()               # 先将近似统计清零，准备按实际入库重新累计
├─ free_low_memory_core_early()                  # 先标保留页，再逐段释放未保留 RAM
│  ├─ memblock_clear_hotplug(0, -1)              # 早期发现的内存不再带 hotplug 标记
│  ├─ memmap_init_reserved_pages()               # 把 reserved/NOMAP 区的 page 固定成 PageReserved
│  │  └─ for_each_reserved_mem_range: reserve_bootmem_region() # 逐页置保留状态
│  └─ for_each_free_mem_range(...)               # 仅遍历 memory - reserved
│     └─ __free_memory_core(start, end)          # 对齐边界、限制在可直接管理的 PFN 范围
│        └─ __free_pages_memory(start_pfn, end_pfn) # 切成最大的对齐 2^order 块
│           └─ memblock_free_pages(page, pfn, order) # 延迟初始化页跳过；本配置继续释放
│              └─ __free_pages_core(page, order) # 清 reserved/refcount，增加 managed_pages
│                 └─ __free_pages_ok(...)        # 准备页并持 zone 锁进入 buddy
│                    └─ __free_one_page(...)     # 尝试与同阶 buddy 合并
│                       └─ add_to_free_list_tail(...) # 启动期实际挂到 free_area[order] 尾部
└─ totalram_pages_add(pages)                      # 把刚成功入库的页数计入系统总 RAM
```

入口实现见 [`mm/memblock.c`](../../mm/memblock.c#L2207)。

### D2. `for_each_free_mem_range()`：只遍历未保留页

这里遍历的是：

```text
memblock.memory - memblock.reserved
```

上面的差集是核心理解；代码还按 memblock 标志过滤（例如排除 NOMAP），并用 `PFN_UP(start)`、`PFN_DOWN(end)` 保留完整页，限制到 `max_low_pfn`。

因此，下列**当时仍处于保留状态**的区域不会在这次调用中放入 buddy：

- 内核镜像和 init 段；
- 页表和 vmemmap 元数据；
- 固件/ACPI/EFI 保留区；
- initrd（若存在）；
- CMA（若启用并预留）或其他保留区域；本配置未启用 CMA。

**“这次不释放”不等于“永远不释放”。** init 段、initrd 等可在使用结束后归还；启用 CMA 时还会有专门的激活路径，见阶段 E。

### D3. `__free_pages_memory()`：尽量按大块释放

代码见 [`mm/memblock.c`](../../mm/memblock.c#L2108)。它把连续 PFN 区间切成尽可能大的、地址对齐的 2 的幂块。

本内核：

```text
MAX_ORDER = 11
最大可管理块 = order 10 = 2^10 页 = 4 MiB（4 KiB 页时）
```

所以一段对齐且完整可释放的 4 MiB RAM 可以作为一个 `order-10` 块交给 buddy。较小或不对齐的边缘先用较小 order 处理。

例如用 PFN 区间 `[8, 20)` 示意（共 12 页）：先释放 `[8, 16)` 的 order-3 块，再释放 `[16, 20)` 的 order-2 块。这里的“连续”指物理页号连续，order 表示块中有多少页，不是 zone 的编号。

### D4. `__free_pages_core()`：页正式转为可管理状态

实现位于 [`mm/page_alloc.c`](../../mm/page_alloc.c#L1773)：

> 下图是 `__free_pages_core()` 函数体内的**顺序状态变更**，不是这四项之间的函数调用图；实际调用树见 D1。

```text
清除 PageReserved
→ 引用计数置为 0
→ 增加 zone->managed_pages
→ 进入正常 free 路径
```

注意初始阶段 `free_area_init_core()` 先用 `freesize` 给 `managed_pages` 一个近似值；`memblock_free_all()` 开头会把它全部清零。这里每释放一块才 `atomic_long_add()` 回实际交出的页数。`managed_pages` 是分配器管理的总页数，后续其中一部分可以已被分配，**不能把它当作当前空闲页数**。

本路径使用 `__free_pages_ok()` **绕过 PCP**，将这些页直接放到 buddy；不是先放到每 CPU 页缓存。

### D5. `__free_one_page()`：伙伴合并并挂入空闲链表

核心算法在 [`mm/page_alloc.c`](../../mm/page_alloc.c#L1058)：

```text
buddy_pfn = pfn XOR (1 << order)

若伙伴 PFN 有效，属于同一 zone，且是满足合并条件的同阶空闲块：
  合并为 order + 1
  继续向上尝试合并

若不能合并：
  启动期按 FPI_TO_TAIL 加入 zone->free_area[order].free_list[migratetype] 的尾部
```

最终空闲块用**块首页**挂链，首页保存 buddy 状态和 order；并非把块内每页都分别挂入同一链表。后续需要小块时，分配器才拆分这些大块。

到此刻才成立：

```text
buddy allocator 有实际库存
__alloc_pages() 可以取页
SLUB 接下来可以依赖这些页完成自身初始化
kmalloc 常用缓存还要等 kmem_cache_init() 建立
```

---

<a id="stage-e"></a>

## 7. 阶段 E：上层分配、正式 PCP 与晚期收尾

**阶段 D 结束，页分配已有库存；但“buddy 可用”早于“核心内存初始化收尾完成”。** 后半程仍按实际顺序走，不能从 `memblock_free_all()` 直接跳到 `page_alloc_init_late()`。

### E1. 仍在 `mm_init()`：先准备上层分配设施

`mem_init()` 返回到 [`mm_init()`](../../init/main.c#L836) 后，核心顺序为：

```text
mem_init() 返回
   ⇢ mem_init_print_info()        此时的内存统计快照
   ⇢ kmem_cache_init()            建 SLUB 自身缓存与常用 kmalloc 缓存
   ⇢ pgtable_init()               体系结构相关页表管理设施
   ⇢ vmalloc_init()               初始化内核虚拟区间管理
   ⇢ init_espfix_bsp()、pti_init() x86 映射相关设置
```

这里省略可选调试初始化，箭头表示同一调用者内的先后。`pgtable_init()` 的具体工作取决于架构，不能把它看成“此时才有页表”；direct map 在阶段 A 已扩展。

[`kmem_cache_init()`](../../mm/slub.c#L4794) 先利用启动用的缓存描述结构建立管理缓存，再创建常用大小的 kmalloc 缓存。它解决的是“如何在页上提供小对象分配”，不是重新建立一套物理内存池。

[`vmalloc_init()`](../../mm/vmalloc.c#L2327) 使用 slab 创建 `vmap_area` 管理对象缓存，接纳此前登记的虚拟区域，并建立空闲虚拟地址空间管理。因此这里有一个实在的依赖：**先让页分配和对象分配可用，再建立这套虚拟区域管理设施。**

### E2. 返回 `start_kernel()`：从 boot pageset 接到正式 PCP

[`setup_per_cpu_pageset()` 的调用](../../init/main.c#L1100) 位于 `mm_init()` 之后。PCP 是每 CPU 的页缓存，用来减少频繁访问 zone 共享 buddy 链表时的锁竞争；这里先理解初始化，不展开运行期取页算法。

把之前分散的 PCP 操作按顺序放到一起：

| 顺序 | 函数 | 此时做什么 |
|---|---|---|
| 阶段 B | `zone_pcp_init()` | 将 zone 的 PCP 指针接到静态 boot pageset，设置早期阈值。 |
| 阶段 C | `build_all_zonelists_init()` | 对每个 possible CPU 初始化 boot pageset。 |
| 阶段 C | `page_alloc_init()` | 注册 CPU 上下线回调；`_nocalls` 表示本次不执行回调。 |
| 阶段 E | `setup_per_cpu_pageset()` | 为每个 populated zone 分配并初始化正式 per-CPU pageset 和统计存储。 |

[`setup_per_cpu_pageset()`](../../mm/page_alloc.c#L9509) 对各 populated zone 调用 `setup_zone_pageset()`，后者通过 `alloc_percpu()` 分配存储、逐 CPU 初始化并设置 high/batch 参数。没有内存的 zone 继续使用 boot pageset。

**为什么分成早期和正式两套？** 正式 PCP 要依赖 per-CPU 分配能力，而这套分配能力本身又需要页分配器。静态 boot pageset 让启动期先能推进，等依赖就绪后再建立正式结构。另一个名字相近的 `setup_per_cpu_areas()` 更早用于建立通用 per-CPU 区域，它不等于这里的正式页缓存初始化。

### E3. 进入 PID 1：`page_alloc_init_late()` 做页分配器收尾

`start_kernel()` 最后经 `arch_call_rest_init()` → `rest_init()` 创建 `kernel_init` 线程，成为 PID 1。下面是另一个执行上下文的调用树；省略无关初始化：

```text
kernel_init()
├─ wait_for_completion(&kthreadd_done)
├─ kernel_init_freeable()
│  ├─ smp_prepare_cpus()
│  ├─ workqueue_init()
│  ├─ init_mm_internals()
│  ├─ smp_init()
│  ├─ sched_init_smp()
│  ├─ padata_init()
│  ├─ page_alloc_init_late()
│  │  ├─ [若开启延迟初始化：启动线程完成剩余 struct page 初始化并等待]
│  │  ├─ buffer_init()
│  │  ├─ memblock_discard()
│  │  ├─ shuffle_free_memory(...)  # 对各 N_MEMORY node，受功能开关影响
│  │  └─ set_zone_contiguous(...)  # 对各 populated zone，检查后才标记
│  └─ do_basic_setup()             # E4：经 initcall 继续初始化
├─ async_synchronize_full()        # 等异步初始化结束；随后还有清理
├─ free_initmem()                  # E5：释放初始化段
├─ mark_readonly()
└─ pti_finalize()
```

本配置没有 `CONFIG_DEFERRED_STRUCT_PAGE_INIT`，不会在 [`page_alloc_init_late()`](../../mm/page_alloc.c#L2319) 补做一批延迟页描述符初始化。换成开启该选项的大内存配置，早期可以只初始化一部分，晚期才完成剩余部分；本篇“阶段 B 描述符初始化完成”的结论不能直接照搬过去。

[`memblock_discard()`](../../mm/memblock.c#L361) 回收动态扩展过的 memblock 区间数组所占内存；静态启动数组不在这里走相同的动态回收分支。它处理的是**账本自身的存储**，不是再次释放账本曾经描述的整片 RAM。若配置要求保留 memblock，则走不同实现。

### E4. 后续 initcall：设置水位线和保留策略，启动后台机制

[`do_basic_setup()`](../../init/main.c#L1406) 调用 `do_initcalls()`，按注册级别执行初始化函数。**这里是回调分发，不是 `do_basic_setup()` 直接写了一句调用每个 MM 函数。**

本篇最应跟住的是 [`init_per_zone_wmark_min()`](../../mm/page_alloc.c#L11187)，它以 `postcore_initcall` 注册：

```text
init_per_zone_wmark_min()
├─ [函数内部] 根据内存规模和用户设置确定 min_free_kbytes
├─ setup_per_zone_wmarks()          设置 zone 的 min/low/high 等水位
├─ refresh_zone_stat_thresholds()   更新相关统计阈值
└─ setup_per_zone_lowmem_reserve()  设置跨 zone 分配时的低端内存保留量
```

树中省略 NUMA 和大页相关调整。**水位线决定分配与回收需要保留的余量；lowmem_reserve 防止普通分配过度消耗地址能力受限的低端 zone。** 它们是分配策略，不是再从 RAM 中切出一批 `memblock.reserved` 区域。

因此，“buddy 已有页”不要求晚期所有策略参数都已最终设好。系统可以先以启动期状态运行，再在此阶段根据已有内存规模设置正常策略。

其他 MM 功能也通过 initcall 就绪，例如 [`kswapd_init()`](../../mm/vmscan.c#L4464) 启动后台回收线程。这里区分**启动回收机制**和**运行期如何回收**，后者不在本文展开。

条件补充：若启用并预留 CMA，其 `core_initcall(cma_init_reserved_areas)` 会早于上述 postcore 级别执行，通过 `cma_activate_area()`、`init_cma_reserved_pageblock()` 将保留区按 CMA 迁移类型交入管理。本仓库 `.config` 未启用 CMA，不把这条条件支线画进本机主流程。

### E5. 初始化代码用完：归还临时内存并完成映射保护

`kernel_init_freeable()` 返回且异步初始化结束后，[`kernel_init()`](../../init/main.c#L1497) 调用 x86 的 [`free_initmem()`](../../arch/x86/mm/init.c#L1115)，释放不再需要的 init 代码/数据所占物理页。`__init` / `__initdata` 所在区域此前必须保留，不能在还会执行这些函数时提前归还。

initrd 在使用完后也有自己的释放路径，具体取决于启动方式和保留选项；**不应把 initrd 释放强行排到 `free_initmem()` 后面**。页表、vmemmap、仍在运行的内核代码等继续使用的内存不因启动结束而统一释放。

随后 `mark_readonly()` 收紧内核映射权限，并可释放内核镜像中的部分对齐间隙，`pti_finalize()` 完成相关隔离映射。这里是已有映射的保护与收尾，不是新建所有页表。之后启动流程才继续执行用户态 init。

到这个边界，可以这样检查初始化是否讲通：**有内存范围与保留记录 → 有访问映射和页管理框架 → 有搜索路线 → 有 buddy 库存 → 有上层分配和正式 PCP → 有运行策略与后台机制 → 不再需要的启动内存已按各自生命周期归还。**

---

<a id="8-关键数据结构对应表"></a>

## 8. 关键数据结构对应表

| 对象 | 管什么 | 出现阶段 |
|---|---|---|
| E820 entry | 固件定义的物理地址类型 | `e820__memory_setup()` |
| `memblock.memory` | 存在的 RAM 区间 | `e820__memblock_setup()` |
| `memblock.reserved` | 早期不可分配区间 | early reserve 到 `memblock_free_all()` |
| `struct page` | 单个 PFN 的管理账本 | `sparse_init()` / `memmap_init()` |
| `pg_data_t` | 一个 NUMA node 的内存管理根 | NUMA 阶段 `alloc_node_data()` 分配清零；`free_area_init_node()` 填基础管理内容。 |
| `struct zone` | 同类物理内存池 | `free_area_init_core()` |
| `zone->free_area[order]` | 指定 order 的 buddy 空闲块库存 | `zone_init_free_lists()` 先置空；阶段 D 的释放路径再挂入实际块。 |
| zonelist | `alloc_pages()` 的 node/zone 搜索路线 | `build_all_zonelists()` 填已有数组中的引用与顺序。 |
| 正式 PCP | 每 CPU 页缓存 | `setup_per_cpu_pageset()`。 |
| zone 水位线 / lowmem_reserve | 分配与回收余量、低端 zone 保护策略 | 晚期 `init_per_zone_wmark_min()`。 |

---

<a id="9-当前-512-mib-qemu-实验机如何落到这些结构上"></a>

## 9. 当前 512 MiB QEMU 实验机如何落到这些结构上

本次核对了仓库已有的 [`qemu-boot.log`](../../out/x86-lab/qemu-boot.log#L49) 和 [`qemu-grub-boot.log`](../../out/x86-lab/qemu-grub-boot.log#L61)。以下是这些**已保存日志中的实验结果**，不是本次重新启动或 GDB 实测：

```text
Node 0
├─ DMA      [0x00001000, 0x00ffffff]
├─ DMA32    [0x01000000, 0x1ffdffff]
└─ Normal   empty
```

因此最终逻辑结构接近：

```text
pgdat: Node 0
├─ ZONE_DMA
│  └─ free_area[0..10]
├─ ZONE_DMA32
│  └─ free_area[0..10]     ← 大部分可分配页在这里
└─ ZONE_NORMAL
   └─ empty
```

其中仍会从 512 MiB 中扣除：

```text
内核本身 + 初期页表 + vmemmap 元数据 + 固件保留范围 + 其他 early allocations
```

所以启动日志显示的可用内存必然小于 QEMU 传入的原始 `-m 512M`。

### 用日志验证先后，不把日志数值混成同一种统计

以已保存的 `qemu-boot.log` 为例：

| 日志顺序 | 记录 | 对应阶段 |
|---|---|---|
| 1 | `NODE_DATA(0) allocated` | 阶段 A：pgdat 存储已经取得。 |
| 2 | `Zone ranges` | 阶段 B：输出 zone 边界，尚非 buddy 入库完成。 |
| 3 | `Built 1 zonelists ... Total pages: 128736` | 阶段 C：搜索路线已构建；这里的页数是规模估计，不是当时空闲链表库存。 |
| 4 | `Memory: 481760K/523768K available ...` | 阶段 D 之后：`mem_init_print_info()` 的统计快照。 |
| 5 | `SLUB: ...` | 阶段 E：对象分配器初始化。 |
| 6 | `Freeing unused kernel image (initmem) memory: 1352K` | 更晚的阶段 E：初始化段使用完后归还。 |

`spanned_pages` 数地址跨度，`present_pages` 数实际存在页，`managed_pages` 数管理页，`nr_free` 数某阶空闲块。以上日志也各有统计口径，不能期待它们简单相等。日志没有逐项输出正式 PCP 或水位线初始化；这些步骤的时序依据源码，不根据“没有日志”推断它们没执行。

---

<a id="10-推荐源码阅读和-gdb-断点顺序"></a>

## 10. 推荐源码阅读和 GDB 断点顺序

按下面顺序读最不容易乱。第 5、8 项写的是**应当逐层 step into 的直接调用关系**；不同编号项之间，则应先 `finish` 回到调用者，再继续观察下一条语句。

1. [`start_kernel()`](../../init/main.c#L931) — 只确认总时间线，不要在这里深挖。
2. [`setup_arch()`](../../arch/x86/kernel/setup.c#L769) — 沿函数体的行号确认 E820、memblock、direct mapping、paging 回调的先后。
3. [`e820__memblock_setup()`](../../arch/x86/kernel/e820.c#L1295) — 看清 `memory` 与 `reserved` 的来源。
4. [`paging_init()`](../../arch/x86/mm/init_64.c#L847) — 只看 `sparse_init()`、两个 `node_clear_state()` 与 `zone_sizes_init()`。
5. [`zone_sizes_init()`](../../arch/x86/mm/init.c#L1188) **直接调用** [`free_area_init()`](../../mm/page_alloc.c#L10509)，后者再进入 [`free_area_init_node()`](../../mm/page_alloc.c#L10119) 与 `memmap_init()`。
6. 从 `free_area_init()` 一路 `finish` 回到 `start_kernel()`，再看 [`build_all_zonelists()`](../../mm/page_alloc.c#L8426) 和 [`page_alloc_init()`](../../mm/page_alloc.c#L10987) 两个同级调用。
7. [`memblock_free_all()`](../../mm/memblock.c#L2207) — 看 early allocator 的最终交接。
8. [`__free_pages_core()`](../../mm/page_alloc.c#L1773) **直接调用** `__free_pages_ok()`，后者**直接调用** [`__free_one_page()`](../../mm/page_alloc.c#L1058)；看具体页如何进入/合并 buddy。
9. 返回 `mm_init()`，观察 [`kmem_cache_init()`](../../mm/slub.c#L4794)、[`vmalloc_init()`](../../mm/vmalloc.c#L2327)，再回到 `start_kernel()` 看 [`setup_per_cpu_pageset()`](../../mm/page_alloc.c#L9509)。
10. 切到 PID 1 的 [`kernel_init()`](../../init/main.c#L1497) 路径，先看 [`page_alloc_init_late()`](../../mm/page_alloc.c#L2319)，再经 initcall 观察 [`init_per_zone_wmark_min()`](../../mm/page_alloc.c#L11187)，最后看 [`free_initmem()`](../../arch/x86/mm/init.c#L1115)。

**入口断点看到的是调用前状态；想确认“已经建好”，要在该函数返回后再看。** `__free_pages_core()` 会命中很多次，观察一个块即可暂时禁用该断点，避免把所有入库块都单步一遍。

推荐断点顺序：

```gdb
b start_kernel
b e820__memblock_setup
b paging_init
b free_area_init
b build_all_zonelists
b page_alloc_init
b memblock_free_all
b __free_pages_core
b kmem_cache_init
b vmalloc_init
b setup_per_cpu_pageset
b page_alloc_init_late
b init_per_zone_wmark_min
b free_initmem
```

| 断到哪里 | 此刻最该验证什么 |
|---|---|
| `free_area_init` | `zone` 的边界/空容器正在建立，但 `managed_pages` 尚未是最终值。 |
| `build_all_zonelists` | zonelist、boot pageset 的路线/框架已经可建；页还未大规模进入 buddy。 |
| `memblock_free_all` | 保留页将被标记 `PageReserved`，而未保留范围即将被分块释放。 |
| `__free_pages_core` | 某一个 order 块从 early 状态进入正常 free 路径。 |
| `setup_per_cpu_pageset` | 基础分配设施已可用，接下来为 populated zone 建正式 PCP。 |
| `page_alloc_init_late` | 已经进入 PID 1 收尾；不应误判成首次 buddy 建库。 |
| `init_per_zone_wmark_min` | 查看设置前后的水位线和 lowmem_reserve；观察变化要等对应 helper 返回。 |
| `free_initmem` | 初始化段此前一直保留，调用完成后才归还其中不再需要的页。 |

---

<a id="11-最终速记"></a>

## 11. 最终速记

```text
E820
  发现 RAM

memblock
  记录 RAM，扣掉 reserved

direct mapping
  让内核可访问物理 RAM

sparse/vmemmap
  让 PFN 找到 struct page

zone/free_area
  建空的 buddy 仓库

build_all_zonelists
  将已有 zone 填成有序搜索表

memblock_free_all
  将未保留 RAM 按 order 投放入库

__free_one_page
  与 buddy 合并，挂进 free_area[order]

kmem_cache_init / vmalloc_init
  准备对象分配和内核虚拟区域管理

setup_per_cpu_pageset
  为有内存的 zone 建正式每 CPU 页缓存

page_alloc_init_late / 后续 initcall
  完成页分配器收尾、水位线和后台机制初始化

free_initmem / 映射收尾
  归还不再需要的 init 内存，完成保护设置
```

> 阅读这条链时，始终追问一句：**“当前是在发现和访问内存、建立管理结构、填搜索路线、交出可用页，还是在完善分配设施与收尾？”**
> 这个问题能把 E820、memblock、vmemmap、zone 和 buddy 清楚地分开。


### 学完这条主线，应当能回答的六个问题

1. **buddy 尚未可用，初始化结构的内存从哪里来？** 来自启动预留/brk 和 memblock 早期分配；使用中的管理数据会被保留。
2. **`pgdat`、`struct page` 的存储和内容何时准备？** `pgdat` 先在 NUMA 阶段取得存储，后完善 node/zone 内容；描述符先由 sparse/vmemmap 准备后备存储，再由 memmap 初始化逐页内容。
3. **哪个“list”先准备，哪个后填？** buddy 空闲链表在 zone 初始化时先置空；zonelist 随后填 zone 引用与顺序；实际空闲块再在释放阶段进入 buddy 链表。
4. **什么动作让页从不可分配变成可分配？** 清理相应早期页状态、更新管理统计，并由正常 buddy 释放路径将页块挂入空闲链表。
5. **为什么还有 PCP、水位线和上层初始化？** 有页库存只是基础，还要建立对象/虚拟区域管理、正式每 CPU 页缓存和正常分配余量策略。
6. **启动结束时，所有 reserved 都能释放吗？** 不能；只有生命周期结束的启动资源按各自路径释放，仍在使用的内核和管理数据必须继续保留。
