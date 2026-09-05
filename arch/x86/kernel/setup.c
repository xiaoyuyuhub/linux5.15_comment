// SPDX-License-Identifier: GPL-2.0-only
/*
 *  Copyright (C) 1995  Linus Torvalds
 *
 * This file contains the setup_arch() code, which handles the architecture-dependent
 * parts of early kernel initialization.
 */
#include <linux/acpi.h>
#include <linux/console.h>
#include <linux/crash_dump.h>
#include <linux/dma-map-ops.h>
#include <linux/dmi.h>
#include <linux/efi.h>
#include <linux/init_ohci1394_dma.h>
#include <linux/initrd.h>
#include <linux/iscsi_ibft.h>
#include <linux/memblock.h>
#include <linux/panic_notifier.h>
#include <linux/pci.h>
#include <linux/root_dev.h>
#include <linux/hugetlb.h>
#include <linux/tboot.h>
#include <linux/usb/xhci-dbgp.h>
#include <linux/static_call.h>
#include <linux/swiotlb.h>

#include <uapi/linux/mount.h>

#include <xen/xen.h>

#include <asm/apic.h>
#include <asm/numa.h>
#include <asm/bios_ebda.h>
#include <asm/bugs.h>
#include <asm/cpu.h>
#include <asm/efi.h>
#include <asm/gart.h>
#include <asm/hypervisor.h>
#include <asm/io_apic.h>
#include <asm/kasan.h>
#include <asm/kaslr.h>
#include <asm/mce.h>
#include <asm/mtrr.h>
#include <asm/realmode.h>
#include <asm/olpc_ofw.h>
#include <asm/pci-direct.h>
#include <asm/prom.h>
#include <asm/proto.h>
#include <asm/thermal.h>
#include <asm/unwind.h>
#include <asm/vsyscall.h>
#include <linux/vmalloc.h>

/*
 * max_low_pfn_mapped: highest directly mapped pfn < 4 GB
 * max_pfn_mapped:     highest directly mapped pfn > 4 GB
 *
 * The direct mapping only covers E820_TYPE_RAM regions, so the ranges and gaps are
 * represented by pfn_mapped[].
 */
unsigned long max_low_pfn_mapped;
unsigned long max_pfn_mapped;

#ifdef CONFIG_DMI
RESERVE_BRK(dmi_alloc, 65536);
#endif


/*
 * Range of the BSS area. The size of the BSS area is determined
 * at link time, with RESERVE_BRK() facility reserving additional
 * chunks.
 */
unsigned long _brk_start = (unsigned long)__brk_base;
unsigned long _brk_end   = (unsigned long)__brk_base;

struct boot_params boot_params;

/*
 * These are the four main kernel memory regions, we put them into
 * the resource tree so that kdump tools and other debugging tools
 * recover it:
 */

static struct resource rodata_resource = {
	.name	= "Kernel rodata",
	.start	= 0,
	.end	= 0,
	.flags	= IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM
};

static struct resource data_resource = {
	.name	= "Kernel data",
	.start	= 0,
	.end	= 0,
	.flags	= IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM
};

static struct resource code_resource = {
	.name	= "Kernel code",
	.start	= 0,
	.end	= 0,
	.flags	= IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM
};

static struct resource bss_resource = {
	.name	= "Kernel bss",
	.start	= 0,
	.end	= 0,
	.flags	= IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM
};


#ifdef CONFIG_X86_32
/* CPU data as detected by the assembly code in head_32.S */
struct cpuinfo_x86 new_cpu_data;

/* Common CPU data for all CPUs */
struct cpuinfo_x86 boot_cpu_data __read_mostly;
EXPORT_SYMBOL(boot_cpu_data);

unsigned int def_to_bigsmp;

struct apm_info apm_info;
EXPORT_SYMBOL(apm_info);

#if defined(CONFIG_X86_SPEEDSTEP_SMI) || \
	defined(CONFIG_X86_SPEEDSTEP_SMI_MODULE)
struct ist_info ist_info;
EXPORT_SYMBOL(ist_info);
#else
struct ist_info ist_info;
#endif

#else
struct cpuinfo_x86 boot_cpu_data __read_mostly;
EXPORT_SYMBOL(boot_cpu_data);
#endif


#if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
__visible unsigned long mmu_cr4_features __ro_after_init;
#else
__visible unsigned long mmu_cr4_features __ro_after_init = X86_CR4_PAE;
#endif

/* Boot loader ID and version as integers, for the benefit of proc_dointvec */
int bootloader_type, bootloader_version;

/*
 * Setup options
 */
struct screen_info screen_info;
EXPORT_SYMBOL(screen_info);
struct edid_info edid_info;
EXPORT_SYMBOL_GPL(edid_info);

extern int root_mountflags;

unsigned long saved_video_mode;

#define RAMDISK_IMAGE_START_MASK	0x07FF
#define RAMDISK_PROMPT_FLAG		0x8000
#define RAMDISK_LOAD_FLAG		0x4000

static char __initdata command_line[COMMAND_LINE_SIZE];
#ifdef CONFIG_CMDLINE_BOOL
static char __initdata builtin_cmdline[COMMAND_LINE_SIZE] = CONFIG_CMDLINE;
#endif

#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
struct edd edd;
#ifdef CONFIG_EDD_MODULE
EXPORT_SYMBOL(edd);
#endif
/**
 * copy_edd() - Copy the BIOS EDD information
 *              from boot_params into a safe place.
 *
 */
static inline void __init copy_edd(void)
{
     memcpy(edd.mbr_signature, boot_params.edd_mbr_sig_buffer,
	    sizeof(edd.mbr_signature));
     memcpy(edd.edd_info, boot_params.eddbuf, sizeof(edd.edd_info));
     edd.mbr_signature_nr = boot_params.edd_mbr_sig_buf_entries;
     edd.edd_info_nr = boot_params.eddbuf_entries;
}
#else
static inline void __init copy_edd(void)
{
}
#endif

void * __init extend_brk(size_t size, size_t align)
{
	size_t mask = align - 1;
	void *ret;

	BUG_ON(_brk_start == 0);
	BUG_ON(align & mask);

	_brk_end = (_brk_end + mask) & ~mask;
	BUG_ON((char *)(_brk_end + size) > __brk_limit);

	ret = (void *)_brk_end;
	_brk_end += size;

	memset(ret, 0, size);

	return ret;
}

#ifdef CONFIG_X86_32
static void __init cleanup_highmap(void)
{
}
#endif

static void __init reserve_brk(void)
{
	if (_brk_end > _brk_start)
		memblock_reserve(__pa_symbol(_brk_start),
				 _brk_end - _brk_start);

	/* Mark brk area as locked down and no longer taking any
	   new allocations */
	_brk_start = 0;
}

u64 relocated_ramdisk;

#ifdef CONFIG_BLK_DEV_INITRD

static u64 __init get_ramdisk_image(void)
{
	u64 ramdisk_image = boot_params.hdr.ramdisk_image;

	ramdisk_image |= (u64)boot_params.ext_ramdisk_image << 32;

	if (ramdisk_image == 0)
		ramdisk_image = phys_initrd_start;

	return ramdisk_image;
}
static u64 __init get_ramdisk_size(void)
{
	u64 ramdisk_size = boot_params.hdr.ramdisk_size;

	ramdisk_size |= (u64)boot_params.ext_ramdisk_size << 32;

	if (ramdisk_size == 0)
		ramdisk_size = phys_initrd_size;

	return ramdisk_size;
}

static void __init relocate_initrd(void)
{
	/* Assume only end is not page aligned */
	u64 ramdisk_image = get_ramdisk_image();
	u64 ramdisk_size  = get_ramdisk_size();
	u64 area_size     = PAGE_ALIGN(ramdisk_size);

	/* We need to move the initrd down into directly mapped mem */
	relocated_ramdisk = memblock_phys_alloc_range(area_size, PAGE_SIZE, 0,
						      PFN_PHYS(max_pfn_mapped));
	if (!relocated_ramdisk)
		panic("Cannot find place for new RAMDISK of size %lld\n",
		      ramdisk_size);

	initrd_start = relocated_ramdisk + PAGE_OFFSET;
	initrd_end   = initrd_start + ramdisk_size;
	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
	       relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);

	copy_from_early_mem((void *)initrd_start, ramdisk_image, ramdisk_size);

	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
		" [mem %#010llx-%#010llx]\n",
		ramdisk_image, ramdisk_image + ramdisk_size - 1,
		relocated_ramdisk, relocated_ramdisk + ramdisk_size - 1);
}

static void __init early_reserve_initrd(void)
{
	/* Assume only end is not page aligned */
	u64 ramdisk_image = get_ramdisk_image();
	u64 ramdisk_size  = get_ramdisk_size();
	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);

	if (!boot_params.hdr.type_of_loader ||
	    !ramdisk_image || !ramdisk_size)
		return;		/* No initrd provided by bootloader */

	memblock_reserve(ramdisk_image, ramdisk_end - ramdisk_image);
}

static void __init reserve_initrd(void)
{
	/* Assume only end is not page aligned */
	u64 ramdisk_image = get_ramdisk_image();
	u64 ramdisk_size  = get_ramdisk_size();
	u64 ramdisk_end   = PAGE_ALIGN(ramdisk_image + ramdisk_size);

	if (!boot_params.hdr.type_of_loader ||
	    !ramdisk_image || !ramdisk_size)
		return;		/* No initrd provided by bootloader */

	initrd_start = 0;

	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
			ramdisk_end - 1);

	if (pfn_range_is_mapped(PFN_DOWN(ramdisk_image),
				PFN_DOWN(ramdisk_end))) {
		/* All are mapped, easy case */
		initrd_start = ramdisk_image + PAGE_OFFSET;
		initrd_end = initrd_start + ramdisk_size;
		return;
	}

	relocate_initrd();

	memblock_free(ramdisk_image, ramdisk_end - ramdisk_image);
}

#else
static void __init early_reserve_initrd(void)
{
}
static void __init reserve_initrd(void)
{
}
#endif /* CONFIG_BLK_DEV_INITRD */

static void __init parse_setup_data(void)
{
	struct setup_data *data;
	u64 pa_data, pa_next;

	pa_data = boot_params.hdr.setup_data;
	while (pa_data) {
		u32 data_len, data_type;

		data = early_memremap(pa_data, sizeof(*data));
		data_len = data->len + sizeof(struct setup_data);
		data_type = data->type;
		pa_next = data->next;
		early_memunmap(data, sizeof(*data));

		switch (data_type) {
		case SETUP_E820_EXT:
			e820__memory_setup_extended(pa_data, data_len);
			break;
		case SETUP_DTB:
			add_dtb(pa_data);
			break;
		case SETUP_EFI:
			parse_efi_setup(pa_data, data_len);
			break;
		default:
			break;
		}
		pa_data = pa_next;
	}
}

static void __init memblock_x86_reserve_range_setup_data(void)
{
	struct setup_data *data;
	u64 pa_data;

	pa_data = boot_params.hdr.setup_data;
	while (pa_data) {
		data = early_memremap(pa_data, sizeof(*data));
		memblock_reserve(pa_data, sizeof(*data) + data->len);

		if (data->type == SETUP_INDIRECT &&
		    ((struct setup_indirect *)data->data)->type != SETUP_INDIRECT)
			memblock_reserve(((struct setup_indirect *)data->data)->addr,
					 ((struct setup_indirect *)data->data)->len);

		pa_data = data->next;
		early_memunmap(data, sizeof(*data));
	}
}

/*
 * --------- Crashkernel reservation ------------------------------
 */

#ifdef CONFIG_KEXEC_CORE

/* 16M alignment for crash kernel regions */
#define CRASH_ALIGN		SZ_16M

/*
 * Keep the crash kernel below this limit.
 *
 * Earlier 32-bits kernels would limit the kernel to the low 512 MB range
 * due to mapping restrictions.
 *
 * 64-bit kdump kernels need to be restricted to be under 64 TB, which is
 * the upper limit of system RAM in 4-level paging mode. Since the kdump
 * jump could be from 5-level paging to 4-level paging, the jump will fail if
 * the kernel is put above 64 TB, and during the 1st kernel bootup there's
 * no good way to detect the paging mode of the target kernel which will be
 * loaded for dumping.
 */
#ifdef CONFIG_X86_32
# define CRASH_ADDR_LOW_MAX	SZ_512M
# define CRASH_ADDR_HIGH_MAX	SZ_512M
#else
# define CRASH_ADDR_LOW_MAX	SZ_4G
# define CRASH_ADDR_HIGH_MAX	SZ_64T
#endif

static int __init reserve_crashkernel_low(void)
{
#ifdef CONFIG_X86_64
	unsigned long long base, low_base = 0, low_size = 0;
	unsigned long low_mem_limit;
	int ret;

	low_mem_limit = min(memblock_phys_mem_size(), CRASH_ADDR_LOW_MAX);

	/* crashkernel=Y,low */
	ret = parse_crashkernel_low(boot_command_line, low_mem_limit, &low_size, &base);
	if (ret) {
		/*
		 * two parts from kernel/dma/swiotlb.c:
		 * -swiotlb size: user-specified with swiotlb= or default.
		 *
		 * -swiotlb overflow buffer: now hardcoded to 32k. We round it
		 * to 8M for other buffers that may need to stay low too. Also
		 * make sure we allocate enough extra low memory so that we
		 * don't run out of DMA buffers for 32-bit devices.
		 */
		low_size = max(swiotlb_size_or_default() + (8UL << 20), 256UL << 20);
	} else {
		/* passed with crashkernel=0,low ? */
		if (!low_size)
			return 0;
	}

	low_base = memblock_phys_alloc_range(low_size, CRASH_ALIGN, 0, CRASH_ADDR_LOW_MAX);
	if (!low_base) {
		pr_err("Cannot reserve %ldMB crashkernel low memory, please try smaller size.\n",
		       (unsigned long)(low_size >> 20));
		return -ENOMEM;
	}

	pr_info("Reserving %ldMB of low memory at %ldMB for crashkernel (low RAM limit: %ldMB)\n",
		(unsigned long)(low_size >> 20),
		(unsigned long)(low_base >> 20),
		(unsigned long)(low_mem_limit >> 20));

	crashk_low_res.start = low_base;
	crashk_low_res.end   = low_base + low_size - 1;
	insert_resource(&iomem_resource, &crashk_low_res);
#endif
	return 0;
}

static void __init reserve_crashkernel(void)
{
	unsigned long long crash_size, crash_base, total_mem;
	bool high = false;
	int ret;

	total_mem = memblock_phys_mem_size();

	/* crashkernel=XM */
	ret = parse_crashkernel(boot_command_line, total_mem, &crash_size, &crash_base);
	if (ret != 0 || crash_size <= 0) {
		/* crashkernel=X,high */
		ret = parse_crashkernel_high(boot_command_line, total_mem,
					     &crash_size, &crash_base);
		if (ret != 0 || crash_size <= 0)
			return;
		high = true;
	}

	if (xen_pv_domain()) {
		pr_info("Ignoring crashkernel for a Xen PV domain\n");
		return;
	}

	/* 0 means: find the address automatically */
	if (!crash_base) {
		/*
		 * Set CRASH_ADDR_LOW_MAX upper bound for crash memory,
		 * crashkernel=x,high reserves memory over 4G, also allocates
		 * 256M extra low memory for DMA buffers and swiotlb.
		 * But the extra memory is not required for all machines.
		 * So try low memory first and fall back to high memory
		 * unless "crashkernel=size[KMG],high" is specified.
		 */
		if (!high)
			crash_base = memblock_phys_alloc_range(crash_size,
						CRASH_ALIGN, CRASH_ALIGN,
						CRASH_ADDR_LOW_MAX);
		if (!crash_base)
			crash_base = memblock_phys_alloc_range(crash_size,
						CRASH_ALIGN, CRASH_ALIGN,
						CRASH_ADDR_HIGH_MAX);
		if (!crash_base) {
			pr_info("crashkernel reservation failed - No suitable area found.\n");
			return;
		}
	} else {
		unsigned long long start;

		start = memblock_phys_alloc_range(crash_size, SZ_1M, crash_base,
						  crash_base + crash_size);
		if (start != crash_base) {
			pr_info("crashkernel reservation failed - memory is in use.\n");
			return;
		}
	}

	if (crash_base >= (1ULL << 32) && reserve_crashkernel_low()) {
		memblock_free(crash_base, crash_size);
		return;
	}

	pr_info("Reserving %ldMB of memory at %ldMB for crashkernel (System RAM: %ldMB)\n",
		(unsigned long)(crash_size >> 20),
		(unsigned long)(crash_base >> 20),
		(unsigned long)(total_mem >> 20));

	crashk_res.start = crash_base;
	crashk_res.end   = crash_base + crash_size - 1;
	insert_resource(&iomem_resource, &crashk_res);
}
#else
static void __init reserve_crashkernel(void)
{
}
#endif

static struct resource standard_io_resources[] = {
	{ .name = "dma1", .start = 0x00, .end = 0x1f,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "pic1", .start = 0x20, .end = 0x21,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "timer0", .start = 0x40, .end = 0x43,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "timer1", .start = 0x50, .end = 0x53,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "keyboard", .start = 0x60, .end = 0x60,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "keyboard", .start = 0x64, .end = 0x64,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "dma page reg", .start = 0x80, .end = 0x8f,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "pic2", .start = 0xa0, .end = 0xa1,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "dma2", .start = 0xc0, .end = 0xdf,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO },
	{ .name = "fpu", .start = 0xf0, .end = 0xff,
		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
};

void __init reserve_standard_io_resources(void)
{
	int i;

	/* request I/O space for devices used on all i[345]86 PCs */
	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
		request_resource(&ioport_resource, &standard_io_resources[i]);

}

static bool __init snb_gfx_workaround_needed(void)
{
#ifdef CONFIG_PCI
	int i;
	u16 vendor, devid;
	static const __initconst u16 snb_ids[] = {
		0x0102,
		0x0112,
		0x0122,
		0x0106,
		0x0116,
		0x0126,
		0x010a,
	};

	/* Assume no if something weird is going on with PCI */
	if (!early_pci_allowed())
		return false;

	vendor = read_pci_config_16(0, 2, 0, PCI_VENDOR_ID);
	if (vendor != 0x8086)
		return false;

	devid = read_pci_config_16(0, 2, 0, PCI_DEVICE_ID);
	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
		if (devid == snb_ids[i])
			return true;
#endif

	return false;
}

/*
 * Sandy Bridge graphics has trouble with certain ranges, exclude
 * them from allocation.
 */
static void __init trim_snb_memory(void)
{
	static const __initconst unsigned long bad_pages[] = {
		0x20050000,
		0x20110000,
		0x20130000,
		0x20138000,
		0x40004000,
	};
	int i;

	if (!snb_gfx_workaround_needed())
		return;

	printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");

	/*
	 * SandyBridge integrated graphics devices have a bug that prevents
	 * them from accessing certain memory ranges, namely anything below
	 * 1M and in the pages listed in bad_pages[] above.
	 *
	 * To avoid these pages being ever accessed by SNB gfx devices reserve
	 * bad_pages that have not already been reserved at boot time.
	 * All memory below the 1 MB mark is anyway reserved later during
	 * setup_arch(), so there is no need to reserve it here.
	 */

	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
			       bad_pages[i]);
	}
}

static void __init trim_bios_range(void)
{
	/*
	 * A special case is the first 4Kb of memory;
	 * This is a BIOS owned area, not kernel ram, but generally
	 * not listed as such in the E820 table.
	 *
	 * This typically reserves additional memory (64KiB by default)
	 * since some BIOSes are known to corrupt low memory.  See the
	 * Kconfig help text for X86_RESERVE_LOW.
	 */
	e820__range_update(0, PAGE_SIZE, E820_TYPE_RAM, E820_TYPE_RESERVED);

	/*
	 * special case: Some BIOSes report the PC BIOS
	 * area (640Kb -> 1Mb) as RAM even though it is not.
	 * take them out.
	 */
	e820__range_remove(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_TYPE_RAM, 1);

	e820__update_table(e820_table);
}

/* called before trim_bios_range() to spare extra sanitize */
static void __init e820_add_kernel_range(void)
{
	u64 start = __pa_symbol(_text);
	u64 size = __pa_symbol(_end) - start;

	/*
	 * Complain if .text .data and .bss are not marked as E820_TYPE_RAM and
	 * attempt to fix it by adding the range. We may have a confused BIOS,
	 * or the user may have used memmap=exactmap or memmap=xxM$yyM to
	 * exclude kernel range. If we really are running on top non-RAM,
	 * we will crash later anyways.
	 */
	if (e820__mapped_all(start, start + size, E820_TYPE_RAM))
		return;

	pr_warn(".text .data .bss are not marked as E820_TYPE_RAM!\n");
	e820__range_remove(start, size, E820_TYPE_RAM, 0);
	e820__range_add(start, size, E820_TYPE_RAM);
}

static void __init early_reserve_memory(void)
{
	/*
	 * Reserve the memory occupied by the kernel between _text and
	 * __end_of_kernel_reserve symbols. Any kernel sections after the
	 * __end_of_kernel_reserve symbol must be explicitly reserved with a
	 * separate memblock_reserve() or they will be discarded.
	 */
	memblock_reserve(__pa_symbol(_text),
			 (unsigned long)__end_of_kernel_reserve - (unsigned long)_text);

	/*
	 * The first 4Kb of memory is a BIOS owned area, but generally it is
	 * not listed as such in the E820 table.
	 *
	 * Reserve the first 64K of memory since some BIOSes are known to
	 * corrupt low memory. After the real mode trampoline is allocated the
	 * rest of the memory below 640k is reserved.
	 *
	 * In addition, make sure page 0 is always reserved because on
	 * systems with L1TF its contents can be leaked to user processes.
	 */
	memblock_reserve(0, SZ_64K);

	early_reserve_initrd();

	if (efi_enabled(EFI_BOOT))
		efi_memblock_x86_reserve_range();

	memblock_x86_reserve_range_setup_data();

	reserve_ibft_region();
	reserve_bios_regions();
	trim_snb_memory();
}

/*
 * Dump out kernel offset information on panic.
 */
static int
dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
{
	if (kaslr_enabled()) {
		pr_emerg("Kernel Offset: 0x%lx from 0x%lx (relocation range: 0x%lx-0x%lx)\n",
			 kaslr_offset(),
			 __START_KERNEL,
			 __START_KERNEL_map,
			 MODULES_VADDR-1);
	} else {
		pr_emerg("Kernel Offset: disabled\n");
	}

	return 0;
}

/*
 * Determine if we were loaded by an EFI loader.  If so, then we have also been
 * passed the efi memmap, systab, etc., so we should use these data structures
 * for initialization.  Note, the efi init code path is determined by the
 * global efi_enabled. This allows the same kernel image to be used on existing
 * systems (with a traditional BIOS) as well as on EFI systems.
 */
/*
 * setup_arch - architecture-specific boot-time initializations
 *
 * Note: On x86_64, fixmaps are ready for use even before this is called.
 */
/*
 * x86 体系结构相关初始化的总入口。
 *
 * 主要工作：
 *  - 从 bootloader/固件/EFI/ACPI/e820 中收集各种启动期信息
 *  - 初始化早期 IDT、CPU 特性、early ioremap
 *  - 处理 e820 内存布局，建立 memblock 视图
 *  - 预留内核自身、initrd、ACPI 表、crashkernel 等物理内存
 *  - 建立完整内核线性映射、正式页表、KASLR 内存随机化
 *  - 初始化 APIC/IOAPIC/NUMA/ACPI/EFI 等平台设施
 *  - 整理/合并命令行，返回给 start_kernel()
 */
void __init setup_arch(char **cmdline_p)
{
#ifdef CONFIG_X86_32
	/*
	 * 32 位：把在 early 阶段探测的 new_cpu_data
	 * 拷贝到正式使用的 boot_cpu_data。
	 */
	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));

	/*
	 * 32 位：复制已经建立好的内核地址范围映射，
	 * 切换到最终的 swapper 页全局目录。
	 *
	 * clone_pgd_range() 会把 initial_page_table 中
	 * KERNEL_PGD_BOUNDARY 之后的内核映射复制到 swapper_pg_dir。
	 */
	clone_pgd_range(swapper_pg_dir     + KERNEL_PGD_BOUNDARY,
			initial_page_table + KERNEL_PGD_BOUNDARY,
			KERNEL_PGD_PTRS);

	/*
	 * 切换 CR3 到 swapper_pg_dir，TLB 会随之被刷新。
	 */
	load_cr3(swapper_pg_dir);

	/*
	 * 注意：Quark X1000 CPU 把 PGE 特性报告错误，
	 * 需要通过 load_cr3() 来刷新 TLB。
	 * 这里 __flush_tlb_all() 之前 CPU quirk 还没生效，
	 * 但上面的 load_cr3() 已经确保了 TLB 被刷新。
	 */
	__flush_tlb_all();
#else
	/*
	 * 64 位：直接打印 bootloader 传入的原始命令行。
	 */
	printk(KERN_INFO "Command line: %s\n", boot_command_line);

	/*
	 * 初步设置物理地址位数上限，用 MAX_PHYSMEM_BITS。
	 * 后面 CPU 特性探测后可能再修正。
	 */
	boot_cpu_data.x86_phys_bits = MAX_PHYSMEM_BITS;
#endif

	/*
	 * 有 OLPC + OpenFirmware 的平台上，reserve_top() 可能会
	 * 改变 fixmap 的位置，所以必须在使用 ioremap 之前调用。
	 */
	olpc_ofw_detect();

	/*
	 * 设置一套早期 IDT，安装基础异常门（#PF/#GP/#UD 等），
	 * 防止 early 阶段出异常直接三重故障重启。
	 */
	idt_setup_early_traps();

	/*
	 * 早期 CPU 初始化：读取 CPUID，填充 boot_cpu_data，
	 * 建立基础的 CPU 特性集，某些关键特性会在此阶段启用/禁用。
	 */
	early_cpu_init();

	/*
	 * 初始化静态分支 (jump label) 框架的早期部分。
	 * 这允许后面根据 CPU 特性/内核参数 patch 分支。
	 */
	jump_label_init();

	/*
	 * static_call 框架初始化，用于把函数指针调用优化为静态调用。
	 */
	static_call_init();

	/*
	 * early ioremap 初始化：
	 * 在 fixmap 正式完全就绪前，提供有限的 MMIO 映射能力，
	 * 用于访问 BIOS/ACPI/EFI 等早期数据结构。
	 */
	early_ioremap_init();

	/*
	 * 某些 OLPC/OFW 平台需要单独处理 PGD。
	 * 一般 PC 平台这里是 no-op。
	 */
	setup_olpc_ofw_pgd();

	/*
	 * 从 boot_params（bootloader 传入的实模式参数区）
	 * 把 root_dev 解码为内核内部的 dev_t。
	 */
	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);

	/*
	 * 保存视频模式信息和显示器 EDID 信息，
	 * 供控制台/帧缓冲驱动使用。
	 */
	screen_info = boot_params.screen_info;
	edid_info = boot_params.edid_info;

#ifdef CONFIG_X86_32
	/*
	 * 32 位平台的一些 BIOS/APM/IST 相关信息。
	 */
	apm_info.bios = boot_params.apm_bios_info;
	ist_info = boot_params.ist_info;
#endif

	/*
	 * 保存启动时的视频模式编号。
	 */
	saved_video_mode = boot_params.hdr.vid_mode;

	/*
	 * 记录 bootloader 类型 (GRUB/SYSLINUX/…)，
	 * type_of_loader 低 4 bit 为类型，高 4 bit 为扩展。
	 */
	bootloader_type = boot_params.hdr.type_of_loader;
	if ((bootloader_type >> 4) == 0xe) {
		/*
		 * 0xe 表示使用扩展 loader 类型，需从 ext_loader_type 取。
		 */
		bootloader_type &= 0xf;
		bootloader_type |= (boot_params.hdr.ext_loader_type+0x10) << 4;
	}

	/*
	 * 组合 loader 版本号：低 4 bit + ext_loader_ver 高位。
	 */
	bootloader_version  = bootloader_type & 0xf;
	bootloader_version |= boot_params.hdr.ext_loader_ver << 4;

#ifdef CONFIG_BLK_DEV_RAM
	/*
	 * ramdisk 镜像起始位置信息，由 bootloader 填入 ram_size 字段。
	 */
	rd_image_start = boot_params.hdr.ram_size & RAMDISK_IMAGE_START_MASK;
#endif

#ifdef CONFIG_EFI
	/*
	 * 根据 efi_loader_signature 判断是不是从 EFI 启动，
	 * 以及是 EFI32 还是 EFI64。
	 */
	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
		     EFI32_LOADER_SIGNATURE, 4)) {
		set_bit(EFI_BOOT, &efi.flags);
	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
		     EFI64_LOADER_SIGNATURE, 4)) {
		set_bit(EFI_BOOT, &efi.flags);
		set_bit(EFI_64BIT, &efi.flags);
	}
#endif

	/*
	 * OEM/平台专用的 arch_setup 钩子。
	 * 某些服务器/嵌入式平台会在这里注入特殊初始化逻辑。
	 */
	x86_init.oem.arch_setup();

	/*
	 * 在把内存正式加入 memblock 之前，先做“早期保留”：
	 * 包括内核文本、bootloader 数据、BIOS/EFI 某些区域等。
	 *
	 * 目的：避免 memblock 后续分配覆盖这些重要区域。
	 *
	 * 注释中特别说明：
	 * 这一步必须在 e820__memory_setup() 之前，
	 * 因为 Xen dom0 的 xen_memory_setup() 依赖于这些保留。
	 */
	early_reserve_memory();

	/*
	 * 建立物理地址空间资源根节点的 end 值，
	 * 使用 x86_phys_bits 决定最大可寻址物理地址。
	 *
	 * iomem_resource: 整个物理地址空间的“资源树”根节点，
	 * 后续 RAM/ROM/MMIO 等都会挂在它下面。
	 */
	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;

	/*
	 * 处理 BIOS/bootloader 提供的 e820 map：
	 * - 复制到内核内部
	 * - 归一化/排序/合并
	 * - 可能加上一些额外保留/修正
	 */
	e820__memory_setup();

	/*
	 * 解析 bootloader 附加的 setup_data 链表。
	 * 这些数据可以携带额外的内存/EFI/ramdisk 等信息。
	 */
	parse_setup_data();

	/*
	 * 拷贝 EDD (Enhanced Disk Drive) 信息，
	 * 用于旧式 BIOS 磁盘探测/调试。
	 */
	copy_edd();

	/*
	 * 如果 bootloader 没指定 root_flags，则默认把 root 文件系统
	 * 挂载为可写（清除 MS_RDONLY）。
	 */
	if (!boot_params.hdr.root_flags)
		root_mountflags &= ~MS_RDONLY;

	/*
	 * 初始化 init_mm（内核的第一个 mm_struct），告知：
	 *  - 内核文本段起止 [_text, _etext)
	 *  - 数据段 [_sdata, _edata)
	 *  - brk 区域末尾 (_brk_end)
	 * 后面内核页表、虚拟地址布局都会基于这些信息。
	 */
	setup_initial_init_mm(_text, _etext, _edata, (void *)_brk_end);

	/*
	 * 把内核自身的物理地址区间注册成 struct resource，
	 * 之后插入 iomem_resource，供 /proc/iomem 等使用。
	 */
	code_resource.start   = __pa_symbol(_text);
	code_resource.end     = __pa_symbol(_etext)      - 1;
	rodata_resource.start = __pa_symbol(__start_rodata);
	rodata_resource.end   = __pa_symbol(__end_rodata) - 1;
	data_resource.start   = __pa_symbol(_sdata);
	data_resource.end     = __pa_symbol(_edata)      - 1;
	bss_resource.start    = __pa_symbol(__bss_start);
	bss_resource.end      = __pa_symbol(__bss_stop)  - 1;

#ifdef CONFIG_CMDLINE_BOOL
#ifdef CONFIG_CMDLINE_OVERRIDE
	/*
	 * 如果配置了 CMDLINE_OVERRIDE，则完全用 builtin_cmdline
	 * 覆盖 bootloader 的命令行。
	 */
	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
#else
	/*
	 * 否则，如果 builtin_cmdline 非空，则将 bootloader cmdline
	 * 追加在 builtin_cmdline 后面，再写回 boot_command_line。
	 *
	 * 也就是：最终命令行 = builtin_cmdline + " " + bootloader_cmdline
	 */
	if (builtin_cmdline[0]) {
		/* append boot loader cmdline to builtin */
		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
	}
#endif
#endif

	/*
	 * 把最终命令行复制到 command_line 缓冲区，
	 * 并通过 *cmdline_p 返回给 start_kernel()。
	 */
	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
	*cmdline_p = command_line;

	/*
	 * x86_configure_nx() 在 parse_early_param() 之前调用一次，
	 * 目的是：
	 *  - 如果硬件不支持 NX，可以提前得知；
	 *  - early 阶段 set_fixmap() 可以安全使用（不会错误设置 NX）。
	 *
	 * 后面在 noexec_setup() 中解析 noexec= 参数时，可能再次调用，
	 * 根据命令行选项最终确定 NX 策略。
	 */
	x86_configure_nx();

	/*
	 * 解析 early_param 注册的参数（.early_param 段），
	 * 这些参数在非常早期就会生效，影响后续初始化行为。
	 */
	parse_early_param();

#ifdef CONFIG_MEMORY_HOTPLUG
	/*
	 * 热插拔内存相关说明（注释里写得很详细，翻译一下）：
	 *
	 * - 内核使用的内存页不能被 hot-remove，因为内核页无法迁移。
	 * - 当启用内存热插拔时，应该尽量避免把内核分配到可热插拔内存上。
	 *
	 * ACPI SRAT 记录了所有 hotpluggable 内存范围，
	 * 但在 SRAT 解析之前我们不知道哪些是 hotpluggable。
	 *
	 * 内核镜像在非常早期就加载到某个 node 的内存中，
	 * 这个 node 必然是不可 hotpluggable 的。
	 *
	 * 在 SRAT 解析之前，我们通过 bottom-up 分配策略：
	 *  - 尽量从靠近内核镜像的区域分配内存，
	 *  - 尽量远离可能是 hotpluggable 的高地址区域。
	 */
	if (movable_node_is_enabled())
		memblock_set_bottom_up(true);
#endif

	/*
	 * 报告当前 NX 状态（启用/禁用），供日志/调试使用。
	 */
	x86_report_nx();

	/*
	 * 使用 ACPI/MPS 检查中断/多处理器配置的一致性。
	 * 如果发现有问题，可能需要禁用本地 APIC。
	 */
	if (acpi_mps_check()) {
#ifdef CONFIG_X86_LOCAL_APIC
		disable_apic = 1;
#endif
		setup_clear_cpu_cap(X86_FEATURE_APIC);
	}

	/*
	 * 把 setup_data 所占用的物理内存在 e820 中标记为保留。
	 */
	e820__reserve_setup_data();

	/*
	 * 完成与 e820 相关的 early 参数处理，
	 * 比如 memmap= / reserve= 等命令行影响的区域。
	 */
	e820__finish_early_params();

	/*
	 * 若通过 EFI 启动，则进行 EFI 的初始化：
	 * - 建立 EFI memory map
	 * - 设置 runtime services 接口等
	 */
	if (efi_enabled(EFI_BOOT))
		efi_init();

	/*
	 * 解析 DMI/SMBIOS 表，获取厂商/产品/版本等信息。
	 * 很多平台 quirk 会根据 DMI 做判断。
	 */
	dmi_setup();

	/*
	 * 在 DMI 可用后，检测 hypervisor 类型（VMware/KVM/Hyper-V 等），
	 * 这是 boot CPU 的平台检测。
	 */
	init_hypervisor_platform();

	/*
	 * 早期 TSC 初始化：估算频率、判断 TSC 是否稳定等，
	 * 后续 timekeeping 和 delay loop 会依赖这些信息。
	 */
	tsc_early_init();

	/*
	 * 探测 ROM 资源区域（如 VGA ROM、BIOS 扩展 ROM 等），
	 * 并填充对应资源。
	 */
	x86_init.resources.probe_roms();

	/*
	 * 在 parse_early_param 之后插入内核各个段的资源到 iomem_resource：
	 * 这便于调试/查看物理内存布局（/proc/iomem）。
	 */
	insert_resource(&iomem_resource, &code_resource);
	insert_resource(&iomem_resource, &rodata_resource);
	insert_resource(&iomem_resource, &data_resource);
	insert_resource(&iomem_resource, &bss_resource);

	/*
	 * 在 e820 中增加内核占用的物理地址区间，
	 * 防止被当作可用 RAM 分配掉。
	 */
	e820_add_kernel_range();

	/*
	 * 修剪 BIOS 内存区域：某些 BIOS 可能把自己的区域标成 RAM，
	 * 这里根据经验/表格做修正。
	 */
	trim_bios_range();

#ifdef CONFIG_X86_32
	/*
	 * 32 位：修正 Pentium Pro 某些 bug 导致的内存映射问题。
	 */
	if (ppro_with_ram_bug()) {
		e820__range_update(0x70000000ULL, 0x40000ULL, E820_TYPE_RAM,
				  E820_TYPE_RESERVED);
		e820__update_table(e820_table);
		printk(KERN_INFO "fixed physical RAM map:\n");
		e820__print_table("bad_ppro");
	}
#else
	/*
	 * 64 位：检查是否需要启用早期 GART IOMMU，
	 * 某些平台会在这里初始化 IOMMU 相关设置。
	 */
	early_gart_iommu_check();
#endif

	/*
	 * 从 e820 map 中推导整个系统 RAM 的最后一个 PFN，
	 * 即 max_pfn（最大可用物理页号，不含设备 MMIO）。
	 */
	max_pfn = e820__end_of_ram_pfn();

	/*
	 * 初始化 MTRR（Memory Type Range Registers）：
	 * - 根据 BIOS 设置/CPU 支持情况初始化缓存属性。
	 */
	mtrr_bp_init();

	/*
	 * 根据 MTRR 信息，对 e820 map 做进一步裁剪：
	 * - 把被标记为 UC(uncached) 的尾部 RAM 视为不可用，
	 *   防止缓存属性混乱。
	 *
	 * 如果发生裁剪，则需要重新计算 max_pfn。
	 */
	if (mtrr_trim_uncached_memory(max_pfn))
		max_pfn = e820__end_of_ram_pfn();

	/*
	 * 记录“最大可能 PFN”，后续内存 hotplug 等要用。
	 */
	max_possible_pfn = max_pfn;

	/*
	 * 初始化缓存模式：
	 * - 在不支持 PAT 的 CPU 上，需要根据 MTRR 设置 fallback；
	 * - 如果 mtrr_bp_init() 里面已经调用了 pat_init()，
	 *   这里再次调用也不会有影响。
	 */
	init_cache_modes();

	/*
	 * KASLR 内存随机化：
	 * 现在 max_pfn 已经确定，可以计算内核各内存区域的随机基址
	 * （text/vmalloc/vmemmap 等）的随机偏移。
	 */
	kernel_randomize_memory();

#ifdef CONFIG_X86_32
	/*
	 * 32 位：find_low_pfn_range() 会更新 max_low_pfn，
	 * 表示低端可映射内存范围。
	 */
	/* max_low_pfn get updated here */
	find_low_pfn_range();
#else
	/*
	 * 检查是否支持 x2APIC 并做相应设置。
	 */
	check_x2apic();

	/*
	 * 计算 max_low_pfn：
	 * 如果总内存超过 4G，则低端内存范围只取 4G 以下部分；
	 * 否则直接等于 max_pfn。
	 */
	/* How many end-of-memory variables you have, grandma! */
	/* need this before calling reserve_initrd */
	if (max_pfn > (1UL<<(32 - PAGE_SHIFT)))
		max_low_pfn = e820__end_of_low_ram_pfn();
	else
		max_low_pfn = max_pfn;

	/*
	 * high_memory 是内核可直接线性映射的虚拟地址末尾：
	 * high_memory = __va(最后一个 PFN 的末地址) + 1
	 */
	high_memory = (void *)__va(max_pfn * PAGE_SIZE - 1) + 1;
#endif

	/*
	 * 查找并预留可能存在的 boot-time SMP 配置信息：
	 * 比如 MP table / ACPI MADT 中的 SMP 拓扑。
	 */
	find_smp_config();

	/*
	 * 为后续构建页表预先分配一块用于保存额外页表项的缓冲，
	 * 避免频繁 alloc。
	 */
	early_alloc_pgt_buf();

	/*
	 * 在调用 e820__memblock_setup() 前，必须先“封口” brk 区域：
	 * - brk 是 early boot 的线性分配器；
	 * - 这里将 brk 最终大小保留到 memblock.reserved，
	 *   防止 e820/memblock 分配重叠。
	 */
	reserve_brk();

	/*
	 * 清理 early 阶段建立的高端映射，避免和正式映射冲突。
	 */
	cleanup_highmap();

	/*
	 * 在 memblock 完整建立前，先将当前 memblock 分配上限
	 * 设为 ISA_END_ADDRESS（通常为 16MB 左右），
	 * 防止早期分配冲进某些不安全区域。
	 */
	memblock_set_current_limit(ISA_END_ADDRESS);

	/*
	 * 把 e820 中的内存区间转化为 memblock.memory；
	 * 再把前面 early_reserve/ reserve_brk 等标记的区域
	 * 转化为 memblock.reserved。
	 *
	 * 之后内核 early 阶段的物理内存分配基本都通过 memblock。
	 */
	e820__memblock_setup();

	/*
	 * SEV (Secure Encrypted Virtualization) 相关架构初始化：
	 * 设置加密 bit 等。
	 */
	/*
	 * Needs to run after memblock setup because it needs the physical
	 * memory size.
	 */
	sev_setup_arch();

	/*
	 * 一堆 EFI 相关的调整：
	 *  - efi_fake_memmap()：某些固件有 bug，需要构造/修正内存映射；
	 *  - efi_find_mirror()：查找内存镜像区域；
	 *  - efi_esrt_init()：初始化 ESRT（EFI System Resource Table）；
	 *  - efi_mokvar_table_init()：初始化 MOK（Machine Owner Key）变量表。
	 */
	efi_fake_memmap();
	efi_find_mirror();
	efi_esrt_init();
	efi_mokvar_table_init();

	/*
	 * EFI 规范声称 ExitBootServices() 后不会再调用 boot services，
	 * 但现实世界固件经常“说谎”，所以这里直接把 boot services
	 * 相关区域预留掉，避免被内核当成普通 RAM 使用。
	 */
	efi_reserve_boot_services();

	/*
	 * 为 mptable (MP 配置表) 预留 4K 物理内存，
	 * 并在 e820/memblock 中标记为 reserved。
	 */
	/* preallocate 4k for mptable mpc */
	e820__memblock_alloc_reserved_mpc_new();

#ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
	/*
	 * 设置 BIOS 内存损坏检测机制，用于发现固件乱写内存的问题。
	 */
	setup_bios_corruption_check();
#endif

#ifdef CONFIG_X86_32
	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
			(max_pfn_mapped<<PAGE_SHIFT) - 1);
#endif

	/*
	 * 为 real mode trampoline 预留内存，并整体预留低 1MB：
	 *
	 * - trampoline 用于 AP 启动、kexec、S3 恢复等需要进入实模式的场景；
	 * - BIOS 往往喜欢乱动低内存，因此简单粗暴整块保留前 1MB，
	 *   以减少被破坏的风险（Windows 也采取类似策略）。
	 */
	reserve_real_mode();

	/*
	 * 构建完整的内核线性映射：
	 * - 基于 e820/mtrr/KASLR 随机基址；
	 * - 建立从物理 RAM 到内核虚拟地址空间的大映射；
	 * - 修正早期页表，仅保留/扩展成最终形态。
	 *
	 * 这一步之后，内核可以通过 __va/__pa 对几乎所有 RAM 访问。
	 */
	init_mem_mapping();

	/*
	 * 更新早期 IDT 中的 page fault (#PF) 处理入口，
	 * 适配新的内存映射/页表布局。
	 */
	idt_setup_early_pf();

	/*
	 * 将当前 CR4 值记录到 mmu_cr4_features 中，用作
	 * 后续 CR4 配置的“基线”。
	 *
	 * 同时屏蔽掉在 long mode 之外无效的特性（目前只屏蔽 PCIDE），
	 * 避免在实模式/保护模式阶段误用。
	 */
	mmu_cr4_features = __read_cr4() & ~X86_CR4_PCIDE;

	/*
	 * 将 memblock 当前分配上限更新为 get_max_mapped()，
	 * 即已经建立映射的最大物理地址，保证后续分配不会溢出映射。
	 */
	memblock_set_current_limit(get_max_mapped());

	/*
	 * NOTE: 对于 32 位，从这一步之后 fixmap 才真正可用。
	 * 64 位虽然 fixmap 更早就可用，但概念上也在这个阶段稳定下来。
	 */

#ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
	/*
	 * 早期初始化 OHCI1394（1394 控制器）的 DMA，
	 * 以避免早期 DMA 写到未加密/未映射区域。
	 */
	if (init_ohci1394_dma_early)
		init_ohci1394_dma_on_all_controllers();
#endif

	/*
	 * 将 log buffer 扩展为更大的缓冲区（相比 start_kernel 早期的 size=0），
	 * 以容纳更多启动日志。
	 */
	/* Allocate bigger log buffer */
	setup_log_buf(1);

	/*
	 * 打印 Secure Boot 状态：启用/禁用/未知。
	 */
	if (efi_enabled(EFI_BOOT)) {
		switch (boot_params.secure_boot) {
		case efi_secureboot_mode_disabled:
			pr_info("Secure boot disabled\n");
			break;
		case efi_secureboot_mode_enabled:
			pr_info("Secure boot enabled\n");
			break;
		default:
			pr_info("Secure boot could not be determined\n");
			break;
		}
	}

	/*
	 * 为 initrd 预留物理内存区域，防止被当成一般 RAM 使用。
	 */
	reserve_initrd();

	/*
	 * 如果在 initrd 中提供了 ACPI 表覆盖固件表，这里做替换。
	 */
	acpi_table_upgrade();

	/*
	 * 查找所有 ACPI 表，并预留它们占用的内存。
	 */
	/* Look for ACPI tables and reserve memory occupied by them. */
	acpi_boot_table_init();

	/*
	 * vsmp 相关初始化（虚拟 SMP/某些老平台特性）。
	 */
	vsmp_init();

	/*
	 * 初始化 I/O 延迟机制（io_delay），
	 * 可能会选择不同实现（port 0x80 / hpet 等）。
	 */
	io_delay_init();

	/*
	 * 提前处理一些平台特殊 quirks（比如早期 ACPI/PCI bug）。
	 */
	early_platform_quirks();

	/*
	 * 早期 ACPI 启动初始化，一些与 CPU/NUMA/中断布局相关的信息
	 * 会在此解析。
	 */
	early_acpi_boot_init();

	/*
	 * initmem 子系统初始化，建立 memory block 等抽象，创建初始化NUMA系统，pgdata等结构体，这里注意是只是初始化
	 * 为赋值，都是后面的事情
	 */
	initmem_init();

	/*
	 * 预留一块连续物理内存给 DMA CMA 使用。
	 * 该区域用于满足设备对“连续大块内存”的需求。
	 */
	dma_contiguous_reserve(max_pfn_mapped << PAGE_SHIFT);

	/*
	 * 如果 CPU 支持 GB pages（1G huge page），则从 CMA 中预留
	 * 一部分用于 hugetlb。
	 */
	if (boot_cpu_has(X86_FEATURE_GBPAGES))
		hugetlb_cma_reserve(PUD_SHIFT - PAGE_SHIFT);

	/*
	 * 根据 crashkernel= 参数为 crash kernel 预留内存。
	 * 这一步放在 SRAT 解析之后，以避免占用 hotpluggable 内存。
	 */
	/*
	 * Reserve memory for crash kernel after SRAT is parsed so that it
	 * won't consume hotpluggable memory.
	 */
	reserve_crashkernel();

	/*
	 * 找出 dma_reserve 区域（为 DMA 保留的一块内存），
	 * 通常用于满足 32bit 设备的 DMA 限制。
	 */
	memblock_find_dma_reserve();

	/*
	 * 早期 xDBC (USB 调试控制器) 初始化：
	 * 如果能成功初始化硬件，则注册一个 early console，
	 * 方便在非常早期阶段输出调试日志。
	 */
	if (!early_xdbc_setup_hardware())
		early_xdbc_register_console();

	/*
	 * 最终分页/页表初始化入口（通过 x86_init 回调）：
	 * - 建立完整的内核页表层级（包括 5-level，如 LA57）
	 * - 映射 vmalloc、vmemmap、fixmap 等区间
	 * - 应用 KASLR 随机化结果
	 */
	x86_init.paging.pagetable_init();

	/*
	 * KASAN (Kernel Address SANitizer) 初始化：
	 * - 建立 shadow memory 的映射
	 * - 准备地址检测机制
	 */
	kasan_init();

	/*
	 * 将 boot-time initial page table 的内核地址范围
	 * 同步回当前正式页表。
	 *
	 * FIXME 中提到：以后 setup_cpu_entry_areas() 里的同步
	 * 可能可以替代这里。
	 */
	/*
	 * Sync back kernel address range.
	 *
	 * FIXME: Can the later sync in setup_cpu_entry_areas() replace
	 * this call?
	 */
	sync_initial_page_table();

	/*
	 * tboot (Intel TXT secure loader) 探测，
	 * 如果存在则进行相应的安全初始化。
	 */
	tboot_probe();

	/*
	 * 映射 vsyscall 页（兼容老用户程序调用 __kernel_vsyscall），
	 * 在 x86_64 上主要用于兼容。
	 */
	map_vsyscall();

	/*
	 * 探测 APIC（local APIC/IO-APIC/x2APIC 等）。
	 */
	generic_apic_probe();

	/*
	 * 处理一些已知的早期硬件/固件 quirks。
	 */
	early_quirks();

	/*
	 * 从 ACPI 表中读取 APIC/NUMA/中断等信息，
	 * 完成 ACPI 层面的启动初始化。
	 */
	/*
	 * Read APIC and some other early information from ACPI tables.
	 */
	acpi_boot_init();

	/*
	 * 初始化 x86 的设备树 (dtb) 相关内容（在使用 DT 的平台）。
	 */
	x86_dtb_init();

	/*
	 * 读取 boot-time SMP 配置（APIC ID/CPU 拓扑等）。
	 */
	/*
	 * get boot-time SMP configuration:
	 */
	get_smp_config();

	/*
	 * 对于没有 ACPI/mptable 的系统，local APIC 映射可能还没建立，
	 * 但 prefill_possible_map() 可能会访问它，因此这里必须
	 * 确保 APIC 映射已经就绪。
	 */
	/*
	 * Systems w/o ACPI and mptables might not have it mapped the local
	 * APIC yet, but prefill_possible_map() might need to access it.
	 */
	init_apic_mappings();

	/*
	 * 预填 possible CPU map（哪些逻辑 CPU 可能存在），
	 * 后续 CPU bring-up 以此为基础。
	 */
	prefill_possible_map();

	/*
	 * 初始化 CPU 到 node 的映射（NUMA 拓扑），
	 * 以及 GI 节点信息。
	 */
	init_cpu_to_node();
	init_gi_nodes();

	/*
	 * 初始化 IO-APIC 映射。
	 */
	io_apic_init_mappings();

	/*
	 * 虚拟化环境下的 late_init 钩子，
	 * 比如 KVM/Hyper-V/VMware 进行后处理。
	 */
	x86_init.hyper.guest_late_init();

	/*
	 * 根据 e820 将各种物理资源区域（RAM/保留/设备）注册到
	 * iomem_resource 树中。
	 */
	e820__reserve_resources();

	/*
	 * 注册 hibernation 时不应该保存/恢复的区域（nosave 区域）。
	 */
	e820__register_nosave_regions(max_pfn);

	/*
	 * 由 arch 具体实现的资源预留工作。
	 */
	x86_init.resources.reserve_resources();

	/*
	 * 设置 PCI gap（通常在 3G~4G 之间的 MMIO 空洞），
	 * 供 PCI 设备 MMIO 映射使用。
	 */
	e820__setup_pci_gap();

#ifdef CONFIG_VT
#if defined(CONFIG_VGA_CONSOLE)
	/*
	 * 若不是 EFI 启动，或者 0xa0000 区域不是 EFI_CONVENTIONAL_MEMORY，
	 * 则启用 VGA 文本控制台。
	 */
	if (!efi_enabled(EFI_BOOT) || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
		conswitchp = &vga_con;
#endif
#endif

	/*
	 * OEM 自定义 banner 输出（比如打印厂商信息）。
	 */
	x86_init.oem.banner();

	/*
	 * 初始化实时时钟 (wallclock)，为后续时间基准提供支持。
	 */
	x86_init.timers.wallclock_init();

	/*
	 * therm_lvt_init 必须在 setup_local_APIC() 之前执行：
	 * - setup_local_APIC() 会短暂关闭 local APIC，
	 * - 这会屏蔽 thermal LVT 中断，
	 * 若此时有 SMI 交付配置，会导致软锁死。
	 */
	/*
	 * This needs to run before setup_local_APIC() which soft-disables the
	 * local APIC temporarily and that masks the thermal LVT interrupt,
	 * leading to softlockups on machines which have configured SMI
	 * interrupt delivery.
	 */
	therm_lvt_init();

	/*
	 * 初始化机器检查 (Machine Check) 机制 (MCE)。
	 */
	mcheck_init();

	/*
	 * 注册 refined_jiffies，基于 CLOCK_TICK_RATE 提供更精准
	 * 的 tick 值。
	 */
	register_refined_jiffies(CLOCK_TICK_RATE);

#ifdef CONFIG_EFI
	/*
	 * 根据 EFI 内存映射应用一些额外 quirks，
	 * 修正固件错误的 memmap。
	 */
	if (efi_enabled(EFI_BOOT))
		efi_apply_memmap_quirks();
#endif

	/*
	 * 初始化调用栈回溯 (unwind) 机制，
	 * 便于 oops/性能分析时打印准确的调用栈。
	 */
	unwind_init();
}

#ifdef CONFIG_X86_32

static struct resource video_ram_resource = {
	.name	= "Video RAM area",
	.start	= 0xa0000,
	.end	= 0xbffff,
	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
};

void __init i386_reserve_resources(void)
{
	request_resource(&iomem_resource, &video_ram_resource);
	reserve_standard_io_resources();
}

#endif /* CONFIG_X86_32 */

static struct notifier_block kernel_offset_notifier = {
	.notifier_call = dump_kernel_offset
};

static int __init register_kernel_offset_dumper(void)
{
	atomic_notifier_chain_register(&panic_notifier_list,
					&kernel_offset_notifier);
	return 0;
}
__initcall(register_kernel_offset_dumper);
