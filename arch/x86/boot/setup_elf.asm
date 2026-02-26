
setup.elf：     文件格式 elf32-i386


Disassembly of section .bstext:

00000000 <bootsect_start>:
   0:	4d                   	dec    %ebp
   1:	5a                   	pop    %edx
	# "MZ", MS-DOS header
	.word	MZ_MAGIC
#endif

	# Normalize the start address
	ljmp	$BOOTSEG, $start2
   2:	ea                   	.byte 0xea
   3:	07                   	pop    %es
   4:	00 c0                	add    %al,%al
   6:	07                   	pop    %es

00000007 <start2>:

start2:
	movw	%cs, %ax
   7:	8c c8                	mov    %cs,%eax
	movw	%ax, %ds
   9:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
   b:	8e c0                	mov    %eax,%es
	movw	%ax, %ss
   d:	8e d0                	mov    %eax,%ss
	xorw	%sp, %sp
   f:	31 e4                	xor    %esp,%esp
	sti
  11:	fb                   	sti    
	cld
  12:	fc                   	cld    

	movw	$bugger_off_msg, %si
  13:	be                   	.byte 0xbe
  14:	40                   	inc    %eax
	...

00000016 <msg_loop>:

msg_loop:
	lodsb
  16:	ac                   	lods   %ds:(%esi),%al
	andb	%al, %al
  17:	20 c0                	and    %al,%al
	jz	bs_die
  19:	74 09                	je     24 <bs_die>
	movb	$0xe, %ah
  1b:	b4 0e                	mov    $0xe,%ah
	movw	$7, %bx
  1d:	bb 07 00 cd 10       	mov    $0x10cd0007,%ebx
	int	$0x10
	jmp	msg_loop
  22:	eb f2                	jmp    16 <msg_loop>

00000024 <bs_die>:

bs_die:
	# Allow the user to press a key, then reboot
	xorw	%ax, %ax
  24:	31 c0                	xor    %eax,%eax
	int	$0x16
  26:	cd 16                	int    $0x16
	int	$0x19
  28:	cd 19                	int    $0x19

	# int 0x19 should never return.  In case it does anyway,
	# invoke the BIOS reset code...
	ljmp	$0xf000,$0xfff0
  2a:	ea f0 ff 00 f0 00 00 	ljmp   $0x0,$0xf000fff0
	...
  39:	00 00                	add    %al,(%eax)
  3b:	00                   	.byte 0x0
  3c:	82 00 00             	addb   $0x0,(%eax)
	...

Disassembly of section .entrytext:

0000026c <start_of_setup>:
# End of setup header #####################################################

	.section ".entrytext", "ax"
start_of_setup:
# Force %es = %ds
	movw	%ds, %ax
 26c:	8c d8                	mov    %ds,%eax
	movw	%ax, %es
 26e:	8e c0                	mov    %eax,%es
	cld
 270:	fc                   	cld    
# Apparently some ancient versions of LILO invoked the kernel with %ss != %ds,
# which happened to work by accident for the old code.  Recalculate the stack
# pointer if %ss is invalid.  Otherwise leave it alone, LOADLIN sets up the
# stack behind its own code, so we can't blindly put it directly past the heap.

	movw	%ss, %dx
 271:	8c d2                	mov    %ss,%edx
	cmpw	%ax, %dx	# %ds == %ss?
 273:	39 c2                	cmp    %eax,%edx
	movw	%sp, %dx
 275:	89 e2                	mov    %esp,%edx
	je	2f		# -> assume %sp is reasonably set
 277:	74 16                	je     28f <start_of_setup+0x23>

	# Invalid %ss, make up a new stack
	movw	$_end, %dx
 279:	ba 90 49 f6 06       	mov    $0x6f64990,%edx
	testb	$CAN_USE_HEAP, loadflags
 27e:	11 02                	adc    %eax,(%edx)
 280:	80 74 04 8b 16       	xorb   $0x16,-0x75(%esp,%eax,1)
	jz	1f
	movw	heap_end_ptr, %dx
 285:	24 02                	and    $0x2,%al
1:	addw	$STACK_SIZE, %dx
 287:	81 c2 00 04 73 02    	add    $0x2730400,%edx
	jnc	2f
	xorw	%dx, %dx	# Prevent wraparound
 28d:	31 d2                	xor    %edx,%edx

2:	# Now %dx should point to the end of our stack space
	andw	$~3, %dx	# dword align (might as well...)
 28f:	83 e2 fc             	and    $0xfffffffc,%edx
	jnz	3f
 292:	75 03                	jne    297 <start_of_setup+0x2b>
	movw	$0xfffc, %dx	# Make sure we're not zero
 294:	ba fc ff 8e d0       	mov    $0xd08efffc,%edx
3:	movw	%ax, %ss
	movzwl	%dx, %esp	# Clear upper half of %esp
 299:	66 0f b7 e2          	movzww %dx,%sp
	sti			# Now we should have a working stack
 29d:	fb                   	sti    

# We will have entered with %cs = %ds+0x20, normalize %cs so
# it is on par with the other segments.
	pushw	%ds
 29e:	1e                   	push   %ds
	pushw	$6f
 29f:	68 a3 02 cb 66       	push   $0x66cb02a3
	lretw
6:

# Check signature at end of setup
	cmpl	$0x5a5aaa55, setup_sig
 2a4:	81 3e 38 36 55 aa    	cmpl   $0xaa553638,(%esi)
 2aa:	5a                   	pop    %edx
 2ab:	5a                   	pop    %edx
	jne	setup_bad
 2ac:	75 17                	jne    2c5 <setup_bad>

# Zero the bss
	movw	$__bss_start, %di
 2ae:	bf 40 36 b9 93       	mov    $0x93b93640,%edi
	movw	$_end+3, %cx
 2b3:	49                   	dec    %ecx
	xorl	%eax, %eax
 2b4:	66 31 c0             	xor    %ax,%ax
	subw	%di, %cx
 2b7:	29 f9                	sub    %edi,%ecx
	shrw	$2, %cx
 2b9:	c1 e9 02             	shr    $0x2,%ecx
	rep; stosl
 2bc:	f3 66 ab             	rep stos %ax,%es:(%edi)

# Jump to C code (should not return)
	calll	main
 2bf:	66 e8 24 0d          	callw  fe7 <console_init+0x26f>
	...

000002c5 <setup_bad>:

# Setup corrupt somehow...
setup_bad:
	movl	$setup_corrupt, %eax
 2c5:	66 b8 d9 03          	mov    $0x3d9,%ax
 2c9:	00 00                	add    %al,(%eax)
	calll	puts
 2cb:	66 e8 ec 00          	callw  3bb <putchar+0x88>
	...

000002d1 <die>:
	# Fall through...

	.globl	die
	.type	die, @function
die:
	hlt
 2d1:	f4                   	hlt    
	jmp	die
 2d2:	eb fd                	jmp    2d1 <die>

Disassembly of section .inittext:

000002d4 <intcall>:
	.section ".inittext","ax"
	.globl	intcall
	.type	intcall, @function
intcall:
	/* Self-modify the INT instruction.  Ugly, but works. */
	cmpb	%al, 3f
 2d4:	38 06                	cmp    %al,(%esi)
 2d6:	ff 02                	incl   (%edx)
	je	1f
 2d8:	74 05                	je     2df <intcall+0xb>
	movb	%al, 3f
 2da:	a2 ff 02 eb 00       	mov    %al,0xeb02ff
	jmp	1f		/* Synchronize pipeline */
1:
	/* Save state */
	pushfl
 2df:	66 9c                	pushfw 
	pushw	%fs
 2e1:	0f a0                	push   %fs
	pushw	%gs
 2e3:	0f a8                	push   %gs
	pushal
 2e5:	66 60                	pushaw 

	/* Copy input state to stack frame */
	subw	$44, %sp
 2e7:	83 ec 2c             	sub    $0x2c,%esp
	movw	%dx, %si
 2ea:	89 d6                	mov    %edx,%esi
	movw	%sp, %di
 2ec:	89 e7                	mov    %esp,%edi
	movw	$11, %cx
 2ee:	b9 0b 00 f3 66       	mov    $0x66f3000b,%ecx
	rep; movsd
 2f3:	a5                   	movsl  %ds:(%esi),%es:(%edi)

	/* Pop full state from the stack */
	popal
 2f4:	66 61                	popaw  
	popw	%gs
 2f6:	0f a9                	pop    %gs
	popw	%fs
 2f8:	0f a1                	pop    %fs
	popw	%es
 2fa:	07                   	pop    %es
	popw	%ds
 2fb:	1f                   	pop    %ds
	popfl
 2fc:	66 9d                	popfw  
 2fe:	cd 00                	int    $0x0
	/* Actual INT */
	.byte	0xcd		/* INT opcode */
3:	.byte	0

	/* Push full state to the stack */
	pushfl
 300:	66 9c                	pushfw 
	pushw	%ds
 302:	1e                   	push   %ds
	pushw	%es
 303:	06                   	push   %es
	pushw	%fs
 304:	0f a0                	push   %fs
	pushw	%gs
 306:	0f a8                	push   %gs
	pushal
 308:	66 60                	pushaw 

	/* Re-establish C environment invariants */
	cld
 30a:	fc                   	cld    
	movzwl	%sp, %esp
 30b:	66 0f b7 e4          	movzww %sp,%sp
	movw	%cs, %ax
 30f:	8c c8                	mov    %cs,%eax
	movw	%ax, %ds
 311:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
 313:	8e c0                	mov    %eax,%es

	/* Copy output state from stack frame */
	movw	68(%esp), %di	/* Original %cx == 3rd argument */
 315:	67 8b 7c 24          	mov    0x24(%si),%edi
 319:	44                   	inc    %esp
	andw	%di, %di
 31a:	21 ff                	and    %edi,%edi
	jz	4f
 31c:	74 08                	je     326 <intcall+0x52>
	movw	%sp, %si
 31e:	89 e6                	mov    %esp,%esi
	movw	$11, %cx
 320:	b9 0b 00 f3 66       	mov    $0x66f3000b,%ecx
	rep; movsd
 325:	a5                   	movsl  %ds:(%esi),%es:(%edi)
4:	addw	$44, %sp
 326:	83 c4 2c             	add    $0x2c,%esp

	/* Restore state and return */
	popal
 329:	66 61                	popaw  
	popw	%gs
 32b:	0f a9                	pop    %gs
	popw	%fs
 32d:	0f a1                	pop    %fs
	popfl
 32f:	66 9d                	popfw  
	retl
 331:	66 c3                	retw   

00000333 <putchar>:
	ireg.al = ch;
	intcall(0x10, &ireg, NULL);
}

void __section(".inittext") putchar(int ch)
{
 333:	66 56                	push   %si
 335:	66 53                	push   %bx
 337:	66 83 ec 2c          	sub    $0x2c,%sp
 33b:	66 89 c3             	mov    %ax,%bx
	if (ch == '\n')
 33e:	66 83 f8 0a          	cmp    $0xa,%ax
 342:	75 0c                	jne    350 <putchar+0x1d>
		putchar('\r');	/* \n -> \r\n */
 344:	66 b8 0d 00          	mov    $0xd,%ax
 348:	00 00                	add    %al,(%eax)
 34a:	66 e8 e3 ff          	callw  331 <intcall+0x5d>
 34e:	ff                   	(bad)  
 34f:	ff 66 89             	jmp    *-0x77(%esi)
	initregs(&ireg);
 352:	e0 66                	loopne 3ba <putchar+0x87>
 354:	e8 55 17 00 00       	call   1aae <initregs>
	ireg.bx = 0x0007;
 359:	67 c7 44 24 10 07 00 	movl   $0x67000710,0x24(%si)
 360:	67 
	ireg.cx = 0x0001;
 361:	c7 44 24 18 01 00 67 	movl   $0xc6670001,0x18(%esp)
 368:	c6 
	ireg.ah = 0x0e;
 369:	44                   	inc    %esp
 36a:	24 1d                	and    $0x1d,%al
 36c:	0e                   	push   %cs
	ireg.al = ch;
 36d:	67 88 5c 24          	mov    %bl,0x24(%si)
 371:	1c 66                	sbb    $0x66,%al
	intcall(0x10, &ireg, NULL);
 373:	31 c9                	xor    %ecx,%ecx
 375:	66 89 e2             	mov    %sp,%dx
 378:	66 b8 10 00          	mov    $0x10,%ax
 37c:	00 00                	add    %al,(%eax)
 37e:	66 e8 50 ff          	callw  2d2 <die+0x1>
 382:	ff                   	(bad)  
 383:	ff 66 83             	jmp    *-0x7d(%esi)

	bios_putchar(ch);

	if (early_serial_base != 0)
 386:	3e 70 49             	jo,pt  3d2 <puts+0x15>
 389:	00 74 27 66          	add    %dh,0x66(%edi,%eiz,1)
 38d:	b9 ff ff 00 00       	mov    $0xffff,%ecx
	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
 392:	66 8b 16             	mov    (%esi),%dx
 395:	70 49                	jo     3e0 <setup_corrupt+0x7>
 397:	66 89 d6             	mov    %dx,%si
 39a:	66 83 c2 05          	add    $0x5,%dx
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
}
static inline u8 inb(u16 port)
{
	u8 v;
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
 39e:	ec                   	in     (%dx),%al
 39f:	a8 20                	test   $0x20,%al
 3a1:	74 08                	je     3ab <putchar+0x78>
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
 3a3:	88 d8                	mov    %bl,%al
 3a5:	66 89 f2             	mov    %si,%dx
 3a8:	ee                   	out    %al,(%dx)
}
 3a9:	eb 08                	jmp    3b3 <putchar+0x80>
	while ((inb(early_serial_base + LSR) & XMTRDY) == 0 && --timeout)
 3ab:	66 49                	dec    %cx
 3ad:	74 f4                	je     3a3 <putchar+0x70>
		cpu_relax();
 3af:	f3 90                	pause  
 3b1:	eb df                	jmp    392 <putchar+0x5f>
		serial_putchar(ch);
}
 3b3:	66 83 c4 2c          	add    $0x2c,%sp
 3b7:	66 5b                	pop    %bx
 3b9:	66 5e                	pop    %si
 3bb:	66 c3                	retw   

000003bd <puts>:

void __section(".inittext") puts(const char *str)
{
 3bd:	66 53                	push   %bx
 3bf:	66 89 c3             	mov    %ax,%bx
	while (*str)
 3c2:	67 66 0f be 03       	movsbw (%bp,%di),%ax
 3c7:	84 c0                	test   %al,%al
 3c9:	74 0a                	je     3d5 <puts+0x18>
		putchar(*str++);
 3cb:	66 43                	inc    %bx
 3cd:	66 e8 60 ff          	callw  331 <intcall+0x5d>
 3d1:	ff                   	(bad)  
 3d2:	ff                   	(bad)  
 3d3:	eb ed                	jmp    3c2 <puts+0x5>
}
 3d5:	66 5b                	pop    %bx
 3d7:	66 c3                	retw   

Disassembly of section .text:

000003f7 <empty_8042>:
{
	u8 status;
	int loops = MAX_8042_LOOPS;
	int ffs   = MAX_8042_FF;

	while (loops--) {
     3f7:	66 ba a1 86          	mov    $0x86a1,%dx
     3fb:	01 00                	add    %eax,(%eax)
	int ffs   = MAX_8042_FF;
     3fd:	66 b9 20 00          	mov    $0x20,%cx
     401:	00 00                	add    %al,(%eax)
	while (loops--) {
     403:	66 4a                	dec    %dx
     405:	74 21                	je     428 <empty_8042+0x31>
}

static inline void io_delay(void)
{
	const u16 DELAY_PORT = 0x80;
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
     407:	e6 80                	out    %al,$0x80
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     409:	e4 64                	in     $0x64,%al
		io_delay();

		status = inb(0x64);
		if (status == 0xff) {
     40b:	3c ff                	cmp    $0xff,%al
     40d:	75 06                	jne    415 <empty_8042+0x1e>
			/* FF is a plausible, but very unlikely status */
			if (!--ffs)
     40f:	66 49                	dec    %cx
     411:	75 06                	jne    419 <empty_8042+0x22>
     413:	eb 13                	jmp    428 <empty_8042+0x31>
				return -1; /* Assume no KBC present */
		}
		if (status & 1) {
     415:	a8 01                	test   $0x1,%al
     417:	74 06                	je     41f <empty_8042+0x28>
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
     419:	e6 80                	out    %al,$0x80
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     41b:	e4 60                	in     $0x60,%al
	return v;
     41d:	eb e4                	jmp    403 <empty_8042+0xc>
			/* Read and discard input data */
			io_delay();
			(void)inb(0x60);
		} else if (!(status & 2)) {
     41f:	a8 02                	test   $0x2,%al
     421:	75 e0                	jne    403 <empty_8042+0xc>
			/* Buffers empty, finished! */
			return 0;
     423:	66 31 c0             	xor    %ax,%ax
		}
	}

	return -1;
}
     426:	66 c3                	retw   
				return -1; /* Assume no KBC present */
     428:	66 83 c8 ff          	or     $0xffff,%ax
     42c:	66 c3                	retw   

0000042e <a20_test>:
#define A20_TEST_ADDR	(4*0x80)
#define A20_TEST_SHORT  32
#define A20_TEST_LONG	2097152	/* 2^21 */

static int a20_test(int loops)
{
     42e:	66 53                	push   %bx
	return seg;
}

static inline void set_fs(u16 seg)
{
	asm volatile("movw %0,%%fs" : : "rm" (seg));
     430:	66 31 d2             	xor    %dx,%dx
     433:	8e e2                	mov    %edx,%fs
	return seg;
}

static inline void set_gs(u16 seg)
{
	asm volatile("movw %0,%%gs" : : "rm" (seg));
     435:	66 83 ca ff          	or     $0xffff,%dx
     439:	8e ea                	mov    %edx,%gs
	return v;
}
static inline u32 rdfs32(addr_t addr)
{
	u32 v;
	asm volatile("movl %%fs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
     43b:	64 66 8b 1e          	mov    %fs:(%esi),%bx
     43f:	00 02                	add    %al,(%edx)
	int saved, ctr;

	set_fs(0x0000);
	set_gs(0xffff);

	saved = ctr = rdfs32(A20_TEST_ADDR);
     441:	66 89 da             	mov    %bx,%dx

	while (loops--) {
     444:	67 66 8d 0c          	lea    (%si),%cx
     448:	18 66 39             	sbb    %ah,0x39(%esi)
     44b:	ca 74 16             	lret   $0x1674
		wrfs32(++ctr, A20_TEST_ADDR);
     44e:	66 42                	inc    %dx
{
	asm volatile("movw %1,%%fs:%0" : "+m" (*(u16 *)addr) : "ri" (v));
}
static inline void wrfs32(u32 v, addr_t addr)
{
	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
     450:	64 66 89 16          	mov    %dx,%fs:(%esi)
     454:	00 02                	add    %al,(%edx)
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
     456:	e6 80                	out    %al,$0x80
	return v;
}
static inline u32 rdgs32(addr_t addr)
{
	u32 v;
	asm volatile("movl %%gs:%1,%0" : "=r" (v) : "m" (*(u32 *)addr));
     458:	65 66 a1 10 02 66 31 	mov    %gs:0x31660210,%ax
		io_delay();	/* Serialize and make delay constant */
		ok = rdgs32(A20_TEST_ADDR+0x10) ^ ctr;
		if (ok)
     45f:	d0 74 e7 eb          	shlb   -0x15(%edi,%eiz,8)
     463:	03 66 31             	add    0x31(%esi),%esp
     466:	c0 64 66 89 1e       	shlb   $0x1e,-0x77(%esi,%eiz,2)
	asm volatile("movl %1,%%fs:%0" : "+m" (*(u32 *)addr) : "ri" (v));
     46b:	00 02                	add    %al,(%edx)
			break;
	}

	wrfs32(saved, A20_TEST_ADDR);
	return ok;
}
     46d:	66 5b                	pop    %bx
     46f:	66 c3                	retw   

00000471 <enable_a20>:
 */

#define A20_ENABLE_LOOPS 255	/* Number of times to try */

int enable_a20(void)
{
     471:	66 56                	push   %si
     473:	66 53                	push   %bx
     475:	66 83 ec 2c          	sub    $0x2c,%sp
       int loops = A20_ENABLE_LOOPS;
       int kbc_err;

       while (loops--) {
     479:	66 bb 00 01          	mov    $0x100,%bx
     47d:	00 00                	add    %al,(%eax)
     47f:	66 4b                	dec    %bx
     481:	0f 84 c2 00 66 b8    	je     b8660549 <image_base+0xb7660549>
	return a20_test(A20_TEST_SHORT);
     487:	20 00                	and    %al,(%eax)
     489:	00 00                	add    %al,(%eax)
     48b:	66 e8 9d ff          	callw  42c <empty_8042+0x35>
     48f:	ff                   	(bad)  
     490:	ff 66 85             	jmp    *-0x7b(%esi)
	       /* First, check to see if A20 is already enabled
		  (legacy free, etc.) */
	       if (a20_test_short())
     493:	c0 74 06 66 31       	shlb   $0x31,0x66(%esi,%eax,1)
		       return 0;
     498:	c0 e9 af             	shr    $0xaf,%cl
     49b:	00 66 89             	add    %ah,-0x77(%esi)
	initregs(&ireg);
     49e:	e0 66                	loopne 506 <enable_a20+0x95>
     4a0:	e8 09 16 00 00       	call   1aae <initregs>
	ireg.ax = 0x2401;
     4a5:	67 c7 44 24 1c 01 24 	movl   $0x6624011c,0x24(%si)
     4ac:	66 
	intcall(0x15, &ireg, NULL);
     4ad:	31 c9                	xor    %ecx,%ecx
     4af:	66 89 e2             	mov    %sp,%dx
     4b2:	66 b8 15 00          	mov    $0x15,%ax
     4b6:	00 00                	add    %al,(%eax)
     4b8:	66 e8 16 fe          	callw  2d2 <die+0x1>
     4bc:	ff                   	(bad)  
     4bd:	ff 66 b8             	jmp    *-0x48(%esi)
	return a20_test(A20_TEST_SHORT);
     4c0:	20 00                	and    %al,(%eax)
     4c2:	00 00                	add    %al,(%eax)
     4c4:	66 e8 64 ff          	callw  42c <empty_8042+0x35>
     4c8:	ff                   	(bad)  
     4c9:	ff 66 85             	jmp    *-0x7b(%esi)
	       
	       /* Next, try the BIOS (INT 0x15, AX=0x2401) */
	       enable_a20_bios();
	       if (a20_test_short())
     4cc:	c0 75 c7 66          	shlb   $0x66,-0x39(%ebp)
		       return 0;
	       
	       /* Try enabling A20 through the keyboard controller */
	       kbc_err = empty_8042();
     4d0:	e8 22 ff ff ff       	call   3f7 <empty_8042>
     4d5:	66 89 c6             	mov    %ax,%si
	return a20_test(A20_TEST_SHORT);
     4d8:	66 b8 20 00          	mov    $0x20,%ax
     4dc:	00 00                	add    %al,(%eax)
     4de:	66 e8 4a ff          	callw  42c <empty_8042+0x35>
     4e2:	ff                   	(bad)  
     4e3:	ff 66 85             	jmp    *-0x7b(%esi)

	       if (a20_test_short())
     4e6:	c0 75 ad 66          	shlb   $0x66,-0x53(%ebp)
		       return 0; /* BIOS worked, but with delayed reaction */
	
	       if (!kbc_err) {
     4ea:	85 f6                	test   %esi,%esi
     4ec:	74 21                	je     50f <enable_a20+0x9e>
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     4ee:	e4 92                	in     $0x92,%al
	port_a &= ~0x01;	/* Do not reset machine */
     4f0:	66 83 e0 fe          	and    $0xfffe,%ax
     4f4:	66 83 c8 02          	or     $0x2,%ax
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
     4f8:	e6 92                	out    %al,$0x92
	return a20_test(A20_TEST_LONG);
     4fa:	66 b8 00 00          	mov    $0x0,%ax
     4fe:	20 00                	and    %al,(%eax)
     500:	66 e8 28 ff          	callw  42c <empty_8042+0x35>
     504:	ff                   	(bad)  
     505:	ff 66 85             	jmp    *-0x7b(%esi)
			       return 0;
	       }
	       
	       /* Finally, try enabling the "fast A20 gate" */
	       enable_a20_fast();
	       if (a20_test_long())
     508:	c0 0f 84             	rorb   $0x84,(%edi)
     50b:	72 ff                	jb     50c <enable_a20+0x9b>
     50d:	eb 87                	jmp    496 <enable_a20+0x25>
	empty_8042();
     50f:	66 e8 e2 fe          	callw  3f5 <setup_corrupt+0x1c>
     513:	ff                   	(bad)  
     514:	ff b0 d1 e6 64 66    	pushl  0x6664e6d1(%eax)
	empty_8042();
     51a:	e8 d8 fe ff ff       	call   3f7 <empty_8042>
     51f:	b0 df                	mov    $0xdf,%al
     521:	e6 60                	out    %al,$0x60
	empty_8042();
     523:	66 e8 ce fe          	callw  3f5 <setup_corrupt+0x1c>
     527:	ff                   	(bad)  
     528:	ff b0 ff e6 64 66    	pushl  0x6664e6ff(%eax)
	empty_8042();
     52e:	e8 c4 fe ff ff       	call   3f7 <empty_8042>
	return a20_test(A20_TEST_LONG);
     533:	66 b8 00 00          	mov    $0x0,%ax
     537:	20 00                	and    %al,(%eax)
     539:	66 e8 ef fe          	callw  42c <empty_8042+0x35>
     53d:	ff                   	(bad)  
     53e:	ff 66 85             	jmp    *-0x7b(%esi)
		       if (a20_test_long())
     541:	c0 74 aa e9 4f       	shlb   $0x4f,-0x17(%edx,%ebp,4)
     546:	ff 66 83             	jmp    *-0x7d(%esi)
		       return 0;
       }
       
       return -1;
     549:	c8 ff 66 83          	enter  $0x66ff,$0x83
}
     54d:	c4 2c 66             	les    (%esi,%eiz,2),%ebp
     550:	5b                   	pop    %ebx
     551:	66 5e                	pop    %si
     553:	66 c3                	retw   

00000555 <__cmdline_find_option>:
 *
 * Returns the length of the argument (regardless of if it was
 * truncated to fit in the buffer), or -1 on not found.
 */
int __cmdline_find_option(unsigned long cmdline_ptr, const char *option, char *buffer, int bufsize)
{
     555:	66 55                	push   %bp
     557:	66 57                	push   %di
     559:	66 56                	push   %si
     55b:	66 53                	push   %bx
     55d:	66 83 ec 08          	sub    $0x8,%sp
     561:	67 66 89 14          	mov    %dx,(%si)
     565:	24 66                	and    $0x66,%al
		st_wordskip,	/* Miscompare, skip */
		st_bufcpy	/* Copying this to buffer */
	} state = st_wordstart;

	if (!cmdline_ptr)
		return -1;      /* No command line */
     567:	83 cb ff             	or     $0xffffffff,%ebx
	if (!cmdline_ptr)
     56a:	66 85 c0             	test   %ax,%ax
     56d:	0f 84 d1 00 66 89    	je     89660644 <image_base+0x88660644>

	cptr = cmdline_ptr & 0xf;
     573:	c5 66 83             	lds    -0x7d(%esi),%esp
     576:	e5 0f                	in     $0xf,%eax
	set_fs(cmdline_ptr >> 4);
     578:	66 c1 e8 04          	shr    $0x4,%ax
	asm volatile("movw %0,%%fs" : : "rm" (seg));
     57c:	8e e0                	mov    %eax,%fs
	char *bufptr = buffer;
     57e:	66 89 ce             	mov    %cx,%si
	} state = st_wordstart;
     581:	66 31 c0             	xor    %ax,%ax
	const char *opptr = NULL;
     584:	66 31 ff             	xor    %di,%di
	int len = -1;
     587:	66 83 cb ff          	or     $0xffff,%bx

		case st_bufcpy:
			if (myisspace(c)) {
				state = st_wordstart;
			} else {
				if (len < bufsize-1)
     58b:	67 66 8b 54 24       	mov    0x24(%si),%dx
     590:	1c 66                	sbb    $0x66,%al
     592:	4a                   	dec    %edx
     593:	67 66 89 54 24       	mov    %dx,0x24(%si)
     598:	04 64                	add    $0x64,%al
	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
     59a:	67 8a 55 00          	mov    0x0(%di),%dl
	while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
     59e:	84 d2                	test   %dl,%dl
     5a0:	0f 84 91 00 66 83    	je     83660637 <image_base+0x82660637>
		switch (state) {
     5a6:	f8                   	clc    
     5a7:	02 74 50 66          	add    0x66(%eax,%edx,2),%dh
     5ab:	83 f8 03             	cmp    $0x3,%eax
     5ae:	74 51                	je     601 <__cmdline_find_option+0xac>
     5b0:	66 48                	dec    %ax
     5b2:	74 0a                	je     5be <__cmdline_find_option+0x69>
					*bufptr++ = c;
				len++;
			}
			break;
		}
	}
     5b4:	66 31 c0             	xor    %ax,%ax
			if (myisspace(c))
     5b7:	80 fa 20             	cmp    $0x20,%dl
     5ba:	76 6c                	jbe    628 <__cmdline_find_option+0xd3>
     5bc:	eb 07                	jmp    5c5 <__cmdline_find_option+0x70>
			if (c == '=' && !*opptr) {
     5be:	80 fa 3d             	cmp    $0x3d,%dl
     5c1:	75 19                	jne    5dc <__cmdline_find_option+0x87>
     5c3:	eb 0f                	jmp    5d4 <__cmdline_find_option+0x7f>
			opptr = option;
     5c5:	67 66 8b 04          	mov    (%si),%ax
     5c9:	24 80                	and    $0x80,%al
			if (c == '=' && !*opptr) {
     5cb:	fa                   	cli    
     5cc:	3d 75 18 67 66       	cmp    $0x66671875,%eax
			opptr = option;
     5d1:	8b 3c 24             	mov    (%esp),%edi
			if (c == '=' && !*opptr) {
     5d4:	67 80 3f 00          	cmpb   $0x0,(%bx)
     5d8:	74 3d                	je     617 <__cmdline_find_option+0xc2>
     5da:	eb 08                	jmp    5e4 <__cmdline_find_option+0x8f>
				state = st_wordstart;
     5dc:	66 31 c0             	xor    %ax,%ax
			} else if (myisspace(c)) {
     5df:	80 fa 20             	cmp    $0x20,%dl
     5e2:	76 44                	jbe    628 <__cmdline_find_option+0xd3>
     5e4:	66 89 f8             	mov    %di,%ax
			} else if (c != *opptr++) {
     5e7:	67 66 8d 78 01       	lea    0x1(%bx,%si),%di
				state = st_wordskip;
     5ec:	67 38 10             	cmp    %dl,(%bx,%si)
     5ef:	0f 95 c0             	setne  %al
     5f2:	66 0f b6 c0          	movzbw %al,%ax
     5f6:	66 40                	inc    %ax
     5f8:	eb 2e                	jmp    628 <__cmdline_find_option+0xd3>
			if (myisspace(c))
     5fa:	80 fa 20             	cmp    $0x20,%dl
     5fd:	77 29                	ja     628 <__cmdline_find_option+0xd3>
     5ff:	eb 24                	jmp    625 <__cmdline_find_option+0xd0>
			if (myisspace(c)) {
     601:	80 fa 20             	cmp    $0x20,%dl
     604:	76 1f                	jbe    625 <__cmdline_find_option+0xd0>
				if (len < bufsize-1)
     606:	67 66 39 5c 24       	cmp    %bx,0x24(%si)
     60b:	04 7e                	add    $0x7e,%al
     60d:	05 67 88 16 66       	add    $0x66168867,%eax
					*bufptr++ = c;
     612:	46                   	inc    %esi
				len++;
     613:	66 43                	inc    %bx
     615:	eb 11                	jmp    628 <__cmdline_find_option+0xd3>
				bufptr = buffer;
     617:	66 89 ce             	mov    %cx,%si
				state = st_bufcpy;
     61a:	66 b8 03 00          	mov    $0x3,%ax
     61e:	00 00                	add    %al,(%eax)
				len = 0;
     620:	66 31 db             	xor    %bx,%bx
     623:	eb 03                	jmp    628 <__cmdline_find_option+0xd3>
				state = st_wordstart;
     625:	66 31 c0             	xor    %ax,%ax
	while (cptr < 0x10000 && (c = rdfs8(cptr++))) {
     628:	66 45                	inc    %bp
     62a:	66 81 fd 00 00       	cmp    $0x0,%bp
     62f:	01 00                	add    %eax,(%eax)
     631:	0f 85 64 ff 67 66    	jne    6668059b <image_base+0x6568059b>

	if (bufsize)
     637:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     63c:	74 04                	je     642 <__cmdline_find_option+0xed>
		*bufptr = '\0';
     63e:	67 c6 06 00 66 89    	movb   $0x89,0x6600

	return len;
}
     644:	d8 66 83             	fsubs  -0x7d(%esi)
     647:	c4 08                	les    (%eax),%ecx
     649:	66 5b                	pop    %bx
     64b:	66 5e                	pop    %si
     64d:	66 5f                	pop    %di
     64f:	66 5d                	pop    %bp
     651:	66 c3                	retw   

00000653 <__cmdline_find_option_bool>:
		st_wordstart,	/* Start of word/after whitespace */
		st_wordcmp,	/* Comparing this word */
		st_wordskip,	/* Miscompare, skip */
	} state = st_wordstart;

	if (!cmdline_ptr)
     653:	66 85 c0             	test   %ax,%ax
     656:	0f 84 89 00 66 55    	je     556606e5 <image_base+0x546606e5>
{
     65c:	66 57                	push   %di
     65e:	66 56                	push   %si
     660:	66 53                	push   %bx
     662:	66 89 d7             	mov    %dx,%di
		return -1;      /* No command line */

	cptr = cmdline_ptr & 0xf;
     665:	66 89 c5             	mov    %ax,%bp
     668:	66 83 e5 0f          	and    $0xf,%bp
	set_fs(cmdline_ptr >> 4);
     66c:	66 c1 e8 04          	shr    $0x4,%ax
	asm volatile("movw %0,%%fs" : : "rm" (seg));
     670:	8e e0                	mov    %eax,%fs
	} state = st_wordstart;
     672:	66 31 d2             	xor    %dx,%dx
	const char *opptr = NULL;
     675:	66 31 f6             	xor    %si,%si
	int pos = 0, wstart = 0;
     678:	66 31 c0             	xor    %ax,%ax
     67b:	66 31 db             	xor    %bx,%bx
	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
     67e:	64 67 8a 0c          	mov    %fs:(%si),%cl
     682:	2b 66 43             	sub    0x43(%esi),%esp

	while (cptr < 0x10000) {
		c = rdfs8(cptr++);
		pos++;

		switch (state) {
     685:	66 83 fa 01          	cmp    $0x1,%dx
     689:	74 15                	je     6a0 <__cmdline_find_option_bool+0x4d>
     68b:	66 83 fa 02          	cmp    $0x2,%dx
     68f:	74 36                	je     6c7 <__cmdline_find_option_bool+0x74>
		case st_wordstart:
			if (!c)
     691:	84 c9                	test   %cl,%cl
     693:	74 54                	je     6e9 <__cmdline_find_option_bool+0x96>
				return 0;
			else if (myisspace(c))
     695:	80 f9 20             	cmp    $0x20,%cl
     698:	76 36                	jbe    6d0 <__cmdline_find_option_bool+0x7d>
				break;

			state = st_wordcmp;
			opptr = option;
     69a:	66 89 fe             	mov    %di,%si
			wstart = pos;
     69d:	66 89 d8             	mov    %bx,%ax
			fallthrough;

		case st_wordcmp:
			if (!*opptr)
     6a0:	67 8a 16 84 d2       	mov    -0x2d7c,%dl
     6a5:	75 0d                	jne    6b4 <__cmdline_find_option_bool+0x61>
				if (!c || myisspace(c))
     6a7:	80 f9 20             	cmp    $0x20,%cl
     6aa:	76 40                	jbe    6ec <__cmdline_find_option_bool+0x99>
					return wstart;
				else
					state = st_wordskip;
     6ac:	66 ba 02 00          	mov    $0x2,%dx
     6b0:	00 00                	add    %al,(%eax)
     6b2:	eb 1f                	jmp    6d3 <__cmdline_find_option_bool+0x80>
			else if (!c)
     6b4:	84 c9                	test   %cl,%cl
     6b6:	74 31                	je     6e9 <__cmdline_find_option_bool+0x96>
				return 0;
			else if (c != *opptr++)
     6b8:	66 46                	inc    %si
				state = st_wordskip;
     6ba:	38 ca                	cmp    %cl,%dl
     6bc:	0f 95 c2             	setne  %dl
     6bf:	66 0f b6 d2          	movzbw %dl,%dx
     6c3:	66 42                	inc    %dx
     6c5:	eb 0c                	jmp    6d3 <__cmdline_find_option_bool+0x80>
			break;

		case st_wordskip:
			if (!c)
     6c7:	84 c9                	test   %cl,%cl
     6c9:	74 1e                	je     6e9 <__cmdline_find_option_bool+0x96>
				return 0;
			else if (myisspace(c))
     6cb:	80 f9 20             	cmp    $0x20,%cl
     6ce:	77 03                	ja     6d3 <__cmdline_find_option_bool+0x80>
				state = st_wordstart;
			break;
		}
	}
     6d0:	66 31 d2             	xor    %dx,%dx
	while (cptr < 0x10000) {
     6d3:	67 66 8d 0c          	lea    (%si),%cx
     6d7:	2b 66 81             	sub    -0x7f(%esi),%esp
     6da:	f9                   	stc    
     6db:	ff                   	(bad)  
     6dc:	ff 00                	incl   (%eax)
     6de:	00 76 9d             	add    %dh,-0x63(%esi)
     6e1:	eb 06                	jmp    6e9 <__cmdline_find_option_bool+0x96>
		return -1;      /* No command line */
     6e3:	66 83 c8 ff          	or     $0xffff,%ax

	return 0;	/* Buffer overrun */
}
     6e7:	66 c3                	retw   
				return 0;
     6e9:	66 31 c0             	xor    %ax,%ax
}
     6ec:	66 5b                	pop    %bx
     6ee:	66 5e                	pop    %si
     6f0:	66 5f                	pop    %di
     6f2:	66 5d                	pop    %bp
     6f4:	66 c3                	retw   

000006f6 <memcpy>:

	.code16
	.text

SYM_FUNC_START_NOALIGN(memcpy)
	pushw	%si
     6f6:	56                   	push   %esi
	pushw	%di
     6f7:	57                   	push   %edi
	movw	%ax, %di
     6f8:	89 c7                	mov    %eax,%edi
	movw	%dx, %si
     6fa:	89 d6                	mov    %edx,%esi
	pushw	%cx
     6fc:	51                   	push   %ecx
	shrw	$2, %cx
     6fd:	c1 e9 02             	shr    $0x2,%ecx
	rep; movsl
     700:	f3 66 a5             	rep movsw %ds:(%esi),%es:(%edi)
	popw	%cx
     703:	59                   	pop    %ecx
	andw	$3, %cx
     704:	83 e1 03             	and    $0x3,%ecx
	rep; movsb
     707:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	popw	%di
     709:	5f                   	pop    %edi
	popw	%si
     70a:	5e                   	pop    %esi
	retl
     70b:	66 c3                	retw   

0000070d <memset>:
SYM_FUNC_END(memcpy)

SYM_FUNC_START_NOALIGN(memset)
	pushw	%di
     70d:	57                   	push   %edi
	movw	%ax, %di
     70e:	89 c7                	mov    %eax,%edi
	movzbl	%dl, %eax
     710:	66 0f b6 c2          	movzbw %dl,%ax
	imull	$0x01010101,%eax
     714:	66 69 c0 01 01       	imul   $0x101,%ax,%ax
     719:	01 01                	add    %eax,(%ecx)
	pushw	%cx
     71b:	51                   	push   %ecx
	shrw	$2, %cx
     71c:	c1 e9 02             	shr    $0x2,%ecx
	rep; stosl
     71f:	f3 66 ab             	rep stos %ax,%es:(%edi)
	popw	%cx
     722:	59                   	pop    %ecx
	andw	$3, %cx
     723:	83 e1 03             	and    $0x3,%ecx
	rep; stosb
     726:	f3 aa                	rep stos %al,%es:(%edi)
	popw	%di
     728:	5f                   	pop    %edi
	retl
     729:	66 c3                	retw   

0000072b <copy_from_fs>:
SYM_FUNC_END(memset)

SYM_FUNC_START_NOALIGN(copy_from_fs)
	pushw	%ds
     72b:	1e                   	push   %ds
	pushw	%fs
     72c:	0f a0                	push   %fs
	popw	%ds
     72e:	1f                   	pop    %ds
	calll	memcpy
     72f:	66 e8 c1 ff          	callw  6f4 <__cmdline_find_option_bool+0xa1>
     733:	ff                   	(bad)  
     734:	ff 1f                	lcall  *(%edi)
	popw	%ds
	retl
     736:	66 c3                	retw   

00000738 <copy_to_fs>:
SYM_FUNC_END(copy_from_fs)

SYM_FUNC_START_NOALIGN(copy_to_fs)
	pushw	%es
     738:	06                   	push   %es
	pushw	%fs
     739:	0f a0                	push   %fs
	popw	%es
     73b:	07                   	pop    %es
	calll	memcpy
     73c:	66 e8 b4 ff          	callw  6f4 <__cmdline_find_option_bool+0xa1>
     740:	ff                   	(bad)  
     741:	ff 07                	incl   (%edi)
	popw	%es
	retl
     743:	66 c3                	retw   

00000745 <validate_cpu>:
	}
#endif
}

int validate_cpu(void)
{
     745:	66 55                	push   %bp
     747:	66 57                	push   %di
     749:	66 56                	push   %si
     74b:	66 53                	push   %bx
     74d:	66 83 ec 10          	sub    $0x10,%sp
	u32 *err_flags;
	int cpu_level, req_level;

	check_cpu(&cpu_level, &req_level, &err_flags);
     751:	67 66 8d 4c 24       	lea    0x24(%si),%cx
     756:	04 67                	add    $0x67,%al
     758:	66 8d 54 24 0c       	lea    0xc(%esp),%dx
     75d:	67 66 8d 44 24       	lea    0x24(%si),%ax
     762:	08 66 e8             	or     %ah,-0x18(%esi)
     765:	47                   	inc    %edi
     766:	03 00                	add    (%eax),%eax
     768:	00 67 66             	add    %ah,0x66(%edi)

	if (cpu_level < req_level) {
     76b:	8b 44 24 0c          	mov    0xc(%esp),%eax
     76f:	67 66 39 44 24       	cmp    %ax,0x24(%si)
     774:	08 0f                	or     %cl,(%edi)
     776:	8d 99 00 66 ba 40    	lea    0x40ba6600(%ecx),%ebx
		return "x86-64";
     77c:	30 00                	xor    %al,(%eax)
     77e:	00 66 83             	add    %ah,-0x7d(%esi)
	if (level == 64) {
     781:	f8                   	clc    
     782:	40                   	inc    %eax
     783:	74 2a                	je     7af <validate_cpu+0x6a>
		if (level == 15)
     785:	66 83 f8 0f          	cmp    $0xf,%ax
     789:	75 06                	jne    791 <validate_cpu+0x4c>
			level = 6;
     78b:	66 b8 06 00          	mov    $0x6,%ax
     78f:	00 00                	add    %al,(%eax)
		sprintf(buf, "i%d86", level);
     791:	66 50                	push   %ax
     793:	66 68 47 30          	pushw  $0x3047
     797:	00 00                	add    %al,(%eax)
     799:	66 68 40 36          	pushw  $0x3640
     79d:	00 00                	add    %al,(%eax)
     79f:	66 e8 b1 12          	callw  1a54 <vsprintf+0x443>
     7a3:	00 00                	add    %al,(%eax)
     7a5:	66 83 c4 0c          	add    $0xc,%sp
     7a9:	66 ba 40 36          	mov    $0x3640,%dx
     7ad:	00 00                	add    %al,(%eax)
		printf("This kernel requires an %s CPU, ",
     7af:	66 52                	push   %dx
     7b1:	66 68 4d 30          	pushw  $0x304d
     7b5:	00 00                	add    %al,(%eax)
     7b7:	66 e8 b3 12          	callw  1a6e <sprintf+0x18>
     7bb:	00 00                	add    %al,(%eax)
		       cpu_name(req_level));
		printf("but only detected an %s CPU.\n",
     7bd:	67 66 8b 44 24       	mov    0x24(%si),%ax
     7c2:	10 66 5e             	adc    %ah,0x5e(%esi)
	if (level == 64) {
     7c5:	66 5f                	pop    %di
		return "x86-64";
     7c7:	66 ba 40 30          	mov    $0x3040,%dx
     7cb:	00 00                	add    %al,(%eax)
	if (level == 64) {
     7cd:	66 83 f8 40          	cmp    $0x40,%ax
     7d1:	74 2a                	je     7fd <BOOTSEG+0x3d>
		if (level == 15)
     7d3:	66 83 f8 0f          	cmp    $0xf,%ax
     7d7:	75 06                	jne    7df <BOOTSEG+0x1f>
			level = 6;
     7d9:	66 b8 06 00          	mov    $0x6,%ax
     7dd:	00 00                	add    %al,(%eax)
		sprintf(buf, "i%d86", level);
     7df:	66 50                	push   %ax
     7e1:	66 68 47 30          	pushw  $0x3047
     7e5:	00 00                	add    %al,(%eax)
     7e7:	66 68 40 36          	pushw  $0x3640
     7eb:	00 00                	add    %al,(%eax)
     7ed:	66 e8 63 12          	callw  1a54 <vsprintf+0x443>
     7f1:	00 00                	add    %al,(%eax)
     7f3:	66 83 c4 0c          	add    $0xc,%sp
     7f7:	66 ba 40 36          	mov    $0x3640,%dx
     7fb:	00 00                	add    %al,(%eax)
		printf("but only detected an %s CPU.\n",
     7fd:	66 52                	push   %dx
     7ff:	66 68 6e 30          	pushw  $0x306e
     803:	00 00                	add    %al,(%eax)
     805:	66 e8 65 12          	callw  1a6e <sprintf+0x18>
     809:	00 00                	add    %al,(%eax)
		       cpu_name(cpu_level));
		return -1;
     80b:	66 59                	pop    %cx
     80d:	66 5b                	pop    %bx
     80f:	e9 d1 00 67 66       	jmp    666708e5 <image_base+0x656708e5>
	}

	if (err_flags) {
     814:	83 7c 24 04 00       	cmpl   $0x0,0x4(%esp)
     819:	0f 84 cc 00 66 b8    	je     b86608eb <image_base+0xb76608eb>
		puts("This kernel requires the following features "
     81f:	8c 30                	mov    %?,(%eax)
     821:	00 00                	add    %al,(%eax)
     823:	66 e8 94 fb          	callw  3bb <putchar+0x88>
     827:	ff                   	(bad)  
     828:	ff 67 66             	jmp    *0x66(%edi)
		     "not present on the CPU:\n");
		show_cap_strs(err_flags);
     82b:	8b 44 24 04          	mov    0x4(%esp),%eax
     82f:	67 66 89 04          	mov    %ax,(%si)
     833:	24 66                	and    $0x66,%al
	const unsigned char *msg_strs = (const unsigned char *)x86_cap_strs;
     835:	bb e0 30 00 00       	mov    $0x30e0,%ebx
	for (i = 0; i < NCAPINTS; i++) {
     83a:	66 31 f6             	xor    %si,%si
		u32 e = err_flags[i];
     83d:	67 66 8b 04          	mov    (%si),%ax
     841:	24 67                	and    $0x67,%al
     843:	66 8b 3c b0          	mov    (%eax,%esi,4),%di
		for (j = 0; j < 32; j++) {
     847:	66 31 ed             	xor    %bp,%bp
			if (msg_strs[0] < i ||
     84a:	67 66 0f b6 03       	movzbw (%bp,%di),%ax
     84f:	66 39 f0             	cmp    %si,%ax
     852:	7c 0d                	jl     861 <BOOTSEG+0xa1>
     854:	75 18                	jne    86e <BOOTSEG+0xae>
			    (msg_strs[0] == i && msg_strs[1] < j)) {
     856:	67 66 0f b6 43 01    	movzbw 0x1(%bp,%di),%ax
     85c:	66 39 e8             	cmp    %bp,%ax
     85f:	7d 0d                	jge    86e <BOOTSEG+0xae>
				msg_strs += 2;
     861:	66 83 c3 02          	add    $0x2,%bx
				while (*msg_strs++)
     865:	66 43                	inc    %bx
     867:	67 80 7b ff 00       	cmpb   $0x0,-0x1(%bp,%di)
     86c:	75 f7                	jne    865 <BOOTSEG+0xa5>
			if (e & 1) {
     86e:	66 f7 c7 01 00       	test   $0x1,%di
     873:	00 00                	add    %al,(%eax)
     875:	74 49                	je     8c0 <BOOTSEG+0x100>
				if (msg_strs[0] == i &&
     877:	67 66 0f b6 03       	movzbw (%bp,%di),%ax
     87c:	66 39 f0             	cmp    %si,%ax
     87f:	75 2b                	jne    8ac <BOOTSEG+0xec>
				    msg_strs[1] == j &&
     881:	67 66 0f b6 43 01    	movzbw 0x1(%bp,%di),%ax
				if (msg_strs[0] == i &&
     887:	66 39 e8             	cmp    %bp,%ax
     88a:	75 20                	jne    8ac <BOOTSEG+0xec>
				    msg_strs[1] == j &&
     88c:	67 80 7b 02 00       	cmpb   $0x0,0x2(%bp,%di)
     891:	74 19                	je     8ac <BOOTSEG+0xec>
					printf("%s ", msg_strs+2);
     893:	67 66 8d 43 02       	lea    0x2(%bp,%di),%ax
     898:	66 50                	push   %ax
     89a:	66 68 d1 30          	pushw  $0x30d1
     89e:	00 00                	add    %al,(%eax)
     8a0:	66 e8 ca 11          	callw  1a6e <sprintf+0x18>
     8a4:	00 00                	add    %al,(%eax)
     8a6:	66 58                	pop    %ax
     8a8:	66 5a                	pop    %dx
     8aa:	eb 14                	jmp    8c0 <BOOTSEG+0x100>
					printf("%d:%d ", i, j);
     8ac:	66 55                	push   %bp
     8ae:	66 56                	push   %si
     8b0:	66 68 d5 30          	pushw  $0x30d5
     8b4:	00 00                	add    %al,(%eax)
     8b6:	66 e8 b4 11          	callw  1a6e <sprintf+0x18>
     8ba:	00 00                	add    %al,(%eax)
     8bc:	66 83 c4 0c          	add    $0xc,%sp
			e >>= 1;
     8c0:	66 d1 ef             	shr    %di
		for (j = 0; j < 32; j++) {
     8c3:	66 45                	inc    %bp
     8c5:	66 83 fd 20          	cmp    $0x20,%bp
     8c9:	0f 85 7d ff 66 46    	jne    4667084c <image_base+0x4567084c>
	for (i = 0; i < NCAPINTS; i++) {
     8cf:	66 83 fe 14          	cmp    $0x14,%si
     8d3:	0f 85 66 ff 66 b8    	jne    b867083f <image_base+0xb767083f>
		putchar('\n');
     8d9:	0a 00                	or     (%eax),%al
     8db:	00 00                	add    %al,(%eax)
     8dd:	66 e8 50 fa          	callw  331 <intcall+0x5d>
     8e1:	ff                   	(bad)  
     8e2:	ff 66 83             	jmp    *-0x7d(%esi)
		return -1;
     8e5:	c8 ff eb 13          	enter  $0xebff,$0x13
	} else if (check_knl_erratum()) {
     8e9:	66 e8 05 04          	callw  cf2 <check_cpu+0x242>
     8ed:	00 00                	add    %al,(%eax)
     8ef:	66 85 c0             	test   %ax,%ax
     8f2:	0f 95 c0             	setne  %al
     8f5:	66 0f b6 c0          	movzbw %al,%ax
     8f9:	66 f7 d8             	neg    %ax
		return -1;
	} else {
		return 0;
	}
}
     8fc:	66 83 c4 10          	add    $0x10,%sp
     900:	66 5b                	pop    %bx
     902:	66 5e                	pop    %si
     904:	66 5f                	pop    %di
     906:	66 5d                	pop    %bp
     908:	66 c3                	retw   

0000090a <has_eflag>:

int has_eflag(unsigned long mask)
{
	unsigned long f0, f1;

	asm volatile(PUSHF "	\n\t"
     90a:	66 9c                	pushfw 
     90c:	66 9c                	pushfw 
     90e:	66 5a                	pop    %dx
     910:	66 89 d1             	mov    %dx,%cx
     913:	66 31 c1             	xor    %ax,%cx
     916:	66 51                	push   %cx
     918:	66 9d                	popfw  
     91a:	66 9c                	pushfw 
     91c:	66 59                	pop    %cx
     91e:	66 9d                	popfw  
		     "pop %1	\n\t"
		     POPF
		     : "=&r" (f0), "=&r" (f1)
		     : "ri" (mask));

	return !!((f0^f1) & mask);
     920:	66 31 ca             	xor    %cx,%dx
     923:	66 85 c2             	test   %ax,%dx
     926:	0f 95 c0             	setne  %al
     929:	66 0f b6 c0          	movzbw %al,%ax
}
     92d:	66 c3                	retw   

0000092f <get_cpuflags>:
{
	u32 max_intel_level, max_amd_level;
	u32 tfms;
	u32 ignored;

	if (loaded_flags)
     92f:	80 3e 46             	cmpb   $0x46,(%esi)
     932:	36 00 0f             	add    %cl,%ss:(%edi)
     935:	85 30                	test   %esi,(%eax)
     937:	01 66 57             	add    %esp,0x57(%esi)
{
     93a:	66 56                	push   %si
     93c:	66 53                	push   %bx
     93e:	66 52                	push   %dx
		return;
	loaded_flags = true;
     940:	c6 06 46             	movb   $0x46,(%esi)
     943:	36 01 67 c7          	add    %esp,%ss:-0x39(%edi)
	u16 fcw = -1, fsw = -1;
     947:	04 24                	add    $0x24,%al
     949:	ff                   	(bad)  
     94a:	ff 67 c7             	jmp    *-0x39(%edi)
     94d:	44                   	inc    %esp
     94e:	24 02                	and    $0x2,%al
     950:	ff                   	(bad)  
     951:	ff 0f                	decl   (%edi)
	asm volatile("mov %%cr0,%0" : "=r" (cr0));
     953:	20 c0                	and    %al,%al
	if (cr0 & (X86_CR0_EM|X86_CR0_TS)) {
     955:	a8 0c                	test   $0xc,%al
     957:	74 07                	je     960 <get_cpuflags+0x31>
		cr0 &= ~(X86_CR0_EM|X86_CR0_TS);
     959:	66 83 e0 f3          	and    $0xfff3,%ax
		asm volatile("mov %0,%%cr0" : : "r" (cr0));
     95d:	0f 22 c0             	mov    %eax,%cr0
	asm volatile("fninit ; fnstsw %0 ; fnstcw %1"
     960:	db e3                	fninit 
     962:	67 dd 7c 24          	fnstsw 0x24(%si)
     966:	02 67 d9             	add    -0x27(%edi),%ah
     969:	3c 24                	cmp    $0x24,%al
	return fsw == 0 && (fcw & 0x103f) == 0x003f;
     96b:	67 83 7c 24 02       	cmpl   $0x2,0x24(%si)
     970:	00 75 14             	add    %dh,0x14(%ebp)
     973:	67 66 8b 04          	mov    (%si),%ax
     977:	24 25                	and    $0x25,%al
     979:	3f                   	aas    
     97a:	10 83 f8 3f 75 07    	adc    %al,0x7753ff8(%ebx)
 constant_test_bit((nr),(addr)) : \
 variable_test_bit((nr),(addr)))

static inline void set_bit(int nr, void *addr)
{
	asm("btsl %1,%0" : "+m" (*(u32 *)addr) : "Ir" (nr));
     980:	66 0f ba 2e 0c       	btsw   $0xc,(%esi)
     985:	39 00                	cmp    %eax,(%eax)

	if (has_fpu())
		set_bit(X86_FEATURE_FPU, cpu.flags);

	if (has_eflag(X86_EFLAGS_ID)) {
     987:	66 b8 00 00          	mov    $0x0,%ax
     98b:	20 00                	and    %al,(%eax)
     98d:	66 e8 77 ff          	callw  908 <BOOTSEG+0x148>
     991:	ff                   	(bad)  
     992:	ff 66 85             	jmp    *-0x7b(%esi)
     995:	c0 0f 84             	rorb   $0x84,(%edi)
     998:	c4 00                	les    (%eax),%eax
	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
     99a:	66 31 f6             	xor    %si,%si
     99d:	66 89 f0             	mov    %si,%ax
     9a0:	66 89 f1             	mov    %si,%cx
     9a3:	0f a2                	cpuid  
     9a5:	66 89 c7             	mov    %ax,%di
     9a8:	66 89 0e             	mov    %cx,(%esi)
     9ab:	64 39 66 89          	cmp    %esp,%fs:-0x77(%esi)
     9af:	16                   	push   %ss
     9b0:	60                   	pusha  
     9b1:	39 66 89             	cmp    %esp,-0x77(%esi)
     9b4:	1e                   	push   %ds
     9b5:	5c                   	pop    %esp
     9b6:	39 67 66             	cmp    %esp,0x66(%edi)
		cpuid(0x0, &max_intel_level, &cpu_vendor[0], &cpu_vendor[2],
		      &cpu_vendor[1]);

		if (max_intel_level >= 0x00000001 &&
     9b9:	8d 40 ff             	lea    -0x1(%eax),%eax
     9bc:	66 3d fe ff          	cmp    $0xfffe,%ax
     9c0:	00 00                	add    %al,(%eax)
     9c2:	77 53                	ja     a17 <get_cpuflags+0xe8>
	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
     9c4:	66 b8 01 00          	mov    $0x1,%ax
     9c8:	00 00                	add    %al,(%eax)
     9ca:	66 89 f1             	mov    %si,%cx
     9cd:	0f a2                	cpuid  
     9cf:	66 89 0e             	mov    %cx,(%esi)
     9d2:	1c 39                	sbb    $0x39,%al
     9d4:	66 89 16             	mov    %dx,(%esi)
     9d7:	0c 39                	or     $0x39,%al
		    max_intel_level <= 0x0000ffff) {
			cpuid(0x1, &tfms, &ignored, &cpu.flags[4],
			      &cpu.flags[0]);
			cpu.level = (tfms >> 8) & 15;
     9d9:	66 89 c2             	mov    %ax,%dx
     9dc:	66 c1 ea 08          	shr    $0x8,%dx
     9e0:	66 83 e2 0f          	and    $0xf,%dx
     9e4:	66 89 16             	mov    %dx,(%esi)
     9e7:	00 39                	add    %bh,(%ecx)
			cpu.family = cpu.level;
     9e9:	66 89 16             	mov    %dx,(%esi)
     9ec:	04 39                	add    $0x39,%al
			cpu.model = (tfms >> 4) & 15;
     9ee:	66 89 c6             	mov    %ax,%si
     9f1:	66 c1 ee 04          	shr    $0x4,%si
     9f5:	66 83 e6 0f          	and    $0xf,%si
			if (cpu.level >= 6)
     9f9:	66 83 fa 05          	cmp    $0x5,%dx
     9fd:	7f 07                	jg     a06 <get_cpuflags+0xd7>
			cpu.model = (tfms >> 4) & 15;
     9ff:	66 89 36             	mov    %si,(%esi)
     a02:	08 39                	or     %bh,(%ecx)
     a04:	eb 11                	jmp    a17 <get_cpuflags+0xe8>
				cpu.model += ((tfms >> 16) & 0xf) << 4;
     a06:	66 c1 e8 0c          	shr    $0xc,%ax
     a0a:	66 25 f0 00          	and    $0xf0,%ax
     a0e:	00 00                	add    %al,(%eax)
     a10:	66 01 f0             	add    %si,%ax
     a13:	66 a3 08 39 66 83    	mov    %ax,0x83663908
		}

		if (max_intel_level >= 0x00000007) {
     a19:	ff 06                	incl   (%esi)
     a1b:	76 10                	jbe    a2d <get_cpuflags+0xfe>
	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
     a1d:	66 b8 07 00          	mov    $0x7,%ax
     a21:	00 00                	add    %al,(%eax)
     a23:	66 31 c9             	xor    %cx,%cx
     a26:	0f a2                	cpuid  
     a28:	66 89 0e             	mov    %cx,(%esi)
     a2b:	4c                   	dec    %esp
     a2c:	39 66 31             	cmp    %esp,0x31(%esi)
     a2f:	f6 66 b8             	mulb   -0x48(%esi)
     a32:	00 00                	add    %al,(%eax)
     a34:	00 80 66 89 f1 0f    	add    %al,0xff18966(%eax)
     a3a:	a2 66 05 ff ff       	mov    %al,0xffff0566
		}

		cpuid(0x80000000, &max_amd_level, &ignored, &ignored,
		      &ignored);

		if (max_amd_level >= 0x80000001 &&
     a3f:	ff                   	(bad)  
     a40:	7f 66                	jg     aa8 <check_cpuflags+0x3e>
     a42:	3d fe ff 00 00       	cmp    $0xfffe,%eax
     a47:	77 15                	ja     a5e <get_cpuflags+0x12f>
	asm volatile(".ifnc %%ebx,%3 ; movl  %%ebx,%3 ; .endif	\n\t"
     a49:	66 b8 01 00          	mov    $0x1,%ax
     a4d:	00 80 66 89 f1 0f    	add    %al,0xff18966(%eax)
     a53:	a2 66 89 0e 24       	mov    %al,0x240e8966
     a58:	39 66 89             	cmp    %esp,-0x77(%esi)
     a5b:	16                   	push   %ss
     a5c:	10 39                	adc    %bh,(%ecx)
		    max_amd_level <= 0x8000ffff) {
			cpuid(0x80000001, &ignored, &ignored, &cpu.flags[6],
			      &cpu.flags[1]);
		}
	}
}
     a5e:	66 58                	pop    %ax
     a60:	66 5b                	pop    %bx
     a62:	66 5e                	pop    %si
     a64:	66 5f                	pop    %di
     a66:	66 c3                	retw   
     a68:	66 c3                	retw   

00000a6a <check_cpuflags>:
	       cpu_vendor[2] == A32('n', 't', 'e', 'l');
}

/* Returns a bitmask of which words we have error bits in */
static int check_cpuflags(void)
{
     a6a:	66 53                	push   %bx
	u32 err;
	int i;

	err = 0;
	for (i = 0; i < NCAPINTS; i++) {
     a6c:	66 31 c9             	xor    %cx,%cx
	err = 0;
     a6f:	66 31 d2             	xor    %dx,%dx
		err_flags[i] = req_flags[i] & ~cpu.flags[i];
		if (err_flags[i])
			err |= 1 << i;
     a72:	66 bb 01 00          	mov    $0x1,%bx
     a76:	00 00                	add    %al,(%eax)
		err_flags[i] = req_flags[i] & ~cpu.flags[i];
     a78:	67 66 8b 04          	mov    (%si),%ax
     a7c:	8d 0c 39             	lea    (%ecx,%edi,1),%ecx
     a7f:	00 00                	add    %al,(%eax)
     a81:	66 f7 d0             	not    %ax
     a84:	67 66 23 04          	and    (%si),%ax
     a88:	8d                   	(bad)  
     a89:	c0 31 00             	shlb   $0x0,(%ecx)
     a8c:	00 67 66             	add    %ah,0x66(%edi)
     a8f:	89 04 8d 60 36 00 00 	mov    %eax,0x3660(,%ecx,4)
		if (err_flags[i])
     a96:	74 09                	je     aa1 <check_cpuflags+0x37>
			err |= 1 << i;
     a98:	66 89 d8             	mov    %bx,%ax
     a9b:	66 d3 e0             	shl    %cl,%ax
     a9e:	66 09 c2             	or     %ax,%dx
	for (i = 0; i < NCAPINTS; i++) {
     aa1:	66 41                	inc    %cx
     aa3:	66 83 f9 14          	cmp    $0x14,%cx
     aa7:	75 cf                	jne    a78 <check_cpuflags+0xe>
	}

	return err;
}
     aa9:	66 89 d0             	mov    %dx,%ax
     aac:	66 5b                	pop    %bx
     aae:	66 c3                	retw   

00000ab0 <check_cpu>:
 * level.  x86-64 is considered level 64 for this purpose.
 *
 * *err_flags_ptr is set to the flags error array if there are flags missing.
 */
int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr)
{
     ab0:	66 55                	push   %bp
     ab2:	66 57                	push   %di
     ab4:	66 56                	push   %si
     ab6:	66 53                	push   %bx
     ab8:	66 83 ec 0c          	sub    $0xc,%sp
     abc:	67 66 89 04          	mov    %ax,(%si)
     ac0:	24 66                	and    $0x66,%al
     ac2:	89 d5                	mov    %edx,%ebp
     ac4:	66 89 ce             	mov    %cx,%si
	int err;

	memset(&cpu.flags, 0, sizeof(cpu.flags));
     ac7:	66 ba 0c 39          	mov    $0x390c,%dx
     acb:	00 00                	add    %al,(%eax)
     acd:	66 b9 14 00          	mov    $0x14,%cx
     ad1:	00 00                	add    %al,(%eax)
     ad3:	66 31 c0             	xor    %ax,%ax
     ad6:	66 89 d7             	mov    %dx,%di
     ad9:	66 f3 ab             	rep stos %ax,%es:(%edi)
	cpu.level = 3;
     adc:	66 c7 06 00 39       	movw   $0x3900,(%esi)
     ae1:	03 00                	add    (%eax),%eax
     ae3:	00 00                	add    %al,(%eax)

	if (has_eflag(X86_EFLAGS_AC))
     ae5:	66 b8 00 00          	mov    $0x0,%ax
     ae9:	04 00                	add    $0x0,%al
     aeb:	66 e8 19 fe          	callw  908 <BOOTSEG+0x148>
     aef:	ff                   	(bad)  
     af0:	ff 66 85             	jmp    *-0x7b(%esi)
     af3:	c0 74 09 66 c7       	shlb   $0xc7,0x66(%ecx,%ecx,1)
		cpu.level = 4;
     af8:	06                   	push   %es
     af9:	00 39                	add    %bh,(%ecx)
     afb:	04 00                	add    $0x0,%al
     afd:	00 00                	add    %al,(%eax)

	get_cpuflags();
     aff:	66 e8 2a fe          	callw  92d <has_eflag+0x23>
     b03:	ff                   	(bad)  
     b04:	ff 66 e8             	jmp    *-0x18(%esi)
	err = check_cpuflags();
     b07:	5f                   	pop    %edi
     b08:	ff                   	(bad)  
     b09:	ff                   	(bad)  
     b0a:	ff 66 89             	jmp    *-0x77(%esi)
     b0d:	c7                   	(bad)  

	if (test_bit(X86_FEATURE_LM, cpu.flags))
     b0e:	f6 06 13             	testb  $0x13,(%esi)
     b11:	39 20                	cmp    %esp,(%eax)
     b13:	74 09                	je     b1e <check_cpu+0x6e>
		cpu.level = 64;
     b15:	66 c7 06 00 39       	movw   $0x3900,(%esi)
     b1a:	40                   	inc    %eax
     b1b:	00 00                	add    %al,(%eax)
     b1d:	00 66 83             	add    %ah,-0x7d(%esi)

	if (err == 0x01 &&
     b20:	ff 01                	incl   (%ecx)
     b22:	0f 85 6d 01 66 8b    	jne    8b660c95 <image_base+0x8a660c95>
	    !(err_flags[0] &
     b28:	16                   	push   %ss
     b29:	60                   	pusha  
     b2a:	36 66 a1 5c 39 66 f7 	mov    %ss:0xf766395c,%ax
	if (err == 0x01 &&
     b31:	c2 ff ff             	ret    $0xffff
     b34:	ff                   	(bad)  
     b35:	f9                   	stc    
     b36:	75 33                	jne    b6b <check_cpu+0xbb>
	       cpu_vendor[1] == A32('e', 'n', 't', 'i') &&
     b38:	66 3d 41 75          	cmp    $0x7541,%ax
     b3c:	74 68                	je     ba6 <check_cpu+0xf6>
     b3e:	75 2b                	jne    b6b <check_cpu+0xbb>
	return cpu_vendor[0] == A32('A', 'u', 't', 'h') &&
     b40:	66 81 3e 60 39       	cmpw   $0x3960,(%esi)
     b45:	65 6e                	outsb  %gs:(%esi),(%dx)
     b47:	74 69                	je     bb2 <check_cpu+0x102>
     b49:	75 20                	jne    b6b <check_cpu+0xbb>
	       cpu_vendor[1] == A32('e', 'n', 't', 'i') &&
     b4b:	66 81 3e 64 39       	cmpw   $0x3964,(%esi)
     b50:	63 41 4d             	arpl   %ax,0x4d(%ecx)
     b53:	44                   	inc    %esp
     b54:	75 15                	jne    b6b <check_cpu+0xbb>
		   turn them on */

		u32 ecx = MSR_K7_HWCR;
		u32 eax, edx;

		asm("rdmsr" : "=a" (eax), "=d" (edx) : "c" (ecx));
     b56:	66 b9 15 00          	mov    $0x15,%cx
     b5a:	01 c0                	add    %eax,%eax
     b5c:	0f 32                	rdmsr  
		eax &= ~(1 << 15);
     b5e:	80 e4 7f             	and    $0x7f,%ah
		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
     b61:	0f 30                	wrmsr  

		get_cpuflags();	/* Make sure it really did something */
     b63:	66 e8 c6 fd          	callw  92d <has_eflag+0x23>
     b67:	ff                   	(bad)  
     b68:	ff                   	(bad)  
		err = check_cpuflags();
     b69:	eb 46                	jmp    bb1 <check_cpu+0x101>
	} else if (err == 0x01 &&
     b6b:	66 f7 c2 ff fe       	test   $0xfeff,%dx
     b70:	ff                   	(bad)  
     b71:	ff 75 49             	pushl  0x49(%ebp)
	       cpu_vendor[1] == A32('a', 'u', 'r', 'H') &&
     b74:	66 3d 43 65          	cmp    $0x6543,%ax
     b78:	6e                   	outsb  %ds:(%esi),(%dx)
     b79:	74 75                	je     bf0 <check_cpu+0x140>
     b7b:	41                   	inc    %ecx
	return cpu_vendor[0] == A32('C', 'e', 'n', 't') &&
     b7c:	66 81 3e 60 39       	cmpw   $0x3960,(%esi)
     b81:	61                   	popa   
     b82:	75 72                	jne    bf6 <check_cpu+0x146>
     b84:	48                   	dec    %eax
     b85:	0f 85 8f 00 66 81    	jne    81660c1a <image_base+0x80660c1a>
	       cpu_vendor[1] == A32('a', 'u', 'r', 'H') &&
     b8b:	3e 64 39 61 75       	ds cmp %esp,%fs:0x75(%ecx)
     b90:	6c                   	insb   (%dx),%es:(%edi)
     b91:	73 0f                	jae    ba2 <check_cpu+0xf2>
     b93:	85 82 00 66 83 3e    	test   %eax,0x3e836600(%edx)
		   !(err_flags[0] & ~(1 << X86_FEATURE_CX8)) &&
		   is_centaur() && cpu.model >= 6) {
     b99:	08 39                	or     %bh,(%ecx)
     b9b:	05 7e 7a 66 b9       	add    $0xb9667a7e,%eax
		   explicitly */

		u32 ecx = MSR_VIA_FCR;
		u32 eax, edx;

		asm("rdmsr" : "=a" (eax), "=d" (edx) : "c" (ecx));
     ba0:	07                   	pop    %es
     ba1:	11 00                	adc    %eax,(%eax)
     ba3:	00 0f                	add    %cl,(%edi)
     ba5:	32 0c 82             	xor    (%edx,%eax,4),%cl
		eax |= (1<<1)|(1<<7);
		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
     ba8:	0f 30                	wrmsr  
     baa:	66 0f ba 2e 0c       	btsw   $0xc,(%esi)
     baf:	39 08                	cmp    %ecx,(%eax)

		set_bit(X86_FEATURE_CX8, cpu.flags);
		err = check_cpuflags();
     bb1:	66 e8 b3 fe          	callw  a68 <get_cpuflags+0x139>
     bb5:	ff                   	(bad)  
     bb6:	ff 66 89             	jmp    *-0x77(%esi)
     bb9:	c7                   	(bad)  
		   is_centaur() && cpu.model >= 6) {
     bba:	e9 d6 00 66 3d       	jmp    3d660c95 <image_base+0x3c660c95>
	       cpu_vendor[1] == A32('i', 'n', 'e', 'T') &&
     bbf:	47                   	inc    %edi
     bc0:	65 6e                	outsb  %gs:(%esi),(%dx)
     bc2:	75 75                	jne    c39 <check_cpu+0x189>
     bc4:	53                   	push   %ebx
	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
     bc5:	66 81 3e 60 39       	cmpw   $0x3960,(%esi)
     bca:	69 6e 65 54 75 48 66 	imul   $0x66487554,0x65(%esi),%ebp
	       cpu_vendor[1] == A32('i', 'n', 'e', 'T') &&
     bd1:	81 3e 64 39 4d 78    	cmpl   $0x784d3964,(%esi)
     bd7:	38 36                	cmp    %dh,(%esi)
     bd9:	75 3d                	jne    c18 <check_cpu+0x168>

		u32 ecx = 0x80860004;
		u32 eax, edx;
		u32 level = 1;

		asm("rdmsr" : "=a" (eax), "=d" (edx) : "c" (ecx));
     bdb:	66 bf 04 00          	mov    $0x4,%di
     bdf:	86 80 66 89 f9 0f    	xchg   %al,0xff98966(%eax)
     be5:	32 67 66             	xor    0x66(%edi),%ah
     be8:	89 54 24 04          	mov    %edx,0x4(%esp)
     bec:	67 66 89 44 24       	mov    %ax,0x24(%si)
     bf1:	08 66 83             	or     %ah,-0x7d(%esi)
		asm("wrmsr" : : "a" (~0), "d" (edx), "c" (ecx));
     bf4:	c8 ff 0f 30          	enter  $0xfff,$0x30
		asm("cpuid"
     bf8:	66 b8 01 00          	mov    $0x1,%ax
     bfc:	00 00                	add    %al,(%eax)
     bfe:	0f a2                	cpuid  
     c00:	66 89 16             	mov    %dx,(%esi)
     c03:	0c 39                	or     $0x39,%al
		    : "+a" (level), "=d" (cpu.flags[0])
		    : : "ecx", "ebx");
		asm("wrmsr" : : "a" (eax), "d" (edx), "c" (ecx));
     c05:	67 66 8b 44 24       	mov    0x24(%si),%ax
     c0a:	08 67 66             	or     %ah,0x66(%edi)
     c0d:	8b 54 24 04          	mov    0x4(%esp),%edx
     c11:	66 89 f9             	mov    %di,%cx
     c14:	0f 30                	wrmsr  

		err = check_cpuflags();
     c16:	eb 99                	jmp    bb1 <check_cpu+0x101>
	} else if (err == 0x01 &&
     c18:	66 83 e2 bf          	and    $0xffbf,%dx
     c1c:	75 7d                	jne    c9b <check_cpu+0x1eb>
	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
     c1e:	66 3d 47 65          	cmp    $0x6547,%ax
     c22:	6e                   	outsb  %ds:(%esi),(%dx)
     c23:	75 75                	jne    c9a <check_cpu+0x1ea>
     c25:	75 66                	jne    c8d <check_cpu+0x1dd>
	return cpu_vendor[0] == A32('G', 'e', 'n', 'u') &&
     c27:	81 3e 60 39 69 6e    	cmpl   $0x6e693960,(%esi)
     c2d:	65 49                	gs dec %ecx
     c2f:	75 6a                	jne    c9b <check_cpu+0x1eb>
	       cpu_vendor[1] == A32('i', 'n', 'e', 'I') &&
     c31:	66 81 3e 64 39       	cmpw   $0x3964,(%esi)
     c36:	6e                   	outsb  %ds:(%esi),(%dx)
     c37:	74 65                	je     c9e <check_cpu+0x1ee>
     c39:	6c                   	insb   (%dx),%es:(%edi)
     c3a:	75 5f                	jne    c9b <check_cpu+0x1eb>
		   !(err_flags[0] & ~(1 << X86_FEATURE_PAE)) &&
		   is_intel() && cpu.level == 6 &&
     c3c:	66 83 3e 00          	cmpw   $0x0,(%esi)
     c40:	39 06                	cmp    %eax,(%esi)
     c42:	75 57                	jne    c9b <check_cpu+0x1eb>
     c44:	66 a1 08 39 66 83    	mov    0x83663908,%ax
     c4a:	e0 fb                	loopne c47 <check_cpu+0x197>
		   (cpu.model == 9 || cpu.model == 13)) {
     c4c:	66 83 f8 09          	cmp    $0x9,%ax
     c50:	75 49                	jne    c9b <check_cpu+0x1eb>
	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
}

static inline int cmdline_find_option_bool(const char *option)
{
	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
     c52:	66 a1 98 3b 66 3d    	mov    0x3d663b98,%ax

	if (cmd_line_ptr >= 0x100000)
     c58:	ff                   	(bad)  
     c59:	ff 0f                	decl   (%edi)
     c5b:	00 76 16             	add    %dh,0x16(%esi)
		/* PAE is disabled on this Pentium M but can be forced */
		if (cmdline_find_option_bool("forcepae")) {
			puts("WARNING: Forcing PAE in CPU flags\n");
     c5e:	66 b8 28 31          	mov    $0x3128,%ax
     c62:	00 00                	add    %al,(%eax)
     c64:	66 e8 53 f7          	callw  3bb <putchar+0x88>
     c68:	ff                   	(bad)  
     c69:	ff 66 0f             	jmp    *0xf(%esi)
     c6c:	ba 2e 0c 39 06       	mov    $0x6390c2e,%edx
			set_bit(X86_FEATURE_PAE, cpu.flags);
			err = check_cpuflags();
     c71:	e9 3d ff 66 ba       	jmp    ba670bb3 <image_base+0xb9670bb3>
		return -1;      /* inaccessible */

	return __cmdline_find_option_bool(cmd_line_ptr, option);
     c76:	4b                   	dec    %ebx
     c77:	31 00                	xor    %eax,(%eax)
     c79:	00 66 e8             	add    %ah,-0x18(%esi)
     c7c:	d3 f9                	sar    %cl,%ecx
     c7e:	ff                   	(bad)  
     c7f:	ff 66 85             	jmp    *-0x7b(%esi)
		if (cmdline_find_option_bool("forcepae")) {
     c82:	c0 75 d9 66          	shlb   $0x66,-0x27(%ebp)
		}
		else {
			puts("WARNING: PAE disabled. Use parameter 'forcepae' to enable at your own risk!\n");
     c86:	b8 54 31 00 00       	mov    $0x3154,%eax
     c8b:	66 e8 2c f7          	callw  3bb <putchar+0x88>
     c8f:	ff                   	(bad)  
     c90:	ff                   	(bad)  
		}
	}
	if (!err)
     c91:	eb 08                	jmp    c9b <check_cpu+0x1eb>
		err = check_knl_erratum();

	if (err_flags_ptr)
		*err_flags_ptr = err ? err_flags : NULL;
     c93:	66 31 c0             	xor    %ax,%ax
	if (!err)
     c96:	66 85 ff             	test   %di,%di
     c99:	74 06                	je     ca1 <check_cpu+0x1f1>
		*err_flags_ptr = err ? err_flags : NULL;
     c9b:	66 b8 60 36          	mov    $0x3660,%ax
     c9f:	00 00                	add    %al,(%eax)
	if (err_flags_ptr)
     ca1:	66 85 f6             	test   %si,%si
     ca4:	74 04                	je     caa <check_cpu+0x1fa>
		*err_flags_ptr = err ? err_flags : NULL;
     ca6:	67 66 89 06 67 66    	mov    %ax,0x6667
	if (cpu_level_ptr)
     cac:	83 3c 24 00          	cmpl   $0x0,(%esp)
     cb0:	74 0d                	je     cbf <check_cpu+0x20f>
		*cpu_level_ptr = cpu.level;
     cb2:	66 a1 00 39 67 66    	mov    0x66673900,%ax
     cb8:	8b 1c 24             	mov    (%esp),%ebx
     cbb:	67 66 89 03          	mov    %ax,(%bp,%di)
	if (req_level_ptr)
     cbf:	66 85 ed             	test   %bp,%bp
     cc2:	74 09                	je     ccd <check_cpu+0x21d>
		*req_level_ptr = req_level;
     cc4:	67 66 c7 45 00 40 00 	movw   $0x40,0x0(%di)
     ccb:	00 00                	add    %al,(%eax)

	return (cpu.level < req_level || err) ? -1 : 0;
     ccd:	66 83 3e 00          	cmpw   $0x0,(%esi)
     cd1:	39 3f                	cmp    %edi,(%edi)
     cd3:	0f 9e c0             	setle  %al
     cd6:	66 85 ff             	test   %di,%di
     cd9:	0f 95 c2             	setne  %dl
     cdc:	66 09 d0             	or     %dx,%ax
     cdf:	66 0f b6 c0          	movzbw %al,%ax
     ce3:	66 f7 d8             	neg    %ax
}
     ce6:	66 83 c4 0c          	add    $0xc,%sp
     cea:	66 5b                	pop    %bx
     cec:	66 5e                	pop    %si
     cee:	66 5f                	pop    %di
     cf0:	66 5d                	pop    %bp
     cf2:	66 c3                	retw   

00000cf4 <check_knl_erratum>:
	puts("This 32-bit kernel can not run on this Xeon Phi x200\n"
	     "processor due to a processor erratum.  Use a 64-bit\n"
	     "kernel, or enable PAE in this 32-bit kernel.\n\n");

	return -1;
}
     cf4:	66 31 c0             	xor    %ax,%ax
     cf7:	66 c3                	retw   

00000cf9 <early_serial_init>:
#define DLH             1       /*  Divisor latch High        */

#define DEFAULT_BAUD 9600

static void early_serial_init(int port, int baud)
{
     cf9:	66 55                	push   %bp
     cfb:	66 57                	push   %di
     cfd:	66 56                	push   %si
     cff:	66 53                	push   %bx
     d01:	66 89 c1             	mov    %ax,%cx
     d04:	66 89 d3             	mov    %dx,%bx
	unsigned char c;
	unsigned divisor;

	outb(0x3, port + LCR);	/* 8n1 */
     d07:	67 66 8d 70 03       	lea    0x3(%bx,%si),%si
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
     d0c:	66 bf 03 00          	mov    $0x3,%di
     d10:	00 00                	add    %al,(%eax)
     d12:	66 89 f8             	mov    %di,%ax
     d15:	66 89 f2             	mov    %si,%dx
     d18:	ee                   	out    %al,(%dx)
	outb(0, port + IER);	/* no interrupt */
     d19:	67 66 8d 69 01       	lea    0x1(%bx,%di),%bp
     d1e:	66 31 c0             	xor    %ax,%ax
     d21:	66 89 ea             	mov    %bp,%dx
     d24:	ee                   	out    %al,(%dx)
	outb(0, port + FCR);	/* no fifo */
     d25:	67 66 8d 51 02       	lea    0x2(%bx,%di),%dx
     d2a:	ee                   	out    %al,(%dx)
	outb(0x3, port + MCR);	/* DTR + RTS */
     d2b:	67 66 8d 51 04       	lea    0x4(%bx,%di),%dx
     d30:	66 89 f8             	mov    %di,%ax
     d33:	ee                   	out    %al,(%dx)

	divisor	= 115200 / baud;
     d34:	66 b8 00 c2          	mov    $0xc200,%ax
     d38:	01 00                	add    %eax,(%eax)
     d3a:	66 99                	cwtd   
     d3c:	66 f7 fb             	idiv   %bx
     d3f:	66 89 c7             	mov    %ax,%di
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     d42:	66 89 f2             	mov    %si,%dx
     d45:	ec                   	in     (%dx),%al
     d46:	88 c3                	mov    %al,%bl
	c = inb(port + LCR);
	outb(c | DLAB, port + LCR);
     d48:	66 83 c8 80          	or     $0xff80,%ax
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
     d4c:	ee                   	out    %al,(%dx)
     d4d:	66 89 f8             	mov    %di,%ax
     d50:	66 89 ca             	mov    %cx,%dx
     d53:	ee                   	out    %al,(%dx)
	outb(divisor & 0xff, port + DLL);
	outb((divisor >> 8) & 0xff, port + DLH);
     d54:	66 89 f8             	mov    %di,%ax
     d57:	66 c1 e8 08          	shr    $0x8,%ax
     d5b:	66 89 ea             	mov    %bp,%dx
     d5e:	ee                   	out    %al,(%dx)
     d5f:	88 d8                	mov    %bl,%al
     d61:	66 83 e0 7f          	and    $0x7f,%ax
     d65:	66 89 f2             	mov    %si,%dx
     d68:	ee                   	out    %al,(%dx)
	outb(c & ~DLAB, port + LCR);

	early_serial_base = port;
     d69:	66 89 0e             	mov    %cx,(%esi)
     d6c:	70 49                	jo     db7 <console_init+0x3f>
}
     d6e:	66 5b                	pop    %bx
     d70:	66 5e                	pop    %si
     d72:	66 5f                	pop    %di
     d74:	66 5d                	pop    %bp
     d76:	66 c3                	retw   

00000d78 <console_init>:
	if (port)
		early_serial_init(port, baud);
}

void console_init(void)
{
     d78:	66 55                	push   %bp
     d7a:	66 57                	push   %di
     d7c:	66 56                	push   %si
     d7e:	66 53                	push   %bx
     d80:	66 83 ec 48          	sub    $0x48,%sp
	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
     d84:	66 a1 98 3b 66 3d    	mov    0x3d663b98,%ax
	if (cmd_line_ptr >= 0x100000)
     d8a:	ff                   	(bad)  
     d8b:	ff 0f                	decl   (%edi)
     d8d:	00 0f                	add    %cl,(%edi)
     d8f:	87 35 01 67 66 8d    	xchg   %esi,0x8d666701
	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
     d95:	7c 24                	jl     dbb <console_init+0x43>
     d97:	08 66 6a             	or     %ah,0x6a(%esi)
     d9a:	20 66 89             	and    %ah,-0x77(%esi)
     d9d:	f9                   	stc    
     d9e:	66 ba 10 32          	mov    $0x3210,%dx
     da2:	00 00                	add    %al,(%eax)
     da4:	66 e8 ab f7          	callw  553 <enable_a20+0xe2>
     da8:	ff                   	(bad)  
     da9:	ff 66 59             	jmp    *0x59(%esi)
	if (cmdline_find_option("earlyprintk", arg, sizeof(arg)) > 0) {
     dac:	66 85 c0             	test   %ax,%ax
     daf:	0f 8e 14 01 66 b9    	jle    b9660ec9 <image_base+0xb8660ec9>
		if (!strncmp(arg, "serial", 6)) {
     db5:	06                   	push   %es
     db6:	00 00                	add    %al,(%eax)
     db8:	00 66 ba             	add    %ah,-0x46(%esi)
     dbb:	1c 32                	sbb    $0x32,%al
     dbd:	00 00                	add    %al,(%eax)
     dbf:	66 89 f8             	mov    %di,%ax
     dc2:	66 e8 ab 0d          	callw  1b71 <strcmp+0x32>
     dc6:	00 00                	add    %al,(%eax)
			port = DEFAULT_SERIAL_PORT;
     dc8:	66 83 f8 01          	cmp    $0x1,%ax
     dcc:	66 19 f6             	sbb    %si,%si
     dcf:	66 81 e6 f8 03       	and    $0x3f8,%si
     dd4:	00 00                	add    %al,(%eax)
     dd6:	66 83 f8 01          	cmp    $0x1,%ax
     dda:	66 19 db             	sbb    %bx,%bx
     ddd:	66 83 e3 06          	and    $0x6,%bx
		if (arg[pos] == ',')
     de1:	67 80 7c 1c 08       	cmpb   $0x8,0x1c(%si)
     de6:	2c 75                	sub    $0x75,%al
     de8:	58                   	pop    %eax
			pos++;
     de9:	66 43                	inc    %bx
		if (pos == 7 && !strncmp(arg + pos, "0x", 2)) {
     deb:	66 83 fb 07          	cmp    $0x7,%bx
     def:	75 50                	jne    e41 <console_init+0xc9>
     df1:	67 66 8d 6c 24       	lea    0x24(%si),%bp
     df6:	0f 66 b9 02 00 00 00 	pcmpgtd 0x2(%ecx),%mm7
     dfd:	66 ba 23 32          	mov    $0x3223,%dx
     e01:	00 00                	add    %al,(%eax)
     e03:	66 89 e8             	mov    %bp,%ax
     e06:	66 e8 67 0d          	callw  1b71 <strcmp+0x32>
     e0a:	00 00                	add    %al,(%eax)
     e0c:	66 85 c0             	test   %ax,%ax
     e0f:	75 30                	jne    e41 <console_init+0xc9>
			port = simple_strtoull(arg + pos, &e, 16);
     e11:	66 b9 10 00          	mov    $0x10,%cx
     e15:	00 00                	add    %al,(%eax)
     e17:	67 66 8d 54 24       	lea    0x24(%si),%dx
     e1c:	04 66                	add    $0x66,%al
     e1e:	89 e8                	mov    %ebp,%eax
     e20:	66 e8 c7 0d          	callw  1beb <atou+0x28>
     e24:	00 00                	add    %al,(%eax)
     e26:	66 89 c6             	mov    %ax,%si
			if (port == 0 || arg + pos == e)
     e29:	66 85 c0             	test   %ax,%ax
     e2c:	74 50                	je     e7e <console_init+0x106>
     e2e:	67 66 8b 44 24       	mov    0x24(%si),%ax
     e33:	04 66                	add    $0x66,%al
     e35:	39 e8                	cmp    %ebp,%eax
     e37:	74 45                	je     e7e <console_init+0x106>
				pos = e - arg;
     e39:	66 29 f8             	sub    %di,%ax
     e3c:	66 89 c3             	mov    %ax,%bx
     e3f:	eb 43                	jmp    e84 <console_init+0x10c>
		} else if (!strncmp(arg + pos, "ttyS", 4)) {
     e41:	67 66 8d 04          	lea    (%si),%ax
     e45:	1f                   	pop    %ds
     e46:	66 b9 04 00          	mov    $0x4,%cx
     e4a:	00 00                	add    %al,(%eax)
     e4c:	66 ba 26 32          	mov    $0x3226,%dx
     e50:	00 00                	add    %al,(%eax)
     e52:	66 e8 1b 0d          	callw  1b71 <strcmp+0x32>
     e56:	00 00                	add    %al,(%eax)
     e58:	66 85 c0             	test   %ax,%ax
     e5b:	75 27                	jne    e84 <console_init+0x10c>
			pos += 4;
     e5d:	67 66 8d 43 04       	lea    0x4(%bp,%di),%ax
			if (arg[pos++] == '1')
     e62:	66 83 c3 05          	add    $0x5,%bx
     e66:	67 80 7c 04 08       	cmpb   $0x8,0x4(%si)
     e6b:	31 0f                	xor    %ecx,(%edi)
     e6d:	94                   	xchg   %eax,%esp
     e6e:	c0 66 0f b6          	shlb   $0xb6,0xf(%esi)
     e72:	c0 67 66 8b          	shlb   $0x8b,0x66(%edi)
			port = bases[idx];
     e76:	34 85                	xor    $0x85,%al
     e78:	4c                   	dec    %esp
     e79:	32 00                	xor    (%eax),%al
     e7b:	00 eb                	add    %ch,%bl
     e7d:	06                   	push   %es
				port = DEFAULT_SERIAL_PORT;
     e7e:	66 be f8 03          	mov    $0x3f8,%si
     e82:	00 00                	add    %al,(%eax)
		if (arg[pos] == ',')
     e84:	67 80 7c 1c 08       	cmpb   $0x8,0x1c(%si)
     e89:	2c 75                	sub    $0x75,%al
     e8b:	02 66 43             	add    0x43(%esi),%ah
		baud = simple_strtoull(arg + pos, &e, 0);
     e8e:	66 01 fb             	add    %di,%bx
     e91:	66 31 c9             	xor    %cx,%cx
     e94:	67 66 8d 54 24       	lea    0x24(%si),%dx
     e99:	04 66                	add    $0x66,%al
     e9b:	89 d8                	mov    %ebx,%eax
     e9d:	66 e8 4a 0d          	callw  1beb <atou+0x28>
     ea1:	00 00                	add    %al,(%eax)
     ea3:	66 89 c2             	mov    %ax,%dx
		if (baud == 0 || arg + pos == e)
     ea6:	66 85 c0             	test   %ax,%ax
     ea9:	74 08                	je     eb3 <console_init+0x13b>
     eab:	67 66 3b 5c 24       	cmp    0x24(%si),%bx
     eb0:	04 75                	add    $0x75,%al
     eb2:	06                   	push   %es
			baud = DEFAULT_BAUD;
     eb3:	66 ba 80 25          	mov    $0x2580,%dx
     eb7:	00 00                	add    %al,(%eax)
	if (port)
     eb9:	66 85 f6             	test   %si,%si
     ebc:	74 09                	je     ec7 <console_init+0x14f>
		early_serial_init(port, baud);
     ebe:	66 89 f0             	mov    %si,%ax
     ec1:	66 e8 32 fe          	callw  cf7 <check_knl_erratum+0x3>
     ec5:	ff                   	(bad)  
     ec6:	ff 66 83             	jmp    *-0x7d(%esi)
	parse_earlyprintk();

	if (!early_serial_base)
     ec9:	3e 70 49             	jo,pt  f15 <console_init+0x19d>
     ecc:	00 0f                	add    %cl,(%edi)
     ece:	85 0a                	test   %ecx,(%edx)
     ed0:	01 66 a1             	add    %esp,-0x5f(%esi)
	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
     ed3:	98                   	cwtl   
     ed4:	3b 66 3d             	cmp    0x3d(%esi),%esp
	if (cmd_line_ptr >= 0x100000)
     ed7:	ff                   	(bad)  
     ed8:	ff 0f                	decl   (%edi)
     eda:	00 0f                	add    %cl,(%edi)
     edc:	87 fc                	xchg   %edi,%esp
     ede:	00 67 66             	add    %ah,0x66(%edi)
	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
     ee1:	8d 5c 24 08          	lea    0x8(%esp),%ebx
     ee5:	66 6a 40             	pushw  $0x40
     ee8:	66 89 d9             	mov    %bx,%cx
     eeb:	66 ba 2b 32          	mov    $0x322b,%dx
     eef:	00 00                	add    %al,(%eax)
     ef1:	66 e8 5e f6          	callw  553 <enable_a20+0xe2>
     ef5:	ff                   	(bad)  
     ef6:	ff 66 5a             	jmp    *0x5a(%esi)
	if (cmdline_find_option("console", optstr, sizeof(optstr)) <= 0)
     ef9:	66 85 c0             	test   %ax,%ax
     efc:	0f 8e db 00 67 66    	jle    66670fdd <image_base+0x65670fdd>
	options = optstr;
     f02:	89 5c 24 04          	mov    %ebx,0x4(%esp)
	if (!strncmp(options, "uart8250,io,", 12))
     f06:	66 b9 0c 00          	mov    $0xc,%cx
     f0a:	00 00                	add    %al,(%eax)
     f0c:	66 ba 33 32          	mov    $0x3233,%dx
     f10:	00 00                	add    %al,(%eax)
     f12:	66 89 d8             	mov    %bx,%ax
     f15:	66 e8 58 0c          	callw  1b71 <strcmp+0x32>
     f19:	00 00                	add    %al,(%eax)
     f1b:	66 85 c0             	test   %ax,%ax
     f1e:	67 66 8b 44 24       	mov    0x24(%si),%ax
     f23:	04 75                	add    $0x75,%al
     f25:	06                   	push   %es
		port = simple_strtoull(options + 12, &options, 0);
     f26:	66 83 c0 0c          	add    $0xc,%ax
     f2a:	eb 23                	jmp    f4f <console_init+0x1d7>
	else if (!strncmp(options, "uart,io,", 8))
     f2c:	66 b9 08 00          	mov    $0x8,%cx
     f30:	00 00                	add    %al,(%eax)
     f32:	66 ba 40 32          	mov    $0x3240,%dx
     f36:	00 00                	add    %al,(%eax)
     f38:	66 e8 35 0c          	callw  1b71 <strcmp+0x32>
     f3c:	00 00                	add    %al,(%eax)
     f3e:	66 85 c0             	test   %ax,%ax
     f41:	0f 85 96 00 67 66    	jne    66670fdd <image_base+0x65670fdd>
		port = simple_strtoull(options + 8, &options, 0);
     f47:	8b 44 24 04          	mov    0x4(%esp),%eax
     f4b:	66 83 c0 08          	add    $0x8,%ax
     f4f:	66 31 c9             	xor    %cx,%cx
     f52:	67 66 8d 54 24       	lea    0x24(%si),%dx
     f57:	04 66                	add    $0x66,%al
     f59:	e8 8f 0c 00 00       	call   1bed <simple_strtoull>
     f5e:	66 89 c3             	mov    %ax,%bx
	if (options && (options[0] == ','))
     f61:	67 66 8b 44 24       	mov    0x24(%si),%ax
     f66:	04 66                	add    $0x66,%al
     f68:	85 c0                	test   %eax,%eax
     f6a:	74 19                	je     f85 <console_init+0x20d>
     f6c:	67 80 38 2c          	cmpb   $0x2c,(%bx,%si)
     f70:	75 13                	jne    f85 <console_init+0x20d>
		baud = simple_strtoull(options + 1, &options, 0);
     f72:	66 40                	inc    %ax
     f74:	66 31 c9             	xor    %cx,%cx
     f77:	67 66 8d 54 24       	lea    0x24(%si),%dx
     f7c:	04 66                	add    $0x66,%al
     f7e:	e8 6a 0c 00 00       	call   1bed <simple_strtoull>
     f83:	eb 45                	jmp    fca <console_init+0x252>
	lcr = inb(port + LCR);
     f85:	67 66 8d 73 03       	lea    0x3(%bp,%di),%si
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     f8a:	66 89 f2             	mov    %si,%dx
     f8d:	ec                   	in     (%dx),%al
     f8e:	66 89 c7             	mov    %ax,%di
	outb(lcr | DLAB, port + LCR);
     f91:	66 83 c8 80          	or     $0xff80,%ax
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
     f95:	ee                   	out    %al,(%dx)
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
     f96:	66 89 da             	mov    %bx,%dx
     f99:	ec                   	in     (%dx),%al
     f9a:	67 88 44 24          	mov    %al,0x24(%si)
     f9e:	03 67 66             	add    0x66(%edi),%esp
	dlh = inb(port + DLH);
     fa1:	8d 53 01             	lea    0x1(%ebx),%edx
     fa4:	ec                   	in     (%dx),%al
     fa5:	66 0f b6 c8          	movzbw %al,%cx
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
     fa9:	66 89 f8             	mov    %di,%ax
     fac:	66 89 f2             	mov    %si,%dx
     faf:	ee                   	out    %al,(%dx)
	quot = (dlh << 8) | dll;
     fb0:	66 c1 e1 08          	shl    $0x8,%cx
     fb4:	67 66 0f b6 54 24    	movzbw 0x24(%si),%dx
     fba:	03 66 09             	add    0x9(%esi),%esp
     fbd:	d1 66 b8             	shll   -0x48(%esi)
	return BASE_BAUD / quot;
     fc0:	00 c2                	add    %al,%dl
     fc2:	01 00                	add    %eax,(%eax)
		baud = probe_baud(port);
     fc4:	66 31 d2             	xor    %dx,%dx
     fc7:	66 f7 f1             	div    %cx
	if (port)
     fca:	66 85 db             	test   %bx,%bx
     fcd:	74 0c                	je     fdb <console_init+0x263>
		early_serial_init(port, baud);
     fcf:	66 89 c2             	mov    %ax,%dx
     fd2:	66 89 d8             	mov    %bx,%ax
     fd5:	66 e8 1e fd          	callw  cf7 <check_knl_erratum+0x3>
     fd9:	ff                   	(bad)  
     fda:	ff 66 83             	jmp    *-0x7d(%esi)
		parse_console_uart8250();
}
     fdd:	c4 48 66             	les    0x66(%eax),%ecx
     fe0:	5b                   	pop    %ebx
     fe1:	66 5e                	pop    %si
     fe3:	66 5f                	pop    %di
     fe5:	66 5d                	pop    %bp
     fe7:	66 c3                	retw   

00000fe9 <main>:
		     "may be limited!\n");
	}
}

void main(void)
{
     fe9:	66 57                	push   %di
     feb:	66 56                	push   %si
     fed:	66 83 ec 58          	sub    $0x58,%sp
	memcpy(&boot_params.hdr, &hdr, sizeof(hdr));
     ff1:	66 b8 61 3b          	mov    $0x3b61,%ax
     ff5:	00 00                	add    %al,(%eax)
     ff7:	66 be f1 01          	mov    $0x1f1,%si
     ffb:	00 00                	add    %al,(%eax)
     ffd:	66 b9 7b 00          	mov    $0x7b,%cx
    1001:	00 00                	add    %al,(%eax)
    1003:	66 89 c7             	mov    %ax,%di
    1006:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	if (!boot_params.hdr.cmd_line_ptr &&
    1008:	66 83 3e 98          	cmpw   $0xff98,(%esi)
    100c:	3b 00                	cmp    (%eax),%eax
    100e:	75 2b                	jne    103b <SYSSEG+0x3b>
    1010:	81 3e 20 00 3f a3    	cmpl   $0xa33f0020,(%esi)
    1016:	75 23                	jne    103b <SYSSEG+0x3b>
		if (oldcmd->cl_offset < boot_params.hdr.setup_move_size)
    1018:	66 0f b7 16          	movzww (%esi),%dx
    101c:	22 00                	and    (%eax),%al
			cmdline_seg = 0x9000;
    101e:	66 b8 00 90          	mov    $0x9000,%ax
    1022:	ff                   	(bad)  
    1023:	ff                   	(bad)  
		if (oldcmd->cl_offset < boot_params.hdr.setup_move_size)
    1024:	3b 16                	cmp    (%esi),%edx
    1026:	82 3b 73             	cmpb   $0x73,(%ebx)
    1029:	02 8c d8 66 0f b7 c0 	add    -0x3f48f09a(%eax,%ebx,8),%cl
			(cmdline_seg << 4) + oldcmd->cl_offset;
    1030:	66 c1 e0 04          	shl    $0x4,%ax
    1034:	66 01 d0             	add    %dx,%ax
    1037:	66 a3 98 3b 66 e8    	mov    %ax,0xe8663b98
	/* First, copy the boot header into the "zeropage" */
	copy_boot_params();

	/* Initialize the early-boot console */
	console_init();
    103d:	37                   	aaa    
    103e:	fd                   	std    
    103f:	ff                   	(bad)  
    1040:	ff 66 a1             	jmp    *-0x5f(%esi)
	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
    1043:	98                   	cwtl   
    1044:	3b 66 3d             	cmp    0x3d(%esi),%esp
	if (cmd_line_ptr >= 0x100000)
    1047:	ff                   	(bad)  
    1048:	ff 0f                	decl   (%edi)
    104a:	00 76 0e             	add    %dh,0xe(%esi)
	if (cmdline_find_option_bool("debug"))
		puts("early console in setup code\n");
    104d:	66 b8 54 32          	mov    $0x3254,%ax
    1051:	00 00                	add    %al,(%eax)
    1053:	66 e8 64 f3          	callw  3bb <putchar+0x88>
    1057:	ff                   	(bad)  
    1058:	ff                   	(bad)  
    1059:	eb 11                	jmp    106c <SYSSEG+0x6c>
	return __cmdline_find_option_bool(cmd_line_ptr, option);
    105b:	66 ba 71 32          	mov    $0x3271,%dx
    105f:	00 00                	add    %al,(%eax)
    1061:	66 e8 ec f5          	callw  651 <__cmdline_find_option+0xfc>
    1065:	ff                   	(bad)  
    1066:	ff 66 85             	jmp    *-0x7b(%esi)
	if (cmdline_find_option_bool("debug"))
    1069:	c0 75 e1 80          	shlb   $0x80,-0x1f(%ebp)
	if (boot_params.hdr.loadflags & CAN_USE_HEAP) {
    106d:	3e 81 3b 00 79 27 67 	cmpl   $0x67277900,%ds:(%ebx)
		asm("leal %P1(%%esp),%0"
    1074:	66 8d 94 24 00 fc ff 	lea    -0x400(%esp),%dx
    107b:	ff 
			((size_t)boot_params.hdr.heap_end_ptr + 0x200);
    107c:	66 0f b7 06          	movzww (%esi),%ax
    1080:	94                   	xchg   %eax,%esp
    1081:	3b 66 05             	cmp    0x5(%esi),%esp
    1084:	00 02                	add    %al,(%edx)
    1086:	00 00                	add    %al,(%eax)
		if (heap_end > stack_end)
    1088:	66 39 c2             	cmp    %ax,%dx
    108b:	72 06                	jb     1093 <SYSSEG+0x93>
		heap_end = (char *)
    108d:	66 a3 c0 35 eb 13    	mov    %ax,0x13eb35c0
			heap_end = stack_end;
    1093:	66 89 16             	mov    %dx,(%esi)
    1096:	c0 35 eb 0c 66 b8 77 	shlb   $0x77,0xb8660ceb
		puts("WARNING: Ancient bootloader, some functionality "
    109d:	32 00                	xor    (%eax),%al
    109f:	00 66 e8             	add    %ah,-0x18(%esi)
    10a2:	17                   	pop    %ss
    10a3:	f3 ff                	repz (bad) 
    10a5:	ff 66 e8             	jmp    *-0x18(%esi)

	/* End of heap check */
	init_heap();

	/* Make sure we have all the proper CPU support */
	if (validate_cpu()) {
    10a8:	99                   	cltd   
    10a9:	f6 ff                	idiv   %bh
    10ab:	ff 66 85             	jmp    *-0x7b(%esi)
    10ae:	c0 74 12 66 b8       	shlb   $0xb8,0x66(%edx,%edx,1)
		puts("Unable to boot - please use a kernel appropriate "
    10b3:	b8 32 00 00 66       	mov    $0x66000032,%eax
    10b8:	e8 00 f3 ff ff       	call   3bd <puts>
		     "for your CPU.\n");
		die();
    10bd:	66 e8 0e f2          	callw  2cf <setup_bad+0xa>
    10c1:	ff                   	(bad)  
    10c2:	ff 67 66             	jmp    *0x66(%edi)
	initregs(&ireg);
    10c5:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    10c9:	66 e8 df 09          	callw  1aac <printf+0x3c>
    10cd:	00 00                	add    %al,(%eax)
	ireg.ax = 0xec00;
    10cf:	67 c7 44 24 48 00 ec 	movl   $0x67ec0048,0x24(%si)
    10d6:	67 
	ireg.bx = 2;
    10d7:	c7 44 24 3c 02 00 66 	movl   $0x31660002,0x3c(%esp)
    10de:	31 
	intcall(0x15, &ireg, NULL);
    10df:	c9                   	leave  
    10e0:	67 66 8d 54 24       	lea    0x24(%si),%dx
    10e5:	2c 66                	sub    $0x66,%al
    10e7:	b8 15 00 00 00       	mov    $0x15,%eax
    10ec:	66 e8 e2 f1          	callw  2d2 <die+0x1>
    10f0:	ff                   	(bad)  
    10f1:	ff 66 e8             	jmp    *-0x18(%esi)

	/* Tell the BIOS what CPU mode we intend to run in. */
	set_bios_mode();

	/* Detect memory layout */
	detect_memory();
    10f4:	b0 00                	mov    $0x0,%al
    10f6:	00 00                	add    %al,(%eax)
	initregs(&ireg);
    10f8:	66 89 e0             	mov    %sp,%ax
    10fb:	66 e8 ad 09          	callw  1aac <printf+0x3c>
    10ff:	00 00                	add    %al,(%eax)
	ireg.ah = 0x02;		/* Get keyboard status */
    1101:	67 c6 44 24 1d       	movb   $0x1d,0x24(%si)
    1106:	02 67 66             	add    0x66(%edi),%ah
	intcall(0x16, &ireg, &oreg);
    1109:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    110d:	66 89 e2             	mov    %sp,%dx
    1110:	66 b8 16 00          	mov    $0x16,%ax
    1114:	00 00                	add    %al,(%eax)
    1116:	66 e8 b8 f1          	callw  2d2 <die+0x1>
    111a:	ff                   	(bad)  
    111b:	ff 67 8a             	jmp    *-0x76(%edi)
	boot_params.kbd_status = oreg.al;
    111e:	44                   	inc    %esp
    111f:	24 48                	and    $0x48,%al
    1121:	a2 5b 3b 67 c7       	mov    %al,0xc7673b5b
	ireg.ax = 0x0305;	/* Set keyboard repeat rate */
    1126:	44                   	inc    %esp
    1127:	24 1c                	and    $0x1c,%al
    1129:	05 03 66 31 c9       	add    $0xc9316603,%eax
	intcall(0x16, &ireg, NULL);
    112e:	66 89 e2             	mov    %sp,%dx
    1131:	66 b8 16 00          	mov    $0x16,%ax
    1135:	00 00                	add    %al,(%eax)
    1137:	66 e8 97 f1          	callw  2d2 <die+0x1>
    113b:	ff                   	(bad)  
    113c:	ff 66 83             	jmp    *-0x7d(%esi)
	if (cpu.level < 6)
    113f:	3e 00 39             	add    %bh,%ds:(%ecx)
    1142:	05 7e 57 66 89       	add    $0x8966577e,%eax
	initregs(&ireg);
    1147:	e0 66                	loopne 11af <detect_memory+0x7>
    1149:	e8 60 09 00 00       	call   1aae <initregs>
	ireg.ax  = 0xe980;	 /* IST Support */
    114e:	67 c7 44 24 1c 80 e9 	movl   $0x67e9801c,0x24(%si)
    1155:	67 
	ireg.edx = 0x47534943;	 /* Request value */
    1156:	66 c7 44 24 14 43 49 	movw   $0x4943,0x14(%esp)
    115d:	53                   	push   %ebx
    115e:	47                   	inc    %edi
	intcall(0x15, &ireg, &oreg);
    115f:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    1164:	2c 66                	sub    $0x66,%al
    1166:	89 e2                	mov    %esp,%edx
    1168:	66 b8 15 00          	mov    $0x15,%ax
    116c:	00 00                	add    %al,(%eax)
    116e:	66 e8 60 f1          	callw  2d2 <die+0x1>
    1172:	ff                   	(bad)  
    1173:	ff 67 66             	jmp    *0x66(%edi)
	boot_params.ist_info.signature  = oreg.eax;
    1176:	8b 44 24 48          	mov    0x48(%esp),%eax
    117a:	66 a3 d0 39 67 66    	mov    %ax,0x666739d0
	boot_params.ist_info.command    = oreg.ebx;
    1180:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    1184:	66 a3 d4 39 67 66    	mov    %ax,0x666739d4
	boot_params.ist_info.event      = oreg.ecx;
    118a:	8b 44 24 44          	mov    0x44(%esp),%eax
    118e:	66 a3 d8 39 67 66    	mov    %ax,0x666739d8
	boot_params.ist_info.perf_level = oreg.edx;
    1194:	8b 44 24 40          	mov    0x40(%esp),%eax
    1198:	66 a3 dc 39 66 e8    	mov    %ax,0xe86639dc
#if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
	query_edd();
#endif

	/* Set the video mode */
	set_video();
    119e:	d5 0f                	aad    $0xf
    11a0:	00 00                	add    %al,(%eax)

	/* Do the last things and invoke protected mode */
	go_to_protected_mode();
    11a2:	66 e8 46 01          	callw  12ec <detect_memory+0x144>
	...

000011a8 <detect_memory>:

	boot_params.screen_info.ext_mem_k = oreg.ax;
}

void detect_memory(void)
{
    11a8:	66 57                	push   %di
    11aa:	66 56                	push   %si
    11ac:	66 53                	push   %bx
    11ae:	66 83 ec 58          	sub    $0x58,%sp
	initregs(&ireg);
    11b2:	66 89 e0             	mov    %sp,%ax
    11b5:	66 e8 f3 08          	callw  1aac <printf+0x3c>
    11b9:	00 00                	add    %al,(%eax)
	ireg.ax  = 0xe820;
    11bb:	67 c7 44 24 1c 20 e8 	movl   $0x67e8201c,0x24(%si)
    11c2:	67 
	ireg.cx  = sizeof(buf);
    11c3:	c7 44 24 18 14 00 67 	movl   $0x66670014,0x18(%esp)
    11ca:	66 
	ireg.edx = SMAP;
    11cb:	c7 44 24 14 50 41 4d 	movl   $0x534d4150,0x14(%esp)
    11d2:	53 
	ireg.di  = (size_t)&buf;
    11d3:	66 b8 b0 36          	mov    $0x36b0,%ax
    11d7:	00 00                	add    %al,(%eax)
    11d9:	67 89 04             	mov    %eax,(%si)
    11dc:	24 66                	and    $0x66,%al
	int count = 0;
    11de:	31 db                	xor    %ebx,%ebx
		intcall(0x15, &ireg, &oreg);
    11e0:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    11e5:	2c 66                	sub    $0x66,%al
    11e7:	89 e2                	mov    %esp,%edx
    11e9:	66 b8 15 00          	mov    $0x15,%ax
    11ed:	00 00                	add    %al,(%eax)
    11ef:	66 e8 df f0          	callw  2d2 <die+0x1>
    11f3:	ff                   	(bad)  
    11f4:	ff 67 66             	jmp    *0x66(%edi)
		ireg.ebx = oreg.ebx; /* for next iteration... */
    11f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    11fb:	67 66 89 44 24       	mov    %ax,0x24(%si)
    1200:	10 67 f6             	adc    %ah,-0xa(%edi)
		if (oreg.eflags & X86_EFLAGS_CF)
    1203:	44                   	inc    %esp
    1204:	24 54                	and    $0x54,%al
    1206:	01 75 3b             	add    %esi,0x3b(%ebp)
		if (oreg.eax != SMAP) {
    1209:	67 66 81 7c 24 48 50 	cmpw   $0x5048,0x24(%si)
    1210:	41                   	inc    %ecx
    1211:	4d                   	dec    %ebp
    1212:	53                   	push   %ebx
    1213:	75 2c                	jne    1241 <detect_memory+0x99>
		*desc++ = buf;
    1215:	66 6b fb 14          	imul   $0x14,%bx,%di
    1219:	66 81 c7 40 3c       	add    $0x3c40,%di
    121e:	00 00                	add    %al,(%eax)
    1220:	66 be b0 36          	mov    $0x36b0,%si
    1224:	00 00                	add    %al,(%eax)
    1226:	66 b9 05 00          	mov    $0x5,%cx
    122a:	00 00                	add    %al,(%eax)
    122c:	66 f3 a5             	rep movsw %ds:(%esi),%es:(%edi)
		count++;
    122f:	66 43                	inc    %bx
	} while (ireg.ebx && count < ARRAY_SIZE(boot_params.e820_table));
    1231:	66 85 c0             	test   %ax,%ax
    1234:	74 0e                	je     1244 <detect_memory+0x9c>
    1236:	66 81 fb 80 00       	cmp    $0x80,%bx
    123b:	00 00                	add    %al,(%eax)
    123d:	75 a1                	jne    11e0 <detect_memory+0x38>
    123f:	eb 03                	jmp    1244 <detect_memory+0x9c>
			count = 0;
    1241:	66 31 db             	xor    %bx,%bx
	boot_params.e820_entries = count;
    1244:	88 1e                	mov    %bl,(%esi)
    1246:	58                   	pop    %eax
    1247:	3b 66 89             	cmp    -0x77(%esi),%esp
	initregs(&ireg);
    124a:	e0 66                	loopne 12b2 <detect_memory+0x10a>
    124c:	e8 5d 08 00 00       	call   1aae <initregs>
	ireg.ax = 0xe801;
    1251:	67 c7 44 24 1c 01 e8 	movl   $0x67e8011c,0x24(%si)
    1258:	67 
	intcall(0x15, &ireg, &oreg);
    1259:	66 8d 4c 24 2c       	lea    0x2c(%esp),%cx
    125e:	66 89 e2             	mov    %sp,%dx
    1261:	66 b8 15 00          	mov    $0x15,%ax
    1265:	00 00                	add    %al,(%eax)
    1267:	66 e8 67 f0          	callw  2d2 <die+0x1>
    126b:	ff                   	(bad)  
    126c:	ff 67 f6             	jmp    *-0xa(%edi)
	if (oreg.eflags & X86_EFLAGS_CF)
    126f:	44                   	inc    %esp
    1270:	24 54                	and    $0x54,%al
    1272:	01 75 40             	add    %esi,0x40(%ebp)
	if (oreg.cx || oreg.dx) {
    1275:	67 66 8b 54 24       	mov    0x24(%si),%dx
    127a:	44                   	inc    %esp
    127b:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1280:	40                   	inc    %eax
    1281:	66 89 d6             	mov    %dx,%si
    1284:	09 c6                	or     %eax,%esi
    1286:	74 0a                	je     1292 <detect_memory+0xea>
		oreg.ax = oreg.cx;
    1288:	67 89 54 24          	mov    %edx,0x24(%si)
    128c:	48                   	dec    %eax
		oreg.bx = oreg.dx;
    128d:	67 89 44 24          	mov    %eax,0x24(%si)
    1291:	3c 67                	cmp    $0x67,%al
	if (oreg.ax > 15*1024) {
    1293:	66 0f b7 44 24 48    	movzww 0x48(%esp),%ax
    1299:	3d 00 3c 77 17       	cmp    $0x17773c00,%eax
	} else if (oreg.ax == 15*1024) {
    129e:	75 11                	jne    12b1 <detect_memory+0x109>
		boot_params.alt_mem_k = (oreg.bx << 6) + oreg.ax;
    12a0:	67 66 0f b7 44 24    	movzww 0x24(%si),%ax
    12a6:	3c 66                	cmp    $0x66,%al
    12a8:	c1 e0 06             	shl    $0x6,%eax
    12ab:	66 05 00 3c          	add    $0x3c00,%ax
    12af:	00 00                	add    %al,(%eax)
    12b1:	66 a3 50 3b 66 89    	mov    %ax,0x89663b50
	initregs(&ireg);
    12b7:	e0 66                	loopne 131f <go_to_protected_mode+0x31>
    12b9:	e8 f0 07 00 00       	call   1aae <initregs>
	ireg.ah = 0x88;
    12be:	67 c6 44 24 1d       	movb   $0x1d,0x24(%si)
    12c3:	88 67 66             	mov    %ah,0x66(%edi)
	intcall(0x15, &ireg, &oreg);
    12c6:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    12ca:	66 89 e2             	mov    %sp,%dx
    12cd:	66 b8 15 00          	mov    $0x15,%ax
    12d1:	00 00                	add    %al,(%eax)
    12d3:	66 e8 fb ef          	callw  2d2 <die+0x1>
    12d7:	ff                   	(bad)  
    12d8:	ff 67 66             	jmp    *0x66(%edi)
	boot_params.screen_info.ext_mem_k = oreg.ax;
    12db:	8b 44 24 48          	mov    0x48(%esp),%eax
    12df:	a3 72 39 66 83       	mov    %eax,0x83663972
	detect_memory_e820();

	detect_memory_e801();

	detect_memory_88();
}
    12e4:	c4 58 66             	les    0x66(%eax),%ebx
    12e7:	5b                   	pop    %ebx
    12e8:	66 5e                	pop    %si
    12ea:	66 5f                	pop    %di
    12ec:	66 c3                	retw   

000012ee <go_to_protected_mode>:

/*
 * Actual invocation sequence
 */
void go_to_protected_mode(void)
{
    12ee:	66 53                	push   %bx
	if (boot_params.hdr.realmode_swtch) {
    12f0:	66 83 3e 78          	cmpw   $0x78,(%esi)
    12f4:	3b 00                	cmp    (%eax),%eax
    12f6:	74 06                	je     12fe <go_to_protected_mode+0x10>
		asm volatile("lcallw *%0"
    12f8:	ff 1e                	lcall  *(%esi)
    12fa:	78 3b                	js     1337 <go_to_protected_mode+0x49>
    12fc:	eb 07                	jmp    1305 <go_to_protected_mode+0x17>
		asm volatile("cli");
    12fe:	fa                   	cli    
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    12ff:	b0 80                	mov    $0x80,%al
    1301:	e6 70                	out    %al,$0x70
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
    1303:	e6 80                	out    %al,$0x80
	/* Hook before leaving real mode, also disables interrupts */
	realmode_switch_hook();

	/* Enable the A20 gate */
	if (enable_a20()) {
    1305:	66 e8 66 f1          	callw  46f <a20_test+0x41>
    1309:	ff                   	(bad)  
    130a:	ff 66 85             	jmp    *-0x7b(%esi)
    130d:	c0 74 12 66 b8       	shlb   $0xb8,0x66(%edx,%edx,1)
		puts("A20 gate not responding, unable to boot...\n");
    1312:	f8                   	clc    
    1313:	32 00                	xor    (%eax),%al
    1315:	00 66 e8             	add    %ah,-0x18(%esi)
    1318:	a1 f0 ff ff 66       	mov    0x66fffff0,%eax
		die();
    131d:	e8 af ef ff ff       	call   2d1 <die>
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    1322:	66 31 c0             	xor    %ax,%ax
    1325:	e6 f0                	out    %al,$0xf0
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
    1327:	e6 80                	out    %al,$0x80
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    1329:	e6 f1                	out    %al,$0xf1
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
    132b:	e6 80                	out    %al,$0x80
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    132d:	b0 ff                	mov    $0xff,%al
    132f:	e6 a1                	out    %al,$0xa1
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
    1331:	e6 80                	out    %al,$0x80
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    1333:	b0 fb                	mov    $0xfb,%al
    1335:	e6 21                	out    %al,$0x21
	asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
    1337:	e6 80                	out    %al,$0x80
	asm volatile("lidtl %0" : : "m" (null_idt));
    1339:	66 0f 01 1e          	lidtw  (%esi)
    133d:	58                   	pop    %eax
    133e:	33 c7                	xor    %edi,%eax
	gdt.len = sizeof(boot_gdt)-1;
    1340:	06                   	push   %es
    1341:	c4 36                	les    (%esi),%esi
    1343:	27                   	daa    
    1344:	00 8c da 66 0f b7 d2 	add    %cl,-0x2d48f09a(%edx,%ebx,8)
	gdt.ptr = (u32)&boot_gdt + (ds() << 4);
    134b:	66 c1 e2 04          	shl    $0x4,%dx
    134f:	67 66 8d 82 30 33    	lea    0x3330(%bp,%si),%ax
    1355:	00 00                	add    %al,(%eax)
    1357:	66 a3 c6 36 66 0f    	mov    %ax,0xf6636c6
	asm volatile("lgdtl %0" : : "m" (gdt));
    135d:	01 16                	add    %edx,(%esi)
    135f:	c4 36                	les    (%esi),%esi
	mask_all_interrupts();

	/* Actual transition to protected mode... */
	setup_idt();
	setup_gdt();
	protected_mode_jump(boot_params.hdr.code32_start,
    1361:	66 81 c2 70 39       	add    $0x3970,%dx
    1366:	00 00                	add    %al,(%eax)
    1368:	66 a1 84 3b 66 e8    	mov    0xe8663b84,%ax
    136e:	00 00                	add    %al,(%eax)
	...

00001372 <protected_mode_jump>:

/*
 * void protected_mode_jump(u32 entrypoint, u32 bootparams);
 */
SYM_FUNC_START_NOALIGN(protected_mode_jump)
	movl	%edx, %esi		# Pointer to boot_params table
    1372:	66 89 d6             	mov    %dx,%si

	xorl	%ebx, %ebx
    1375:	66 31 db             	xor    %bx,%bx
	movw	%cs, %bx
    1378:	8c cb                	mov    %cs,%ebx
	shll	$4, %ebx
    137a:	66 c1 e3 04          	shl    $0x4,%bx
	addl	%ebx, 2f
    137e:	66 01 1e             	add    %bx,(%esi)
    1381:	96                   	xchg   %eax,%esi
    1382:	13 eb                	adc    %ebx,%ebp
	jmp	1f			# Short jump to serialize on 386/486
    1384:	00 b9 18 00 bf 20    	add    %bh,0x20bf0018(%ecx)
1:

	movw	$__BOOT_DS, %cx
	movw	$__BOOT_TSS, %di
    138a:	00 0f                	add    %cl,(%edi)

	movl	%cr0, %edx
    138c:	20 c2                	and    %al,%dl
	orb	$X86_CR0_PE, %dl	# Protected mode
    138e:	80 ca 01             	or     $0x1,%dl
	movl	%edx, %cr0
    1391:	0f 22 c2             	mov    %edx,%cr0
    1394:	66 ea 14 30 00 00    	ljmpw  $0x0,$0x3014
    139a:	10 00                	adc    %al,(%eax)

0000139c <number>:
n = ((unsigned long) n) / (unsigned) base; \
__res; })

static char *number(char *str, long num, int base, int size, int precision,
		    int type)
{
    139c:	66 55                	push   %bp
    139e:	66 57                	push   %di
    13a0:	66 56                	push   %si
    13a2:	66 53                	push   %bx
    13a4:	66 83 ec 5c          	sub    $0x5c,%sp
    13a8:	66 89 c3             	mov    %ax,%bx
    13ab:	67 66 89 14          	mov    %dx,(%si)
    13af:	24 67                	and    $0x67,%al
    13b1:	66 89 4c 24 04       	mov    %cx,0x4(%esp)
    13b6:	67 66 8b 6c 24       	mov    0x24(%si),%bp
    13bb:	70 67                	jo     1424 <number+0x88>
    13bd:	66 8b 7c 24 78       	mov    0x78(%esp),%di
	char c, sign, locase;
	int i;

	/* locase = 0 or 0x20. ORing digits or letters with 'locase'
	 * produces same digits or (maybe lowercased) letters */
	locase = (type & SMALL);
    13c2:	66 89 f9             	mov    %di,%cx
    13c5:	66 83 e1 20          	and    $0x20,%cx
    13c9:	67 88 4c 24          	mov    %cl,0x24(%si)
    13cd:	0b 66 89             	or     -0x77(%esi),%esp
	if (type & LEFT)
    13d0:	f8                   	clc    
    13d1:	66 83 e0 10          	and    $0x10,%ax
    13d5:	67 66 89 44 24       	mov    %ax,0x24(%si)
    13da:	0c 74                	or     $0x74,%al
    13dc:	06                   	push   %es
		type &= ~ZEROPAD;
    13dd:	66 83 e7 fe          	and    $0xfffe,%di
	if (base < 2 || base > 16)
		return NULL;
	c = (type & ZEROPAD) ? '0' : ' ';
    13e1:	eb 0f                	jmp    13f2 <number+0x56>
    13e3:	67 c6 44 24 0a       	movb   $0xa,0x24(%si)
    13e8:	30 66 f7             	xor    %ah,-0x9(%esi)
    13eb:	c7 01 00 00 00 75    	movl   $0x75000000,(%ecx)
    13f1:	06                   	push   %es
    13f2:	67 c6 44 24 0a       	movb   $0xa,0x24(%si)
    13f7:	20 66 31             	and    %ah,0x31(%esi)
	sign = 0;
    13fa:	f6 66 f7             	mulb   -0x9(%esi)
	if (type & SIGN) {
    13fd:	c7 02 00 00 00 74    	movl   $0x74000000,(%edx)
    1403:	3b 67 66             	cmp    0x66(%edi),%esp
		if (num < 0) {
    1406:	83 3c 24 00          	cmpl   $0x0,(%esp)
    140a:	79 0f                	jns    141b <number+0x7f>
			sign = '-';
			num = -num;
    140c:	67 66 f7 1c          	negw   (%si)
    1410:	24 66                	and    $0x66,%al
			size--;
    1412:	4d                   	dec    %ebp
			sign = '-';
    1413:	66 be 2d 00          	mov    $0x2d,%si
    1417:	00 00                	add    %al,(%eax)
    1419:	eb 24                	jmp    143f <number+0xa3>
		} else if (type & PLUS) {
    141b:	66 f7 c7 04 00       	test   $0x4,%di
    1420:	00 00                	add    %al,(%eax)
    1422:	74 0a                	je     142e <number+0x92>
			sign = '+';
			size--;
    1424:	66 4d                	dec    %bp
			sign = '+';
    1426:	66 be 2b 00          	mov    $0x2b,%si
    142a:	00 00                	add    %al,(%eax)
    142c:	eb 11                	jmp    143f <number+0xa3>
		} else if (type & SPACE) {
    142e:	66 f7 c7 08 00       	test   $0x8,%di
    1433:	00 00                	add    %al,(%eax)
    1435:	74 08                	je     143f <number+0xa3>
			sign = ' ';
			size--;
    1437:	66 4d                	dec    %bp
			sign = ' ';
    1439:	66 be 20 00          	mov    $0x20,%si
    143d:	00 00                	add    %al,(%eax)
		}
	}
	if (type & SPECIAL) {
    143f:	66 89 f8             	mov    %di,%ax
    1442:	66 83 e0 40          	and    $0x40,%ax
    1446:	67 66 89 44 24       	mov    %ax,0x24(%si)
    144b:	10 74 1a 67          	adc    %dh,0x67(%edx,%ebx,1)
		if (base == 16)
    144f:	66 83 7c 24 04 10    	cmpw   $0x10,0x4(%esp)
    1455:	75 06                	jne    145d <number+0xc1>
			size -= 2;
    1457:	66 83 ed 02          	sub    $0x2,%bp
    145b:	eb 0b                	jmp    1468 <number+0xcc>
		else if (base == 8)
    145d:	67 66 83 7c 24 04    	cmpw   $0x4,0x24(%si)
    1463:	08 75 02             	or     %dh,0x2(%ebp)
			size--;
    1466:	66 4d                	dec    %bp
	}
	i = 0;
	if (num == 0)
    1468:	67 66 83 3c 24       	cmpw   $0x24,(%si)
    146d:	00 75 0e             	add    %dh,0xe(%ebp)
		tmp[i++] = '0';
    1470:	67 c6 44 24 1a       	movb   $0x1a,0x24(%si)
    1475:	30 66 b9             	xor    %ah,-0x47(%esi)
    1478:	01 00                	add    %eax,(%eax)
    147a:	00 00                	add    %al,(%eax)
    147c:	eb 3d                	jmp    14bb <number+0x11f>
	i = 0;
    147e:	66 31 c9             	xor    %cx,%cx
	else
		while (num != 0)
			tmp[i++] = (digits[__do_div(num, base)] | locase);
    1481:	67 66 8b 04          	mov    (%si),%ax
    1485:	24 67                	and    $0x67,%al
    1487:	66 89 44 24 14       	mov    %ax,0x14(%esp)
    148c:	66 31 d2             	xor    %dx,%dx
    148f:	67 66 f7 74 24       	divw   0x24(%si)
    1494:	04 67                	add    $0x67,%al
    1496:	66 89 04 24          	mov    %ax,(%esp)
    149a:	66 41                	inc    %cx
    149c:	67 8a 44 24          	mov    0x24(%si),%al
    14a0:	0b 67 0a             	or     0xa(%edi),%esp
    14a3:	82 b8 33 00 00 67 88 	cmpb   $0x88,0x67000033(%eax)
    14aa:	44                   	inc    %esp
    14ab:	0c 19                	or     $0x19,%al
		while (num != 0)
    14ad:	67 66 8b 44 24       	mov    0x24(%si),%ax
    14b2:	04 67                	add    $0x67,%al
    14b4:	66 3b 44 24 14       	cmp    0x14(%esp),%ax
    14b9:	76 c6                	jbe    1481 <number+0xe5>
	if (i > precision)
    14bb:	67 66 89 0c          	mov    %cx,(%si)
    14bf:	24 67                	and    $0x67,%al
    14c1:	66 3b 4c 24 74       	cmp    0x74(%esp),%cx
    14c6:	7d 0b                	jge    14d3 <number+0x137>
    14c8:	67 66 8b 44 24       	mov    0x24(%si),%ax
    14cd:	74 67                	je     1536 <number+0x19a>
    14cf:	66 89 04 24          	mov    %ax,(%esp)
		precision = i;
	size -= precision;
    14d3:	67 66 2b 2c          	sub    (%si),%bp
    14d7:	24 66                	and    $0x66,%al
	if (!(type & (ZEROPAD + LEFT)))
    14d9:	83 e7 11             	and    $0x11,%edi
    14dc:	75 2a                	jne    1508 <number+0x16c>
    14de:	66 31 c0             	xor    %ax,%ax
		while (size-- > 0)
    14e1:	66 89 ef             	mov    %bp,%di
    14e4:	66 29 c7             	sub    %ax,%di
    14e7:	66 85 ff             	test   %di,%di
    14ea:	7e 09                	jle    14f5 <number+0x159>
			*str++ = ' ';
    14ec:	67 c6 04 03          	movb   $0x3,(%si)
    14f0:	20 66 40             	and    %ah,0x40(%esi)
    14f3:	eb ec                	jmp    14e1 <number+0x145>
    14f5:	66 89 ef             	mov    %bp,%di
    14f8:	66 85 ed             	test   %bp,%bp
    14fb:	79 03                	jns    1500 <number+0x164>
    14fd:	66 31 ff             	xor    %di,%di
    1500:	66 01 fb             	add    %di,%bx
    1503:	66 4d                	dec    %bp
    1505:	66 29 fd             	sub    %di,%bp
	if (sign)
    1508:	66 89 f0             	mov    %si,%ax
    150b:	84 c0                	test   %al,%al
    150d:	74 05                	je     1514 <number+0x178>
		*str++ = sign;
    150f:	67 88 03             	mov    %al,(%bp,%di)
    1512:	66 43                	inc    %bx
	if (type & SPECIAL) {
    1514:	67 66 83 7c 24 10    	cmpw   $0x10,0x24(%si)
    151a:	00 74 2f 67          	add    %dh,0x67(%edi,%ebp,1)
		if (base == 8)
    151e:	66 83 7c 24 04 08    	cmpw   $0x8,0x4(%esp)
    1524:	75 08                	jne    152e <number+0x192>
			*str++ = '0';
    1526:	67 c6 03 30          	movb   $0x30,(%bp,%di)
    152a:	66 43                	inc    %bx
    152c:	eb 1e                	jmp    154c <number+0x1b0>
		else if (base == 16) {
    152e:	67 66 83 7c 24 04    	cmpw   $0x4,0x24(%si)
    1534:	10 75 15             	adc    %dh,0x15(%ebp)
			*str++ = '0';
    1537:	67 c6 03 30          	movb   $0x30,(%bp,%di)
			*str++ = ('X' | locase);
    153b:	67 8a 44 24          	mov    0x24(%si),%al
    153f:	0b 66 83             	or     -0x7d(%esi),%esp
    1542:	c8 58 67 88          	enter  $0x6758,$0x88
    1546:	43                   	inc    %ebx
    1547:	01 66 83             	add    %esp,-0x7d(%esi)
    154a:	c3                   	ret    
    154b:	02 67 66             	add    0x66(%edi),%ah
		}
	}
	if (!(type & LEFT))
    154e:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
    1553:	75 33                	jne    1588 <number+0x1ec>
    1555:	66 89 d8             	mov    %bx,%ax
    1558:	67 66 8d 3c          	lea    (%si),%di
    155c:	2b 66 89             	sub    -0x77(%esi),%esp
		while (size-- > 0)
    155f:	fe                   	(bad)  
    1560:	66 29 c6             	sub    %ax,%si
    1563:	66 85 f6             	test   %si,%si
    1566:	7e 0d                	jle    1575 <number+0x1d9>
			*str++ = c;
    1568:	66 40                	inc    %ax
    156a:	67 8a 54 24          	mov    0x24(%si),%dl
    156e:	0a 67 88             	or     -0x78(%edi),%ah
    1571:	50                   	push   %eax
    1572:	ff                   	(bad)  
    1573:	eb e8                	jmp    155d <number+0x1c1>
    1575:	66 89 ee             	mov    %bp,%si
    1578:	66 85 ed             	test   %bp,%bp
    157b:	79 03                	jns    1580 <number+0x1e4>
    157d:	66 31 f6             	xor    %si,%si
    1580:	66 01 f3             	add    %si,%bx
    1583:	66 4d                	dec    %bp
    1585:	66 29 f5             	sub    %si,%bp
    1588:	66 89 d8             	mov    %bx,%ax
	while (i < precision--)
    158b:	67 66 8b 14          	mov    (%si),%dx
    158f:	24 67                	and    $0x67,%al
    1591:	66 8d 3c 13          	lea    (%ebx,%edx,1),%di
    1595:	66 89 fe             	mov    %di,%si
    1598:	66 29 c6             	sub    %ax,%si
    159b:	66 39 f1             	cmp    %si,%cx
    159e:	7d 09                	jge    15a9 <number+0x20d>
		*str++ = '0';
    15a0:	66 40                	inc    %ax
    15a2:	67 c6 40 ff 30       	movb   $0x30,-0x1(%bx,%si)
    15a7:	eb ec                	jmp    1595 <number+0x1f9>
    15a9:	66 89 c8             	mov    %cx,%ax
    15ac:	66 31 f6             	xor    %si,%si
    15af:	67 66 3b 0c          	cmp    (%si),%cx
    15b3:	24 7f                	and    $0x7f,%al
    15b5:	0b 67 66             	or     0x66(%edi),%esp
    15b8:	8b 14 24             	mov    (%esp),%edx
    15bb:	66 29 ca             	sub    %cx,%dx
    15be:	66 89 d6             	mov    %dx,%si
    15c1:	66 01 f3             	add    %si,%bx
	while (i < precision--)
    15c4:	66 89 de             	mov    %bx,%si
	while (i-- > 0)
    15c7:	66 49                	dec    %cx
    15c9:	66 83 f9 ff          	cmp    $0xffff,%cx
    15cd:	74 0d                	je     15dc <number+0x240>
		*str++ = tmp[i];
    15cf:	66 46                	inc    %si
    15d1:	67 8a 54 0c          	mov    0xc(%si),%dl
    15d5:	1a 67 88             	sbb    -0x78(%edi),%ah
    15d8:	56                   	push   %esi
    15d9:	ff                   	(bad)  
    15da:	eb eb                	jmp    15c7 <number+0x22b>
    15dc:	66 01 c3             	add    %ax,%bx
	while (i-- > 0)
    15df:	66 31 c0             	xor    %ax,%ax
	while (size-- > 0)
    15e2:	66 89 ea             	mov    %bp,%dx
    15e5:	66 29 c2             	sub    %ax,%dx
    15e8:	66 85 d2             	test   %dx,%dx
    15eb:	7e 09                	jle    15f6 <number+0x25a>
		*str++ = ' ';
    15ed:	67 c6 04 03          	movb   $0x3,(%si)
    15f1:	20 66 40             	and    %ah,0x40(%esi)
    15f4:	eb ec                	jmp    15e2 <number+0x246>
    15f6:	66 85 ed             	test   %bp,%bp
    15f9:	79 03                	jns    15fe <number+0x262>
    15fb:	66 31 ed             	xor    %bp,%bp
    15fe:	67 66 8d 04          	lea    (%si),%ax
    1602:	2b 66 83             	sub    -0x7d(%esi),%esp
	return str;
}
    1605:	c4 5c 66 5b          	les    0x5b(%esi,%eiz,2),%ebx
    1609:	66 5e                	pop    %si
    160b:	66 5f                	pop    %di
    160d:	66 5d                	pop    %bp
    160f:	66 c3                	retw   

00001611 <vsprintf>:

int vsprintf(char *buf, const char *fmt, va_list args)
{
    1611:	66 55                	push   %bp
    1613:	66 57                	push   %di
    1615:	66 56                	push   %si
    1617:	66 53                	push   %bx
    1619:	66 83 ec 14          	sub    $0x14,%sp
    161d:	67 66 89 44 24       	mov    %ax,0x24(%si)
    1622:	08 66 89             	or     %ah,-0x77(%esi)
    1625:	c8 67 66 8b          	enter  $0x6667,$0x8b
	int field_width;	/* width of output field */
	int precision;		/* min. # of digits for integers; max
				   number of chars for from string */
	int qualifier;		/* 'h', 'l', or 'L' for integer fields */

	for (str = buf; *fmt; ++fmt) {
    1629:	5c                   	pop    %esp
    162a:	24 08                	and    $0x8,%al
    162c:	67 8a 0a             	mov    (%bp,%si),%cl
    162f:	84 c9                	test   %cl,%cl
    1631:	0f 84 06 04 80 f9    	je     f9801a3d <image_base+0xf8801a3d>
		if (*fmt != '%') {
    1637:	25 74 09 67 88       	and    $0x88670974,%eax
			*str++ = *fmt;
    163c:	0b 66 89             	or     -0x77(%esi),%esp
			continue;
    163f:	d5 e9                	aad    $0xe9
    1641:	52                   	push   %edx
    1642:	03 66 31             	add    0x31(%esi),%esp
		}

		/* process flags */
		flags = 0;
    1645:	ff 67 66             	jmp    *0x66(%edi)
	      repeat:
		++fmt;		/* this also skips first '%' */
    1648:	8d 6a 01             	lea    0x1(%edx),%ebp
		switch (*fmt) {
    164b:	67 8a 4a 01          	mov    0x1(%bp,%si),%cl
    164f:	80 f9 2b             	cmp    $0x2b,%cl
    1652:	74 2b                	je     167f <vsprintf+0x6e>
    1654:	7f 13                	jg     1669 <vsprintf+0x58>
    1656:	80 f9 20             	cmp    $0x20,%cl
    1659:	74 2a                	je     1685 <vsprintf+0x74>
    165b:	80 f9 23             	cmp    $0x23,%cl
    165e:	75 2b                	jne    168b <vsprintf+0x7a>
			goto repeat;
		case ' ':
			flags |= SPACE;
			goto repeat;
		case '#':
			flags |= SPECIAL;
    1660:	66 83 cf 40          	or     $0x40,%di
{
    1664:	66 89 ea             	mov    %bp,%dx
    1667:	eb dd                	jmp    1646 <vsprintf+0x35>
		switch (*fmt) {
    1669:	80 f9 2d             	cmp    $0x2d,%cl
    166c:	74 0b                	je     1679 <vsprintf+0x68>
    166e:	80 f9 30             	cmp    $0x30,%cl
    1671:	75 18                	jne    168b <vsprintf+0x7a>
			goto repeat;
		case '0':
			flags |= ZEROPAD;
    1673:	66 83 cf 01          	or     $0x1,%di
			goto repeat;
    1677:	eb eb                	jmp    1664 <vsprintf+0x53>
			flags |= LEFT;
    1679:	66 83 cf 10          	or     $0x10,%di
			goto repeat;
    167d:	eb e5                	jmp    1664 <vsprintf+0x53>
			flags |= PLUS;
    167f:	66 83 cf 04          	or     $0x4,%di
			goto repeat;
    1683:	eb df                	jmp    1664 <vsprintf+0x53>
			flags |= SPACE;
    1685:	66 83 cf 08          	or     $0x8,%di
			goto repeat;
    1689:	eb d9                	jmp    1664 <vsprintf+0x53>
#ifndef BOOT_CTYPE_H
#define BOOT_CTYPE_H

static inline int isdigit(int ch)
{
	return (ch >= '0') && (ch <= '9');
    168b:	66 0f be f1          	movsbw %cl,%si
    168f:	66 83 ee 30          	sub    $0x30,%si
		}

		/* get field width */
		field_width = -1;
		if (isdigit(*fmt))
    1693:	66 83 fe 09          	cmp    $0x9,%si
    1697:	77 22                	ja     16bb <vsprintf+0xaa>
	int i = 0;
    1699:	66 31 f6             	xor    %si,%si
    169c:	67 66 0f be 55 00    	movsbw 0x0(%di),%dx
    16a2:	67 66 8d 4a d0       	lea    -0x30(%bp,%si),%cx
	while (isdigit(**s))
    16a7:	66 83 f9 09          	cmp    $0x9,%cx
    16ab:	77 30                	ja     16dd <vsprintf+0xcc>
		i = i * 10 + *((*s)++) - '0';
    16ad:	66 45                	inc    %bp
    16af:	66 6b f6 0a          	imul   $0xa,%si,%si
    16b3:	67 66 8d 74 16       	lea    0x16(%si),%si
    16b8:	d0 eb                	shr    %bl
    16ba:	e1 66                	loope  1722 <vsprintf+0x111>
		field_width = -1;
    16bc:	83 ce ff             	or     $0xffffffff,%esi
			field_width = skip_atoi(&fmt);
		else if (*fmt == '*') {
    16bf:	80 f9 2a             	cmp    $0x2a,%cl
    16c2:	75 19                	jne    16dd <vsprintf+0xcc>
			++fmt;
    16c4:	67 66 8d 6a 02       	lea    0x2(%bp,%si),%bp
			/* it's the next argument */
			field_width = va_arg(args, int);
    16c9:	67 66 8b 30          	mov    (%bx,%si),%si
    16cd:	66 83 c0 04          	add    $0x4,%ax
			if (field_width < 0) {
    16d1:	66 85 f6             	test   %si,%si
    16d4:	79 07                	jns    16dd <vsprintf+0xcc>
				field_width = -field_width;
    16d6:	66 f7 de             	neg    %si
				flags |= LEFT;
    16d9:	66 83 cf 10          	or     $0x10,%di
			}
		}

		/* get the precision */
		precision = -1;
    16dd:	67 66 c7 04 24 ff    	movw   $0xff24,(%si)
    16e3:	ff                   	(bad)  
    16e4:	ff                   	(bad)  
    16e5:	ff 67 80             	jmp    *-0x80(%edi)
		if (*fmt == '.') {
    16e8:	7d 00                	jge    16ea <vsprintf+0xd9>
    16ea:	2e 0f 85 8b 00 67 66 	jne,pn 6667177c <image_base+0x6567177c>
			++fmt;
    16f1:	8d 55 01             	lea    0x1(%ebp),%edx
    16f4:	67 66 89 54 24       	mov    %dx,0x24(%si)
    16f9:	04 67                	add    $0x67,%al
			if (isdigit(*fmt))
    16fb:	66 0f be 4d 01       	movsbw 0x1(%ebp),%cx
    1700:	66 89 ca             	mov    %cx,%dx
    1703:	66 83 e9 30          	sub    $0x30,%cx
    1707:	66 83 f9 09          	cmp    $0x9,%cx
    170b:	77 2b                	ja     1738 <vsprintf+0x127>
	int i = 0;
    170d:	66 31 d2             	xor    %dx,%dx
    1710:	67 66 8b 4c 24       	mov    0x24(%si),%cx
    1715:	04 67                	add    $0x67,%al
    1717:	66 0f be 29          	movsbw (%ecx),%bp
    171b:	67 66 8d 4d d0       	lea    -0x30(%di),%cx
	while (isdigit(**s))
    1720:	66 83 f9 09          	cmp    $0x9,%cx
    1724:	77 2a                	ja     1750 <vsprintf+0x13f>
		i = i * 10 + *((*s)++) - '0';
    1726:	67 66 ff 44 24       	incw   0x24(%si)
    172b:	04 66                	add    $0x66,%al
    172d:	6b d2 0a             	imul   $0xa,%edx,%edx
    1730:	67 66 8d 54 2a       	lea    0x2a(%si),%dx
    1735:	d0 eb                	shr    %bl
    1737:	d8 80 fa 2a 75 2e    	fadds  0x2e752afa(%eax)
				precision = skip_atoi(&fmt);
			else if (*fmt == '*') {
				++fmt;
    173d:	67 66 8d 55 02       	lea    0x2(%di),%dx
    1742:	67 66 89 54 24       	mov    %dx,0x24(%si)
    1747:	04 67                	add    $0x67,%al
				/* it's the next argument */
				precision = va_arg(args, int);
    1749:	66 8b 10             	mov    (%eax),%dx
    174c:	66 83 c0 04          	add    $0x4,%ax
			}
			if (precision < 0)
    1750:	67 66 89 14          	mov    %dx,(%si)
    1754:	24 66                	and    $0x66,%al
    1756:	85 d2                	test   %edx,%edx
    1758:	79 09                	jns    1763 <vsprintf+0x152>
    175a:	67 66 c7 04 24 00    	movw   $0x24,(%si)
    1760:	00 00                	add    %al,(%eax)
    1762:	00 67 66             	add    %ah,0x66(%edi)
    1765:	8b 6c 24 04          	mov    0x4(%esp),%ebp
    1769:	eb 0f                	jmp    177a <vsprintf+0x169>
			++fmt;
    176b:	67 66 8b 6c 24       	mov    0x24(%si),%bp
    1770:	04 67                	add    $0x67,%al
				precision = 0;
    1772:	66 c7 04 24 00 00    	movw   $0x0,(%esp)
    1778:	00 00                	add    %al,(%eax)
		}

		/* get the conversion qualifier */
		qualifier = -1;
		if (*fmt == 'h' || *fmt == 'l' || *fmt == 'L') {
    177a:	67 8a 55 00          	mov    0x0(%di),%dl
    177e:	88 d1                	mov    %dl,%cl
    1780:	66 83 e1 df          	and    $0xffdf,%cx
    1784:	80 f9 4c             	cmp    $0x4c,%cl
    1787:	74 0f                	je     1798 <vsprintf+0x187>
		qualifier = -1;
    1789:	67 66 c7 44 24 04 ff 	movw   $0xff04,0x24(%si)
    1790:	ff                   	(bad)  
    1791:	ff                   	(bad)  
    1792:	ff 80 fa 68 75 0c    	incl   0xc7568fa(%eax)
			qualifier = *fmt;
    1798:	66 0f be ca          	movsbw %dl,%cx
    179c:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    17a1:	04 66                	add    $0x66,%al
			++fmt;
    17a3:	45                   	inc    %ebp
		}

		/* default base */
		base = 10;

		switch (*fmt) {
    17a4:	67 8a 55 00          	mov    0x0(%di),%dl
    17a8:	80 fa 78             	cmp    $0x78,%dl
    17ab:	0f 8f fd 01 80 fa    	jg     fa8019ae <image_base+0xf98019ae>
    17b1:	62 7f 17             	bound  %edi,0x17(%edi)
    17b4:	80 fa 25             	cmp    $0x25,%dl
    17b7:	0f 84 d6 01 66 b9    	je     b9661993 <image_base+0xb8661993>
    17bd:	10 00                	adc    %al,(%eax)
    17bf:	00 00                	add    %al,(%eax)
    17c1:	80 fa 58             	cmp    $0x58,%dl
    17c4:	0f 84 06 02 e9 e1    	je     e1e919d0 <image_base+0xe0e919d0>
    17ca:	01 66 83             	add    %esp,-0x7d(%esi)
    17cd:	ea 63 80 fa 15 0f 87 	ljmp   $0x870f,$0x15fa8063
    17d4:	d6                   	(bad)  
    17d5:	01 66 0f             	add    %esp,0xf(%esi)
    17d8:	b6 d2                	mov    $0xd2,%dh
    17da:	67 ff 24             	jmp    *(%si)
    17dd:	95                   	xchg   %eax,%ebp
    17de:	60                   	pusha  
    17df:	33 00                	xor    (%eax),%eax
    17e1:	00 66 b9             	add    %ah,-0x47(%esi)
			*str++ = '%';
			continue;

			/* integer number formats - set up the flags and "break" */
		case 'o':
			base = 8;
    17e4:	08 00                	or     %al,(%eax)
    17e6:	00 00                	add    %al,(%eax)
    17e8:	e9 e3 01 66 83       	jmp    836619d0 <image_base+0x826619d0>
			if (!(flags & LEFT))
    17ed:	e7 10                	out    %eax,$0x10
    17ef:	75 3e                	jne    182f <vsprintf+0x21e>
    17f1:	66 31 d2             	xor    %dx,%dx
				while (--field_width > 0)
    17f4:	66 42                	inc    %dx
    17f6:	66 89 f1             	mov    %si,%cx
    17f9:	66 29 d1             	sub    %dx,%cx
    17fc:	66 85 c9             	test   %cx,%cx
    17ff:	7e 08                	jle    1809 <vsprintf+0x1f8>
					*str++ = ' ';
    1801:	67 c6 44 13 ff       	movb   $0xff,0x13(%si)
    1806:	20 eb                	and    %ch,%bl
    1808:	eb 67                	jmp    1871 <vsprintf+0x260>
    180a:	66 8d 56 ff          	lea    -0x1(%esi),%dx
    180e:	66 31 c9             	xor    %cx,%cx
    1811:	66 85 f6             	test   %si,%si
    1814:	7e 03                	jle    1819 <vsprintf+0x208>
    1816:	66 89 d1             	mov    %dx,%cx
    1819:	66 01 cb             	add    %cx,%bx
    181c:	66 85 f6             	test   %si,%si
    181f:	7f 06                	jg     1827 <vsprintf+0x216>
    1821:	66 be 01 00          	mov    $0x1,%si
    1825:	00 00                	add    %al,(%eax)
    1827:	66 29 f2             	sub    %si,%dx
    182a:	67 66 8d 72 01       	lea    0x1(%bp,%si),%si
			*str++ = (unsigned char)va_arg(args, int);
    182f:	67 66 8d 50 04       	lea    0x4(%bx,%si),%dx
    1834:	67 66 8b 00          	mov    (%bx,%si),%ax
    1838:	67 88 03             	mov    %al,(%bp,%di)
			while (--field_width > 0)
    183b:	66 31 c0             	xor    %ax,%ax
    183e:	66 40                	inc    %ax
    1840:	66 89 f1             	mov    %si,%cx
    1843:	66 29 c1             	sub    %ax,%cx
    1846:	66 85 c9             	test   %cx,%cx
    1849:	7e 07                	jle    1852 <vsprintf+0x241>
				*str++ = ' ';
    184b:	67 c6 04 03          	movb   $0x3,(%si)
    184f:	20 eb                	and    %ch,%bl
    1851:	ec                   	in     (%dx),%al
    1852:	66 31 c0             	xor    %ax,%ax
    1855:	66 85 f6             	test   %si,%si
    1858:	7e 05                	jle    185f <vsprintf+0x24e>
    185a:	67 66 8d 46 ff       	lea    -0x1(%bp),%ax
    185f:	67 66 8d 5c 03       	lea    0x3(%si),%bx
    1864:	01 66 89             	add    %esp,-0x77(%esi)
			*str++ = (unsigned char)va_arg(args, int);
    1867:	d0 e9                	shr    %cl
    1869:	c8 01 67 66          	enter  $0x6701,$0x66
			s = va_arg(args, char *);
    186d:	8d 48 04             	lea    0x4(%eax),%ecx
    1870:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    1875:	0c 67                	or     $0x67,%al
    1877:	66 8b 00             	mov    (%eax),%ax
    187a:	67 66 89 44 24       	mov    %ax,0x24(%si)
    187f:	04 67                	add    $0x67,%al
			len = strnlen(s, precision);
    1881:	66 8b 14 24          	mov    (%esp),%dx
    1885:	66 e8 1e 03          	callw  1ba7 <strncmp+0x34>
    1889:	00 00                	add    %al,(%eax)
			if (!(flags & LEFT))
    188b:	66 83 e7 10          	and    $0x10,%di
    188f:	75 48                	jne    18d9 <vsprintf+0x2c8>
    1891:	66 89 da             	mov    %bx,%dx
				while (len < field_width--)
    1894:	67 66 8d 3c          	lea    (%si),%di
    1898:	33 66 89             	xor    -0x77(%esi),%esp
    189b:	f9                   	stc    
    189c:	66 29 d1             	sub    %dx,%cx
    189f:	66 39 c8             	cmp    %cx,%ax
    18a2:	7d 09                	jge    18ad <vsprintf+0x29c>
					*str++ = ' ';
    18a4:	66 42                	inc    %dx
    18a6:	67 c6 42 ff 20       	movb   $0x20,-0x1(%bp,%si)
    18ab:	eb ec                	jmp    1899 <vsprintf+0x288>
    18ad:	66 89 f1             	mov    %si,%cx
    18b0:	66 29 c1             	sub    %ax,%cx
    18b3:	66 31 d2             	xor    %dx,%dx
    18b6:	66 39 c6             	cmp    %ax,%si
    18b9:	7c 03                	jl     18be <vsprintf+0x2ad>
    18bb:	66 89 ca             	mov    %cx,%dx
    18be:	66 01 d3             	add    %dx,%bx
    18c1:	67 66 8d 7e ff       	lea    -0x1(%bp),%di
    18c6:	66 31 d2             	xor    %dx,%dx
    18c9:	66 39 c6             	cmp    %ax,%si
    18cc:	7c 06                	jl     18d4 <vsprintf+0x2c3>
    18ce:	66 f7 d9             	neg    %cx
    18d1:	66 89 ca             	mov    %cx,%dx
    18d4:	67 66 8d 34          	lea    (%si),%si
    18d8:	17                   	pop    %ss
			for (i = 0; i < len; ++i)
    18d9:	66 31 d2             	xor    %dx,%dx
    18dc:	66 39 c2             	cmp    %ax,%dx
    18df:	7d 12                	jge    18f3 <vsprintf+0x2e2>
				*str++ = *s++;
    18e1:	67 66 8b 7c 24       	mov    0x24(%si),%di
    18e6:	04 67                	add    $0x67,%al
    18e8:	8a 0c 17             	mov    (%edi,%edx,1),%cl
    18eb:	67 88 0c             	mov    %cl,(%si)
    18ee:	13 66 42             	adc    0x42(%esi),%esp
			for (i = 0; i < len; ++i)
    18f1:	eb e9                	jmp    18dc <vsprintf+0x2cb>
    18f3:	66 89 c2             	mov    %ax,%dx
    18f6:	66 85 c0             	test   %ax,%ax
    18f9:	79 03                	jns    18fe <vsprintf+0x2ed>
    18fb:	66 31 d2             	xor    %dx,%dx
    18fe:	66 01 d3             	add    %dx,%bx
    1901:	66 89 da             	mov    %bx,%dx
			while (len < field_width--)
    1904:	67 66 8d 3c          	lea    (%si),%di
    1908:	33 66 89             	xor    -0x77(%esi),%esp
    190b:	f9                   	stc    
    190c:	66 29 d1             	sub    %dx,%cx
    190f:	66 39 c8             	cmp    %cx,%ax
    1912:	7d 09                	jge    191d <vsprintf+0x30c>
				*str++ = ' ';
    1914:	66 42                	inc    %dx
    1916:	67 c6 42 ff 20       	movb   $0x20,-0x1(%bp,%si)
    191b:	eb ec                	jmp    1909 <vsprintf+0x2f8>
    191d:	66 31 d2             	xor    %dx,%dx
    1920:	66 39 c6             	cmp    %ax,%si
    1923:	7c 06                	jl     192b <vsprintf+0x31a>
    1925:	66 29 c6             	sub    %ax,%si
    1928:	66 89 f2             	mov    %si,%dx
    192b:	66 01 d3             	add    %dx,%bx
    192e:	e9 fc 00 66 83       	jmp    83661a2f <image_base+0x82661a2f>
			if (field_width == -1) {
    1933:	fe                   	(bad)  
    1934:	ff 75 0a             	pushl  0xa(%ebp)
				flags |= ZEROPAD;
    1937:	66 83 cf 01          	or     $0x1,%di
				field_width = 2 * sizeof(void *);
    193b:	66 be 08 00          	mov    $0x8,%si
    193f:	00 00                	add    %al,(%eax)
				     (unsigned long)va_arg(args, void *), 16,
    1941:	67 66 8d 48 04       	lea    0x4(%bx,%si),%cx
    1946:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    194b:	04 66                	add    $0x66,%al
			str = number(str,
    194d:	57                   	push   %edi
    194e:	67 66 ff 74 24       	pushw  0x24(%si)
    1953:	04 66                	add    $0x66,%al
    1955:	56                   	push   %esi
    1956:	66 b9 10 00          	mov    $0x10,%cx
    195a:	00 00                	add    %al,(%eax)
    195c:	67 66 8b 10          	mov    (%bx,%si),%dx
    1960:	66 89 d8             	mov    %bx,%ax
    1963:	66 e8 33 fa          	callw  139a <protected_mode_jump+0x28>
    1967:	ff                   	(bad)  
    1968:	ff 66 89             	jmp    *-0x77(%esi)
    196b:	c3                   	ret    
			continue;
    196c:	66 83 c4 0c          	add    $0xc,%sp
				     (unsigned long)va_arg(args, void *), 16,
    1970:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1975:	04 e9                	add    $0xe9,%al
			continue;
    1977:	ba 00 66 89 d9       	mov    $0xd9896600,%edx
			if (qualifier == 'l') {
    197c:	67 66 2b 4c 24       	sub    0x24(%si),%cx
    1981:	08 67 66             	or     %ah,0x66(%edi)
    1984:	8b 10                	mov    (%eax),%edx
    1986:	66 83 c0 04          	add    $0x4,%ax
				*ip = (str - buf);
    198a:	67 66 89 0a          	mov    %cx,(%bp,%si)
    198e:	e9 a2 00 67 c6       	jmp    c6671a35 <image_base+0xc5671a35>
			*str++ = '%';
    1993:	03 25 66 43 e9 99    	add    0x99e94366,%esp
			continue;
    1999:	00 66 83             	add    %ah,-0x7d(%esi)
			break;

		case 'x':
			flags |= SMALL;
    199c:	cf                   	iret   
    199d:	20 66 b9             	and    %ah,-0x47(%esi)
		case 'X':
			base = 16;
    19a0:	10 00                	adc    %al,(%eax)
    19a2:	00 00                	add    %al,(%eax)
    19a4:	eb 28                	jmp    19ce <vsprintf+0x3bd>
			break;

		case 'd':
		case 'i':
			flags |= SIGN;
    19a6:	66 83 cf 02          	or     $0x2,%di
    19aa:	eb 1c                	jmp    19c8 <vsprintf+0x3b7>
		case 'u':
			break;

		default:
			*str++ = '%';
    19ac:	67 c6 03 25          	movb   $0x25,(%bp,%di)
			if (*fmt)
    19b0:	67 8a 55 00          	mov    0x0(%di),%dl
    19b4:	84 d2                	test   %dl,%dl
    19b6:	74 0a                	je     19c2 <vsprintf+0x3b1>
				*str++ = *fmt;
    19b8:	67 88 53 01          	mov    %dl,0x1(%bp,%di)
    19bc:	66 83 c3 02          	add    $0x2,%bx
    19c0:	eb 71                	jmp    1a33 <vsprintf+0x422>
			*str++ = '%';
    19c2:	66 43                	inc    %bx
			else
				--fmt;
    19c4:	66 4d                	dec    %bp
    19c6:	eb 6b                	jmp    1a33 <vsprintf+0x422>
		base = 10;
    19c8:	66 b9 0a 00          	mov    $0xa,%cx
    19cc:	00 00                	add    %al,(%eax)
			continue;
		}
		if (qualifier == 'l')
    19ce:	67 66 8d 50 04       	lea    0x4(%bx,%si),%dx
    19d3:	67 66 89 54 24       	mov    %dx,0x24(%si)
    19d8:	0c 67                	or     $0x67,%al
    19da:	66 83 7c 24 04 6c    	cmpw   $0x6c,0x4(%esp)
    19e0:	74 2d                	je     1a0f <vsprintf+0x3fe>
			num = va_arg(args, unsigned long);
		else if (qualifier == 'h') {
    19e2:	66 89 fa             	mov    %di,%dx
    19e5:	66 83 e2 02          	and    $0x2,%dx
    19e9:	67 66 89 54 24       	mov    %dx,0x24(%si)
    19ee:	10 67 66             	adc    %ah,0x66(%edi)
    19f1:	83 7c 24 04 68       	cmpl   $0x68,0x4(%esp)
    19f6:	75 17                	jne    1a0f <vsprintf+0x3fe>
			num = (unsigned short)va_arg(args, int);
    19f8:	67 66 8b 00          	mov    (%bx,%si),%ax
			if (flags & SIGN)
				num = (short)num;
    19fc:	66 0f bf d0          	movsww %ax,%dx
			if (flags & SIGN)
    1a00:	67 66 83 7c 24 10    	cmpw   $0x10,0x24(%si)
    1a06:	00 75 0a             	add    %dh,0xa(%ebp)
			num = (unsigned short)va_arg(args, int);
    1a09:	66 0f b7 d0          	movzww %ax,%dx
    1a0d:	eb 04                	jmp    1a13 <vsprintf+0x402>
		} else if (flags & SIGN)
			num = va_arg(args, int);
    1a0f:	67 66 8b 10          	mov    (%bx,%si),%dx
		else
			num = va_arg(args, unsigned int);
		str = number(str, num, base, field_width, precision, flags);
    1a13:	66 57                	push   %di
    1a15:	67 66 ff 74 24       	pushw  0x24(%si)
    1a1a:	04 66                	add    $0x66,%al
    1a1c:	56                   	push   %esi
    1a1d:	66 89 d8             	mov    %bx,%ax
    1a20:	66 e8 76 f9          	callw  139a <protected_mode_jump+0x28>
    1a24:	ff                   	(bad)  
    1a25:	ff 66 89             	jmp    *-0x77(%esi)
    1a28:	c3                   	ret    
    1a29:	66 83 c4 0c          	add    $0xc,%sp
    1a2d:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1a32:	0c 67                	or     $0x67,%al
	for (str = buf; *fmt; ++fmt) {
    1a34:	66 8d 55 01          	lea    0x1(%ebp),%dx
    1a38:	e9 f1 fb 67 c6       	jmp    c668162e <image_base+0xc568162e>
	}
	*str = '\0';
    1a3d:	03 00                	add    (%eax),%eax
	return str - buf;
    1a3f:	66 89 d8             	mov    %bx,%ax
    1a42:	67 66 2b 44 24       	sub    0x24(%si),%ax
    1a47:	08 66 83             	or     %ah,-0x7d(%esi)
}
    1a4a:	c4 14 66             	les    (%esi,%eiz,2),%edx
    1a4d:	5b                   	pop    %ebx
    1a4e:	66 5e                	pop    %si
    1a50:	66 5f                	pop    %di
    1a52:	66 5d                	pop    %bp
    1a54:	66 c3                	retw   

00001a56 <sprintf>:
{
	va_list args;
	int i;

	va_start(args, fmt);
	i = vsprintf(buf, fmt, args);
    1a56:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    1a5b:	0c 67                	or     $0x67,%al
    1a5d:	66 8b 54 24 08       	mov    0x8(%esp),%dx
    1a62:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1a67:	04 66                	add    $0x66,%al
    1a69:	e8 a3 fb ff ff       	call   1611 <vsprintf>
	va_end(args);
	return i;
}
    1a6e:	66 c3                	retw   

00001a70 <printf>:

int printf(const char *fmt, ...)
{
    1a70:	66 53                	push   %bx
    1a72:	66 81 ec 00 04       	sub    $0x400,%sp
    1a77:	00 00                	add    %al,(%eax)
	char printf_buf[1024];
	va_list args;
	int printed;

	va_start(args, fmt);
	printed = vsprintf(printf_buf, fmt, args);
    1a79:	67 66 8d 8c 24 0c    	lea    0xc24(%si),%cx
    1a7f:	04 00                	add    $0x0,%al
    1a81:	00 67 66             	add    %ah,0x66(%edi)
    1a84:	8b 94 24 08 04 00 00 	mov    0x408(%esp),%edx
    1a8b:	66 89 e0             	mov    %sp,%ax
    1a8e:	66 e8 7d fb          	callw  160f <number+0x273>
    1a92:	ff                   	(bad)  
    1a93:	ff 66 89             	jmp    *-0x77(%esi)
    1a96:	c3                   	ret    
	va_end(args);

	puts(printf_buf);
    1a97:	66 89 e0             	mov    %sp,%ax
    1a9a:	66 e8 1d e9          	callw  3bb <putchar+0x88>
    1a9e:	ff                   	(bad)  
    1a9f:	ff 66 89             	jmp    *-0x77(%esi)

	return printed;
}
    1aa2:	d8 66 81             	fsubs  -0x7f(%esi)
    1aa5:	c4 00                	les    (%eax),%eax
    1aa7:	04 00                	add    $0x0,%al
    1aa9:	00 66 5b             	add    %ah,0x5b(%esi)
    1aac:	66 c3                	retw   

00001aae <initregs>:

#include "boot.h"
#include "string.h"

void initregs(struct biosregs *reg)
{
    1aae:	66 57                	push   %di
    1ab0:	66 89 c2             	mov    %ax,%dx
	memset(reg, 0, sizeof(*reg));
    1ab3:	66 b9 0b 00          	mov    $0xb,%cx
    1ab7:	00 00                	add    %al,(%eax)
    1ab9:	66 31 c0             	xor    %ax,%ax
    1abc:	66 89 d7             	mov    %dx,%di
    1abf:	66 f3 ab             	rep stos %ax,%es:(%edi)
	reg->eflags |= X86_EFLAGS_CF;
    1ac2:	67 66 c7 42 28 01 00 	movw   $0x1,0x28(%bp,%si)
    1ac9:	00 00                	add    %al,(%eax)
	asm("movw %%ds,%0" : "=rm" (seg));
    1acb:	8c d8                	mov    %ds,%eax
	reg->ds = ds();
    1acd:	67 89 42 26          	mov    %eax,0x26(%bp,%si)
	reg->es = ds();
    1ad1:	67 89 42 24          	mov    %eax,0x24(%bp,%si)
	asm volatile("movw %%fs,%0" : "=rm" (seg));
    1ad5:	8c e0                	mov    %fs,%eax
	reg->fs = fs();
    1ad7:	67 89 42 22          	mov    %eax,0x22(%bp,%si)
	asm volatile("movw %%gs,%0" : "=rm" (seg));
    1adb:	8c e8                	mov    %gs,%eax
	reg->gs = gs();
    1add:	67 89 42 20          	mov    %eax,0x20(%bp,%si)
}
    1ae1:	66 5f                	pop    %di
    1ae3:	66 c3                	retw   

00001ae5 <isxdigit>:
    1ae5:	67 66 8d 50 d0       	lea    -0x30(%bx,%si),%dx
}

static inline int isxdigit(int ch)
{
	if (isdigit(ch))
    1aea:	66 83 fa 09          	cmp    $0x9,%dx
    1aee:	76 15                	jbe    1b05 <isxdigit+0x20>
		return true;

	if ((ch >= 'a') && (ch <= 'f'))
		return true;

	return (ch >= 'A') && (ch <= 'F');
    1af0:	66 83 e0 df          	and    $0xffdf,%ax
    1af4:	66 83 e8 41          	sub    $0x41,%ax
    1af8:	66 83 f8 05          	cmp    $0x5,%ax
    1afc:	0f 96 c0             	setbe  %al
    1aff:	66 0f b6 c0          	movzbw %al,%ax
    1b03:	66 c3                	retw   
		return true;
    1b05:	66 b8 01 00          	mov    $0x1,%ax
    1b09:	00 00                	add    %al,(%eax)
}
    1b0b:	66 c3                	retw   

00001b0d <memcmp>:
#undef memcpy
#undef memset
#undef memcmp

int memcmp(const void *s1, const void *s2, size_t len)
{
    1b0d:	66 57                	push   %di
    1b0f:	66 56                	push   %si
	bool diff;
	asm("repe; cmpsb" CC_SET(nz)
    1b11:	66 89 c7             	mov    %ax,%di
    1b14:	66 89 d6             	mov    %dx,%si
    1b17:	f3 a6                	repz cmpsb %es:(%edi),%ds:(%esi)
	    : CC_OUT(nz) (diff), "+D" (s1), "+S" (s2), "+c" (len));
	return diff;
    1b19:	0f 95 c0             	setne  %al
    1b1c:	66 0f b6 c0          	movzbw %al,%ax
}
    1b20:	66 5e                	pop    %si
    1b22:	66 5f                	pop    %di
    1b24:	66 c3                	retw   

00001b26 <bcmp>:
    1b26:	66 57                	push   %di
    1b28:	66 56                	push   %si
    1b2a:	66 89 c7             	mov    %ax,%di
    1b2d:	66 89 d6             	mov    %dx,%si
    1b30:	f3 a6                	repz cmpsb %es:(%edi),%ds:(%esi)
    1b32:	0f 95 c0             	setne  %al
    1b35:	66 0f b6 c0          	movzbw %al,%ax
    1b39:	66 5e                	pop    %si
    1b3b:	66 5f                	pop    %di
    1b3d:	66 c3                	retw   

00001b3f <strcmp>:
{
	return memcmp(s1, s2, len);
}

int strcmp(const char *str1, const char *str2)
{
    1b3f:	66 57                	push   %di
    1b41:	66 56                	push   %si
    1b43:	66 53                	push   %bx
    1b45:	66 89 c7             	mov    %ax,%di
	const unsigned char *s1 = (const unsigned char *)str1;
	const unsigned char *s2 = (const unsigned char *)str2;
	int delta = 0;

	while (*s1 || *s2) {
    1b48:	66 31 f6             	xor    %si,%si
    1b4b:	67 8a 0c             	mov    (%si),%cl
    1b4e:	37                   	aaa    
    1b4f:	67 66 0f b6 1c       	movzbw (%si),%bx
    1b54:	32 88 c8 08 d8 74    	xor    0x74d808c8(%eax),%cl
    1b5a:	0d 66 0f b6 c1       	or     $0xc1b60f66,%eax
		delta = *s1 - *s2;
		if (delta)
    1b5f:	66 46                	inc    %si
    1b61:	66 29 d8             	sub    %bx,%ax
    1b64:	74 e5                	je     1b4b <strcmp+0xc>
    1b66:	eb 03                	jmp    1b6b <strcmp+0x2c>
			return delta;
		s1++;
		s2++;
	}
	return 0;
    1b68:	66 31 c0             	xor    %ax,%ax
}
    1b6b:	66 5b                	pop    %bx
    1b6d:	66 5e                	pop    %si
    1b6f:	66 5f                	pop    %di
    1b71:	66 c3                	retw   

00001b73 <strncmp>:

int strncmp(const char *cs, const char *ct, size_t count)
{
	unsigned char c1, c2;

	while (count) {
    1b73:	66 01 d1             	add    %dx,%cx
    1b76:	66 39 ca             	cmp    %cx,%dx
    1b79:	75 05                	jne    1b80 <strncmp+0xd>
			return c1 < c2 ? -1 : 1;
		if (!c1)
			break;
		count--;
	}
	return 0;
    1b7b:	66 31 c0             	xor    %ax,%ax
}
    1b7e:	66 c3                	retw   
{
    1b80:	66 53                	push   %bx
		c1 = *cs++;
    1b82:	66 40                	inc    %ax
    1b84:	67 8a 58 ff          	mov    -0x1(%bx,%si),%bl
		c2 = *ct++;
    1b88:	66 42                	inc    %dx
		if (c1 != c2)
    1b8a:	67 3a 5a ff          	cmp    -0x1(%bp,%si),%bl
    1b8e:	74 09                	je     1b99 <strncmp+0x26>
			return c1 < c2 ? -1 : 1;
    1b90:	66 19 c0             	sbb    %ax,%ax
    1b93:	66 83 c8 01          	or     $0x1,%ax
    1b97:	eb 0c                	jmp    1ba5 <strncmp+0x32>
		if (!c1)
    1b99:	84 db                	test   %bl,%bl
    1b9b:	74 05                	je     1ba2 <strncmp+0x2f>
	while (count) {
    1b9d:	66 39 ca             	cmp    %cx,%dx
    1ba0:	75 e0                	jne    1b82 <strncmp+0xf>
	return 0;
    1ba2:	66 31 c0             	xor    %ax,%ax
}
    1ba5:	66 5b                	pop    %bx
    1ba7:	66 c3                	retw   

00001ba9 <strnlen>:

size_t strnlen(const char *s, size_t maxlen)
{
    1ba9:	66 89 c1             	mov    %ax,%cx
	const char *es = s;
	while (*es && maxlen) {
    1bac:	66 01 c2             	add    %ax,%dx
    1baf:	66 39 d0             	cmp    %dx,%ax
    1bb2:	74 0a                	je     1bbe <strnlen+0x15>
    1bb4:	67 80 38 00          	cmpb   $0x0,(%bx,%si)
    1bb8:	74 04                	je     1bbe <strnlen+0x15>
		es++;
    1bba:	66 40                	inc    %ax
		maxlen--;
    1bbc:	eb f1                	jmp    1baf <strnlen+0x6>
	}

	return (es - s);
    1bbe:	66 29 c8             	sub    %cx,%ax
}
    1bc1:	66 c3                	retw   

00001bc3 <atou>:

unsigned int atou(const char *s)
{
    1bc3:	66 53                	push   %bx
    1bc5:	66 89 c2             	mov    %ax,%dx
	unsigned int i = 0;
    1bc8:	66 31 c0             	xor    %ax,%ax
	return (ch >= '0') && (ch <= '9');
    1bcb:	67 66 0f be 0a       	movsbw (%bp,%si),%cx
    1bd0:	67 66 8d 59 d0       	lea    -0x30(%bx,%di),%bx
	while (isdigit(*s))
    1bd5:	66 83 fb 09          	cmp    $0x9,%bx
    1bd9:	77 0e                	ja     1be9 <atou+0x26>
		i = i * 10 + (*s++ - '0');
    1bdb:	66 42                	inc    %dx
    1bdd:	66 6b c0 0a          	imul   $0xa,%ax,%ax
    1be1:	67 66 8d 44 01       	lea    0x1(%si),%ax
    1be6:	d0 eb                	shr    %bl
    1be8:	e2 66                	loop   1c50 <simple_strtoull+0x63>
	return i;
}
    1bea:	5b                   	pop    %ebx
    1beb:	66 c3                	retw   

00001bed <simple_strtoull>:
 * @cp: The start of the string
 * @endp: A pointer to the end of the parsed string will be placed here
 * @base: The number base to use
 */
unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
{
    1bed:	66 55                	push   %bp
    1bef:	66 89 e5             	mov    %sp,%bp
    1bf2:	66 57                	push   %di
    1bf4:	66 56                	push   %si
    1bf6:	66 53                	push   %bx
    1bf8:	66 83 ec 0c          	sub    $0xc,%sp
    1bfc:	66 89 c6             	mov    %ax,%si
    1bff:	67 66 89 14          	mov    %dx,(%si)
    1c03:	24 67                	and    $0x67,%al
	unsigned long long result = 0;

	if (!base)
    1c05:	8a 00                	mov    (%eax),%al
    1c07:	66 85 c9             	test   %cx,%cx
    1c0a:	75 2f                	jne    1c3b <simple_strtoull+0x4e>
		return 10;
    1c0c:	66 bf 0a 00          	mov    $0xa,%di
    1c10:	00 00                	add    %al,(%eax)
	if (cp[0] == '0') {
    1c12:	3c 30                	cmp    $0x30,%al
    1c14:	75 48                	jne    1c5e <simple_strtoull+0x71>
		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
    1c16:	67 8a 46 01          	mov    0x1(%bp),%al
    1c1a:	66 83 c8 20          	or     $0x20,%ax
			return 8;
    1c1e:	66 bf 08 00          	mov    $0x8,%di
    1c22:	00 00                	add    %al,(%eax)
		if (TOLOWER(cp[1]) == 'x' && isxdigit(cp[2]))
    1c24:	3c 78                	cmp    $0x78,%al
    1c26:	75 36                	jne    1c5e <simple_strtoull+0x71>
    1c28:	67 66 0f be 46 02    	movsbw 0x2(%bp),%ax
    1c2e:	66 e8 b1 fe          	callw  1ae3 <initregs+0x35>
    1c32:	ff                   	(bad)  
    1c33:	ff 66 85             	jmp    *-0x7b(%esi)
    1c36:	c0 75 1b eb          	shlb   $0xeb,0x1b(%ebp)
    1c3a:	23 66 89             	and    -0x77(%esi),%esp
    1c3d:	cf                   	iret   
		base = simple_guess_base(cp);

	if (base == 16 && cp[0] == '0' && TOLOWER(cp[1]) == 'x')
    1c3e:	66 83 f9 10          	cmp    $0x10,%cx
    1c42:	75 1a                	jne    1c5e <simple_strtoull+0x71>
    1c44:	3c 30                	cmp    $0x30,%al
    1c46:	75 16                	jne    1c5e <simple_strtoull+0x71>
    1c48:	67 8a 46 01          	mov    0x1(%bp),%al
    1c4c:	66 83 c8 20          	or     $0x20,%ax
    1c50:	3c 78                	cmp    $0x78,%al
    1c52:	75 0a                	jne    1c5e <simple_strtoull+0x71>
		cp += 2;
    1c54:	66 83 c6 02          	add    $0x2,%si
    1c58:	66 bf 10 00          	mov    $0x10,%di
    1c5c:	00 00                	add    %al,(%eax)
			return 8;
    1c5e:	67 66 c7 44 24 04 00 	movw   $0x4,0x24(%si)
    1c65:	00 00                	add    %al,(%eax)
    1c67:	00 67 66             	add    %ah,0x66(%edi)
    1c6a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
    1c71:	00 

	while (isxdigit(*cp)) {
    1c72:	67 66 0f be 0e 66 89 	movsbw -0x769a,%cx
    1c79:	cb                   	lret   
    1c7a:	66 89 c8             	mov    %cx,%ax
    1c7d:	66 e8 62 fe          	callw  1ae3 <initregs+0x35>
    1c81:	ff                   	(bad)  
    1c82:	ff 66 85             	jmp    *-0x7b(%esi)
    1c85:	c0 74 4a 66 83       	shlb   $0x83,0x66(%edx,%ecx,2)
    1c8a:	e9 30 66 83 f9       	jmp    f98382bf <image_base+0xf88382bf>
		unsigned int value;

		value = isdigit(*cp) ? *cp - '0' : TOLOWER(*cp) - 'a' + 10;
    1c8f:	09 76 0c             	or     %esi,0xc(%esi)
    1c92:	66 83 cb 20          	or     $0x20,%bx
    1c96:	66 0f be cb          	movsbw %bl,%cx
    1c9a:	66 83 e9 57          	sub    $0x57,%cx
		if (value >= base)
    1c9e:	66 39 f9             	cmp    %di,%cx
    1ca1:	73 2f                	jae    1cd2 <simple_strtoull+0xe5>
			break;
		result = result * base + value;
    1ca3:	67 66 8b 5c 24       	mov    0x24(%si),%bx
    1ca8:	08 66 0f             	or     %ah,0xf(%esi)
    1cab:	af                   	scas   %es:(%edi),%eax
    1cac:	df 67 66             	fbld   0x66(%edi)
    1caf:	8b 44 24 04          	mov    0x4(%esp),%eax
    1cb3:	66 f7 e7             	mul    %di
    1cb6:	66 01 da             	add    %bx,%dx
    1cb9:	66 31 db             	xor    %bx,%bx
    1cbc:	66 01 c1             	add    %ax,%cx
    1cbf:	66 11 d3             	adc    %dx,%bx
    1cc2:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    1cc7:	04 67                	add    $0x67,%al
    1cc9:	66 89 5c 24 08       	mov    %bx,0x8(%esp)
		cp++;
    1cce:	66 46                	inc    %si
    1cd0:	eb a0                	jmp    1c72 <simple_strtoull+0x85>
	}
	if (endp)
    1cd2:	67 66 83 3c 24       	cmpw   $0x24,(%si)
    1cd7:	00 74 09 67          	add    %dh,0x67(%ecx,%ecx,1)
		*endp = (char *)cp;
    1cdb:	66 8b 04 24          	mov    (%esp),%ax
    1cdf:	67 66 89 30          	mov    %si,(%bx,%si)

	return result;
}
    1ce3:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1ce8:	04 67                	add    $0x67,%al
    1cea:	66 8b 54 24 08       	mov    0x8(%esp),%dx
    1cef:	66 83 c4 0c          	add    $0xc,%sp
    1cf3:	66 5b                	pop    %bx
    1cf5:	66 5e                	pop    %si
    1cf7:	66 5f                	pop    %di
    1cf9:	66 5d                	pop    %bp
    1cfb:	66 c3                	retw   

00001cfd <simple_strtol>:

long simple_strtol(const char *cp, char **endp, unsigned int base)
{
	if (*cp == '-')
    1cfd:	67 80 38 2d          	cmpb   $0x2d,(%bx,%si)
    1d01:	75 0d                	jne    1d10 <simple_strtol+0x13>
		return -simple_strtoull(cp + 1, endp, base);
    1d03:	66 40                	inc    %ax
    1d05:	66 e8 e2 fe          	callw  1beb <atou+0x28>
    1d09:	ff                   	(bad)  
    1d0a:	ff 66 f7             	jmp    *-0x9(%esi)
    1d0d:	d8 66 c3             	fsubs  -0x3d(%esi)

	return simple_strtoull(cp, endp, base);
    1d10:	66 e8 d7 fe          	callw  1beb <atou+0x28>
    1d14:	ff                   	(bad)  
    1d15:	ff 66 c3             	jmp    *-0x3d(%esi)

00001d18 <strlen>:
/**
 * strlen - Find the length of a string
 * @s: The string to be sized
 */
size_t strlen(const char *s)
{
    1d18:	66 89 c2             	mov    %ax,%dx
	const char *sc;

	for (sc = s; *sc != '\0'; ++sc)
    1d1b:	67 80 38 00          	cmpb   $0x0,(%bx,%si)
    1d1f:	74 04                	je     1d25 <strlen+0xd>
    1d21:	66 40                	inc    %ax
    1d23:	eb f6                	jmp    1d1b <strlen+0x3>
		/* nothing */;
	return sc - s;
    1d25:	66 29 d0             	sub    %dx,%ax
}
    1d28:	66 c3                	retw   

00001d2a <strstr>:
 * strstr - Find the first substring in a %NUL terminated string
 * @s1: The string to be searched
 * @s2: The string to search for
 */
char *strstr(const char *s1, const char *s2)
{
    1d2a:	66 55                	push   %bp
    1d2c:	66 57                	push   %di
    1d2e:	66 56                	push   %si
    1d30:	66 53                	push   %bx
    1d32:	66 51                	push   %cx
    1d34:	66 89 c1             	mov    %ax,%cx
    1d37:	66 89 d5             	mov    %dx,%bp
	size_t l1, l2;

	l2 = strlen(s2);
    1d3a:	66 89 d0             	mov    %dx,%ax
    1d3d:	66 e8 d5 ff          	callw  1d16 <simple_strtol+0x19>
    1d41:	ff                   	(bad)  
    1d42:	ff 66 85             	jmp    *-0x7b(%esi)
	if (!l2)
    1d45:	c0 74 3c 66 89       	shlb   $0x89,0x66(%esp,%edi,1)
    1d4a:	c3                   	ret    
		return (char *)s1;
	l1 = strlen(s1);
    1d4b:	66 89 c8             	mov    %cx,%ax
    1d4e:	66 e8 c4 ff          	callw  1d16 <simple_strtol+0x19>
    1d52:	ff                   	(bad)  
    1d53:	ff 66 89             	jmp    *-0x77(%esi)
    1d56:	c2 67 66             	ret    $0x6667
	while (l1 >= l2) {
    1d59:	8d 04 01             	lea    (%ecx,%eax,1),%eax
    1d5c:	67 66 89 04          	mov    %ax,(%si)
    1d60:	24 67                	and    $0x67,%al
    1d62:	66 8b 04 24          	mov    (%esp),%ax
    1d66:	66 29 d0             	sub    %dx,%ax
    1d69:	66 39 da             	cmp    %bx,%dx
    1d6c:	72 11                	jb     1d7f <strstr+0x55>
		l1--;
    1d6e:	66 4a                	dec    %dx
	asm("repe; cmpsb" CC_SET(nz)
    1d70:	66 89 c7             	mov    %ax,%di
    1d73:	66 89 ee             	mov    %bp,%si
    1d76:	66 89 d9             	mov    %bx,%cx
    1d79:	f3 a6                	repz cmpsb %es:(%edi),%ds:(%esi)
		if (!memcmp(s1, s2, l2))
    1d7b:	75 e4                	jne    1d61 <strstr+0x37>
    1d7d:	eb 08                	jmp    1d87 <strstr+0x5d>
			return (char *)s1;
		s1++;
	}
	return NULL;
    1d7f:	66 31 c0             	xor    %ax,%ax
    1d82:	eb 03                	jmp    1d87 <strstr+0x5d>
		return (char *)s1;
    1d84:	66 89 c8             	mov    %cx,%ax
}
    1d87:	66 5a                	pop    %dx
    1d89:	66 5b                	pop    %bx
    1d8b:	66 5e                	pop    %si
    1d8d:	66 5f                	pop    %di
    1d8f:	66 5d                	pop    %bp
    1d91:	66 c3                	retw   

00001d93 <strchr>:
 * @s: the string to be searched
 * @c: the character to search for
 */
char *strchr(const char *s, int c)
{
	while (*s != (char)c)
    1d93:	67 8a 08             	mov    (%bx,%si),%cl
    1d96:	38 d1                	cmp    %dl,%cl
    1d98:	74 0b                	je     1da5 <strchr+0x12>
		if (*s++ == '\0')
    1d9a:	66 40                	inc    %ax
    1d9c:	84 c9                	test   %cl,%cl
    1d9e:	75 f3                	jne    1d93 <strchr>
			return NULL;
    1da0:	66 31 c0             	xor    %ax,%ax
	return (char *)s;
}
    1da3:	66 c3                	retw   
    1da5:	66 c3                	retw   

00001da7 <kstrtoull>:
 * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
 * Used as a replacement for the obsolete simple_strtoull. Return code must
 * be checked.
 */
int kstrtoull(const char *s, unsigned int base, unsigned long long *res)
{
    1da7:	66 55                	push   %bp
    1da9:	66 57                	push   %di
    1dab:	66 56                	push   %si
    1dad:	66 53                	push   %bx
    1daf:	66 83 ec 10          	sub    $0x10,%sp
    1db3:	66 89 c3             	mov    %ax,%bx
    1db6:	66 89 d5             	mov    %dx,%bp
    1db9:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    1dbe:	0c 67                	or     $0x67,%al
	if (s[0] == '+')
    1dc0:	80 38 2b             	cmpb   $0x2b,(%eax)
    1dc3:	75 02                	jne    1dc7 <kstrtoull+0x20>
		s++;
    1dc5:	66 43                	inc    %bx
	if (*base == 0) {
    1dc7:	67 8a 03             	mov    (%bp,%di),%al
    1dca:	66 85 ed             	test   %bp,%bp
    1dcd:	75 2f                	jne    1dfe <kstrtoull+0x57>
			*base = 10;
    1dcf:	66 bd 0a 00          	mov    $0xa,%bp
    1dd3:	00 00                	add    %al,(%eax)
		if (s[0] == '0') {
    1dd5:	3c 30                	cmp    $0x30,%al
    1dd7:	75 45                	jne    1e1e <kstrtoull+0x77>
	return c | 0x20;
    1dd9:	67 8a 43 01          	mov    0x1(%bp,%di),%al
    1ddd:	66 83 c8 20          	or     $0x20,%ax
				*base = 8;
    1de1:	66 bd 08 00          	mov    $0x8,%bp
    1de5:	00 00                	add    %al,(%eax)
			if (_tolower(s[1]) == 'x' && isxdigit(s[2]))
    1de7:	3c 78                	cmp    $0x78,%al
    1de9:	75 33                	jne    1e1e <kstrtoull+0x77>
    1deb:	67 66 0f be 43 02    	movsbw 0x2(%bp,%di),%ax
    1df1:	66 e8 ee fc          	callw  1ae3 <initregs+0x35>
    1df5:	ff                   	(bad)  
    1df6:	ff 66 85             	jmp    *-0x7b(%esi)
    1df9:	c0 75 18 eb          	shlb   $0xeb,0x18(%ebp)
    1dfd:	20 66 83             	and    %ah,-0x7d(%esi)
	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
    1e00:	fd                   	std    
    1e01:	10 75 1a             	adc    %dh,0x1a(%ebp)
    1e04:	3c 30                	cmp    $0x30,%al
    1e06:	75 16                	jne    1e1e <kstrtoull+0x77>
	return c | 0x20;
    1e08:	67 8a 43 01          	mov    0x1(%bp,%di),%al
    1e0c:	66 83 c8 20          	or     $0x20,%ax
	if (*base == 16 && s[0] == '0' && _tolower(s[1]) == 'x')
    1e10:	3c 78                	cmp    $0x78,%al
    1e12:	75 0a                	jne    1e1e <kstrtoull+0x77>
		s += 2;
    1e14:	66 83 c3 02          	add    $0x2,%bx
    1e18:	66 bd 10 00          	mov    $0x10,%bp
    1e1c:	00 00                	add    %al,(%eax)
				*base = 8;
    1e1e:	67 66 89 5c 24       	mov    %bx,0x24(%si)
    1e23:	08 66 31             	or     %ah,0x31(%esi)
	rv = 0;
    1e26:	c9                   	leave  
	res = 0;
    1e27:	67 66 c7 04 24 00    	movw   $0x24,(%si)
    1e2d:	00 00                	add    %al,(%eax)
    1e2f:	00 67 66             	add    %ah,0x66(%edi)
    1e32:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1e39:	00 
		unsigned int c = *s;
    1e3a:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1e3f:	08 67 66             	or     %ah,0x66(%edi)
    1e42:	0f be 10             	movsbl (%eax),%edx
    1e45:	66 89 d0             	mov    %dx,%ax
		if ('0' <= c && c <= '9')
    1e48:	67 66 8d 7a d0       	lea    -0x30(%bp,%si),%di
    1e4d:	66 89 fe             	mov    %di,%si
    1e50:	66 83 ff 09          	cmp    $0x9,%di
    1e54:	76 1b                	jbe    1e71 <kstrtoull+0xca>
		unsigned int lc = c | 0x20; /* don't tolower() this line */
    1e56:	66 83 c8 20          	or     $0x20,%ax
    1e5a:	66 0f be d0          	movsbw %al,%dx
		else if ('a' <= lc && lc <= 'f')
    1e5e:	67 66 8d 42 9f       	lea    -0x61(%bp,%si),%ax
    1e63:	66 83 f8 05          	cmp    $0x5,%ax
    1e67:	77 7a                	ja     1ee3 <kstrtoull+0x13c>
			val = lc - 'a' + 10;
    1e69:	67 66 8d 42 a9       	lea    -0x57(%bp,%si),%ax
    1e6e:	66 89 c6             	mov    %ax,%si
		if (val >= base)
    1e71:	66 39 ee             	cmp    %bp,%si
    1e74:	73 6d                	jae    1ee3 <kstrtoull+0x13c>
		if (unlikely(res & (~0ull << 60))) {
    1e76:	67 66 f7 44 24 04 00 	testw  $0x4,0x24(%si)
    1e7d:	00 00                	add    %al,(%eax)
    1e7f:	f0 74 2d             	lock je 1eaf <kstrtoull+0x108>
		d.v32[1] = upper / divisor;
    1e82:	66 83 c8 ff          	or     $0xffff,%ax
    1e86:	66 31 d2             	xor    %dx,%dx
    1e89:	66 f7 f5             	div    %bp
    1e8c:	66 89 c7             	mov    %ax,%di
	asm ("divl %2" : "=a" (d.v32[0]), "=d" (*remainder) :
    1e8f:	66 89 f0             	mov    %si,%ax
    1e92:	66 f7 d0             	not    %ax
    1e95:	66 f7 f5             	div    %bp
			if (res > __div_u64(ULLONG_MAX - val, base))
    1e98:	67 66 3b 04          	cmp    (%si),%ax
    1e9c:	24 66                	and    $0x66,%al
    1e9e:	89 f8                	mov    %edi,%eax
    1ea0:	67 66 1b 44 24       	sbb    0x24(%si),%ax
    1ea5:	04 73                	add    $0x73,%al
    1ea7:	07                   	pop    %es
				rv |= KSTRTOX_OVERFLOW;
    1ea8:	66 81 c9 00 00       	or     $0x0,%cx
    1ead:	00 80 67 66 8b 7c    	add    %al,0x7c8b6667(%eax)
		res = res * base + val;
    1eb3:	24 04                	and    $0x4,%al
    1eb5:	66 0f af fd          	imul   %bp,%di
    1eb9:	67 66 8b 04          	mov    (%si),%ax
    1ebd:	24 66                	and    $0x66,%al
    1ebf:	f7 e5                	mul    %ebp
    1ec1:	66 01 fa             	add    %di,%dx
    1ec4:	66 31 ff             	xor    %di,%di
    1ec7:	66 01 c6             	add    %ax,%si
    1eca:	66 11 d7             	adc    %dx,%di
    1ecd:	67 66 89 34          	mov    %si,(%si)
    1ed1:	24 67                	and    $0x67,%al
    1ed3:	66 89 7c 24 04       	mov    %di,0x4(%esp)
		rv++;
    1ed8:	66 41                	inc    %cx
		s++;
    1eda:	67 66 ff 44 24       	incw   0x24(%si)
    1edf:	08 e9                	or     %ch,%cl
	while (1) {
    1ee1:	57                   	push   %edi
    1ee2:	ff 66 b8             	jmp    *-0x48(%esi)
		return -ERANGE;
    1ee5:	de ff                	fdivrp %st,%st(7)
    1ee7:	ff                   	(bad)  
    1ee8:	ff 66 85             	jmp    *-0x7b(%esi)
	if (rv & KSTRTOX_OVERFLOW)
    1eeb:	c9                   	leave  
    1eec:	78 3c                	js     1f2a <kstrtoull+0x183>
		return -EINVAL;
    1eee:	66 b8 ea ff          	mov    $0xffea,%ax
    1ef2:	ff                   	(bad)  
    1ef3:	ff 74 34 66          	pushl  0x66(%esp,%esi,1)
	s += rv;
    1ef7:	01 cb                	add    %ecx,%ebx
	if (*s == '\n')
    1ef9:	67 80 3b 0a          	cmpb   $0xa,(%bp,%di)
    1efd:	75 02                	jne    1f01 <kstrtoull+0x15a>
		s++;
    1eff:	66 43                	inc    %bx
		return -EINVAL;
    1f01:	66 b8 ea ff          	mov    $0xffea,%ax
    1f05:	ff                   	(bad)  
    1f06:	ff 67 80             	jmp    *-0x80(%edi)
	if (*s)
    1f09:	3b 00                	cmp    (%eax),%eax
    1f0b:	75 1d                	jne    1f2a <kstrtoull+0x183>
	*res = _res;
    1f0d:	67 66 8b 44 24       	mov    0x24(%si),%ax
    1f12:	0c 67                	or     $0x67,%al
    1f14:	66 8b 0c 24          	mov    (%esp),%cx
    1f18:	67 66 8b 5c 24       	mov    0x24(%si),%bx
    1f1d:	04 67                	add    $0x67,%al
    1f1f:	66 89 08             	mov    %cx,(%eax)
    1f22:	67 66 89 58 04       	mov    %bx,0x4(%bx,%si)
	return 0;
    1f27:	66 31 c0             	xor    %ax,%ax
	return _kstrtoull(s, base, res);
}
    1f2a:	66 83 c4 10          	add    $0x10,%sp
    1f2e:	66 5b                	pop    %bx
    1f30:	66 5e                	pop    %si
    1f32:	66 5f                	pop    %di
    1f34:	66 5d                	pop    %bp
    1f36:	66 c3                	retw   

00001f38 <boot_kstrtoul>:
 *
 * Returns 0 on success, -ERANGE on overflow and -EINVAL on parsing error.
 * Used as a replacement for the simple_strtoull.
 */
int boot_kstrtoul(const char *s, unsigned int base, unsigned long *res)
{
    1f38:	66 53                	push   %bx
    1f3a:	66 83 ec 08          	sub    $0x8,%sp
    1f3e:	66 89 cb             	mov    %cx,%bx
	rv = kstrtoull(s, base, &tmp);
    1f41:	66 89 e1             	mov    %sp,%cx
    1f44:	66 e8 5d fe          	callw  1da5 <strchr+0x12>
    1f48:	ff                   	(bad)  
    1f49:	ff 66 85             	jmp    *-0x7b(%esi)
	if (rv < 0)
    1f4c:	c0 78 1b 67          	sarb   $0x67,0x1b(%eax)
	if (tmp != (unsigned long)tmp)
    1f50:	66 8b 14 24          	mov    (%esp),%dx
		return -ERANGE;
    1f54:	66 b8 de ff          	mov    $0xffde,%ax
    1f58:	ff                   	(bad)  
    1f59:	ff 67 66             	jmp    *0x66(%edi)
	if (tmp != (unsigned long)tmp)
    1f5c:	83 7c 24 04 00       	cmpl   $0x0,0x4(%esp)
    1f61:	75 07                	jne    1f6a <boot_kstrtoul+0x32>
	*res = tmp;
    1f63:	67 66 89 13          	mov    %dx,(%bp,%di)
	return 0;
    1f67:	66 31 c0             	xor    %ax,%ax
	if (sizeof(unsigned long) == sizeof(unsigned long long) &&
	    __alignof__(unsigned long) == __alignof__(unsigned long long))
		return kstrtoull(s, base, (unsigned long long *)res);
	else
		return _kstrtoul(s, base, res);
}
    1f6a:	66 83 c4 08          	add    $0x8,%sp
    1f6e:	66 5b                	pop    %bx
    1f70:	66 c3                	retw   

00001f72 <kbd_pending>:

	return oreg.al;
}

static int kbd_pending(void)
{
    1f72:	66 83 ec 58          	sub    $0x58,%sp
	struct biosregs ireg, oreg;

	initregs(&ireg);
    1f76:	66 89 e0             	mov    %sp,%ax
    1f79:	66 e8 2f fb          	callw  1aac <printf+0x3c>
    1f7d:	ff                   	(bad)  
    1f7e:	ff 67 c6             	jmp    *-0x3a(%edi)
	ireg.ah = 0x01;
    1f81:	44                   	inc    %esp
    1f82:	24 1d                	and    $0x1d,%al
    1f84:	01 67 66             	add    %esp,0x66(%edi)
	intcall(0x16, &ireg, &oreg);
    1f87:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    1f8b:	66 89 e2             	mov    %sp,%dx
    1f8e:	66 b8 16 00          	mov    $0x16,%ax
    1f92:	00 00                	add    %al,(%eax)
    1f94:	66 e8 3a e3          	callw  2d2 <die+0x1>
    1f98:	ff                   	(bad)  
    1f99:	ff 67 66             	jmp    *0x66(%edi)

	return !(oreg.eflags & X86_EFLAGS_ZF);
    1f9c:	8b 44 24 54          	mov    0x54(%esp),%eax
    1fa0:	66 c1 e8 06          	shr    $0x6,%ax
    1fa4:	66 83 f0 01          	xor    $0x1,%ax
    1fa8:	66 83 e0 01          	and    $0x1,%ax
}
    1fac:	66 83 c4 58          	add    $0x58,%sp
    1fb0:	66 c3                	retw   

00001fb2 <gettime>:
{
    1fb2:	66 83 ec 58          	sub    $0x58,%sp
	initregs(&ireg);
    1fb6:	66 89 e0             	mov    %sp,%ax
    1fb9:	66 e8 ef fa          	callw  1aac <printf+0x3c>
    1fbd:	ff                   	(bad)  
    1fbe:	ff 67 c6             	jmp    *-0x3a(%edi)
	ireg.ah = 0x02;
    1fc1:	44                   	inc    %esp
    1fc2:	24 1d                	and    $0x1d,%al
    1fc4:	02 67 66             	add    0x66(%edi),%ah
	intcall(0x1a, &ireg, &oreg);
    1fc7:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    1fcb:	66 89 e2             	mov    %sp,%dx
    1fce:	66 b8 1a 00          	mov    $0x1a,%ax
    1fd2:	00 00                	add    %al,(%eax)
    1fd4:	66 e8 fa e2          	callw  2d2 <die+0x1>
    1fd8:	ff                   	(bad)  
    1fd9:	ff 67 8a             	jmp    *-0x76(%edi)
}
    1fdc:	44                   	inc    %esp
    1fdd:	24 41                	and    $0x41,%al
    1fdf:	66 83 c4 58          	add    $0x58,%sp
    1fe3:	66 c3                	retw   

00001fe5 <getchar>:
{
    1fe5:	66 83 ec 58          	sub    $0x58,%sp
	initregs(&ireg);
    1fe9:	66 89 e0             	mov    %sp,%ax
    1fec:	66 e8 bc fa          	callw  1aac <printf+0x3c>
    1ff0:	ff                   	(bad)  
    1ff1:	ff 67 66             	jmp    *0x66(%edi)
	intcall(0x16, &ireg, &oreg);
    1ff4:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    1ff8:	66 89 e2             	mov    %sp,%dx
    1ffb:	66 b8 16 00          	mov    $0x16,%ax
    1fff:	00 00                	add    %al,(%eax)
    2001:	66 e8 cd e2          	callw  2d2 <die+0x1>
    2005:	ff                   	(bad)  
    2006:	ff 67 66             	jmp    *0x66(%edi)
	return oreg.al;
    2009:	0f b6 44 24 48       	movzbl 0x48(%esp),%eax
}
    200e:	66 83 c4 58          	add    $0x58,%sp
    2012:	66 c3                	retw   

00002014 <kbd_flush>:

void kbd_flush(void)
{
	for (;;) {
		if (!kbd_pending())
    2014:	66 e8 58 ff          	callw  1f70 <boot_kstrtoul+0x38>
    2018:	ff                   	(bad)  
    2019:	ff 66 85             	jmp    *-0x7b(%esi)
    201c:	c0 74 08 66 e8       	shlb   $0xe8,0x66(%eax,%ecx,1)
			break;
		getchar();
    2021:	c0 ff ff             	sar    $0xff,%bh
    2024:	ff                   	(bad)  
		if (!kbd_pending())
    2025:	eb ed                	jmp    2014 <kbd_flush>
	}
}
    2027:	66 c3                	retw   

00002029 <getchar_timeout>:

int getchar_timeout(void)
{
    2029:	66 56                	push   %si
    202b:	66 53                	push   %bx
	int cnt = 30;
	int t0, t1;

	t0 = gettime();
    202d:	66 e8 7f ff          	callw  1fb0 <kbd_pending+0x3e>
    2031:	ff                   	(bad)  
    2032:	ff 66 0f             	jmp    *0xf(%esi)
    2035:	b6 d8                	mov    $0xd8,%dh
	int cnt = 30;
    2037:	66 be 1e 00          	mov    $0x1e,%si
    203b:	00 00                	add    %al,(%eax)

	while (cnt) {
		if (kbd_pending())
    203d:	66 e8 2f ff          	callw  1f70 <boot_kstrtoul+0x38>
    2041:	ff                   	(bad)  
    2042:	ff 66 85             	jmp    *-0x7b(%esi)
    2045:	c0 74 06 66 5b       	shlb   $0x5b,0x66(%esi,%eax,1)
			t0 = t1;
		}
	}

	return 0;		/* Timeout! */
}
    204a:	66 5e                	pop    %si
			return getchar();
    204c:	eb 97                	jmp    1fe5 <getchar>
		t1 = gettime();
    204e:	66 e8 5e ff          	callw  1fb0 <kbd_pending+0x3e>
    2052:	ff                   	(bad)  
    2053:	ff 66 0f             	jmp    *0xf(%esi)
    2056:	b6 c0                	mov    $0xc0,%dh
		if (t0 != t1) {
    2058:	66 39 d8             	cmp    %bx,%ax
    205b:	74 02                	je     205f <getchar_timeout+0x36>
			cnt--;
    205d:	66 4e                	dec    %si
	while (cnt) {
    205f:	66 85 f6             	test   %si,%si
    2062:	74 05                	je     2069 <getchar_timeout+0x40>
		t1 = gettime();
    2064:	66 89 c3             	mov    %ax,%bx
    2067:	eb d4                	jmp    203d <getchar_timeout+0x14>
}
    2069:	66 31 c0             	xor    %ax,%ax
    206c:	66 5b                	pop    %bx
    206e:	66 5e                	pop    %si
    2070:	66 c3                	retw   

00002072 <store_cursor_position>:
#include "vesa.h"

static u16 video_segment;

static void store_cursor_position(void)
{
    2072:	66 83 ec 58          	sub    $0x58,%sp
	struct biosregs ireg, oreg;

	initregs(&ireg);
    2076:	66 89 e0             	mov    %sp,%ax
    2079:	66 e8 2f fa          	callw  1aac <printf+0x3c>
    207d:	ff                   	(bad)  
    207e:	ff 67 c6             	jmp    *-0x3a(%edi)
	ireg.ah = 0x03;
    2081:	44                   	inc    %esp
    2082:	24 1d                	and    $0x1d,%al
    2084:	03 67 66             	add    0x66(%edi),%esp
	intcall(0x10, &ireg, &oreg);
    2087:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    208b:	66 89 e2             	mov    %sp,%dx
    208e:	66 b8 10 00          	mov    $0x10,%ax
    2092:	00 00                	add    %al,(%eax)
    2094:	66 e8 3a e2          	callw  2d2 <die+0x1>
    2098:	ff                   	(bad)  
    2099:	ff 67 66             	jmp    *0x66(%edi)

	boot_params.screen_info.orig_x = oreg.dl;
    209c:	8b 44 24 40          	mov    0x40(%esp),%eax
    20a0:	a3 70 39 67 8a       	mov    %eax,0x8a673970
	boot_params.screen_info.orig_y = oreg.dh;

	if (oreg.ch & 0x20)
    20a5:	44                   	inc    %esp
    20a6:	24 45                	and    $0x45,%al
    20a8:	a8 20                	test   $0x20,%al
    20aa:	74 05                	je     20b1 <store_cursor_position+0x3f>
		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
    20ac:	80 0e 78             	orb    $0x78,(%esi)
    20af:	39 01                	cmp    %eax,(%ecx)

	if ((oreg.ch & 0x1f) > (oreg.cl & 0x1f))
    20b1:	66 83 e0 1f          	and    $0x1f,%ax
    20b5:	67 8a 54 24          	mov    0x24(%si),%dl
    20b9:	44                   	inc    %esp
    20ba:	66 83 e2 1f          	and    $0x1f,%dx
    20be:	38 d0                	cmp    %dl,%al
    20c0:	76 05                	jbe    20c7 <store_cursor_position+0x55>
		boot_params.screen_info.flags |= VIDEO_FLAGS_NOCURSOR;
    20c2:	80 0e 78             	orb    $0x78,(%esi)
    20c5:	39 01                	cmp    %eax,(%ecx)
}
    20c7:	66 83 c4 58          	add    $0x58,%sp
    20cb:	66 c3                	retw   

000020cd <store_mode_params.part.0>:
 * Store the video mode parameters for later usage by the kernel.
 * This is done by asking the BIOS except for the rows/columns
 * parameters in the default 80x25 mode -- these are set directly,
 * because some very obscure BIOSes supply insane values.
 */
static void store_mode_params(void)
    20cd:	66 83 ec 58          	sub    $0x58,%sp
	/* For graphics mode, it is up to the mode-setting driver
	   (currently only video-vesa.c) to store the parameters */
	if (graphic_mode)
		return;

	store_cursor_position();
    20d1:	66 e8 9b ff          	callw  2070 <getchar_timeout+0x47>
    20d5:	ff                   	(bad)  
    20d6:	ff 66 89             	jmp    *-0x77(%esi)
	initregs(&ireg);
    20d9:	e0 66                	loopne 2141 <store_mode_params.part.0+0x74>
    20db:	e8 ce f9 ff ff       	call   1aae <initregs>
	ireg.ah = 0x0f;
    20e0:	67 c6 44 24 1d       	movb   $0x1d,0x24(%si)
    20e5:	0f 67 66 8d          	packuswb -0x73(%esi),%mm4
	intcall(0x10, &ireg, &oreg);
    20e9:	4c                   	dec    %esp
    20ea:	24 2c                	and    $0x2c,%al
    20ec:	66 89 e2             	mov    %sp,%dx
    20ef:	66 b8 10 00          	mov    $0x10,%ax
    20f3:	00 00                	add    %al,(%eax)
    20f5:	66 e8 d9 e1          	callw  2d2 <die+0x1>
    20f9:	ff                   	(bad)  
    20fa:	ff 67 8a             	jmp    *-0x76(%edi)
	boot_params.screen_info.orig_video_mode = oreg.al & 0x7f;
    20fd:	44                   	inc    %esp
    20fe:	24 48                	and    $0x48,%al
    2100:	66 83 e0 7f          	and    $0x7f,%ax
    2104:	a2 76 39 67 66       	mov    %al,0x66673976
	boot_params.screen_info.orig_video_page = oreg.bh;
    2109:	0f b6 54 24 3d       	movzbl 0x3d(%esp),%edx
    210e:	89 16                	mov    %edx,(%esi)
    2110:	74 39                	je     214b <store_mode_params.part.0+0x7e>
	if (boot_params.screen_info.orig_video_mode == 0x07) {
		/* MDA, HGC, or VGA in monochrome mode */
		video_segment = 0xb000;
	} else {
		/* CGA, EGA, VGA and so forth */
		video_segment = 0xb800;
    2112:	66 ba 00 b8          	mov    $0xb800,%dx
    2116:	ff                   	(bad)  
    2117:	ff                   	(bad)  
	if (boot_params.screen_info.orig_video_mode == 0x07) {
    2118:	3c 07                	cmp    $0x7,%al
    211a:	75 06                	jne    2122 <store_mode_params.part.0+0x55>
    211c:	66 ba 00 b0          	mov    $0xb000,%dx
    2120:	ff                   	(bad)  
    2121:	ff 89 16 e0 36 66    	decl   0x6636e016(%ecx)
	asm volatile("movw %0,%%fs" : : "rm" (seg));
    2127:	31 c0                	xor    %eax,%eax
    2129:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
    212b:	64 a1 85 04 a3 80    	mov    %fs:0x80a30485,%eax
	}

	set_fs(0);
	font_size = rdfs16(0x485); /* Font size, BIOS area */
	boot_params.screen_info.orig_video_points = font_size;
    2131:	39 64 8b 0e          	cmp    %esp,0xe(%ebx,%ecx,4)
    2135:	4a                   	dec    %edx
    2136:	04 66                	add    $0x66,%al

	x = rdfs16(0x44a);
	y = (adapter == ADAPTER_CGA) ? 25 : rdfs8(0x484)+1;
    2138:	b8 19 00 00 00       	mov    $0x19,%eax
    213d:	66 83 3e 78          	cmpw   $0x78,(%esi)
    2141:	49                   	dec    %ecx
    2142:	00 74 0a 64          	add    %dh,0x64(%edx,%ecx,1)
	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
    2146:	a0 84 04 66 0f       	mov    0xf660484,%al
    214b:	b6 c0                	mov    $0xc0,%dh
    214d:	66 40                	inc    %ax

	if (force_x)
    214f:	66 8b 16             	mov    (%esi),%dx
    2152:	80 49 66 85          	orb    $0x85,0x66(%ecx)
    2156:	d2 75 04             	shlb   %cl,0x4(%ebp)
	x = rdfs16(0x44a);
    2159:	66 0f b7 d1          	movzww %cx,%dx
		x = force_x;
	if (force_y)
    215d:	66 8b 0e             	mov    (%esi),%cx
    2160:	7c 49                	jl     21ab <set_video+0x34>
    2162:	66 85 c9             	test   %cx,%cx
    2165:	74 03                	je     216a <store_mode_params.part.0+0x9d>
    2167:	66 89 c8             	mov    %cx,%ax
		y = force_y;

	boot_params.screen_info.orig_video_cols  = x;
    216a:	88 16                	mov    %dl,(%esi)
    216c:	77 39                	ja     21a7 <set_video+0x30>
	boot_params.screen_info.orig_video_lines = y;
    216e:	a2 7e 39 66 83       	mov    %al,0x8366397e
}
    2173:	c4 58 66             	les    0x66(%eax),%ebx
    2176:	c3                   	ret    

00002177 <set_video>:

	store_cursor_position();
}

void set_video(void)
{
    2177:	66 55                	push   %bp
    2179:	66 57                	push   %di
    217b:	66 56                	push   %si
    217d:	66 53                	push   %bx
    217f:	66 83 ec 38          	sub    $0x38,%sp
	u16 mode = boot_params.hdr.vid_mode;
    2183:	8b 1e                	mov    (%esi),%ebx
    2185:	6a 3b                	push   $0x3b

	RESET_HEAP();
    2187:	66 c7 06 c4 35       	movw   $0x35c4,(%esi)
    218c:	90                   	nop
    218d:	49                   	dec    %ecx
    218e:	00 00                	add    %al,(%eax)
	if (graphic_mode)
    2190:	66 83 3e 84          	cmpw   $0xff84,(%esi)
    2194:	49                   	dec    %ecx
    2195:	00 75 06             	add    %dh,0x6(%ebp)
    2198:	66 e8 2f ff          	callw  20cb <store_cursor_position+0x59>
    219c:	ff                   	(bad)  
    219d:	ff 66 0f             	jmp    *0xf(%esi)
	saved.x = boot_params.screen_info.orig_video_cols;
    21a0:	b6 0e                	mov    $0xe,%dh
    21a2:	77 39                	ja     21dd <set_video+0x66>
    21a4:	66 89 0e             	mov    %cx,(%esi)
    21a7:	cc                   	int3   
    21a8:	36 66 0f b6 06       	movzbw %ss:(%esi),%ax
	saved.y = boot_params.screen_info.orig_video_lines;
    21ad:	7e 39                	jle    21e8 <set_video+0x71>
    21af:	66 a3 d0 36 66 0f    	mov    %ax,0xf6636d0
	saved.curx = boot_params.screen_info.orig_x;
    21b5:	b6 16                	mov    $0x16,%dh
    21b7:	70 39                	jo     21f2 <set_video+0x7b>
    21b9:	66 89 16             	mov    %dx,(%esi)
    21bc:	d4 36                	aam    $0x36
	saved.cury = boot_params.screen_info.orig_y;
    21be:	66 0f b6 16          	movzbw (%esi),%dx
    21c2:	71 39                	jno    21fd <set_video+0x86>
    21c4:	66 89 16             	mov    %dx,(%esi)
    21c7:	d8 36                	fdivs  (%esi)
	if (!heap_free(saved.x*saved.y*sizeof(u16)+512))
    21c9:	66 0f af c8          	imul   %ax,%cx
    21cd:	66 81 c1 00 01       	add    $0x100,%cx
    21d2:	00 00                	add    %al,(%eax)
    21d4:	66 01 c9             	add    %cx,%cx
	return (int)(heap_end-HEAP) >= (int)n;
    21d7:	66 a1 c4 35 66 8b    	mov    0x8b6635c4,%ax
    21dd:	16                   	push   %ss
    21de:	c0 35 66 29 c2 66 39 	shlb   $0x39,0x66c22966
    21e5:	ca 7c 28             	lret   $0x287c
	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
    21e8:	66 40                	inc    %ax
    21ea:	66 83 e0 fe          	and    $0xfffe,%ax
	HEAP += s*n;
    21ee:	66 81 e9 00 02       	sub    $0x200,%cx
    21f3:	00 00                	add    %al,(%eax)
    21f5:	67 66 8d 14          	lea    (%si),%dx
    21f9:	08 66 89             	or     %ah,-0x77(%esi)
    21fc:	16                   	push   %ss
    21fd:	c4 35 66 a3 dc 36    	les    0x36dca366,%esi
	asm volatile("movw %0,%%fs" : : "rm" (seg));
    2203:	8e 26                	mov    (%esi),%fs
    2205:	e0 36                	loopne 223d <set_video+0xc6>
	copy_from_fs(saved.data, 0, saved.x*saved.y*sizeof(u16));
    2207:	66 31 d2             	xor    %dx,%dx
    220a:	66 e8 1b e5          	callw  729 <memset+0x1c>
    220e:	ff                   	(bad)  
    220f:	ff 66 31             	jmp    *0x31(%esi)

	store_mode_params();
	save_screen();
	probe_cards(0);
    2212:	c0 66 e8 15          	shlb   $0x15,-0x18(%esi)
    2216:	04 00                	add    $0x0,%al
    2218:	00 83 fb fd 0f 85    	add    %al,-0x7af00205(%ebx)

	for (;;) {
		if (mode == ASK_VGA)
    221e:	b7 02                	mov    $0x2,%bh
	puts("Press <ENTER> to see video modes available, "
    2220:	66 b8 c8 33          	mov    $0x33c8,%ax
    2224:	00 00                	add    %al,(%eax)
    2226:	66 e8 91 e1          	callw  3bb <putchar+0x88>
    222a:	ff                   	(bad)  
    222b:	ff 66 e8             	jmp    *-0x18(%esi)
	kbd_flush();
    222e:	e2 fd                	loop   222d <set_video+0xb6>
    2230:	ff                   	(bad)  
    2231:	ff 66 e8             	jmp    *-0x18(%esi)
		key = getchar_timeout();
    2234:	f1                   	icebp  
    2235:	fd                   	std    
    2236:	ff                   	(bad)  
    2237:	ff 66 a9             	jmp    *-0x57(%esi)
		if (key == ' ' || key == 0)
    223a:	df ff                	(bad)  
    223c:	ff                   	(bad)  
    223d:	ff 0f                	decl   (%edi)
    223f:	84 8f 02 66 83 f8    	test   %cl,-0x77c99fe(%edi)
		if (key == '\r')
    2245:	0d 0f 84 c0 00       	or     $0xc0840f,%eax
		putchar('\a');	/* Beep! */
    224a:	66 b8 07 00          	mov    $0x7,%ax
    224e:	00 00                	add    %al,(%eax)
    2250:	66 e8 dd e0          	callw  331 <intcall+0x5d>
    2254:	ff                   	(bad)  
    2255:	ff                   	(bad)  
		key = getchar_timeout();
    2256:	eb da                	jmp    2232 <set_video+0xbb>
	if (col)
    2258:	66 85 f6             	test   %si,%si
    225b:	74 0c                	je     2269 <set_video+0xf2>
		putchar('\n');
    225d:	66 b8 0a 00          	mov    $0xa,%ax
    2261:	00 00                	add    %al,(%eax)
    2263:	66 e8 ca e0          	callw  331 <intcall+0x5d>
    2267:	ff                   	(bad)  
    2268:	ff 66 b8             	jmp    *-0x48(%esi)
		puts("Enter a video mode or \"scan\" to scan for "
    226b:	4f                   	dec    %edi
    226c:	34 00                	xor    $0x0,%al
    226e:	00 66 e8             	add    %ah,-0x18(%esi)
    2271:	48                   	dec    %eax
    2272:	e1 ff                	loope  2273 <set_video+0xfc>
    2274:	ff 66 31             	jmp    *0x31(%esi)
	int i, len = 0;
    2277:	f6 66 e8             	mulb   -0x18(%esi)
		key = getchar();
    227a:	67 fd                	addr16 std 
    227c:	ff                   	(bad)  
    227d:	ff 66 89             	jmp    *-0x77(%esi)
    2280:	c3                   	ret    
		if (key == '\b') {
    2281:	66 83 f8 08          	cmp    $0x8,%ax
    2285:	0f 84 0f 02 67 66    	je     6667249a <image_base+0x6567249a>
		} else if ((key >= '0' && key <= '9') ||
    228b:	8d 40 d0             	lea    -0x30(%eax),%eax
    228e:	66 83 f8 09          	cmp    $0x9,%ax
    2292:	0f 86 1a 02 66 89    	jbe    896624b2 <image_base+0x886624b2>
    2298:	d8 66 83             	fsubs  -0x7d(%esi)
    229b:	e0 df                	loopne 227c <set_video+0x105>
    229d:	66 83 e8 41          	sub    $0x41,%ax
    22a1:	66 83 f8 19          	cmp    $0x19,%ax
    22a5:	0f 86 07 02 66 83    	jbe    836624b2 <image_base+0x826624b2>
	} while (key != '\r');
    22ab:	fb                   	sti    
    22ac:	0d 75 c9 66 b8       	or     $0xb866c975,%eax
	putchar('\n');
    22b1:	0a 00                	or     (%eax),%al
    22b3:	00 00                	add    %al,(%eax)
    22b5:	66 e8 78 e0          	callw  331 <intcall+0x5d>
    22b9:	ff                   	(bad)  
    22ba:	ff 66 85             	jmp    *-0x7b(%esi)
	if (len == 0)
    22bd:	f6 0f 84             	testb  $0x84,(%edi)
    22c0:	0f 02 66 31          	lar    0x31(%esi),%esp
	for (i = 0; i < len; i++) {
    22c4:	d2 66 31             	shlb   %cl,0x31(%esi)
	v = 0;
    22c7:	db 66 c1             	(bad)  -0x3f(%esi)
		v <<= 4;
    22ca:	e3 04                	jecxz  22d0 <set_video+0x159>
		key = entry_buf[i] | 0x20;
    22cc:	67 8a 44 14          	mov    0x14(%si),%al
    22d0:	0c 66                	or     $0x66,%al
    22d2:	83 c8 20             	or     $0x20,%eax
    22d5:	66 0f be c0          	movsbw %al,%ax
		v += (key > '9') ? key-'a'+10 : key-'0';
    22d9:	67 66 8d 48 d0       	lea    -0x30(%bx,%si),%cx
    22de:	66 83 f8 39          	cmp    $0x39,%ax
    22e2:	7e 05                	jle    22e9 <set_video+0x172>
    22e4:	67 66 8d 48 a9       	lea    -0x57(%bx,%si),%cx
    22e9:	66 01 cb             	add    %cx,%bx
	for (i = 0; i < len; i++) {
    22ec:	66 42                	inc    %dx
    22ee:	66 39 f2             	cmp    %si,%dx
    22f1:	75 d5                	jne    22c8 <set_video+0x151>
		if (sel != SCAN)
    22f3:	66 81 fb b7 cc       	cmp    $0xccb7,%bx
    22f8:	01 00                	add    %eax,(%eax)
    22fa:	0f 85 d9 01 66 b8    	jne    b86624d9 <image_base+0xb76624d9>
		probe_cards(1);
    2300:	01 00                	add    %eax,(%eax)
    2302:	00 00                	add    %al,(%eax)
    2304:	66 e8 24 03          	callw  262c <set_video+0x4b5>
    2308:	00 00                	add    %al,(%eax)
	nmodes = 0;
    230a:	66 31 d2             	xor    %dx,%dx
	for (card = video_cards; card < video_cards_end; card++)
    230d:	66 b8 68 35          	mov    $0x3568,%ax
    2311:	00 00                	add    %al,(%eax)
    2313:	66 3d bc 35          	cmp    $0x35bc,%ax
    2317:	00 00                	add    %al,(%eax)
    2319:	73 0b                	jae    2326 <set_video+0x1af>
		nmodes += card->nmodes;
    231b:	67 66 03 50 10       	add    0x10(%bx,%si),%dx
	for (card = video_cards; card < video_cards_end; card++)
    2320:	66 83 c0 1c          	add    $0x1c,%ax
    2324:	eb ed                	jmp    2313 <set_video+0x19c>
		modes_per_line = 3;
    2326:	66 31 c0             	xor    %ax,%ax
    2329:	66 83 fa 14          	cmp    $0x14,%dx
    232d:	0f 9d c0             	setge  %al
    2330:	67 66 8d 44 00       	lea    0x0(%si),%ax
    2335:	01 67 66             	add    %esp,0x66(%edi)
    2338:	89 44 24 04          	mov    %eax,0x4(%esp)
	for (col = 0; col < modes_per_line; col++)
    233c:	66 31 db             	xor    %bx,%bx
		puts("Mode: Resolution:  Type: ");
    233f:	66 b8 19 34          	mov    $0x3419,%ax
    2343:	00 00                	add    %al,(%eax)
    2345:	66 e8 72 e0          	callw  3bb <putchar+0x88>
    2349:	ff                   	(bad)  
    234a:	ff 66 43             	jmp    *0x43(%esi)
	for (col = 0; col < modes_per_line; col++)
    234d:	67 66 3b 5c 24       	cmp    0x24(%si),%bx
    2352:	04 75                	add    $0x75,%al
    2354:	ea 66 b8 0a 00 00 00 	ljmp   $0x0,$0xab866
	putchar('\n');
    235b:	66 e8 d2 df          	callw  331 <intcall+0x5d>
    235f:	ff                   	(bad)  
    2360:	ff 66 31             	jmp    *0x31(%esi)
	col = 0;
    2363:	f6 67 c6             	mulb   -0x3a(%edi)
	ch = '0';
    2366:	04 24                	add    $0x24,%al
    2368:	30 66 bd             	xor    %ah,-0x43(%esi)
	for (card = video_cards; card < video_cards_end; card++) {
    236b:	68 35 00 00 66       	push   $0x66000035
    2370:	81 fd bc 35 00 00    	cmp    $0x35bc,%ebp
    2376:	0f 83 de fe 67 66    	jae    6668225a <image_base+0x6568225a>
		mi = card->modes;
    237c:	8b 7d 0c             	mov    0xc(%ebp),%edi
		for (i = 0; i < card->nmodes; i++, mi++) {
    237f:	66 31 db             	xor    %bx,%bx
    2382:	67 66 3b 5d 10       	cmp    0x10(%di),%bx
    2387:	0f 8d 06 01 67 8b    	jge    8b672493 <image_base+0x8a672493>
			int visible = mi->x && mi->y;
    238d:	4c                   	dec    %esp
    238e:	df 02                	filds  (%edx)
    2390:	66 31 d2             	xor    %dx,%dx
    2393:	85 c9                	test   %ecx,%ecx
    2395:	74 0c                	je     23a3 <set_video+0x22c>
    2397:	66 31 d2             	xor    %dx,%dx
    239a:	67 83 7c df 04       	cmpl   $0x4,-0x21(%si)
    239f:	00 0f                	add    %cl,(%edi)
    23a1:	95                   	xchg   %eax,%ebp
    23a2:	c2 67 8b             	ret    $0x8b67
			u16 mode_id = mi->mode ? mi->mode :
    23a5:	04 df                	add    $0xdf,%al
    23a7:	67 89 44 24          	mov    %eax,0x24(%si)
    23ab:	0a 85 c0 75 11 67    	or     0x671175c0(%ebp),%al
				(mi->y << 8)+mi->x;
    23b1:	8b 44 df 04          	mov    0x4(%edi,%ebx,8),%eax
    23b5:	66 c1 e0 08          	shl    $0x8,%ax
			u16 mode_id = mi->mode ? mi->mode :
    23b9:	66 01 c8             	add    %cx,%ax
    23bc:	67 89 44 24          	mov    %eax,0x24(%si)
    23c0:	0a 66 85             	or     -0x7b(%esi),%ah
			if (!visible)
    23c3:	d2 0f                	rorb   %cl,(%edi)
    23c5:	84 c4                	test   %al,%ah
    23c7:	00 67 8b             	add    %ah,-0x75(%edi)
			if (mi->depth)
    23ca:	44                   	inc    %esp
    23cb:	df 06                	filds  (%esi)
    23cd:	67 66 0f b7 54 df    	movzww -0x21(%si),%dx
    23d3:	04 85                	add    $0x85,%al
    23d5:	c0 74 22 66 0f       	shlb   $0xf,0x66(%edx,%eiz,1)
				sprintf(resbuf, "%dx%d", mi->y, mi->depth);
    23da:	b7 c0                	mov    $0xc0,%bh
    23dc:	66 50                	push   %ax
    23de:	66 52                	push   %dx
    23e0:	66 68 33 34          	pushw  $0x3433
    23e4:	00 00                	add    %al,(%eax)
    23e6:	67 66 8d 44 24       	lea    0x24(%si),%ax
    23eb:	18 66 50             	sbb    %ah,0x50(%esi)
    23ee:	66 e8 62 f6          	callw  1a54 <vsprintf+0x443>
    23f2:	ff                   	(bad)  
    23f3:	ff 66 83             	jmp    *-0x7d(%esi)
    23f6:	c4 10                	les    (%eax),%edx
    23f8:	eb 1a                	jmp    2414 <set_video+0x29d>
				sprintf(resbuf, "%d", mi->y);
    23fa:	66 52                	push   %dx
    23fc:	66 68 36 34          	pushw  $0x3436
    2400:	00 00                	add    %al,(%eax)
    2402:	67 66 8d 44 24       	lea    0x24(%si),%ax
    2407:	14 66                	adc    $0x66,%al
    2409:	50                   	push   %eax
    240a:	66 e8 46 f6          	callw  1a54 <vsprintf+0x443>
    240e:	ff                   	(bad)  
    240f:	ff 66 83             	jmp    *-0x7d(%esi)
    2412:	c4 0c 67             	les    (%edi,%eiz,2),%ecx
			printf("%c %03X %4dx%-7s %-6s",
    2415:	66 ff 75 00          	pushw  0x0(%ebp)
    2419:	67 66 8d 44 24       	lea    0x24(%si),%ax
    241e:	10 66 50             	adc    %ah,0x50(%esi)
    2421:	67 66 0f b7 44 df    	movzww -0x21(%si),%ax
    2427:	02 66 50             	add    0x50(%esi),%ah
    242a:	67 66 0f b7 44 24    	movzww 0x24(%si),%ax
    2430:	16                   	push   %ss
    2431:	66 50                	push   %ax
    2433:	67 66 0f be 44 24    	movsbw 0x24(%si),%ax
    2439:	10 66 50             	adc    %ah,0x50(%esi)
    243c:	66 68 39 34          	pushw  $0x3439
    2440:	00 00                	add    %al,(%eax)
    2442:	66 e8 28 f6          	callw  1a6e <sprintf+0x18>
    2446:	ff                   	(bad)  
    2447:	ff 66 46             	jmp    *0x46(%esi)
			if (col >= modes_per_line) {
    244a:	66 83 c4 18          	add    $0x18,%sp
    244e:	67 66 39 74 24       	cmp    %si,0x24(%si)
    2453:	04 7f                	add    $0x7f,%al
    2455:	0f 66 b8 0a 00 00 00 	pcmpgtd 0xa(%eax),%mm7
				putchar('\n');
    245c:	66 e8 d1 de          	callw  331 <intcall+0x5d>
    2460:	ff                   	(bad)  
    2461:	ff 66 31             	jmp    *0x31(%esi)
				col = 0;
    2464:	f6 67 80             	mulb   -0x80(%edi)
			if (ch == '9')
    2467:	3c 24                	cmp    $0x24,%al
    2469:	39 74 14 67          	cmp    %esi,0x67(%esp,%edx,1)
			else if (ch == 'z' || ch == ' ')
    246d:	80 3c 24 20          	cmpb   $0x20,(%esp)
    2471:	74 14                	je     2487 <set_video+0x310>
    2473:	67 80 3c 24          	cmpb   $0x24,(%si)
    2477:	7a 74                	jp     24ed <set_video+0x376>
    2479:	0d 67 fe 04 24       	or     $0x2404fe67,%eax
				ch++;
    247e:	eb 0c                	jmp    248c <set_video+0x315>
				ch = 'a';
    2480:	67 c6 04 24          	movb   $0x24,(%si)
    2484:	61                   	popa   
    2485:	eb 05                	jmp    248c <set_video+0x315>
				ch = ' '; /* Out of keys... */
    2487:	67 c6 04 24          	movb   $0x24,(%si)
    248b:	20 66 43             	and    %ah,0x43(%esi)
		for (i = 0; i < card->nmodes; i++, mi++) {
    248e:	e9 f1 fe 66 83       	jmp    83672384 <image_base+0x82672384>
	for (card = video_cards; card < video_cards_end; card++) {
    2493:	c5 1c e9             	lds    (%ecx,%ebp,8),%ebx
    2496:	d7                   	xlat   %ds:(%ebx)
    2497:	fe                   	(bad)  
			if (len > 0) {
    2498:	66 85 f6             	test   %si,%si
    249b:	0f 84 d9 fd 66 b8    	je     b867227a <image_base+0xb767227a>
				puts("\b \b");
    24a1:	8b 34 00             	mov    (%eax,%eax,1),%esi
    24a4:	00 66 e8             	add    %ah,-0x18(%esi)
    24a7:	12 df                	adc    %bh,%bl
    24a9:	ff                   	(bad)  
    24aa:	ff 66 4e             	jmp    *0x4e(%esi)
				len--;
    24ad:	e9 c8 fd 66 83       	jmp    8367227a <image_base+0x8267227a>
			if (len < sizeof(entry_buf)) {
    24b2:	fe 03                	incb   (%ebx)
    24b4:	0f 8f f1 fd 67 66    	jg     666822ab <image_base+0x656822ab>
				entry_buf[len++] = key;
    24ba:	8d 7e 01             	lea    0x1(%esi),%edi
    24bd:	67 88 5c 34          	mov    %bl,0x34(%si)
    24c1:	0c 66                	or     $0x66,%al
				putchar(key);
    24c3:	89 d8                	mov    %ebx,%eax
    24c5:	66 e8 68 de          	callw  331 <intcall+0x5d>
    24c9:	ff                   	(bad)  
    24ca:	ff 66 89             	jmp    *-0x77(%esi)
				entry_buf[len++] = key;
    24cd:	fe                   	(bad)  
    24ce:	e9 d8 fd 66 bb       	jmp    bb6722ab <image_base+0xba6722ab>
			return VIDEO_CURRENT_MODE; /* Default */
    24d3:	04 0f                	add    $0xf,%al
    24d5:	00 00                	add    %al,(%eax)
			mode = mode_menu();

		if (!set_mode(mode))
    24d7:	66 0f b7 f3          	movzww %bx,%si
    24db:	66 89 f0             	mov    %si,%ax
    24de:	66 e8 f6 01          	callw  26d8 <mode_defined+0x50>
    24e2:	00 00                	add    %al,(%eax)
    24e4:	66 85 c0             	test   %ax,%ax
    24e7:	74 15                	je     24fe <set_video+0x387>
			break;

		printf("Undefined video mode number: %x\n", mode);
    24e9:	66 56                	push   %si
    24eb:	66 68 8f 34          	pushw  $0x348f
    24ef:	00 00                	add    %al,(%eax)
    24f1:	66 e8 79 f5          	callw  1a6e <sprintf+0x18>
    24f5:	ff                   	(bad)  
    24f6:	ff 66 58             	jmp    *0x58(%esi)
    24f9:	66 5a                	pop    %dx
    24fb:	e9 22 fd 89 1e       	jmp    1e8a2222 <image_base+0x1d8a2222>
		mode = ASK_VGA;
	}
	boot_params.hdr.vid_mode = mode;
    2500:	6a 3b                	push   $0x3b
	vesa_store_edid();
    2502:	66 e8 69 09          	callw  2e6f <vesa_probe+0x139>
    2506:	00 00                	add    %al,(%eax)
	if (graphic_mode)
    2508:	66 83 3e 84          	cmpw   $0xff84,(%esi)
    250c:	49                   	dec    %ecx
    250d:	00 75 06             	add    %dh,0x6(%ebp)
    2510:	66 e8 b7 fb          	callw  20cb <store_cursor_position+0x59>
    2514:	ff                   	(bad)  
    2515:	ff 66 83             	jmp    *-0x7d(%esi)
	store_mode_params();

	if (do_restore)
    2518:	3e 74 49             	je,pt  2564 <set_video+0x3ed>
    251b:	00 0f                	add    %cl,(%edi)
    251d:	84 00                	test   %al,(%eax)
    251f:	01 66 8b             	add    %esp,-0x75(%esi)
	u16 *src = saved.data;
    2522:	2e dc 36             	fdivl  %cs:(%esi)
	if (!src)
    2525:	66 83 3e 84          	cmpw   $0xff84,(%esi)
    2529:	49                   	dec    %ecx
    252a:	00 0f                	add    %cl,(%edi)
    252c:	85 f1                	test   %esi,%ecx
    252e:	00 66 85             	add    %ah,-0x7b(%esi)
    2531:	ed                   	in     (%dx),%eax
    2532:	0f 84 ea 00 66 0f    	je     f662622 <image_base+0xe662622>
	int xs = boot_params.screen_info.orig_video_cols;
    2538:	b6 1e                	mov    $0x1e,%dh
    253a:	77 39                	ja     2575 <set_video+0x3fe>
	int ys = boot_params.screen_info.orig_video_lines;
    253c:	66 0f b6 06          	movzbw (%esi),%ax
    2540:	7e 39                	jle    257b <set_video+0x404>
    2542:	67 66 89 04          	mov    %ax,(%si)
    2546:	24 8e                	and    $0x8e,%al
    2548:	26 e0 36             	es loopne 2581 <set_video+0x40a>
	for (y = 0; y < ys; y++) {
    254b:	66 31 f6             	xor    %si,%si
	addr_t dst = 0;
    254e:	66 31 ff             	xor    %di,%di
	for (y = 0; y < ys; y++) {
    2551:	67 66 39 34          	cmp    %si,(%si)
    2555:	24 7e                	and    $0x7e,%al
    2557:	69 66 89 d9 66 39 36 	imul   $0x363966d9,-0x77(%esi),%esp
		if (y < saved.y) {
    255e:	d0 36                	shlb   (%esi)
    2560:	7e 45                	jle    25a7 <set_video+0x430>
			int copy = (xs < saved.x) ? xs : saved.x;
    2562:	66 8b 0e             	mov    (%esi),%cx
    2565:	cc                   	int3   
    2566:	36 66 39 d9          	ss cmp %bx,%cx
    256a:	7e 03                	jle    256f <set_video+0x3f8>
    256c:	66 89 d9             	mov    %bx,%cx
			copy_to_fs(dst, src, copy*sizeof(u16));
    256f:	66 01 c9             	add    %cx,%cx
    2572:	67 66 89 4c 24       	mov    %cx,0x24(%si)
    2577:	04 66                	add    $0x66,%al
    2579:	89 ea                	mov    %ebp,%edx
    257b:	66 89 f8             	mov    %di,%ax
    257e:	66 e8 b4 e1          	callw  736 <copy_from_fs+0xb>
    2582:	ff                   	(bad)  
    2583:	ff 67 66             	jmp    *0x66(%edi)
			dst += copy*sizeof(u16);
    2586:	8b 4c 24 04          	mov    0x4(%esp),%ecx
    258a:	66 01 cf             	add    %cx,%di
			src += saved.x;
    258d:	66 a1 cc 36 67 66    	mov    0x666736cc,%ax
    2593:	8d 14 00             	lea    (%eax,%eax,1),%edx
    2596:	66 01 d5             	add    %dx,%bp
			npad = (xs < saved.x) ? 0 : xs-saved.x;
    2599:	66 31 c9             	xor    %cx,%cx
    259c:	66 39 c3             	cmp    %ax,%bx
    259f:	7c 06                	jl     25a7 <set_video+0x430>
    25a1:	66 89 d9             	mov    %bx,%cx
    25a4:	66 29 c1             	sub    %ax,%cx
		asm volatile("pushw %%es ; "
    25a7:	8b 16                	mov    (%esi),%edx
    25a9:	e0 36                	loopne 25e1 <set_video+0x46a>
    25ab:	66 b8 20 07          	mov    $0x720,%ax
    25af:	20 07                	and    %al,(%edi)
    25b1:	06                   	push   %es
    25b2:	8e c2                	mov    %edx,%es
    25b4:	d1 e9                	shr    %ecx
    25b6:	73 01                	jae    25b9 <set_video+0x442>
    25b8:	ab                   	stos   %eax,%es:(%edi)
    25b9:	f3 66 ab             	rep stos %ax,%es:(%edi)
    25bc:	07                   	pop    %es
	for (y = 0; y < ys; y++) {
    25bd:	66 46                	inc    %si
    25bf:	eb 90                	jmp    2551 <set_video+0x3da>
	if (saved.curx >= xs)
    25c1:	66 3b 1e             	cmp    (%esi),%bx
    25c4:	d4 36                	aam    $0x36
    25c6:	7f 07                	jg     25cf <set_video+0x458>
		saved.curx = xs-1;
    25c8:	66 4b                	dec    %bx
    25ca:	66 89 1e             	mov    %bx,(%esi)
    25cd:	d4 36                	aam    $0x36
	if (saved.cury >= ys)
    25cf:	67 66 8b 04          	mov    (%si),%ax
    25d3:	24 66                	and    $0x66,%al
    25d5:	3b 06                	cmp    (%esi),%eax
    25d7:	d8 36                	fdivs  (%esi)
    25d9:	7f 06                	jg     25e1 <set_video+0x46a>
		saved.cury = ys-1;
    25db:	66 48                	dec    %ax
    25dd:	66 a3 d8 36 67 66    	mov    %ax,0x666736d8
	initregs(&ireg);
    25e3:	8d 44 24 0c          	lea    0xc(%esp),%eax
    25e7:	66 e8 c1 f4          	callw  1aac <printf+0x3c>
    25eb:	ff                   	(bad)  
    25ec:	ff 67 c6             	jmp    *-0x3a(%edi)
	ireg.ah = 0x02;		/* Set cursor position */
    25ef:	44                   	inc    %esp
    25f0:	24 29                	and    $0x29,%al
    25f2:	02 66 a1             	add    -0x5f(%esi),%ah
	ireg.dh = saved.cury;
    25f5:	d8 36                	fdivs  (%esi)
    25f7:	67 88 44 24          	mov    %al,0x24(%si)
    25fb:	21 66 a1             	and    %esp,-0x5f(%esi)
	ireg.dl = saved.curx;
    25fe:	d4 36                	aam    $0x36
    2600:	67 88 44 24          	mov    %al,0x24(%si)
    2604:	20 66 31             	and    %ah,0x31(%esi)
	intcall(0x10, &ireg, NULL);
    2607:	c9                   	leave  
    2608:	67 66 8d 54 24       	lea    0x24(%si),%dx
    260d:	0c 66                	or     $0x66,%al
    260f:	b8 10 00 00 00       	mov    $0x10,%eax
    2614:	66 e8 ba dc          	callw  2d2 <die+0x1>
    2618:	ff                   	(bad)  
    2619:	ff 66 e8             	jmp    *-0x18(%esi)
	store_cursor_position();
    261c:	52                   	push   %edx
    261d:	fa                   	cli    
    261e:	ff                   	(bad)  
    261f:	ff 66 83             	jmp    *-0x7d(%esi)
		restore_screen();
}
    2622:	c4 38                	les    (%eax),%edi
    2624:	66 5b                	pop    %bx
    2626:	66 5e                	pop    %si
    2628:	66 5f                	pop    %di
    262a:	66 5d                	pop    %bp
    262c:	66 c3                	retw   

0000262e <probe_cards>:
void probe_cards(int unsafe)
{
	struct card_info *card;
	static u8 probed[2];

	if (probed[unsafe])
    262e:	67 80 b8 e2 36 00    	cmpb   $0x0,0x36e2(%bx,%si)
    2634:	00 00                	add    %al,(%eax)
    2636:	75 4e                	jne    2686 <probe_cards+0x58>
{
    2638:	66 56                	push   %si
    263a:	66 53                	push   %bx
    263c:	66 89 c6             	mov    %ax,%si
		return;

	probed[unsafe] = 1;
    263f:	67 c6 80 e2 36 00    	movb   $0x0,0x36e2(%bx,%si)
    2645:	00 01                	add    %al,(%ecx)

	for (card = video_cards; card < video_cards_end; card++) {
    2647:	66 bb 68 35          	mov    $0x3568,%bx
    264b:	00 00                	add    %al,(%eax)
    264d:	66 81 fb bc 35       	cmp    $0x35bc,%bx
    2652:	00 00                	add    %al,(%eax)
    2654:	73 2a                	jae    2680 <probe_cards+0x52>
		if (card->unsafe == unsafe) {
    2656:	67 66 39 73 14       	cmp    %si,0x14(%bp,%di)
    265b:	75 1d                	jne    267a <probe_cards+0x4c>
			if (card->probe)
    265d:	67 66 8b 43 08       	mov    0x8(%bp,%di),%ax
    2662:	66 85 c0             	test   %ax,%ax
    2665:	74 0a                	je     2671 <probe_cards+0x43>
				card->nmodes = card->probe();
    2667:	66 ff d0             	callw  *%ax
    266a:	67 66 89 43 10       	mov    %ax,0x10(%bp,%di)
    266f:	eb 09                	jmp    267a <probe_cards+0x4c>
			else
				card->nmodes = 0;
    2671:	67 66 c7 43 10 00 00 	movw   $0x0,0x10(%bp,%di)
    2678:	00 00                	add    %al,(%eax)
	for (card = video_cards; card < video_cards_end; card++) {
    267a:	66 83 c3 1c          	add    $0x1c,%bx
    267e:	eb cd                	jmp    264d <probe_cards+0x1f>
		}
	}
}
    2680:	66 5b                	pop    %bx
    2682:	66 5e                	pop    %si
    2684:	66 c3                	retw   
    2686:	66 c3                	retw   

00002688 <mode_defined>:
{
	struct card_info *card;
	struct mode_info *mi;
	int i;

	for (card = video_cards; card < video_cards_end; card++) {
    2688:	66 ba 68 35          	mov    $0x3568,%dx
    268c:	00 00                	add    %al,(%eax)
    268e:	66 81 fa bc 35       	cmp    $0x35bc,%dx
    2693:	00 00                	add    %al,(%eax)
    2695:	72 05                	jb     269c <mode_defined+0x14>
			if (mi->mode == mode)
				return 1;
		}
	}

	return 0;
    2697:	66 31 c0             	xor    %ax,%ax
}
    269a:	66 c3                	retw   
{
    269c:	66 56                	push   %si
    269e:	66 53                	push   %bx
		mi = card->modes;
    26a0:	67 66 8b 72 0c       	mov    0xc(%bp,%si),%si
		for (i = 0; i < card->nmodes; i++, mi++) {
    26a5:	67 66 8b 5a 10       	mov    0x10(%bp,%si),%bx
    26aa:	66 31 c9             	xor    %cx,%cx
    26ad:	66 39 cb             	cmp    %cx,%bx
    26b0:	7e 0a                	jle    26bc <mode_defined+0x34>
			if (mi->mode == mode)
    26b2:	67 39 04             	cmp    %eax,(%si)
    26b5:	ce                   	into   
    26b6:	74 16                	je     26ce <mode_defined+0x46>
		for (i = 0; i < card->nmodes; i++, mi++) {
    26b8:	66 41                	inc    %cx
    26ba:	eb f1                	jmp    26ad <mode_defined+0x25>
	for (card = video_cards; card < video_cards_end; card++) {
    26bc:	66 83 c2 1c          	add    $0x1c,%dx
    26c0:	66 81 fa bc 35       	cmp    $0x35bc,%dx
    26c5:	00 00                	add    %al,(%eax)
    26c7:	72 d7                	jb     26a0 <mode_defined+0x18>
	return 0;
    26c9:	66 31 c0             	xor    %ax,%ax
    26cc:	eb 06                	jmp    26d4 <mode_defined+0x4c>
				return 1;
    26ce:	66 b8 01 00          	mov    $0x1,%ax
    26d2:	00 00                	add    %al,(%eax)
}
    26d4:	66 5b                	pop    %bx
    26d6:	66 5e                	pop    %si
    26d8:	66 c3                	retw   

000026da <set_mode>:
	out_idx(ov, crtc, 0x07);
}

/* Set mode (with recalc if specified) */
int set_mode(u16 mode)
{
    26da:	66 55                	push   %bp
    26dc:	66 57                	push   %di
    26de:	66 56                	push   %si
    26e0:	66 53                	push   %bx
    26e2:	66 83 ec 20          	sub    $0x20,%sp
	int rv;
	u16 real_mode;

	/* Very special mode numbers... */
	if (mode == VIDEO_CURRENT_MODE)
		return 0;	/* Nothing to do... */
    26e6:	66 31 ff             	xor    %di,%di
	if (mode == VIDEO_CURRENT_MODE)
    26e9:	3d 04 0f 0f 84       	cmp    $0x840f0f04,%eax
    26ee:	fa                   	cli    
    26ef:	01 66 bb             	add    %esp,-0x45(%esi)
	else if (mode == NORMAL_VGA)
		mode = VIDEO_80x25;
    26f2:	00 0f                	add    %cl,(%edi)
    26f4:	00 00                	add    %al,(%eax)
	else if (mode == NORMAL_VGA)
    26f6:	83 f8 ff             	cmp    $0xffffffff,%eax
    26f9:	74 0e                	je     2709 <set_mode+0x2f>
    26fb:	66 89 c3             	mov    %ax,%bx
	else if (mode == EXTENDED_VGA)
    26fe:	83 f8 fe             	cmp    $0xfffffffe,%eax
    2701:	75 06                	jne    2709 <set_mode+0x2f>
		mode = VIDEO_8POINT;
    2703:	66 bb 01 0f          	mov    $0xf01,%bx
    2707:	00 00                	add    %al,(%eax)
	mode &= ~VIDEO_RECALC;
    2709:	66 89 dd             	mov    %bx,%bp
    270c:	81 e5 ff 7f 66 ba    	and    $0xba667fff,%ebp
	for (card = video_cards; card < video_cards_end; card++) {
    2712:	68 35 00 00 67       	push   $0x67000035
	nmode = 0;
    2717:	66 c7 44 24 08 00 00 	movw   $0x0,0x8(%esp)
    271e:	00 00                	add    %al,(%eax)
			if ((mode == nmode && visible) ||
    2720:	66 89 d8             	mov    %bx,%ax
    2723:	66 25 ff 7f          	and    $0x7fff,%ax
    2727:	00 00                	add    %al,(%eax)
    2729:	67 66 89 44 24       	mov    %ax,0x24(%si)
    272e:	10 66 81             	adc    %ah,-0x7f(%esi)
	for (card = video_cards; card < video_cards_end; card++) {
    2731:	fa                   	cli    
    2732:	bc 35 00 00 0f       	mov    $0xf000035,%esp
    2737:	83 b4 00 67 66 8b 42 	xorl   $0xc,0x428b6667(%eax,%eax,1)
    273e:	0c 
		for (i = 0; i < card->nmodes; i++, mi++) {
    273f:	67 66 8b 72 10       	mov    0x10(%bp,%si),%si
    2744:	67 66 89 74 24       	mov    %si,0x24(%si)
    2749:	14 67                	adc    $0x67,%al
    274b:	66 c7 44 24 0c 00 00 	movw   $0x0,0xc(%esp)
    2752:	00 00                	add    %al,(%eax)
    2754:	67 66 8b 74 24       	mov    0x24(%si),%si
    2759:	14 67                	adc    $0x67,%al
    275b:	66 39 74 24 0c       	cmp    %si,0xc(%esp)
    2760:	0f 8d 83 00 67 8b    	jge    8b6727e9 <image_base+0x8a6727e9>
			int visible = mi->x || mi->y;
    2766:	70 02                	jo     276a <set_mode+0x90>
    2768:	67 89 74 24          	mov    %esi,0x24(%si)
    276c:	06                   	push   %es
    276d:	67 66 c7 04 24 01    	movw   $0x124,(%si)
    2773:	00 00                	add    %al,(%eax)
    2775:	00 85 f6 75 10 66    	add    %al,0x661075f6(%ebp)
    277b:	31 c9                	xor    %ecx,%ecx
    277d:	67 83 78 04 00       	cmpl   $0x0,0x4(%bx,%si)
    2782:	0f 95 c1             	setne  %cl
    2785:	67 66 89 0c          	mov    %cx,(%si)
    2789:	24 67                	and    $0x67,%al
			if ((mode == nmode && visible) ||
    278b:	8b 30                	mov    (%eax),%esi
    278d:	67 66 8b 7c 24       	mov    0x24(%si),%di
    2792:	08 67 66             	or     %ah,0x66(%edi)
    2795:	39 7c 24 10          	cmp    %edi,0x10(%esp)
    2799:	75 08                	jne    27a3 <set_mode+0xc9>
    279b:	67 66 83 3c 24       	cmpw   $0x24,(%si)
    27a0:	00 75 20             	add    %dh,0x20(%ebp)
    27a3:	39 f5                	cmp    %esi,%ebp
    27a5:	74 1c                	je     27c3 <set_mode+0xe9>
			    mode == (mi->y << 8)+mi->x) {
    27a7:	67 66 0f b7 48 04    	movzww 0x4(%bx,%si),%cx
    27ad:	66 c1 e1 08          	shl    $0x8,%cx
    27b1:	67 66 0f b7 7c 24    	movzww 0x24(%si),%di
    27b7:	06                   	push   %es
    27b8:	66 01 cf             	add    %cx,%di
			    mode == mi->mode ||
    27bb:	67 66 39 7c 24       	cmp    %di,0x24(%si)
    27c0:	10 75 0a             	adc    %dh,0xa(%ebp)
				return card->set_mode(mi);
    27c3:	67 66 ff 52 04       	callw  *0x4(%bp,%si)
    27c8:	66 89 c7             	mov    %ax,%di
    27cb:	eb 7b                	jmp    2848 <set_mode+0x16e>
				nmode++;
    27cd:	67 66 83 3c 24       	cmpw   $0x24,(%si)
    27d2:	01 67 66             	add    %esp,0x66(%edi)
    27d5:	83 5c 24 08 ff       	sbbl   $0xffffffff,0x8(%esp)
		for (i = 0; i < card->nmodes; i++, mi++) {
    27da:	67 66 ff 44 24       	incw   0x24(%si)
    27df:	0c 66                	or     $0x66,%al
    27e1:	83 c0 08             	add    $0x8,%eax
    27e4:	e9 6d ff 66 83       	jmp    83672756 <image_base+0x82672756>
	for (card = video_cards; card < video_cards_end; card++) {
    27e9:	c2 1c e9             	ret    $0xe91c
    27ec:	41                   	inc    %ecx
    27ed:	ff 66 ba             	jmp    *-0x46(%esi)
	for (card = video_cards; card < video_cards_end; card++) {
    27f0:	68 35 00 00 66       	push   $0x66000035
		    mode < card->xmode_first+card->xmode_n) {
    27f5:	0f b7 cd             	movzwl %bp,%ecx
	for (card = video_cards; card < video_cards_end; card++) {
    27f8:	66 81 fa bc 35       	cmp    $0x35bc,%dx
    27fd:	00 00                	add    %al,(%eax)
    27ff:	73 40                	jae    2841 <set_mode+0x167>
		if (mode >= card->xmode_first &&
    2801:	67 66 0f b7 42 18    	movzww 0x18(%bp,%si),%ax
    2807:	39 c5                	cmp    %eax,%ebp
    2809:	72 30                	jb     283b <set_mode+0x161>
		    mode < card->xmode_first+card->xmode_n) {
    280b:	67 66 0f b7 72 1a    	movzww 0x1a(%bp,%si),%si
    2811:	66 01 f0             	add    %si,%ax
		if (mode >= card->xmode_first &&
    2814:	66 39 c1             	cmp    %ax,%cx
    2817:	7d 22                	jge    283b <set_mode+0x161>
			*real_mode = mix.mode = mode;
    2819:	67 89 6c 24          	mov    %ebp,0x24(%si)
    281d:	18 67 66             	sbb    %ah,0x66(%edi)
			mix.x = mix.y = 0;
    2820:	c7 44 24 1a 00 00 00 	movl   $0x0,0x1a(%esp)
    2827:	00 
			return card->set_mode(&mix);
    2828:	67 66 8d 44 24       	lea    0x24(%si),%ax
    282d:	18 67 66             	sbb    %ah,0x66(%edi)
    2830:	ff 52 04             	call   *0x4(%edx)
    2833:	66 89 c7             	mov    %ax,%di
    2836:	66 89 ee             	mov    %bp,%si
    2839:	eb 0d                	jmp    2848 <set_mode+0x16e>
	for (card = video_cards; card < video_cards_end; card++) {
    283b:	66 83 c2 1c          	add    $0x1c,%dx
    283f:	eb b7                	jmp    27f8 <set_mode+0x11e>
	return -1;
    2841:	66 83 cf ff          	or     $0xffff,%di
    2845:	e9 a2 00 66 85       	jmp    856628ec <image_base+0x846628ec>

	rv = raw_set_mode(mode, &real_mode);
	if (rv)
    284a:	ff 0f                	decl   (%edi)
    284c:	85 9b 00 85 db 0f    	test   %ebx,0xfdb8500(%ebx)
		return rv;

	if (mode & VIDEO_RECALC)
    2852:	89 91 00 66 31 c0    	mov    %edx,-0x3fce9a00(%ecx)
    2858:	8e e0                	mov    %eax,%fs
	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
    285a:	64 8a 1e             	mov    %fs:(%esi),%bl
    285d:	85 04 66             	test   %eax,(%esi,%eiz,2)
	font_size = rdfs8(0x485); /* BIOS: font size (pixels) */
    2860:	0f b6 d3             	movzbl %bl,%edx
	rows = force_y ? force_y : rdfs8(0x484)+1; /* Text rows */
    2863:	66 8b 1e             	mov    (%esi),%bx
    2866:	7c 49                	jl     28b1 <set_mode+0x1d7>
    2868:	66 85 db             	test   %bx,%bx
    286b:	75 0d                	jne    287a <set_mode+0x1a0>
    286d:	64 a0 84 04 66 0f    	mov    %fs:0xf660484,%al
    2873:	b6 c0                	mov    $0xc0,%dh
    2875:	67 66 8d 58 01       	lea    0x1(%bx,%si),%bx
	rows *= font_size;	/* Visible scan lines */
    287a:	66 0f af da          	imul   %dx,%bx
	rows--;			/* ... minus one */
    287e:	66 4b                	dec    %bx
	crtc = vga_crtc();
    2880:	66 e8 21 02          	callw  2aa5 <vga_set_14font+0x69>
    2884:	00 00                	add    %al,(%eax)
    2886:	66 89 c1             	mov    %ax,%cx
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    2889:	b0 11                	mov    $0x11,%al
    288b:	66 89 ca             	mov    %cx,%dx
    288e:	ee                   	out    %al,(%dx)

/* Accessing VGA indexed registers */
static inline u8 in_idx(u16 port, u8 index)
{
	outb(index, port);
	return inb(port+1);
    288f:	67 66 8d 69 01       	lea    0x1(%bx,%di),%bp
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2894:	66 89 ea             	mov    %bp,%dx
    2897:	ec                   	in     (%dx),%al
}

static inline void out_idx(u8 v, u16 port, u8 index)
{
	outw(index+(v << 8), port);
    2898:	66 83 e0 7f          	and    $0x7f,%ax
    289c:	66 c1 e0 08          	shl    $0x8,%ax
    28a0:	66 83 c0 11          	add    $0x11,%ax
	asm volatile("outw %0,%1" : : "a" (v), "dN" (port));
    28a4:	66 89 ca             	mov    %cx,%dx
    28a7:	ef                   	out    %eax,(%dx)
    28a8:	66 89 d8             	mov    %bx,%ax
    28ab:	66 c1 e0 08          	shl    $0x8,%ax
    28af:	66 83 c0 12          	add    $0x12,%ax
    28b3:	ef                   	out    %eax,(%dx)
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    28b4:	b0 07                	mov    $0x7,%al
    28b6:	ee                   	out    %al,(%dx)
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    28b7:	66 89 ea             	mov    %bp,%dx
    28ba:	ec                   	in     (%dx),%al
	ov &= 0xbd;
    28bb:	66 83 e0 bd          	and    $0xffbd,%ax
    28bf:	88 c2                	mov    %al,%dl
	ov |= (rows >> (8-1)) & 0x02;
    28c1:	66 89 d8             	mov    %bx,%ax
    28c4:	66 c1 e8 07          	shr    $0x7,%ax
    28c8:	66 83 e0 02          	and    $0x2,%ax
	ov |= (rows >> (9-6)) & 0x40;
    28cc:	66 c1 eb 03          	shr    $0x3,%bx
    28d0:	66 83 e3 40          	and    $0x40,%bx
    28d4:	66 09 d8             	or     %bx,%ax
    28d7:	66 09 d0             	or     %dx,%ax
    28da:	66 c1 e0 08          	shl    $0x8,%ax
    28de:	66 83 c0 07          	add    $0x7,%ax
	asm volatile("outw %0,%1" : : "a" (v), "dN" (port));
    28e2:	66 89 ca             	mov    %cx,%dx
    28e5:	ef                   	out    %eax,(%dx)
		vga_recalc_vertical();

	/* Save the canonical mode number for the kernel, not
	   an alias, size specification or menu position */
#ifndef _WAKEUP
	boot_params.hdr.vid_mode = real_mode;
    28e6:	89 36                	mov    %esi,(%esi)
    28e8:	6a 3b                	push   $0x3b
#endif
	return 0;
}
    28ea:	66 89 f8             	mov    %di,%ax
    28ed:	66 83 c4 20          	add    $0x20,%sp
    28f1:	66 5b                	pop    %bx
    28f3:	66 5e                	pop    %si
    28f5:	66 5f                	pop    %di
    28f7:	66 5d                	pop    %bp
    28f9:	66 c3                	retw   

000028fb <vga_probe>:
 * Note: this probe includes basic information required by all
 * systems.  It should be executed first, by making sure
 * video-vga.c is listed first in the Makefile.
 */
static int vga_probe(void)
{
    28fb:	66 83 ec 58          	sub    $0x58,%sp
		ARRAY_SIZE(vga_modes),
	};

	struct biosregs ireg, oreg;

	initregs(&ireg);
    28ff:	66 89 e0             	mov    %sp,%ax
    2902:	66 e8 a6 f1          	callw  1aac <printf+0x3c>
    2906:	ff                   	(bad)  
    2907:	ff 67 c7             	jmp    *-0x39(%edi)

	ireg.ax = 0x1200;
    290a:	44                   	inc    %esp
    290b:	24 1c                	and    $0x1c,%al
    290d:	00 12                	add    %dl,(%edx)
	ireg.bl = 0x10;		/* Check EGA/VGA */
    290f:	67 c6 44 24 10       	movb   $0x10,0x24(%si)
    2914:	10 67 66             	adc    %ah,0x66(%edi)
	intcall(0x10, &ireg, &oreg);
    2917:	8d 4c 24 2c          	lea    0x2c(%esp),%ecx
    291b:	66 89 e2             	mov    %sp,%dx
    291e:	66 b8 10 00          	mov    $0x10,%ax
    2922:	00 00                	add    %al,(%eax)
    2924:	66 e8 aa d9          	callw  2d2 <die+0x1>
    2928:	ff                   	(bad)  
    2929:	ff 67 66             	jmp    *0x66(%edi)

#ifndef _WAKEUP
	boot_params.screen_info.orig_video_ega_bx = oreg.bx;
    292c:	8b 44 24 3c          	mov    0x3c(%esp),%eax
    2930:	a3 7a 39 67 80       	mov    %eax,0x8067397a
#endif

	/* If we have MDA/CGA/HGC then BL will be unchanged at 0x10 */
	if (oreg.bl != 0x10) {
    2935:	7c 24                	jl     295b <vga_probe+0x60>
    2937:	3c 10                	cmp    $0x10,%al
    2939:	74 3f                	je     297a <vga_probe+0x7f>
		/* EGA/VGA */
		ireg.ax = 0x1a00;
    293b:	67 c7 44 24 1c 00 1a 	movl   $0x671a001c,0x24(%si)
    2942:	67 
		intcall(0x10, &ireg, &oreg);
    2943:	66 8d 4c 24 2c       	lea    0x2c(%esp),%cx
    2948:	66 89 e2             	mov    %sp,%dx
    294b:	66 b8 10 00          	mov    $0x10,%ax
    294f:	00 00                	add    %al,(%eax)
    2951:	66 e8 7d d9          	callw  2d2 <die+0x1>
    2955:	ff                   	(bad)  
    2956:	ff 67 80             	jmp    *-0x80(%edi)

		if (oreg.al == 0x1a) {
    2959:	7c 24                	jl     297f <vga_probe+0x84>
    295b:	48                   	dec    %eax
    295c:	1a 75 10             	sbb    0x10(%ebp),%dh
			adapter = ADAPTER_VGA;
    295f:	66 c7 06 78 49       	movw   $0x4978,(%esi)
    2964:	02 00                	add    (%eax),%al
    2966:	00 00                	add    %al,(%eax)
#ifndef _WAKEUP
			boot_params.screen_info.orig_video_isVGA = 1;
    2968:	c6 06 7f             	movb   $0x7f,(%esi)
    296b:	39 01                	cmp    %eax,(%ecx)
    296d:	eb 14                	jmp    2983 <vga_probe+0x88>
#endif
		} else {
			adapter = ADAPTER_EGA;
    296f:	66 c7 06 78 49       	movw   $0x4978,(%esi)
    2974:	01 00                	add    %eax,(%eax)
    2976:	00 00                	add    %al,(%eax)
    2978:	eb 09                	jmp    2983 <vga_probe+0x88>
		}
	} else {
		adapter = ADAPTER_CGA;
    297a:	66 c7 06 78 49       	movw   $0x4978,(%esi)
    297f:	00 00                	add    %al,(%eax)
    2981:	00 00                	add    %al,(%eax)
	}

	video_vga.modes = mode_lists[adapter];
    2983:	66 a1 78 49 67 66    	mov    0x66674978,%ax
    2989:	8b 14 85 3c 35 00 00 	mov    0x353c(,%eax,4),%edx
    2990:	66 89 16             	mov    %dx,(%esi)
    2993:	74 35                	je     29ca <vga_set_8font+0x18>
	video_vga.card_name = card_name[adapter];
    2995:	67 66 8b 14          	mov    (%si),%dx
    2999:	85 30                	test   %esi,(%eax)
    299b:	35 00 00 66 89       	xor    $0x89660000,%eax
    29a0:	16                   	push   %ss
    29a1:	68 35 67 66 8b       	push   $0x8b666735
	return mode_count[adapter];
    29a6:	04 85                	add    $0x85,%al
    29a8:	24 35                	and    $0x35,%al
    29aa:	00 00                	add    %al,(%eax)
}
    29ac:	66 83 c4 58          	add    $0x58,%sp
    29b0:	66 c3                	retw   

000029b2 <vga_set_8font>:
{
    29b2:	66 83 ec 2c          	sub    $0x2c,%sp
	initregs(&ireg);
    29b6:	66 89 e0             	mov    %sp,%ax
    29b9:	66 e8 ef f0          	callw  1aac <printf+0x3c>
    29bd:	ff                   	(bad)  
    29be:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1112;
    29c1:	44                   	inc    %esp
    29c2:	24 1c                	and    $0x1c,%al
    29c4:	12 11                	adc    (%ecx),%dl
	intcall(0x10, &ireg, NULL);
    29c6:	66 31 c9             	xor    %cx,%cx
    29c9:	66 89 e2             	mov    %sp,%dx
    29cc:	66 b8 10 00          	mov    $0x10,%ax
    29d0:	00 00                	add    %al,(%eax)
    29d2:	66 e8 fc d8          	callw  2d2 <die+0x1>
    29d6:	ff                   	(bad)  
    29d7:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1200;
    29da:	44                   	inc    %esp
    29db:	24 1c                	and    $0x1c,%al
    29dd:	00 12                	add    %dl,(%edx)
	ireg.bl = 0x20;
    29df:	67 c6 44 24 10       	movb   $0x10,0x24(%si)
    29e4:	20 66 31             	and    %ah,0x31(%esi)
	intcall(0x10, &ireg, NULL);
    29e7:	c9                   	leave  
    29e8:	66 89 e2             	mov    %sp,%dx
    29eb:	66 b8 10 00          	mov    $0x10,%ax
    29ef:	00 00                	add    %al,(%eax)
    29f1:	66 e8 dd d8          	callw  2d2 <die+0x1>
    29f5:	ff                   	(bad)  
    29f6:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1201;
    29f9:	44                   	inc    %esp
    29fa:	24 1c                	and    $0x1c,%al
    29fc:	01 12                	add    %edx,(%edx)
	ireg.bl = 0x34;
    29fe:	67 c6 44 24 10       	movb   $0x10,0x24(%si)
    2a03:	34 66                	xor    $0x66,%al
	intcall(0x10, &ireg, NULL);
    2a05:	31 c9                	xor    %ecx,%ecx
    2a07:	66 89 e2             	mov    %sp,%dx
    2a0a:	66 b8 10 00          	mov    $0x10,%ax
    2a0e:	00 00                	add    %al,(%eax)
    2a10:	66 e8 be d8          	callw  2d2 <die+0x1>
    2a14:	ff                   	(bad)  
    2a15:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x0100;
    2a18:	44                   	inc    %esp
    2a19:	24 1c                	and    $0x1c,%al
    2a1b:	00 01                	add    %al,(%ecx)
	ireg.cx = 0x0607;
    2a1d:	67 c7 44 24 18 07 06 	movl   $0x66060718,0x24(%si)
    2a24:	66 
	intcall(0x10, &ireg, NULL);
    2a25:	31 c9                	xor    %ecx,%ecx
    2a27:	66 89 e2             	mov    %sp,%dx
    2a2a:	66 b8 10 00          	mov    $0x10,%ax
    2a2e:	00 00                	add    %al,(%eax)
    2a30:	66 e8 9e d8          	callw  2d2 <die+0x1>
    2a34:	ff                   	(bad)  
    2a35:	ff 66 83             	jmp    *-0x7d(%esi)
}
    2a38:	c4 2c 66             	les    (%esi,%eiz,2),%ebp
    2a3b:	c3                   	ret    

00002a3c <vga_set_14font>:
{
    2a3c:	66 83 ec 2c          	sub    $0x2c,%sp
	initregs(&ireg);
    2a40:	66 89 e0             	mov    %sp,%ax
    2a43:	66 e8 65 f0          	callw  1aac <printf+0x3c>
    2a47:	ff                   	(bad)  
    2a48:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1111;
    2a4b:	44                   	inc    %esp
    2a4c:	24 1c                	and    $0x1c,%al
    2a4e:	11 11                	adc    %edx,(%ecx)
	intcall(0x10, &ireg, NULL);
    2a50:	66 31 c9             	xor    %cx,%cx
    2a53:	66 89 e2             	mov    %sp,%dx
    2a56:	66 b8 10 00          	mov    $0x10,%ax
    2a5a:	00 00                	add    %al,(%eax)
    2a5c:	66 e8 72 d8          	callw  2d2 <die+0x1>
    2a60:	ff                   	(bad)  
    2a61:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1201;
    2a64:	44                   	inc    %esp
    2a65:	24 1c                	and    $0x1c,%al
    2a67:	01 12                	add    %edx,(%edx)
	ireg.bl = 0x34;
    2a69:	67 c6 44 24 10       	movb   $0x10,0x24(%si)
    2a6e:	34 66                	xor    $0x66,%al
	intcall(0x10, &ireg, NULL);
    2a70:	31 c9                	xor    %ecx,%ecx
    2a72:	66 89 e2             	mov    %sp,%dx
    2a75:	66 b8 10 00          	mov    $0x10,%ax
    2a79:	00 00                	add    %al,(%eax)
    2a7b:	66 e8 53 d8          	callw  2d2 <die+0x1>
    2a7f:	ff                   	(bad)  
    2a80:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x0100;
    2a83:	44                   	inc    %esp
    2a84:	24 1c                	and    $0x1c,%al
    2a86:	00 01                	add    %al,(%ecx)
	ireg.cx = 0x0b0c;
    2a88:	67 c7 44 24 18 0c 0b 	movl   $0x660b0c18,0x24(%si)
    2a8f:	66 
	intcall(0x10, &ireg, NULL);
    2a90:	31 c9                	xor    %ecx,%ecx
    2a92:	66 89 e2             	mov    %sp,%dx
    2a95:	66 b8 10 00          	mov    $0x10,%ax
    2a99:	00 00                	add    %al,(%eax)
    2a9b:	66 e8 33 d8          	callw  2d2 <die+0x1>
    2a9f:	ff                   	(bad)  
    2aa0:	ff 66 83             	jmp    *-0x7d(%esi)
}
    2aa3:	c4 2c 66             	les    (%esi,%eiz,2),%ebp
    2aa6:	c3                   	ret    

00002aa7 <vga_crtc>:
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2aa7:	66 ba cc 03          	mov    $0x3cc,%dx
    2aab:	00 00                	add    %al,(%eax)
    2aad:	ec                   	in     (%dx),%al
    2aae:	88 c2                	mov    %al,%dl
	return (inb(0x3cc) & 1) ? 0x3d4 : 0x3b4;
    2ab0:	66 b8 d4 03          	mov    $0x3d4,%ax
    2ab4:	00 00                	add    %al,(%eax)
    2ab6:	80 e2 01             	and    $0x1,%dl
    2ab9:	75 06                	jne    2ac1 <vga_crtc+0x1a>
    2abb:	66 b8 b4 03          	mov    $0x3b4,%ax
    2abf:	00 00                	add    %al,(%eax)
}
    2ac1:	66 c3                	retw   

00002ac3 <vga_set_480_scanlines>:
	crtc = vga_crtc();
    2ac3:	66 e8 de ff          	callw  2aa5 <vga_set_14font+0x69>
    2ac7:	ff                   	(bad)  
    2ac8:	ff 66 89             	jmp    *-0x77(%esi)
    2acb:	c2 66 b8             	ret    $0xb866
	asm volatile("outw %0,%1" : : "a" (v), "dN" (port));
    2ace:	11 0c 00             	adc    %ecx,(%eax,%eax,1)
    2ad1:	00 ef                	add    %ch,%bh
    2ad3:	66 b8 06 0b          	mov    $0xb06,%ax
    2ad7:	00 00                	add    %al,(%eax)
    2ad9:	ef                   	out    %eax,(%dx)
    2ada:	66 b8 07 3e          	mov    $0x3e07,%ax
    2ade:	00 00                	add    %al,(%eax)
    2ae0:	ef                   	out    %eax,(%dx)
    2ae1:	66 b8 10 ea          	mov    $0xea10,%ax
    2ae5:	ff                   	(bad)  
    2ae6:	ff                   	(bad)  
    2ae7:	ef                   	out    %eax,(%dx)
    2ae8:	66 b8 12 df          	mov    $0xdf12,%ax
    2aec:	ff                   	(bad)  
    2aed:	ff                   	(bad)  
    2aee:	ef                   	out    %eax,(%dx)
    2aef:	66 b8 15 e7          	mov    $0xe715,%ax
    2af3:	ff                   	(bad)  
    2af4:	ff                   	(bad)  
    2af5:	ef                   	out    %eax,(%dx)
    2af6:	66 b8 16 04          	mov    $0x416,%ax
    2afa:	00 00                	add    %al,(%eax)
    2afc:	ef                   	out    %eax,(%dx)
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2afd:	66 ba cc 03          	mov    $0x3cc,%dx
    2b01:	00 00                	add    %al,(%eax)
    2b03:	ec                   	in     (%dx),%al
	csel &= 0x0d;
    2b04:	66 83 e0 0d          	and    $0xd,%ax
	csel |= 0xe2;
    2b08:	66 83 c8 e2          	or     $0xffe2,%ax
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    2b0c:	66 ba c2 03          	mov    $0x3c2,%dx
    2b10:	00 00                	add    %al,(%eax)
    2b12:	ee                   	out    %al,(%dx)
}
    2b13:	66 c3                	retw   

00002b15 <vga_set_mode>:
{
    2b15:	66 53                	push   %bx
    2b17:	66 83 ec 58          	sub    $0x58,%sp
    2b1b:	66 89 c3             	mov    %ax,%bx
	initregs(&ireg);
    2b1e:	66 89 e0             	mov    %sp,%ax
    2b21:	66 e8 87 ef          	callw  1aac <printf+0x3c>
    2b25:	ff                   	(bad)  
    2b26:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x0f00;
    2b29:	44                   	inc    %esp
    2b2a:	24 1c                	and    $0x1c,%al
    2b2c:	00 0f                	add    %cl,(%edi)
	intcall(0x10, &ireg, &oreg);
    2b2e:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    2b33:	2c 66                	sub    $0x66,%al
    2b35:	89 e2                	mov    %esp,%edx
    2b37:	66 b8 10 00          	mov    $0x10,%ax
    2b3b:	00 00                	add    %al,(%eax)
    2b3d:	66 e8 91 d7          	callw  2d2 <die+0x1>
    2b41:	ff                   	(bad)  
    2b42:	ff 67 66             	jmp    *0x66(%edi)
	mode = oreg.al;
    2b45:	0f b6 44 24 48       	movzbl 0x48(%esp),%eax
	if (mode != 3 && mode != 7)
    2b4a:	3c 07                	cmp    $0x7,%al
    2b4c:	74 06                	je     2b54 <vga_set_mode+0x3f>
		mode = 3;
    2b4e:	66 b8 03 00          	mov    $0x3,%ax
    2b52:	00 00                	add    %al,(%eax)
	ireg.ax = mode;		/* AH=0: set mode */
    2b54:	67 89 44 24          	mov    %eax,0x24(%si)
    2b58:	1c 66                	sbb    $0x66,%al
	intcall(0x10, &ireg, NULL);
    2b5a:	31 c9                	xor    %ecx,%ecx
    2b5c:	66 89 e2             	mov    %sp,%dx
    2b5f:	66 b8 10 00          	mov    $0x10,%ax
    2b63:	00 00                	add    %al,(%eax)
    2b65:	66 e8 69 d7          	callw  2d2 <die+0x1>
    2b69:	ff                   	(bad)  
    2b6a:	ff 66 c7             	jmp    *-0x39(%esi)
	do_restore = 1;
    2b6d:	06                   	push   %es
    2b6e:	74 49                	je     2bb9 <vga_set_mode+0xa4>
    2b70:	01 00                	add    %eax,(%eax)
    2b72:	00 00                	add    %al,(%eax)
	force_x = mode->x;
    2b74:	67 66 0f b7 43 02    	movzww 0x2(%bp,%di),%ax
    2b7a:	66 a3 80 49 67 66    	mov    %ax,0x66674980
	force_y = mode->y;
    2b80:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
    2b84:	66 a3 7c 49 67 8b    	mov    %ax,0x8b67497c
	switch (mode->mode) {
    2b8a:	03 2d 01 0f 83 f8    	add    0xf8830f01,%ebp
    2b90:	06                   	push   %es
    2b91:	0f 87 b5 00 66 0f    	ja     f662c4c <image_base+0xe662c4c>
    2b97:	b7 c0                	mov    $0xc0,%bh
    2b99:	67 ff 24             	jmp    *(%si)
    2b9c:	85 08                	test   %ecx,(%eax)
    2b9e:	35 00 00 67 66       	xor    $0x66670000,%eax
	initregs(&ireg);
    2ba3:	8d 44 24 2c          	lea    0x2c(%esp),%eax
    2ba7:	66 e8 01 ef          	callw  1aac <printf+0x3c>
    2bab:	ff                   	(bad)  
    2bac:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x1201;
    2baf:	44                   	inc    %esp
    2bb0:	24 48                	and    $0x48,%al
    2bb2:	01 12                	add    %edx,(%edx)
	ireg.bl = 0x30;
    2bb4:	67 c6 44 24 3c       	movb   $0x3c,0x24(%si)
    2bb9:	30 66 31             	xor    %ah,0x31(%esi)
	intcall(0x10, &ireg, NULL);
    2bbc:	c9                   	leave  
    2bbd:	67 66 8d 54 24       	lea    0x24(%si),%dx
    2bc2:	2c 66                	sub    $0x66,%al
    2bc4:	b8 10 00 00 00       	mov    $0x10,%eax
    2bc9:	66 e8 05 d7          	callw  2d2 <die+0x1>
    2bcd:	ff                   	(bad)  
    2bce:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x0003;
    2bd1:	44                   	inc    %esp
    2bd2:	24 48                	and    $0x48,%al
    2bd4:	03 00                	add    (%eax),%eax
	intcall(0x10, &ireg, NULL);
    2bd6:	66 31 c9             	xor    %cx,%cx
    2bd9:	67 66 8d 54 24       	lea    0x24(%si),%dx
    2bde:	2c 66                	sub    $0x66,%al
    2be0:	b8 10 00 00 00       	mov    $0x10,%eax
    2be5:	66 e8 e9 d6          	callw  2d2 <die+0x1>
    2be9:	ff                   	(bad)  
    2bea:	ff 66 e8             	jmp    *-0x18(%esi)
	vga_set_8font();
    2bed:	c1 fd ff             	sar    $0xff,%ebp
    2bf0:	ff                   	(bad)  
}
    2bf1:	eb 57                	jmp    2c4a <vga_set_mode+0x135>
		vga_set_14font();
    2bf3:	66 e8 43 fe          	callw  2a3a <vga_set_8font+0x88>
    2bf7:	ff                   	(bad)  
    2bf8:	ff                   	(bad)  
		break;
    2bf9:	eb 4f                	jmp    2c4a <vga_set_mode+0x135>
	vga_set_480_scanlines();
    2bfb:	66 e8 c2 fe          	callw  2ac1 <vga_crtc+0x1a>
    2bff:	ff                   	(bad)  
    2c00:	ff                   	(bad)  
	crtc = vga_crtc();
    2c01:	eb 30                	jmp    2c33 <vga_set_mode+0x11e>
	vga_set_480_scanlines();
    2c03:	66 e8 ba fe          	callw  2ac1 <vga_crtc+0x1a>
    2c07:	ff                   	(bad)  
    2c08:	ff 66 e8             	jmp    *-0x18(%esi)
	vga_set_14font();
    2c0b:	2d fe ff ff 66       	sub    $0x66fffffe,%eax
	crtc = vga_crtc();
    2c10:	e8 92 fe ff ff       	call   2aa7 <vga_crtc>
    2c15:	66 89 c2             	mov    %ax,%dx
	asm volatile("outw %0,%1" : : "a" (v), "dN" (port));
    2c18:	66 b8 07 3e          	mov    $0x3e07,%ax
    2c1c:	00 00                	add    %al,(%eax)
    2c1e:	ef                   	out    %eax,(%dx)
    2c1f:	66 b8 12 db          	mov    $0xdb12,%ax
    2c23:	ff                   	(bad)  
    2c24:	ff                   	(bad)  
    2c25:	eb 22                	jmp    2c49 <vga_set_mode+0x134>
	vga_set_480_scanlines();
    2c27:	66 e8 96 fe          	callw  2ac1 <vga_crtc+0x1a>
    2c2b:	ff                   	(bad)  
    2c2c:	ff 66 e8             	jmp    *-0x18(%esi)
	vga_set_8font();
    2c2f:	7f fd                	jg     2c2e <vga_set_mode+0x119>
    2c31:	ff                   	(bad)  
    2c32:	ff 66 e8             	jmp    *-0x18(%esi)
	crtc = vga_crtc();
    2c35:	6e                   	outsb  %ds:(%esi),(%dx)
    2c36:	fe                   	(bad)  
    2c37:	ff                   	(bad)  
    2c38:	ff 66 89             	jmp    *-0x77(%esi)
    2c3b:	c2 66 b8             	ret    $0xb866
    2c3e:	07                   	pop    %es
    2c3f:	3e 00 00             	add    %al,%ds:(%eax)
    2c42:	ef                   	out    %eax,(%dx)
    2c43:	66 b8 12 df          	mov    $0xdf12,%ax
    2c47:	ff                   	(bad)  
    2c48:	ff                   	(bad)  
    2c49:	ef                   	out    %eax,(%dx)
}
    2c4a:	66 31 c0             	xor    %ax,%ax
    2c4d:	66 83 c4 58          	add    $0x58,%sp
    2c51:	66 5b                	pop    %bx
    2c53:	66 c3                	retw   

00002c55 <vesa_set_mode>:

	return nmodes;
}

static int vesa_set_mode(struct mode_info *mode)
{
    2c55:	66 55                	push   %bp
    2c57:	66 57                	push   %di
    2c59:	66 56                	push   %si
    2c5b:	66 53                	push   %bx
    2c5d:	66 83 ec 58          	sub    $0x58,%sp
    2c61:	66 89 c3             	mov    %ax,%bx
	struct biosregs ireg, oreg;
	int is_graphic;
	u16 vesa_mode = mode->mode - VIDEO_FIRST_VESA;
    2c64:	67 8b 00             	mov    (%bx,%si),%eax
    2c67:	67 66 8d b0 00 fe    	lea    -0x200(%bx,%si),%si
    2c6d:	ff                   	(bad)  
    2c6e:	ff 66 bd             	jmp    *-0x43(%esi)

	memset(&vminfo, 0, sizeof(vminfo)); /* Just in case... */
    2c71:	00 37                	add    %dh,(%edi)
    2c73:	00 00                	add    %al,(%eax)
    2c75:	66 b9 40 00          	mov    $0x40,%cx
    2c79:	00 00                	add    %al,(%eax)
    2c7b:	66 31 c0             	xor    %ax,%ax
    2c7e:	66 89 ef             	mov    %bp,%di
    2c81:	66 f3 ab             	rep stos %ax,%es:(%edi)

	initregs(&ireg);
    2c84:	66 89 e0             	mov    %sp,%ax
    2c87:	66 e8 21 ee          	callw  1aac <printf+0x3c>
    2c8b:	ff                   	(bad)  
    2c8c:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x4f01;
    2c8f:	44                   	inc    %esp
    2c90:	24 1c                	and    $0x1c,%al
    2c92:	01 4f 67             	add    %ecx,0x67(%edi)
	ireg.cx = vesa_mode;
    2c95:	89 74 24 18          	mov    %esi,0x18(%esp)
	ireg.di = (size_t)&vminfo;
    2c99:	67 89 2c             	mov    %ebp,(%si)
    2c9c:	24 67                	and    $0x67,%al
	intcall(0x10, &ireg, &oreg);
    2c9e:	66 8d 4c 24 2c       	lea    0x2c(%esp),%cx
    2ca3:	66 89 e2             	mov    %sp,%dx
    2ca6:	66 b8 10 00          	mov    $0x10,%ax
    2caa:	00 00                	add    %al,(%eax)
    2cac:	66 e8 22 d6          	callw  2d2 <die+0x1>
    2cb0:	ff                   	(bad)  
    2cb1:	ff 67 83             	jmp    *-0x7d(%edi)

	if (oreg.ax != 0x004f)
    2cb4:	7c 24                	jl     2cda <vesa_set_mode+0x85>
    2cb6:	48                   	dec    %eax
    2cb7:	4f                   	dec    %edi
    2cb8:	74 06                	je     2cc0 <vesa_set_mode+0x6b>
		return -1;
    2cba:	66 83 c8 ff          	or     $0xffff,%ax
    2cbe:	eb 68                	jmp    2d28 <vesa_set_mode+0xd3>

	if ((vminfo.mode_attr & 0x15) == 0x05) {
    2cc0:	66 a1 00 37 66 83    	mov    0x83663700,%ax
    2cc6:	e0 15                	loopne 2cdd <vesa_set_mode+0x88>
    2cc8:	83 f8 05             	cmp    $0x5,%eax
    2ccb:	75 ed                	jne    2cba <vesa_set_mode+0x65>
	} else {
		return -1;	/* Invalid mode */
	}


	initregs(&ireg);
    2ccd:	66 89 e0             	mov    %sp,%ax
    2cd0:	66 e8 d8 ed          	callw  1aac <printf+0x3c>
    2cd4:	ff                   	(bad)  
    2cd5:	ff 67 c7             	jmp    *-0x39(%edi)
	ireg.ax = 0x4f02;
    2cd8:	44                   	inc    %esp
    2cd9:	24 1c                	and    $0x1c,%al
    2cdb:	02 4f 67             	add    0x67(%edi),%cl
	ireg.bx = vesa_mode;
    2cde:	89 74 24 10          	mov    %esi,0x10(%esp)
	intcall(0x10, &ireg, &oreg);
    2ce2:	67 66 8d 4c 24       	lea    0x24(%si),%cx
    2ce7:	2c 66                	sub    $0x66,%al
    2ce9:	89 e2                	mov    %esp,%edx
    2ceb:	66 b8 10 00          	mov    $0x10,%ax
    2cef:	00 00                	add    %al,(%eax)
    2cf1:	66 e8 dd d5          	callw  2d2 <die+0x1>
    2cf5:	ff                   	(bad)  
    2cf6:	ff 67 83             	jmp    *-0x7d(%edi)

	if (oreg.ax != 0x004f)
    2cf9:	7c 24                	jl     2d1f <vesa_set_mode+0xca>
    2cfb:	48                   	dec    %eax
    2cfc:	4f                   	dec    %edi
    2cfd:	75 bb                	jne    2cba <vesa_set_mode+0x65>
		return -1;

	graphic_mode = is_graphic;
    2cff:	66 c7 06 84 49       	movw   $0x4984,(%esi)
    2d04:	00 00                	add    %al,(%eax)
    2d06:	00 00                	add    %al,(%eax)
	if (!is_graphic) {
		/* Text mode */
		force_x = mode->x;
    2d08:	67 66 0f b7 43 02    	movzww 0x2(%bp,%di),%ax
    2d0e:	66 a3 80 49 67 66    	mov    %ax,0x66674980
		force_y = mode->y;
    2d14:	0f b7 43 04          	movzwl 0x4(%ebx),%eax
    2d18:	66 a3 7c 49 66 c7    	mov    %ax,0xc766497c
		do_restore = 1;
    2d1e:	06                   	push   %es
    2d1f:	74 49                	je     2d6a <vesa_probe+0x34>
    2d21:	01 00                	add    %eax,(%eax)
    2d23:	00 00                	add    %al,(%eax)
	} else {
		/* Graphics mode */
		vesa_store_mode_params_graphics();
	}

	return 0;
    2d25:	66 31 c0             	xor    %ax,%ax
}
    2d28:	66 83 c4 58          	add    $0x58,%sp
    2d2c:	66 5b                	pop    %bx
    2d2e:	66 5e                	pop    %si
    2d30:	66 5f                	pop    %di
    2d32:	66 5d                	pop    %bp
    2d34:	66 c3                	retw   

00002d36 <vesa_probe>:
{
    2d36:	66 55                	push   %bp
    2d38:	66 57                	push   %di
    2d3a:	66 56                	push   %si
    2d3c:	66 53                	push   %bx
    2d3e:	66 83 ec 58          	sub    $0x58,%sp
	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
    2d42:	66 a1 c4 35 66 40    	mov    0x406635c4,%ax
    2d48:	66 83 e0 fe          	and    $0xfffe,%ax
	HEAP += s*n;
    2d4c:	66 a3 c4 35 66 a3    	mov    %ax,0xa36635c4
	video_vesa.modes = GET_HEAP(struct mode_info, 0);
    2d52:	90                   	nop
    2d53:	35 66 89 e0 66       	xor    $0x66e08966,%eax
	initregs(&ireg);
    2d58:	e8 51 ed ff ff       	call   1aae <initregs>
	ireg.ax = 0x4f00;
    2d5d:	67 c7 44 24 1c 00 4f 	movl   $0x664f001c,0x24(%si)
    2d64:	66 
	ireg.di = (size_t)&vginfo;
    2d65:	b8 00 38 00 00       	mov    $0x3800,%eax
    2d6a:	67 89 04             	mov    %eax,(%si)
    2d6d:	24 67                	and    $0x67,%al
	intcall(0x10, &ireg, &oreg);
    2d6f:	66 8d 4c 24 2c       	lea    0x2c(%esp),%cx
    2d74:	66 89 e2             	mov    %sp,%dx
    2d77:	66 b8 10 00          	mov    $0x10,%ax
    2d7b:	00 00                	add    %al,(%eax)
    2d7d:	66 e8 51 d5          	callw  2d2 <die+0x1>
    2d81:	ff                   	(bad)  
    2d82:	ff 66 31             	jmp    *0x31(%esi)
		return 0;	/* Not present */
    2d85:	f6 67 83             	mulb   -0x7d(%edi)
	if (oreg.ax != 0x004f ||
    2d88:	7c 24                	jl     2dae <vesa_probe+0x78>
    2d8a:	48                   	dec    %eax
    2d8b:	4f                   	dec    %edi
    2d8c:	0f 85 d0 00 66 81    	jne    81662e62 <image_base+0x80662e62>
    2d92:	3e 00 38             	add    %bh,%ds:(%eax)
    2d95:	56                   	push   %esi
    2d96:	45                   	inc    %ebp
    2d97:	53                   	push   %ebx
    2d98:	41                   	inc    %ecx
    2d99:	0f 85 c3 00 81 3e    	jne    3e812e62 <image_base+0x3d812e62>
	    vginfo.signature != VESA_MAGIC ||
    2d9f:	04 38                	add    $0x38,%al
    2da1:	01 01                	add    %eax,(%ecx)
    2da3:	0f 86 b9 00 8e 26    	jbe    268e2e62 <image_base+0x258e2e62>
	asm volatile("movw %0,%%fs" : : "rm" (seg));
    2da9:	10 38                	adc    %bh,(%eax)
	mode_ptr = vginfo.video_mode_ptr.off;
    2dab:	66 0f b7 2e          	movzww (%esi),%bp
    2daf:	0e                   	push   %cs
    2db0:	38 64 67 8b          	cmp    %ah,-0x75(%edi,%eiz,2)
	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
    2db4:	5d                   	pop    %ebp
    2db5:	00 83 fb ff 0f 84    	add    %al,-0x7bf00005(%ebx)
	while ((mode = rdfs16(mode_ptr)) != 0xffff) {
    2dbb:	a3 00 66 83 c5       	mov    %eax,0xc5836600
		mode_ptr += 2;
    2dc0:	02 66 a1             	add    -0x5f(%esi),%ah
	return (int)(heap_end-HEAP) >= (int)n;
    2dc3:	c0 35 66 2b 06 c4 35 	shlb   $0x35,0xc4062b66
		if (!heap_free(sizeof(struct mode_info)))
    2dca:	66 83 f8 07          	cmp    $0x7,%ax
    2dce:	0f 8e 8e 00 66 89    	jle    89662e62 <image_base+0x88662e62>
		if (mode & ~0x1ff)
    2dd4:	d8 66 25             	fsubs  0x25(%esi)
    2dd7:	00 fe                	add    %bh,%dh
    2dd9:	00 00                	add    %al,(%eax)
    2ddb:	75 d4                	jne    2db1 <vesa_probe+0x7b>
		memset(&vminfo, 0, sizeof(vminfo)); /* Just in case... */
    2ddd:	66 ba 00 37          	mov    $0x3700,%dx
    2de1:	00 00                	add    %al,(%eax)
    2de3:	66 b9 40 00          	mov    $0x40,%cx
    2de7:	00 00                	add    %al,(%eax)
    2de9:	66 89 d7             	mov    %dx,%di
    2dec:	66 f3 ab             	rep stos %ax,%es:(%edi)
		ireg.ax = 0x4f01;
    2def:	67 c7 44 24 1c 01 4f 	movl   $0x674f011c,0x24(%si)
    2df6:	67 
		ireg.cx = mode;
    2df7:	89 5c 24 18          	mov    %ebx,0x18(%esp)
		ireg.di = (size_t)&vminfo;
    2dfb:	67 89 14             	mov    %edx,(%si)
    2dfe:	24 67                	and    $0x67,%al
		intcall(0x10, &ireg, &oreg);
    2e00:	66 8d 4c 24 2c       	lea    0x2c(%esp),%cx
    2e05:	66 89 e2             	mov    %sp,%dx
    2e08:	66 b8 10 00          	mov    $0x10,%ax
    2e0c:	00 00                	add    %al,(%eax)
    2e0e:	66 e8 c0 d4          	callw  2d2 <die+0x1>
    2e12:	ff                   	(bad)  
    2e13:	ff 67 83             	jmp    *-0x7d(%edi)
		if (oreg.ax != 0x004f)
    2e16:	7c 24                	jl     2e3c <vesa_probe+0x106>
    2e18:	48                   	dec    %eax
    2e19:	4f                   	dec    %edi
    2e1a:	75 95                	jne    2db1 <vesa_probe+0x7b>
		if ((vminfo.mode_attr & 0x15) == 0x05) {
    2e1c:	66 a1 00 37 66 83    	mov    0x83663700,%ax
    2e22:	e0 15                	loopne 2e39 <vesa_probe+0x103>
    2e24:	83 f8 05             	cmp    $0x5,%eax
    2e27:	75 88                	jne    2db1 <vesa_probe+0x7b>
	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
    2e29:	66 a1 c4 35 66 40    	mov    0x406635c4,%ax
    2e2f:	66 83 e0 fe          	and    $0xfffe,%ax
	HEAP += s*n;
    2e33:	67 66 8d 50 08       	lea    0x8(%bx,%si),%dx
    2e38:	66 89 16             	mov    %dx,(%esi)
    2e3b:	c4 35 81 c3 00 02    	les    0x200c381,%esi
			mi->mode  = mode + VIDEO_FIRST_VESA;
    2e41:	67 89 18             	mov    %ebx,(%bx,%si)
			mi->depth = 0; /* text */
    2e44:	67 c7 40 06 00 00 8b 	movl   $0x168b0000,0x6(%bx,%si)
    2e4b:	16 
			mi->x     = vminfo.h_res;
    2e4c:	12 37                	adc    (%edi),%dh
    2e4e:	67 89 50 02          	mov    %edx,0x2(%bx,%si)
			mi->y     = vminfo.v_res;
    2e52:	66 8b 16             	mov    (%esi),%dx
    2e55:	14 37                	adc    $0x37,%al
    2e57:	67 89 50 04          	mov    %edx,0x4(%bx,%si)
			nmodes++;
    2e5b:	66 46                	inc    %si
    2e5d:	e9 51 ff 66 89       	jmp    89672db3 <image_base+0x88672db3>
}
    2e62:	f0 66 83 c4 58       	lock add $0x58,%sp
    2e67:	66 5b                	pop    %bx
    2e69:	66 5e                	pop    %si
    2e6b:	66 5f                	pop    %di
    2e6d:	66 5d                	pop    %bp
    2e6f:	66 c3                	retw   

00002e71 <vesa_store_edid>:
	/* ireg.dx = 0;	*/		/* EDID block number */
	ireg.es = ds();
	ireg.di =(size_t)&boot_params.edid_info; /* (ES:)Pointer to block */
	intcall(0x10, &ireg, &oreg);
#endif /* CONFIG_FIRMWARE_EDID */
}
    2e71:	66 c3                	retw   

00002e73 <set_bios_mode>:
{
	return set_bios_mode(mi->mode - VIDEO_FIRST_BIOS);
}

static int set_bios_mode(u8 mode)
{
    2e73:	66 53                	push   %bx
    2e75:	66 83 ec 58          	sub    $0x58,%sp
    2e79:	66 89 c3             	mov    %ax,%bx
	struct biosregs ireg, oreg;
	u8 new_mode;

	initregs(&ireg);
    2e7c:	66 89 e0             	mov    %sp,%ax
    2e7f:	66 e8 29 ec          	callw  1aac <printf+0x3c>
    2e83:	ff                   	(bad)  
    2e84:	ff 67 88             	jmp    *-0x78(%edi)
	ireg.al = mode;		/* AH=0x00 Set Video Mode */
    2e87:	5c                   	pop    %esp
    2e88:	24 1c                	and    $0x1c,%al
	intcall(0x10, &ireg, NULL);
    2e8a:	66 31 c9             	xor    %cx,%cx
    2e8d:	66 89 e2             	mov    %sp,%dx
    2e90:	66 b8 10 00          	mov    $0x10,%ax
    2e94:	00 00                	add    %al,(%eax)
    2e96:	66 e8 38 d4          	callw  2d2 <die+0x1>
    2e9a:	ff                   	(bad)  
    2e9b:	ff 67 c6             	jmp    *-0x3a(%edi)

	ireg.ah = 0x0f;		/* Get Current Video Mode */
    2e9e:	44                   	inc    %esp
    2e9f:	24 1d                	and    $0x1d,%al
    2ea1:	0f 67 66 8d          	packuswb -0x73(%esi),%mm4
	intcall(0x10, &ireg, &oreg);
    2ea5:	4c                   	dec    %esp
    2ea6:	24 2c                	and    $0x2c,%al
    2ea8:	66 89 e2             	mov    %sp,%dx
    2eab:	66 b8 10 00          	mov    $0x10,%ax
    2eaf:	00 00                	add    %al,(%eax)
    2eb1:	66 e8 1d d4          	callw  2d2 <die+0x1>
    2eb5:	ff                   	(bad)  
    2eb6:	ff 66 c7             	jmp    *-0x39(%esi)

	do_restore = 1;		/* Assume video contents were lost */
    2eb9:	06                   	push   %es
    2eba:	74 49                	je     2f05 <bios_set_mode+0x3>
    2ebc:	01 00                	add    %eax,(%eax)
    2ebe:	00 00                	add    %al,(%eax)

	/* Not all BIOSes are clean with the top bit */
	new_mode = oreg.al & 0x7f;
    2ec0:	67 8a 54 24          	mov    0x24(%si),%dl
    2ec4:	48                   	dec    %eax
    2ec5:	66 83 e2 7f          	and    $0x7f,%dx

	if (new_mode == mode)
    2ec9:	38 d3                	cmp    %dl,%bl
    2ecb:	74 27                	je     2ef4 <set_bios_mode+0x81>
		return 0;	/* Mode change OK */

#ifndef _WAKEUP
	if (new_mode != boot_params.screen_info.orig_video_mode) {
    2ecd:	66 0f b6 06          	movzbw (%esi),%ax
    2ed1:	76 39                	jbe    2f0c <bios_probe+0x2>
		   video mode. */
		ireg.ax = boot_params.screen_info.orig_video_mode;
		intcall(0x10, &ireg, NULL);
	}
#endif
	return -1;
    2ed3:	66 83 cb ff          	or     $0xffff,%bx
	if (new_mode != boot_params.screen_info.orig_video_mode) {
    2ed7:	38 d0                	cmp    %dl,%al
    2ed9:	74 1c                	je     2ef7 <set_bios_mode+0x84>
		ireg.ax = boot_params.screen_info.orig_video_mode;
    2edb:	67 89 44 24          	mov    %eax,0x24(%si)
    2edf:	1c 66                	sbb    $0x66,%al
		intcall(0x10, &ireg, NULL);
    2ee1:	31 c9                	xor    %ecx,%ecx
    2ee3:	66 89 e2             	mov    %sp,%dx
    2ee6:	66 b8 10 00          	mov    $0x10,%ax
    2eea:	00 00                	add    %al,(%eax)
    2eec:	66 e8 e2 d3          	callw  2d2 <die+0x1>
    2ef0:	ff                   	(bad)  
    2ef1:	ff                   	(bad)  
    2ef2:	eb 03                	jmp    2ef7 <set_bios_mode+0x84>
		return 0;	/* Mode change OK */
    2ef4:	66 31 db             	xor    %bx,%bx
}
    2ef7:	66 89 d8             	mov    %bx,%ax
    2efa:	66 83 c4 58          	add    $0x58,%sp
    2efe:	66 5b                	pop    %bx
    2f00:	66 c3                	retw   

00002f02 <bios_set_mode>:
	return set_bios_mode(mi->mode - VIDEO_FIRST_BIOS);
    2f02:	67 66 0f b6 00       	movzbw (%bx,%si),%ax
    2f07:	e9                   	.byte 0xe9
    2f08:	69                   	.byte 0x69
    2f09:	ff                   	.byte 0xff

00002f0a <bios_probe>:

static int bios_probe(void)
{
    2f0a:	66 55                	push   %bp
    2f0c:	66 57                	push   %di
    2f0e:	66 56                	push   %si
    2f10:	66 53                	push   %bx
#endif
	u16 crtc;
	struct mode_info *mi;
	int nmodes = 0;

	if (adapter != ADAPTER_EGA && adapter != ADAPTER_VGA)
    2f12:	66 a1 78 49 66 48    	mov    0x48664978,%ax
		return 0;
    2f18:	66 31 ff             	xor    %di,%di
	if (adapter != ADAPTER_EGA && adapter != ADAPTER_VGA)
    2f1b:	66 83 f8 01          	cmp    $0x1,%ax
    2f1f:	0f 87 e4 00 8a 1e    	ja     1e8a3009 <image_base+0x1d8a3009>
	u8 saved_mode = boot_params.screen_info.orig_video_mode;
    2f25:	76 39                	jbe    2f60 <bios_probe+0x56>
	asm volatile("movw %0,%%fs" : : "rm" (seg));
    2f27:	66 31 c0             	xor    %ax,%ax
    2f2a:	8e e0                	mov    %eax,%fs

	set_fs(0);
	crtc = vga_crtc();
    2f2c:	66 e8 75 fb          	callw  2aa5 <vga_set_14font+0x69>
    2f30:	ff                   	(bad)  
    2f31:	ff 66 89             	jmp    *-0x77(%esi)
    2f34:	c6                   	(bad)  
	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
    2f35:	66 a1 c4 35 66 40    	mov    0x406635c4,%ax
    2f3b:	66 83 e0 fe          	and    $0xfffe,%ax
	HEAP += s*n;
    2f3f:	66 a3 c4 35 66 a3    	mov    %ax,0xa36635c4

	video_bios.modes = GET_HEAP(struct mode_info, 0);
    2f45:	ac                   	lods   %ds:(%esi),%al
    2f46:	35 66 bd 14 01       	xor    $0x114bd66,%eax
    2f4b:	00 00                	add    %al,(%eax)
	return (int)(heap_end-HEAP) >= (int)n;
    2f4d:	66 a1 c0 35 66 2b    	mov    0x2b6635c0,%ax
    2f53:	06                   	push   %es
    2f54:	c4 35 66 83 f8 07    	les    0x7f88366,%esi

	for (mode = 0x14; mode <= 0x7f; mode++) {
		if (!heap_free(sizeof(struct mode_info)))
    2f5a:	0f 8e 9f 00 66 89    	jle    89662fff <image_base+0x88662fff>
			break;

		if (mode_defined(VIDEO_FIRST_BIOS+mode))
    2f60:	e8 66 e8 21 f7       	call   f72217cb <image_base+0xf62217cb>
    2f65:	ff                   	(bad)  
    2f66:	ff 66 85             	jmp    *-0x7b(%esi)
    2f69:	c0 0f 85             	rorb   $0x85,(%edi)
    2f6c:	82 00 67             	addb   $0x67,(%eax)
			continue;

		if (set_bios_mode(mode))
    2f6f:	66 8d 85 00 ff ff ff 	lea    -0x100(%ebp),%ax
    2f76:	66 e8 f7 fe          	callw  2e71 <vesa_store_edid>
    2f7a:	ff                   	(bad)  
    2f7b:	ff 66 85             	jmp    *-0x7b(%esi)
    2f7e:	c0 75 6f b0          	shlb   $0xb0,0x6f(%ebp)
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    2f82:	10 66 ba             	adc    %ah,-0x46(%esi)
    2f85:	c0 03 00             	rolb   $0x0,(%ebx)
    2f88:	00 ee                	add    %ch,%dh
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2f8a:	66 ba c1 03          	mov    $0x3c1,%dx
    2f8e:	00 00                	add    %al,(%eax)
    2f90:	ec                   	in     (%dx),%al
			continue;

		/* Try to verify that it's a text mode. */

		/* Attribute Controller: make graphics controller disabled */
		if (in_idx(0x3c0, 0x10) & 0x01)
    2f91:	a8 01                	test   $0x1,%al
    2f93:	75 5b                	jne    2ff0 <bios_probe+0xe6>
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    2f95:	b0 06                	mov    $0x6,%al
    2f97:	66 ba ce 03          	mov    $0x3ce,%dx
    2f9b:	00 00                	add    %al,(%eax)
    2f9d:	ee                   	out    %al,(%dx)
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2f9e:	66 ba cf 03          	mov    $0x3cf,%dx
    2fa2:	00 00                	add    %al,(%eax)
    2fa4:	ec                   	in     (%dx),%al
			continue;

		/* Graphics Controller: verify Alpha addressing enabled */
		if (in_idx(0x3ce, 0x06) & 0x01)
    2fa5:	a8 01                	test   $0x1,%al
    2fa7:	75 47                	jne    2ff0 <bios_probe+0xe6>
	asm volatile("outb %0,%1" : : "a" (v), "dN" (port));
    2fa9:	b0 0f                	mov    $0xf,%al
    2fab:	66 89 f2             	mov    %si,%dx
    2fae:	ee                   	out    %al,(%dx)
	return inb(port+1);
    2faf:	67 66 8d 56 01       	lea    0x1(%bp),%dx
	asm volatile("inb %1,%0" : "=a" (v) : "dN" (port));
    2fb4:	ec                   	in     (%dx),%al
			continue;

		/* CRTC cursor location low should be zero(?) */
		if (in_idx(crtc, 0x0f))
    2fb5:	84 c0                	test   %al,%al
    2fb7:	75 37                	jne    2ff0 <bios_probe+0xe6>
	HEAP = (char *)(((size_t)HEAP+(a-1)) & ~(a-1));
    2fb9:	66 a1 c4 35 66 40    	mov    0x406635c4,%ax
    2fbf:	66 83 e0 fe          	and    $0xfffe,%ax
	HEAP += s*n;
    2fc3:	67 66 8d 50 08       	lea    0x8(%bx,%si),%dx
    2fc8:	66 89 16             	mov    %dx,(%esi)
    2fcb:	c4 35 67 89 28 67    	les    0x67288967,%esi
			continue;

		mi = GET_HEAP(struct mode_info, 1);
		mi->mode = VIDEO_FIRST_BIOS+mode;
		mi->depth = 0;	/* text */
    2fd1:	c7 40 06 00 00 64 8b 	movl   $0x8b640000,0x6(%eax)
	asm volatile("movw %%fs:%1,%0" : "=r" (v) : "m" (*(u16 *)addr));
    2fd8:	16                   	push   %ss
    2fd9:	4a                   	dec    %edx
    2fda:	04 67                	add    $0x67,%al
		mi->x = rdfs16(0x44a);
    2fdc:	89 50 02             	mov    %edx,0x2(%eax)
	asm volatile("movb %%fs:%1,%0" : "=q" (v) : "m" (*(u8 *)addr));
    2fdf:	64 8a 16             	mov    %fs:(%esi),%dl
    2fe2:	84 04 66             	test   %al,(%esi,%eiz,2)
		mi->y = rdfs8(0x484)+1;
    2fe5:	0f b6 d2             	movzbl %dl,%edx
    2fe8:	66 42                	inc    %dx
    2fea:	67 89 50 04          	mov    %edx,0x4(%bx,%si)
		nmodes++;
    2fee:	66 47                	inc    %di
	for (mode = 0x14; mode <= 0x7f; mode++) {
    2ff0:	66 45                	inc    %bp
    2ff2:	66 81 fd 80 01       	cmp    $0x180,%bp
    2ff7:	00 00                	add    %al,(%eax)
    2ff9:	0f 85 50 ff 66 0f    	jne    f672f4f <image_base+0xe672f4f>
	}

	set_bios_mode(saved_mode);
    2fff:	b6 c3                	mov    $0xc3,%dh
    3001:	66 e8 6c fe          	callw  2e71 <vesa_store_edid>
    3005:	ff                   	(bad)  
    3006:	ff 66 89             	jmp    *-0x77(%esi)

	return nmodes;
}
    3009:	f8                   	clc    
    300a:	66 5b                	pop    %bx
    300c:	66 5e                	pop    %si
    300e:	66 5f                	pop    %di
    3010:	66 5d                	pop    %bp
    3012:	66 c3                	retw   

Disassembly of section .text32:

00003014 <.text32>:

	.code32
	.section ".text32","ax"
SYM_FUNC_START_LOCAL_NOALIGN(.Lin_pm32)
	# Set up data segments for flat 32-bit mode
	movl	%ecx, %ds
    3014:	8e d9                	mov    %ecx,%ds
	movl	%ecx, %es
    3016:	8e c1                	mov    %ecx,%es
	movl	%ecx, %fs
    3018:	8e e1                	mov    %ecx,%fs
	movl	%ecx, %gs
    301a:	8e e9                	mov    %ecx,%gs
	movl	%ecx, %ss
    301c:	8e d1                	mov    %ecx,%ss
	# The 32-bit code sets up its own stack, but this way we do have
	# a valid stack if some debugging hack wants to use it.
	addl	%ebx, %esp
    301e:	01 dc                	add    %ebx,%esp

	# Set up TR to make Intel VT happy
	ltr	%di
    3020:	0f 00 df             	ltr    %di

	# Clear registers to allow for future extensions to the
	# 32-bit boot protocol
	xorl	%ecx, %ecx
    3023:	31 c9                	xor    %ecx,%ecx
	xorl	%edx, %edx
    3025:	31 d2                	xor    %edx,%edx
	xorl	%ebx, %ebx
    3027:	31 db                	xor    %ebx,%ebx
	xorl	%ebp, %ebp
    3029:	31 ed                	xor    %ebp,%ebp
	xorl	%edi, %edi
    302b:	31 ff                	xor    %edi,%edi

	# Set up LDTR to make Intel VT happy
	lldt	%cx
    302d:	0f 00 d1             	lldt   %cx

	jmpl	*%eax			# Jump to the 32-bit entrypoint
    3030:	ff e0                	jmp    *%eax
