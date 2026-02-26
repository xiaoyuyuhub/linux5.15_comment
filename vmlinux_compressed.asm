
vmlinux：     文件格式 elf64-x86-64


Disassembly of section .head.text:

0000000000000000 <startup_32>:
   0:	fc                   	cld    
   1:	fa                   	cli    
   2:	8d a6 e8 01 00 00    	lea    0x1e8(%rsi),%esp
   8:	e8 00 00 00 00       	callq  d <startup_32+0xd>
   d:	5d                   	pop    %rbp
   e:	83 ed 0d             	sub    $0xd,%ebp
  11:	8d 85 c0 bf 8d 00    	lea    0x8dbfc0(%rbp),%eax
  17:	89 40 02             	mov    %eax,0x2(%rax)
  1a:	0f 01 10             	lgdt   (%rax)
  1d:	b8 18 00 00 00       	mov    $0x18,%eax
  22:	8e d8                	mov    %eax,%ds
  24:	8e c0                	mov    %eax,%es
  26:	8e e0                	mov    %eax,%fs
  28:	8e e8                	mov    %eax,%gs
  2a:	8e d0                	mov    %eax,%ss
  2c:	8d a5 c0 02 8f 00    	lea    0x8f02c0(%rbp),%esp
  32:	6a 08                	pushq  $0x8
  34:	8d 85 3c 00 00 00    	lea    0x3c(%rbp),%eax
  3a:	50                   	push   %rax
  3b:	cb                   	lret   
  3c:	e8 ef a3 8d 00       	callq  8da430 <startup32_load_idt>
  41:	e8 ba f8 8c 00       	callq  8cf900 <verify_cpu>
  46:	85 c0                	test   %eax,%eax
  48:	0f 85 a2 f8 8c 00    	jne    8cf8f0 <trampoline_32bit_src+0x70>
  4e:	89 eb                	mov    %ebp,%ebx
  50:	2b 9d 00 c2 8d 00    	sub    0x8dc200(%rbp),%ebx
  56:	8b 86 30 02 00 00    	mov    0x230(%rsi),%eax
  5c:	48 01 c3             	add    %rax,%rbx
  5f:	f7 d0                	not    %eax
  61:	21 c3                	and    %eax,%ebx
  63:	81 fb 00 00 00 01    	cmp    $0x1000000,%ebx
  69:	73 05                	jae    70 <startup_32+0x70>
  6b:	bb 00 00 00 01       	mov    $0x1000000,%ebx
  70:	03 9e 60 02 00 00    	add    0x260(%rsi),%ebx
  76:	81 eb 00 b0 8f 00    	sub    $0x8fb000,%ebx
  7c:	0f 20 e0             	mov    %cr4,%rax
  7f:	83 c8 20             	or     $0x20,%eax
  82:	0f 22 e0             	mov    %rax,%cr4
  85:	e8 26 44 8d 00       	callq  8d44b0 <get_sev_encryption_bit>
  8a:	31 d2                	xor    %edx,%edx
  8c:	8d bb 00 40 8f 00    	lea    0x8f4000(%rbx),%edi
  92:	31 c0                	xor    %eax,%eax
  94:	b9 00 18 00 00       	mov    $0x1800,%ecx
  99:	f3 ab                	rep stos %eax,%es:(%rdi)
  9b:	8d bb 00 40 8f 00    	lea    0x8f4000(%rbx),%edi
  a1:	8d 87 07 10 00 00    	lea    0x1007(%rdi),%eax
  a7:	89 07                	mov    %eax,(%rdi)
  a9:	01 57 04             	add    %edx,0x4(%rdi)
  ac:	8d bb 00 50 8f 00    	lea    0x8f5000(%rbx),%edi
  b2:	8d 87 07 10 00 00    	lea    0x1007(%rdi),%eax
  b8:	b9 04 00 00 00       	mov    $0x4,%ecx
  bd:	89 07                	mov    %eax,(%rdi)
  bf:	01 57 04             	add    %edx,0x4(%rdi)
  c2:	05 00 10 00 00       	add    $0x1000,%eax
  c7:	83 c7 08             	add    $0x8,%edi
  ca:	49 75 f0             	rex.WB jne bd <startup_32+0xbd>
  cd:	8d bb 00 60 8f 00    	lea    0x8f6000(%rbx),%edi
  d3:	b8 83 01 00 00       	mov    $0x183,%eax
  d8:	b9 00 08 00 00       	mov    $0x800,%ecx
  dd:	89 07                	mov    %eax,(%rdi)
  df:	01 57 04             	add    %edx,0x4(%rdi)
  e2:	05 00 00 20 00       	add    $0x200000,%eax
  e7:	83 c7 08             	add    $0x8,%edi
  ea:	49 75 f0             	rex.WB jne dd <startup_32+0xdd>
  ed:	8d 83 00 40 8f 00    	lea    0x8f4000(%rbx),%eax
  f3:	0f 22 d8             	mov    %rax,%cr3
  f6:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  fb:	0f 32                	rdmsr  
  fd:	0f ba e8 08          	bts    $0x8,%eax
 101:	0f 30                	wrmsr  
 103:	31 c0                	xor    %eax,%eax
 105:	0f 00 d0             	lldt   %ax
 108:	b8 20 00 00 00       	mov    $0x20,%eax
 10d:	0f 00 d8             	ltr    %ax
 110:	8d 85 00 02 00 00    	lea    0x200(%rbp),%eax
 116:	8b bd 04 c2 8d 00    	mov    0x8dc204(%rbp),%edi
 11c:	85 ff                	test   %edi,%edi
 11e:	74 23                	je     143 <startup_32+0x143>
 120:	8d 85 90 03 00 00    	lea    0x390(%rbp),%eax
 126:	8b b5 08 c2 8d 00    	mov    0x8dc208(%rbp),%esi
 12c:	8b 95 0c c2 8d 00    	mov    0x8dc20c(%rbp),%edx
 132:	85 d2                	test   %edx,%edx
 134:	75 0d                	jne    143 <startup_32+0x143>
 136:	83 ec 28             	sub    $0x28,%esp
 139:	8d 85 50 4f 8d 00    	lea    0x8d4f50(%rbp),%eax
 13f:	89 f9                	mov    %edi,%ecx
 141:	89 f2                	mov    %esi,%edx
 143:	e8 f8 a2 8d 00       	callq  8da440 <startup32_check_sev_cbit>
 148:	6a 10                	pushq  $0x10
 14a:	50                   	push   %rax
 14b:	b8 01 00 00 80       	mov    $0x80000001,%eax
 150:	0f 22 c0             	mov    %rax,%cr0
 153:	cb                   	lret   
	...

0000000000000190 <efi32_stub_entry>:
 190:	83 c4 04             	add    $0x4,%esp
 193:	59                   	pop    %rcx
 194:	5a                   	pop    %rdx
 195:	5e                   	pop    %rsi
 196:	e8 00 00 00 00       	callq  19b <efi32_stub_entry+0xb>
 19b:	5d                   	pop    %rbp
 19c:	81 ed 9b 01 00 00    	sub    $0x19b,%ebp
 1a2:	89 b5 0c c2 8d 00    	mov    %esi,0x8dc20c(%rbp)

00000000000001a8 <efi32_pe_stub_entry>:
 1a8:	89 8d 04 c2 8d 00    	mov    %ecx,0x8dc204(%rbp)
 1ae:	89 95 08 c2 8d 00    	mov    %edx,0x8dc208(%rbp)
 1b4:	c6 85 10 c2 8d 00 00 	movb   $0x0,0x8dc210(%rbp)
 1bb:	0f 01 85 38 c2 8d 00 	sgdt   0x8dc238(%rbp)
 1c2:	8c 8d 4c c2 8d 00    	mov    %cs,0x8dc24c(%rbp)
 1c8:	8c 9d 4e c2 8d 00    	mov    %ds,0x8dc24e(%rbp)
 1ce:	0f 01 8d 42 c2 8d 00 	sidt   0x8dc242(%rbp)
 1d5:	0f 20 c0             	mov    %cr0,%rax
 1d8:	0f ba f0 1f          	btr    $0x1f,%eax
 1dc:	0f 22 c0             	mov    %rax,%cr0
 1df:	e9 1c fe ff ff       	jmpq   0 <startup_32>
	...

0000000000000200 <startup_64>:
 200:	fc                   	cld    
 201:	fa                   	cli    
 202:	31 c0                	xor    %eax,%eax
 204:	8e d8                	mov    %eax,%ds
 206:	8e c0                	mov    %eax,%es
 208:	8e d0                	mov    %eax,%ss
 20a:	8e e0                	mov    %eax,%fs
 20c:	8e e8                	mov    %eax,%gs
 20e:	48 8d 2d eb fd ff ff 	lea    -0x215(%rip),%rbp        # 0 <startup_32>
 215:	8b 05 e5 bf 8d 00    	mov    0x8dbfe5(%rip),%eax        # 8dc200 <image_offset>
 21b:	48 29 c5             	sub    %rax,%rbp
 21e:	8b 86 30 02 00 00    	mov    0x230(%rsi),%eax
 224:	ff c8                	dec    %eax
 226:	48 01 c5             	add    %rax,%rbp
 229:	48 f7 d0             	not    %rax
 22c:	48 21 c5             	and    %rax,%rbp
 22f:	48 81 fd 00 00 00 01 	cmp    $0x1000000,%rbp
 236:	73 07                	jae    23f <startup_64+0x3f>
 238:	48 c7 c5 00 00 00 01 	mov    $0x1000000,%rbp
 23f:	8b 9e 60 02 00 00    	mov    0x260(%rsi),%ebx
 245:	81 eb 00 b0 8f 00    	sub    $0x8fb000,%ebx
 24b:	48 01 eb             	add    %rbp,%rbx
 24e:	48 8d a3 c0 02 8f 00 	lea    0x8f02c0(%rbx),%rsp
 255:	48 8d 05 54 bd 8d 00 	lea    0x8dbd54(%rip),%rax        # 8dbfb0 <gdt64>
 25c:	48 01 40 02          	add    %rax,0x2(%rax)
 260:	0f 01 10             	lgdt   (%rax)
 263:	6a 10                	pushq  $0x10
 265:	48 8d 05 03 00 00 00 	lea    0x3(%rip),%rax        # 26f <startup_64+0x6f>
 26c:	50                   	push   %rax
 26d:	48 cb                	lretq  
 26f:	56                   	push   %rsi
 270:	e8 2b 41 8d 00       	callq  8d43a0 <load_stage1_idt>
 275:	5e                   	pop    %rsi
 276:	56                   	push   %rsi
 277:	48 89 f7             	mov    %rsi,%rdi
 27a:	e8 51 43 8d 00       	callq  8d45d0 <paging_prepare>
 27f:	5e                   	pop    %rsi
 280:	48 89 c1             	mov    %rax,%rcx
 283:	48 8d 3d 0c 00 00 00 	lea    0xc(%rip),%rdi        # 296 <trampoline_return>
 28a:	6a 08                	pushq  $0x8
 28c:	48 8d 80 00 10 00 00 	lea    0x1000(%rax),%rax
 293:	50                   	push   %rax
 294:	48 cb                	lretq  

0000000000000296 <trampoline_return>:
 296:	48 8d a3 c0 02 8f 00 	lea    0x8f02c0(%rbx),%rsp
 29d:	56                   	push   %rsi
 29e:	48 8d bb 00 a0 8f 00 	lea    0x8fa000(%rbx),%rdi
 2a5:	e8 46 46 8d 00       	callq  8d48f0 <cleanup_trampoline>
 2aa:	5e                   	pop    %rsi
 2ab:	6a 00                	pushq  $0x0
 2ad:	9d                   	popfq  
 2ae:	56                   	push   %rsi
 2af:	48 8d 35 02 c0 8d 00 	lea    0x8dc002(%rip),%rsi        # 8dc2b8 <_edata+0x34>
 2b6:	48 8d bb b8 c2 8d 00 	lea    0x8dc2b8(%rbx),%rdi
 2bd:	b9 c0 c2 8d 00       	mov    $0x8dc2c0,%ecx
 2c2:	c1 e9 03             	shr    $0x3,%ecx
 2c5:	fd                   	std    
 2c6:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
 2c9:	fc                   	cld    
 2ca:	5e                   	pop    %rsi
 2cb:	48 8d 83 b0 bf 8d 00 	lea    0x8dbfb0(%rbx),%rax
 2d2:	48 8d 93 c0 bf 8d 00 	lea    0x8dbfc0(%rbx),%rdx
 2d9:	48 89 50 02          	mov    %rdx,0x2(%rax)
 2dd:	0f 01 10             	lgdt   (%rax)
 2e0:	48 8d 83 20 f8 8c 00 	lea    0x8cf820(%rbx),%rax
 2e7:	ff e0                	jmpq   *%rax
	...

0000000000000390 <efi64_stub_entry>:
 390:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
 394:	48 89 d3             	mov    %rdx,%rbx
 397:	e8 76 4d 8d 00       	callq  8d5112 <efi_main>
 39c:	48 89 de             	mov    %rbx,%rsi
 39f:	48 8d 80 00 02 00 00 	lea    0x200(%rax),%rax
 3a6:	ff e0                	jmpq   *%rax
 3a8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
 3af:	00 

00000000000003b0 <efi32_pe_entry>:
 3b0:	55                   	push   %rbp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	50                   	push   %rax
 3b4:	53                   	push   %rbx
 3b5:	57                   	push   %rdi
 3b6:	e8 45 f5 8c 00       	callq  8cf900 <verify_cpu>
 3bb:	85 c0                	test   %eax,%eax
 3bd:	b8 03 00 00 80       	mov    $0x80000003,%eax
 3c2:	75 45                	jne    409 <efi32_pe_entry+0x59>
 3c4:	e8 00 00 00 00       	callq  3c9 <efi32_pe_entry+0x19>
 3c9:	5b                   	pop    %rbx
 3ca:	81 eb c9 03 00 00    	sub    $0x3c9,%ebx
 3d0:	8d 45 fc             	lea    -0x4(%rbp),%eax
 3d3:	50                   	push   %rax
 3d4:	8d 83 20 a4 8d 00    	lea    0x8da420(%rbx),%eax
 3da:	50                   	push   %rax
 3db:	ff 75 08             	pushq  0x8(%rbp)
 3de:	8b 45 0c             	mov    0xc(%rbp),%eax
 3e1:	8b 40 3c             	mov    0x3c(%rax),%eax
 3e4:	ff 50 58             	callq  *0x58(%rax)
 3e7:	83 c4 0c             	add    $0xc,%esp
 3ea:	85 c0                	test   %eax,%eax
 3ec:	75 1b                	jne    409 <efi32_pe_entry+0x59>
 3ee:	8b 4d 08             	mov    0x8(%rbp),%ecx
 3f1:	8b 55 0c             	mov    0xc(%rbp),%edx
 3f4:	8b 75 fc             	mov    -0x4(%rbp),%esi
 3f7:	8b 76 20             	mov    0x20(%rsi),%esi
 3fa:	89 dd                	mov    %ebx,%ebp
 3fc:	29 f3                	sub    %esi,%ebx
 3fe:	89 9d 00 c2 8d 00    	mov    %ebx,0x8dc200(%rbp)
 404:	e9 9f fd ff ff       	jmpq   1a8 <efi32_pe_stub_entry>
 409:	5f                   	pop    %rdi
 40a:	5b                   	pop    %rbx
 40b:	c9                   	leaveq 
 40c:	c3                   	retq   

Disassembly of section .text:

00000000008cf820 <_text>:
  8cf820:	31 c0                	xor    %eax,%eax
  8cf822:	48 8d 3d 97 ca 00 00 	lea    0xca97(%rip),%rdi        # 8dc2c0 <boot_heap>
  8cf829:	48 8d 0d e0 43 02 00 	lea    0x243e0(%rip),%rcx        # 8f3c10 <_ebss>
  8cf830:	48 29 f9             	sub    %rdi,%rcx
  8cf833:	48 c1 e9 03          	shr    $0x3,%rcx
  8cf837:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  8cf83a:	56                   	push   %rsi
  8cf83b:	e8 80 4d 00 00       	callq  8d45c0 <set_sev_encryption_mask>
  8cf840:	e8 7b 4b 00 00       	callq  8d43c0 <load_stage2_idt>
  8cf845:	48 8b 3c 24          	mov    (%rsp),%rdi
  8cf849:	e8 f2 48 00 00       	callq  8d4140 <initialize_identity_maps>
  8cf84e:	5e                   	pop    %rsi
  8cf84f:	56                   	push   %rsi
  8cf850:	48 89 f7             	mov    %rsi,%rdi
  8cf853:	48 8d 35 66 ca 00 00 	lea    0xca66(%rip),%rsi        # 8dc2c0 <boot_heap>
  8cf85a:	48 8d 15 ac 0b 73 ff 	lea    -0x8cf454(%rip),%rdx        # 40d <_ehead>
  8cf861:	8b 0d d7 b6 00 00    	mov    0xb6d7(%rip),%ecx        # 8daf3e <input_len>
  8cf867:	49 89 e8             	mov    %rbp,%r8
  8cf86a:	44 8b 0d d1 b6 00 00 	mov    0xb6d1(%rip),%r9d        # 8daf42 <output_len>
  8cf871:	e8 8a 2c 00 00       	callq  8d2500 <extract_kernel>
  8cf876:	5e                   	pop    %rsi
  8cf877:	ff e0                	jmpq   *%rax
  8cf879:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000008cf880 <trampoline_32bit_src>:
  8cf880:	b8 18 00 00 00       	mov    $0x18,%eax
  8cf885:	8e d8                	mov    %eax,%ds
  8cf887:	8e d0                	mov    %eax,%ss
  8cf889:	8d a1 00 20 00 00    	lea    0x2000(%rcx),%esp
  8cf88f:	0f 20 c0             	mov    %cr0,%rax
  8cf892:	0f ba f0 1f          	btr    $0x1f,%eax
  8cf896:	0f 22 c0             	mov    %rax,%cr0
  8cf899:	85 d2                	test   %edx,%edx
  8cf89b:	74 0c                	je     8cf8a9 <trampoline_32bit_src+0x29>
  8cf89d:	0f 20 e0             	mov    %cr4,%rax
  8cf8a0:	a9 00 10 00 00       	test   $0x1000,%eax
  8cf8a5:	75 11                	jne    8cf8b8 <trampoline_32bit_src+0x38>
  8cf8a7:	eb 0a                	jmp    8cf8b3 <trampoline_32bit_src+0x33>
  8cf8a9:	0f 20 e0             	mov    %cr4,%rax
  8cf8ac:	a9 00 10 00 00       	test   $0x1000,%eax
  8cf8b1:	74 05                	je     8cf8b8 <trampoline_32bit_src+0x38>
  8cf8b3:	8d 01                	lea    (%rcx),%eax
  8cf8b5:	0f 22 d8             	mov    %rax,%cr3
  8cf8b8:	51                   	push   %rcx
  8cf8b9:	52                   	push   %rdx
  8cf8ba:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  8cf8bf:	0f 32                	rdmsr  
  8cf8c1:	0f ba e8 08          	bts    $0x8,%eax
  8cf8c5:	0f 30                	wrmsr  
  8cf8c7:	5a                   	pop    %rdx
  8cf8c8:	59                   	pop    %rcx
  8cf8c9:	b8 20 00 00 00       	mov    $0x20,%eax
  8cf8ce:	85 d2                	test   %edx,%edx
  8cf8d0:	74 05                	je     8cf8d7 <trampoline_32bit_src+0x57>
  8cf8d2:	0d 00 10 00 00       	or     $0x1000,%eax
  8cf8d7:	0f 22 e0             	mov    %rax,%cr4
  8cf8da:	8d 81 6c 10 00 00    	lea    0x106c(%rcx),%eax
  8cf8e0:	6a 10                	pushq  $0x10
  8cf8e2:	50                   	push   %rax
  8cf8e3:	b8 01 00 00 80       	mov    $0x80000001,%eax
  8cf8e8:	0f 22 c0             	mov    %rax,%cr0
  8cf8eb:	cb                   	lret   
  8cf8ec:	ff e7                	jmpq   *%rdi
  8cf8ee:	00 00                	add    %al,(%rax)
  8cf8f0:	f4                   	hlt    
  8cf8f1:	eb fd                	jmp    8cf8f0 <trampoline_32bit_src+0x70>
  8cf8f3:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8cf8fa:	00 00 00 00 
  8cf8fe:	66 90                	xchg   %ax,%ax

00000000008cf900 <verify_cpu>:
  8cf900:	9c                   	pushfq 
  8cf901:	6a 00                	pushq  $0x0
  8cf903:	9d                   	popfq  
  8cf904:	b8 00 00 00 00       	mov    $0x0,%eax
  8cf909:	0f a2                	cpuid  
  8cf90b:	83 f8 01             	cmp    $0x1,%eax
  8cf90e:	0f 82 d2 00 00 00    	jb     8cf9e6 <verify_cpu+0xe6>
  8cf914:	66 31 ff             	xor    %di,%di
  8cf917:	81 fb 41 75 74 68    	cmp    $0x68747541,%ebx
  8cf91d:	75 16                	jne    8cf935 <verify_cpu+0x35>
  8cf91f:	81 fa 65 6e 74 69    	cmp    $0x69746e65,%edx
  8cf925:	75 0e                	jne    8cf935 <verify_cpu+0x35>
  8cf927:	81 f9 63 41 4d 44    	cmp    $0x444d4163,%ecx
  8cf92d:	75 06                	jne    8cf935 <verify_cpu+0x35>
  8cf92f:	66 bf 01 00          	mov    $0x1,%di
  8cf933:	eb 4d                	jmp    8cf982 <verify_cpu+0x82>
  8cf935:	81 fb 47 65 6e 75    	cmp    $0x756e6547,%ebx
  8cf93b:	75 45                	jne    8cf982 <verify_cpu+0x82>
  8cf93d:	81 fa 69 6e 65 49    	cmp    $0x49656e69,%edx
  8cf943:	75 3d                	jne    8cf982 <verify_cpu+0x82>
  8cf945:	81 f9 6e 74 65 6c    	cmp    $0x6c65746e,%ecx
  8cf94b:	75 35                	jne    8cf982 <verify_cpu+0x82>
  8cf94d:	b8 01 00 00 00       	mov    $0x1,%eax
  8cf952:	0f a2                	cpuid  
  8cf954:	89 c1                	mov    %eax,%ecx
  8cf956:	25 00 0f f0 0f       	and    $0xff00f00,%eax
  8cf95b:	c1 e8 08             	shr    $0x8,%eax
  8cf95e:	83 f8 06             	cmp    $0x6,%eax
  8cf961:	77 10                	ja     8cf973 <verify_cpu+0x73>
  8cf963:	72 1d                	jb     8cf982 <verify_cpu+0x82>
  8cf965:	81 e1 f0 00 0f 00    	and    $0xf00f0,%ecx
  8cf96b:	c1 e9 04             	shr    $0x4,%ecx
  8cf96e:	83 f9 0d             	cmp    $0xd,%ecx
  8cf971:	72 0f                	jb     8cf982 <verify_cpu+0x82>
  8cf973:	b9 a0 01 00 00       	mov    $0x1a0,%ecx
  8cf978:	0f 32                	rdmsr  
  8cf97a:	0f ba f2 02          	btr    $0x2,%edx
  8cf97e:	73 02                	jae    8cf982 <verify_cpu+0x82>
  8cf980:	0f 30                	wrmsr  
  8cf982:	b8 01 00 00 00       	mov    $0x1,%eax
  8cf987:	0f a2                	cpuid  
  8cf989:	81 e2 69 81 00 07    	and    $0x7008169,%edx
  8cf98f:	81 f2 69 81 00 07    	xor    $0x7008169,%edx
  8cf995:	75 4f                	jne    8cf9e6 <verify_cpu+0xe6>
  8cf997:	b8 00 00 00 80       	mov    $0x80000000,%eax
  8cf99c:	0f a2                	cpuid  
  8cf99e:	3d 01 00 00 80       	cmp    $0x80000001,%eax
  8cf9a3:	72 41                	jb     8cf9e6 <verify_cpu+0xe6>
  8cf9a5:	b8 01 00 00 80       	mov    $0x80000001,%eax
  8cf9aa:	0f a2                	cpuid  
  8cf9ac:	81 e2 00 00 00 20    	and    $0x20000000,%edx
  8cf9b2:	81 f2 00 00 00 20    	xor    $0x20000000,%edx
  8cf9b8:	75 2c                	jne    8cf9e6 <verify_cpu+0xe6>
  8cf9ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8cf9bf:	0f a2                	cpuid  
  8cf9c1:	81 e2 00 00 00 06    	and    $0x6000000,%edx
  8cf9c7:	81 fa 00 00 00 06    	cmp    $0x6000000,%edx
  8cf9cd:	74 1e                	je     8cf9ed <verify_cpu+0xed>
  8cf9cf:	66 85 ff             	test   %di,%di
  8cf9d2:	74 12                	je     8cf9e6 <verify_cpu+0xe6>
  8cf9d4:	b9 15 00 01 c0       	mov    $0xc0010015,%ecx
  8cf9d9:	0f 32                	rdmsr  
  8cf9db:	0f ba f0 0f          	btr    $0xf,%eax
  8cf9df:	0f 30                	wrmsr  
  8cf9e1:	66 31 ff             	xor    %di,%di
  8cf9e4:	eb d4                	jmp    8cf9ba <verify_cpu+0xba>
  8cf9e6:	9d                   	popfq  
  8cf9e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8cf9ec:	c3                   	retq   
  8cf9ed:	9d                   	popfq  
  8cf9ee:	31 c0                	xor    %eax,%eax
  8cf9f0:	c3                   	retq   
  8cf9f1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8cf9f8:	00 00 00 
  8cf9fb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008cfa00 <malloc>:
  8cfa00:	48 8b 05 c1 18 02 00 	mov    0x218c1(%rip),%rax        # 8f12c8 <malloc_ptr>
  8cfa07:	48 63 ff             	movslq %edi,%rdi
  8cfa0a:	48 8b 15 57 39 02 00 	mov    0x23957(%rip),%rdx        # 8f3368 <free_mem_end_ptr>
  8cfa11:	48 85 c0             	test   %rax,%rax
  8cfa14:	48 0f 44 05 54 39 02 	cmove  0x23954(%rip),%rax        # 8f3370 <free_mem_ptr>
  8cfa1b:	00 
  8cfa1c:	48 83 c0 03          	add    $0x3,%rax
  8cfa20:	48 83 e0 fc          	and    $0xfffffffffffffffc,%rax
  8cfa24:	48 01 c7             	add    %rax,%rdi
  8cfa27:	48 89 3d 9a 18 02 00 	mov    %rdi,0x2189a(%rip)        # 8f12c8 <malloc_ptr>
  8cfa2e:	48 85 d2             	test   %rdx,%rdx
  8cfa31:	74 05                	je     8cfa38 <malloc+0x38>
  8cfa33:	48 39 d7             	cmp    %rdx,%rdi
  8cfa36:	73 08                	jae    8cfa40 <malloc+0x40>
  8cfa38:	83 05 81 18 02 00 01 	addl   $0x1,0x21881(%rip)        # 8f12c0 <malloc_count>
  8cfa3f:	c3                   	retq   
  8cfa40:	31 c0                	xor    %eax,%eax
  8cfa42:	c3                   	retq   
  8cfa43:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8cfa4a:	00 00 00 00 
  8cfa4e:	66 90                	xchg   %ax,%ax

00000000008cfa50 <nofill>:
  8cfa50:	f3 0f 1e fa          	endbr64 
  8cfa54:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  8cfa5b:	c3                   	retq   
  8cfa5c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008cfa60 <zlib_updatewindow>:
  8cfa60:	41 55                	push   %r13
  8cfa62:	49 89 fd             	mov    %rdi,%r13
  8cfa65:	41 54                	push   %r12
  8cfa67:	55                   	push   %rbp
  8cfa68:	53                   	push   %rbx
  8cfa69:	48 83 ec 08          	sub    $0x8,%rsp
  8cfa6d:	4c 8b 67 38          	mov    0x38(%rdi),%r12
  8cfa71:	2b 77 20             	sub    0x20(%rdi),%esi
  8cfa74:	89 f5                	mov    %esi,%ebp
  8cfa76:	48 8b 77 18          	mov    0x18(%rdi),%rsi
  8cfa7a:	41 8b 54 24 2c       	mov    0x2c(%r12),%edx
  8cfa7f:	49 8b 7c 24 38       	mov    0x38(%r12),%rdi
  8cfa84:	39 ea                	cmp    %ebp,%edx
  8cfa86:	77 28                	ja     8cfab0 <zlib_updatewindow+0x50>
  8cfa88:	48 29 d6             	sub    %rdx,%rsi
  8cfa8b:	e8 60 36 00 00       	callq  8d30f0 <memcpy>
  8cfa90:	41 8b 44 24 2c       	mov    0x2c(%r12),%eax
  8cfa95:	41 c7 44 24 34 00 00 	movl   $0x0,0x34(%r12)
  8cfa9c:	00 00 
  8cfa9e:	41 89 44 24 30       	mov    %eax,0x30(%r12)
  8cfaa3:	48 83 c4 08          	add    $0x8,%rsp
  8cfaa7:	5b                   	pop    %rbx
  8cfaa8:	5d                   	pop    %rbp
  8cfaa9:	41 5c                	pop    %r12
  8cfaab:	41 5d                	pop    %r13
  8cfaad:	c3                   	retq   
  8cfaae:	66 90                	xchg   %ax,%ax
  8cfab0:	41 8b 44 24 34       	mov    0x34(%r12),%eax
  8cfab5:	29 c2                	sub    %eax,%edx
  8cfab7:	39 d5                	cmp    %edx,%ebp
  8cfab9:	89 d3                	mov    %edx,%ebx
  8cfabb:	0f 46 dd             	cmovbe %ebp,%ebx
  8cfabe:	48 01 c7             	add    %rax,%rdi
  8cfac1:	89 e8                	mov    %ebp,%eax
  8cfac3:	48 29 c6             	sub    %rax,%rsi
  8cfac6:	89 da                	mov    %ebx,%edx
  8cfac8:	e8 23 36 00 00       	callq  8d30f0 <memcpy>
  8cfacd:	29 dd                	sub    %ebx,%ebp
  8cfacf:	75 37                	jne    8cfb08 <zlib_updatewindow+0xa8>
  8cfad1:	41 8b 74 24 34       	mov    0x34(%r12),%esi
  8cfad6:	41 8b 44 24 2c       	mov    0x2c(%r12),%eax
  8cfadb:	41 8b 54 24 30       	mov    0x30(%r12),%edx
  8cfae0:	01 de                	add    %ebx,%esi
  8cfae2:	39 c6                	cmp    %eax,%esi
  8cfae4:	0f 45 ee             	cmovne %esi,%ebp
  8cfae7:	41 89 6c 24 34       	mov    %ebp,0x34(%r12)
  8cfaec:	39 d0                	cmp    %edx,%eax
  8cfaee:	76 b3                	jbe    8cfaa3 <zlib_updatewindow+0x43>
  8cfaf0:	01 d3                	add    %edx,%ebx
  8cfaf2:	41 89 5c 24 30       	mov    %ebx,0x30(%r12)
  8cfaf7:	48 83 c4 08          	add    $0x8,%rsp
  8cfafb:	5b                   	pop    %rbx
  8cfafc:	5d                   	pop    %rbp
  8cfafd:	41 5c                	pop    %r12
  8cfaff:	41 5d                	pop    %r13
  8cfb01:	c3                   	retq   
  8cfb02:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8cfb08:	49 8b 75 18          	mov    0x18(%r13),%rsi
  8cfb0c:	89 ea                	mov    %ebp,%edx
  8cfb0e:	49 8b 7c 24 38       	mov    0x38(%r12),%rdi
  8cfb13:	48 29 d6             	sub    %rdx,%rsi
  8cfb16:	e8 d5 35 00 00       	callq  8d30f0 <memcpy>
  8cfb1b:	41 8b 44 24 2c       	mov    0x2c(%r12),%eax
  8cfb20:	41 89 6c 24 34       	mov    %ebp,0x34(%r12)
  8cfb25:	41 89 44 24 30       	mov    %eax,0x30(%r12)
  8cfb2a:	48 83 c4 08          	add    $0x8,%rsp
  8cfb2e:	5b                   	pop    %rbx
  8cfb2f:	5d                   	pop    %rbp
  8cfb30:	41 5c                	pop    %r12
  8cfb32:	41 5d                	pop    %r13
  8cfb34:	c3                   	retq   
  8cfb35:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8cfb3c:	00 00 00 00 

00000000008cfb40 <scroll>:
  8cfb40:	48 83 ec 08          	sub    $0x8,%rsp
  8cfb44:	8b 35 8a 17 02 00    	mov    0x2178a(%rip),%esi        # 8f12d4 <lines>
  8cfb4a:	8b 05 80 17 02 00    	mov    0x21780(%rip),%eax        # 8f12d0 <cols>
  8cfb50:	48 8b 3d 89 17 02 00 	mov    0x21789(%rip),%rdi        # 8f12e0 <vidmem>
  8cfb57:	8d 56 ff             	lea    -0x1(%rsi),%edx
  8cfb5a:	8d 34 00             	lea    (%rax,%rax,1),%esi
  8cfb5d:	0f af d0             	imul   %eax,%edx
  8cfb60:	48 63 f6             	movslq %esi,%rsi
  8cfb63:	48 01 fe             	add    %rdi,%rsi
  8cfb66:	01 d2                	add    %edx,%edx
  8cfb68:	48 63 d2             	movslq %edx,%rdx
  8cfb6b:	e8 30 35 00 00       	callq  8d30a0 <memmove>
  8cfb70:	8b 05 5e 17 02 00    	mov    0x2175e(%rip),%eax        # 8f12d4 <lines>
  8cfb76:	8b 35 54 17 02 00    	mov    0x21754(%rip),%esi        # 8f12d0 <cols>
  8cfb7c:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8cfb7f:	0f af ce             	imul   %esi,%ecx
  8cfb82:	01 ce                	add    %ecx,%esi
  8cfb84:	39 f1                	cmp    %esi,%ecx
  8cfb86:	7d 24                	jge    8cfbac <scroll+0x6c>
  8cfb88:	8d 04 09             	lea    (%rcx,%rcx,1),%eax
  8cfb8b:	48 8b 0d 4e 17 02 00 	mov    0x2174e(%rip),%rcx        # 8f12e0 <vidmem>
  8cfb92:	8d 14 36             	lea    (%rsi,%rsi,1),%edx
  8cfb95:	48 98                	cltq   
  8cfb97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8cfb9e:	00 00 
  8cfba0:	c6 04 01 20          	movb   $0x20,(%rcx,%rax,1)
  8cfba4:	48 83 c0 02          	add    $0x2,%rax
  8cfba8:	39 c2                	cmp    %eax,%edx
  8cfbaa:	7f f4                	jg     8cfba0 <scroll+0x60>
  8cfbac:	48 83 c4 08          	add    $0x8,%rsp
  8cfbb0:	c3                   	retq   
  8cfbb1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8cfbb8:	00 00 00 00 
  8cfbbc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008cfbc0 <zlib_inflate_table>:
  8cfbc0:	f3 0f 1e fa          	endbr64 
  8cfbc4:	41 57                	push   %r15
  8cfbc6:	41 56                	push   %r14
  8cfbc8:	41 55                	push   %r13
  8cfbca:	41 54                	push   %r12
  8cfbcc:	55                   	push   %rbp
  8cfbcd:	53                   	push   %rbx
  8cfbce:	48 81 ec 98 00 00 00 	sub    $0x98,%rsp
  8cfbd5:	48 8d 44 24 58       	lea    0x58(%rsp),%rax
  8cfbda:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8cfbdf:	4c 89 44 24 38       	mov    %r8,0x38(%rsp)
  8cfbe4:	4c 89 0c 24          	mov    %r9,(%rsp)
  8cfbe8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8cfbed:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8cfbf2:	48 8d 4c 24 78       	lea    0x78(%rsp),%rcx
  8cfbf7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8cfbfe:	00 00 
  8cfc00:	45 31 d2             	xor    %r10d,%r10d
  8cfc03:	48 83 c0 02          	add    $0x2,%rax
  8cfc07:	66 44 89 50 fe       	mov    %r10w,-0x2(%rax)
  8cfc0c:	48 39 c1             	cmp    %rax,%rcx
  8cfc0f:	75 ef                	jne    8cfc00 <zlib_inflate_table+0x40>
  8cfc11:	85 d2                	test   %edx,%edx
  8cfc13:	74 25                	je     8cfc3a <zlib_inflate_table+0x7a>
  8cfc15:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  8cfc1a:	8d 72 ff             	lea    -0x1(%rdx),%esi
  8cfc1d:	48 89 d8             	mov    %rbx,%rax
  8cfc20:	4c 8d 44 73 02       	lea    0x2(%rbx,%rsi,2),%r8
  8cfc25:	0f 1f 00             	nopl   (%rax)
  8cfc28:	0f b7 30             	movzwl (%rax),%esi
  8cfc2b:	48 83 c0 02          	add    $0x2,%rax
  8cfc2f:	66 83 44 74 58 01    	addw   $0x1,0x58(%rsp,%rsi,2)
  8cfc35:	49 39 c0             	cmp    %rax,%r8
  8cfc38:	75 ee                	jne    8cfc28 <zlib_inflate_table+0x68>
  8cfc3a:	48 8d 44 24 76       	lea    0x76(%rsp),%rax
  8cfc3f:	bd 0f 00 00 00       	mov    $0xf,%ebp
  8cfc44:	0f 1f 40 00          	nopl   0x0(%rax)
  8cfc48:	66 83 38 00          	cmpw   $0x0,(%rax)
  8cfc4c:	75 52                	jne    8cfca0 <zlib_inflate_table+0xe0>
  8cfc4e:	48 83 e8 02          	sub    $0x2,%rax
  8cfc52:	83 ed 01             	sub    $0x1,%ebp
  8cfc55:	75 f1                	jne    8cfc48 <zlib_inflate_table+0x88>
  8cfc57:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8cfc5c:	48 8b 03             	mov    (%rbx),%rax
  8cfc5f:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8cfc63:	48 89 13             	mov    %rdx,(%rbx)
  8cfc66:	c7 00 40 01 00 00    	movl   $0x140,(%rax)
  8cfc6c:	48 8b 03             	mov    (%rbx),%rax
  8cfc6f:	48 8d 50 04          	lea    0x4(%rax),%rdx
  8cfc73:	48 89 13             	mov    %rdx,(%rbx)
  8cfc76:	c7 00 40 01 00 00    	movl   $0x140,(%rax)
  8cfc7c:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8cfc81:	c7 00 01 00 00 00    	movl   $0x1,(%rax)
  8cfc87:	31 c0                	xor    %eax,%eax
  8cfc89:	48 81 c4 98 00 00 00 	add    $0x98,%rsp
  8cfc90:	5b                   	pop    %rbx
  8cfc91:	5d                   	pop    %rbp
  8cfc92:	41 5c                	pop    %r12
  8cfc94:	41 5d                	pop    %r13
  8cfc96:	41 5e                	pop    %r14
  8cfc98:	41 5f                	pop    %r15
  8cfc9a:	c3                   	retq   
  8cfc9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8cfca0:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8cfca5:	b8 01 00 00 00       	mov    $0x1,%eax
  8cfcaa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8cfcb0:	66 83 3c 46 00       	cmpw   $0x0,(%rsi,%rax,2)
  8cfcb5:	89 c3                	mov    %eax,%ebx
  8cfcb7:	75 0f                	jne    8cfcc8 <zlib_inflate_table+0x108>
  8cfcb9:	48 83 c0 01          	add    $0x1,%rax
  8cfcbd:	48 83 f8 0f          	cmp    $0xf,%rax
  8cfcc1:	75 ed                	jne    8cfcb0 <zlib_inflate_table+0xf0>
  8cfcc3:	bb 0f 00 00 00       	mov    $0xf,%ebx
  8cfcc8:	4c 8d 44 24 5a       	lea    0x5a(%rsp),%r8
  8cfccd:	b8 01 00 00 00       	mov    $0x1,%eax
  8cfcd2:	4c 89 c6             	mov    %r8,%rsi
  8cfcd5:	0f 1f 00             	nopl   (%rax)
  8cfcd8:	44 0f b7 0e          	movzwl (%rsi),%r9d
  8cfcdc:	01 c0                	add    %eax,%eax
  8cfcde:	44 29 c8             	sub    %r9d,%eax
  8cfce1:	0f 88 f1 01 00 00    	js     8cfed8 <zlib_inflate_table+0x318>
  8cfce7:	48 83 c6 02          	add    $0x2,%rsi
  8cfceb:	48 39 f1             	cmp    %rsi,%rcx
  8cfcee:	75 e8                	jne    8cfcd8 <zlib_inflate_table+0x118>
  8cfcf0:	85 c0                	test   %eax,%eax
  8cfcf2:	74 11                	je     8cfd05 <zlib_inflate_table+0x145>
  8cfcf4:	85 ff                	test   %edi,%edi
  8cfcf6:	0f 84 dc 01 00 00    	je     8cfed8 <zlib_inflate_table+0x318>
  8cfcfc:	83 fd 01             	cmp    $0x1,%ebp
  8cfcff:	0f 85 d3 01 00 00    	jne    8cfed8 <zlib_inflate_table+0x318>
  8cfd05:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8cfd0a:	45 31 c9             	xor    %r9d,%r9d
  8cfd0d:	31 c9                	xor    %ecx,%ecx
  8cfd0f:	66 44 89 4c 24 7a    	mov    %r9w,0x7a(%rsp)
  8cfd15:	4c 8d 4c 24 7c       	lea    0x7c(%rsp),%r9
  8cfd1a:	8b 30                	mov    (%rax),%esi
  8cfd1c:	31 c0                	xor    %eax,%eax
  8cfd1e:	66 90                	xchg   %ax,%ax
  8cfd20:	66 41 03 0c 00       	add    (%r8,%rax,1),%cx
  8cfd25:	66 41 89 0c 01       	mov    %cx,(%r9,%rax,1)
  8cfd2a:	48 83 c0 02          	add    $0x2,%rax
  8cfd2e:	48 83 f8 1c          	cmp    $0x1c,%rax
  8cfd32:	75 ec                	jne    8cfd20 <zlib_inflate_table+0x160>
  8cfd34:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
  8cfd39:	4c 8b 1c 24          	mov    (%rsp),%r11
  8cfd3d:	44 8d 42 ff          	lea    -0x1(%rdx),%r8d
  8cfd41:	31 c0                	xor    %eax,%eax
  8cfd43:	85 d2                	test   %edx,%edx
  8cfd45:	75 0c                	jne    8cfd53 <zlib_inflate_table+0x193>
  8cfd47:	eb 31                	jmp    8cfd7a <zlib_inflate_table+0x1ba>
  8cfd49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8cfd50:	48 89 d0             	mov    %rdx,%rax
  8cfd53:	41 0f b7 14 41       	movzwl (%r9,%rax,2),%edx
  8cfd58:	66 85 d2             	test   %dx,%dx
  8cfd5b:	74 14                	je     8cfd71 <zlib_inflate_table+0x1b1>
  8cfd5d:	0f b7 4c 54 78       	movzwl 0x78(%rsp,%rdx,2),%ecx
  8cfd62:	44 8d 51 01          	lea    0x1(%rcx),%r10d
  8cfd66:	66 41 89 04 4b       	mov    %ax,(%r11,%rcx,2)
  8cfd6b:	66 44 89 54 54 78    	mov    %r10w,0x78(%rsp,%rdx,2)
  8cfd71:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8cfd75:	49 39 c0             	cmp    %rax,%r8
  8cfd78:	75 d6                	jne    8cfd50 <zlib_inflate_table+0x190>
  8cfd7a:	39 ee                	cmp    %ebp,%esi
  8cfd7c:	b8 01 00 00 00       	mov    $0x1,%eax
  8cfd81:	0f 47 f5             	cmova  %ebp,%esi
  8cfd84:	39 f3                	cmp    %esi,%ebx
  8cfd86:	0f 43 f3             	cmovae %ebx,%esi
  8cfd89:	89 f1                	mov    %esi,%ecx
  8cfd8b:	89 74 24 0c          	mov    %esi,0xc(%rsp)
  8cfd8f:	d3 e0                	shl    %cl,%eax
  8cfd91:	89 44 24 1c          	mov    %eax,0x1c(%rsp)
  8cfd95:	85 ff                	test   %edi,%edi
  8cfd97:	0f 84 2b 02 00 00    	je     8cffc8 <zlib_inflate_table+0x408>
  8cfd9d:	83 ff 01             	cmp    $0x1,%edi
  8cfda0:	0f 84 0a 02 00 00    	je     8cffb0 <zlib_inflate_table+0x3f0>
  8cfda6:	48 8d 05 93 b0 00 00 	lea    0xb093(%rip),%rax        # 8dae40 <dext.30593>
  8cfdad:	c7 44 24 18 ff ff ff 	movl   $0xffffffff,0x18(%rsp)
  8cfdb4:	ff 
  8cfdb5:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8cfdba:	48 8d 05 bf b0 00 00 	lea    0xb0bf(%rip),%rax        # 8dae80 <dbase.30592>
  8cfdc1:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8cfdc6:	83 ff 01             	cmp    $0x1,%edi
  8cfdc9:	0f 94 44 24 57       	sete   0x57(%rsp)
  8cfdce:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8cfdd3:	89 6c 24 20          	mov    %ebp,0x20(%rsp)
  8cfdd7:	31 f6                	xor    %esi,%esi
  8cfdd9:	45 31 ed             	xor    %r13d,%r13d
  8cfddc:	c7 44 24 24 ff ff ff 	movl   $0xffffffff,0x24(%rsp)
  8cfde3:	ff 
  8cfde4:	44 8b 64 24 0c       	mov    0xc(%rsp),%r12d
  8cfde9:	45 31 ff             	xor    %r15d,%r15d
  8cfdec:	41 be 01 00 00 00    	mov    $0x1,%r14d
  8cfdf2:	4c 8b 18             	mov    (%rax),%r11
  8cfdf5:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  8cfdf9:	83 e8 01             	sub    $0x1,%eax
  8cfdfc:	89 44 24 50          	mov    %eax,0x50(%rsp)
  8cfe00:	48 8b 3c 24          	mov    (%rsp),%rdi
  8cfe04:	44 89 f8             	mov    %r15d,%eax
  8cfe07:	41 89 d9             	mov    %ebx,%r9d
  8cfe0a:	45 31 c0             	xor    %r8d,%r8d
  8cfe0d:	45 29 e9             	sub    %r13d,%r9d
  8cfe10:	0f b7 04 47          	movzwl (%rdi,%rax,2),%eax
  8cfe14:	48 89 c7             	mov    %rax,%rdi
  8cfe17:	3b 44 24 18          	cmp    0x18(%rsp),%eax
  8cfe1b:	7c 19                	jl     8cfe36 <zlib_inflate_table+0x276>
  8cfe1d:	0f 8e c5 01 00 00    	jle    8cffe8 <zlib_inflate_table+0x428>
  8cfe23:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8cfe28:	44 0f b6 04 78       	movzbl (%rax,%rdi,2),%r8d
  8cfe2d:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  8cfe32:	0f b7 3c 78          	movzwl (%rax,%rdi,2),%edi
  8cfe36:	89 d9                	mov    %ebx,%ecx
  8cfe38:	45 89 f2             	mov    %r14d,%r10d
  8cfe3b:	44 89 f5             	mov    %r14d,%ebp
  8cfe3e:	89 f0                	mov    %esi,%eax
  8cfe40:	44 29 e9             	sub    %r13d,%ecx
  8cfe43:	41 d3 e2             	shl    %cl,%r10d
  8cfe46:	44 89 e1             	mov    %r12d,%ecx
  8cfe49:	d3 e5                	shl    %cl,%ebp
  8cfe4b:	44 89 e9             	mov    %r13d,%ecx
  8cfe4e:	d3 e8                	shr    %cl,%eax
  8cfe50:	89 c1                	mov    %eax,%ecx
  8cfe52:	89 e8                	mov    %ebp,%eax
  8cfe54:	0f 1f 40 00          	nopl   0x0(%rax)
  8cfe58:	44 29 d0             	sub    %r10d,%eax
  8cfe5b:	8d 14 01             	lea    (%rcx,%rax,1),%edx
  8cfe5e:	49 8d 14 93          	lea    (%r11,%rdx,4),%rdx
  8cfe62:	44 88 02             	mov    %r8b,(%rdx)
  8cfe65:	44 88 4a 01          	mov    %r9b,0x1(%rdx)
  8cfe69:	66 89 7a 02          	mov    %di,0x2(%rdx)
  8cfe6d:	75 e9                	jne    8cfe58 <zlib_inflate_table+0x298>
  8cfe6f:	8d 4b ff             	lea    -0x1(%rbx),%ecx
  8cfe72:	44 89 f0             	mov    %r14d,%eax
  8cfe75:	d3 e0                	shl    %cl,%eax
  8cfe77:	85 c6                	test   %eax,%esi
  8cfe79:	74 0b                	je     8cfe86 <zlib_inflate_table+0x2c6>
  8cfe7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8cfe80:	d1 e8                	shr    %eax
  8cfe82:	85 c6                	test   %eax,%esi
  8cfe84:	75 fa                	jne    8cfe80 <zlib_inflate_table+0x2c0>
  8cfe86:	85 c0                	test   %eax,%eax
  8cfe88:	74 07                	je     8cfe91 <zlib_inflate_table+0x2d1>
  8cfe8a:	8d 50 ff             	lea    -0x1(%rax),%edx
  8cfe8d:	21 d6                	and    %edx,%esi
  8cfe8f:	01 f0                	add    %esi,%eax
  8cfe91:	89 d9                	mov    %ebx,%ecx
  8cfe93:	41 83 c7 01          	add    $0x1,%r15d
  8cfe97:	66 83 6c 4c 58 01    	subw   $0x1,0x58(%rsp,%rcx,2)
  8cfe9d:	75 1e                	jne    8cfebd <zlib_inflate_table+0x2fd>
  8cfe9f:	3b 5c 24 20          	cmp    0x20(%rsp),%ebx
  8cfea3:	0f 84 4c 01 00 00    	je     8cfff5 <zlib_inflate_table+0x435>
  8cfea9:	48 8b 1c 24          	mov    (%rsp),%rbx
  8cfead:	44 89 fa             	mov    %r15d,%edx
  8cfeb0:	0f b7 14 53          	movzwl (%rbx,%rdx,2),%edx
  8cfeb4:	48 8b 5c 24 10       	mov    0x10(%rsp),%rbx
  8cfeb9:	0f b7 1c 53          	movzwl (%rbx,%rdx,2),%ebx
  8cfebd:	8b 7c 24 0c          	mov    0xc(%rsp),%edi
  8cfec1:	39 fb                	cmp    %edi,%ebx
  8cfec3:	76 0c                	jbe    8cfed1 <zlib_inflate_table+0x311>
  8cfec5:	8b 74 24 50          	mov    0x50(%rsp),%esi
  8cfec9:	21 c6                	and    %eax,%esi
  8cfecb:	3b 74 24 24          	cmp    0x24(%rsp),%esi
  8cfecf:	75 17                	jne    8cfee8 <zlib_inflate_table+0x328>
  8cfed1:	89 c6                	mov    %eax,%esi
  8cfed3:	e9 28 ff ff ff       	jmpq   8cfe00 <zlib_inflate_table+0x240>
  8cfed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8cfedd:	e9 a7 fd ff ff       	jmpq   8cfc89 <zlib_inflate_table+0xc9>
  8cfee2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8cfee8:	45 85 ed             	test   %r13d,%r13d
  8cfeeb:	41 89 dc             	mov    %ebx,%r12d
  8cfeee:	44 8b 44 24 20       	mov    0x20(%rsp),%r8d
  8cfef3:	44 89 f2             	mov    %r14d,%edx
  8cfef6:	44 0f 44 ef          	cmove  %edi,%r13d
  8cfefa:	4d 8d 1c ab          	lea    (%r11,%rbp,4),%r11
  8cfefe:	45 29 ec             	sub    %r13d,%r12d
  8cff01:	44 89 e1             	mov    %r12d,%ecx
  8cff04:	d3 e2                	shl    %cl,%edx
  8cff06:	44 39 c3             	cmp    %r8d,%ebx
  8cff09:	73 42                	jae    8cff4d <zlib_inflate_table+0x38d>
  8cff0b:	89 d9                	mov    %ebx,%ecx
  8cff0d:	0f b7 4c 4c 58       	movzwl 0x58(%rsp,%rcx,2),%ecx
  8cff12:	29 ca                	sub    %ecx,%edx
  8cff14:	85 d2                	test   %edx,%edx
  8cff16:	7e 35                	jle    8cff4d <zlib_inflate_table+0x38d>
  8cff18:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8cff1d:	8d 4b 01             	lea    0x1(%rbx),%ecx
  8cff20:	48 8d 0c 4f          	lea    (%rdi,%rcx,2),%rcx
  8cff24:	eb 17                	jmp    8cff3d <zlib_inflate_table+0x37d>
  8cff26:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8cff2d:	00 00 00 
  8cff30:	0f b7 39             	movzwl (%rcx),%edi
  8cff33:	48 83 c1 02          	add    $0x2,%rcx
  8cff37:	29 fa                	sub    %edi,%edx
  8cff39:	85 d2                	test   %edx,%edx
  8cff3b:	7e 10                	jle    8cff4d <zlib_inflate_table+0x38d>
  8cff3d:	41 83 c4 01          	add    $0x1,%r12d
  8cff41:	01 d2                	add    %edx,%edx
  8cff43:	43 8d 7c 25 00       	lea    0x0(%r13,%r12,1),%edi
  8cff48:	44 39 c7             	cmp    %r8d,%edi
  8cff4b:	72 e3                	jb     8cff30 <zlib_inflate_table+0x370>
  8cff4d:	44 89 f2             	mov    %r14d,%edx
  8cff50:	44 89 e1             	mov    %r12d,%ecx
  8cff53:	d3 e2                	shl    %cl,%edx
  8cff55:	01 54 24 1c          	add    %edx,0x1c(%rsp)
  8cff59:	8b 7c 24 1c          	mov    0x1c(%rsp),%edi
  8cff5d:	81 ff af 05 00 00    	cmp    $0x5af,%edi
  8cff63:	76 07                	jbe    8cff6c <zlib_inflate_table+0x3ac>
  8cff65:	80 7c 24 57 00       	cmpb   $0x0,0x57(%rsp)
  8cff6a:	75 52                	jne    8cffbe <zlib_inflate_table+0x3fe>
  8cff6c:	4c 8b 54 24 28       	mov    0x28(%rsp),%r10
  8cff71:	89 f2                	mov    %esi,%edx
  8cff73:	89 74 24 24          	mov    %esi,0x24(%rsp)
  8cff77:	89 c6                	mov    %eax,%esi
  8cff79:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  8cff80:	00 
  8cff81:	49 8b 3a             	mov    (%r10),%rdi
  8cff84:	44 88 24 97          	mov    %r12b,(%rdi,%rdx,4)
  8cff88:	4c 89 d7             	mov    %r10,%rdi
  8cff8b:	49 8b 12             	mov    (%r10),%rdx
  8cff8e:	44 0f b6 54 24 0c    	movzbl 0xc(%rsp),%r10d
  8cff94:	44 88 54 0a 01       	mov    %r10b,0x1(%rdx,%rcx,1)
  8cff99:	48 8b 3f             	mov    (%rdi),%rdi
  8cff9c:	4c 89 da             	mov    %r11,%rdx
  8cff9f:	48 29 fa             	sub    %rdi,%rdx
  8cffa2:	48 c1 fa 02          	sar    $0x2,%rdx
  8cffa6:	66 89 54 0f 02       	mov    %dx,0x2(%rdi,%rcx,1)
  8cffab:	e9 50 fe ff ff       	jmpq   8cfe00 <zlib_inflate_table+0x240>
  8cffb0:	81 7c 24 1c af 05 00 	cmpl   $0x5af,0x1c(%rsp)
  8cffb7:	00 
  8cffb8:	0f 86 e7 00 00 00    	jbe    8d00a5 <zlib_inflate_table+0x4e5>
  8cffbe:	b8 01 00 00 00       	mov    $0x1,%eax
  8cffc3:	e9 c1 fc ff ff       	jmpq   8cfc89 <zlib_inflate_table+0xc9>
  8cffc8:	48 8b 04 24          	mov    (%rsp),%rax
  8cffcc:	c7 44 24 18 13 00 00 	movl   $0x13,0x18(%rsp)
  8cffd3:	00 
  8cffd4:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8cffd9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8cffde:	e9 e3 fd ff ff       	jmpq   8cfdc6 <zlib_inflate_table+0x206>
  8cffe3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8cffe8:	31 ff                	xor    %edi,%edi
  8cffea:	41 b8 60 00 00 00    	mov    $0x60,%r8d
  8cfff0:	e9 41 fe ff ff       	jmpq   8cfe36 <zlib_inflate_table+0x276>
  8cfff5:	8b 6c 24 20          	mov    0x20(%rsp),%ebp
  8cfff9:	0f b6 7c 24 0c       	movzbl 0xc(%rsp),%edi
  8cfffe:	be 01 00 00 00       	mov    $0x1,%esi
  8d0003:	85 c0                	test   %eax,%eax
  8d0005:	74 63                	je     8d006a <zlib_inflate_table+0x4aa>
  8d0007:	44 8b 44 24 24       	mov    0x24(%rsp),%r8d
  8d000c:	44 8b 54 24 50       	mov    0x50(%rsp),%r10d
  8d0011:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d0018:	89 c2                	mov    %eax,%edx
  8d001a:	45 85 ed             	test   %r13d,%r13d
  8d001d:	74 1c                	je     8d003b <zlib_inflate_table+0x47b>
  8d001f:	44 21 d2             	and    %r10d,%edx
  8d0022:	44 39 c2             	cmp    %r8d,%edx
  8d0025:	74 75                	je     8d009c <zlib_inflate_table+0x4dc>
  8d0027:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8d002c:	8b 6c 24 0c          	mov    0xc(%rsp),%ebp
  8d0030:	41 89 f9             	mov    %edi,%r9d
  8d0033:	89 c2                	mov    %eax,%edx
  8d0035:	45 31 ed             	xor    %r13d,%r13d
  8d0038:	4c 8b 1b             	mov    (%rbx),%r11
  8d003b:	49 8d 14 93          	lea    (%r11,%rdx,4),%rdx
  8d003f:	31 c9                	xor    %ecx,%ecx
  8d0041:	66 89 4a 02          	mov    %cx,0x2(%rdx)
  8d0045:	8d 4d ff             	lea    -0x1(%rbp),%ecx
  8d0048:	c6 02 40             	movb   $0x40,(%rdx)
  8d004b:	44 88 4a 01          	mov    %r9b,0x1(%rdx)
  8d004f:	89 f2                	mov    %esi,%edx
  8d0051:	d3 e2                	shl    %cl,%edx
  8d0053:	85 d0                	test   %edx,%eax
  8d0055:	74 39                	je     8d0090 <zlib_inflate_table+0x4d0>
  8d0057:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d005e:	00 00 
  8d0060:	d1 ea                	shr    %edx
  8d0062:	85 d0                	test   %edx,%eax
  8d0064:	75 fa                	jne    8d0060 <zlib_inflate_table+0x4a0>
  8d0066:	85 d2                	test   %edx,%edx
  8d0068:	75 26                	jne    8d0090 <zlib_inflate_table+0x4d0>
  8d006a:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  8d006f:	8b 44 24 1c          	mov    0x1c(%rsp),%eax
  8d0073:	48 c1 e0 02          	shl    $0x2,%rax
  8d0077:	48 01 03             	add    %rax,(%rbx)
  8d007a:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8d007f:	8b 5c 24 0c          	mov    0xc(%rsp),%ebx
  8d0083:	89 18                	mov    %ebx,(%rax)
  8d0085:	31 c0                	xor    %eax,%eax
  8d0087:	e9 fd fb ff ff       	jmpq   8cfc89 <zlib_inflate_table+0xc9>
  8d008c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d0090:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  8d0093:	21 c8                	and    %ecx,%eax
  8d0095:	01 d0                	add    %edx,%eax
  8d0097:	e9 7c ff ff ff       	jmpq   8d0018 <zlib_inflate_table+0x458>
  8d009c:	89 c2                	mov    %eax,%edx
  8d009e:	44 89 e9             	mov    %r13d,%ecx
  8d00a1:	d3 ea                	shr    %cl,%edx
  8d00a3:	eb 96                	jmp    8d003b <zlib_inflate_table+0x47b>
  8d00a5:	48 8d 05 12 ac 00 00 	lea    0xac12(%rip),%rax        # 8dacbe <lenfix.30781+0x6be>
  8d00ac:	c7 44 24 18 00 01 00 	movl   $0x100,0x18(%rsp)
  8d00b3:	00 
  8d00b4:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8d00b9:	48 8d 05 3e ac 00 00 	lea    0xac3e(%rip),%rax        # 8dacfe <lenfix.30781+0x6fe>
  8d00c0:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8d00c5:	c6 44 24 57 01       	movb   $0x1,0x57(%rsp)
  8d00ca:	e9 ff fc ff ff       	jmpq   8cfdce <zlib_inflate_table+0x20e>
  8d00cf:	90                   	nop

00000000008d00d0 <inflate_fast>:
  8d00d0:	f3 0f 1e fa          	endbr64 
  8d00d4:	41 57                	push   %r15
  8d00d6:	89 f6                	mov    %esi,%esi
  8d00d8:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d00de:	41 56                	push   %r14
  8d00e0:	41 55                	push   %r13
  8d00e2:	41 54                	push   %r12
  8d00e4:	55                   	push   %rbp
  8d00e5:	53                   	push   %rbx
  8d00e6:	48 89 fb             	mov    %rdi,%rbx
  8d00e9:	48 83 ec 58          	sub    $0x58,%rsp
  8d00ed:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d00f1:	4c 8b 1b             	mov    (%rbx),%r11
  8d00f4:	48 8b 7f 38          	mov    0x38(%rdi),%rdi
  8d00f8:	4c 8b 53 18          	mov    0x18(%rbx),%r10
  8d00fc:	4d 8d 74 03 fb       	lea    -0x5(%r11,%rax,1),%r14
  8d0101:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8d0105:	8b 4f 6c             	mov    0x6c(%rdi),%ecx
  8d0108:	44 8b 6f 34          	mov    0x34(%rdi),%r13d
  8d010c:	48 89 c2             	mov    %rax,%rdx
  8d010f:	49 8d 84 02 ff fe ff 	lea    -0x101(%r10,%rax,1),%rax
  8d0116:	ff 
  8d0117:	8b 6f 2c             	mov    0x2c(%rdi),%ebp
  8d011a:	4c 8b 4f 58          	mov    0x58(%rdi),%r9
  8d011e:	48 29 f2             	sub    %rsi,%rdx
  8d0121:	48 89 04 24          	mov    %rax,(%rsp)
  8d0125:	8b 47 30             	mov    0x30(%rdi),%eax
  8d0128:	49 8d 34 12          	lea    (%r10,%rdx,1),%rsi
  8d012c:	44 89 c2             	mov    %r8d,%edx
  8d012f:	89 6c 24 30          	mov    %ebp,0x30(%rsp)
  8d0133:	44 01 ed             	add    %r13d,%ebp
  8d0136:	d3 e2                	shl    %cl,%edx
  8d0138:	8b 4f 68             	mov    0x68(%rdi),%ecx
  8d013b:	89 44 24 2c          	mov    %eax,0x2c(%rsp)
  8d013f:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8d0143:	4c 8b 7f 60          	mov    0x60(%rdi),%r15
  8d0147:	48 89 74 24 18       	mov    %rsi,0x18(%rsp)
  8d014c:	41 d3 e0             	shl    %cl,%r8d
  8d014f:	44 89 6c 24 28       	mov    %r13d,0x28(%rsp)
  8d0154:	8b 77 48             	mov    0x48(%rdi),%esi
  8d0157:	41 8d 48 ff          	lea    -0x1(%r8),%ecx
  8d015b:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d0160:	48 8b 47 40          	mov    0x40(%rdi),%rax
  8d0164:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d016a:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d016f:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  8d0172:	48 89 4c 24 10       	mov    %rcx,0x10(%rsp)
  8d0177:	41 8d 4d ff          	lea    -0x1(%r13),%ecx
  8d017b:	49 89 fd             	mov    %rdi,%r13
  8d017e:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  8d0183:	48 83 c1 01          	add    $0x1,%rcx
  8d0187:	89 6c 24 34          	mov    %ebp,0x34(%rsp)
  8d018b:	48 89 4c 24 40       	mov    %rcx,0x40(%rsp)
  8d0190:	83 fe 0e             	cmp    $0xe,%esi
  8d0193:	77 21                	ja     8d01b6 <inflate_fast+0xe6>
  8d0195:	41 0f b6 53 01       	movzbl 0x1(%r11),%edx
  8d019a:	8d 4e 08             	lea    0x8(%rsi),%ecx
  8d019d:	41 0f b6 3b          	movzbl (%r11),%edi
  8d01a1:	49 83 c3 02          	add    $0x2,%r11
  8d01a5:	48 d3 e2             	shl    %cl,%rdx
  8d01a8:	89 f1                	mov    %esi,%ecx
  8d01aa:	83 c6 10             	add    $0x10,%esi
  8d01ad:	48 d3 e7             	shl    %cl,%rdi
  8d01b0:	48 01 fa             	add    %rdi,%rdx
  8d01b3:	48 01 d0             	add    %rdx,%rax
  8d01b6:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d01bb:	48 21 c2             	and    %rax,%rdx
  8d01be:	49 8d 14 91          	lea    (%r9,%rdx,4),%rdx
  8d01c2:	0f b6 4a 01          	movzbl 0x1(%rdx),%ecx
  8d01c6:	0f b6 3a             	movzbl (%rdx),%edi
  8d01c9:	44 0f b7 62 02       	movzwl 0x2(%rdx),%r12d
  8d01ce:	48 d3 e8             	shr    %cl,%rax
  8d01d1:	29 ce                	sub    %ecx,%esi
  8d01d3:	40 0f b6 cf          	movzbl %dil,%ecx
  8d01d7:	85 c9                	test   %ecx,%ecx
  8d01d9:	74 5a                	je     8d0235 <inflate_fast+0x165>
  8d01db:	40 f6 c7 10          	test   $0x10,%dil
  8d01df:	75 7a                	jne    8d025b <inflate_fast+0x18b>
  8d01e1:	40 f6 c7 40          	test   $0x40,%dil
  8d01e5:	0f 85 d5 01 00 00    	jne    8d03c0 <inflate_fast+0x2f0>
  8d01eb:	44 89 e5             	mov    %r12d,%ebp
  8d01ee:	eb 10                	jmp    8d0200 <inflate_fast+0x130>
  8d01f0:	40 f6 c7 10          	test   $0x10,%dil
  8d01f4:	75 62                	jne    8d0258 <inflate_fast+0x188>
  8d01f6:	40 f6 c7 40          	test   $0x40,%dil
  8d01fa:	0f 85 c0 01 00 00    	jne    8d03c0 <inflate_fast+0x2f0>
  8d0200:	44 89 c2             	mov    %r8d,%edx
  8d0203:	d3 e2                	shl    %cl,%edx
  8d0205:	44 8d 62 ff          	lea    -0x1(%rdx),%r12d
  8d0209:	4c 89 e2             	mov    %r12,%rdx
  8d020c:	44 0f b7 e5          	movzwl %bp,%r12d
  8d0210:	48 21 c2             	and    %rax,%rdx
  8d0213:	49 01 d4             	add    %rdx,%r12
  8d0216:	4b 8d 14 a1          	lea    (%r9,%r12,4),%rdx
  8d021a:	0f b6 4a 01          	movzbl 0x1(%rdx),%ecx
  8d021e:	0f b6 3a             	movzbl (%rdx),%edi
  8d0221:	0f b7 6a 02          	movzwl 0x2(%rdx),%ebp
  8d0225:	48 d3 e8             	shr    %cl,%rax
  8d0228:	29 ce                	sub    %ecx,%esi
  8d022a:	40 0f b6 cf          	movzbl %dil,%ecx
  8d022e:	85 c9                	test   %ecx,%ecx
  8d0230:	75 be                	jne    8d01f0 <inflate_fast+0x120>
  8d0232:	41 89 ec             	mov    %ebp,%r12d
  8d0235:	45 88 22             	mov    %r12b,(%r10)
  8d0238:	49 83 c2 01          	add    $0x1,%r10
  8d023c:	4d 39 f3             	cmp    %r14,%r11
  8d023f:	73 0a                	jae    8d024b <inflate_fast+0x17b>
  8d0241:	4c 3b 14 24          	cmp    (%rsp),%r10
  8d0245:	0f 82 45 ff ff ff    	jb     8d0190 <inflate_fast+0xc0>
  8d024b:	4c 89 ef             	mov    %r13,%rdi
  8d024e:	e9 8e 01 00 00       	jmpq   8d03e1 <inflate_fast+0x311>
  8d0253:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d0258:	41 89 ec             	mov    %ebp,%r12d
  8d025b:	41 0f b7 d4          	movzwl %r12w,%edx
  8d025f:	83 e7 0f             	and    $0xf,%edi
  8d0262:	74 36                	je     8d029a <inflate_fast+0x1ca>
  8d0264:	40 0f b6 ef          	movzbl %dil,%ebp
  8d0268:	39 f5                	cmp    %esi,%ebp
  8d026a:	76 13                	jbe    8d027f <inflate_fast+0x1af>
  8d026c:	45 0f b6 23          	movzbl (%r11),%r12d
  8d0270:	89 f1                	mov    %esi,%ecx
  8d0272:	49 83 c3 01          	add    $0x1,%r11
  8d0276:	83 c6 08             	add    $0x8,%esi
  8d0279:	49 d3 e4             	shl    %cl,%r12
  8d027c:	4c 01 e0             	add    %r12,%rax
  8d027f:	89 f9                	mov    %edi,%ecx
  8d0281:	41 bc ff ff ff ff    	mov    $0xffffffff,%r12d
  8d0287:	29 ee                	sub    %ebp,%esi
  8d0289:	41 d3 e4             	shl    %cl,%r12d
  8d028c:	44 89 e1             	mov    %r12d,%ecx
  8d028f:	f7 d1                	not    %ecx
  8d0291:	21 c1                	and    %eax,%ecx
  8d0293:	01 ca                	add    %ecx,%edx
  8d0295:	89 f9                	mov    %edi,%ecx
  8d0297:	48 d3 e8             	shr    %cl,%rax
  8d029a:	83 fe 0e             	cmp    $0xe,%esi
  8d029d:	0f 86 ad 01 00 00    	jbe    8d0450 <inflate_fast+0x380>
  8d02a3:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d02a8:	48 21 c1             	and    %rax,%rcx
  8d02ab:	eb 1c                	jmp    8d02c9 <inflate_fast+0x1f9>
  8d02ad:	0f 1f 00             	nopl   (%rax)
  8d02b0:	83 e7 40             	and    $0x40,%edi
  8d02b3:	0f 85 f7 01 00 00    	jne    8d04b0 <inflate_fast+0x3e0>
  8d02b9:	44 89 c7             	mov    %r8d,%edi
  8d02bc:	d3 e7                	shl    %cl,%edi
  8d02be:	89 f9                	mov    %edi,%ecx
  8d02c0:	83 e9 01             	sub    $0x1,%ecx
  8d02c3:	48 21 c1             	and    %rax,%rcx
  8d02c6:	4c 01 e1             	add    %r12,%rcx
  8d02c9:	49 8d 0c 8f          	lea    (%r15,%rcx,4),%rcx
  8d02cd:	0f b6 39             	movzbl (%rcx),%edi
  8d02d0:	44 0f b7 61 02       	movzwl 0x2(%rcx),%r12d
  8d02d5:	0f b6 49 01          	movzbl 0x1(%rcx),%ecx
  8d02d9:	48 d3 e8             	shr    %cl,%rax
  8d02dc:	29 ce                	sub    %ecx,%esi
  8d02de:	40 0f b6 cf          	movzbl %dil,%ecx
  8d02e2:	40 f6 c7 10          	test   $0x10,%dil
  8d02e6:	74 c8                	je     8d02b0 <inflate_fast+0x1e0>
  8d02e8:	41 0f b7 cc          	movzwl %r12w,%ecx
  8d02ec:	41 89 fc             	mov    %edi,%r12d
  8d02ef:	83 e7 0f             	and    $0xf,%edi
  8d02f2:	89 4c 24 48          	mov    %ecx,0x48(%rsp)
  8d02f6:	41 83 e4 0f          	and    $0xf,%r12d
  8d02fa:	39 f7                	cmp    %esi,%edi
  8d02fc:	76 20                	jbe    8d031e <inflate_fast+0x24e>
  8d02fe:	41 0f b6 0b          	movzbl (%r11),%ecx
  8d0302:	48 89 cd             	mov    %rcx,%rbp
  8d0305:	89 f1                	mov    %esi,%ecx
  8d0307:	48 d3 e5             	shl    %cl,%rbp
  8d030a:	8d 4e 08             	lea    0x8(%rsi),%ecx
  8d030d:	48 01 e8             	add    %rbp,%rax
  8d0310:	39 cf                	cmp    %ecx,%edi
  8d0312:	0f 87 6f 02 00 00    	ja     8d0587 <inflate_fast+0x4b7>
  8d0318:	49 83 c3 01          	add    $0x1,%r11
  8d031c:	89 ce                	mov    %ecx,%esi
  8d031e:	44 89 e1             	mov    %r12d,%ecx
  8d0321:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
  8d0326:	29 fe                	sub    %edi,%esi
  8d0328:	4c 89 d7             	mov    %r10,%rdi
  8d032b:	d3 e5                	shl    %cl,%ebp
  8d032d:	48 2b 7c 24 18       	sub    0x18(%rsp),%rdi
  8d0332:	89 e9                	mov    %ebp,%ecx
  8d0334:	8b 6c 24 48          	mov    0x48(%rsp),%ebp
  8d0338:	f7 d1                	not    %ecx
  8d033a:	21 c1                	and    %eax,%ecx
  8d033c:	01 cd                	add    %ecx,%ebp
  8d033e:	44 89 e1             	mov    %r12d,%ecx
  8d0341:	48 d3 e8             	shr    %cl,%rax
  8d0344:	39 fd                	cmp    %edi,%ebp
  8d0346:	0f 87 ab 01 00 00    	ja     8d04f7 <inflate_fast+0x427>
  8d034c:	89 e9                	mov    %ebp,%ecx
  8d034e:	4d 89 d4             	mov    %r10,%r12
  8d0351:	49 29 cc             	sub    %rcx,%r12
  8d0354:	41 f6 c2 01          	test   $0x1,%r10b
  8d0358:	74 14                	je     8d036e <inflate_fast+0x29e>
  8d035a:	41 0f b6 0c 24       	movzbl (%r12),%ecx
  8d035f:	83 ea 01             	sub    $0x1,%edx
  8d0362:	49 83 c4 01          	add    $0x1,%r12
  8d0366:	49 83 c2 01          	add    $0x1,%r10
  8d036a:	41 88 4a ff          	mov    %cl,-0x1(%r10)
  8d036e:	89 d7                	mov    %edx,%edi
  8d0370:	d1 ef                	shr    %edi
  8d0372:	83 fd 02             	cmp    $0x2,%ebp
  8d0375:	0f 86 50 01 00 00    	jbe    8d04cb <inflate_fast+0x3fb>
  8d037b:	31 c9                	xor    %ecx,%ecx
  8d037d:	0f 1f 00             	nopl   (%rax)
  8d0380:	41 0f b7 2c 4c       	movzwl (%r12,%rcx,2),%ebp
  8d0385:	66 41 89 2c 4a       	mov    %bp,(%r10,%rcx,2)
  8d038a:	48 83 c1 01          	add    $0x1,%rcx
  8d038e:	48 39 f9             	cmp    %rdi,%rcx
  8d0391:	75 ed                	jne    8d0380 <inflate_fast+0x2b0>
  8d0393:	48 01 c9             	add    %rcx,%rcx
  8d0396:	49 01 cc             	add    %rcx,%r12
  8d0399:	49 01 ca             	add    %rcx,%r10
  8d039c:	83 e2 01             	and    $0x1,%edx
  8d039f:	0f 84 97 fe ff ff    	je     8d023c <inflate_fast+0x16c>
  8d03a5:	41 0f b6 14 24       	movzbl (%r12),%edx
  8d03aa:	49 83 c2 01          	add    $0x1,%r10
  8d03ae:	41 88 52 ff          	mov    %dl,-0x1(%r10)
  8d03b2:	e9 85 fe ff ff       	jmpq   8d023c <inflate_fast+0x16c>
  8d03b7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d03be:	00 00 
  8d03c0:	89 fd                	mov    %edi,%ebp
  8d03c2:	4c 89 ef             	mov    %r13,%rdi
  8d03c5:	83 e5 20             	and    $0x20,%ebp
  8d03c8:	0f 85 b2 00 00 00    	jne    8d0480 <inflate_fast+0x3b0>
  8d03ce:	48 8d 0d ef ad 00 00 	lea    0xadef(%rip),%rcx        # 8db1c4 <kernel_info_end+0x34>
  8d03d5:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  8d03d9:	41 c7 45 00 1b 00 00 	movl   $0x1b,0x0(%r13)
  8d03e0:	00 
  8d03e1:	89 f2                	mov    %esi,%edx
  8d03e3:	83 e6 07             	and    $0x7,%esi
  8d03e6:	4c 89 53 18          	mov    %r10,0x18(%rbx)
  8d03ea:	c1 ea 03             	shr    $0x3,%edx
  8d03ed:	89 f1                	mov    %esi,%ecx
  8d03ef:	49 29 d3             	sub    %rdx,%r11
  8d03f2:	ba 01 00 00 00       	mov    $0x1,%edx
  8d03f7:	d3 e2                	shl    %cl,%edx
  8d03f9:	4c 89 1b             	mov    %r11,(%rbx)
  8d03fc:	83 ea 01             	sub    $0x1,%edx
  8d03ff:	48 21 d0             	and    %rdx,%rax
  8d0402:	4d 39 de             	cmp    %r11,%r14
  8d0405:	0f 86 95 00 00 00    	jbe    8d04a0 <inflate_fast+0x3d0>
  8d040b:	4c 89 f2             	mov    %r14,%rdx
  8d040e:	4c 29 da             	sub    %r11,%rdx
  8d0411:	83 c2 05             	add    $0x5,%edx
  8d0414:	48 8b 34 24          	mov    (%rsp),%rsi
  8d0418:	48 89 53 08          	mov    %rdx,0x8(%rbx)
  8d041c:	49 39 f2             	cmp    %rsi,%r10
  8d041f:	73 6f                	jae    8d0490 <inflate_fast+0x3c0>
  8d0421:	4c 29 d6             	sub    %r10,%rsi
  8d0424:	48 89 f2             	mov    %rsi,%rdx
  8d0427:	81 c2 01 01 00 00    	add    $0x101,%edx
  8d042d:	48 89 53 20          	mov    %rdx,0x20(%rbx)
  8d0431:	48 89 47 40          	mov    %rax,0x40(%rdi)
  8d0435:	89 4f 48             	mov    %ecx,0x48(%rdi)
  8d0438:	48 83 c4 58          	add    $0x58,%rsp
  8d043c:	5b                   	pop    %rbx
  8d043d:	5d                   	pop    %rbp
  8d043e:	41 5c                	pop    %r12
  8d0440:	41 5d                	pop    %r13
  8d0442:	41 5e                	pop    %r14
  8d0444:	41 5f                	pop    %r15
  8d0446:	c3                   	retq   
  8d0447:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d044e:	00 00 
  8d0450:	41 0f b6 7b 01       	movzbl 0x1(%r11),%edi
  8d0455:	8d 4e 08             	lea    0x8(%rsi),%ecx
  8d0458:	41 0f b6 2b          	movzbl (%r11),%ebp
  8d045c:	49 83 c3 02          	add    $0x2,%r11
  8d0460:	48 d3 e7             	shl    %cl,%rdi
  8d0463:	89 f1                	mov    %esi,%ecx
  8d0465:	83 c6 10             	add    $0x10,%esi
  8d0468:	48 d3 e5             	shl    %cl,%rbp
  8d046b:	48 01 ef             	add    %rbp,%rdi
  8d046e:	48 01 f8             	add    %rdi,%rax
  8d0471:	e9 2d fe ff ff       	jmpq   8d02a3 <inflate_fast+0x1d3>
  8d0476:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d047d:	00 00 00 
  8d0480:	41 c7 45 00 0b 00 00 	movl   $0xb,0x0(%r13)
  8d0487:	00 
  8d0488:	e9 54 ff ff ff       	jmpq   8d03e1 <inflate_fast+0x311>
  8d048d:	0f 1f 00             	nopl   (%rax)
  8d0490:	8b 14 24             	mov    (%rsp),%edx
  8d0493:	44 29 d2             	sub    %r10d,%edx
  8d0496:	81 c2 01 01 00 00    	add    $0x101,%edx
  8d049c:	eb 8f                	jmp    8d042d <inflate_fast+0x35d>
  8d049e:	66 90                	xchg   %ax,%ax
  8d04a0:	44 89 f2             	mov    %r14d,%edx
  8d04a3:	44 29 da             	sub    %r11d,%edx
  8d04a6:	83 c2 05             	add    $0x5,%edx
  8d04a9:	e9 66 ff ff ff       	jmpq   8d0414 <inflate_fast+0x344>
  8d04ae:	66 90                	xchg   %ax,%ax
  8d04b0:	48 8d 0d f7 ac 00 00 	lea    0xacf7(%rip),%rcx        # 8db1ae <kernel_info_end+0x1e>
  8d04b7:	4c 89 ef             	mov    %r13,%rdi
  8d04ba:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  8d04be:	41 c7 45 00 1b 00 00 	movl   $0x1b,0x0(%r13)
  8d04c5:	00 
  8d04c6:	e9 16 ff ff ff       	jmpq   8d03e1 <inflate_fast+0x311>
  8d04cb:	41 0f b7 4a fe       	movzwl -0x2(%r10),%ecx
  8d04d0:	83 fd 01             	cmp    $0x1,%ebp
  8d04d3:	0f 84 15 01 00 00    	je     8d05ee <inflate_fast+0x51e>
  8d04d9:	31 ed                	xor    %ebp,%ebp
  8d04db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d04e0:	66 41 89 0c 6a       	mov    %cx,(%r10,%rbp,2)
  8d04e5:	48 83 c5 01          	add    $0x1,%rbp
  8d04e9:	48 39 fd             	cmp    %rdi,%rbp
  8d04ec:	75 f2                	jne    8d04e0 <inflate_fast+0x410>
  8d04ee:	4d 8d 14 6a          	lea    (%r10,%rbp,2),%r10
  8d04f2:	e9 a5 fe ff ff       	jmpq   8d039c <inflate_fast+0x2cc>
  8d04f7:	41 89 ec             	mov    %ebp,%r12d
  8d04fa:	41 29 fc             	sub    %edi,%r12d
  8d04fd:	44 39 64 24 2c       	cmp    %r12d,0x2c(%rsp)
  8d0502:	0f 82 c0 01 00 00    	jb     8d06c8 <inflate_fast+0x5f8>
  8d0508:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  8d050c:	29 ef                	sub    %ebp,%edi
  8d050e:	85 c9                	test   %ecx,%ecx
  8d0510:	0f 84 88 00 00 00    	je     8d059e <inflate_fast+0x4ce>
  8d0516:	44 39 64 24 28       	cmp    %r12d,0x28(%rsp)
  8d051b:	0f 83 d8 00 00 00    	jae    8d05f9 <inflate_fast+0x529>
  8d0521:	8b 4c 24 34          	mov    0x34(%rsp),%ecx
  8d0525:	44 2b 64 24 28       	sub    0x28(%rsp),%r12d
  8d052a:	01 f9                	add    %edi,%ecx
  8d052c:	48 03 4c 24 20       	add    0x20(%rsp),%rcx
  8d0531:	44 39 e2             	cmp    %r12d,%edx
  8d0534:	76 2c                	jbe    8d0562 <inflate_fast+0x492>
  8d0536:	e9 13 01 00 00       	jmpq   8d064e <inflate_fast+0x57e>
  8d053b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d0540:	0f b6 39             	movzbl (%rcx),%edi
  8d0543:	48 83 c1 03          	add    $0x3,%rcx
  8d0547:	49 83 c2 03          	add    $0x3,%r10
  8d054b:	83 ea 03             	sub    $0x3,%edx
  8d054e:	41 88 7a fd          	mov    %dil,-0x3(%r10)
  8d0552:	0f b6 79 fe          	movzbl -0x2(%rcx),%edi
  8d0556:	41 88 7a fe          	mov    %dil,-0x2(%r10)
  8d055a:	0f b6 79 ff          	movzbl -0x1(%rcx),%edi
  8d055e:	41 88 7a ff          	mov    %dil,-0x1(%r10)
  8d0562:	83 fa 02             	cmp    $0x2,%edx
  8d0565:	77 d9                	ja     8d0540 <inflate_fast+0x470>
  8d0567:	85 d2                	test   %edx,%edx
  8d0569:	0f 84 cd fc ff ff    	je     8d023c <inflate_fast+0x16c>
  8d056f:	0f b6 39             	movzbl (%rcx),%edi
  8d0572:	41 88 3a             	mov    %dil,(%r10)
  8d0575:	83 fa 02             	cmp    $0x2,%edx
  8d0578:	0f 84 bf 00 00 00    	je     8d063d <inflate_fast+0x56d>
  8d057e:	49 83 c2 01          	add    $0x1,%r10
  8d0582:	e9 b5 fc ff ff       	jmpq   8d023c <inflate_fast+0x16c>
  8d0587:	41 0f b6 6b 01       	movzbl 0x1(%r11),%ebp
  8d058c:	83 c6 10             	add    $0x10,%esi
  8d058f:	49 83 c3 02          	add    $0x2,%r11
  8d0593:	48 d3 e5             	shl    %cl,%rbp
  8d0596:	48 01 e8             	add    %rbp,%rax
  8d0599:	e9 80 fd ff ff       	jmpq   8d031e <inflate_fast+0x24e>
  8d059e:	8b 4c 24 30          	mov    0x30(%rsp),%ecx
  8d05a2:	01 f9                	add    %edi,%ecx
  8d05a4:	48 03 4c 24 20       	add    0x20(%rsp),%rcx
  8d05a9:	44 39 e2             	cmp    %r12d,%edx
  8d05ac:	76 b4                	jbe    8d0562 <inflate_fast+0x492>
  8d05ae:	01 fa                	add    %edi,%edx
  8d05b0:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  8d05b5:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
  8d05ba:	48 83 c7 01          	add    $0x1,%rdi
  8d05be:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
  8d05c3:	31 ff                	xor    %edi,%edi
  8d05c5:	44 0f b6 24 39       	movzbl (%rcx,%rdi,1),%r12d
  8d05ca:	45 88 24 3a          	mov    %r12b,(%r10,%rdi,1)
  8d05ce:	49 89 fc             	mov    %rdi,%r12
  8d05d1:	48 83 c7 01          	add    $0x1,%rdi
  8d05d5:	4c 39 64 24 48       	cmp    %r12,0x48(%rsp)
  8d05da:	75 e9                	jne    8d05c5 <inflate_fast+0x4f5>
  8d05dc:	4c 03 54 24 50       	add    0x50(%rsp),%r10
  8d05e1:	89 ed                	mov    %ebp,%ebp
  8d05e3:	4c 89 d1             	mov    %r10,%rcx
  8d05e6:	48 29 e9             	sub    %rbp,%rcx
  8d05e9:	e9 74 ff ff ff       	jmpq   8d0562 <inflate_fast+0x492>
  8d05ee:	0f b6 ed             	movzbl %ch,%ebp
  8d05f1:	40 88 e9             	mov    %bpl,%cl
  8d05f4:	e9 e0 fe ff ff       	jmpq   8d04d9 <inflate_fast+0x409>
  8d05f9:	8b 4c 24 28          	mov    0x28(%rsp),%ecx
  8d05fd:	01 f9                	add    %edi,%ecx
  8d05ff:	48 03 4c 24 20       	add    0x20(%rsp),%rcx
  8d0604:	44 39 e2             	cmp    %r12d,%edx
  8d0607:	0f 86 55 ff ff ff    	jbe    8d0562 <inflate_fast+0x492>
  8d060d:	01 fa                	add    %edi,%edx
  8d060f:	41 8d 7c 24 ff       	lea    -0x1(%r12),%edi
  8d0614:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
  8d0619:	48 83 c7 01          	add    $0x1,%rdi
  8d061d:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
  8d0622:	31 ff                	xor    %edi,%edi
  8d0624:	44 0f b6 24 39       	movzbl (%rcx,%rdi,1),%r12d
  8d0629:	45 88 24 3a          	mov    %r12b,(%r10,%rdi,1)
  8d062d:	49 89 fc             	mov    %rdi,%r12
  8d0630:	48 83 c7 01          	add    $0x1,%rdi
  8d0634:	4c 39 64 24 48       	cmp    %r12,0x48(%rsp)
  8d0639:	75 e9                	jne    8d0624 <inflate_fast+0x554>
  8d063b:	eb 9f                	jmp    8d05dc <inflate_fast+0x50c>
  8d063d:	0f b6 51 01          	movzbl 0x1(%rcx),%edx
  8d0641:	49 83 c2 02          	add    $0x2,%r10
  8d0645:	41 88 52 ff          	mov    %dl,-0x1(%r10)
  8d0649:	e9 ee fb ff ff       	jmpq   8d023c <inflate_fast+0x16c>
  8d064e:	03 54 24 28          	add    0x28(%rsp),%edx
  8d0652:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d0657:	01 fa                	add    %edi,%edx
  8d0659:	44 89 e7             	mov    %r12d,%edi
  8d065c:	48 89 7c 24 48       	mov    %rdi,0x48(%rsp)
  8d0661:	31 ff                	xor    %edi,%edi
  8d0663:	0f b6 04 39          	movzbl (%rcx,%rdi,1),%eax
  8d0667:	41 88 04 3a          	mov    %al,(%r10,%rdi,1)
  8d066b:	48 83 c7 01          	add    $0x1,%rdi
  8d066f:	48 39 7c 24 48       	cmp    %rdi,0x48(%rsp)
  8d0674:	75 ed                	jne    8d0663 <inflate_fast+0x593>
  8d0676:	41 8d 4c 24 ff       	lea    -0x1(%r12),%ecx
  8d067b:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8d0680:	4d 8d 54 0a 01       	lea    0x1(%r10,%rcx,1),%r10
  8d0685:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8d068a:	39 54 24 28          	cmp    %edx,0x28(%rsp)
  8d068e:	0f 83 ce fe ff ff    	jae    8d0562 <inflate_fast+0x492>
  8d0694:	4c 8b 64 24 20       	mov    0x20(%rsp),%r12
  8d0699:	2b 54 24 28          	sub    0x28(%rsp),%edx
  8d069d:	31 c9                	xor    %ecx,%ecx
  8d069f:	41 0f b6 3c 0c       	movzbl (%r12,%rcx,1),%edi
  8d06a4:	41 88 3c 0a          	mov    %dil,(%r10,%rcx,1)
  8d06a8:	48 89 cf             	mov    %rcx,%rdi
  8d06ab:	48 83 c1 01          	add    $0x1,%rcx
  8d06af:	48 39 7c 24 38       	cmp    %rdi,0x38(%rsp)
  8d06b4:	75 e9                	jne    8d069f <inflate_fast+0x5cf>
  8d06b6:	4c 03 54 24 40       	add    0x40(%rsp),%r10
  8d06bb:	89 ed                	mov    %ebp,%ebp
  8d06bd:	4c 89 d1             	mov    %r10,%rcx
  8d06c0:	48 29 e9             	sub    %rbp,%rcx
  8d06c3:	e9 9a fe ff ff       	jmpq   8d0562 <inflate_fast+0x492>
  8d06c8:	48 8d 0d c1 aa 00 00 	lea    0xaac1(%rip),%rcx        # 8db190 <kernel_info_end>
  8d06cf:	4c 89 ef             	mov    %r13,%rdi
  8d06d2:	48 89 4b 30          	mov    %rcx,0x30(%rbx)
  8d06d6:	41 c7 45 00 1b 00 00 	movl   $0x1b,0x0(%r13)
  8d06dd:	00 
  8d06de:	e9 fe fc ff ff       	jmpq   8d03e1 <inflate_fast+0x311>
  8d06e3:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d06ea:	00 00 00 00 
  8d06ee:	66 90                	xchg   %ax,%ax

00000000008d06f0 <zlib_inflate_workspacesize>:
  8d06f0:	f3 0f 1e fa          	endbr64 
  8d06f4:	b8 48 a5 00 00       	mov    $0xa548,%eax
  8d06f9:	c3                   	retq   
  8d06fa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d0700 <zlib_inflateReset>:
  8d0700:	f3 0f 1e fa          	endbr64 
  8d0704:	48 85 ff             	test   %rdi,%rdi
  8d0707:	0f 84 83 00 00 00    	je     8d0790 <zlib_inflateReset+0x90>
  8d070d:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8d0711:	48 85 c0             	test   %rax,%rax
  8d0714:	74 7a                	je     8d0790 <zlib_inflateReset+0x90>
  8d0716:	48 c7 40 20 00 00 00 	movq   $0x0,0x20(%rax)
  8d071d:	00 
  8d071e:	48 8d 90 48 05 00 00 	lea    0x548(%rax),%rdx
  8d0725:	48 c7 47 28 00 00 00 	movq   $0x0,0x28(%rdi)
  8d072c:	00 
  8d072d:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  8d0734:	00 
  8d0735:	48 c7 47 30 00 00 00 	movq   $0x0,0x30(%rdi)
  8d073c:	00 
  8d073d:	48 c7 47 50 01 00 00 	movq   $0x1,0x50(%rdi)
  8d0744:	00 
  8d0745:	8b 48 28             	mov    0x28(%rax),%ecx
  8d0748:	48 89 90 80 00 00 00 	mov    %rdx,0x80(%rax)
  8d074f:	48 89 50 60          	mov    %rdx,0x60(%rax)
  8d0753:	48 89 50 58          	mov    %rdx,0x58(%rax)
  8d0757:	ba 01 00 00 00       	mov    $0x1,%edx
  8d075c:	d3 e2                	shl    %cl,%edx
  8d075e:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  8d0765:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%rax)
  8d076c:	c7 40 14 00 80 00 00 	movl   $0x8000,0x14(%rax)
  8d0773:	48 c7 40 40 00 00 00 	movq   $0x0,0x40(%rax)
  8d077a:	00 
  8d077b:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%rax)
  8d0782:	89 50 2c             	mov    %edx,0x2c(%rax)
  8d0785:	48 c7 40 30 00 00 00 	movq   $0x0,0x30(%rax)
  8d078c:	00 
  8d078d:	31 c0                	xor    %eax,%eax
  8d078f:	c3                   	retq   
  8d0790:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  8d0795:	c3                   	retq   
  8d0796:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d079d:	00 00 00 

00000000008d07a0 <zlib_inflateInit2>:
  8d07a0:	f3 0f 1e fa          	endbr64 
  8d07a4:	48 85 ff             	test   %rdi,%rdi
  8d07a7:	74 47                	je     8d07f0 <zlib_inflateInit2+0x50>
  8d07a9:	48 8b 47 40          	mov    0x40(%rdi),%rax
  8d07ad:	89 f2                	mov    %esi,%edx
  8d07af:	48 c7 47 30 00 00 00 	movq   $0x0,0x30(%rdi)
  8d07b6:	00 
  8d07b7:	c1 fa 04             	sar    $0x4,%edx
  8d07ba:	48 89 47 38          	mov    %rax,0x38(%rdi)
  8d07be:	83 c2 01             	add    $0x1,%edx
  8d07c1:	85 f6                	test   %esi,%esi
  8d07c3:	79 04                	jns    8d07c9 <zlib_inflateInit2+0x29>
  8d07c5:	f7 de                	neg    %esi
  8d07c7:	31 d2                	xor    %edx,%edx
  8d07c9:	89 50 08             	mov    %edx,0x8(%rax)
  8d07cc:	8d 56 f8             	lea    -0x8(%rsi),%edx
  8d07cf:	83 fa 07             	cmp    $0x7,%edx
  8d07d2:	77 1c                	ja     8d07f0 <zlib_inflateInit2+0x50>
  8d07d4:	89 70 28             	mov    %esi,0x28(%rax)
  8d07d7:	48 8b 4f 40          	mov    0x40(%rdi),%rcx
  8d07db:	48 8d 91 48 25 00 00 	lea    0x2548(%rcx),%rdx
  8d07e2:	48 89 50 38          	mov    %rdx,0x38(%rax)
  8d07e6:	e9 15 ff ff ff       	jmpq   8d0700 <zlib_inflateReset>
  8d07eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d07f0:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  8d07f5:	c3                   	retq   
  8d07f6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d07fd:	00 00 00 

00000000008d0800 <zlib_inflate>:
  8d0800:	f3 0f 1e fa          	endbr64 
  8d0804:	41 57                	push   %r15
  8d0806:	41 56                	push   %r14
  8d0808:	41 55                	push   %r13
  8d080a:	41 54                	push   %r12
  8d080c:	55                   	push   %rbp
  8d080d:	53                   	push   %rbx
  8d080e:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  8d0815:	89 74 24 34          	mov    %esi,0x34(%rsp)
  8d0819:	48 85 ff             	test   %rdi,%rdi
  8d081c:	0f 84 96 01 00 00    	je     8d09b8 <zlib_inflate+0x1b8>
  8d0822:	48 8b 6f 38          	mov    0x38(%rdi),%rbp
  8d0826:	49 89 fc             	mov    %rdi,%r12
  8d0829:	48 85 ed             	test   %rbp,%rbp
  8d082c:	0f 84 86 01 00 00    	je     8d09b8 <zlib_inflate+0x1b8>
  8d0832:	4c 8b 37             	mov    (%rdi),%r14
  8d0835:	4d 85 f6             	test   %r14,%r14
  8d0838:	0f 84 6a 01 00 00    	je     8d09a8 <zlib_inflate+0x1a8>
  8d083e:	8b 75 00             	mov    0x0(%rbp),%esi
  8d0841:	83 fe 0b             	cmp    $0xb,%esi
  8d0844:	75 10                	jne    8d0856 <zlib_inflate+0x56>
  8d0846:	c7 45 00 0c 00 00 00 	movl   $0xc,0x0(%rbp)
  8d084d:	4d 8b 34 24          	mov    (%r12),%r14
  8d0851:	be 0c 00 00 00       	mov    $0xc,%esi
  8d0856:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  8d085b:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
  8d0860:	4c 8d 3d f9 9b 00 00 	lea    0x9bf9(%rip),%r15        # 8da460 <startup32_check_sev_cbit+0x20>
  8d0867:	4c 8b 5d 40          	mov    0x40(%rbp),%r11
  8d086b:	8b 5d 48             	mov    0x48(%rbp),%ebx
  8d086e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d0873:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  8d0878:	41 89 fd             	mov    %edi,%r13d
  8d087b:	48 89 7c 24 20       	mov    %rdi,0x20(%rsp)
  8d0880:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d0885:	89 04 24             	mov    %eax,(%rsp)
  8d0888:	89 44 24 08          	mov    %eax,0x8(%rsp)
  8d088c:	83 fe 1c             	cmp    $0x1c,%esi
  8d088f:	0f 87 23 01 00 00    	ja     8d09b8 <zlib_inflate+0x1b8>
  8d0895:	89 f0                	mov    %esi,%eax
  8d0897:	49 63 04 87          	movslq (%r15,%rax,4),%rax
  8d089b:	4c 01 f8             	add    %r15,%rax
  8d089e:	3e ff e0             	notrack jmpq *%rax
  8d08a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d08a8:	44 8b 45 08          	mov    0x8(%rbp),%r8d
  8d08ac:	45 85 c0             	test   %r8d,%r8d
  8d08af:	0f 85 b3 0e 00 00    	jne    8d1768 <zlib_inflate+0xf68>
  8d08b5:	c7 45 00 0c 00 00 00 	movl   $0xc,0x0(%rbp)
  8d08bc:	8b 45 04             	mov    0x4(%rbp),%eax
  8d08bf:	85 c0                	test   %eax,%eax
  8d08c1:	0f 84 79 08 00 00    	je     8d1140 <zlib_inflate+0x940>
  8d08c7:	89 d9                	mov    %ebx,%ecx
  8d08c9:	c7 45 00 18 00 00 00 	movl   $0x18,0x0(%rbp)
  8d08d0:	83 e3 f8             	and    $0xfffffff8,%ebx
  8d08d3:	83 e1 07             	and    $0x7,%ecx
  8d08d6:	49 d3 eb             	shr    %cl,%r11
  8d08d9:	44 8b 55 08          	mov    0x8(%rbp),%r10d
  8d08dd:	45 85 d2             	test   %r10d,%r10d
  8d08e0:	0f 84 15 04 00 00    	je     8d0cfb <zlib_inflate+0x4fb>
  8d08e6:	83 fb 1f             	cmp    $0x1f,%ebx
  8d08e9:	77 3a                	ja     8d0925 <zlib_inflate+0x125>
  8d08eb:	89 d9                	mov    %ebx,%ecx
  8d08ed:	45 85 ed             	test   %r13d,%r13d
  8d08f0:	75 17                	jne    8d0909 <zlib_inflate+0x109>
  8d08f2:	e9 db 09 00 00       	jmpq   8d12d2 <zlib_inflate+0xad2>
  8d08f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d08fe:	00 00 
  8d0900:	45 85 ed             	test   %r13d,%r13d
  8d0903:	0f 84 c7 09 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0909:	41 0f b6 06          	movzbl (%r14),%eax
  8d090d:	49 83 c6 01          	add    $0x1,%r14
  8d0911:	41 83 ed 01          	sub    $0x1,%r13d
  8d0915:	48 d3 e0             	shl    %cl,%rax
  8d0918:	83 c1 08             	add    $0x8,%ecx
  8d091b:	49 01 c3             	add    %rax,%r11
  8d091e:	83 f9 1f             	cmp    $0x1f,%ecx
  8d0921:	76 dd                	jbe    8d0900 <zlib_inflate+0x100>
  8d0923:	89 cb                	mov    %ecx,%ebx
  8d0925:	8b 74 24 18          	mov    0x18(%rsp),%esi
  8d0929:	2b 74 24 08          	sub    0x8(%rsp),%esi
  8d092d:	89 f0                	mov    %esi,%eax
  8d092f:	89 74 24 40          	mov    %esi,0x40(%rsp)
  8d0933:	49 01 44 24 28       	add    %rax,0x28(%r12)
  8d0938:	48 01 45 20          	add    %rax,0x20(%rbp)
  8d093c:	85 f6                	test   %esi,%esi
  8d093e:	0f 85 b2 0f 00 00    	jne    8d18f6 <zlib_inflate+0x10f6>
  8d0944:	4c 89 d8             	mov    %r11,%rax
  8d0947:	4c 89 da             	mov    %r11,%rdx
  8d094a:	4c 89 d9             	mov    %r11,%rcx
  8d094d:	48 c1 e8 18          	shr    $0x18,%rax
  8d0951:	48 c1 ea 08          	shr    $0x8,%rdx
  8d0955:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8d095b:	0f b6 c0             	movzbl %al,%eax
  8d095e:	48 c1 e1 18          	shl    $0x18,%rcx
  8d0962:	48 09 d0             	or     %rdx,%rax
  8d0965:	4c 89 da             	mov    %r11,%rdx
  8d0968:	89 c9                	mov    %ecx,%ecx
  8d096a:	48 c1 e2 08          	shl    $0x8,%rdx
  8d096e:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8d0974:	48 01 ca             	add    %rcx,%rdx
  8d0977:	48 01 d0             	add    %rdx,%rax
  8d097a:	48 3b 45 18          	cmp    0x18(%rbp),%rax
  8d097e:	0f 84 6b 03 00 00    	je     8d0cef <zlib_inflate+0x4ef>
  8d0984:	48 8d 05 30 a9 00 00 	lea    0xa930(%rip),%rax        # 8db2bb <kernel_info_end+0x12b>
  8d098b:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d0990:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d0994:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d099b:	89 04 24             	mov    %eax,(%rsp)
  8d099e:	e9 78 05 00 00       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d09a3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d09a8:	48 83 7f 08 00       	cmpq   $0x0,0x8(%rdi)
  8d09ad:	0f 84 8b fe ff ff    	je     8d083e <zlib_inflate+0x3e>
  8d09b3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d09b8:	c7 44 24 18 fe ff ff 	movl   $0xfffffffe,0x18(%rsp)
  8d09bf:	ff 
  8d09c0:	8b 44 24 18          	mov    0x18(%rsp),%eax
  8d09c4:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  8d09cb:	5b                   	pop    %rbx
  8d09cc:	5d                   	pop    %rbp
  8d09cd:	41 5c                	pop    %r12
  8d09cf:	41 5d                	pop    %r13
  8d09d1:	41 5e                	pop    %r14
  8d09d3:	41 5f                	pop    %r15
  8d09d5:	c3                   	retq   
  8d09d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d09dd:	00 00 00 
  8d09e0:	8b 4d 68             	mov    0x68(%rbp),%ecx
  8d09e3:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8d09e9:	48 8b 7d 58          	mov    0x58(%rbp),%rdi
  8d09ed:	41 d3 e0             	shl    %cl,%r8d
  8d09f0:	41 f7 d0             	not    %r8d
  8d09f3:	44 89 c0             	mov    %r8d,%eax
  8d09f6:	44 21 d8             	and    %r11d,%eax
  8d09f9:	48 8d 14 87          	lea    (%rdi,%rax,4),%rdx
  8d09fd:	0f b6 4a 01          	movzbl 0x1(%rdx),%ecx
  8d0a01:	0f b6 02             	movzbl (%rdx),%eax
  8d0a04:	0f b7 72 02          	movzwl 0x2(%rdx),%esi
  8d0a08:	0f b6 d1             	movzbl %cl,%edx
  8d0a0b:	39 da                	cmp    %ebx,%edx
  8d0a0d:	76 52                	jbe    8d0a61 <zlib_inflate+0x261>
  8d0a0f:	45 85 ed             	test   %r13d,%r13d
  8d0a12:	0f 84 a4 0e 00 00    	je     8d18bc <zlib_inflate+0x10bc>
  8d0a18:	89 d9                	mov    %ebx,%ecx
  8d0a1a:	eb 0d                	jmp    8d0a29 <zlib_inflate+0x229>
  8d0a1c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d0a20:	45 85 ed             	test   %r13d,%r13d
  8d0a23:	0f 84 91 0e 00 00    	je     8d18ba <zlib_inflate+0x10ba>
  8d0a29:	41 0f b6 06          	movzbl (%r14),%eax
  8d0a2d:	49 83 c6 01          	add    $0x1,%r14
  8d0a31:	41 83 ed 01          	sub    $0x1,%r13d
  8d0a35:	48 d3 e0             	shl    %cl,%rax
  8d0a38:	83 c1 08             	add    $0x8,%ecx
  8d0a3b:	49 01 c3             	add    %rax,%r11
  8d0a3e:	44 89 c0             	mov    %r8d,%eax
  8d0a41:	44 21 d8             	and    %r11d,%eax
  8d0a44:	48 8d 14 87          	lea    (%rdi,%rax,4),%rdx
  8d0a48:	44 0f b6 52 01       	movzbl 0x1(%rdx),%r10d
  8d0a4d:	0f b6 02             	movzbl (%rdx),%eax
  8d0a50:	0f b7 72 02          	movzwl 0x2(%rdx),%esi
  8d0a54:	41 0f b6 d2          	movzbl %r10b,%edx
  8d0a58:	39 ca                	cmp    %ecx,%edx
  8d0a5a:	77 c4                	ja     8d0a20 <zlib_inflate+0x220>
  8d0a5c:	89 cb                	mov    %ecx,%ebx
  8d0a5e:	44 89 d1             	mov    %r10d,%ecx
  8d0a61:	84 c0                	test   %al,%al
  8d0a63:	0f 84 24 06 00 00    	je     8d108d <zlib_inflate+0x88d>
  8d0a69:	a8 f0                	test   $0xf0,%al
  8d0a6b:	0f 84 7a 13 00 00    	je     8d1deb <zlib_inflate+0x15eb>
  8d0a71:	89 75 4c             	mov    %esi,0x4c(%rbp)
  8d0a74:	89 d1                	mov    %edx,%ecx
  8d0a76:	29 d3                	sub    %edx,%ebx
  8d0a78:	49 d3 eb             	shr    %cl,%r11
  8d0a7b:	a8 20                	test   $0x20,%al
  8d0a7d:	0f 84 e3 12 00 00    	je     8d1d66 <zlib_inflate+0x1566>
  8d0a83:	c7 45 00 0b 00 00 00 	movl   $0xb,0x0(%rbp)
  8d0a8a:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d0a8f:	83 7c 24 34 06       	cmpl   $0x6,0x34(%rsp)
  8d0a94:	0f 85 22 fe ff ff    	jne    8d08bc <zlib_inflate+0xbc>
  8d0a9a:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  8d0a9f:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d0aa3:	44 89 e8             	mov    %r13d,%eax
  8d0aa6:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d0aad:	00 
  8d0aae:	e9 6d 02 00 00       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d0ab3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d0ab8:	8b 45 54             	mov    0x54(%rbp),%eax
  8d0abb:	85 c0                	test   %eax,%eax
  8d0abd:	74 4b                	je     8d0b0a <zlib_inflate+0x30a>
  8d0abf:	39 c3                	cmp    %eax,%ebx
  8d0ac1:	73 31                	jae    8d0af4 <zlib_inflate+0x2f4>
  8d0ac3:	45 85 ed             	test   %r13d,%r13d
  8d0ac6:	0f 84 06 08 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d0acc:	89 d9                	mov    %ebx,%ecx
  8d0ace:	eb 09                	jmp    8d0ad9 <zlib_inflate+0x2d9>
  8d0ad0:	45 85 ed             	test   %r13d,%r13d
  8d0ad3:	0f 84 f7 07 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0ad9:	41 0f b6 16          	movzbl (%r14),%edx
  8d0add:	49 83 c6 01          	add    $0x1,%r14
  8d0ae1:	41 83 ed 01          	sub    $0x1,%r13d
  8d0ae5:	48 d3 e2             	shl    %cl,%rdx
  8d0ae8:	83 c1 08             	add    $0x8,%ecx
  8d0aeb:	49 01 d3             	add    %rdx,%r11
  8d0aee:	39 c1                	cmp    %eax,%ecx
  8d0af0:	72 de                	jb     8d0ad0 <zlib_inflate+0x2d0>
  8d0af2:	89 cb                	mov    %ecx,%ebx
  8d0af4:	89 c1                	mov    %eax,%ecx
  8d0af6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8d0afb:	29 c3                	sub    %eax,%ebx
  8d0afd:	d3 e2                	shl    %cl,%edx
  8d0aff:	f7 d2                	not    %edx
  8d0b01:	44 21 da             	and    %r11d,%edx
  8d0b04:	01 55 4c             	add    %edx,0x4c(%rbp)
  8d0b07:	49 d3 eb             	shr    %cl,%r11
  8d0b0a:	c7 45 00 14 00 00 00 	movl   $0x14,0x0(%rbp)
  8d0b11:	8b 4d 6c             	mov    0x6c(%rbp),%ecx
  8d0b14:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  8d0b1a:	48 8b 7d 60          	mov    0x60(%rbp),%rdi
  8d0b1e:	41 d3 e2             	shl    %cl,%r10d
  8d0b21:	41 f7 d2             	not    %r10d
  8d0b24:	44 89 d0             	mov    %r10d,%eax
  8d0b27:	44 21 d8             	and    %r11d,%eax
  8d0b2a:	48 8d 04 87          	lea    (%rdi,%rax,4),%rax
  8d0b2e:	0f b6 50 01          	movzbl 0x1(%rax),%edx
  8d0b32:	0f b6 30             	movzbl (%rax),%esi
  8d0b35:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
  8d0b3a:	0f b6 c2             	movzbl %dl,%eax
  8d0b3d:	41 89 c1             	mov    %eax,%r9d
  8d0b40:	39 c3                	cmp    %eax,%ebx
  8d0b42:	73 54                	jae    8d0b98 <zlib_inflate+0x398>
  8d0b44:	45 85 ed             	test   %r13d,%r13d
  8d0b47:	0f 84 85 07 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d0b4d:	89 d9                	mov    %ebx,%ecx
  8d0b4f:	eb 10                	jmp    8d0b61 <zlib_inflate+0x361>
  8d0b51:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d0b58:	45 85 ed             	test   %r13d,%r13d
  8d0b5b:	0f 84 6f 07 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0b61:	41 0f b6 06          	movzbl (%r14),%eax
  8d0b65:	49 83 c6 01          	add    $0x1,%r14
  8d0b69:	41 83 ed 01          	sub    $0x1,%r13d
  8d0b6d:	48 d3 e0             	shl    %cl,%rax
  8d0b70:	83 c1 08             	add    $0x8,%ecx
  8d0b73:	49 01 c3             	add    %rax,%r11
  8d0b76:	44 89 d0             	mov    %r10d,%eax
  8d0b79:	44 21 d8             	and    %r11d,%eax
  8d0b7c:	48 8d 04 87          	lea    (%rdi,%rax,4),%rax
  8d0b80:	0f b6 50 01          	movzbl 0x1(%rax),%edx
  8d0b84:	0f b6 30             	movzbl (%rax),%esi
  8d0b87:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
  8d0b8c:	0f b6 c2             	movzbl %dl,%eax
  8d0b8f:	41 89 c1             	mov    %eax,%r9d
  8d0b92:	39 c8                	cmp    %ecx,%eax
  8d0b94:	77 c2                	ja     8d0b58 <zlib_inflate+0x358>
  8d0b96:	89 cb                	mov    %ecx,%ebx
  8d0b98:	41 89 c2             	mov    %eax,%r10d
  8d0b9b:	40 f6 c6 f0          	test   $0xf0,%sil
  8d0b9f:	0f 84 6b 0c 00 00    	je     8d1810 <zlib_inflate+0x1010>
  8d0ba5:	89 c1                	mov    %eax,%ecx
  8d0ba7:	29 c3                	sub    %eax,%ebx
  8d0ba9:	49 d3 eb             	shr    %cl,%r11
  8d0bac:	40 f6 c6 40          	test   $0x40,%sil
  8d0bb0:	0f 84 1a 0b 00 00    	je     8d16d0 <zlib_inflate+0xed0>
  8d0bb6:	48 8d 05 f1 a5 00 00 	lea    0xa5f1(%rip),%rax        # 8db1ae <kernel_info_end+0x1e>
  8d0bbd:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d0bc2:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d0bc9:	e9 4d 03 00 00       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d0bce:	66 90                	xchg   %ax,%ax
  8d0bd0:	83 fb 1f             	cmp    $0x1f,%ebx
  8d0bd3:	77 36                	ja     8d0c0b <zlib_inflate+0x40b>
  8d0bd5:	45 85 ed             	test   %r13d,%r13d
  8d0bd8:	0f 84 f4 06 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d0bde:	89 d9                	mov    %ebx,%ecx
  8d0be0:	eb 0f                	jmp    8d0bf1 <zlib_inflate+0x3f1>
  8d0be2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d0be8:	45 85 ed             	test   %r13d,%r13d
  8d0beb:	0f 84 df 06 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0bf1:	41 0f b6 06          	movzbl (%r14),%eax
  8d0bf5:	49 83 c6 01          	add    $0x1,%r14
  8d0bf9:	41 83 ed 01          	sub    $0x1,%r13d
  8d0bfd:	48 d3 e0             	shl    %cl,%rax
  8d0c00:	83 c1 08             	add    $0x8,%ecx
  8d0c03:	49 01 c3             	add    %rax,%r11
  8d0c06:	83 f9 1f             	cmp    $0x1f,%ecx
  8d0c09:	76 dd                	jbe    8d0be8 <zlib_inflate+0x3e8>
  8d0c0b:	4c 89 d8             	mov    %r11,%rax
  8d0c0e:	4c 89 da             	mov    %r11,%rdx
  8d0c11:	31 db                	xor    %ebx,%ebx
  8d0c13:	48 c1 e8 18          	shr    $0x18,%rax
  8d0c17:	48 c1 ea 08          	shr    $0x8,%rdx
  8d0c1b:	81 e2 00 ff 00 00    	and    $0xff00,%edx
  8d0c21:	0f b6 c0             	movzbl %al,%eax
  8d0c24:	48 09 d0             	or     %rdx,%rax
  8d0c27:	4c 89 da             	mov    %r11,%rdx
  8d0c2a:	49 c1 e3 18          	shl    $0x18,%r11
  8d0c2e:	48 c1 e2 08          	shl    $0x8,%rdx
  8d0c32:	45 89 db             	mov    %r11d,%r11d
  8d0c35:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8d0c3b:	4c 01 da             	add    %r11,%rdx
  8d0c3e:	45 31 db             	xor    %r11d,%r11d
  8d0c41:	48 01 d0             	add    %rdx,%rax
  8d0c44:	48 89 45 18          	mov    %rax,0x18(%rbp)
  8d0c48:	49 89 44 24 50       	mov    %rax,0x50(%r12)
  8d0c4d:	c7 45 00 0a 00 00 00 	movl   $0xa,0x0(%rbp)
  8d0c54:	8b 7d 0c             	mov    0xc(%rbp),%edi
  8d0c57:	85 ff                	test   %edi,%edi
  8d0c59:	0f 84 51 12 00 00    	je     8d1eb0 <zlib_inflate+0x16b0>
  8d0c5f:	48 c7 45 18 01 00 00 	movq   $0x1,0x18(%rbp)
  8d0c66:	00 
  8d0c67:	49 c7 44 24 50 01 00 	movq   $0x1,0x50(%r12)
  8d0c6e:	00 00 
  8d0c70:	83 7c 24 34 06       	cmpl   $0x6,0x34(%rsp)
  8d0c75:	c7 45 00 0b 00 00 00 	movl   $0xb,0x0(%rbp)
  8d0c7c:	0f 85 3a fc ff ff    	jne    8d08bc <zlib_inflate+0xbc>
  8d0c82:	e9 13 fe ff ff       	jmpq   8d0a9a <zlib_inflate+0x29a>
  8d0c87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d0c8e:	00 00 
  8d0c90:	c7 45 00 16 00 00 00 	movl   $0x16,0x0(%rbp)
  8d0c97:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d0c9b:	85 c0                	test   %eax,%eax
  8d0c9d:	0f 84 16 11 00 00    	je     8d1db9 <zlib_inflate+0x15b9>
  8d0ca3:	44 8b 14 24          	mov    (%rsp),%r10d
  8d0ca7:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  8d0cab:	8b 45 50             	mov    0x50(%rbp),%eax
  8d0cae:	8b 4d 4c             	mov    0x4c(%rbp),%ecx
  8d0cb1:	44 89 d2             	mov    %r10d,%edx
  8d0cb4:	29 fa                	sub    %edi,%edx
  8d0cb6:	39 d0                	cmp    %edx,%eax
  8d0cb8:	0f 86 ea 08 00 00    	jbe    8d15a8 <zlib_inflate+0xda8>
  8d0cbe:	8d 14 38             	lea    (%rax,%rdi,1),%edx
  8d0cc1:	8b 7d 34             	mov    0x34(%rbp),%edi
  8d0cc4:	48 8b 75 38          	mov    0x38(%rbp),%rsi
  8d0cc8:	89 d0                	mov    %edx,%eax
  8d0cca:	44 29 d0             	sub    %r10d,%eax
  8d0ccd:	41 29 d2             	sub    %edx,%r10d
  8d0cd0:	44 89 d2             	mov    %r10d,%edx
  8d0cd3:	39 c7                	cmp    %eax,%edi
  8d0cd5:	0f 83 15 0a 00 00    	jae    8d16f0 <zlib_inflate+0xef0>
  8d0cdb:	29 f8                	sub    %edi,%eax
  8d0cdd:	03 7d 2c             	add    0x2c(%rbp),%edi
  8d0ce0:	01 fa                	add    %edi,%edx
  8d0ce2:	48 01 d6             	add    %rdx,%rsi
  8d0ce5:	39 c8                	cmp    %ecx,%eax
  8d0ce7:	0f 47 c1             	cmova  %ecx,%eax
  8d0cea:	e9 c3 08 00 00       	jmpq   8d15b2 <zlib_inflate+0xdb2>
  8d0cef:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d0cf3:	31 db                	xor    %ebx,%ebx
  8d0cf5:	45 31 db             	xor    %r11d,%r11d
  8d0cf8:	89 04 24             	mov    %eax,(%rsp)
  8d0cfb:	c7 45 00 1a 00 00 00 	movl   $0x1a,0x0(%rbp)
  8d0d02:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d0d08:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  8d0d0d:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d0d11:	44 89 e8             	mov    %r13d,%eax
  8d0d14:	c7 44 24 18 01 00 00 	movl   $0x1,0x18(%rsp)
  8d0d1b:	00 
  8d0d1c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d0d20:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d0d25:	49 89 54 24 20       	mov    %rdx,0x20(%r12)
  8d0d2a:	4d 89 34 24          	mov    %r14,(%r12)
  8d0d2e:	49 89 74 24 18       	mov    %rsi,0x18(%r12)
  8d0d33:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  8d0d38:	44 8b 45 2c          	mov    0x2c(%rbp),%r8d
  8d0d3c:	4c 89 5d 40          	mov    %r11,0x40(%rbp)
  8d0d40:	89 5d 48             	mov    %ebx,0x48(%rbp)
  8d0d43:	45 85 c0             	test   %r8d,%r8d
  8d0d46:	75 13                	jne    8d0d5b <zlib_inflate+0x55b>
  8d0d48:	83 7d 00 17          	cmpl   $0x17,0x0(%rbp)
  8d0d4c:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  8d0d51:	77 18                	ja     8d0d6b <zlib_inflate+0x56b>
  8d0d53:	8b 14 24             	mov    (%rsp),%edx
  8d0d56:	48 39 c2             	cmp    %rax,%rdx
  8d0d59:	74 10                	je     8d0d6b <zlib_inflate+0x56b>
  8d0d5b:	8b 34 24             	mov    (%rsp),%esi
  8d0d5e:	4c 89 e7             	mov    %r12,%rdi
  8d0d61:	e8 fa ec ff ff       	callq  8cfa60 <zlib_updatewindow>
  8d0d66:	49 8b 44 24 20       	mov    0x20(%r12),%rax
  8d0d6b:	8b 34 24             	mov    (%rsp),%esi
  8d0d6e:	8b 7c 24 20          	mov    0x20(%rsp),%edi
  8d0d72:	41 2b 7c 24 08       	sub    0x8(%r12),%edi
  8d0d77:	29 c6                	sub    %eax,%esi
  8d0d79:	89 7c 24 70          	mov    %edi,0x70(%rsp)
  8d0d7d:	89 f8                	mov    %edi,%eax
  8d0d7f:	49 01 44 24 10       	add    %rax,0x10(%r12)
  8d0d84:	89 f0                	mov    %esi,%eax
  8d0d86:	49 01 44 24 28       	add    %rax,0x28(%r12)
  8d0d8b:	8b 7d 08             	mov    0x8(%rbp),%edi
  8d0d8e:	48 01 45 20          	add    %rax,0x20(%rbp)
  8d0d92:	89 74 24 38          	mov    %esi,0x38(%rsp)
  8d0d96:	85 ff                	test   %edi,%edi
  8d0d98:	74 08                	je     8d0da2 <zlib_inflate+0x5a2>
  8d0d9a:	85 f6                	test   %esi,%esi
  8d0d9c:	0f 85 7e 05 00 00    	jne    8d1320 <zlib_inflate+0xb20>
  8d0da2:	8b 4d 04             	mov    0x4(%rbp),%ecx
  8d0da5:	8b 45 48             	mov    0x48(%rbp),%eax
  8d0da8:	85 c9                	test   %ecx,%ecx
  8d0daa:	74 03                	je     8d0daf <zlib_inflate+0x5af>
  8d0dac:	83 c0 40             	add    $0x40,%eax
  8d0daf:	83 7d 00 0b          	cmpl   $0xb,0x0(%rbp)
  8d0db3:	8d 90 80 00 00 00    	lea    0x80(%rax),%edx
  8d0db9:	0f 44 c2             	cmove  %edx,%eax
  8d0dbc:	80 7c 24 50 00       	cmpb   $0x0,0x50(%rsp)
  8d0dc1:	41 89 44 24 48       	mov    %eax,0x48(%r12)
  8d0dc6:	0f 84 24 05 00 00    	je     8d12f0 <zlib_inflate+0xaf0>
  8d0dcc:	49 83 7c 24 20 00    	cmpq   $0x0,0x20(%r12)
  8d0dd2:	74 0c                	je     8d0de0 <zlib_inflate+0x5e0>
  8d0dd4:	49 83 7c 24 08 00    	cmpq   $0x0,0x8(%r12)
  8d0dda:	0f 84 90 07 00 00    	je     8d1570 <zlib_inflate+0xd70>
  8d0de0:	8b 44 24 70          	mov    0x70(%rsp),%eax
  8d0de4:	0b 44 24 38          	or     0x38(%rsp),%eax
  8d0de8:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
  8d0ded:	0f 45 44 24 18       	cmovne 0x18(%rsp),%eax
  8d0df2:	89 44 24 18          	mov    %eax,0x18(%rsp)
  8d0df6:	e9 c5 fb ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d0dfb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d0e00:	8b 45 4c             	mov    0x4c(%rbp),%eax
  8d0e03:	85 c0                	test   %eax,%eax
  8d0e05:	0f 84 65 fe ff ff    	je     8d0c70 <zlib_inflate+0x470>
  8d0e0b:	41 39 c5             	cmp    %eax,%r13d
  8d0e0e:	8b 74 24 08          	mov    0x8(%rsp),%esi
  8d0e12:	41 0f 46 c5          	cmovbe %r13d,%eax
  8d0e16:	39 f0                	cmp    %esi,%eax
  8d0e18:	0f 47 c6             	cmova  %esi,%eax
  8d0e1b:	85 c0                	test   %eax,%eax
  8d0e1d:	0f 84 0e 11 00 00    	je     8d1f31 <zlib_inflate+0x1731>
  8d0e23:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d0e28:	89 c2                	mov    %eax,%edx
  8d0e2a:	4c 89 f6             	mov    %r14,%rsi
  8d0e2d:	4c 89 5c 24 40       	mov    %r11,0x40(%rsp)
  8d0e32:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  8d0e37:	89 44 24 38          	mov    %eax,0x38(%rsp)
  8d0e3b:	e8 b0 22 00 00       	callq  8d30f0 <memcpy>
  8d0e40:	8b 4c 24 38          	mov    0x38(%rsp),%ecx
  8d0e44:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d0e49:	29 4c 24 08          	sub    %ecx,0x8(%rsp)
  8d0e4d:	8b 75 00             	mov    0x0(%rbp),%esi
  8d0e50:	48 01 54 24 10       	add    %rdx,0x10(%rsp)
  8d0e55:	4c 8b 5c 24 40       	mov    0x40(%rsp),%r11
  8d0e5a:	41 29 cd             	sub    %ecx,%r13d
  8d0e5d:	49 01 d6             	add    %rdx,%r14
  8d0e60:	29 4d 4c             	sub    %ecx,0x4c(%rbp)
  8d0e63:	e9 24 fa ff ff       	jmpq   8d088c <zlib_inflate+0x8c>
  8d0e68:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d0e6f:	00 
  8d0e70:	8b 75 7c             	mov    0x7c(%rbp),%esi
  8d0e73:	8b 7d 70             	mov    0x70(%rbp),%edi
  8d0e76:	89 d9                	mov    %ebx,%ecx
  8d0e78:	39 fe                	cmp    %edi,%esi
  8d0e7a:	0f 83 7f 0d 00 00    	jae    8d1bff <zlib_inflate+0x13ff>
  8d0e80:	83 f9 02             	cmp    $0x2,%ecx
  8d0e83:	77 58                	ja     8d0edd <zlib_inflate+0x6dd>
  8d0e85:	45 85 ed             	test   %r13d,%r13d
  8d0e88:	0f 84 42 04 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0e8e:	41 0f b6 06          	movzbl (%r14),%eax
  8d0e92:	41 83 ed 01          	sub    $0x1,%r13d
  8d0e96:	49 8d 56 01          	lea    0x1(%r14),%rdx
  8d0e9a:	48 d3 e0             	shl    %cl,%rax
  8d0e9d:	83 c1 08             	add    $0x8,%ecx
  8d0ea0:	49 01 c3             	add    %rax,%r11
  8d0ea3:	48 8d 1d 56 9f 00 00 	lea    0x9f56(%rip),%rbx        # 8dae00 <order.30813>
  8d0eaa:	8d 46 01             	lea    0x1(%rsi),%eax
  8d0ead:	45 89 d8             	mov    %r11d,%r8d
  8d0eb0:	83 e9 03             	sub    $0x3,%ecx
  8d0eb3:	0f b7 34 73          	movzwl (%rbx,%rsi,2),%esi
  8d0eb7:	41 83 e0 07          	and    $0x7,%r8d
  8d0ebb:	89 45 7c             	mov    %eax,0x7c(%rbp)
  8d0ebe:	49 c1 eb 03          	shr    $0x3,%r11
  8d0ec2:	66 44 89 84 75 88 00 	mov    %r8w,0x88(%rbp,%rsi,2)
  8d0ec9:	00 00 
  8d0ecb:	39 f8                	cmp    %edi,%eax
  8d0ecd:	0f 83 25 0d 00 00    	jae    8d1bf8 <zlib_inflate+0x13f8>
  8d0ed3:	49 89 d6             	mov    %rdx,%r14
  8d0ed6:	89 c6                	mov    %eax,%esi
  8d0ed8:	83 f9 02             	cmp    $0x2,%ecx
  8d0edb:	76 a8                	jbe    8d0e85 <zlib_inflate+0x685>
  8d0edd:	4c 89 f2             	mov    %r14,%rdx
  8d0ee0:	eb c1                	jmp    8d0ea3 <zlib_inflate+0x6a3>
  8d0ee2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d0ee8:	8b 75 54             	mov    0x54(%rbp),%esi
  8d0eeb:	85 f6                	test   %esi,%esi
  8d0eed:	0f 85 15 08 00 00    	jne    8d1708 <zlib_inflate+0xf08>
  8d0ef3:	8b 55 50             	mov    0x50(%rbp),%edx
  8d0ef6:	8b 04 24             	mov    (%rsp),%eax
  8d0ef9:	03 45 30             	add    0x30(%rbp),%eax
  8d0efc:	2b 44 24 08          	sub    0x8(%rsp),%eax
  8d0f00:	39 d0                	cmp    %edx,%eax
  8d0f02:	0f 83 88 fd ff ff    	jae    8d0c90 <zlib_inflate+0x490>
  8d0f08:	48 8d 05 81 a2 00 00 	lea    0xa281(%rip),%rax        # 8db190 <kernel_info_end>
  8d0f0f:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d0f14:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d0f1b:	c6 44 24 50 00       	movb   $0x0,0x50(%rsp)
  8d0f20:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d0f24:	44 89 e8             	mov    %r13d,%eax
  8d0f27:	c7 44 24 18 fd ff ff 	movl   $0xfffffffd,0x18(%rsp)
  8d0f2e:	ff 
  8d0f2f:	e9 ec fd ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d0f34:	0f 1f 40 00          	nopl   0x0(%rax)
  8d0f38:	44 8b 45 7c          	mov    0x7c(%rbp),%r8d
  8d0f3c:	8b 45 74             	mov    0x74(%rbp),%eax
  8d0f3f:	44 8b 4d 78          	mov    0x78(%rbp),%r9d
  8d0f43:	41 01 c1             	add    %eax,%r9d
  8d0f46:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8d0f4a:	45 39 c1             	cmp    %r8d,%r9d
  8d0f4d:	0f 86 e6 06 00 00    	jbe    8d1639 <zlib_inflate+0xe39>
  8d0f53:	8b 4d 68             	mov    0x68(%rbp),%ecx
  8d0f56:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8d0f5b:	48 8b 75 58          	mov    0x58(%rbp),%rsi
  8d0f5f:	d3 e2                	shl    %cl,%edx
  8d0f61:	f7 d2                	not    %edx
  8d0f63:	89 d0                	mov    %edx,%eax
  8d0f65:	44 21 d8             	and    %r11d,%eax
  8d0f68:	48 8d 04 86          	lea    (%rsi,%rax,4),%rax
  8d0f6c:	0f b6 48 01          	movzbl 0x1(%rax),%ecx
  8d0f70:	0f b7 78 02          	movzwl 0x2(%rax),%edi
  8d0f74:	0f b6 c1             	movzbl %cl,%eax
  8d0f77:	39 c3                	cmp    %eax,%ebx
  8d0f79:	73 52                	jae    8d0fcd <zlib_inflate+0x7cd>
  8d0f7b:	45 85 ed             	test   %r13d,%r13d
  8d0f7e:	0f 84 4e 03 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d0f84:	89 d9                	mov    %ebx,%ecx
  8d0f86:	eb 11                	jmp    8d0f99 <zlib_inflate+0x799>
  8d0f88:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d0f8f:	00 
  8d0f90:	45 85 ed             	test   %r13d,%r13d
  8d0f93:	0f 84 37 03 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d0f99:	41 0f b6 06          	movzbl (%r14),%eax
  8d0f9d:	49 83 c6 01          	add    $0x1,%r14
  8d0fa1:	41 83 ed 01          	sub    $0x1,%r13d
  8d0fa5:	48 d3 e0             	shl    %cl,%rax
  8d0fa8:	83 c1 08             	add    $0x8,%ecx
  8d0fab:	49 01 c3             	add    %rax,%r11
  8d0fae:	89 d0                	mov    %edx,%eax
  8d0fb0:	44 21 d8             	and    %r11d,%eax
  8d0fb3:	48 8d 04 86          	lea    (%rsi,%rax,4),%rax
  8d0fb7:	44 0f b6 50 01       	movzbl 0x1(%rax),%r10d
  8d0fbc:	0f b7 78 02          	movzwl 0x2(%rax),%edi
  8d0fc0:	41 0f b6 c2          	movzbl %r10b,%eax
  8d0fc4:	39 c8                	cmp    %ecx,%eax
  8d0fc6:	77 c8                	ja     8d0f90 <zlib_inflate+0x790>
  8d0fc8:	89 cb                	mov    %ecx,%ebx
  8d0fca:	44 89 d1             	mov    %r10d,%ecx
  8d0fcd:	66 83 ff 0f          	cmp    $0xf,%di
  8d0fd1:	0f 86 41 06 00 00    	jbe    8d1618 <zlib_inflate+0xe18>
  8d0fd7:	66 83 ff 10          	cmp    $0x10,%di
  8d0fdb:	0f 84 12 0d 00 00    	je     8d1cf3 <zlib_inflate+0x14f3>
  8d0fe1:	66 83 ff 11          	cmp    $0x11,%di
  8d0fe5:	0f 84 4e 0b 00 00    	je     8d1b39 <zlib_inflate+0x1339>
  8d0feb:	44 8d 50 07          	lea    0x7(%rax),%r10d
  8d0fef:	44 39 d3             	cmp    %r10d,%ebx
  8d0ff2:	73 39                	jae    8d102d <zlib_inflate+0x82d>
  8d0ff4:	45 85 ed             	test   %r13d,%r13d
  8d0ff7:	0f 84 d5 02 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d0ffd:	89 d9                	mov    %ebx,%ecx
  8d0fff:	eb 10                	jmp    8d1011 <zlib_inflate+0x811>
  8d1001:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1008:	45 85 ed             	test   %r13d,%r13d
  8d100b:	0f 84 bf 02 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d1011:	41 0f b6 3e          	movzbl (%r14),%edi
  8d1015:	49 83 c6 01          	add    $0x1,%r14
  8d1019:	41 83 ed 01          	sub    $0x1,%r13d
  8d101d:	48 d3 e7             	shl    %cl,%rdi
  8d1020:	83 c1 08             	add    $0x8,%ecx
  8d1023:	49 01 fb             	add    %rdi,%r11
  8d1026:	44 39 d1             	cmp    %r10d,%ecx
  8d1029:	72 dd                	jb     8d1008 <zlib_inflate+0x808>
  8d102b:	89 cb                	mov    %ecx,%ebx
  8d102d:	89 c1                	mov    %eax,%ecx
  8d102f:	bf f9 ff ff ff       	mov    $0xfffffff9,%edi
  8d1034:	49 d3 eb             	shr    %cl,%r11
  8d1037:	29 c7                	sub    %eax,%edi
  8d1039:	44 89 d9             	mov    %r11d,%ecx
  8d103c:	01 fb                	add    %edi,%ebx
  8d103e:	49 c1 eb 07          	shr    $0x7,%r11
  8d1042:	31 ff                	xor    %edi,%edi
  8d1044:	83 e1 7f             	and    $0x7f,%ecx
  8d1047:	83 c1 0b             	add    $0xb,%ecx
  8d104a:	41 01 c8             	add    %ecx,%r8d
  8d104d:	45 39 c8             	cmp    %r9d,%r8d
  8d1050:	0f 87 90 0f 00 00    	ja     8d1fe6 <zlib_inflate+0x17e6>
  8d1056:	8b 45 7c             	mov    0x7c(%rbp),%eax
  8d1059:	44 8d 04 01          	lea    (%rcx,%rax,1),%r8d
  8d105d:	0f 1f 00             	nopl   (%rax)
  8d1060:	89 c1                	mov    %eax,%ecx
  8d1062:	83 c0 01             	add    $0x1,%eax
  8d1065:	66 89 bc 4d 88 00 00 	mov    %di,0x88(%rbp,%rcx,2)
  8d106c:	00 
  8d106d:	41 39 c0             	cmp    %eax,%r8d
  8d1070:	75 ee                	jne    8d1060 <zlib_inflate+0x860>
  8d1072:	44 89 45 7c          	mov    %r8d,0x7c(%rbp)
  8d1076:	e9 b5 05 00 00       	jmpq   8d1630 <zlib_inflate+0xe30>
  8d107b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d1080:	c7 44 24 18 fc ff ff 	movl   $0xfffffffc,0x18(%rsp)
  8d1087:	ff 
  8d1088:	e9 33 f9 ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d108d:	89 75 4c             	mov    %esi,0x4c(%rbp)
  8d1090:	49 d3 eb             	shr    %cl,%r11
  8d1093:	29 d3                	sub    %edx,%ebx
  8d1095:	c7 45 00 17 00 00 00 	movl   $0x17,0x0(%rbp)
  8d109c:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d10a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d10a8:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d10ac:	85 c0                	test   %eax,%eax
  8d10ae:	0f 84 05 0d 00 00    	je     8d1db9 <zlib_inflate+0x15b9>
  8d10b4:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d10b9:	8b 45 4c             	mov    0x4c(%rbp),%eax
  8d10bc:	83 6c 24 08 01       	subl   $0x1,0x8(%rsp)
  8d10c1:	88 06                	mov    %al,(%rsi)
  8d10c3:	4c 8d 4e 01          	lea    0x1(%rsi),%r9
  8d10c7:	c7 45 00 12 00 00 00 	movl   $0x12,0x0(%rbp)
  8d10ce:	41 83 fd 05          	cmp    $0x5,%r13d
  8d10d2:	0f 86 08 f9 ff ff    	jbe    8d09e0 <zlib_inflate+0x1e0>
  8d10d8:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d10dc:	3d 01 01 00 00       	cmp    $0x101,%eax
  8d10e1:	0f 86 f9 f8 ff ff    	jbe    8d09e0 <zlib_inflate+0x1e0>
  8d10e7:	49 89 44 24 20       	mov    %rax,0x20(%r12)
  8d10ec:	44 89 e8             	mov    %r13d,%eax
  8d10ef:	8b 34 24             	mov    (%rsp),%esi
  8d10f2:	4c 89 e7             	mov    %r12,%rdi
  8d10f5:	4d 89 34 24          	mov    %r14,(%r12)
  8d10f9:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  8d10fe:	4d 89 4c 24 18       	mov    %r9,0x18(%r12)
  8d1103:	4c 89 5d 40          	mov    %r11,0x40(%rbp)
  8d1107:	89 5d 48             	mov    %ebx,0x48(%rbp)
  8d110a:	e8 c1 ef ff ff       	callq  8d00d0 <inflate_fast>
  8d110f:	49 8b 44 24 18       	mov    0x18(%r12),%rax
  8d1114:	4d 8b 34 24          	mov    (%r12),%r14
  8d1118:	45 8b 6c 24 08       	mov    0x8(%r12),%r13d
  8d111d:	4c 8b 5d 40          	mov    0x40(%rbp),%r11
  8d1121:	8b 5d 48             	mov    0x48(%rbp),%ebx
  8d1124:	8b 75 00             	mov    0x0(%rbp),%esi
  8d1127:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d112c:	41 8b 44 24 20       	mov    0x20(%r12),%eax
  8d1131:	89 44 24 08          	mov    %eax,0x8(%rsp)
  8d1135:	e9 52 f7 ff ff       	jmpq   8d088c <zlib_inflate+0x8c>
  8d113a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d1140:	83 fb 02             	cmp    $0x2,%ebx
  8d1143:	0f 87 4f 0c 00 00    	ja     8d1d98 <zlib_inflate+0x1598>
  8d1149:	45 85 ed             	test   %r13d,%r13d
  8d114c:	0f 84 4e 0c 00 00    	je     8d1da0 <zlib_inflate+0x15a0>
  8d1152:	41 0f b6 06          	movzbl (%r14),%eax
  8d1156:	89 d9                	mov    %ebx,%ecx
  8d1158:	41 83 ed 01          	sub    $0x1,%r13d
  8d115c:	49 8d 56 01          	lea    0x1(%r14),%rdx
  8d1160:	83 c3 08             	add    $0x8,%ebx
  8d1163:	48 d3 e0             	shl    %cl,%rax
  8d1166:	49 01 c3             	add    %rax,%r11
  8d1169:	44 89 d8             	mov    %r11d,%eax
  8d116c:	83 e0 01             	and    $0x1,%eax
  8d116f:	89 45 04             	mov    %eax,0x4(%rbp)
  8d1172:	4c 89 d8             	mov    %r11,%rax
  8d1175:	48 d1 e8             	shr    %rax
  8d1178:	83 e0 03             	and    $0x3,%eax
  8d117b:	83 f8 02             	cmp    $0x2,%eax
  8d117e:	0f 85 b4 00 00 00    	jne    8d1238 <zlib_inflate+0xa38>
  8d1184:	c7 45 00 0f 00 00 00 	movl   $0xf,0x0(%rbp)
  8d118b:	49 c1 eb 03          	shr    $0x3,%r11
  8d118f:	83 eb 03             	sub    $0x3,%ebx
  8d1192:	49 89 d6             	mov    %rdx,%r14
  8d1195:	83 fb 0d             	cmp    $0xd,%ebx
  8d1198:	77 3b                	ja     8d11d5 <zlib_inflate+0x9d5>
  8d119a:	45 85 ed             	test   %r13d,%r13d
  8d119d:	0f 84 2f 01 00 00    	je     8d12d2 <zlib_inflate+0xad2>
  8d11a3:	89 d9                	mov    %ebx,%ecx
  8d11a5:	eb 12                	jmp    8d11b9 <zlib_inflate+0x9b9>
  8d11a7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d11ae:	00 00 
  8d11b0:	45 85 ed             	test   %r13d,%r13d
  8d11b3:	0f 84 17 01 00 00    	je     8d12d0 <zlib_inflate+0xad0>
  8d11b9:	41 0f b6 06          	movzbl (%r14),%eax
  8d11bd:	49 83 c6 01          	add    $0x1,%r14
  8d11c1:	41 83 ed 01          	sub    $0x1,%r13d
  8d11c5:	48 d3 e0             	shl    %cl,%rax
  8d11c8:	83 c1 08             	add    $0x8,%ecx
  8d11cb:	49 01 c3             	add    %rax,%r11
  8d11ce:	83 f9 0d             	cmp    $0xd,%ecx
  8d11d1:	76 dd                	jbe    8d11b0 <zlib_inflate+0x9b0>
  8d11d3:	89 cb                	mov    %ecx,%ebx
  8d11d5:	4c 89 d8             	mov    %r11,%rax
  8d11d8:	4c 89 df             	mov    %r11,%rdi
  8d11db:	44 89 da             	mov    %r11d,%edx
  8d11de:	83 eb 0e             	sub    $0xe,%ebx
  8d11e1:	48 c1 e8 05          	shr    $0x5,%rax
  8d11e5:	48 c1 ef 0a          	shr    $0xa,%rdi
  8d11e9:	83 e2 1f             	and    $0x1f,%edx
  8d11ec:	83 e0 1f             	and    $0x1f,%eax
  8d11ef:	83 e7 0f             	and    $0xf,%edi
  8d11f2:	81 c2 01 01 00 00    	add    $0x101,%edx
  8d11f8:	49 c1 eb 0e          	shr    $0xe,%r11
  8d11fc:	83 c0 01             	add    $0x1,%eax
  8d11ff:	83 c7 04             	add    $0x4,%edi
  8d1202:	89 55 74             	mov    %edx,0x74(%rbp)
  8d1205:	89 45 78             	mov    %eax,0x78(%rbp)
  8d1208:	89 7d 70             	mov    %edi,0x70(%rbp)
  8d120b:	81 fa 1e 01 00 00    	cmp    $0x11e,%edx
  8d1211:	77 09                	ja     8d121c <zlib_inflate+0xa1c>
  8d1213:	83 f8 1e             	cmp    $0x1e,%eax
  8d1216:	0f 86 99 0a 00 00    	jbe    8d1cb5 <zlib_inflate+0x14b5>
  8d121c:	48 8d 05 dd a1 00 00 	lea    0xa1dd(%rip),%rax        # 8db400 <kernel_info_end+0x270>
  8d1223:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1228:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d122f:	e9 e7 fc ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1234:	0f 1f 40 00          	nopl   0x0(%rax)
  8d1238:	83 f8 03             	cmp    $0x3,%eax
  8d123b:	0f 84 95 09 00 00    	je     8d1bd6 <zlib_inflate+0x13d6>
  8d1241:	83 f8 01             	cmp    $0x1,%eax
  8d1244:	0f 84 4d 09 00 00    	je     8d1b97 <zlib_inflate+0x1397>
  8d124a:	c7 45 00 0d 00 00 00 	movl   $0xd,0x0(%rbp)
  8d1251:	49 c1 eb 03          	shr    $0x3,%r11
  8d1255:	83 eb 03             	sub    $0x3,%ebx
  8d1258:	49 89 d6             	mov    %rdx,%r14
  8d125b:	89 d9                	mov    %ebx,%ecx
  8d125d:	83 e3 f8             	and    $0xfffffff8,%ebx
  8d1260:	83 e1 07             	and    $0x7,%ecx
  8d1263:	49 d3 eb             	shr    %cl,%r11
  8d1266:	83 fb 1f             	cmp    $0x1f,%ebx
  8d1269:	77 2e                	ja     8d1299 <zlib_inflate+0xa99>
  8d126b:	45 85 ed             	test   %r13d,%r13d
  8d126e:	74 62                	je     8d12d2 <zlib_inflate+0xad2>
  8d1270:	89 d9                	mov    %ebx,%ecx
  8d1272:	eb 09                	jmp    8d127d <zlib_inflate+0xa7d>
  8d1274:	0f 1f 40 00          	nopl   0x0(%rax)
  8d1278:	45 85 ed             	test   %r13d,%r13d
  8d127b:	74 53                	je     8d12d0 <zlib_inflate+0xad0>
  8d127d:	41 0f b6 06          	movzbl (%r14),%eax
  8d1281:	49 83 c6 01          	add    $0x1,%r14
  8d1285:	41 83 ed 01          	sub    $0x1,%r13d
  8d1289:	48 d3 e0             	shl    %cl,%rax
  8d128c:	83 c1 08             	add    $0x8,%ecx
  8d128f:	49 01 c3             	add    %rax,%r11
  8d1292:	83 f9 1f             	cmp    $0x1f,%ecx
  8d1295:	76 e1                	jbe    8d1278 <zlib_inflate+0xa78>
  8d1297:	89 cb                	mov    %ecx,%ebx
  8d1299:	4c 89 d8             	mov    %r11,%rax
  8d129c:	41 0f b7 d3          	movzwl %r11w,%edx
  8d12a0:	48 c1 e8 10          	shr    $0x10,%rax
  8d12a4:	48 35 ff ff 00 00    	xor    $0xffff,%rax
  8d12aa:	48 39 c2             	cmp    %rax,%rdx
  8d12ad:	0f 84 2b 06 00 00    	je     8d18de <zlib_inflate+0x10de>
  8d12b3:	48 8d 05 7f 9f 00 00 	lea    0x9f7f(%rip),%rax        # 8db239 <kernel_info_end+0xa9>
  8d12ba:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d12bf:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d12c6:	e9 50 fc ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d12cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d12d0:	89 cb                	mov    %ecx,%ebx
  8d12d2:	83 7c 24 34 02       	cmpl   $0x2,0x34(%rsp)
  8d12d7:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d12db:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d12e2:	00 
  8d12e3:	0f 94 44 24 50       	sete   0x50(%rsp)
  8d12e8:	31 c0                	xor    %eax,%eax
  8d12ea:	e9 31 fa ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d12ef:	90                   	nop
  8d12f0:	8b 44 24 70          	mov    0x70(%rsp),%eax
  8d12f4:	0b 44 24 38          	or     0x38(%rsp),%eax
  8d12f8:	0f 85 5a 02 00 00    	jne    8d1558 <zlib_inflate+0xd58>
  8d12fe:	8b 44 24 18          	mov    0x18(%rsp),%eax
  8d1302:	85 c0                	test   %eax,%eax
  8d1304:	0f 85 b6 f6 ff ff    	jne    8d09c0 <zlib_inflate+0x1c0>
  8d130a:	c7 44 24 18 fb ff ff 	movl   $0xfffffffb,0x18(%rsp)
  8d1311:	ff 
  8d1312:	e9 a9 f6 ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d1317:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d131e:	00 00 
  8d1320:	49 8b 4c 24 18       	mov    0x18(%r12),%rcx
  8d1325:	89 74 24 28          	mov    %esi,0x28(%rsp)
  8d1329:	48 89 6c 24 58       	mov    %rbp,0x58(%rsp)
  8d132e:	48 29 c1             	sub    %rax,%rcx
  8d1331:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8d1335:	4c 89 64 24 60       	mov    %r12,0x60(%rsp)
  8d133a:	49 89 c9             	mov    %rcx,%r9
  8d133d:	44 0f b7 f8          	movzwl %ax,%r15d
  8d1341:	48 c1 e8 10          	shr    $0x10,%rax
  8d1345:	0f b7 f8             	movzwl %ax,%edi
  8d1348:	49 89 f8             	mov    %rdi,%r8
  8d134b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d1350:	8b 5c 24 28          	mov    0x28(%rsp),%ebx
  8d1354:	b8 b0 15 00 00       	mov    $0x15b0,%eax
  8d1359:	81 fb b0 15 00 00    	cmp    $0x15b0,%ebx
  8d135f:	89 da                	mov    %ebx,%edx
  8d1361:	0f 46 c3             	cmovbe %ebx,%eax
  8d1364:	29 c3                	sub    %eax,%ebx
  8d1366:	89 5c 24 28          	mov    %ebx,0x28(%rsp)
  8d136a:	83 fa 0f             	cmp    $0xf,%edx
  8d136d:	0f 86 9d 01 00 00    	jbe    8d1510 <zlib_inflate+0xd10>
  8d1373:	83 e8 10             	sub    $0x10,%eax
  8d1376:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8d137b:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d137f:	c1 e8 04             	shr    $0x4,%eax
  8d1382:	89 44 24 40          	mov    %eax,0x40(%rsp)
  8d1386:	48 83 c0 01          	add    $0x1,%rax
  8d138a:	48 c1 e0 04          	shl    $0x4,%rax
  8d138e:	4c 01 c8             	add    %r9,%rax
  8d1391:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d1396:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d139d:	00 00 00 
  8d13a0:	41 0f b6 01          	movzbl (%r9),%eax
  8d13a4:	45 0f b6 71 02       	movzbl 0x2(%r9),%r14d
  8d13a9:	49 83 c1 10          	add    $0x10,%r9
  8d13ad:	45 0f b6 69 f4       	movzbl -0xc(%r9),%r13d
  8d13b2:	45 0f b6 61 f5       	movzbl -0xb(%r9),%r12d
  8d13b7:	4c 01 f8             	add    %r15,%rax
  8d13ba:	41 0f b6 69 f6       	movzbl -0xa(%r9),%ebp
  8d13bf:	45 0f b6 59 f8       	movzbl -0x8(%r9),%r11d
  8d13c4:	48 89 c3             	mov    %rax,%rbx
  8d13c7:	41 0f b6 41 f1       	movzbl -0xf(%r9),%eax
  8d13cc:	45 0f b6 51 f9       	movzbl -0x7(%r9),%r10d
  8d13d1:	45 0f b6 41 fa       	movzbl -0x6(%r9),%r8d
  8d13d6:	41 0f b6 71 fc       	movzbl -0x4(%r9),%esi
  8d13db:	48 89 1c 24          	mov    %rbx,(%rsp)
  8d13df:	48 01 d8             	add    %rbx,%rax
  8d13e2:	41 0f b6 59 f7       	movzbl -0x9(%r9),%ebx
  8d13e7:	41 0f b6 49 fd       	movzbl -0x3(%r9),%ecx
  8d13ec:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
  8d13f0:	45 0f b6 71 f3       	movzbl -0xd(%r9),%r14d
  8d13f5:	48 03 04 24          	add    (%rsp),%rax
  8d13f9:	41 0f b6 51 fe       	movzbl -0x2(%r9),%edx
  8d13fe:	45 0f b6 79 ff       	movzbl -0x1(%r9),%r15d
  8d1403:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d1408:	49 01 fe             	add    %rdi,%r14
  8d140b:	48 03 44 24 08       	add    0x8(%rsp),%rax
  8d1410:	41 0f b6 79 fb       	movzbl -0x5(%r9),%edi
  8d1415:	4d 01 f5             	add    %r14,%r13
  8d1418:	4c 01 f0             	add    %r14,%rax
  8d141b:	4d 01 ec             	add    %r13,%r12
  8d141e:	4c 01 e8             	add    %r13,%rax
  8d1421:	4c 01 e5             	add    %r12,%rbp
  8d1424:	49 01 c4             	add    %rax,%r12
  8d1427:	48 01 eb             	add    %rbp,%rbx
  8d142a:	4c 01 e5             	add    %r12,%rbp
  8d142d:	49 01 db             	add    %rbx,%r11
  8d1430:	48 01 eb             	add    %rbp,%rbx
  8d1433:	4d 01 da             	add    %r11,%r10
  8d1436:	49 01 db             	add    %rbx,%r11
  8d1439:	4d 01 d0             	add    %r10,%r8
  8d143c:	4d 01 da             	add    %r11,%r10
  8d143f:	4c 01 c7             	add    %r8,%rdi
  8d1442:	4d 01 d0             	add    %r10,%r8
  8d1445:	48 01 fe             	add    %rdi,%rsi
  8d1448:	4c 01 c7             	add    %r8,%rdi
  8d144b:	48 01 f1             	add    %rsi,%rcx
  8d144e:	48 01 fe             	add    %rdi,%rsi
  8d1451:	48 01 ca             	add    %rcx,%rdx
  8d1454:	48 01 f1             	add    %rsi,%rcx
  8d1457:	49 01 d7             	add    %rdx,%r15
  8d145a:	48 01 ca             	add    %rcx,%rdx
  8d145d:	4c 01 fa             	add    %r15,%rdx
  8d1460:	48 01 54 24 10       	add    %rdx,0x10(%rsp)
  8d1465:	4c 3b 4c 24 20       	cmp    0x20(%rsp),%r9
  8d146a:	0f 85 30 ff ff ff    	jne    8d13a0 <zlib_inflate+0xba0>
  8d1470:	8b 44 24 40          	mov    0x40(%rsp),%eax
  8d1474:	8b 74 24 48          	mov    0x48(%rsp),%esi
  8d1478:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d147d:	c1 e0 04             	shl    $0x4,%eax
  8d1480:	29 c6                	sub    %eax,%esi
  8d1482:	89 f0                	mov    %esi,%eax
  8d1484:	0f 85 8b 00 00 00    	jne    8d1515 <zlib_inflate+0xd15>
  8d148a:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d1491:	00 0f 00 
  8d1494:	8b 74 24 28          	mov    0x28(%rsp),%esi
  8d1498:	49 f7 e7             	mul    %r15
  8d149b:	4c 89 f8             	mov    %r15,%rax
  8d149e:	48 29 d0             	sub    %rdx,%rax
  8d14a1:	48 d1 e8             	shr    %rax
  8d14a4:	48 01 c2             	add    %rax,%rdx
  8d14a7:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d14ae:	00 0f 00 
  8d14b1:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d14b5:	48 69 d2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rdx
  8d14bc:	49 29 d7             	sub    %rdx,%r15
  8d14bf:	49 f7 e0             	mul    %r8
  8d14c2:	4c 89 c0             	mov    %r8,%rax
  8d14c5:	48 29 d0             	sub    %rdx,%rax
  8d14c8:	48 d1 e8             	shr    %rax
  8d14cb:	48 01 c2             	add    %rax,%rdx
  8d14ce:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d14d2:	48 69 d2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rdx
  8d14d9:	49 29 d0             	sub    %rdx,%r8
  8d14dc:	85 f6                	test   %esi,%esi
  8d14de:	0f 85 6c fe ff ff    	jne    8d1350 <zlib_inflate+0xb50>
  8d14e4:	4c 89 c0             	mov    %r8,%rax
  8d14e7:	48 8b 6c 24 58       	mov    0x58(%rsp),%rbp
  8d14ec:	4c 8b 64 24 60       	mov    0x60(%rsp),%r12
  8d14f1:	48 c1 e0 10          	shl    $0x10,%rax
  8d14f5:	49 09 c7             	or     %rax,%r15
  8d14f8:	4c 89 7d 18          	mov    %r15,0x18(%rbp)
  8d14fc:	4d 89 7c 24 50       	mov    %r15,0x50(%r12)
  8d1501:	e9 9c f8 ff ff       	jmpq   8d0da2 <zlib_inflate+0x5a2>
  8d1506:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d150d:	00 00 00 
  8d1510:	4c 89 4c 24 20       	mov    %r9,0x20(%rsp)
  8d1515:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8d151a:	83 e8 01             	sub    $0x1,%eax
  8d151d:	48 89 c2             	mov    %rax,%rdx
  8d1520:	48 8d 74 03 01       	lea    0x1(%rbx,%rax,1),%rsi
  8d1525:	48 89 d8             	mov    %rbx,%rax
  8d1528:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d152f:	00 
  8d1530:	0f b6 08             	movzbl (%rax),%ecx
  8d1533:	48 83 c0 01          	add    $0x1,%rax
  8d1537:	49 01 cf             	add    %rcx,%r15
  8d153a:	4d 01 f8             	add    %r15,%r8
  8d153d:	48 39 f0             	cmp    %rsi,%rax
  8d1540:	75 ee                	jne    8d1530 <zlib_inflate+0xd30>
  8d1542:	48 8b 5c 24 20       	mov    0x20(%rsp),%rbx
  8d1547:	48 63 c2             	movslq %edx,%rax
  8d154a:	4c 8d 4c 03 01       	lea    0x1(%rbx,%rax,1),%r9
  8d154f:	e9 36 ff ff ff       	jmpq   8d148a <zlib_inflate+0xc8a>
  8d1554:	0f 1f 40 00          	nopl   0x0(%rax)
  8d1558:	83 7c 24 34 05       	cmpl   $0x5,0x34(%rsp)
  8d155d:	0f 84 9b fd ff ff    	je     8d12fe <zlib_inflate+0xafe>
  8d1563:	e9 58 f4 ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d1568:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d156f:	00 
  8d1570:	49 8b 44 24 38       	mov    0x38(%r12),%rax
  8d1575:	48 85 c0             	test   %rax,%rax
  8d1578:	0f 84 3a f4 ff ff    	je     8d09b8 <zlib_inflate+0x1b8>
  8d157e:	83 38 0d             	cmpl   $0xd,(%rax)
  8d1581:	0f 85 04 08 00 00    	jne    8d1d8b <zlib_inflate+0x158b>
  8d1587:	8b 50 48             	mov    0x48(%rax),%edx
  8d158a:	85 d2                	test   %edx,%edx
  8d158c:	0f 85 f9 07 00 00    	jne    8d1d8b <zlib_inflate+0x158b>
  8d1592:	c7 00 0b 00 00 00    	movl   $0xb,(%rax)
  8d1598:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d159f:	00 
  8d15a0:	e9 1b f4 ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d15a5:	0f 1f 00             	nopl   (%rax)
  8d15a8:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d15ad:	48 29 c6             	sub    %rax,%rsi
  8d15b0:	89 c8                	mov    %ecx,%eax
  8d15b2:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  8d15b6:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d15bb:	39 f8                	cmp    %edi,%eax
  8d15bd:	0f 47 c7             	cmova  %edi,%eax
  8d15c0:	29 c1                	sub    %eax,%ecx
  8d15c2:	29 c7                	sub    %eax,%edi
  8d15c4:	89 4d 4c             	mov    %ecx,0x4c(%rbp)
  8d15c7:	8d 48 ff             	lea    -0x1(%rax),%ecx
  8d15ca:	31 c0                	xor    %eax,%eax
  8d15cc:	89 7c 24 08          	mov    %edi,0x8(%rsp)
  8d15d0:	48 8d 79 01          	lea    0x1(%rcx),%rdi
  8d15d4:	0f 1f 40 00          	nopl   0x0(%rax)
  8d15d8:	0f b6 14 06          	movzbl (%rsi,%rax,1),%edx
  8d15dc:	41 88 14 00          	mov    %dl,(%r8,%rax,1)
  8d15e0:	48 89 c2             	mov    %rax,%rdx
  8d15e3:	48 83 c0 01          	add    $0x1,%rax
  8d15e7:	48 39 d1             	cmp    %rdx,%rcx
  8d15ea:	75 ec                	jne    8d15d8 <zlib_inflate+0xdd8>
  8d15ec:	8b 45 4c             	mov    0x4c(%rbp),%eax
  8d15ef:	48 01 7c 24 10       	add    %rdi,0x10(%rsp)
  8d15f4:	85 c0                	test   %eax,%eax
  8d15f6:	74 08                	je     8d1600 <zlib_inflate+0xe00>
  8d15f8:	8b 75 00             	mov    0x0(%rbp),%esi
  8d15fb:	e9 8c f2 ff ff       	jmpq   8d088c <zlib_inflate+0x8c>
  8d1600:	c7 45 00 12 00 00 00 	movl   $0x12,0x0(%rbp)
  8d1607:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
  8d160c:	e9 bd fa ff ff       	jmpq   8d10ce <zlib_inflate+0x8ce>
  8d1611:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1618:	29 c3                	sub    %eax,%ebx
  8d161a:	41 8d 40 01          	lea    0x1(%r8),%eax
  8d161e:	49 d3 eb             	shr    %cl,%r11
  8d1621:	89 45 7c             	mov    %eax,0x7c(%rbp)
  8d1624:	66 42 89 bc 45 88 00 	mov    %di,0x88(%rbp,%r8,2)
  8d162b:	00 00 
  8d162d:	41 89 c0             	mov    %eax,%r8d
  8d1630:	45 39 c1             	cmp    %r8d,%r9d
  8d1633:	0f 87 2a f9 ff ff    	ja     8d0f63 <zlib_inflate+0x763>
  8d1639:	83 7d 00 1b          	cmpl   $0x1b,0x0(%rbp)
  8d163d:	0f 84 d8 f8 ff ff    	je     8d0f1b <zlib_inflate+0x71b>
  8d1643:	48 8d 85 48 05 00 00 	lea    0x548(%rbp),%rax
  8d164a:	8b 54 24 28          	mov    0x28(%rsp),%edx
  8d164e:	c7 45 68 09 00 00 00 	movl   $0x9,0x68(%rbp)
  8d1655:	4c 8d 8d 08 03 00 00 	lea    0x308(%rbp),%r9
  8d165c:	48 89 85 80 00 00 00 	mov    %rax,0x80(%rbp)
  8d1663:	4c 8d 45 68          	lea    0x68(%rbp),%r8
  8d1667:	48 8d 8d 80 00 00 00 	lea    0x80(%rbp),%rcx
  8d166e:	bf 01 00 00 00       	mov    $0x1,%edi
  8d1673:	48 89 45 58          	mov    %rax,0x58(%rbp)
  8d1677:	48 8d b5 88 00 00 00 	lea    0x88(%rbp),%rsi
  8d167e:	4c 89 5c 24 48       	mov    %r11,0x48(%rsp)
  8d1683:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
  8d1688:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  8d168d:	48 89 74 24 28       	mov    %rsi,0x28(%rsp)
  8d1692:	e8 29 e5 ff ff       	callq  8cfbc0 <zlib_inflate_table>
  8d1697:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8d169c:	48 8b 4c 24 38       	mov    0x38(%rsp),%rcx
  8d16a1:	85 c0                	test   %eax,%eax
  8d16a3:	4c 8b 4c 24 40       	mov    0x40(%rsp),%r9
  8d16a8:	4c 8b 5c 24 48       	mov    0x48(%rsp),%r11
  8d16ad:	0f 84 cc 08 00 00    	je     8d1f7f <zlib_inflate+0x177f>
  8d16b3:	48 8d 05 cf 9b 00 00 	lea    0x9bcf(%rip),%rax        # 8db289 <kernel_info_end+0xf9>
  8d16ba:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d16bf:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d16c6:	e9 50 f8 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d16cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d16d0:	83 e6 0f             	and    $0xf,%esi
  8d16d3:	44 89 45 50          	mov    %r8d,0x50(%rbp)
  8d16d7:	89 75 54             	mov    %esi,0x54(%rbp)
  8d16da:	c7 45 00 15 00 00 00 	movl   $0x15,0x0(%rbp)
  8d16e1:	e9 05 f8 ff ff       	jmpq   8d0eeb <zlib_inflate+0x6eb>
  8d16e6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d16ed:	00 00 00 
  8d16f0:	01 fa                	add    %edi,%edx
  8d16f2:	48 01 d6             	add    %rdx,%rsi
  8d16f5:	e9 eb f5 ff ff       	jmpq   8d0ce5 <zlib_inflate+0x4e5>
  8d16fa:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
  8d16ff:	e9 ca f9 ff ff       	jmpq   8d10ce <zlib_inflate+0x8ce>
  8d1704:	0f 1f 40 00          	nopl   0x0(%rax)
  8d1708:	39 f3                	cmp    %esi,%ebx
  8d170a:	73 38                	jae    8d1744 <zlib_inflate+0xf44>
  8d170c:	45 85 ed             	test   %r13d,%r13d
  8d170f:	0f 84 bd fb ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1715:	89 d9                	mov    %ebx,%ecx
  8d1717:	eb 10                	jmp    8d1729 <zlib_inflate+0xf29>
  8d1719:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1720:	45 85 ed             	test   %r13d,%r13d
  8d1723:	0f 84 a7 fb ff ff    	je     8d12d0 <zlib_inflate+0xad0>
  8d1729:	41 0f b6 06          	movzbl (%r14),%eax
  8d172d:	49 83 c6 01          	add    $0x1,%r14
  8d1731:	41 83 ed 01          	sub    $0x1,%r13d
  8d1735:	48 d3 e0             	shl    %cl,%rax
  8d1738:	83 c1 08             	add    $0x8,%ecx
  8d173b:	49 01 c3             	add    %rax,%r11
  8d173e:	39 f1                	cmp    %esi,%ecx
  8d1740:	72 de                	jb     8d1720 <zlib_inflate+0xf20>
  8d1742:	89 cb                	mov    %ecx,%ebx
  8d1744:	89 f1                	mov    %esi,%ecx
  8d1746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d174b:	29 f3                	sub    %esi,%ebx
  8d174d:	d3 e0                	shl    %cl,%eax
  8d174f:	89 c2                	mov    %eax,%edx
  8d1751:	f7 d2                	not    %edx
  8d1753:	44 21 da             	and    %r11d,%edx
  8d1756:	03 55 50             	add    0x50(%rbp),%edx
  8d1759:	49 d3 eb             	shr    %cl,%r11
  8d175c:	89 55 50             	mov    %edx,0x50(%rbp)
  8d175f:	e9 92 f7 ff ff       	jmpq   8d0ef6 <zlib_inflate+0x6f6>
  8d1764:	0f 1f 40 00          	nopl   0x0(%rax)
  8d1768:	83 fb 0f             	cmp    $0xf,%ebx
  8d176b:	77 38                	ja     8d17a5 <zlib_inflate+0xfa5>
  8d176d:	45 85 ed             	test   %r13d,%r13d
  8d1770:	0f 84 5c fb ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1776:	89 d9                	mov    %ebx,%ecx
  8d1778:	eb 0f                	jmp    8d1789 <zlib_inflate+0xf89>
  8d177a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d1780:	45 85 ed             	test   %r13d,%r13d
  8d1783:	0f 84 47 fb ff ff    	je     8d12d0 <zlib_inflate+0xad0>
  8d1789:	41 0f b6 06          	movzbl (%r14),%eax
  8d178d:	49 83 c6 01          	add    $0x1,%r14
  8d1791:	41 83 ed 01          	sub    $0x1,%r13d
  8d1795:	48 d3 e0             	shl    %cl,%rax
  8d1798:	83 c1 08             	add    $0x8,%ecx
  8d179b:	49 01 c3             	add    %rax,%r11
  8d179e:	83 f9 0f             	cmp    $0xf,%ecx
  8d17a1:	76 dd                	jbe    8d1780 <zlib_inflate+0xf80>
  8d17a3:	89 cb                	mov    %ecx,%ebx
  8d17a5:	48 ba 11 42 08 21 84 	movabs $0x842108421084211,%rdx
  8d17ac:	10 42 08 
  8d17af:	44 89 d9             	mov    %r11d,%ecx
  8d17b2:	4c 89 d8             	mov    %r11,%rax
  8d17b5:	c1 e1 08             	shl    $0x8,%ecx
  8d17b8:	48 c1 e8 08          	shr    $0x8,%rax
  8d17bc:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8d17c2:	48 01 c1             	add    %rax,%rcx
  8d17c5:	48 89 c8             	mov    %rcx,%rax
  8d17c8:	48 f7 e2             	mul    %rdx
  8d17cb:	48 89 c8             	mov    %rcx,%rax
  8d17ce:	48 29 d0             	sub    %rdx,%rax
  8d17d1:	48 d1 e8             	shr    %rax
  8d17d4:	48 01 c2             	add    %rax,%rdx
  8d17d7:	48 c1 ea 04          	shr    $0x4,%rdx
  8d17db:	48 89 d0             	mov    %rdx,%rax
  8d17de:	48 c1 e0 05          	shl    $0x5,%rax
  8d17e2:	48 29 d0             	sub    %rdx,%rax
  8d17e5:	48 39 c1             	cmp    %rax,%rcx
  8d17e8:	0f 84 de 04 00 00    	je     8d1ccc <zlib_inflate+0x14cc>
  8d17ee:	48 8d 05 eb 99 00 00 	lea    0x99eb(%rip),%rax        # 8db1e0 <kernel_info_end+0x50>
  8d17f5:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d17fa:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1801:	e9 15 f7 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1806:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d180d:	00 00 00 
  8d1810:	8d 0c 06             	lea    (%rsi,%rax,1),%ecx
  8d1813:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d1818:	44 89 44 24 38       	mov    %r8d,0x38(%rsp)
  8d181d:	d3 e0                	shl    %cl,%eax
  8d181f:	89 d1                	mov    %edx,%ecx
  8d1821:	f7 d0                	not    %eax
  8d1823:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8d1827:	44 21 d8             	and    %r11d,%eax
  8d182a:	d3 e8                	shr    %cl,%eax
  8d182c:	44 01 c0             	add    %r8d,%eax
  8d182f:	48 8d 04 87          	lea    (%rdi,%rax,4),%rax
  8d1833:	0f b6 30             	movzbl (%rax),%esi
  8d1836:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
  8d183b:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  8d183f:	42 8d 14 10          	lea    (%rax,%r10,1),%edx
  8d1843:	39 da                	cmp    %ebx,%edx
  8d1845:	76 65                	jbe    8d18ac <zlib_inflate+0x10ac>
  8d1847:	45 85 ed             	test   %r13d,%r13d
  8d184a:	0f 84 82 fa ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1850:	44 89 4c 24 40       	mov    %r9d,0x40(%rsp)
  8d1855:	8b 74 24 38          	mov    0x38(%rsp),%esi
  8d1859:	44 8b 4c 24 28       	mov    0x28(%rsp),%r9d
  8d185e:	eb 09                	jmp    8d1869 <zlib_inflate+0x1069>
  8d1860:	45 85 ed             	test   %r13d,%r13d
  8d1863:	0f 84 69 fa ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1869:	41 0f b6 06          	movzbl (%r14),%eax
  8d186d:	89 d9                	mov    %ebx,%ecx
  8d186f:	83 c3 08             	add    $0x8,%ebx
  8d1872:	49 83 c6 01          	add    $0x1,%r14
  8d1876:	41 83 ed 01          	sub    $0x1,%r13d
  8d187a:	48 d3 e0             	shl    %cl,%rax
  8d187d:	44 89 d1             	mov    %r10d,%ecx
  8d1880:	49 01 c3             	add    %rax,%r11
  8d1883:	44 89 c8             	mov    %r9d,%eax
  8d1886:	44 21 d8             	and    %r11d,%eax
  8d1889:	d3 e8                	shr    %cl,%eax
  8d188b:	01 f0                	add    %esi,%eax
  8d188d:	48 8d 04 87          	lea    (%rdi,%rax,4),%rax
  8d1891:	0f b6 08             	movzbl (%rax),%ecx
  8d1894:	44 0f b7 40 02       	movzwl 0x2(%rax),%r8d
  8d1899:	0f b6 40 01          	movzbl 0x1(%rax),%eax
  8d189d:	42 8d 14 10          	lea    (%rax,%r10,1),%edx
  8d18a1:	39 da                	cmp    %ebx,%edx
  8d18a3:	77 bb                	ja     8d1860 <zlib_inflate+0x1060>
  8d18a5:	44 8b 4c 24 40       	mov    0x40(%rsp),%r9d
  8d18aa:	89 ce                	mov    %ecx,%esi
  8d18ac:	44 89 d1             	mov    %r10d,%ecx
  8d18af:	44 29 cb             	sub    %r9d,%ebx
  8d18b2:	49 d3 eb             	shr    %cl,%r11
  8d18b5:	e9 eb f2 ff ff       	jmpq   8d0ba5 <zlib_inflate+0x3a5>
  8d18ba:	89 cb                	mov    %ecx,%ebx
  8d18bc:	83 7c 24 34 02       	cmpl   $0x2,0x34(%rsp)
  8d18c1:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d18c5:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d18ca:	0f 94 44 24 50       	sete   0x50(%rsp)
  8d18cf:	31 c0                	xor    %eax,%eax
  8d18d1:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d18d8:	00 
  8d18d9:	e9 42 f4 ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d18de:	41 0f b7 c3          	movzwl %r11w,%eax
  8d18e2:	c7 45 00 0e 00 00 00 	movl   $0xe,0x0(%rbp)
  8d18e9:	31 db                	xor    %ebx,%ebx
  8d18eb:	45 31 db             	xor    %r11d,%r11d
  8d18ee:	89 45 4c             	mov    %eax,0x4c(%rbp)
  8d18f1:	e9 0d f5 ff ff       	jmpq   8d0e03 <zlib_inflate+0x603>
  8d18f6:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d18fb:	48 89 6c 24 50       	mov    %rbp,0x50(%rsp)
  8d1900:	4c 89 74 24 58       	mov    %r14,0x58(%rsp)
  8d1905:	48 29 c1             	sub    %rax,%rcx
  8d1908:	48 8b 45 18          	mov    0x18(%rbp),%rax
  8d190c:	44 89 6c 24 60       	mov    %r13d,0x60(%rsp)
  8d1911:	4c 89 5c 24 68       	mov    %r11,0x68(%rsp)
  8d1916:	44 0f b7 f8          	movzwl %ax,%r15d
  8d191a:	48 c1 e8 10          	shr    $0x10,%rax
  8d191e:	89 5c 24 74          	mov    %ebx,0x74(%rsp)
  8d1922:	0f b7 c0             	movzwl %ax,%eax
  8d1925:	4c 89 64 24 78       	mov    %r12,0x78(%rsp)
  8d192a:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d192f:	90                   	nop
  8d1930:	8b 74 24 40          	mov    0x40(%rsp),%esi
  8d1934:	b8 b0 15 00 00       	mov    $0x15b0,%eax
  8d1939:	81 fe b0 15 00 00    	cmp    $0x15b0,%esi
  8d193f:	89 f2                	mov    %esi,%edx
  8d1941:	0f 46 c6             	cmovbe %esi,%eax
  8d1944:	29 c6                	sub    %eax,%esi
  8d1946:	89 74 24 40          	mov    %esi,0x40(%rsp)
  8d194a:	83 fa 0f             	cmp    $0xf,%edx
  8d194d:	0f 86 9e 01 00 00    	jbe    8d1af1 <zlib_inflate+0x12f1>
  8d1953:	83 e8 10             	sub    $0x10,%eax
  8d1956:	89 44 24 70          	mov    %eax,0x70(%rsp)
  8d195a:	c1 e8 04             	shr    $0x4,%eax
  8d195d:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d1961:	48 83 c0 01          	add    $0x1,%rax
  8d1965:	48 c1 e0 04          	shl    $0x4,%rax
  8d1969:	48 01 c8             	add    %rcx,%rax
  8d196c:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8d1971:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1978:	0f b6 01             	movzbl (%rcx),%eax
  8d197b:	44 0f b6 71 02       	movzbl 0x2(%rcx),%r14d
  8d1980:	48 83 c1 10          	add    $0x10,%rcx
  8d1984:	44 0f b6 69 f4       	movzbl -0xc(%rcx),%r13d
  8d1989:	44 0f b6 61 f5       	movzbl -0xb(%rcx),%r12d
  8d198e:	4c 01 f8             	add    %r15,%rax
  8d1991:	0f b6 69 f6          	movzbl -0xa(%rcx),%ebp
  8d1995:	44 0f b6 59 f8       	movzbl -0x8(%rcx),%r11d
  8d199a:	48 89 c6             	mov    %rax,%rsi
  8d199d:	0f b6 41 f1          	movzbl -0xf(%rcx),%eax
  8d19a1:	44 0f b6 51 f9       	movzbl -0x7(%rcx),%r10d
  8d19a6:	44 0f b6 49 fa       	movzbl -0x6(%rcx),%r9d
  8d19ab:	44 0f b6 41 fb       	movzbl -0x5(%rcx),%r8d
  8d19b0:	48 89 34 24          	mov    %rsi,(%rsp)
  8d19b4:	48 01 f0             	add    %rsi,%rax
  8d19b7:	0f b6 79 fc          	movzbl -0x4(%rcx),%edi
  8d19bb:	0f b6 71 fd          	movzbl -0x3(%rcx),%esi
  8d19bf:	49 8d 1c 06          	lea    (%r14,%rax,1),%rbx
  8d19c3:	44 0f b6 71 f3       	movzbl -0xd(%rcx),%r14d
  8d19c8:	48 03 04 24          	add    (%rsp),%rax
  8d19cc:	0f b6 51 fe          	movzbl -0x2(%rcx),%edx
  8d19d0:	44 0f b6 79 ff       	movzbl -0x1(%rcx),%r15d
  8d19d5:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
  8d19da:	49 01 de             	add    %rbx,%r14
  8d19dd:	48 03 44 24 18       	add    0x18(%rsp),%rax
  8d19e2:	0f b6 59 f7          	movzbl -0x9(%rcx),%ebx
  8d19e6:	4d 01 f5             	add    %r14,%r13
  8d19e9:	4c 01 f0             	add    %r14,%rax
  8d19ec:	4d 01 ec             	add    %r13,%r12
  8d19ef:	4c 01 e8             	add    %r13,%rax
  8d19f2:	4c 01 e5             	add    %r12,%rbp
  8d19f5:	49 01 c4             	add    %rax,%r12
  8d19f8:	48 01 eb             	add    %rbp,%rbx
  8d19fb:	4c 01 e5             	add    %r12,%rbp
  8d19fe:	49 01 db             	add    %rbx,%r11
  8d1a01:	48 01 eb             	add    %rbp,%rbx
  8d1a04:	4d 01 da             	add    %r11,%r10
  8d1a07:	49 01 db             	add    %rbx,%r11
  8d1a0a:	4d 01 d1             	add    %r10,%r9
  8d1a0d:	4d 01 da             	add    %r11,%r10
  8d1a10:	4d 01 c8             	add    %r9,%r8
  8d1a13:	4d 01 d1             	add    %r10,%r9
  8d1a16:	4c 01 c7             	add    %r8,%rdi
  8d1a19:	4d 01 c8             	add    %r9,%r8
  8d1a1c:	48 01 fe             	add    %rdi,%rsi
  8d1a1f:	4c 01 c7             	add    %r8,%rdi
  8d1a22:	48 01 f2             	add    %rsi,%rdx
  8d1a25:	48 01 fe             	add    %rdi,%rsi
  8d1a28:	49 01 d7             	add    %rdx,%r15
  8d1a2b:	48 01 f2             	add    %rsi,%rdx
  8d1a2e:	4c 01 fa             	add    %r15,%rdx
  8d1a31:	48 01 54 24 28       	add    %rdx,0x28(%rsp)
  8d1a36:	48 3b 4c 24 38       	cmp    0x38(%rsp),%rcx
  8d1a3b:	0f 85 37 ff ff ff    	jne    8d1978 <zlib_inflate+0x1178>
  8d1a41:	8b 44 24 48          	mov    0x48(%rsp),%eax
  8d1a45:	8b 5c 24 70          	mov    0x70(%rsp),%ebx
  8d1a49:	c1 e0 04             	shl    $0x4,%eax
  8d1a4c:	29 c3                	sub    %eax,%ebx
  8d1a4e:	89 d8                	mov    %ebx,%eax
  8d1a50:	0f 85 a0 00 00 00    	jne    8d1af6 <zlib_inflate+0x12f6>
  8d1a56:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d1a5d:	00 0f 00 
  8d1a60:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8d1a65:	44 8b 4c 24 40       	mov    0x40(%rsp),%r9d
  8d1a6a:	49 f7 e7             	mul    %r15
  8d1a6d:	4c 89 f8             	mov    %r15,%rax
  8d1a70:	48 29 d0             	sub    %rdx,%rax
  8d1a73:	48 d1 e8             	shr    %rax
  8d1a76:	48 01 c2             	add    %rax,%rdx
  8d1a79:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d1a7d:	48 69 c2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rax
  8d1a84:	49 29 c7             	sub    %rax,%r15
  8d1a87:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d1a8e:	00 0f 00 
  8d1a91:	48 f7 e7             	mul    %rdi
  8d1a94:	48 89 f8             	mov    %rdi,%rax
  8d1a97:	48 29 d0             	sub    %rdx,%rax
  8d1a9a:	48 d1 e8             	shr    %rax
  8d1a9d:	48 01 c2             	add    %rax,%rdx
  8d1aa0:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d1aa4:	48 69 c2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rax
  8d1aab:	48 29 c7             	sub    %rax,%rdi
  8d1aae:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8d1ab3:	45 85 c9             	test   %r9d,%r9d
  8d1ab6:	0f 85 74 fe ff ff    	jne    8d1930 <zlib_inflate+0x1130>
  8d1abc:	48 89 f8             	mov    %rdi,%rax
  8d1abf:	48 8b 6c 24 50       	mov    0x50(%rsp),%rbp
  8d1ac4:	4c 8b 64 24 78       	mov    0x78(%rsp),%r12
  8d1ac9:	48 c1 e0 10          	shl    $0x10,%rax
  8d1acd:	4c 8b 74 24 58       	mov    0x58(%rsp),%r14
  8d1ad2:	44 8b 6c 24 60       	mov    0x60(%rsp),%r13d
  8d1ad7:	49 09 c7             	or     %rax,%r15
  8d1ada:	4c 8b 5c 24 68       	mov    0x68(%rsp),%r11
  8d1adf:	8b 5c 24 74          	mov    0x74(%rsp),%ebx
  8d1ae3:	4c 89 7d 18          	mov    %r15,0x18(%rbp)
  8d1ae7:	4d 89 7c 24 50       	mov    %r15,0x50(%r12)
  8d1aec:	e9 53 ee ff ff       	jmpq   8d0944 <zlib_inflate+0x144>
  8d1af1:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  8d1af6:	48 8b 5c 24 38       	mov    0x38(%rsp),%rbx
  8d1afb:	83 e8 01             	sub    $0x1,%eax
  8d1afe:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8d1b03:	48 89 c2             	mov    %rax,%rdx
  8d1b06:	48 8d 74 03 01       	lea    0x1(%rbx,%rax,1),%rsi
  8d1b0b:	48 89 d8             	mov    %rbx,%rax
  8d1b0e:	66 90                	xchg   %ax,%ax
  8d1b10:	0f b6 38             	movzbl (%rax),%edi
  8d1b13:	48 83 c0 01          	add    $0x1,%rax
  8d1b17:	49 01 ff             	add    %rdi,%r15
  8d1b1a:	4c 01 f9             	add    %r15,%rcx
  8d1b1d:	48 39 f0             	cmp    %rsi,%rax
  8d1b20:	75 ee                	jne    8d1b10 <zlib_inflate+0x1310>
  8d1b22:	48 8b 5c 24 38       	mov    0x38(%rsp),%rbx
  8d1b27:	48 63 c2             	movslq %edx,%rax
  8d1b2a:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8d1b2f:	48 8d 4c 03 01       	lea    0x1(%rbx,%rax,1),%rcx
  8d1b34:	e9 1d ff ff ff       	jmpq   8d1a56 <zlib_inflate+0x1256>
  8d1b39:	44 8d 50 03          	lea    0x3(%rax),%r10d
  8d1b3d:	41 39 da             	cmp    %ebx,%r10d
  8d1b40:	76 33                	jbe    8d1b75 <zlib_inflate+0x1375>
  8d1b42:	45 85 ed             	test   %r13d,%r13d
  8d1b45:	0f 84 87 f7 ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1b4b:	89 d9                	mov    %ebx,%ecx
  8d1b4d:	eb 0a                	jmp    8d1b59 <zlib_inflate+0x1359>
  8d1b4f:	90                   	nop
  8d1b50:	45 85 ed             	test   %r13d,%r13d
  8d1b53:	0f 84 77 f7 ff ff    	je     8d12d0 <zlib_inflate+0xad0>
  8d1b59:	41 0f b6 3e          	movzbl (%r14),%edi
  8d1b5d:	49 83 c6 01          	add    $0x1,%r14
  8d1b61:	41 83 ed 01          	sub    $0x1,%r13d
  8d1b65:	48 d3 e7             	shl    %cl,%rdi
  8d1b68:	83 c1 08             	add    $0x8,%ecx
  8d1b6b:	49 01 fb             	add    %rdi,%r11
  8d1b6e:	44 39 d1             	cmp    %r10d,%ecx
  8d1b71:	72 dd                	jb     8d1b50 <zlib_inflate+0x1350>
  8d1b73:	89 cb                	mov    %ecx,%ebx
  8d1b75:	89 c1                	mov    %eax,%ecx
  8d1b77:	bf fd ff ff ff       	mov    $0xfffffffd,%edi
  8d1b7c:	49 d3 eb             	shr    %cl,%r11
  8d1b7f:	29 c7                	sub    %eax,%edi
  8d1b81:	44 89 d9             	mov    %r11d,%ecx
  8d1b84:	01 fb                	add    %edi,%ebx
  8d1b86:	49 c1 eb 03          	shr    $0x3,%r11
  8d1b8a:	31 ff                	xor    %edi,%edi
  8d1b8c:	83 e1 07             	and    $0x7,%ecx
  8d1b8f:	83 c1 03             	add    $0x3,%ecx
  8d1b92:	e9 b3 f4 ff ff       	jmpq   8d104a <zlib_inflate+0x84a>
  8d1b97:	4c 8b 4c 24 10       	mov    0x10(%rsp),%r9
  8d1b9c:	49 c1 eb 03          	shr    $0x3,%r11
  8d1ba0:	83 eb 03             	sub    $0x3,%ebx
  8d1ba3:	49 89 d6             	mov    %rdx,%r14
  8d1ba6:	48 8d 05 53 8a 00 00 	lea    0x8a53(%rip),%rax        # 8da600 <lenfix.30781>
  8d1bad:	c7 45 00 12 00 00 00 	movl   $0x12,0x0(%rbp)
  8d1bb4:	48 89 45 58          	mov    %rax,0x58(%rbp)
  8d1bb8:	48 8d 05 c1 89 00 00 	lea    0x89c1(%rip),%rax        # 8da580 <distfix.30782>
  8d1bbf:	48 89 45 60          	mov    %rax,0x60(%rbp)
  8d1bc3:	48 b8 09 00 00 00 05 	movabs $0x500000009,%rax
  8d1bca:	00 00 00 
  8d1bcd:	48 89 45 68          	mov    %rax,0x68(%rbp)
  8d1bd1:	e9 f8 f4 ff ff       	jmpq   8d10ce <zlib_inflate+0x8ce>
  8d1bd6:	48 8d 05 49 96 00 00 	lea    0x9649(%rip),%rax        # 8db226 <kernel_info_end+0x96>
  8d1bdd:	49 c1 eb 03          	shr    $0x3,%r11
  8d1be1:	83 eb 03             	sub    $0x3,%ebx
  8d1be4:	49 89 d6             	mov    %rdx,%r14
  8d1be7:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1bec:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1bf3:	e9 23 f3 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1bf8:	89 cb                	mov    %ecx,%ebx
  8d1bfa:	89 c6                	mov    %eax,%esi
  8d1bfc:	49 89 d6             	mov    %rdx,%r14
  8d1bff:	83 fe 12             	cmp    $0x12,%esi
  8d1c02:	77 49                	ja     8d1c4d <zlib_inflate+0x144d>
  8d1c04:	ba 12 00 00 00       	mov    $0x12,%edx
  8d1c09:	89 f1                	mov    %esi,%ecx
  8d1c0b:	48 8d 05 ee 91 00 00 	lea    0x91ee(%rip),%rax        # 8dae00 <order.30813>
  8d1c12:	29 f2                	sub    %esi,%edx
  8d1c14:	48 8d 3d e7 91 00 00 	lea    0x91e7(%rip),%rdi        # 8dae02 <order.30813+0x2>
  8d1c1b:	48 8d 04 48          	lea    (%rax,%rcx,2),%rax
  8d1c1f:	48 01 ca             	add    %rcx,%rdx
  8d1c22:	48 8d 0c 57          	lea    (%rdi,%rdx,2),%rcx
  8d1c26:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d1c2d:	00 00 00 
  8d1c30:	0f b7 10             	movzwl (%rax),%edx
  8d1c33:	31 f6                	xor    %esi,%esi
  8d1c35:	48 83 c0 02          	add    $0x2,%rax
  8d1c39:	66 89 b4 55 88 00 00 	mov    %si,0x88(%rbp,%rdx,2)
  8d1c40:	00 
  8d1c41:	48 39 c1             	cmp    %rax,%rcx
  8d1c44:	75 ea                	jne    8d1c30 <zlib_inflate+0x1430>
  8d1c46:	c7 45 7c 13 00 00 00 	movl   $0x13,0x7c(%rbp)
  8d1c4d:	48 8d 85 48 05 00 00 	lea    0x548(%rbp),%rax
  8d1c54:	c7 45 68 07 00 00 00 	movl   $0x7,0x68(%rbp)
  8d1c5b:	31 ff                	xor    %edi,%edi
  8d1c5d:	48 8d 8d 80 00 00 00 	lea    0x80(%rbp),%rcx
  8d1c64:	48 89 85 80 00 00 00 	mov    %rax,0x80(%rbp)
  8d1c6b:	4c 8d 45 68          	lea    0x68(%rbp),%r8
  8d1c6f:	48 8d b5 88 00 00 00 	lea    0x88(%rbp),%rsi
  8d1c76:	ba 13 00 00 00       	mov    $0x13,%edx
  8d1c7b:	48 89 45 58          	mov    %rax,0x58(%rbp)
  8d1c7f:	4c 8d 8d 08 03 00 00 	lea    0x308(%rbp),%r9
  8d1c86:	4c 89 5c 24 28       	mov    %r11,0x28(%rsp)
  8d1c8b:	e8 30 df ff ff       	callq  8cfbc0 <zlib_inflate_table>
  8d1c90:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d1c95:	85 c0                	test   %eax,%eax
  8d1c97:	0f 84 38 01 00 00    	je     8d1dd5 <zlib_inflate+0x15d5>
  8d1c9d:	48 8d 05 b2 95 00 00 	lea    0x95b2(%rip),%rax        # 8db256 <kernel_info_end+0xc6>
  8d1ca4:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1ca9:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1cb0:	e9 66 f2 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1cb5:	c7 45 7c 00 00 00 00 	movl   $0x0,0x7c(%rbp)
  8d1cbc:	31 f6                	xor    %esi,%esi
  8d1cbe:	89 d9                	mov    %ebx,%ecx
  8d1cc0:	c7 45 00 10 00 00 00 	movl   $0x10,0x0(%rbp)
  8d1cc7:	e9 b4 f1 ff ff       	jmpq   8d0e80 <zlib_inflate+0x680>
  8d1ccc:	44 89 d8             	mov    %r11d,%eax
  8d1ccf:	83 e0 0f             	and    $0xf,%eax
  8d1cd2:	83 f8 08             	cmp    $0x8,%eax
  8d1cd5:	0f 84 1f 02 00 00    	je     8d1efa <zlib_inflate+0x16fa>
  8d1cdb:	48 8d 05 15 95 00 00 	lea    0x9515(%rip),%rax        # 8db1f7 <kernel_info_end+0x67>
  8d1ce2:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1ce7:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1cee:	e9 28 f2 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1cf3:	44 8d 50 02          	lea    0x2(%rax),%r10d
  8d1cf7:	41 39 da             	cmp    %ebx,%r10d
  8d1cfa:	76 39                	jbe    8d1d35 <zlib_inflate+0x1535>
  8d1cfc:	45 85 ed             	test   %r13d,%r13d
  8d1cff:	0f 84 cd f5 ff ff    	je     8d12d2 <zlib_inflate+0xad2>
  8d1d05:	89 d9                	mov    %ebx,%ecx
  8d1d07:	eb 10                	jmp    8d1d19 <zlib_inflate+0x1519>
  8d1d09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1d10:	45 85 ed             	test   %r13d,%r13d
  8d1d13:	0f 84 b7 f5 ff ff    	je     8d12d0 <zlib_inflate+0xad0>
  8d1d19:	41 0f b6 3e          	movzbl (%r14),%edi
  8d1d1d:	49 83 c6 01          	add    $0x1,%r14
  8d1d21:	41 83 ed 01          	sub    $0x1,%r13d
  8d1d25:	48 d3 e7             	shl    %cl,%rdi
  8d1d28:	83 c1 08             	add    $0x8,%ecx
  8d1d2b:	49 01 fb             	add    %rdi,%r11
  8d1d2e:	44 39 d1             	cmp    %r10d,%ecx
  8d1d31:	72 dd                	jb     8d1d10 <zlib_inflate+0x1510>
  8d1d33:	89 cb                	mov    %ecx,%ebx
  8d1d35:	89 c1                	mov    %eax,%ecx
  8d1d37:	29 c3                	sub    %eax,%ebx
  8d1d39:	49 d3 eb             	shr    %cl,%r11
  8d1d3c:	45 85 c0             	test   %r8d,%r8d
  8d1d3f:	0f 84 a1 02 00 00    	je     8d1fe6 <zlib_inflate+0x17e6>
  8d1d45:	44 89 d9             	mov    %r11d,%ecx
  8d1d48:	41 8d 40 ff          	lea    -0x1(%r8),%eax
  8d1d4c:	49 c1 eb 02          	shr    $0x2,%r11
  8d1d50:	83 eb 02             	sub    $0x2,%ebx
  8d1d53:	83 e1 03             	and    $0x3,%ecx
  8d1d56:	0f b7 bc 45 88 00 00 	movzwl 0x88(%rbp,%rax,2),%edi
  8d1d5d:	00 
  8d1d5e:	83 c1 03             	add    $0x3,%ecx
  8d1d61:	e9 e4 f2 ff ff       	jmpq   8d104a <zlib_inflate+0x84a>
  8d1d66:	a8 40                	test   $0x40,%al
  8d1d68:	0f 84 75 01 00 00    	je     8d1ee3 <zlib_inflate+0x16e3>
  8d1d6e:	48 8d 05 4f 94 00 00 	lea    0x944f(%rip),%rax        # 8db1c4 <kernel_info_end+0x34>
  8d1d75:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d1d7a:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1d7f:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1d86:	e9 90 f1 ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1d8b:	c7 44 24 18 fd ff ff 	movl   $0xfffffffd,0x18(%rsp)
  8d1d92:	ff 
  8d1d93:	e9 28 ec ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d1d98:	4c 89 f2             	mov    %r14,%rdx
  8d1d9b:	e9 c9 f3 ff ff       	jmpq   8d1169 <zlib_inflate+0x969>
  8d1da0:	83 7c 24 34 02       	cmpl   $0x2,0x34(%rsp)
  8d1da5:	8b 54 24 08          	mov    0x8(%rsp),%edx
  8d1da9:	89 44 24 18          	mov    %eax,0x18(%rsp)
  8d1dad:	0f 94 44 24 50       	sete   0x50(%rsp)
  8d1db2:	31 c0                	xor    %eax,%eax
  8d1db4:	e9 67 ef ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d1db9:	83 7c 24 34 02       	cmpl   $0x2,0x34(%rsp)
  8d1dbe:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d1dc5:	00 
  8d1dc6:	44 89 e8             	mov    %r13d,%eax
  8d1dc9:	0f 94 44 24 50       	sete   0x50(%rsp)
  8d1dce:	31 d2                	xor    %edx,%edx
  8d1dd0:	e9 4b ef ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d1dd5:	c7 45 7c 00 00 00 00 	movl   $0x0,0x7c(%rbp)
  8d1ddc:	45 31 c0             	xor    %r8d,%r8d
  8d1ddf:	c7 45 00 11 00 00 00 	movl   $0x11,0x0(%rbp)
  8d1de6:	e9 51 f1 ff ff       	jmpq   8d0f3c <zlib_inflate+0x73c>
  8d1deb:	01 d0                	add    %edx,%eax
  8d1ded:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8d1df3:	89 c1                	mov    %eax,%ecx
  8d1df5:	41 d3 e0             	shl    %cl,%r8d
  8d1df8:	89 d1                	mov    %edx,%ecx
  8d1dfa:	41 f7 d0             	not    %r8d
  8d1dfd:	44 89 c0             	mov    %r8d,%eax
  8d1e00:	44 89 44 24 28       	mov    %r8d,0x28(%rsp)
  8d1e05:	44 21 d8             	and    %r11d,%eax
  8d1e08:	d3 e8                	shr    %cl,%eax
  8d1e0a:	01 f0                	add    %esi,%eax
  8d1e0c:	48 8d 0c 87          	lea    (%rdi,%rax,4),%rcx
  8d1e10:	44 0f b6 41 01       	movzbl 0x1(%rcx),%r8d
  8d1e15:	0f b6 01             	movzbl (%rcx),%eax
  8d1e18:	44 0f b7 51 02       	movzwl 0x2(%rcx),%r10d
  8d1e1d:	41 8d 0c 10          	lea    (%r8,%rdx,1),%ecx
  8d1e21:	39 d9                	cmp    %ebx,%ecx
  8d1e23:	76 64                	jbe    8d1e89 <zlib_inflate+0x1689>
  8d1e25:	45 85 ed             	test   %r13d,%r13d
  8d1e28:	0f 84 8e fa ff ff    	je     8d18bc <zlib_inflate+0x10bc>
  8d1e2e:	48 89 6c 24 10       	mov    %rbp,0x10(%rsp)
  8d1e33:	8b 6c 24 28          	mov    0x28(%rsp),%ebp
  8d1e37:	eb 10                	jmp    8d1e49 <zlib_inflate+0x1649>
  8d1e39:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d1e40:	45 85 ed             	test   %r13d,%r13d
  8d1e43:	0f 84 de 00 00 00    	je     8d1f27 <zlib_inflate+0x1727>
  8d1e49:	41 0f b6 06          	movzbl (%r14),%eax
  8d1e4d:	89 d9                	mov    %ebx,%ecx
  8d1e4f:	83 c3 08             	add    $0x8,%ebx
  8d1e52:	49 83 c6 01          	add    $0x1,%r14
  8d1e56:	41 83 ed 01          	sub    $0x1,%r13d
  8d1e5a:	48 d3 e0             	shl    %cl,%rax
  8d1e5d:	89 d1                	mov    %edx,%ecx
  8d1e5f:	49 01 c3             	add    %rax,%r11
  8d1e62:	89 e8                	mov    %ebp,%eax
  8d1e64:	44 21 d8             	and    %r11d,%eax
  8d1e67:	d3 e8                	shr    %cl,%eax
  8d1e69:	01 f0                	add    %esi,%eax
  8d1e6b:	48 8d 0c 87          	lea    (%rdi,%rax,4),%rcx
  8d1e6f:	44 0f b6 41 01       	movzbl 0x1(%rcx),%r8d
  8d1e74:	0f b6 01             	movzbl (%rcx),%eax
  8d1e77:	44 0f b7 51 02       	movzwl 0x2(%rcx),%r10d
  8d1e7c:	41 8d 0c 10          	lea    (%r8,%rdx,1),%ecx
  8d1e80:	39 d9                	cmp    %ebx,%ecx
  8d1e82:	77 bc                	ja     8d1e40 <zlib_inflate+0x1640>
  8d1e84:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  8d1e89:	89 d1                	mov    %edx,%ecx
  8d1e8b:	29 d3                	sub    %edx,%ebx
  8d1e8d:	44 89 55 4c          	mov    %r10d,0x4c(%rbp)
  8d1e91:	49 d3 eb             	shr    %cl,%r11
  8d1e94:	44 89 c1             	mov    %r8d,%ecx
  8d1e97:	44 29 c3             	sub    %r8d,%ebx
  8d1e9a:	49 d3 eb             	shr    %cl,%r11
  8d1e9d:	84 c0                	test   %al,%al
  8d1e9f:	0f 85 d6 eb ff ff    	jne    8d0a7b <zlib_inflate+0x27b>
  8d1ea5:	e9 eb f1 ff ff       	jmpq   8d1095 <zlib_inflate+0x895>
  8d1eaa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d1eb0:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  8d1eb5:	4d 89 34 24          	mov    %r14,(%r12)
  8d1eb9:	c7 44 24 18 02 00 00 	movl   $0x2,0x18(%rsp)
  8d1ec0:	00 
  8d1ec1:	49 89 44 24 18       	mov    %rax,0x18(%r12)
  8d1ec6:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d1eca:	49 89 44 24 20       	mov    %rax,0x20(%r12)
  8d1ecf:	44 89 e8             	mov    %r13d,%eax
  8d1ed2:	49 89 44 24 08       	mov    %rax,0x8(%r12)
  8d1ed7:	4c 89 5d 40          	mov    %r11,0x40(%rbp)
  8d1edb:	89 5d 48             	mov    %ebx,0x48(%rbp)
  8d1ede:	e9 dd ea ff ff       	jmpq   8d09c0 <zlib_inflate+0x1c0>
  8d1ee3:	83 e0 0f             	and    $0xf,%eax
  8d1ee6:	c7 45 00 13 00 00 00 	movl   $0x13,0x0(%rbp)
  8d1eed:	89 45 54             	mov    %eax,0x54(%rbp)
  8d1ef0:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d1ef5:	e9 c1 eb ff ff       	jmpq   8d0abb <zlib_inflate+0x2bb>
  8d1efa:	49 c1 eb 04          	shr    $0x4,%r11
  8d1efe:	44 89 d9             	mov    %r11d,%ecx
  8d1f01:	83 e1 0f             	and    $0xf,%ecx
  8d1f04:	83 c1 08             	add    $0x8,%ecx
  8d1f07:	39 4d 28             	cmp    %ecx,0x28(%rbp)
  8d1f0a:	73 41                	jae    8d1f4d <zlib_inflate+0x174d>
  8d1f0c:	48 8d 05 ff 92 00 00 	lea    0x92ff(%rip),%rax        # 8db212 <kernel_info_end+0x82>
  8d1f13:	83 eb 04             	sub    $0x4,%ebx
  8d1f16:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1f1b:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1f22:	e9 f4 ef ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1f27:	48 8b 6c 24 10       	mov    0x10(%rsp),%rbp
  8d1f2c:	e9 8b f9 ff ff       	jmpq   8d18bc <zlib_inflate+0x10bc>
  8d1f31:	83 7c 24 34 02       	cmpl   $0x2,0x34(%rsp)
  8d1f36:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%rsp)
  8d1f3d:	00 
  8d1f3e:	89 f2                	mov    %esi,%edx
  8d1f40:	44 89 e8             	mov    %r13d,%eax
  8d1f43:	0f 94 44 24 50       	sete   0x50(%rsp)
  8d1f48:	e9 d3 ed ff ff       	jmpq   8d0d20 <zlib_inflate+0x520>
  8d1f4d:	b8 01 00 00 00       	mov    $0x1,%eax
  8d1f52:	48 c7 45 18 01 00 00 	movq   $0x1,0x18(%rbp)
  8d1f59:	00 
  8d1f5a:	d3 e0                	shl    %cl,%eax
  8d1f5c:	89 45 14             	mov    %eax,0x14(%rbp)
  8d1f5f:	49 c7 44 24 50 01 00 	movq   $0x1,0x50(%r12)
  8d1f66:	00 00 
  8d1f68:	41 81 e3 00 02 00 00 	and    $0x200,%r11d
  8d1f6f:	75 64                	jne    8d1fd5 <zlib_inflate+0x17d5>
  8d1f71:	c7 45 00 0b 00 00 00 	movl   $0xb,0x0(%rbp)
  8d1f78:	89 f3                	mov    %esi,%ebx
  8d1f7a:	e9 10 eb ff ff       	jmpq   8d0a8f <zlib_inflate+0x28f>
  8d1f7f:	48 8b 85 80 00 00 00 	mov    0x80(%rbp),%rax
  8d1f86:	8b 55 78             	mov    0x78(%rbp),%edx
  8d1f89:	4c 8d 45 6c          	lea    0x6c(%rbp),%r8
  8d1f8d:	bf 02 00 00 00       	mov    $0x2,%edi
  8d1f92:	c7 45 6c 06 00 00 00 	movl   $0x6,0x6c(%rbp)
  8d1f99:	48 89 45 60          	mov    %rax,0x60(%rbp)
  8d1f9d:	8b 45 74             	mov    0x74(%rbp),%eax
  8d1fa0:	4c 89 5c 24 28       	mov    %r11,0x28(%rsp)
  8d1fa5:	48 01 c0             	add    %rax,%rax
  8d1fa8:	48 01 c6             	add    %rax,%rsi
  8d1fab:	e8 10 dc ff ff       	callq  8cfbc0 <zlib_inflate_table>
  8d1fb0:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
  8d1fb5:	85 c0                	test   %eax,%eax
  8d1fb7:	0f 84 43 f6 ff ff    	je     8d1600 <zlib_inflate+0xe00>
  8d1fbd:	48 8d 05 e1 92 00 00 	lea    0x92e1(%rip),%rax        # 8db2a5 <kernel_info_end+0x115>
  8d1fc4:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1fc9:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1fd0:	e9 46 ef ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1fd5:	c7 45 00 09 00 00 00 	movl   $0x9,0x0(%rbp)
  8d1fdc:	89 f3                	mov    %esi,%ebx
  8d1fde:	45 31 db             	xor    %r11d,%r11d
  8d1fe1:	e9 ef eb ff ff       	jmpq   8d0bd5 <zlib_inflate+0x3d5>
  8d1fe6:	48 8d 05 82 92 00 00 	lea    0x9282(%rip),%rax        # 8db26f <kernel_info_end+0xdf>
  8d1fed:	49 89 44 24 30       	mov    %rax,0x30(%r12)
  8d1ff2:	c7 45 00 1b 00 00 00 	movl   $0x1b,0x0(%rbp)
  8d1ff9:	e9 1d ef ff ff       	jmpq   8d0f1b <zlib_inflate+0x71b>
  8d1ffe:	66 90                	xchg   %ax,%ax

00000000008d2000 <zlib_inflateEnd>:
  8d2000:	f3 0f 1e fa          	endbr64 
  8d2004:	48 85 ff             	test   %rdi,%rdi
  8d2007:	74 0b                	je     8d2014 <zlib_inflateEnd+0x14>
  8d2009:	48 83 7f 38 01       	cmpq   $0x1,0x38(%rdi)
  8d200e:	19 c0                	sbb    %eax,%eax
  8d2010:	83 e0 fe             	and    $0xfffffffe,%eax
  8d2013:	c3                   	retq   
  8d2014:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  8d2019:	c3                   	retq   
  8d201a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d2020 <zlib_inflateIncomp>:
  8d2020:	f3 0f 1e fa          	endbr64 
  8d2024:	41 57                	push   %r15
  8d2026:	41 56                	push   %r14
  8d2028:	41 55                	push   %r13
  8d202a:	41 54                	push   %r12
  8d202c:	49 89 fc             	mov    %rdi,%r12
  8d202f:	55                   	push   %rbp
  8d2030:	53                   	push   %rbx
  8d2031:	48 83 ec 48          	sub    $0x48,%rsp
  8d2035:	4c 8b 77 38          	mov    0x38(%rdi),%r14
  8d2039:	48 8b 6f 18          	mov    0x18(%rdi),%rbp
  8d203d:	48 8b 5f 20          	mov    0x20(%rdi),%rbx
  8d2041:	41 8b 06             	mov    (%r14),%eax
  8d2044:	83 f8 0b             	cmp    $0xb,%eax
  8d2047:	74 08                	je     8d2051 <zlib_inflateIncomp+0x31>
  8d2049:	85 c0                	test   %eax,%eax
  8d204b:	0f 85 9f 02 00 00    	jne    8d22f0 <zlib_inflateIncomp+0x2d0>
  8d2051:	49 8b 74 24 08       	mov    0x8(%r12),%rsi
  8d2056:	49 8b 04 24          	mov    (%r12),%rax
  8d205a:	4c 89 e7             	mov    %r12,%rdi
  8d205d:	83 e3 ff             	and    $0xffffffff,%ebx
  8d2060:	49 c7 44 24 20 00 00 	movq   $0x0,0x20(%r12)
  8d2067:	00 00 
  8d2069:	48 01 f0             	add    %rsi,%rax
  8d206c:	49 89 44 24 18       	mov    %rax,0x18(%r12)
  8d2071:	e8 ea d9 ff ff       	callq  8cfa60 <zlib_updatewindow>
  8d2076:	49 89 5c 24 20       	mov    %rbx,0x20(%r12)
  8d207b:	49 8b 0c 24          	mov    (%r12),%rcx
  8d207f:	49 89 6c 24 18       	mov    %rbp,0x18(%r12)
  8d2084:	49 8b 46 18          	mov    0x18(%r14),%rax
  8d2088:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8d208d:	44 0f b7 f8          	movzwl %ax,%r15d
  8d2091:	48 c1 e8 10          	shr    $0x10,%rax
  8d2095:	44 0f b7 c0          	movzwl %ax,%r8d
  8d2099:	48 85 c9             	test   %rcx,%rcx
  8d209c:	0f 84 3e 02 00 00    	je     8d22e0 <zlib_inflateIncomp+0x2c0>
  8d20a2:	85 d2                	test   %edx,%edx
  8d20a4:	0f 84 b6 01 00 00    	je     8d2260 <zlib_inflateIncomp+0x240>
  8d20aa:	4c 89 74 24 30       	mov    %r14,0x30(%rsp)
  8d20af:	4c 89 c0             	mov    %r8,%rax
  8d20b2:	49 89 ca             	mov    %rcx,%r10
  8d20b5:	41 89 d0             	mov    %edx,%r8d
  8d20b8:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
  8d20bd:	49 89 c1             	mov    %rax,%r9
  8d20c0:	41 81 f8 b0 15 00 00 	cmp    $0x15b0,%r8d
  8d20c7:	b8 b0 15 00 00       	mov    $0x15b0,%eax
  8d20cc:	44 89 c2             	mov    %r8d,%edx
  8d20cf:	41 0f 46 c0          	cmovbe %r8d,%eax
  8d20d3:	41 29 c0             	sub    %eax,%r8d
  8d20d6:	83 fa 0f             	cmp    $0xf,%edx
  8d20d9:	0f 86 c9 01 00 00    	jbe    8d22a8 <zlib_inflateIncomp+0x288>
  8d20df:	83 e8 10             	sub    $0x10,%eax
  8d20e2:	89 44 24 2c          	mov    %eax,0x2c(%rsp)
  8d20e6:	c1 e8 04             	shr    $0x4,%eax
  8d20e9:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8d20ed:	48 83 c0 01          	add    $0x1,%rax
  8d20f1:	48 c1 e0 04          	shl    $0x4,%rax
  8d20f5:	4d 8d 1c 02          	lea    (%r10,%rax,1),%r11
  8d20f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d2100:	41 0f b6 02          	movzbl (%r10),%eax
  8d2104:	45 0f b6 72 01       	movzbl 0x1(%r10),%r14d
  8d2109:	49 83 c2 10          	add    $0x10,%r10
  8d210d:	45 0f b6 6a f2       	movzbl -0xe(%r10),%r13d
  8d2112:	41 0f b6 52 f3       	movzbl -0xd(%r10),%edx
  8d2117:	4c 01 f8             	add    %r15,%rax
  8d211a:	45 0f b6 62 f6       	movzbl -0xa(%r10),%r12d
  8d211f:	41 0f b6 6a f9       	movzbl -0x7(%r10),%ebp
  8d2124:	49 01 c6             	add    %rax,%r14
  8d2127:	45 0f b6 7a ff       	movzbl -0x1(%r10),%r15d
  8d212c:	4d 01 f5             	add    %r14,%r13
  8d212f:	4c 01 f0             	add    %r14,%rax
  8d2132:	4a 8d 0c 2a          	lea    (%rdx,%r13,1),%rcx
  8d2136:	41 0f b6 52 f4       	movzbl -0xc(%r10),%edx
  8d213b:	4c 01 e8             	add    %r13,%rax
  8d213e:	48 89 0c 24          	mov    %rcx,(%rsp)
  8d2142:	48 03 04 24          	add    (%rsp),%rax
  8d2146:	48 01 ca             	add    %rcx,%rdx
  8d2149:	41 0f b6 4a fd       	movzbl -0x3(%r10),%ecx
  8d214e:	48 89 d3             	mov    %rdx,%rbx
  8d2151:	41 0f b6 52 f5       	movzbl -0xb(%r10),%edx
  8d2156:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  8d215b:	48 03 44 24 08       	add    0x8(%rsp),%rax
  8d2160:	48 01 da             	add    %rbx,%rdx
  8d2163:	41 0f b6 5a fa       	movzbl -0x6(%r10),%ebx
  8d2168:	49 01 d4             	add    %rdx,%r12
  8d216b:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  8d2170:	48 03 44 24 10       	add    0x10(%rsp),%rax
  8d2175:	4c 89 e7             	mov    %r12,%rdi
  8d2178:	45 0f b6 62 f7       	movzbl -0x9(%r10),%r12d
  8d217d:	41 0f b6 52 fe       	movzbl -0x2(%r10),%edx
  8d2182:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8d2187:	48 03 44 24 18       	add    0x18(%rsp),%rax
  8d218c:	49 01 fc             	add    %rdi,%r12
  8d218f:	41 0f b6 7a fb       	movzbl -0x5(%r10),%edi
  8d2194:	4c 89 e6             	mov    %r12,%rsi
  8d2197:	45 0f b6 62 f8       	movzbl -0x8(%r10),%r12d
  8d219c:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
  8d21a1:	48 03 44 24 20       	add    0x20(%rsp),%rax
  8d21a6:	49 01 f4             	add    %rsi,%r12
  8d21a9:	41 0f b6 72 fc       	movzbl -0x4(%r10),%esi
  8d21ae:	4c 01 e5             	add    %r12,%rbp
  8d21b1:	49 01 c4             	add    %rax,%r12
  8d21b4:	48 01 eb             	add    %rbp,%rbx
  8d21b7:	4c 01 e5             	add    %r12,%rbp
  8d21ba:	48 01 df             	add    %rbx,%rdi
  8d21bd:	48 01 eb             	add    %rbp,%rbx
  8d21c0:	48 01 fe             	add    %rdi,%rsi
  8d21c3:	48 01 df             	add    %rbx,%rdi
  8d21c6:	48 01 f1             	add    %rsi,%rcx
  8d21c9:	48 01 fe             	add    %rdi,%rsi
  8d21cc:	48 01 ca             	add    %rcx,%rdx
  8d21cf:	48 01 f1             	add    %rsi,%rcx
  8d21d2:	49 01 d7             	add    %rdx,%r15
  8d21d5:	48 01 ca             	add    %rcx,%rdx
  8d21d8:	4c 01 fa             	add    %r15,%rdx
  8d21db:	49 01 d1             	add    %rdx,%r9
  8d21de:	4d 39 da             	cmp    %r11,%r10
  8d21e1:	0f 85 19 ff ff ff    	jne    8d2100 <zlib_inflateIncomp+0xe0>
  8d21e7:	8b 44 24 28          	mov    0x28(%rsp),%eax
  8d21eb:	8b 5c 24 2c          	mov    0x2c(%rsp),%ebx
  8d21ef:	c1 e0 04             	shl    $0x4,%eax
  8d21f2:	29 c3                	sub    %eax,%ebx
  8d21f4:	89 d8                	mov    %ebx,%eax
  8d21f6:	0f 85 af 00 00 00    	jne    8d22ab <zlib_inflateIncomp+0x28b>
  8d21fc:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d2203:	00 0f 00 
  8d2206:	49 f7 e7             	mul    %r15
  8d2209:	4c 89 f8             	mov    %r15,%rax
  8d220c:	48 29 d0             	sub    %rdx,%rax
  8d220f:	48 d1 e8             	shr    %rax
  8d2212:	48 01 c2             	add    %rax,%rdx
  8d2215:	48 b8 cd c5 2f 0d e1 	movabs $0xf00e10d2fc5cd,%rax
  8d221c:	00 0f 00 
  8d221f:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d2223:	48 69 d2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rdx
  8d222a:	49 29 d7             	sub    %rdx,%r15
  8d222d:	49 f7 e1             	mul    %r9
  8d2230:	4c 89 c8             	mov    %r9,%rax
  8d2233:	48 29 d0             	sub    %rdx,%rax
  8d2236:	48 d1 e8             	shr    %rax
  8d2239:	48 01 c2             	add    %rax,%rdx
  8d223c:	48 c1 ea 0f          	shr    $0xf,%rdx
  8d2240:	48 69 d2 f1 ff 00 00 	imul   $0xfff1,%rdx,%rdx
  8d2247:	49 29 d1             	sub    %rdx,%r9
  8d224a:	45 85 c0             	test   %r8d,%r8d
  8d224d:	0f 85 6d fe ff ff    	jne    8d20c0 <zlib_inflateIncomp+0xa0>
  8d2253:	4c 8b 74 24 30       	mov    0x30(%rsp),%r14
  8d2258:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
  8d225d:	4d 89 c8             	mov    %r9,%r8
  8d2260:	4c 89 c0             	mov    %r8,%rax
  8d2263:	48 c1 e0 10          	shl    $0x10,%rax
  8d2267:	49 09 c7             	or     %rax,%r15
  8d226a:	4d 89 7e 18          	mov    %r15,0x18(%r14)
  8d226e:	49 8b 44 24 08       	mov    0x8(%r12),%rax
  8d2273:	4d 89 7c 24 50       	mov    %r15,0x50(%r12)
  8d2278:	49 01 44 24 28       	add    %rax,0x28(%r12)
  8d227d:	49 01 44 24 10       	add    %rax,0x10(%r12)
  8d2282:	49 01 04 24          	add    %rax,(%r12)
  8d2286:	49 01 46 20          	add    %rax,0x20(%r14)
  8d228a:	31 c0                	xor    %eax,%eax
  8d228c:	49 c7 44 24 08 00 00 	movq   $0x0,0x8(%r12)
  8d2293:	00 00 
  8d2295:	48 83 c4 48          	add    $0x48,%rsp
  8d2299:	5b                   	pop    %rbx
  8d229a:	5d                   	pop    %rbp
  8d229b:	41 5c                	pop    %r12
  8d229d:	41 5d                	pop    %r13
  8d229f:	41 5e                	pop    %r14
  8d22a1:	41 5f                	pop    %r15
  8d22a3:	c3                   	retq   
  8d22a4:	0f 1f 40 00          	nopl   0x0(%rax)
  8d22a8:	4d 89 d3             	mov    %r10,%r11
  8d22ab:	8d 50 ff             	lea    -0x1(%rax),%edx
  8d22ae:	48 89 d0             	mov    %rdx,%rax
  8d22b1:	49 8d 4c 13 01       	lea    0x1(%r11,%rdx,1),%rcx
  8d22b6:	4c 89 da             	mov    %r11,%rdx
  8d22b9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d22c0:	0f b6 32             	movzbl (%rdx),%esi
  8d22c3:	48 83 c2 01          	add    $0x1,%rdx
  8d22c7:	49 01 f7             	add    %rsi,%r15
  8d22ca:	4d 01 f9             	add    %r15,%r9
  8d22cd:	48 39 ca             	cmp    %rcx,%rdx
  8d22d0:	75 ee                	jne    8d22c0 <zlib_inflateIncomp+0x2a0>
  8d22d2:	48 98                	cltq   
  8d22d4:	4d 8d 54 03 01       	lea    0x1(%r11,%rax,1),%r10
  8d22d9:	e9 1e ff ff ff       	jmpq   8d21fc <zlib_inflateIncomp+0x1dc>
  8d22de:	66 90                	xchg   %ax,%ax
  8d22e0:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  8d22e6:	e9 7f ff ff ff       	jmpq   8d226a <zlib_inflateIncomp+0x24a>
  8d22eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d22f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8d22f5:	eb 9e                	jmp    8d2295 <zlib_inflateIncomp+0x275>
  8d22f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d22fe:	00 00 

00000000008d2300 <__putstr>:
  8d2300:	f3 0f 1e fa          	endbr64 
  8d2304:	8b 35 e2 10 02 00    	mov    0x210e2(%rip),%esi        # 8f33ec <early_serial_base>
  8d230a:	85 f6                	test   %esi,%esi
  8d230c:	74 5d                	je     8d236b <__putstr+0x6b>
  8d230e:	0f b6 07             	movzbl (%rdi),%eax
  8d2311:	84 c0                	test   %al,%al
  8d2313:	74 56                	je     8d236b <__putstr+0x6b>
  8d2315:	49 89 f9             	mov    %rdi,%r9
  8d2318:	41 ba 0d 00 00 00    	mov    $0xd,%r10d
  8d231e:	66 90                	xchg   %ax,%ax
  8d2320:	8d 4e 05             	lea    0x5(%rsi),%ecx
  8d2323:	3c 0a                	cmp    $0xa,%al
  8d2325:	0f 84 35 01 00 00    	je     8d2460 <__putstr+0x160>
  8d232b:	49 83 c1 01          	add    $0x1,%r9
  8d232f:	89 ca                	mov    %ecx,%edx
  8d2331:	45 0f b6 41 ff       	movzbl -0x1(%r9),%r8d
  8d2336:	ec                   	in     (%dx),%al
  8d2337:	a8 20                	test   $0x20,%al
  8d2339:	75 22                	jne    8d235d <__putstr+0x5d>
  8d233b:	b9 fe ff 00 00       	mov    $0xfffe,%ecx
  8d2340:	eb 0b                	jmp    8d234d <__putstr+0x4d>
  8d2342:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d2348:	83 e9 01             	sub    $0x1,%ecx
  8d234b:	74 10                	je     8d235d <__putstr+0x5d>
  8d234d:	f3 90                	pause  
  8d234f:	8b 35 97 10 02 00    	mov    0x21097(%rip),%esi        # 8f33ec <early_serial_base>
  8d2355:	8d 56 05             	lea    0x5(%rsi),%edx
  8d2358:	ec                   	in     (%dx),%al
  8d2359:	a8 20                	test   $0x20,%al
  8d235b:	74 eb                	je     8d2348 <__putstr+0x48>
  8d235d:	44 89 c0             	mov    %r8d,%eax
  8d2360:	89 f2                	mov    %esi,%edx
  8d2362:	ee                   	out    %al,(%dx)
  8d2363:	41 0f b6 01          	movzbl (%r9),%eax
  8d2367:	84 c0                	test   %al,%al
  8d2369:	75 b5                	jne    8d2320 <__putstr+0x20>
  8d236b:	8b 05 63 ef 01 00    	mov    0x1ef63(%rip),%eax        # 8f12d4 <lines>
  8d2371:	85 c0                	test   %eax,%eax
  8d2373:	0f 84 e1 00 00 00    	je     8d245a <__putstr+0x15a>
  8d2379:	8b 05 51 ef 01 00    	mov    0x1ef51(%rip),%eax        # 8f12d0 <cols>
  8d237f:	85 c0                	test   %eax,%eax
  8d2381:	0f 84 d3 00 00 00    	je     8d245a <__putstr+0x15a>
  8d2387:	55                   	push   %rbp
  8d2388:	53                   	push   %rbx
  8d2389:	48 8d 5f 01          	lea    0x1(%rdi),%rbx
  8d238d:	48 83 ec 08          	sub    $0x8,%rsp
  8d2391:	48 8b 35 c8 0f 02 00 	mov    0x20fc8(%rip),%rsi        # 8f3360 <boot_params>
  8d2398:	0f b6 17             	movzbl (%rdi),%edx
  8d239b:	0f b6 0e             	movzbl (%rsi),%ecx
  8d239e:	0f b6 6e 01          	movzbl 0x1(%rsi),%ebp
  8d23a2:	41 89 c9             	mov    %ecx,%r9d
  8d23a5:	41 89 e8             	mov    %ebp,%r8d
  8d23a8:	84 d2                	test   %dl,%dl
  8d23aa:	75 13                	jne    8d23bf <__putstr+0xbf>
  8d23ac:	eb 68                	jmp    8d2416 <__putstr+0x116>
  8d23ae:	66 90                	xchg   %ax,%ax
  8d23b0:	89 c5                	mov    %eax,%ebp
  8d23b2:	31 c9                	xor    %ecx,%ecx
  8d23b4:	0f b6 13             	movzbl (%rbx),%edx
  8d23b7:	48 83 c3 01          	add    $0x1,%rbx
  8d23bb:	84 d2                	test   %dl,%dl
  8d23bd:	74 44                	je     8d2403 <__putstr+0x103>
  8d23bf:	80 fa 0a             	cmp    $0xa,%dl
  8d23c2:	74 22                	je     8d23e6 <__putstr+0xe6>
  8d23c4:	8b 35 06 ef 01 00    	mov    0x1ef06(%rip),%esi        # 8f12d0 <cols>
  8d23ca:	48 8b 3d 0f ef 01 00 	mov    0x1ef0f(%rip),%rdi        # 8f12e0 <vidmem>
  8d23d1:	89 f0                	mov    %esi,%eax
  8d23d3:	0f af c5             	imul   %ebp,%eax
  8d23d6:	01 c8                	add    %ecx,%eax
  8d23d8:	83 c1 01             	add    $0x1,%ecx
  8d23db:	01 c0                	add    %eax,%eax
  8d23dd:	48 98                	cltq   
  8d23df:	88 14 07             	mov    %dl,(%rdi,%rax,1)
  8d23e2:	39 ce                	cmp    %ecx,%esi
  8d23e4:	7f ce                	jg     8d23b4 <__putstr+0xb4>
  8d23e6:	8d 45 01             	lea    0x1(%rbp),%eax
  8d23e9:	39 05 e5 ee 01 00    	cmp    %eax,0x1eee5(%rip)        # 8f12d4 <lines>
  8d23ef:	7f bf                	jg     8d23b0 <__putstr+0xb0>
  8d23f1:	e8 4a d7 ff ff       	callq  8cfb40 <scroll>
  8d23f6:	0f b6 13             	movzbl (%rbx),%edx
  8d23f9:	48 83 c3 01          	add    $0x1,%rbx
  8d23fd:	31 c9                	xor    %ecx,%ecx
  8d23ff:	84 d2                	test   %dl,%dl
  8d2401:	75 bc                	jne    8d23bf <__putstr+0xbf>
  8d2403:	48 8b 35 56 0f 02 00 	mov    0x20f56(%rip),%rsi        # 8f3360 <boot_params>
  8d240a:	8b 05 c0 ee 01 00    	mov    0x1eec0(%rip),%eax        # 8f12d0 <cols>
  8d2410:	41 89 c9             	mov    %ecx,%r9d
  8d2413:	41 89 e8             	mov    %ebp,%r8d
  8d2416:	0f af e8             	imul   %eax,%ebp
  8d2419:	44 88 0e             	mov    %r9b,(%rsi)
  8d241c:	8b 35 b6 ee 01 00    	mov    0x1eeb6(%rip),%esi        # 8f12d8 <vidport>
  8d2422:	b8 0e 00 00 00       	mov    $0xe,%eax
  8d2427:	48 8b 15 32 0f 02 00 	mov    0x20f32(%rip),%rdx        # 8f3360 <boot_params>
  8d242e:	01 e9                	add    %ebp,%ecx
  8d2430:	44 88 42 01          	mov    %r8b,0x1(%rdx)
  8d2434:	89 f2                	mov    %esi,%edx
  8d2436:	01 c9                	add    %ecx,%ecx
  8d2438:	ee                   	out    %al,(%dx)
  8d2439:	8d 7e 01             	lea    0x1(%rsi),%edi
  8d243c:	89 c8                	mov    %ecx,%eax
  8d243e:	c1 f8 09             	sar    $0x9,%eax
  8d2441:	89 fa                	mov    %edi,%edx
  8d2443:	ee                   	out    %al,(%dx)
  8d2444:	b8 0f 00 00 00       	mov    $0xf,%eax
  8d2449:	89 f2                	mov    %esi,%edx
  8d244b:	ee                   	out    %al,(%dx)
  8d244c:	89 c8                	mov    %ecx,%eax
  8d244e:	89 fa                	mov    %edi,%edx
  8d2450:	d1 f8                	sar    %eax
  8d2452:	ee                   	out    %al,(%dx)
  8d2453:	48 83 c4 08          	add    $0x8,%rsp
  8d2457:	5b                   	pop    %rbx
  8d2458:	5d                   	pop    %rbp
  8d2459:	c3                   	retq   
  8d245a:	c3                   	retq   
  8d245b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d2460:	89 ca                	mov    %ecx,%edx
  8d2462:	ec                   	in     (%dx),%al
  8d2463:	a8 20                	test   $0x20,%al
  8d2465:	75 21                	jne    8d2488 <__putstr+0x188>
  8d2467:	41 b8 fe ff 00 00    	mov    $0xfffe,%r8d
  8d246d:	eb 07                	jmp    8d2476 <__putstr+0x176>
  8d246f:	90                   	nop
  8d2470:	41 83 e8 01          	sub    $0x1,%r8d
  8d2474:	74 12                	je     8d2488 <__putstr+0x188>
  8d2476:	f3 90                	pause  
  8d2478:	8b 35 6e 0f 02 00    	mov    0x20f6e(%rip),%esi        # 8f33ec <early_serial_base>
  8d247e:	8d 4e 05             	lea    0x5(%rsi),%ecx
  8d2481:	89 ca                	mov    %ecx,%edx
  8d2483:	ec                   	in     (%dx),%al
  8d2484:	a8 20                	test   $0x20,%al
  8d2486:	74 e8                	je     8d2470 <__putstr+0x170>
  8d2488:	44 89 d0             	mov    %r10d,%eax
  8d248b:	89 f2                	mov    %esi,%edx
  8d248d:	ee                   	out    %al,(%dx)
  8d248e:	e9 98 fe ff ff       	jmpq   8d232b <__putstr+0x2b>
  8d2493:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d249a:	00 00 00 00 
  8d249e:	66 90                	xchg   %ax,%ax

00000000008d24a0 <__puthex>:
  8d24a0:	f3 0f 1e fa          	endbr64 
  8d24a4:	41 54                	push   %r12
  8d24a6:	b8 30 00 00 00       	mov    $0x30,%eax
  8d24ab:	55                   	push   %rbp
  8d24ac:	48 89 fd             	mov    %rdi,%rbp
  8d24af:	53                   	push   %rbx
  8d24b0:	bb 3c 00 00 00       	mov    $0x3c,%ebx
  8d24b5:	48 83 ec 10          	sub    $0x10,%rsp
  8d24b9:	66 89 44 24 0e       	mov    %ax,0xe(%rsp)
  8d24be:	4c 8d 64 24 0e       	lea    0xe(%rsp),%r12
  8d24c3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d24c8:	89 d9                	mov    %ebx,%ecx
  8d24ca:	48 89 e8             	mov    %rbp,%rax
  8d24cd:	4c 89 e7             	mov    %r12,%rdi
  8d24d0:	48 d3 e8             	shr    %cl,%rax
  8d24d3:	83 e0 0f             	and    $0xf,%eax
  8d24d6:	8d 48 30             	lea    0x30(%rax),%ecx
  8d24d9:	48 83 f8 09          	cmp    $0x9,%rax
  8d24dd:	8d 50 57             	lea    0x57(%rax),%edx
  8d24e0:	89 c8                	mov    %ecx,%eax
  8d24e2:	0f 47 c2             	cmova  %edx,%eax
  8d24e5:	83 eb 04             	sub    $0x4,%ebx
  8d24e8:	88 44 24 0e          	mov    %al,0xe(%rsp)
  8d24ec:	e8 0f fe ff ff       	callq  8d2300 <__putstr>
  8d24f1:	83 fb fc             	cmp    $0xfffffffc,%ebx
  8d24f4:	75 d2                	jne    8d24c8 <__puthex+0x28>
  8d24f6:	48 83 c4 10          	add    $0x10,%rsp
  8d24fa:	5b                   	pop    %rbx
  8d24fb:	5d                   	pop    %rbp
  8d24fc:	41 5c                	pop    %r12
  8d24fe:	c3                   	retq   
  8d24ff:	90                   	nop

00000000008d2500 <extract_kernel>:
  8d2500:	f3 0f 1e fa          	endbr64 
  8d2504:	41 57                	push   %r15
  8d2506:	49 89 ff             	mov    %rdi,%r15
  8d2509:	41 56                	push   %r14
  8d250b:	49 89 f6             	mov    %rsi,%r14
  8d250e:	41 55                	push   %r13
  8d2510:	49 89 d5             	mov    %rdx,%r13
  8d2513:	41 54                	push   %r12
  8d2515:	4d 89 c4             	mov    %r8,%r12
  8d2518:	55                   	push   %rbp
  8d2519:	4c 89 cd             	mov    %r9,%rbp
  8d251c:	53                   	push   %rbx
  8d251d:	48 89 cb             	mov    %rcx,%rbx
  8d2520:	48 81 ec b8 00 00 00 	sub    $0xb8,%rsp
  8d2527:	80 a7 11 02 00 00 fd 	andb   $0xfd,0x211(%rdi)
  8d252e:	80 bf ef 01 00 00 00 	cmpb   $0x0,0x1ef(%rdi)
  8d2535:	48 89 3d 24 0e 02 00 	mov    %rdi,0x20e24(%rip)        # 8f3360 <boot_params>
  8d253c:	0f 85 ae 02 00 00    	jne    8d27f0 <extract_kernel+0x2f0>
  8d2542:	41 80 7f 06 07       	cmpb   $0x7,0x6(%r15)
  8d2547:	0f 84 83 02 00 00    	je     8d27d0 <extract_kernel+0x2d0>
  8d254d:	48 c7 05 88 ed 01 00 	movq   $0xb8000,0x1ed88(%rip)        # 8f12e0 <vidmem>
  8d2554:	00 80 0b 00 
  8d2558:	c7 05 76 ed 01 00 d4 	movl   $0x3d4,0x1ed76(%rip)        # 8f12d8 <vidport>
  8d255f:	03 00 00 
  8d2562:	41 0f b6 47 0e       	movzbl 0xe(%r15),%eax
  8d2567:	89 05 67 ed 01 00    	mov    %eax,0x1ed67(%rip)        # 8f12d4 <lines>
  8d256d:	41 0f b6 47 07       	movzbl 0x7(%r15),%eax
  8d2572:	89 05 58 ed 01 00    	mov    %eax,0x1ed58(%rip)        # 8f12d0 <cols>
  8d2578:	e8 43 12 00 00       	callq  8d37c0 <console_init>
  8d257d:	4c 8b 3d dc 0d 02 00 	mov    0x20ddc(%rip),%r15        # 8f3360 <boot_params>
  8d2584:	e8 d7 25 00 00       	callq  8d4b60 <get_rsdp_addr>
  8d2589:	48 8d 3d 98 8e 00 00 	lea    0x8e98(%rip),%rdi        # 8db428 <kernel_info_end+0x298>
  8d2590:	49 89 47 70          	mov    %rax,0x70(%r15)
  8d2594:	41 bf 00 80 e2 01    	mov    $0x1e28000,%r15d
  8d259a:	e8 61 fd ff ff       	callq  8d2300 <__putstr>
  8d259f:	48 81 fd 00 80 e2 01 	cmp    $0x1e28000,%rbp
  8d25a6:	49 8d 86 00 00 01 00 	lea    0x10000(%r14),%rax
  8d25ad:	48 8d 3d 1c 8d 00 00 	lea    0x8d1c(%rip),%rdi        # 8db2d0 <kernel_info_end+0x140>
  8d25b4:	4c 0f 43 fd          	cmovae %rbp,%r15
  8d25b8:	48 89 05 a9 0d 02 00 	mov    %rax,0x20da9(%rip)        # 8f3368 <free_mem_end_ptr>
  8d25bf:	4c 89 35 aa 0d 02 00 	mov    %r14,0x20daa(%rip)        # 8f3370 <free_mem_ptr>
  8d25c6:	e8 35 fd ff ff       	callq  8d2300 <__putstr>
  8d25cb:	4c 89 ef             	mov    %r13,%rdi
  8d25ce:	e8 cd fe ff ff       	callq  8d24a0 <__puthex>
  8d25d3:	48 8d 3d 51 90 00 00 	lea    0x9051(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d25da:	e8 21 fd ff ff       	callq  8d2300 <__putstr>
  8d25df:	48 8d 3d f9 8c 00 00 	lea    0x8cf9(%rip),%rdi        # 8db2df <kernel_info_end+0x14f>
  8d25e6:	e8 15 fd ff ff       	callq  8d2300 <__putstr>
  8d25eb:	48 89 df             	mov    %rbx,%rdi
  8d25ee:	e8 ad fe ff ff       	callq  8d24a0 <__puthex>
  8d25f3:	48 8d 3d 31 90 00 00 	lea    0x9031(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d25fa:	e8 01 fd ff ff       	callq  8d2300 <__putstr>
  8d25ff:	48 8d 3d e7 8c 00 00 	lea    0x8ce7(%rip),%rdi        # 8db2ed <kernel_info_end+0x15d>
  8d2606:	e8 f5 fc ff ff       	callq  8d2300 <__putstr>
  8d260b:	4c 89 e7             	mov    %r12,%rdi
  8d260e:	e8 8d fe ff ff       	callq  8d24a0 <__puthex>
  8d2613:	48 8d 3d 11 90 00 00 	lea    0x9011(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d261a:	e8 e1 fc ff ff       	callq  8d2300 <__putstr>
  8d261f:	48 8d 3d d2 8c 00 00 	lea    0x8cd2(%rip),%rdi        # 8db2f8 <kernel_info_end+0x168>
  8d2626:	e8 d5 fc ff ff       	callq  8d2300 <__putstr>
  8d262b:	48 89 ef             	mov    %rbp,%rdi
  8d262e:	e8 6d fe ff ff       	callq  8d24a0 <__puthex>
  8d2633:	48 8d 3d f1 8f 00 00 	lea    0x8ff1(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d263a:	e8 c1 fc ff ff       	callq  8d2300 <__putstr>
  8d263f:	48 8d 3d c1 8c 00 00 	lea    0x8cc1(%rip),%rdi        # 8db307 <kernel_info_end+0x177>
  8d2646:	e8 b5 fc ff ff       	callq  8d2300 <__putstr>
  8d264b:	bf 00 80 e2 01       	mov    $0x1e28000,%edi
  8d2650:	e8 4b fe ff ff       	callq  8d24a0 <__puthex>
  8d2655:	48 8d 3d cf 8f 00 00 	lea    0x8fcf(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d265c:	e8 9f fc ff ff       	callq  8d2300 <__putstr>
  8d2661:	48 8d 3d b5 8c 00 00 	lea    0x8cb5(%rip),%rdi        # 8db31d <kernel_info_end+0x18d>
  8d2668:	e8 93 fc ff ff       	callq  8d2300 <__putstr>
  8d266d:	49 8d bf ff ff 1f 00 	lea    0x1fffff(%r15),%rdi
  8d2674:	48 81 e7 00 00 e0 ff 	and    $0xffffffffffe00000,%rdi
  8d267b:	e8 20 fe ff ff       	callq  8d24a0 <__puthex>
  8d2680:	48 8d 3d a4 8f 00 00 	lea    0x8fa4(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d2687:	e8 74 fc ff ff       	callq  8d2300 <__putstr>
  8d268c:	48 8d 3d 9a 8c 00 00 	lea    0x8c9a(%rip),%rdi        # 8db32d <kernel_info_end+0x19d>
  8d2693:	e8 68 fc ff ff       	callq  8d2300 <__putstr>
  8d2698:	48 8b 3d 81 9b 00 00 	mov    0x9b81(%rip),%rdi        # 8dc220 <trampoline_32bit>
  8d269f:	e8 fc fd ff ff       	callq  8d24a0 <__puthex>
  8d26a4:	48 8d 3d 80 8f 00 00 	lea    0x8f80(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d26ab:	e8 50 fc ff ff       	callq  8d2300 <__putstr>
  8d26b0:	41 f7 c4 ff ff 1f 00 	test   $0x1fffff,%r12d
  8d26b7:	0f 85 93 04 00 00    	jne    8d2b50 <extract_kernel+0x650>
  8d26bd:	48 b8 ff ff ff ff ff 	movabs $0x3fffffffffff,%rax
  8d26c4:	3f 00 00 
  8d26c7:	49 39 c6             	cmp    %rax,%r14
  8d26ca:	0f 87 74 04 00 00    	ja     8d2b44 <extract_kernel+0x644>
  8d26d0:	49 81 c7 00 00 00 01 	add    $0x1000000,%r15
  8d26d7:	49 81 ff 00 00 00 20 	cmp    $0x20000000,%r15
  8d26de:	0f 87 78 04 00 00    	ja     8d2b5c <extract_kernel+0x65c>
  8d26e4:	48 8d 3d 75 8c 00 00 	lea    0x8c75(%rip),%rdi        # 8db360 <kernel_info_end+0x1d0>
  8d26eb:	e8 10 fc ff ff       	callq  8d2300 <__putstr>
  8d26f0:	4d 89 e1             	mov    %r12,%r9
  8d26f3:	48 85 ed             	test   %rbp,%rbp
  8d26f6:	49 f7 d1             	not    %r9
  8d26f9:	4c 0f 45 cd          	cmovne %rbp,%r9
  8d26fd:	4d 85 e4             	test   %r12,%r12
  8d2700:	0f 84 10 04 00 00    	je     8d2b16 <extract_kernel+0x616>
  8d2706:	4d 89 ee             	mov    %r13,%r14
  8d2709:	4d 85 ed             	test   %r13,%r13
  8d270c:	0f 84 96 01 00 00    	je     8d28a8 <extract_kernel+0x3a8>
  8d2712:	bf 60 00 00 00       	mov    $0x60,%edi
  8d2717:	e8 e4 d2 ff ff       	callq  8cfa00 <malloc>
  8d271c:	49 89 c7             	mov    %rax,%r15
  8d271f:	48 85 c0             	test   %rax,%rax
  8d2722:	0f 84 b8 01 00 00    	je     8d28e0 <extract_kernel+0x3e0>
  8d2728:	bf 48 25 00 00       	mov    $0x2548,%edi
  8d272d:	e8 ce d2 ff ff       	callq  8cfa00 <malloc>
  8d2732:	49 89 47 40          	mov    %rax,0x40(%r15)
  8d2736:	48 85 c0             	test   %rax,%rax
  8d2739:	0f 84 91 01 00 00    	je     8d28d0 <extract_kernel+0x3d0>
  8d273f:	48 85 db             	test   %rbx,%rbx
  8d2742:	75 10                	jne    8d2754 <extract_kernel+0x254>
  8d2744:	be 00 40 00 00       	mov    $0x4000,%esi
  8d2749:	4c 89 f7             	mov    %r14,%rdi
  8d274c:	e8 ff d2 ff ff       	callq  8cfa50 <nofill>
  8d2751:	48 89 c3             	mov    %rax,%rbx
  8d2754:	48 83 fb 09          	cmp    $0x9,%rbx
  8d2758:	7e 66                	jle    8d27c0 <extract_kernel+0x2c0>
  8d275a:	41 80 3e 1f          	cmpb   $0x1f,(%r14)
  8d275e:	75 60                	jne    8d27c0 <extract_kernel+0x2c0>
  8d2760:	41 80 7e 01 8b       	cmpb   $0x8b,0x1(%r14)
  8d2765:	75 59                	jne    8d27c0 <extract_kernel+0x2c0>
  8d2767:	41 80 7e 02 08       	cmpb   $0x8,0x2(%r14)
  8d276c:	75 52                	jne    8d27c0 <extract_kernel+0x2c0>
  8d276e:	49 8d 46 0a          	lea    0xa(%r14),%rax
  8d2772:	48 83 eb 0a          	sub    $0xa,%rbx
  8d2776:	49 89 07             	mov    %rax,(%r15)
  8d2779:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  8d277d:	41 f6 46 03 08       	testb  $0x8,0x3(%r14)
  8d2782:	75 27                	jne    8d27ab <extract_kernel+0x2ab>
  8d2784:	e9 67 01 00 00       	jmpq   8d28f0 <extract_kernel+0x3f0>
  8d2789:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d2790:	49 8b 07             	mov    (%r15),%rax
  8d2793:	48 83 eb 01          	sub    $0x1,%rbx
  8d2797:	49 89 5f 08          	mov    %rbx,0x8(%r15)
  8d279b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8d279f:	49 89 17             	mov    %rdx,(%r15)
  8d27a2:	80 38 00             	cmpb   $0x0,(%rax)
  8d27a5:	0f 84 45 01 00 00    	je     8d28f0 <extract_kernel+0x3f0>
  8d27ab:	48 85 db             	test   %rbx,%rbx
  8d27ae:	75 e0                	jne    8d2790 <extract_kernel+0x290>
  8d27b0:	48 8d 3d d2 8b 00 00 	lea    0x8bd2(%rip),%rdi        # 8db389 <kernel_info_end+0x1f9>
  8d27b7:	e8 d4 0d 00 00       	callq  8d3590 <error>
  8d27bc:	0f 1f 40 00          	nopl   0x0(%rax)
  8d27c0:	48 8d 3d b2 8b 00 00 	lea    0x8bb2(%rip),%rdi        # 8db379 <kernel_info_end+0x1e9>
  8d27c7:	e8 c4 0d 00 00       	callq  8d3590 <error>
  8d27cc:	0f 1f 40 00          	nopl   0x0(%rax)
  8d27d0:	48 c7 05 05 eb 01 00 	movq   $0xb0000,0x1eb05(%rip)        # 8f12e0 <vidmem>
  8d27d7:	00 00 0b 00 
  8d27db:	c7 05 f3 ea 01 00 b4 	movl   $0x3b4,0x1eaf3(%rip)        # 8f12d8 <vidport>
  8d27e2:	03 00 00 
  8d27e5:	e9 78 fd ff ff       	jmpq   8d2562 <extract_kernel+0x62>
  8d27ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d27f0:	b8 13 00 00 00       	mov    $0x13,%eax
  8d27f5:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  8d27fa:	48 8d 35 df 7c 00 00 	lea    0x7cdf(%rip),%rsi        # 8da4e0 <startup32_check_sev_cbit+0xa0>
  8d2801:	48 89 c1             	mov    %rax,%rcx
  8d2804:	4c 8d 05 b5 da 01 00 	lea    0x1dab5(%rip),%r8        # 8f02c0 <scratch.30438>
  8d280b:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d280e:	4c 89 c7             	mov    %r8,%rdi
  8d2811:	48 89 c8             	mov    %rcx,%rax
  8d2814:	b9 00 02 00 00       	mov    $0x200,%ecx
  8d2819:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  8d281c:	48 8d 84 24 a8 00 00 	lea    0xa8(%rsp),%rax
  8d2823:	00 
  8d2824:	48 8d 4c 24 10       	lea    0x10(%rsp),%rcx
  8d2829:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d282e:	66 90                	xchg   %ax,%ax
  8d2830:	8b 01                	mov    (%rcx),%eax
  8d2832:	8b 51 04             	mov    0x4(%rcx),%edx
  8d2835:	48 89 0c 24          	mov    %rcx,(%rsp)
  8d2839:	49 8d 3c 00          	lea    (%r8,%rax,1),%rdi
  8d283d:	49 8d 34 07          	lea    (%r15,%rax,1),%rsi
  8d2841:	e8 aa 08 00 00       	callq  8d30f0 <memcpy>
  8d2846:	48 8b 0c 24          	mov    (%rsp),%rcx
  8d284a:	4c 8d 05 6f da 01 00 	lea    0x1da6f(%rip),%r8        # 8f02c0 <scratch.30438>
  8d2851:	48 83 c1 08          	add    $0x8,%rcx
  8d2855:	48 3b 4c 24 08       	cmp    0x8(%rsp),%rcx
  8d285a:	75 d4                	jne    8d2830 <extract_kernel+0x330>
  8d285c:	49 8d 7f 08          	lea    0x8(%r15),%rdi
  8d2860:	49 8b 00             	mov    (%r8),%rax
  8d2863:	4d 89 fa             	mov    %r15,%r10
  8d2866:	4c 89 c6             	mov    %r8,%rsi
  8d2869:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
  8d286d:	49 29 fa             	sub    %rdi,%r10
  8d2870:	49 89 07             	mov    %rax,(%r15)
  8d2873:	48 8b 05 3e ea 01 00 	mov    0x1ea3e(%rip),%rax        # 8f12b8 <scratch.30438+0xff8>
  8d287a:	4c 29 d6             	sub    %r10,%rsi
  8d287d:	41 81 c2 00 10 00 00 	add    $0x1000,%r10d
  8d2884:	41 c1 ea 03          	shr    $0x3,%r10d
  8d2888:	49 89 87 f8 0f 00 00 	mov    %rax,0xff8(%r15)
  8d288f:	44 89 d1             	mov    %r10d,%ecx
  8d2892:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d2895:	4c 8b 3d c4 0a 02 00 	mov    0x20ac4(%rip),%r15        # 8f3360 <boot_params>
  8d289c:	e9 a1 fc ff ff       	jmpq   8d2542 <extract_kernel+0x42>
  8d28a1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d28a8:	bf 00 40 00 00       	mov    $0x4000,%edi
  8d28ad:	e8 4e d1 ff ff       	callq  8cfa00 <malloc>
  8d28b2:	49 89 c6             	mov    %rax,%r14
  8d28b5:	48 85 c0             	test   %rax,%rax
  8d28b8:	0f 85 ce 02 00 00    	jne    8d2b8c <extract_kernel+0x68c>
  8d28be:	48 8d 3d 33 8c 00 00 	lea    0x8c33(%rip),%rdi        # 8db4f8 <kernel_info_end+0x368>
  8d28c5:	e8 c6 0c 00 00       	callq  8d3590 <error>
  8d28ca:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d28d0:	48 8d 3d 79 8c 00 00 	lea    0x8c79(%rip),%rdi        # 8db550 <kernel_info_end+0x3c0>
  8d28d7:	e8 b4 0c 00 00       	callq  8d3590 <error>
  8d28dc:	0f 1f 40 00          	nopl   0x0(%rax)
  8d28e0:	48 8d 3d 41 8c 00 00 	lea    0x8c41(%rip),%rdi        # 8db528 <kernel_info_end+0x398>
  8d28e7:	e8 a4 0c 00 00       	callq  8d3590 <error>
  8d28ec:	0f 1f 40 00          	nopl   0x0(%rax)
  8d28f0:	4d 89 67 18          	mov    %r12,0x18(%r15)
  8d28f4:	be f1 ff ff ff       	mov    $0xfffffff1,%esi
  8d28f9:	4c 89 ff             	mov    %r15,%rdi
  8d28fc:	4d 89 4f 20          	mov    %r9,0x20(%r15)
  8d2900:	e8 9b de ff ff       	callq  8d07a0 <zlib_inflateInit2>
  8d2905:	49 8b 57 40          	mov    0x40(%r15),%rdx
  8d2909:	c7 42 2c 00 00 00 00 	movl   $0x0,0x2c(%rdx)
  8d2910:	49 8b 57 40          	mov    0x40(%r15),%rdx
  8d2914:	48 c7 42 38 00 00 00 	movq   $0x0,0x38(%rdx)
  8d291b:	00 
  8d291c:	85 c0                	test   %eax,%eax
  8d291e:	74 10                	je     8d2930 <extract_kernel+0x430>
  8d2920:	eb 41                	jmp    8d2963 <extract_kernel+0x463>
  8d2922:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d2928:	85 c0                	test   %eax,%eax
  8d292a:	0f 85 ce 01 00 00    	jne    8d2afe <extract_kernel+0x5fe>
  8d2930:	49 83 7f 08 00       	cmpq   $0x0,0x8(%r15)
  8d2935:	75 1d                	jne    8d2954 <extract_kernel+0x454>
  8d2937:	be 00 40 00 00       	mov    $0x4000,%esi
  8d293c:	4c 89 f7             	mov    %r14,%rdi
  8d293f:	e8 0c d1 ff ff       	callq  8cfa50 <nofill>
  8d2944:	48 85 c0             	test   %rax,%rax
  8d2947:	0f 88 bd 01 00 00    	js     8d2b0a <extract_kernel+0x60a>
  8d294d:	4d 89 37             	mov    %r14,(%r15)
  8d2950:	49 89 47 08          	mov    %rax,0x8(%r15)
  8d2954:	31 f6                	xor    %esi,%esi
  8d2956:	4c 89 ff             	mov    %r15,%rdi
  8d2959:	e8 a2 de ff ff       	callq  8d0800 <zlib_inflate>
  8d295e:	83 f8 01             	cmp    $0x1,%eax
  8d2961:	75 c5                	jne    8d2928 <extract_kernel+0x428>
  8d2963:	8b 05 57 e9 01 00    	mov    0x1e957(%rip),%eax        # 8f12c0 <malloc_count>
  8d2969:	8d 50 fe             	lea    -0x2(%rax),%edx
  8d296c:	83 f8 01             	cmp    $0x1,%eax
  8d296f:	0f 85 68 01 00 00    	jne    8d2add <extract_kernel+0x5dd>
  8d2975:	48 8b 15 f4 09 02 00 	mov    0x209f4(%rip),%rdx        # 8f3370 <free_mem_ptr>
  8d297c:	c7 05 3a e9 01 00 ff 	movl   $0xffffffff,0x1e93a(%rip)        # 8f12c0 <malloc_count>
  8d2983:	ff ff ff 
  8d2986:	48 89 15 3b e9 01 00 	mov    %rdx,0x1e93b(%rip)        # 8f12c8 <malloc_ptr>
  8d298d:	4d 85 ed             	test   %r13,%r13
  8d2990:	0f 84 8c 01 00 00    	je     8d2b22 <extract_kernel+0x622>
  8d2996:	49 8b 54 24 08       	mov    0x8(%r12),%rdx
  8d299b:	49 8b 04 24          	mov    (%r12),%rax
  8d299f:	4d 8b 74 24 20       	mov    0x20(%r12),%r14
  8d29a4:	45 0f b7 6c 24 38    	movzwl 0x38(%r12),%r13d
  8d29aa:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  8d29af:	49 8b 54 24 10       	mov    0x10(%r12),%rdx
  8d29b4:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d29b9:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
  8d29be:	49 8b 54 24 18       	mov    0x18(%r12),%rdx
  8d29c3:	4c 89 74 24 30       	mov    %r14,0x30(%rsp)
  8d29c8:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  8d29cd:	49 8b 54 24 28       	mov    0x28(%r12),%rdx
  8d29d2:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  8d29d7:	49 8b 54 24 30       	mov    0x30(%r12),%rdx
  8d29dc:	48 89 54 24 40       	mov    %rdx,0x40(%rsp)
  8d29e1:	49 8b 54 24 38       	mov    0x38(%r12),%rdx
  8d29e6:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  8d29eb:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
  8d29f0:	0f 85 8a 01 00 00    	jne    8d2b80 <extract_kernel+0x680>
  8d29f6:	48 8d 3d b8 89 00 00 	lea    0x89b8(%rip),%rdi        # 8db3b5 <kernel_info_end+0x225>
  8d29fd:	41 0f b7 ed          	movzwl %r13w,%ebp
  8d2a01:	e8 fa f8 ff ff       	callq  8d2300 <__putstr>
  8d2a06:	6b fd 38             	imul   $0x38,%ebp,%edi
  8d2a09:	e8 f2 cf ff ff       	callq  8cfa00 <malloc>
  8d2a0e:	48 89 c3             	mov    %rax,%rbx
  8d2a11:	48 85 c0             	test   %rax,%rax
  8d2a14:	0f 84 4e 01 00 00    	je     8d2b68 <extract_kernel+0x668>
  8d2a1a:	41 0f b7 c5          	movzwl %r13w,%eax
  8d2a1e:	4b 8d 34 34          	lea    (%r12,%r14,1),%rsi
  8d2a22:	48 89 df             	mov    %rbx,%rdi
  8d2a25:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8d2a2c:	00 
  8d2a2d:	48 29 c2             	sub    %rax,%rdx
  8d2a30:	48 c1 e2 03          	shl    $0x3,%rdx
  8d2a34:	e8 b7 06 00 00       	callq  8d30f0 <memcpy>
  8d2a39:	66 45 85 ed          	test   %r13w,%r13w
  8d2a3d:	74 61                	je     8d2aa0 <extract_kernel+0x5a0>
  8d2a3f:	8d 45 ff             	lea    -0x1(%rbp),%eax
  8d2a42:	48 83 c0 01          	add    $0x1,%rax
  8d2a46:	48 8d 14 c5 00 00 00 	lea    0x0(,%rax,8),%rdx
  8d2a4d:	00 
  8d2a4e:	48 29 c2             	sub    %rax,%rdx
  8d2a51:	48 8d 2c d3          	lea    (%rbx,%rdx,8),%rbp
  8d2a55:	eb 12                	jmp    8d2a69 <extract_kernel+0x569>
  8d2a57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d2a5e:	00 00 
  8d2a60:	48 83 c3 38          	add    $0x38,%rbx
  8d2a64:	48 39 dd             	cmp    %rbx,%rbp
  8d2a67:	74 37                	je     8d2aa0 <extract_kernel+0x5a0>
  8d2a69:	83 3b 01             	cmpl   $0x1,(%rbx)
  8d2a6c:	75 f2                	jne    8d2a60 <extract_kernel+0x560>
  8d2a6e:	f7 43 30 ff ff 1f 00 	testl  $0x1fffff,0x30(%rbx)
  8d2a75:	0f 85 f9 00 00 00    	jne    8d2b74 <extract_kernel+0x674>
  8d2a7b:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  8d2a7f:	48 8b 43 18          	mov    0x18(%rbx),%rax
  8d2a83:	48 8b 53 20          	mov    0x20(%rbx),%rdx
  8d2a87:	4c 01 e6             	add    %r12,%rsi
  8d2a8a:	49 8d bc 04 00 00 00 	lea    -0x1000000(%r12,%rax,1),%rdi
  8d2a91:	ff 
  8d2a92:	e8 09 06 00 00       	callq  8d30a0 <memmove>
  8d2a97:	eb c7                	jmp    8d2a60 <extract_kernel+0x560>
  8d2a99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d2aa0:	83 2d 19 e8 01 00 01 	subl   $0x1,0x1e819(%rip)        # 8f12c0 <malloc_count>
  8d2aa7:	75 0e                	jne    8d2ab7 <extract_kernel+0x5b7>
  8d2aa9:	48 8b 05 c0 08 02 00 	mov    0x208c0(%rip),%rax        # 8f3370 <free_mem_ptr>
  8d2ab0:	48 89 05 11 e8 01 00 	mov    %rax,0x1e811(%rip)        # 8f12c8 <malloc_ptr>
  8d2ab7:	48 8d 3d 07 89 00 00 	lea    0x8907(%rip),%rdi        # 8db3c5 <kernel_info_end+0x235>
  8d2abe:	e8 3d f8 ff ff       	callq  8d2300 <__putstr>
  8d2ac3:	e8 78 19 00 00       	callq  8d4440 <cleanup_exception_handling>
  8d2ac8:	4c 89 e0             	mov    %r12,%rax
  8d2acb:	48 81 c4 b8 00 00 00 	add    $0xb8,%rsp
  8d2ad2:	5b                   	pop    %rbx
  8d2ad3:	5d                   	pop    %rbp
  8d2ad4:	41 5c                	pop    %r12
  8d2ad6:	41 5d                	pop    %r13
  8d2ad8:	41 5e                	pop    %r14
  8d2ada:	41 5f                	pop    %r15
  8d2adc:	c3                   	retq   
  8d2add:	89 15 dd e7 01 00    	mov    %edx,0x1e7dd(%rip)        # 8f12c0 <malloc_count>
  8d2ae3:	85 d2                	test   %edx,%edx
  8d2ae5:	0f 85 a2 fe ff ff    	jne    8d298d <extract_kernel+0x48d>
  8d2aeb:	48 8b 15 7e 08 02 00 	mov    0x2087e(%rip),%rdx        # 8f3370 <free_mem_ptr>
  8d2af2:	48 89 15 cf e7 01 00 	mov    %rdx,0x1e7cf(%rip)        # 8f12c8 <malloc_ptr>
  8d2af9:	e9 8f fe ff ff       	jmpq   8d298d <extract_kernel+0x48d>
  8d2afe:	48 8d 3d 9c 88 00 00 	lea    0x889c(%rip),%rdi        # 8db3a1 <kernel_info_end+0x211>
  8d2b05:	e8 86 0a 00 00       	callq  8d3590 <error>
  8d2b0a:	48 8d 3d 85 88 00 00 	lea    0x8885(%rip),%rdi        # 8db396 <kernel_info_end+0x206>
  8d2b11:	e8 7a 0a 00 00       	callq  8d3590 <error>
  8d2b16:	48 8d 3d ab 89 00 00 	lea    0x89ab(%rip),%rdi        # 8db4c8 <kernel_info_end+0x338>
  8d2b1d:	e8 6e 0a 00 00       	callq  8d3590 <error>
  8d2b22:	83 e8 03             	sub    $0x3,%eax
  8d2b25:	89 05 95 e7 01 00    	mov    %eax,0x1e795(%rip)        # 8f12c0 <malloc_count>
  8d2b2b:	0f 85 65 fe ff ff    	jne    8d2996 <extract_kernel+0x496>
  8d2b31:	48 8b 05 38 08 02 00 	mov    0x20838(%rip),%rax        # 8f3370 <free_mem_ptr>
  8d2b38:	48 89 05 89 e7 01 00 	mov    %rax,0x1e789(%rip)        # 8f12c8 <malloc_ptr>
  8d2b3f:	e9 52 fe ff ff       	jmpq   8d2996 <extract_kernel+0x496>
  8d2b44:	48 8d 3d f7 87 00 00 	lea    0x87f7(%rip),%rdi        # 8db342 <kernel_info_end+0x1b2>
  8d2b4b:	e8 40 0a 00 00       	callq  8d3590 <error>
  8d2b50:	48 8d 3d f9 88 00 00 	lea    0x88f9(%rip),%rdi        # 8db450 <kernel_info_end+0x2c0>
  8d2b57:	e8 34 0a 00 00       	callq  8d3590 <error>
  8d2b5c:	48 8d 3d 25 89 00 00 	lea    0x8925(%rip),%rdi        # 8db488 <kernel_info_end+0x2f8>
  8d2b63:	e8 28 0a 00 00       	callq  8d3590 <error>
  8d2b68:	48 8d 3d 31 8a 00 00 	lea    0x8a31(%rip),%rdi        # 8db5a0 <kernel_info_end+0x410>
  8d2b6f:	e8 1c 0a 00 00       	callq  8d3590 <error>
  8d2b74:	48 8d 3d 4d 8a 00 00 	lea    0x8a4d(%rip),%rdi        # 8db5c8 <kernel_info_end+0x438>
  8d2b7b:	e8 10 0a 00 00       	callq  8d3590 <error>
  8d2b80:	48 8d 3d f9 89 00 00 	lea    0x89f9(%rip),%rdi        # 8db580 <kernel_info_end+0x3f0>
  8d2b87:	e8 04 0a 00 00       	callq  8d3590 <error>
  8d2b8c:	31 db                	xor    %ebx,%ebx
  8d2b8e:	e9 7f fb ff ff       	jmpq   8d2712 <extract_kernel+0x212>
  8d2b93:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d2b9a:	00 00 00 
  8d2b9d:	0f 1f 00             	nopl   (%rax)

00000000008d2ba0 <_kstrtoull>:
  8d2ba0:	41 56                	push   %r14
  8d2ba2:	0f b6 0f             	movzbl (%rdi),%ecx
  8d2ba5:	49 89 d3             	mov    %rdx,%r11
  8d2ba8:	41 55                	push   %r13
  8d2baa:	41 54                	push   %r12
  8d2bac:	55                   	push   %rbp
  8d2bad:	53                   	push   %rbx
  8d2bae:	85 f6                	test   %esi,%esi
  8d2bb0:	0f 85 f2 00 00 00    	jne    8d2ca8 <_kstrtoull+0x108>
  8d2bb6:	be 0a 00 00 00       	mov    $0xa,%esi
  8d2bbb:	80 f9 30             	cmp    $0x30,%cl
  8d2bbe:	0f 84 0c 01 00 00    	je     8d2cd0 <_kstrtoull+0x130>
  8d2bc4:	49 89 fa             	mov    %rdi,%r10
  8d2bc7:	45 31 c0             	xor    %r8d,%r8d
  8d2bca:	45 31 c9             	xor    %r9d,%r9d
  8d2bcd:	89 f3                	mov    %esi,%ebx
  8d2bcf:	49 bc 00 00 00 00 00 	movabs $0xf000000000000000,%r12
  8d2bd6:	00 00 f0 
  8d2bd9:	48 bd 00 00 00 00 ff 	movabs $0xffffffff00000000,%rbp
  8d2be0:	ff ff ff 
  8d2be3:	eb 16                	jmp    8d2bfb <_kstrtoull+0x5b>
  8d2be5:	0f 1f 00             	nopl   (%rax)
  8d2be8:	4c 0f af cb          	imul   %rbx,%r9
  8d2bec:	49 83 c2 01          	add    $0x1,%r10
  8d2bf0:	41 83 c0 01          	add    $0x1,%r8d
  8d2bf4:	49 01 c9             	add    %rcx,%r9
  8d2bf7:	41 0f b6 0a          	movzbl (%r10),%ecx
  8d2bfb:	0f be d1             	movsbl %cl,%edx
  8d2bfe:	8d 42 d0             	lea    -0x30(%rdx),%eax
  8d2c01:	83 f8 09             	cmp    $0x9,%eax
  8d2c04:	76 13                	jbe    8d2c19 <_kstrtoull+0x79>
  8d2c06:	89 c8                	mov    %ecx,%eax
  8d2c08:	83 c8 20             	or     $0x20,%eax
  8d2c0b:	0f be c0             	movsbl %al,%eax
  8d2c0e:	8d 50 9f             	lea    -0x61(%rax),%edx
  8d2c11:	83 fa 05             	cmp    $0x5,%edx
  8d2c14:	77 5a                	ja     8d2c70 <_kstrtoull+0xd0>
  8d2c16:	83 e8 57             	sub    $0x57,%eax
  8d2c19:	39 f0                	cmp    %esi,%eax
  8d2c1b:	73 53                	jae    8d2c70 <_kstrtoull+0xd0>
  8d2c1d:	89 c1                	mov    %eax,%ecx
  8d2c1f:	4d 85 e1             	test   %r12,%r9
  8d2c22:	74 c4                	je     8d2be8 <_kstrtoull+0x48>
  8d2c24:	49 89 cd             	mov    %rcx,%r13
  8d2c27:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d2c2c:	49 f7 d5             	not    %r13
  8d2c2f:	89 c2                	mov    %eax,%edx
  8d2c31:	45 89 ee             	mov    %r13d,%r14d
  8d2c34:	39 f0                	cmp    %esi,%eax
  8d2c36:	72 0e                	jb     8d2c46 <_kstrtoull+0xa6>
  8d2c38:	31 d2                	xor    %edx,%edx
  8d2c3a:	45 89 ee             	mov    %r13d,%r14d
  8d2c3d:	f7 f6                	div    %esi
  8d2c3f:	48 c1 e0 20          	shl    $0x20,%rax
  8d2c43:	49 09 c6             	or     %rax,%r14
  8d2c46:	44 89 e8             	mov    %r13d,%eax
  8d2c49:	f7 f6                	div    %esi
  8d2c4b:	41 89 c5             	mov    %eax,%r13d
  8d2c4e:	4c 89 f0             	mov    %r14,%rax
  8d2c51:	44 89 c2             	mov    %r8d,%edx
  8d2c54:	48 21 e8             	and    %rbp,%rax
  8d2c57:	81 ca 00 00 00 80    	or     $0x80000000,%edx
  8d2c5d:	4c 09 e8             	or     %r13,%rax
  8d2c60:	49 39 c1             	cmp    %rax,%r9
  8d2c63:	44 0f 47 c2          	cmova  %edx,%r8d
  8d2c67:	e9 7c ff ff ff       	jmpq   8d2be8 <_kstrtoull+0x48>
  8d2c6c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d2c70:	45 85 c0             	test   %r8d,%r8d
  8d2c73:	0f 88 a9 00 00 00    	js     8d2d22 <_kstrtoull+0x182>
  8d2c79:	0f 84 99 00 00 00    	je     8d2d18 <_kstrtoull+0x178>
  8d2c7f:	49 01 f8             	add    %rdi,%r8
  8d2c82:	41 0f b6 00          	movzbl (%r8),%eax
  8d2c86:	3c 0a                	cmp    $0xa,%al
  8d2c88:	75 05                	jne    8d2c8f <_kstrtoull+0xef>
  8d2c8a:	41 0f b6 40 01       	movzbl 0x1(%r8),%eax
  8d2c8f:	84 c0                	test   %al,%al
  8d2c91:	0f 85 81 00 00 00    	jne    8d2d18 <_kstrtoull+0x178>
  8d2c97:	4d 89 0b             	mov    %r9,(%r11)
  8d2c9a:	31 c0                	xor    %eax,%eax
  8d2c9c:	5b                   	pop    %rbx
  8d2c9d:	5d                   	pop    %rbp
  8d2c9e:	41 5c                	pop    %r12
  8d2ca0:	41 5d                	pop    %r13
  8d2ca2:	41 5e                	pop    %r14
  8d2ca4:	c3                   	retq   
  8d2ca5:	0f 1f 00             	nopl   (%rax)
  8d2ca8:	83 fe 10             	cmp    $0x10,%esi
  8d2cab:	0f 85 13 ff ff ff    	jne    8d2bc4 <_kstrtoull+0x24>
  8d2cb1:	80 f9 30             	cmp    $0x30,%cl
  8d2cb4:	0f 85 0a ff ff ff    	jne    8d2bc4 <_kstrtoull+0x24>
  8d2cba:	0f b6 47 01          	movzbl 0x1(%rdi),%eax
  8d2cbe:	83 c8 20             	or     $0x20,%eax
  8d2cc1:	3c 78                	cmp    $0x78,%al
  8d2cc3:	0f 85 fb fe ff ff    	jne    8d2bc4 <_kstrtoull+0x24>
  8d2cc9:	0f b6 57 02          	movzbl 0x2(%rdi),%edx
  8d2ccd:	eb 33                	jmp    8d2d02 <_kstrtoull+0x162>
  8d2ccf:	90                   	nop
  8d2cd0:	0f b6 47 01          	movzbl 0x1(%rdi),%eax
  8d2cd4:	be 08 00 00 00       	mov    $0x8,%esi
  8d2cd9:	83 c8 20             	or     $0x20,%eax
  8d2cdc:	3c 78                	cmp    $0x78,%al
  8d2cde:	0f 85 e0 fe ff ff    	jne    8d2bc4 <_kstrtoull+0x24>
  8d2ce4:	0f be 47 02          	movsbl 0x2(%rdi),%eax
  8d2ce8:	89 c2                	mov    %eax,%edx
  8d2cea:	83 e8 30             	sub    $0x30,%eax
  8d2ced:	83 f8 09             	cmp    $0x9,%eax
  8d2cf0:	76 10                	jbe    8d2d02 <_kstrtoull+0x162>
  8d2cf2:	89 d0                	mov    %edx,%eax
  8d2cf4:	83 e0 df             	and    $0xffffffdf,%eax
  8d2cf7:	83 e8 41             	sub    $0x41,%eax
  8d2cfa:	3c 05                	cmp    $0x5,%al
  8d2cfc:	0f 87 c2 fe ff ff    	ja     8d2bc4 <_kstrtoull+0x24>
  8d2d02:	89 d1                	mov    %edx,%ecx
  8d2d04:	48 83 c7 02          	add    $0x2,%rdi
  8d2d08:	be 10 00 00 00       	mov    $0x10,%esi
  8d2d0d:	e9 b2 fe ff ff       	jmpq   8d2bc4 <_kstrtoull+0x24>
  8d2d12:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d2d18:	b8 ea ff ff ff       	mov    $0xffffffea,%eax
  8d2d1d:	e9 7a ff ff ff       	jmpq   8d2c9c <_kstrtoull+0xfc>
  8d2d22:	b8 de ff ff ff       	mov    $0xffffffde,%eax
  8d2d27:	e9 70 ff ff ff       	jmpq   8d2c9c <_kstrtoull+0xfc>
  8d2d2c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d2d30 <memcmp>:
  8d2d30:	f3 0f 1e fa          	endbr64 
  8d2d34:	48 89 d1             	mov    %rdx,%rcx
  8d2d37:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  8d2d39:	0f 95 c0             	setne  %al
  8d2d3c:	0f b6 c0             	movzbl %al,%eax
  8d2d3f:	c3                   	retq   

00000000008d2d40 <bcmp>:
  8d2d40:	f3 0f 1e fa          	endbr64 
  8d2d44:	48 89 d1             	mov    %rdx,%rcx
  8d2d47:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  8d2d49:	0f 95 c0             	setne  %al
  8d2d4c:	0f b6 c0             	movzbl %al,%eax
  8d2d4f:	c3                   	retq   

00000000008d2d50 <strcmp>:
  8d2d50:	f3 0f 1e fa          	endbr64 
  8d2d54:	31 c9                	xor    %ecx,%ecx
  8d2d56:	eb 10                	jmp    8d2d68 <strcmp+0x18>
  8d2d58:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d2d5f:	00 
  8d2d60:	48 83 c1 01          	add    $0x1,%rcx
  8d2d64:	29 d0                	sub    %edx,%eax
  8d2d66:	75 12                	jne    8d2d7a <strcmp+0x2a>
  8d2d68:	0f b6 04 0f          	movzbl (%rdi,%rcx,1),%eax
  8d2d6c:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  8d2d70:	41 89 c0             	mov    %eax,%r8d
  8d2d73:	41 08 d0             	or     %dl,%r8b
  8d2d76:	75 e8                	jne    8d2d60 <strcmp+0x10>
  8d2d78:	31 c0                	xor    %eax,%eax
  8d2d7a:	c3                   	retq   
  8d2d7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008d2d80 <strncmp>:
  8d2d80:	f3 0f 1e fa          	endbr64 
  8d2d84:	48 85 d2             	test   %rdx,%rdx
  8d2d87:	74 27                	je     8d2db0 <strncmp+0x30>
  8d2d89:	31 c0                	xor    %eax,%eax
  8d2d8b:	eb 10                	jmp    8d2d9d <strncmp+0x1d>
  8d2d8d:	0f 1f 00             	nopl   (%rax)
  8d2d90:	84 c9                	test   %cl,%cl
  8d2d92:	74 1c                	je     8d2db0 <strncmp+0x30>
  8d2d94:	48 83 c0 01          	add    $0x1,%rax
  8d2d98:	48 39 d0             	cmp    %rdx,%rax
  8d2d9b:	74 13                	je     8d2db0 <strncmp+0x30>
  8d2d9d:	0f b6 0c 07          	movzbl (%rdi,%rax,1),%ecx
  8d2da1:	3a 0c 06             	cmp    (%rsi,%rax,1),%cl
  8d2da4:	74 ea                	je     8d2d90 <strncmp+0x10>
  8d2da6:	19 c0                	sbb    %eax,%eax
  8d2da8:	83 c8 01             	or     $0x1,%eax
  8d2dab:	c3                   	retq   
  8d2dac:	0f 1f 40 00          	nopl   0x0(%rax)
  8d2db0:	31 c0                	xor    %eax,%eax
  8d2db2:	c3                   	retq   
  8d2db3:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d2dba:	00 00 00 00 
  8d2dbe:	66 90                	xchg   %ax,%ax

00000000008d2dc0 <strnlen>:
  8d2dc0:	f3 0f 1e fa          	endbr64 
  8d2dc4:	80 3f 00             	cmpb   $0x0,(%rdi)
  8d2dc7:	74 27                	je     8d2df0 <strnlen+0x30>
  8d2dc9:	48 85 f6             	test   %rsi,%rsi
  8d2dcc:	74 22                	je     8d2df0 <strnlen+0x30>
  8d2dce:	48 89 f8             	mov    %rdi,%rax
  8d2dd1:	eb 0a                	jmp    8d2ddd <strnlen+0x1d>
  8d2dd3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d2dd8:	80 38 00             	cmpb   $0x0,(%rax)
  8d2ddb:	74 0f                	je     8d2dec <strnlen+0x2c>
  8d2ddd:	48 83 c0 01          	add    $0x1,%rax
  8d2de1:	48 89 f2             	mov    %rsi,%rdx
  8d2de4:	48 29 c2             	sub    %rax,%rdx
  8d2de7:	48 01 fa             	add    %rdi,%rdx
  8d2dea:	75 ec                	jne    8d2dd8 <strnlen+0x18>
  8d2dec:	48 29 f8             	sub    %rdi,%rax
  8d2def:	c3                   	retq   
  8d2df0:	31 c0                	xor    %eax,%eax
  8d2df2:	c3                   	retq   
  8d2df3:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d2dfa:	00 00 00 00 
  8d2dfe:	66 90                	xchg   %ax,%ax

00000000008d2e00 <atou>:
  8d2e00:	f3 0f 1e fa          	endbr64 
  8d2e04:	0f be 07             	movsbl (%rdi),%eax
  8d2e07:	45 31 c0             	xor    %r8d,%r8d
  8d2e0a:	8d 50 d0             	lea    -0x30(%rax),%edx
  8d2e0d:	83 fa 09             	cmp    $0x9,%edx
  8d2e10:	77 1e                	ja     8d2e30 <atou+0x30>
  8d2e12:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d2e18:	43 8d 14 80          	lea    (%r8,%r8,4),%edx
  8d2e1c:	48 83 c7 01          	add    $0x1,%rdi
  8d2e20:	44 8d 44 50 d0       	lea    -0x30(%rax,%rdx,2),%r8d
  8d2e25:	0f be 07             	movsbl (%rdi),%eax
  8d2e28:	8d 50 d0             	lea    -0x30(%rax),%edx
  8d2e2b:	83 fa 09             	cmp    $0x9,%edx
  8d2e2e:	76 e8                	jbe    8d2e18 <atou+0x18>
  8d2e30:	44 89 c0             	mov    %r8d,%eax
  8d2e33:	c3                   	retq   
  8d2e34:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d2e3b:	00 00 00 00 
  8d2e3f:	90                   	nop

00000000008d2e40 <simple_strtoull>:
  8d2e40:	f3 0f 1e fa          	endbr64 
  8d2e44:	44 0f b6 07          	movzbl (%rdi),%r8d
  8d2e48:	85 d2                	test   %edx,%edx
  8d2e4a:	75 5c                	jne    8d2ea8 <simple_strtoull+0x68>
  8d2e4c:	ba 0a 00 00 00       	mov    $0xa,%edx
  8d2e51:	41 80 f8 30          	cmp    $0x30,%r8b
  8d2e55:	74 79                	je     8d2ed0 <simple_strtoull+0x90>
  8d2e57:	31 c0                	xor    %eax,%eax
  8d2e59:	41 89 d1             	mov    %edx,%r9d
  8d2e5c:	eb 12                	jmp    8d2e70 <simple_strtoull+0x30>
  8d2e5e:	66 90                	xchg   %ax,%ax
  8d2e60:	49 0f af c1          	imul   %r9,%rax
  8d2e64:	44 0f b6 47 01       	movzbl 0x1(%rdi),%r8d
  8d2e69:	48 83 c7 01          	add    $0x1,%rdi
  8d2e6d:	48 01 c8             	add    %rcx,%rax
  8d2e70:	41 0f be c8          	movsbl %r8b,%ecx
  8d2e74:	83 e9 30             	sub    $0x30,%ecx
  8d2e77:	83 f9 09             	cmp    $0x9,%ecx
  8d2e7a:	76 1a                	jbe    8d2e96 <simple_strtoull+0x56>
  8d2e7c:	44 89 c1             	mov    %r8d,%ecx
  8d2e7f:	83 e1 df             	and    $0xffffffdf,%ecx
  8d2e82:	83 e9 41             	sub    $0x41,%ecx
  8d2e85:	80 f9 05             	cmp    $0x5,%cl
  8d2e88:	77 10                	ja     8d2e9a <simple_strtoull+0x5a>
  8d2e8a:	41 83 c8 20          	or     $0x20,%r8d
  8d2e8e:	45 0f be c0          	movsbl %r8b,%r8d
  8d2e92:	41 8d 48 a9          	lea    -0x57(%r8),%ecx
  8d2e96:	39 d1                	cmp    %edx,%ecx
  8d2e98:	72 c6                	jb     8d2e60 <simple_strtoull+0x20>
  8d2e9a:	48 85 f6             	test   %rsi,%rsi
  8d2e9d:	74 03                	je     8d2ea2 <simple_strtoull+0x62>
  8d2e9f:	48 89 3e             	mov    %rdi,(%rsi)
  8d2ea2:	c3                   	retq   
  8d2ea3:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d2ea8:	83 fa 10             	cmp    $0x10,%edx
  8d2eab:	75 aa                	jne    8d2e57 <simple_strtoull+0x17>
  8d2ead:	41 80 f8 30          	cmp    $0x30,%r8b
  8d2eb1:	75 a4                	jne    8d2e57 <simple_strtoull+0x17>
  8d2eb3:	0f b6 47 01          	movzbl 0x1(%rdi),%eax
  8d2eb7:	83 c8 20             	or     $0x20,%eax
  8d2eba:	3c 78                	cmp    $0x78,%al
  8d2ebc:	75 99                	jne    8d2e57 <simple_strtoull+0x17>
  8d2ebe:	0f b6 4f 02          	movzbl 0x2(%rdi),%ecx
  8d2ec2:	41 89 c8             	mov    %ecx,%r8d
  8d2ec5:	48 83 c7 02          	add    $0x2,%rdi
  8d2ec9:	ba 10 00 00 00       	mov    $0x10,%edx
  8d2ece:	eb 87                	jmp    8d2e57 <simple_strtoull+0x17>
  8d2ed0:	0f b6 47 01          	movzbl 0x1(%rdi),%eax
  8d2ed4:	ba 08 00 00 00       	mov    $0x8,%edx
  8d2ed9:	83 c8 20             	or     $0x20,%eax
  8d2edc:	3c 78                	cmp    $0x78,%al
  8d2ede:	0f 85 73 ff ff ff    	jne    8d2e57 <simple_strtoull+0x17>
  8d2ee4:	0f be 47 02          	movsbl 0x2(%rdi),%eax
  8d2ee8:	89 c1                	mov    %eax,%ecx
  8d2eea:	83 e8 30             	sub    $0x30,%eax
  8d2eed:	83 f8 09             	cmp    $0x9,%eax
  8d2ef0:	76 d0                	jbe    8d2ec2 <simple_strtoull+0x82>
  8d2ef2:	89 c8                	mov    %ecx,%eax
  8d2ef4:	83 e0 df             	and    $0xffffffdf,%eax
  8d2ef7:	83 e8 41             	sub    $0x41,%eax
  8d2efa:	3c 05                	cmp    $0x5,%al
  8d2efc:	76 c4                	jbe    8d2ec2 <simple_strtoull+0x82>
  8d2efe:	e9 54 ff ff ff       	jmpq   8d2e57 <simple_strtoull+0x17>
  8d2f03:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d2f0a:	00 00 00 00 
  8d2f0e:	66 90                	xchg   %ax,%ax

00000000008d2f10 <simple_strtol>:
  8d2f10:	f3 0f 1e fa          	endbr64 
  8d2f14:	80 3f 2d             	cmpb   $0x2d,(%rdi)
  8d2f17:	74 07                	je     8d2f20 <simple_strtol+0x10>
  8d2f19:	e9 22 ff ff ff       	jmpq   8d2e40 <simple_strtoull>
  8d2f1e:	66 90                	xchg   %ax,%ax
  8d2f20:	48 83 c7 01          	add    $0x1,%rdi
  8d2f24:	e8 17 ff ff ff       	callq  8d2e40 <simple_strtoull>
  8d2f29:	48 f7 d8             	neg    %rax
  8d2f2c:	c3                   	retq   
  8d2f2d:	0f 1f 00             	nopl   (%rax)

00000000008d2f30 <strlen>:
  8d2f30:	f3 0f 1e fa          	endbr64 
  8d2f34:	80 3f 00             	cmpb   $0x0,(%rdi)
  8d2f37:	74 17                	je     8d2f50 <strlen+0x20>
  8d2f39:	48 89 f8             	mov    %rdi,%rax
  8d2f3c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d2f40:	48 83 c0 01          	add    $0x1,%rax
  8d2f44:	80 38 00             	cmpb   $0x0,(%rax)
  8d2f47:	75 f7                	jne    8d2f40 <strlen+0x10>
  8d2f49:	48 29 f8             	sub    %rdi,%rax
  8d2f4c:	c3                   	retq   
  8d2f4d:	0f 1f 00             	nopl   (%rax)
  8d2f50:	31 c0                	xor    %eax,%eax
  8d2f52:	c3                   	retq   
  8d2f53:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d2f5a:	00 00 00 00 
  8d2f5e:	66 90                	xchg   %ax,%ax

00000000008d2f60 <strstr>:
  8d2f60:	f3 0f 1e fa          	endbr64 
  8d2f64:	80 3e 00             	cmpb   $0x0,(%rsi)
  8d2f67:	48 89 f8             	mov    %rdi,%rax
  8d2f6a:	49 89 f2             	mov    %rsi,%r10
  8d2f6d:	0f 84 85 00 00 00    	je     8d2ff8 <strstr+0x98>
  8d2f73:	48 89 f2             	mov    %rsi,%rdx
  8d2f76:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d2f7d:	00 00 00 
  8d2f80:	48 83 c2 01          	add    $0x1,%rdx
  8d2f84:	80 3a 00             	cmpb   $0x0,(%rdx)
  8d2f87:	75 f7                	jne    8d2f80 <strstr+0x20>
  8d2f89:	49 89 c1             	mov    %rax,%r9
  8d2f8c:	4c 29 d2             	sub    %r10,%rdx
  8d2f8f:	74 60                	je     8d2ff1 <strstr+0x91>
  8d2f91:	80 38 00             	cmpb   $0x0,(%rax)
  8d2f94:	74 58                	je     8d2fee <strstr+0x8e>
  8d2f96:	48 89 c1             	mov    %rax,%rcx
  8d2f99:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d2fa0:	48 83 c1 01          	add    $0x1,%rcx
  8d2fa4:	80 39 00             	cmpb   $0x0,(%rcx)
  8d2fa7:	75 f7                	jne    8d2fa0 <strstr+0x40>
  8d2fa9:	48 29 c1             	sub    %rax,%rcx
  8d2fac:	49 89 c8             	mov    %rcx,%r8
  8d2faf:	48 39 ca             	cmp    %rcx,%rdx
  8d2fb2:	77 3a                	ja     8d2fee <strstr+0x8e>
  8d2fb4:	48 89 c7             	mov    %rax,%rdi
  8d2fb7:	4c 89 d6             	mov    %r10,%rsi
  8d2fba:	48 89 d1             	mov    %rdx,%rcx
  8d2fbd:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  8d2fbf:	74 37                	je     8d2ff8 <strstr+0x98>
  8d2fc1:	48 83 c0 01          	add    $0x1,%rax
  8d2fc5:	48 89 c1             	mov    %rax,%rcx
  8d2fc8:	48 29 d1             	sub    %rdx,%rcx
  8d2fcb:	49 01 c8             	add    %rcx,%r8
  8d2fce:	eb 16                	jmp    8d2fe6 <strstr+0x86>
  8d2fd0:	48 89 c7             	mov    %rax,%rdi
  8d2fd3:	4c 89 d6             	mov    %r10,%rsi
  8d2fd6:	48 89 d1             	mov    %rdx,%rcx
  8d2fd9:	f3 a6                	repz cmpsb %es:(%rdi),%ds:(%rsi)
  8d2fdb:	0f 95 c1             	setne  %cl
  8d2fde:	48 83 c0 01          	add    $0x1,%rax
  8d2fe2:	84 c9                	test   %cl,%cl
  8d2fe4:	74 0b                	je     8d2ff1 <strstr+0x91>
  8d2fe6:	49 89 c1             	mov    %rax,%r9
  8d2fe9:	4c 39 c0             	cmp    %r8,%rax
  8d2fec:	75 e2                	jne    8d2fd0 <strstr+0x70>
  8d2fee:	45 31 c9             	xor    %r9d,%r9d
  8d2ff1:	4c 89 c8             	mov    %r9,%rax
  8d2ff4:	c3                   	retq   
  8d2ff5:	0f 1f 00             	nopl   (%rax)
  8d2ff8:	49 89 c1             	mov    %rax,%r9
  8d2ffb:	4c 89 c8             	mov    %r9,%rax
  8d2ffe:	c3                   	retq   
  8d2fff:	90                   	nop

00000000008d3000 <strchr>:
  8d3000:	f3 0f 1e fa          	endbr64 
  8d3004:	48 89 f8             	mov    %rdi,%rax
  8d3007:	eb 0f                	jmp    8d3018 <strchr+0x18>
  8d3009:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3010:	48 83 c0 01          	add    $0x1,%rax
  8d3014:	84 d2                	test   %dl,%dl
  8d3016:	74 10                	je     8d3028 <strchr+0x28>
  8d3018:	0f b6 10             	movzbl (%rax),%edx
  8d301b:	40 38 f2             	cmp    %sil,%dl
  8d301e:	75 f0                	jne    8d3010 <strchr+0x10>
  8d3020:	c3                   	retq   
  8d3021:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3028:	31 c0                	xor    %eax,%eax
  8d302a:	c3                   	retq   
  8d302b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008d3030 <kstrtoull>:
  8d3030:	f3 0f 1e fa          	endbr64 
  8d3034:	31 c0                	xor    %eax,%eax
  8d3036:	80 3f 2b             	cmpb   $0x2b,(%rdi)
  8d3039:	0f 94 c0             	sete   %al
  8d303c:	48 01 c7             	add    %rax,%rdi
  8d303f:	e9 5c fb ff ff       	jmpq   8d2ba0 <_kstrtoull>
  8d3044:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d304b:	00 00 00 00 
  8d304f:	90                   	nop

00000000008d3050 <boot_kstrtoul>:
  8d3050:	f3 0f 1e fa          	endbr64 
  8d3054:	31 c0                	xor    %eax,%eax
  8d3056:	80 3f 2b             	cmpb   $0x2b,(%rdi)
  8d3059:	0f 94 c0             	sete   %al
  8d305c:	48 01 c7             	add    %rax,%rdi
  8d305f:	e9 3c fb ff ff       	jmpq   8d2ba0 <_kstrtoull>
  8d3064:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d306b:	00 00 00 00 
  8d306f:	90                   	nop

00000000008d3070 <memset>:
  8d3070:	f3 0f 1e fa          	endbr64 
  8d3074:	48 89 f8             	mov    %rdi,%rax
  8d3077:	48 89 f9             	mov    %rdi,%rcx
  8d307a:	4c 8d 04 3a          	lea    (%rdx,%rdi,1),%r8
  8d307e:	48 85 d2             	test   %rdx,%rdx
  8d3081:	74 11                	je     8d3094 <memset+0x24>
  8d3083:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3088:	40 88 31             	mov    %sil,(%rcx)
  8d308b:	48 83 c1 01          	add    $0x1,%rcx
  8d308f:	49 39 c8             	cmp    %rcx,%r8
  8d3092:	75 f4                	jne    8d3088 <memset+0x18>
  8d3094:	c3                   	retq   
  8d3095:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d309c:	00 00 00 00 

00000000008d30a0 <memmove>:
  8d30a0:	f3 0f 1e fa          	endbr64 
  8d30a4:	48 89 f8             	mov    %rdi,%rax
  8d30a7:	48 39 f7             	cmp    %rsi,%rdi
  8d30aa:	76 2c                	jbe    8d30d8 <memmove+0x38>
  8d30ac:	48 89 f9             	mov    %rdi,%rcx
  8d30af:	48 29 f1             	sub    %rsi,%rcx
  8d30b2:	48 39 d1             	cmp    %rdx,%rcx
  8d30b5:	73 21                	jae    8d30d8 <memmove+0x38>
  8d30b7:	48 83 ea 01          	sub    $0x1,%rdx
  8d30bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d30c0:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  8d30c4:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
  8d30c7:	48 83 ea 01          	sub    $0x1,%rdx
  8d30cb:	48 83 fa ff          	cmp    $0xffffffffffffffff,%rdx
  8d30cf:	75 ef                	jne    8d30c0 <memmove+0x20>
  8d30d1:	c3                   	retq   
  8d30d2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d30d8:	48 89 d1             	mov    %rdx,%rcx
  8d30db:	48 89 c7             	mov    %rax,%rdi
  8d30de:	83 e2 07             	and    $0x7,%edx
  8d30e1:	48 c1 e9 03          	shr    $0x3,%rcx
  8d30e5:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d30e8:	48 89 d1             	mov    %rdx,%rcx
  8d30eb:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8d30ed:	c3                   	retq   
  8d30ee:	66 90                	xchg   %ax,%ax

00000000008d30f0 <memcpy>:
  8d30f0:	f3 0f 1e fa          	endbr64 
  8d30f4:	48 89 f8             	mov    %rdi,%rax
  8d30f7:	48 39 f7             	cmp    %rsi,%rdi
  8d30fa:	76 0b                	jbe    8d3107 <memcpy+0x17>
  8d30fc:	48 89 f9             	mov    %rdi,%rcx
  8d30ff:	48 29 f1             	sub    %rsi,%rcx
  8d3102:	48 39 d1             	cmp    %rdx,%rcx
  8d3105:	72 19                	jb     8d3120 <memcpy+0x30>
  8d3107:	48 89 d1             	mov    %rdx,%rcx
  8d310a:	48 89 c7             	mov    %rax,%rdi
  8d310d:	83 e2 07             	and    $0x7,%edx
  8d3110:	48 c1 e9 03          	shr    $0x3,%rcx
  8d3114:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d3117:	48 89 d1             	mov    %rdx,%rcx
  8d311a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi)
  8d311c:	c3                   	retq   
  8d311d:	0f 1f 00             	nopl   (%rax)
  8d3120:	48 83 ec 28          	sub    $0x28,%rsp
  8d3124:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d3129:	48 8d 3d c8 84 00 00 	lea    0x84c8(%rip),%rdi        # 8db5f8 <kernel_info_end+0x468>
  8d3130:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  8d3135:	48 89 74 24 10       	mov    %rsi,0x10(%rsp)
  8d313a:	e8 21 04 00 00       	callq  8d3560 <warn>
  8d313f:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d3144:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d3149:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d314e:	48 83 c4 28          	add    $0x28,%rsp
  8d3152:	48 89 c7             	mov    %rax,%rdi
  8d3155:	e9 46 ff ff ff       	jmpq   8d30a0 <memmove>
  8d315a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d3160 <__cmdline_find_option>:
  8d3160:	f3 0f 1e fa          	endbr64 
  8d3164:	48 85 ff             	test   %rdi,%rdi
  8d3167:	0f 84 08 02 00 00    	je     8d3375 <__cmdline_find_option+0x215>
  8d316d:	41 55                	push   %r13
  8d316f:	49 89 f8             	mov    %rdi,%r8
  8d3172:	49 89 f9             	mov    %rdi,%r9
  8d3175:	49 89 d3             	mov    %rdx,%r11
  8d3178:	41 54                	push   %r12
  8d317a:	41 83 e0 0f          	and    $0xf,%r8d
  8d317e:	49 83 e1 f0          	and    $0xfffffffffffffff0,%r9
  8d3182:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  8d3188:	55                   	push   %rbp
  8d3189:	49 83 c0 01          	add    $0x1,%r8
  8d318d:	bd 01 00 01 00       	mov    $0x10001,%ebp
  8d3192:	53                   	push   %rbx
  8d3193:	0f b6 07             	movzbl (%rdi),%eax
  8d3196:	8d 59 ff             	lea    -0x1(%rcx),%ebx
  8d3199:	84 c0                	test   %al,%al
  8d319b:	74 73                	je     8d3210 <__cmdline_find_option+0xb0>
  8d319d:	3c 20                	cmp    $0x20,%al
  8d319f:	77 1d                	ja     8d31be <__cmdline_find_option+0x5e>
  8d31a1:	49 81 f8 ff ff 00 00 	cmp    $0xffff,%r8
  8d31a8:	77 66                	ja     8d3210 <__cmdline_find_option+0xb0>
  8d31aa:	43 0f b6 04 01       	movzbl (%r9,%r8,1),%eax
  8d31af:	49 8d 78 01          	lea    0x1(%r8),%rdi
  8d31b3:	84 c0                	test   %al,%al
  8d31b5:	74 59                	je     8d3210 <__cmdline_find_option+0xb0>
  8d31b7:	49 89 f8             	mov    %rdi,%r8
  8d31ba:	3c 20                	cmp    $0x20,%al
  8d31bc:	76 e3                	jbe    8d31a1 <__cmdline_find_option+0x41>
  8d31be:	44 0f b6 26          	movzbl (%rsi),%r12d
  8d31c2:	49 89 f5             	mov    %rsi,%r13
  8d31c5:	3c 3d                	cmp    $0x3d,%al
  8d31c7:	0f 84 33 01 00 00    	je     8d3300 <__cmdline_find_option+0x1a0>
  8d31cd:	41 38 c4             	cmp    %al,%r12b
  8d31d0:	74 76                	je     8d3248 <__cmdline_find_option+0xe8>
  8d31d2:	49 81 f8 ff ff 00 00 	cmp    $0xffff,%r8
  8d31d9:	77 35                	ja     8d3210 <__cmdline_find_option+0xb0>
  8d31db:	43 0f b6 3c 01       	movzbl (%r9,%r8,1),%edi
  8d31e0:	49 8d 40 01          	lea    0x1(%r8),%rax
  8d31e4:	40 84 ff             	test   %dil,%dil
  8d31e7:	74 27                	je     8d3210 <__cmdline_find_option+0xb0>
  8d31e9:	40 80 ff 20          	cmp    $0x20,%dil
  8d31ed:	76 39                	jbe    8d3228 <__cmdline_find_option+0xc8>
  8d31ef:	48 3d 00 00 01 00    	cmp    $0x10000,%rax
  8d31f5:	74 19                	je     8d3210 <__cmdline_find_option+0xb0>
  8d31f7:	48 83 c0 01          	add    $0x1,%rax
  8d31fb:	41 0f b6 7c 01 ff    	movzbl -0x1(%r9,%rax,1),%edi
  8d3201:	40 84 ff             	test   %dil,%dil
  8d3204:	75 e3                	jne    8d31e9 <__cmdline_find_option+0x89>
  8d3206:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d320d:	00 00 00 
  8d3210:	85 c9                	test   %ecx,%ecx
  8d3212:	74 04                	je     8d3218 <__cmdline_find_option+0xb8>
  8d3214:	41 c6 03 00          	movb   $0x0,(%r11)
  8d3218:	5b                   	pop    %rbx
  8d3219:	44 89 d0             	mov    %r10d,%eax
  8d321c:	5d                   	pop    %rbp
  8d321d:	41 5c                	pop    %r12
  8d321f:	41 5d                	pop    %r13
  8d3221:	c3                   	retq   
  8d3222:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d3228:	48 3d 00 00 01 00    	cmp    $0x10000,%rax
  8d322e:	74 e0                	je     8d3210 <__cmdline_find_option+0xb0>
  8d3230:	4c 8d 40 01          	lea    0x1(%rax),%r8
  8d3234:	41 0f b6 04 01       	movzbl (%r9,%rax,1),%eax
  8d3239:	84 c0                	test   %al,%al
  8d323b:	0f 85 5c ff ff ff    	jne    8d319d <__cmdline_find_option+0x3d>
  8d3241:	eb cd                	jmp    8d3210 <__cmdline_find_option+0xb0>
  8d3243:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3248:	49 81 f8 ff ff 00 00 	cmp    $0xffff,%r8
  8d324f:	77 bf                	ja     8d3210 <__cmdline_find_option+0xb0>
  8d3251:	43 0f b6 04 01       	movzbl (%r9,%r8,1),%eax
  8d3256:	49 8d 78 01          	lea    0x1(%r8),%rdi
  8d325a:	84 c0                	test   %al,%al
  8d325c:	74 b2                	je     8d3210 <__cmdline_find_option+0xb0>
  8d325e:	49 83 c5 01          	add    $0x1,%r13
  8d3262:	3c 3d                	cmp    $0x3d,%al
  8d3264:	74 2a                	je     8d3290 <__cmdline_find_option+0x130>
  8d3266:	3c 20                	cmp    $0x20,%al
  8d3268:	0f 87 fa 00 00 00    	ja     8d3368 <__cmdline_find_option+0x208>
  8d326e:	48 81 ff 00 00 01 00 	cmp    $0x10000,%rdi
  8d3275:	74 99                	je     8d3210 <__cmdline_find_option+0xb0>
  8d3277:	41 0f b6 04 39       	movzbl (%r9,%rdi,1),%eax
  8d327c:	4c 8d 47 01          	lea    0x1(%rdi),%r8
  8d3280:	84 c0                	test   %al,%al
  8d3282:	0f 85 15 ff ff ff    	jne    8d319d <__cmdline_find_option+0x3d>
  8d3288:	eb 86                	jmp    8d3210 <__cmdline_find_option+0xb0>
  8d328a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d3290:	45 0f b6 65 00       	movzbl 0x0(%r13),%r12d
  8d3295:	45 84 e4             	test   %r12b,%r12b
  8d3298:	75 5e                	jne    8d32f8 <__cmdline_find_option+0x198>
  8d329a:	48 81 ff 00 00 01 00 	cmp    $0x10000,%rdi
  8d32a1:	74 79                	je     8d331c <__cmdline_find_option+0x1bc>
  8d32a3:	48 8d 47 01          	lea    0x1(%rdi),%rax
  8d32a7:	41 0f b6 3c 39       	movzbl (%r9,%rdi,1),%edi
  8d32ac:	40 84 ff             	test   %dil,%dil
  8d32af:	74 6b                	je     8d331c <__cmdline_find_option+0x1bc>
  8d32b1:	41 89 e8             	mov    %ebp,%r8d
  8d32b4:	49 89 d3             	mov    %rdx,%r11
  8d32b7:	45 31 d2             	xor    %r10d,%r10d
  8d32ba:	41 29 c0             	sub    %eax,%r8d
  8d32bd:	40 80 ff 20          	cmp    $0x20,%dil
  8d32c1:	0f 86 61 ff ff ff    	jbe    8d3228 <__cmdline_find_option+0xc8>
  8d32c7:	44 39 d3             	cmp    %r10d,%ebx
  8d32ca:	7e 07                	jle    8d32d3 <__cmdline_find_option+0x173>
  8d32cc:	41 88 3b             	mov    %dil,(%r11)
  8d32cf:	49 83 c3 01          	add    $0x1,%r11
  8d32d3:	41 83 c2 01          	add    $0x1,%r10d
  8d32d7:	45 39 c2             	cmp    %r8d,%r10d
  8d32da:	0f 84 30 ff ff ff    	je     8d3210 <__cmdline_find_option+0xb0>
  8d32e0:	48 83 c0 01          	add    $0x1,%rax
  8d32e4:	41 0f b6 7c 01 ff    	movzbl -0x1(%r9,%rax,1),%edi
  8d32ea:	40 84 ff             	test   %dil,%dil
  8d32ed:	75 ce                	jne    8d32bd <__cmdline_find_option+0x15d>
  8d32ef:	e9 1c ff ff ff       	jmpq   8d3210 <__cmdline_find_option+0xb0>
  8d32f4:	0f 1f 40 00          	nopl   0x0(%rax)
  8d32f8:	49 89 f8             	mov    %rdi,%r8
  8d32fb:	e9 cd fe ff ff       	jmpq   8d31cd <__cmdline_find_option+0x6d>
  8d3300:	45 84 e4             	test   %r12b,%r12b
  8d3303:	75 2b                	jne    8d3330 <__cmdline_find_option+0x1d0>
  8d3305:	49 81 f8 ff ff 00 00 	cmp    $0xffff,%r8
  8d330c:	77 0e                	ja     8d331c <__cmdline_find_option+0x1bc>
  8d330e:	43 0f b6 3c 01       	movzbl (%r9,%r8,1),%edi
  8d3313:	49 8d 40 01          	lea    0x1(%r8),%rax
  8d3317:	40 84 ff             	test   %dil,%dil
  8d331a:	75 95                	jne    8d32b1 <__cmdline_find_option+0x151>
  8d331c:	49 89 d3             	mov    %rdx,%r11
  8d331f:	45 31 d2             	xor    %r10d,%r10d
  8d3322:	e9 e9 fe ff ff       	jmpq   8d3210 <__cmdline_find_option+0xb0>
  8d3327:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d332e:	00 00 
  8d3330:	41 80 fc 3d          	cmp    $0x3d,%r12b
  8d3334:	0f 85 98 fe ff ff    	jne    8d31d2 <__cmdline_find_option+0x72>
  8d333a:	49 81 f8 ff ff 00 00 	cmp    $0xffff,%r8
  8d3341:	0f 87 c9 fe ff ff    	ja     8d3210 <__cmdline_find_option+0xb0>
  8d3347:	43 0f b6 04 01       	movzbl (%r9,%r8,1),%eax
  8d334c:	49 8d 78 01          	lea    0x1(%r8),%rdi
  8d3350:	84 c0                	test   %al,%al
  8d3352:	0f 84 b8 fe ff ff    	je     8d3210 <__cmdline_find_option+0xb0>
  8d3358:	4c 8d 6e 01          	lea    0x1(%rsi),%r13
  8d335c:	e9 01 ff ff ff       	jmpq   8d3262 <__cmdline_find_option+0x102>
  8d3361:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3368:	45 0f b6 65 00       	movzbl 0x0(%r13),%r12d
  8d336d:	49 89 f8             	mov    %rdi,%r8
  8d3370:	e9 58 fe ff ff       	jmpq   8d31cd <__cmdline_find_option+0x6d>
  8d3375:	41 ba ff ff ff ff    	mov    $0xffffffff,%r10d
  8d337b:	44 89 d0             	mov    %r10d,%eax
  8d337e:	c3                   	retq   
  8d337f:	90                   	nop

00000000008d3380 <__cmdline_find_option_bool>:
  8d3380:	f3 0f 1e fa          	endbr64 
  8d3384:	48 85 ff             	test   %rdi,%rdi
  8d3387:	0f 84 3e 01 00 00    	je     8d34cb <__cmdline_find_option_bool+0x14b>
  8d338d:	49 89 f9             	mov    %rdi,%r9
  8d3390:	49 89 fa             	mov    %rdi,%r10
  8d3393:	0f b6 17             	movzbl (%rdi),%edx
  8d3396:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d339c:	41 83 e1 0f          	and    $0xf,%r9d
  8d33a0:	49 83 e2 f0          	and    $0xfffffffffffffff0,%r10
  8d33a4:	49 83 c1 01          	add    $0x1,%r9
  8d33a8:	84 d2                	test   %dl,%dl
  8d33aa:	74 64                	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d33ac:	80 fa 20             	cmp    $0x20,%dl
  8d33af:	0f 86 83 00 00 00    	jbe    8d3438 <__cmdline_find_option_bool+0xb8>
  8d33b5:	0f b6 3e             	movzbl (%rsi),%edi
  8d33b8:	44 89 c0             	mov    %r8d,%eax
  8d33bb:	4c 89 c9             	mov    %r9,%rcx
  8d33be:	40 84 ff             	test   %dil,%dil
  8d33c1:	74 0d                	je     8d33d0 <__cmdline_find_option_bool+0x50>
  8d33c3:	40 38 d7             	cmp    %dl,%dil
  8d33c6:	0f 84 8c 00 00 00    	je     8d3458 <__cmdline_find_option_bool+0xd8>
  8d33cc:	0f 1f 40 00          	nopl   0x0(%rax)
  8d33d0:	48 81 f9 ff ff 00 00 	cmp    $0xffff,%rcx
  8d33d7:	77 37                	ja     8d3410 <__cmdline_find_option_bool+0x90>
  8d33d9:	48 8d 51 01          	lea    0x1(%rcx),%rdx
  8d33dd:	83 c0 01             	add    $0x1,%eax
  8d33e0:	41 0f b6 0c 0a       	movzbl (%r10,%rcx,1),%ecx
  8d33e5:	29 d0                	sub    %edx,%eax
  8d33e7:	44 8d 04 10          	lea    (%rax,%rdx,1),%r8d
  8d33eb:	84 c9                	test   %cl,%cl
  8d33ed:	74 21                	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d33ef:	80 f9 20             	cmp    $0x20,%cl
  8d33f2:	77 2c                	ja     8d3420 <__cmdline_find_option_bool+0xa0>
  8d33f4:	48 81 fa 00 00 01 00 	cmp    $0x10000,%rdx
  8d33fb:	74 13                	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d33fd:	4c 8d 4a 01          	lea    0x1(%rdx),%r9
  8d3401:	41 0f b6 14 12       	movzbl (%r10,%rdx,1),%edx
  8d3406:	41 83 c0 01          	add    $0x1,%r8d
  8d340a:	84 d2                	test   %dl,%dl
  8d340c:	75 9e                	jne    8d33ac <__cmdline_find_option_bool+0x2c>
  8d340e:	66 90                	xchg   %ax,%ax
  8d3410:	45 31 c0             	xor    %r8d,%r8d
  8d3413:	44 89 c0             	mov    %r8d,%eax
  8d3416:	c3                   	retq   
  8d3417:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d341e:	00 00 
  8d3420:	48 81 fa 00 00 01 00 	cmp    $0x10000,%rdx
  8d3427:	74 e7                	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d3429:	48 83 c2 01          	add    $0x1,%rdx
  8d342d:	41 0f b6 4c 12 ff    	movzbl -0x1(%r10,%rdx,1),%ecx
  8d3433:	eb b2                	jmp    8d33e7 <__cmdline_find_option_bool+0x67>
  8d3435:	0f 1f 00             	nopl   (%rax)
  8d3438:	49 81 f9 ff ff 00 00 	cmp    $0xffff,%r9
  8d343f:	77 cf                	ja     8d3410 <__cmdline_find_option_bool+0x90>
  8d3441:	43 0f b6 14 0a       	movzbl (%r10,%r9,1),%edx
  8d3446:	41 83 c0 01          	add    $0x1,%r8d
  8d344a:	49 83 c1 01          	add    $0x1,%r9
  8d344e:	e9 55 ff ff ff       	jmpq   8d33a8 <__cmdline_find_option_bool+0x28>
  8d3453:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3458:	49 81 f9 ff ff 00 00 	cmp    $0xffff,%r9
  8d345f:	77 af                	ja     8d3410 <__cmdline_find_option_bool+0x90>
  8d3461:	48 89 f0             	mov    %rsi,%rax
  8d3464:	48 83 c1 01          	add    $0x1,%rcx
  8d3468:	45 8d 58 01          	lea    0x1(%r8),%r11d
  8d346c:	43 0f b6 3c 0a       	movzbl (%r10,%r9,1),%edi
  8d3471:	4c 29 c8             	sub    %r9,%rax
  8d3474:	41 29 cb             	sub    %ecx,%r11d
  8d3477:	49 89 c1             	mov    %rax,%r9
  8d347a:	41 0f b6 14 09       	movzbl (%r9,%rcx,1),%edx
  8d347f:	41 8d 04 0b          	lea    (%r11,%rcx,1),%eax
  8d3483:	84 d2                	test   %dl,%dl
  8d3485:	75 19                	jne    8d34a0 <__cmdline_find_option_bool+0x120>
  8d3487:	40 84 ff             	test   %dil,%dil
  8d348a:	74 87                	je     8d3413 <__cmdline_find_option_bool+0x93>
  8d348c:	40 80 ff 20          	cmp    $0x20,%dil
  8d3490:	0f 87 3a ff ff ff    	ja     8d33d0 <__cmdline_find_option_bool+0x50>
  8d3496:	e9 78 ff ff ff       	jmpq   8d3413 <__cmdline_find_option_bool+0x93>
  8d349b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d34a0:	40 84 ff             	test   %dil,%dil
  8d34a3:	0f 84 67 ff ff ff    	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d34a9:	40 38 fa             	cmp    %dil,%dl
  8d34ac:	0f 85 1e ff ff ff    	jne    8d33d0 <__cmdline_find_option_bool+0x50>
  8d34b2:	48 81 f9 00 00 01 00 	cmp    $0x10000,%rcx
  8d34b9:	0f 84 51 ff ff ff    	je     8d3410 <__cmdline_find_option_bool+0x90>
  8d34bf:	48 83 c1 01          	add    $0x1,%rcx
  8d34c3:	41 0f b6 7c 0a ff    	movzbl -0x1(%r10,%rcx,1),%edi
  8d34c9:	eb af                	jmp    8d347a <__cmdline_find_option_bool+0xfa>
  8d34cb:	41 b8 ff ff ff ff    	mov    $0xffffffff,%r8d
  8d34d1:	e9 3d ff ff ff       	jmpq   8d3413 <__cmdline_find_option_bool+0x93>
  8d34d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d34dd:	00 00 00 

00000000008d34e0 <get_cmd_line_ptr>:
  8d34e0:	f3 0f 1e fa          	endbr64 
  8d34e4:	48 8b 15 75 fe 01 00 	mov    0x1fe75(%rip),%rdx        # 8f3360 <boot_params>
  8d34eb:	8b 82 c8 00 00 00    	mov    0xc8(%rdx),%eax
  8d34f1:	8b 8a 28 02 00 00    	mov    0x228(%rdx),%ecx
  8d34f7:	48 c1 e0 20          	shl    $0x20,%rax
  8d34fb:	48 09 c8             	or     %rcx,%rax
  8d34fe:	c3                   	retq   
  8d34ff:	90                   	nop

00000000008d3500 <cmdline_find_option>:
  8d3500:	f3 0f 1e fa          	endbr64 
  8d3504:	48 8b 05 55 fe 01 00 	mov    0x1fe55(%rip),%rax        # 8f3360 <boot_params>
  8d350b:	49 89 f8             	mov    %rdi,%r8
  8d350e:	89 d1                	mov    %edx,%ecx
  8d3510:	8b b8 c8 00 00 00    	mov    0xc8(%rax),%edi
  8d3516:	8b 90 28 02 00 00    	mov    0x228(%rax),%edx
  8d351c:	48 c1 e7 20          	shl    $0x20,%rdi
  8d3520:	48 09 d7             	or     %rdx,%rdi
  8d3523:	48 89 f2             	mov    %rsi,%rdx
  8d3526:	4c 89 c6             	mov    %r8,%rsi
  8d3529:	e9 32 fc ff ff       	jmpq   8d3160 <__cmdline_find_option>
  8d352e:	66 90                	xchg   %ax,%ax

00000000008d3530 <cmdline_find_option_bool>:
  8d3530:	f3 0f 1e fa          	endbr64 
  8d3534:	48 8b 05 25 fe 01 00 	mov    0x1fe25(%rip),%rax        # 8f3360 <boot_params>
  8d353b:	48 89 fe             	mov    %rdi,%rsi
  8d353e:	8b b8 c8 00 00 00    	mov    0xc8(%rax),%edi
  8d3544:	8b 90 28 02 00 00    	mov    0x228(%rax),%edx
  8d354a:	48 c1 e7 20          	shl    $0x20,%rdi
  8d354e:	48 09 d7             	or     %rdx,%rdi
  8d3551:	e9 2a fe ff ff       	jmpq   8d3380 <__cmdline_find_option_bool>
  8d3556:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d355d:	00 00 00 

00000000008d3560 <warn>:
  8d3560:	f3 0f 1e fa          	endbr64 
  8d3564:	55                   	push   %rbp
  8d3565:	48 89 fd             	mov    %rdi,%rbp
  8d3568:	48 8d 3d bb 80 00 00 	lea    0x80bb(%rip),%rdi        # 8db62a <kernel_info_end+0x49a>
  8d356f:	e8 8c ed ff ff       	callq  8d2300 <__putstr>
  8d3574:	48 89 ef             	mov    %rbp,%rdi
  8d3577:	e8 84 ed ff ff       	callq  8d2300 <__putstr>
  8d357c:	48 8d 3d a7 80 00 00 	lea    0x80a7(%rip),%rdi        # 8db62a <kernel_info_end+0x49a>
  8d3583:	5d                   	pop    %rbp
  8d3584:	e9 77 ed ff ff       	jmpq   8d2300 <__putstr>
  8d3589:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000008d3590 <error>:
  8d3590:	f3 0f 1e fa          	endbr64 
  8d3594:	50                   	push   %rax
  8d3595:	58                   	pop    %rax
  8d3596:	48 83 ec 08          	sub    $0x8,%rsp
  8d359a:	e8 c1 ff ff ff       	callq  8d3560 <warn>
  8d359f:	48 8d 3d 87 80 00 00 	lea    0x8087(%rip),%rdi        # 8db62d <kernel_info_end+0x49d>
  8d35a6:	e8 55 ed ff ff       	callq  8d2300 <__putstr>
  8d35ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d35b0:	f4                   	hlt    
  8d35b1:	eb fd                	jmp    8d35b0 <error+0x20>
  8d35b3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d35ba:	00 00 00 
  8d35bd:	0f 1f 00             	nopl   (%rax)

00000000008d35c0 <has_eflag>:
  8d35c0:	f3 0f 1e fa          	endbr64 
  8d35c4:	9c                   	pushfq 
  8d35c5:	9c                   	pushfq 
  8d35c6:	58                   	pop    %rax
  8d35c7:	48 89 c2             	mov    %rax,%rdx
  8d35ca:	48 31 fa             	xor    %rdi,%rdx
  8d35cd:	52                   	push   %rdx
  8d35ce:	9d                   	popfq  
  8d35cf:	9c                   	pushfq 
  8d35d0:	5a                   	pop    %rdx
  8d35d1:	9d                   	popfq  
  8d35d2:	48 31 d0             	xor    %rdx,%rax
  8d35d5:	48 85 f8             	test   %rdi,%rax
  8d35d8:	0f 95 c0             	setne  %al
  8d35db:	0f b6 c0             	movzbl %al,%eax
  8d35de:	c3                   	retq   
  8d35df:	90                   	nop

00000000008d35e0 <get_cpuflags>:
  8d35e0:	f3 0f 1e fa          	endbr64 
  8d35e4:	80 3d fd dc 01 00 00 	cmpb   $0x0,0x1dcfd(%rip)        # 8f12e8 <loaded_flags>
  8d35eb:	74 03                	je     8d35f0 <get_cpuflags+0x10>
  8d35ed:	c3                   	retq   
  8d35ee:	66 90                	xchg   %ax,%ax
  8d35f0:	53                   	push   %rbx
  8d35f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d35f6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8d35fb:	48 83 ec 10          	sub    $0x10,%rsp
  8d35ff:	c6 05 e2 dc 01 00 01 	movb   $0x1,0x1dce2(%rip)        # 8f12e8 <loaded_flags>
  8d3606:	66 89 44 24 0c       	mov    %ax,0xc(%rsp)
  8d360b:	66 89 54 24 0e       	mov    %dx,0xe(%rsp)
  8d3610:	0f 20 c0             	mov    %cr0,%rax
  8d3613:	a8 0c                	test   $0xc,%al
  8d3615:	74 07                	je     8d361e <get_cpuflags+0x3e>
  8d3617:	48 83 e0 f3          	and    $0xfffffffffffffff3,%rax
  8d361b:	0f 22 c0             	mov    %rax,%cr0
  8d361e:	db e3                	fninit 
  8d3620:	dd 7c 24 0e          	fnstsw 0xe(%rsp)
  8d3624:	d9 7c 24 0c          	fnstcw 0xc(%rsp)
  8d3628:	66 83 7c 24 0e 00    	cmpw   $0x0,0xe(%rsp)
  8d362e:	75 13                	jne    8d3643 <get_cpuflags+0x63>
  8d3630:	0f b7 44 24 0c       	movzwl 0xc(%rsp),%eax
  8d3635:	66 25 3f 10          	and    $0x103f,%ax
  8d3639:	66 83 f8 3f          	cmp    $0x3f,%ax
  8d363d:	0f 84 cd 00 00 00    	je     8d3710 <get_cpuflags+0x130>
  8d3643:	9c                   	pushfq 
  8d3644:	9c                   	pushfq 
  8d3645:	58                   	pop    %rax
  8d3646:	48 89 c2             	mov    %rax,%rdx
  8d3649:	48 81 f2 00 00 20 00 	xor    $0x200000,%rdx
  8d3650:	52                   	push   %rdx
  8d3651:	9d                   	popfq  
  8d3652:	9c                   	pushfq 
  8d3653:	5a                   	pop    %rdx
  8d3654:	9d                   	popfq  
  8d3655:	48 31 d0             	xor    %rdx,%rax
  8d3658:	a9 00 00 20 00       	test   $0x200000,%eax
  8d365d:	0f 84 a2 00 00 00    	je     8d3705 <get_cpuflags+0x125>
  8d3663:	31 f6                	xor    %esi,%esi
  8d3665:	89 f0                	mov    %esi,%eax
  8d3667:	89 f1                	mov    %esi,%ecx
  8d3669:	0f a2                	cpuid  
  8d366b:	89 c7                	mov    %eax,%edi
  8d366d:	8d 40 ff             	lea    -0x1(%rax),%eax
  8d3670:	89 0d 72 fd 01 00    	mov    %ecx,0x1fd72(%rip)        # 8f33e8 <cpu_vendor+0x8>
  8d3676:	89 15 68 fd 01 00    	mov    %edx,0x1fd68(%rip)        # 8f33e4 <cpu_vendor+0x4>
  8d367c:	89 1d 5e fd 01 00    	mov    %ebx,0x1fd5e(%rip)        # 8f33e0 <cpu_vendor>
  8d3682:	3d fe ff 00 00       	cmp    $0xfffe,%eax
  8d3687:	77 3c                	ja     8d36c5 <get_cpuflags+0xe5>
  8d3689:	b8 01 00 00 00       	mov    $0x1,%eax
  8d368e:	89 f1                	mov    %esi,%ecx
  8d3690:	0f a2                	cpuid  
  8d3692:	89 15 f4 fc 01 00    	mov    %edx,0x1fcf4(%rip)        # 8f338c <cpu+0xc>
  8d3698:	89 c2                	mov    %eax,%edx
  8d369a:	89 0d fc fc 01 00    	mov    %ecx,0x1fcfc(%rip)        # 8f339c <cpu+0x1c>
  8d36a0:	c1 ea 08             	shr    $0x8,%edx
  8d36a3:	89 c1                	mov    %eax,%ecx
  8d36a5:	83 e2 0f             	and    $0xf,%edx
  8d36a8:	c1 e9 04             	shr    $0x4,%ecx
  8d36ab:	89 15 cf fc 01 00    	mov    %edx,0x1fccf(%rip)        # 8f3380 <cpu>
  8d36b1:	83 e1 0f             	and    $0xf,%ecx
  8d36b4:	89 15 ca fc 01 00    	mov    %edx,0x1fcca(%rip)        # 8f3384 <cpu+0x4>
  8d36ba:	83 fa 05             	cmp    $0x5,%edx
  8d36bd:	7f 61                	jg     8d3720 <get_cpuflags+0x140>
  8d36bf:	89 0d c3 fc 01 00    	mov    %ecx,0x1fcc3(%rip)        # 8f3388 <cpu+0x8>
  8d36c5:	83 ff 06             	cmp    $0x6,%edi
  8d36c8:	76 0f                	jbe    8d36d9 <get_cpuflags+0xf9>
  8d36ca:	b8 07 00 00 00       	mov    $0x7,%eax
  8d36cf:	31 c9                	xor    %ecx,%ecx
  8d36d1:	0f a2                	cpuid  
  8d36d3:	89 0d f3 fc 01 00    	mov    %ecx,0x1fcf3(%rip)        # 8f33cc <cpu+0x4c>
  8d36d9:	31 f6                	xor    %esi,%esi
  8d36db:	b8 00 00 00 80       	mov    $0x80000000,%eax
  8d36e0:	89 f1                	mov    %esi,%ecx
  8d36e2:	0f a2                	cpuid  
  8d36e4:	05 ff ff ff 7f       	add    $0x7fffffff,%eax
  8d36e9:	3d fe ff 00 00       	cmp    $0xfffe,%eax
  8d36ee:	77 15                	ja     8d3705 <get_cpuflags+0x125>
  8d36f0:	b8 01 00 00 80       	mov    $0x80000001,%eax
  8d36f5:	89 f1                	mov    %esi,%ecx
  8d36f7:	0f a2                	cpuid  
  8d36f9:	89 0d a5 fc 01 00    	mov    %ecx,0x1fca5(%rip)        # 8f33a4 <cpu+0x24>
  8d36ff:	89 15 8b fc 01 00    	mov    %edx,0x1fc8b(%rip)        # 8f3390 <cpu+0x10>
  8d3705:	48 83 c4 10          	add    $0x10,%rsp
  8d3709:	5b                   	pop    %rbx
  8d370a:	c3                   	retq   
  8d370b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3710:	0f ba 2d 74 fc 01 00 	btsl   $0x0,0x1fc74(%rip)        # 8f338c <cpu+0xc>
  8d3717:	00 
  8d3718:	e9 26 ff ff ff       	jmpq   8d3643 <get_cpuflags+0x63>
  8d371d:	0f 1f 00             	nopl   (%rax)
  8d3720:	c1 e8 0c             	shr    $0xc,%eax
  8d3723:	25 f0 00 00 00       	and    $0xf0,%eax
  8d3728:	01 c8                	add    %ecx,%eax
  8d372a:	89 05 58 fc 01 00    	mov    %eax,0x1fc58(%rip)        # 8f3388 <cpu+0x8>
  8d3730:	eb 93                	jmp    8d36c5 <get_cpuflags+0xe5>
  8d3732:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d3739:	00 00 00 00 
  8d373d:	0f 1f 00             	nopl   (%rax)

00000000008d3740 <has_cpuflag>:
  8d3740:	f3 0f 1e fa          	endbr64 
  8d3744:	41 89 f8             	mov    %edi,%r8d
  8d3747:	e8 94 fe ff ff       	callq  8d35e0 <get_cpuflags>
  8d374c:	44 0f a3 05 38 fc 01 	bt     %r8d,0x1fc38(%rip)        # 8f338c <cpu+0xc>
  8d3753:	00 
  8d3754:	0f 92 c0             	setb   %al
  8d3757:	c3                   	retq   
  8d3758:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d375f:	00 

00000000008d3760 <early_serial_init>:
  8d3760:	44 8d 47 03          	lea    0x3(%rdi),%r8d
  8d3764:	b9 03 00 00 00       	mov    $0x3,%ecx
  8d3769:	89 c8                	mov    %ecx,%eax
  8d376b:	44 89 c2             	mov    %r8d,%edx
  8d376e:	ee                   	out    %al,(%dx)
  8d376f:	44 8d 4f 01          	lea    0x1(%rdi),%r9d
  8d3773:	31 c0                	xor    %eax,%eax
  8d3775:	44 89 ca             	mov    %r9d,%edx
  8d3778:	ee                   	out    %al,(%dx)
  8d3779:	8d 57 02             	lea    0x2(%rdi),%edx
  8d377c:	ee                   	out    %al,(%dx)
  8d377d:	8d 57 04             	lea    0x4(%rdi),%edx
  8d3780:	89 c8                	mov    %ecx,%eax
  8d3782:	ee                   	out    %al,(%dx)
  8d3783:	b8 00 c2 01 00       	mov    $0x1c200,%eax
  8d3788:	99                   	cltd   
  8d3789:	f7 fe                	idiv   %esi
  8d378b:	44 89 c2             	mov    %r8d,%edx
  8d378e:	89 c1                	mov    %eax,%ecx
  8d3790:	ec                   	in     (%dx),%al
  8d3791:	89 c6                	mov    %eax,%esi
  8d3793:	83 c8 80             	or     $0xffffff80,%eax
  8d3796:	ee                   	out    %al,(%dx)
  8d3797:	89 c8                	mov    %ecx,%eax
  8d3799:	89 fa                	mov    %edi,%edx
  8d379b:	ee                   	out    %al,(%dx)
  8d379c:	89 c8                	mov    %ecx,%eax
  8d379e:	44 89 ca             	mov    %r9d,%edx
  8d37a1:	c1 e8 08             	shr    $0x8,%eax
  8d37a4:	ee                   	out    %al,(%dx)
  8d37a5:	89 f0                	mov    %esi,%eax
  8d37a7:	44 89 c2             	mov    %r8d,%edx
  8d37aa:	83 e0 7f             	and    $0x7f,%eax
  8d37ad:	ee                   	out    %al,(%dx)
  8d37ae:	89 3d 38 fc 01 00    	mov    %edi,0x1fc38(%rip)        # 8f33ec <early_serial_base>
  8d37b4:	c3                   	retq   
  8d37b5:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d37bc:	00 00 00 00 

00000000008d37c0 <console_init>:
  8d37c0:	f3 0f 1e fa          	endbr64 
  8d37c4:	41 56                	push   %r14
  8d37c6:	ba 20 00 00 00       	mov    $0x20,%edx
  8d37cb:	48 8d 3d 6d 7e 00 00 	lea    0x7e6d(%rip),%rdi        # 8db63f <kernel_info_end+0x4af>
  8d37d2:	41 55                	push   %r13
  8d37d4:	41 54                	push   %r12
  8d37d6:	55                   	push   %rbp
  8d37d7:	53                   	push   %rbx
  8d37d8:	48 83 ec 50          	sub    $0x50,%rsp
  8d37dc:	48 8d 6c 24 10       	lea    0x10(%rsp),%rbp
  8d37e1:	48 89 ee             	mov    %rbp,%rsi
  8d37e4:	e8 17 fd ff ff       	callq  8d3500 <cmdline_find_option>
  8d37e9:	85 c0                	test   %eax,%eax
  8d37eb:	7f 23                	jg     8d3810 <console_init+0x50>
  8d37ed:	8b 05 f9 fb 01 00    	mov    0x1fbf9(%rip),%eax        # 8f33ec <early_serial_base>
  8d37f3:	85 c0                	test   %eax,%eax
  8d37f5:	0f 84 c5 00 00 00    	je     8d38c0 <console_init+0x100>
  8d37fb:	48 83 c4 50          	add    $0x50,%rsp
  8d37ff:	5b                   	pop    %rbx
  8d3800:	5d                   	pop    %rbp
  8d3801:	41 5c                	pop    %r12
  8d3803:	41 5d                	pop    %r13
  8d3805:	41 5e                	pop    %r14
  8d3807:	c3                   	retq   
  8d3808:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d380f:	00 
  8d3810:	ba 06 00 00 00       	mov    $0x6,%edx
  8d3815:	48 8d 35 2f 7e 00 00 	lea    0x7e2f(%rip),%rsi        # 8db64b <kernel_info_end+0x4bb>
  8d381c:	48 89 ef             	mov    %rbp,%rdi
  8d381f:	e8 5c f5 ff ff       	callq  8d2d80 <strncmp>
  8d3824:	85 c0                	test   %eax,%eax
  8d3826:	0f 84 54 01 00 00    	je     8d3980 <console_init+0x1c0>
  8d382c:	31 db                	xor    %ebx,%ebx
  8d382e:	80 7c 24 10 2c       	cmpb   $0x2c,0x10(%rsp)
  8d3833:	40 0f 94 c7          	sete   %dil
  8d3837:	0f 94 c3             	sete   %bl
  8d383a:	45 31 e4             	xor    %r12d,%r12d
  8d383d:	40 0f b6 ff          	movzbl %dil,%edi
  8d3841:	48 01 ef             	add    %rbp,%rdi
  8d3844:	ba 04 00 00 00       	mov    $0x4,%edx
  8d3849:	48 8d 35 02 7e 00 00 	lea    0x7e02(%rip),%rsi        # 8db652 <kernel_info_end+0x4c2>
  8d3850:	e8 2b f5 ff ff       	callq  8d2d80 <strncmp>
  8d3855:	4c 8d 6c 24 08       	lea    0x8(%rsp),%r13
  8d385a:	85 c0                	test   %eax,%eax
  8d385c:	0f 84 4e 01 00 00    	je     8d39b0 <console_init+0x1f0>
  8d3862:	48 63 c3             	movslq %ebx,%rax
  8d3865:	80 7c 04 10 2c       	cmpb   $0x2c,0x10(%rsp,%rax,1)
  8d386a:	75 06                	jne    8d3872 <console_init+0xb2>
  8d386c:	83 c3 01             	add    $0x1,%ebx
  8d386f:	48 63 c3             	movslq %ebx,%rax
  8d3872:	48 8d 5c 05 00       	lea    0x0(%rbp,%rax,1),%rbx
  8d3877:	4c 89 ee             	mov    %r13,%rsi
  8d387a:	31 d2                	xor    %edx,%edx
  8d387c:	48 89 df             	mov    %rbx,%rdi
  8d387f:	e8 bc f5 ff ff       	callq  8d2e40 <simple_strtoull>
  8d3884:	89 c6                	mov    %eax,%esi
  8d3886:	85 c0                	test   %eax,%eax
  8d3888:	0f 84 12 01 00 00    	je     8d39a0 <console_init+0x1e0>
  8d388e:	48 3b 5c 24 08       	cmp    0x8(%rsp),%rbx
  8d3893:	b8 80 25 00 00       	mov    $0x2580,%eax
  8d3898:	0f 44 f0             	cmove  %eax,%esi
  8d389b:	45 85 e4             	test   %r12d,%r12d
  8d389e:	0f 84 49 ff ff ff    	je     8d37ed <console_init+0x2d>
  8d38a4:	44 89 e7             	mov    %r12d,%edi
  8d38a7:	e8 b4 fe ff ff       	callq  8d3760 <early_serial_init>
  8d38ac:	8b 05 3a fb 01 00    	mov    0x1fb3a(%rip),%eax        # 8f33ec <early_serial_base>
  8d38b2:	85 c0                	test   %eax,%eax
  8d38b4:	0f 85 41 ff ff ff    	jne    8d37fb <console_init+0x3b>
  8d38ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d38c0:	ba 40 00 00 00       	mov    $0x40,%edx
  8d38c5:	48 89 ee             	mov    %rbp,%rsi
  8d38c8:	48 8d 3d 88 7d 00 00 	lea    0x7d88(%rip),%rdi        # 8db657 <kernel_info_end+0x4c7>
  8d38cf:	e8 2c fc ff ff       	callq  8d3500 <cmdline_find_option>
  8d38d4:	85 c0                	test   %eax,%eax
  8d38d6:	0f 8e 1f ff ff ff    	jle    8d37fb <console_init+0x3b>
  8d38dc:	ba 0c 00 00 00       	mov    $0xc,%edx
  8d38e1:	48 8d 35 77 7d 00 00 	lea    0x7d77(%rip),%rsi        # 8db65f <kernel_info_end+0x4cf>
  8d38e8:	48 89 ef             	mov    %rbp,%rdi
  8d38eb:	48 89 6c 24 08       	mov    %rbp,0x8(%rsp)
  8d38f0:	e8 8b f4 ff ff       	callq  8d2d80 <strncmp>
  8d38f5:	85 c0                	test   %eax,%eax
  8d38f7:	0f 85 13 01 00 00    	jne    8d3a10 <console_init+0x250>
  8d38fd:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d3902:	4c 8d 6c 24 08       	lea    0x8(%rsp),%r13
  8d3907:	31 d2                	xor    %edx,%edx
  8d3909:	4c 89 ee             	mov    %r13,%rsi
  8d390c:	48 8d 78 0c          	lea    0xc(%rax),%rdi
  8d3910:	e8 2b f5 ff ff       	callq  8d2e40 <simple_strtoull>
  8d3915:	41 89 c4             	mov    %eax,%r12d
  8d3918:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d391d:	48 85 ff             	test   %rdi,%rdi
  8d3920:	74 09                	je     8d392b <console_init+0x16b>
  8d3922:	80 3f 2c             	cmpb   $0x2c,(%rdi)
  8d3925:	0f 84 65 01 00 00    	je     8d3a90 <console_init+0x2d0>
  8d392b:	41 8d 4c 24 03       	lea    0x3(%r12),%ecx
  8d3930:	89 ca                	mov    %ecx,%edx
  8d3932:	ec                   	in     (%dx),%al
  8d3933:	41 89 c0             	mov    %eax,%r8d
  8d3936:	83 c8 80             	or     $0xffffff80,%eax
  8d3939:	ee                   	out    %al,(%dx)
  8d393a:	44 89 e2             	mov    %r12d,%edx
  8d393d:	ec                   	in     (%dx),%al
  8d393e:	0f b6 f8             	movzbl %al,%edi
  8d3941:	41 8d 54 24 01       	lea    0x1(%r12),%edx
  8d3946:	ec                   	in     (%dx),%al
  8d3947:	89 c6                	mov    %eax,%esi
  8d3949:	89 ca                	mov    %ecx,%edx
  8d394b:	44 89 c0             	mov    %r8d,%eax
  8d394e:	ee                   	out    %al,(%dx)
  8d394f:	40 0f b6 ce          	movzbl %sil,%ecx
  8d3953:	b8 00 c2 01 00       	mov    $0x1c200,%eax
  8d3958:	31 d2                	xor    %edx,%edx
  8d395a:	c1 e1 08             	shl    $0x8,%ecx
  8d395d:	09 f9                	or     %edi,%ecx
  8d395f:	f7 f1                	div    %ecx
  8d3961:	45 85 e4             	test   %r12d,%r12d
  8d3964:	0f 84 91 fe ff ff    	je     8d37fb <console_init+0x3b>
  8d396a:	89 c6                	mov    %eax,%esi
  8d396c:	44 89 e7             	mov    %r12d,%edi
  8d396f:	e8 ec fd ff ff       	callq  8d3760 <early_serial_init>
  8d3974:	e9 82 fe ff ff       	jmpq   8d37fb <console_init+0x3b>
  8d3979:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3980:	80 7c 24 16 2c       	cmpb   $0x2c,0x16(%rsp)
  8d3985:	74 51                	je     8d39d8 <console_init+0x218>
  8d3987:	bf 06 00 00 00       	mov    $0x6,%edi
  8d398c:	41 bc f8 03 00 00    	mov    $0x3f8,%r12d
  8d3992:	bb 06 00 00 00       	mov    $0x6,%ebx
  8d3997:	e9 a5 fe ff ff       	jmpq   8d3841 <console_init+0x81>
  8d399c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d39a0:	be 80 25 00 00       	mov    $0x2580,%esi
  8d39a5:	e9 f1 fe ff ff       	jmpq   8d389b <console_init+0xdb>
  8d39aa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d39b0:	8d 43 04             	lea    0x4(%rbx),%eax
  8d39b3:	31 d2                	xor    %edx,%edx
  8d39b5:	83 c3 05             	add    $0x5,%ebx
  8d39b8:	48 98                	cltq   
  8d39ba:	80 7c 04 10 31       	cmpb   $0x31,0x10(%rsp,%rax,1)
  8d39bf:	48 8d 05 82 75 00 00 	lea    0x7582(%rip),%rax        # 8daf48 <bases.30379>
  8d39c6:	0f 94 c2             	sete   %dl
  8d39c9:	44 8b 24 90          	mov    (%rax,%rdx,4),%r12d
  8d39cd:	e9 90 fe ff ff       	jmpq   8d3862 <console_init+0xa2>
  8d39d2:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d39d8:	4c 8d 74 24 17       	lea    0x17(%rsp),%r14
  8d39dd:	ba 02 00 00 00       	mov    $0x2,%edx
  8d39e2:	48 8d 35 57 7d 00 00 	lea    0x7d57(%rip),%rsi        # 8db740 <kernel_info_end+0x5b0>
  8d39e9:	4c 89 f7             	mov    %r14,%rdi
  8d39ec:	e8 8f f3 ff ff       	callq  8d2d80 <strncmp>
  8d39f1:	85 c0                	test   %eax,%eax
  8d39f3:	74 5b                	je     8d3a50 <console_init+0x290>
  8d39f5:	bf 07 00 00 00       	mov    $0x7,%edi
  8d39fa:	41 bc f8 03 00 00    	mov    $0x3f8,%r12d
  8d3a00:	bb 07 00 00 00       	mov    $0x7,%ebx
  8d3a05:	e9 37 fe ff ff       	jmpq   8d3841 <console_init+0x81>
  8d3a0a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d3a10:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d3a15:	ba 08 00 00 00       	mov    $0x8,%edx
  8d3a1a:	48 8d 35 4b 7c 00 00 	lea    0x7c4b(%rip),%rsi        # 8db66c <kernel_info_end+0x4dc>
  8d3a21:	e8 5a f3 ff ff       	callq  8d2d80 <strncmp>
  8d3a26:	85 c0                	test   %eax,%eax
  8d3a28:	0f 85 cd fd ff ff    	jne    8d37fb <console_init+0x3b>
  8d3a2e:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d3a33:	4c 8d 6c 24 08       	lea    0x8(%rsp),%r13
  8d3a38:	31 d2                	xor    %edx,%edx
  8d3a3a:	4c 89 ee             	mov    %r13,%rsi
  8d3a3d:	48 8d 78 08          	lea    0x8(%rax),%rdi
  8d3a41:	e8 fa f3 ff ff       	callq  8d2e40 <simple_strtoull>
  8d3a46:	41 89 c4             	mov    %eax,%r12d
  8d3a49:	e9 ca fe ff ff       	jmpq   8d3918 <console_init+0x158>
  8d3a4e:	66 90                	xchg   %ax,%ax
  8d3a50:	4c 8d 6c 24 08       	lea    0x8(%rsp),%r13
  8d3a55:	ba 10 00 00 00       	mov    $0x10,%edx
  8d3a5a:	4c 89 f7             	mov    %r14,%rdi
  8d3a5d:	4c 89 ee             	mov    %r13,%rsi
  8d3a60:	e8 db f3 ff ff       	callq  8d2e40 <simple_strtoull>
  8d3a65:	41 89 c4             	mov    %eax,%r12d
  8d3a68:	85 c0                	test   %eax,%eax
  8d3a6a:	74 14                	je     8d3a80 <console_init+0x2c0>
  8d3a6c:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  8d3a71:	4c 39 f3             	cmp    %r14,%rbx
  8d3a74:	74 0a                	je     8d3a80 <console_init+0x2c0>
  8d3a76:	29 eb                	sub    %ebp,%ebx
  8d3a78:	e9 e5 fd ff ff       	jmpq   8d3862 <console_init+0xa2>
  8d3a7d:	0f 1f 00             	nopl   (%rax)
  8d3a80:	41 bc f8 03 00 00    	mov    $0x3f8,%r12d
  8d3a86:	bb 07 00 00 00       	mov    $0x7,%ebx
  8d3a8b:	e9 d2 fd ff ff       	jmpq   8d3862 <console_init+0xa2>
  8d3a90:	48 83 c7 01          	add    $0x1,%rdi
  8d3a94:	31 d2                	xor    %edx,%edx
  8d3a96:	4c 89 ee             	mov    %r13,%rsi
  8d3a99:	e8 a2 f3 ff ff       	callq  8d2e40 <simple_strtoull>
  8d3a9e:	e9 be fe ff ff       	jmpq   8d3961 <console_init+0x1a1>
  8d3aa3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d3aaa:	00 00 00 
  8d3aad:	0f 1f 00             	nopl   (%rax)

00000000008d3ab0 <ident_pmd_init.isra.0>:
  8d3ab0:	48 81 e1 00 00 e0 ff 	and    $0xffffffffffe00000,%rcx
  8d3ab7:	4c 39 c1             	cmp    %r8,%rcx
  8d3aba:	73 64                	jae    8d3b20 <ident_pmd_init.isra.0+0x70>
  8d3abc:	49 bb ff 0f 00 00 00 	movabs $0xfff0000000000fff,%r11
  8d3ac3:	00 f0 ff 
  8d3ac6:	53                   	push   %rbx
  8d3ac7:	48 bb ff ff 1f 00 00 	movabs $0xfff00000001fffff,%rbx
  8d3ace:	00 f0 ff 
  8d3ad1:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3ad8:	48 89 c8             	mov    %rcx,%rax
  8d3adb:	4d 89 da             	mov    %r11,%r10
  8d3ade:	48 c1 e8 12          	shr    $0x12,%rax
  8d3ae2:	25 f8 0f 00 00       	and    $0xff8,%eax
  8d3ae7:	48 01 d0             	add    %rdx,%rax
  8d3aea:	4c 8b 08             	mov    (%rax),%r9
  8d3aed:	41 f6 c1 80          	test   $0x80,%r9b
  8d3af1:	4c 0f 45 d3          	cmovne %rbx,%r10
  8d3af5:	4d 21 d1             	and    %r10,%r9
  8d3af8:	41 f7 c1 81 01 00 00 	test   $0x181,%r9d
  8d3aff:	75 0c                	jne    8d3b0d <ident_pmd_init.isra.0+0x5d>
  8d3b01:	49 89 c9             	mov    %rcx,%r9
  8d3b04:	4c 2b 0e             	sub    (%rsi),%r9
  8d3b07:	4c 0b 0f             	or     (%rdi),%r9
  8d3b0a:	4c 89 08             	mov    %r9,(%rax)
  8d3b0d:	48 81 c1 00 00 20 00 	add    $0x200000,%rcx
  8d3b14:	4c 39 c1             	cmp    %r8,%rcx
  8d3b17:	72 bf                	jb     8d3ad8 <ident_pmd_init.isra.0+0x28>
  8d3b19:	5b                   	pop    %rbx
  8d3b1a:	c3                   	retq   
  8d3b1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3b20:	c3                   	retq   
  8d3b21:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d3b28:	00 00 00 00 
  8d3b2c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d3b30 <ident_pud_init>:
  8d3b30:	48 39 ca             	cmp    %rcx,%rdx
  8d3b33:	0f 83 4b 01 00 00    	jae    8d3c84 <ident_pud_init+0x154>
  8d3b39:	41 57                	push   %r15
  8d3b3b:	49 89 d7             	mov    %rdx,%r15
  8d3b3e:	41 56                	push   %r14
  8d3b40:	49 89 ce             	mov    %rcx,%r14
  8d3b43:	41 55                	push   %r13
  8d3b45:	49 bd ff ff ff 3f 00 	movabs $0xfff000003fffffff,%r13
  8d3b4c:	00 f0 ff 
  8d3b4f:	41 54                	push   %r12
  8d3b51:	49 89 fc             	mov    %rdi,%r12
  8d3b54:	55                   	push   %rbp
  8d3b55:	48 89 f5             	mov    %rsi,%rbp
  8d3b58:	53                   	push   %rbx
  8d3b59:	48 83 ec 18          	sub    $0x18,%rsp
  8d3b5d:	eb 30                	jmp    8d3b8f <ident_pud_init+0x5f>
  8d3b5f:	90                   	nop
  8d3b60:	48 b9 ff 0f 00 00 00 	movabs $0xfff0000000000fff,%rcx
  8d3b67:	00 f0 ff 
  8d3b6a:	48 85 f6             	test   %rsi,%rsi
  8d3b6d:	49 0f 45 cd          	cmovne %r13,%rcx
  8d3b71:	48 21 ca             	and    %rcx,%rdx
  8d3b74:	83 e2 01             	and    $0x1,%edx
  8d3b77:	75 0d                	jne    8d3b86 <ident_pud_init+0x56>
  8d3b79:	49 2b 44 24 18       	sub    0x18(%r12),%rax
  8d3b7e:	49 0b 44 24 10       	or     0x10(%r12),%rax
  8d3b83:	48 89 03             	mov    %rax,(%rbx)
  8d3b86:	4d 39 fe             	cmp    %r15,%r14
  8d3b89:	0f 86 af 00 00 00    	jbe    8d3c3e <ident_pud_init+0x10e>
  8d3b8f:	4c 89 fb             	mov    %r15,%rbx
  8d3b92:	4c 89 f8             	mov    %r15,%rax
  8d3b95:	4c 89 f9             	mov    %r15,%rcx
  8d3b98:	48 c1 eb 1b          	shr    $0x1b,%rbx
  8d3b9c:	48 25 00 00 00 c0    	and    $0xffffffffc0000000,%rax
  8d3ba2:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
  8d3ba8:	48 8d 90 00 00 00 40 	lea    0x40000000(%rax),%rdx
  8d3baf:	48 01 eb             	add    %rbp,%rbx
  8d3bb2:	49 39 d6             	cmp    %rdx,%r14
  8d3bb5:	49 0f 46 d6          	cmovbe %r14,%rdx
  8d3bb9:	49 89 d7             	mov    %rdx,%r15
  8d3bbc:	48 8b 13             	mov    (%rbx),%rdx
  8d3bbf:	48 89 d6             	mov    %rdx,%rsi
  8d3bc2:	81 e6 80 00 00 00    	and    $0x80,%esi
  8d3bc8:	41 80 7c 24 20 00    	cmpb   $0x0,0x20(%r12)
  8d3bce:	75 90                	jne    8d3b60 <ident_pud_init+0x30>
  8d3bd0:	48 b8 ff 0f 00 00 00 	movabs $0xfff0000000000fff,%rax
  8d3bd7:	00 f0 ff 
  8d3bda:	48 85 f6             	test   %rsi,%rsi
  8d3bdd:	48 bf 00 00 00 c0 ff 	movabs $0xfffffc0000000,%rdi
  8d3be4:	ff 0f 00 
  8d3be7:	48 be 00 f0 ff ff ff 	movabs $0xffffffffff000,%rsi
  8d3bee:	ff 0f 00 
  8d3bf1:	49 0f 45 c5          	cmovne %r13,%rax
  8d3bf5:	48 0f 45 f7          	cmovne %rdi,%rsi
  8d3bf9:	48 21 d0             	and    %rdx,%rax
  8d3bfc:	a8 01                	test   $0x1,%al
  8d3bfe:	75 50                	jne    8d3c50 <ident_pud_init+0x120>
  8d3c00:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d3c05:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
  8d3c0a:	41 ff 14 24          	callq  *(%r12)
  8d3c0e:	48 89 c2             	mov    %rax,%rdx
  8d3c11:	48 85 c0             	test   %rax,%rax
  8d3c14:	74 5a                	je     8d3c70 <ident_pud_init+0x140>
  8d3c16:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  8d3c1b:	49 8d 74 24 18       	lea    0x18(%r12),%rsi
  8d3c20:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  8d3c25:	4d 89 f8             	mov    %r15,%r8
  8d3c28:	e8 83 fe ff ff       	callq  8d3ab0 <ident_pmd_init.isra.0>
  8d3c2d:	49 0b 54 24 28       	or     0x28(%r12),%rdx
  8d3c32:	48 89 13             	mov    %rdx,(%rbx)
  8d3c35:	4d 39 fe             	cmp    %r15,%r14
  8d3c38:	0f 87 51 ff ff ff    	ja     8d3b8f <ident_pud_init+0x5f>
  8d3c3e:	48 83 c4 18          	add    $0x18,%rsp
  8d3c42:	31 c0                	xor    %eax,%eax
  8d3c44:	5b                   	pop    %rbx
  8d3c45:	5d                   	pop    %rbp
  8d3c46:	41 5c                	pop    %r12
  8d3c48:	41 5d                	pop    %r13
  8d3c4a:	41 5e                	pop    %r14
  8d3c4c:	41 5f                	pop    %r15
  8d3c4e:	c3                   	retq   
  8d3c4f:	90                   	nop
  8d3c50:	48 21 f2             	and    %rsi,%rdx
  8d3c53:	49 8d 7c 24 10       	lea    0x10(%r12),%rdi
  8d3c58:	49 8d 74 24 18       	lea    0x18(%r12),%rsi
  8d3c5d:	4d 89 f8             	mov    %r15,%r8
  8d3c60:	e8 4b fe ff ff       	callq  8d3ab0 <ident_pmd_init.isra.0>
  8d3c65:	e9 1c ff ff ff       	jmpq   8d3b86 <ident_pud_init+0x56>
  8d3c6a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d3c70:	48 83 c4 18          	add    $0x18,%rsp
  8d3c74:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8d3c79:	5b                   	pop    %rbx
  8d3c7a:	5d                   	pop    %rbp
  8d3c7b:	41 5c                	pop    %r12
  8d3c7d:	41 5d                	pop    %r13
  8d3c7f:	41 5e                	pop    %r14
  8d3c81:	41 5f                	pop    %r15
  8d3c83:	c3                   	retq   
  8d3c84:	31 c0                	xor    %eax,%eax
  8d3c86:	c3                   	retq   
  8d3c87:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d3c8e:	00 00 

00000000008d3c90 <ident_p4d_init>:
  8d3c90:	48 39 ca             	cmp    %rcx,%rdx
  8d3c93:	0f 83 ee 00 00 00    	jae    8d3d87 <ident_p4d_init+0xf7>
  8d3c99:	41 57                	push   %r15
  8d3c9b:	49 89 ff             	mov    %rdi,%r15
  8d3c9e:	41 56                	push   %r14
  8d3ca0:	41 55                	push   %r13
  8d3ca2:	49 89 d5             	mov    %rdx,%r13
  8d3ca5:	41 54                	push   %r12
  8d3ca7:	49 89 f4             	mov    %rsi,%r12
  8d3caa:	55                   	push   %rbp
  8d3cab:	53                   	push   %rbx
  8d3cac:	48 89 cb             	mov    %rcx,%rbx
  8d3caf:	48 83 ec 18          	sub    $0x18,%rsp
  8d3cb3:	8b 05 6f 85 00 00    	mov    0x856f(%rip),%eax        # 8dc228 <ptrs_per_p4d>
  8d3cb9:	4c 89 ea             	mov    %r13,%rdx
  8d3cbc:	48 b9 00 00 00 00 80 	movabs $0x8000000000,%rcx
  8d3cc3:	00 00 00 
  8d3cc6:	48 c1 ea 27          	shr    $0x27,%rdx
  8d3cca:	83 e8 01             	sub    $0x1,%eax
  8d3ccd:	48 21 d0             	and    %rdx,%rax
  8d3cd0:	4c 89 ea             	mov    %r13,%rdx
  8d3cd3:	49 8d 2c c4          	lea    (%r12,%rax,8),%rbp
  8d3cd7:	48 b8 00 00 00 00 80 	movabs $0xffffff8000000000,%rax
  8d3cde:	ff ff ff 
  8d3ce1:	4c 21 e8             	and    %r13,%rax
  8d3ce4:	48 8b 75 00          	mov    0x0(%rbp),%rsi
  8d3ce8:	48 01 c8             	add    %rcx,%rax
  8d3ceb:	48 39 c3             	cmp    %rax,%rbx
  8d3cee:	48 0f 46 c3          	cmovbe %rbx,%rax
  8d3cf2:	49 89 c5             	mov    %rax,%r13
  8d3cf5:	40 f6 c6 01          	test   $0x1,%sil
  8d3cf9:	75 55                	jne    8d3d50 <ident_p4d_init+0xc0>
  8d3cfb:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  8d3d00:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  8d3d04:	41 ff 17             	callq  *(%r15)
  8d3d07:	49 89 c6             	mov    %rax,%r14
  8d3d0a:	48 85 c0             	test   %rax,%rax
  8d3d0d:	74 71                	je     8d3d80 <ident_p4d_init+0xf0>
  8d3d0f:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d3d14:	4c 89 e9             	mov    %r13,%rcx
  8d3d17:	48 89 c6             	mov    %rax,%rsi
  8d3d1a:	4c 89 ff             	mov    %r15,%rdi
  8d3d1d:	e8 0e fe ff ff       	callq  8d3b30 <ident_pud_init>
  8d3d22:	85 c0                	test   %eax,%eax
  8d3d24:	75 46                	jne    8d3d6c <ident_p4d_init+0xdc>
  8d3d26:	49 8b 77 28          	mov    0x28(%r15),%rsi
  8d3d2a:	4c 09 f6             	or     %r14,%rsi
  8d3d2d:	48 89 75 00          	mov    %rsi,0x0(%rbp)
  8d3d31:	4c 39 eb             	cmp    %r13,%rbx
  8d3d34:	0f 87 79 ff ff ff    	ja     8d3cb3 <ident_p4d_init+0x23>
  8d3d3a:	48 83 c4 18          	add    $0x18,%rsp
  8d3d3e:	31 c0                	xor    %eax,%eax
  8d3d40:	5b                   	pop    %rbx
  8d3d41:	5d                   	pop    %rbp
  8d3d42:	41 5c                	pop    %r12
  8d3d44:	41 5d                	pop    %r13
  8d3d46:	41 5e                	pop    %r14
  8d3d48:	41 5f                	pop    %r15
  8d3d4a:	c3                   	retq   
  8d3d4b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3d50:	48 b8 00 f0 ff ff ff 	movabs $0xffffffffff000,%rax
  8d3d57:	ff 0f 00 
  8d3d5a:	4c 89 e9             	mov    %r13,%rcx
  8d3d5d:	4c 89 ff             	mov    %r15,%rdi
  8d3d60:	48 21 c6             	and    %rax,%rsi
  8d3d63:	e8 c8 fd ff ff       	callq  8d3b30 <ident_pud_init>
  8d3d68:	85 c0                	test   %eax,%eax
  8d3d6a:	74 c5                	je     8d3d31 <ident_p4d_init+0xa1>
  8d3d6c:	48 83 c4 18          	add    $0x18,%rsp
  8d3d70:	5b                   	pop    %rbx
  8d3d71:	5d                   	pop    %rbp
  8d3d72:	41 5c                	pop    %r12
  8d3d74:	41 5d                	pop    %r13
  8d3d76:	41 5e                	pop    %r14
  8d3d78:	41 5f                	pop    %r15
  8d3d7a:	c3                   	retq   
  8d3d7b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  8d3d80:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8d3d85:	eb e5                	jmp    8d3d6c <ident_p4d_init+0xdc>
  8d3d87:	31 c0                	xor    %eax,%eax
  8d3d89:	c3                   	retq   
  8d3d8a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d3d90 <alloc_pgt_page.part.0>:
  8d3d90:	53                   	push   %rbx
  8d3d91:	48 89 fb             	mov    %rdi,%rbx
  8d3d94:	48 8d 3d dd 78 00 00 	lea    0x78dd(%rip),%rdi        # 8db678 <kernel_info_end+0x4e8>
  8d3d9b:	e8 60 e5 ff ff       	callq  8d2300 <__putstr>
  8d3da0:	48 8d 3d 3c 79 00 00 	lea    0x793c(%rip),%rdi        # 8db6e3 <kernel_info_end+0x553>
  8d3da7:	e8 54 e5 ff ff       	callq  8d2300 <__putstr>
  8d3dac:	48 8b 7b 10          	mov    0x10(%rbx),%rdi
  8d3db0:	e8 eb e6 ff ff       	callq  8d24a0 <__puthex>
  8d3db5:	48 8d 3d 6f 78 00 00 	lea    0x786f(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d3dbc:	e8 3f e5 ff ff       	callq  8d2300 <__putstr>
  8d3dc1:	48 8d 3d 35 79 00 00 	lea    0x7935(%rip),%rdi        # 8db6fd <kernel_info_end+0x56d>
  8d3dc8:	e8 33 e5 ff ff       	callq  8d2300 <__putstr>
  8d3dcd:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  8d3dd1:	e8 ca e6 ff ff       	callq  8d24a0 <__puthex>
  8d3dd6:	48 8d 3d 4e 78 00 00 	lea    0x784e(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d3ddd:	e8 1e e5 ff ff       	callq  8d2300 <__putstr>
  8d3de2:	31 c0                	xor    %eax,%eax
  8d3de4:	5b                   	pop    %rbx
  8d3de5:	c3                   	retq   
  8d3de6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d3ded:	00 00 00 

00000000008d3df0 <alloc_pgt_page>:
  8d3df0:	f3 0f 1e fa          	endbr64 
  8d3df4:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8d3df8:	48 3b 47 08          	cmp    0x8(%rdi),%rax
  8d3dfc:	73 1a                	jae    8d3e18 <alloc_pgt_page+0x28>
  8d3dfe:	4c 8b 07             	mov    (%rdi),%r8
  8d3e01:	49 01 c0             	add    %rax,%r8
  8d3e04:	48 05 00 10 00 00    	add    $0x1000,%rax
  8d3e0a:	48 89 47 10          	mov    %rax,0x10(%rdi)
  8d3e0e:	4c 89 c0             	mov    %r8,%rax
  8d3e11:	c3                   	retq   
  8d3e12:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d3e18:	e9 73 ff ff ff       	jmpq   8d3d90 <alloc_pgt_page.part.0>
  8d3e1d:	0f 1f 00             	nopl   (%rax)

00000000008d3e20 <set_clr_page_flags.constprop.0>:
  8d3e20:	41 54                	push   %r12
  8d3e22:	48 8b 05 07 d5 01 00 	mov    0x1d507(%rip),%rax        # 8f1330 <top_level_pgt>
  8d3e29:	55                   	push   %rbp
  8d3e2a:	48 89 f5             	mov    %rsi,%rbp
  8d3e2d:	53                   	push   %rbx
  8d3e2e:	48 89 fb             	mov    %rdi,%rbx
  8d3e31:	4c 8b 0f             	mov    (%rdi),%r9
  8d3e34:	8b 15 f6 83 00 00    	mov    0x83f6(%rip),%edx        # 8dc230 <__pgtable_l5_enabled>
  8d3e3a:	85 d2                	test   %edx,%edx
  8d3e3c:	74 24                	je     8d3e62 <set_clr_page_flags.constprop.0+0x42>
  8d3e3e:	8b 15 e4 83 00 00    	mov    0x83e4(%rip),%edx        # 8dc228 <ptrs_per_p4d>
  8d3e44:	8d 4a ff             	lea    -0x1(%rdx),%ecx
  8d3e47:	48 89 fa             	mov    %rdi,%rdx
  8d3e4a:	48 c1 ea 27          	shr    $0x27,%rdx
  8d3e4e:	48 21 d1             	and    %rdx,%rcx
  8d3e51:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
  8d3e58:	ff 0f 00 
  8d3e5b:	48 23 10             	and    (%rax),%rdx
  8d3e5e:	48 8d 04 ca          	lea    (%rdx,%rcx,8),%rax
  8d3e62:	48 b9 00 f0 ff ff ff 	movabs $0xffffffffff000,%rcx
  8d3e69:	ff 0f 00 
  8d3e6c:	48 8b 10             	mov    (%rax),%rdx
  8d3e6f:	48 89 d8             	mov    %rbx,%rax
  8d3e72:	49 bc 00 00 00 c0 ff 	movabs $0xfffffc0000000,%r12
  8d3e79:	ff 0f 00 
  8d3e7c:	48 bf ff 0f 00 00 00 	movabs $0xfff0000000000fff,%rdi
  8d3e83:	00 f0 ff 
  8d3e86:	48 c1 e8 1e          	shr    $0x1e,%rax
  8d3e8a:	48 21 ca             	and    %rcx,%rdx
  8d3e8d:	25 ff 01 00 00       	and    $0x1ff,%eax
  8d3e92:	48 8b 14 c2          	mov    (%rdx,%rax,8),%rdx
  8d3e96:	f6 c2 80             	test   $0x80,%dl
  8d3e99:	4c 0f 44 e1          	cmove  %rcx,%r12
  8d3e9d:	4c 21 e2             	and    %r12,%rdx
  8d3ea0:	49 89 dc             	mov    %rbx,%r12
  8d3ea3:	49 c1 ec 12          	shr    $0x12,%r12
  8d3ea7:	41 81 e4 f8 0f 00 00 	and    $0xff8,%r12d
  8d3eae:	49 01 d4             	add    %rdx,%r12
  8d3eb1:	48 ba ff ff 1f 00 00 	movabs $0xfff00000001fffff,%rdx
  8d3eb8:	00 f0 ff 
  8d3ebb:	49 8b 04 24          	mov    (%r12),%rax
  8d3ebf:	48 89 c6             	mov    %rax,%rsi
  8d3ec2:	81 e6 80 00 00 00    	and    $0x80,%esi
  8d3ec8:	48 be 00 00 e0 ff ff 	movabs $0xfffffffe00000,%rsi
  8d3ecf:	ff 0f 00 
  8d3ed2:	48 0f 44 d7          	cmove  %rdi,%rdx
  8d3ed6:	48 0f 45 ce          	cmovne %rsi,%rcx
  8d3eda:	48 21 c2             	and    %rax,%rdx
  8d3edd:	81 e2 80 00 00 00    	and    $0x80,%edx
  8d3ee3:	75 33                	jne    8d3f18 <set_clr_page_flags.constprop.0+0xf8>
  8d3ee5:	48 c1 eb 09          	shr    $0x9,%rbx
  8d3ee9:	48 21 c8             	and    %rcx,%rax
  8d3eec:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
  8d3ef2:	48 01 c3             	add    %rax,%rbx
  8d3ef5:	0f 84 9d 00 00 00    	je     8d3f98 <set_clr_page_flags.constprop.0+0x178>
  8d3efb:	48 f7 d5             	not    %rbp
  8d3efe:	48 23 2b             	and    (%rbx),%rbp
  8d3f01:	48 8b 05 28 d4 01 00 	mov    0x1d428(%rip),%rax        # 8f1330 <top_level_pgt>
  8d3f08:	48 89 2b             	mov    %rbp,(%rbx)
  8d3f0b:	0f 22 d8             	mov    %rax,%cr3
  8d3f0e:	31 c0                	xor    %eax,%eax
  8d3f10:	5b                   	pop    %rbx
  8d3f11:	5d                   	pop    %rbp
  8d3f12:	41 5c                	pop    %r12
  8d3f14:	c3                   	retq   
  8d3f15:	0f 1f 00             	nopl   (%rax)
  8d3f18:	48 8b 3d e9 d3 01 00 	mov    0x1d3e9(%rip),%rdi        # 8f1308 <mapping_info+0x8>
  8d3f1f:	ff 15 db d3 01 00    	callq  *0x1d3db(%rip)        # 8f1300 <mapping_info>
  8d3f25:	48 85 c0             	test   %rax,%rax
  8d3f28:	74 6e                	je     8d3f98 <set_clr_page_flags.constprop.0+0x178>
  8d3f2a:	48 8b 3d df d3 01 00 	mov    0x1d3df(%rip),%rdi        # 8f1310 <mapping_info+0x10>
  8d3f31:	48 89 da             	mov    %rbx,%rdx
  8d3f34:	48 89 c1             	mov    %rax,%rcx
  8d3f37:	48 81 e2 00 00 e0 ff 	and    $0xffffffffffe00000,%rdx
  8d3f3e:	40 80 e7 7f          	and    $0x7f,%dil
  8d3f42:	4c 8d 82 00 00 20 00 	lea    0x200000(%rdx),%r8
  8d3f49:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d3f50:	48 89 fe             	mov    %rdi,%rsi
  8d3f53:	48 83 c1 08          	add    $0x8,%rcx
  8d3f57:	48 09 d6             	or     %rdx,%rsi
  8d3f5a:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
  8d3f61:	48 89 71 f8          	mov    %rsi,-0x8(%rcx)
  8d3f65:	4c 39 c2             	cmp    %r8,%rdx
  8d3f68:	75 e6                	jne    8d3f50 <set_clr_page_flags.constprop.0+0x130>
  8d3f6a:	48 8b 15 b7 d3 01 00 	mov    0x1d3b7(%rip),%rdx        # 8f1328 <mapping_info+0x28>
  8d3f71:	48 09 c2             	or     %rax,%rdx
  8d3f74:	49 89 14 24          	mov    %rdx,(%r12)
  8d3f78:	48 8b 15 b1 d3 01 00 	mov    0x1d3b1(%rip),%rdx        # 8f1330 <top_level_pgt>
  8d3f7f:	0f 22 da             	mov    %rdx,%cr3
  8d3f82:	48 c1 eb 09          	shr    $0x9,%rbx
  8d3f86:	81 e3 f8 0f 00 00    	and    $0xff8,%ebx
  8d3f8c:	48 01 c3             	add    %rax,%rbx
  8d3f8f:	e9 67 ff ff ff       	jmpq   8d3efb <set_clr_page_flags.constprop.0+0xdb>
  8d3f94:	0f 1f 40 00          	nopl   0x0(%rax)
  8d3f98:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8d3f9d:	e9 6e ff ff ff       	jmpq   8d3f10 <set_clr_page_flags.constprop.0+0xf0>
  8d3fa2:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d3fa9:	00 00 00 00 
  8d3fad:	0f 1f 00             	nopl   (%rax)

00000000008d3fb0 <kernel_ident_mapping_init>:
  8d3fb0:	f3 0f 1e fa          	endbr64 
  8d3fb4:	41 57                	push   %r15
  8d3fb6:	49 89 ff             	mov    %rdi,%r15
  8d3fb9:	41 56                	push   %r14
  8d3fbb:	41 55                	push   %r13
  8d3fbd:	41 54                	push   %r12
  8d3fbf:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  8d3fc5:	55                   	push   %rbp
  8d3fc6:	48 89 f5             	mov    %rsi,%rbp
  8d3fc9:	53                   	push   %rbx
  8d3fca:	48 83 ec 18          	sub    $0x18,%rsp
  8d3fce:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8d3fd2:	4c 8b 77 18          	mov    0x18(%rdi),%r14
  8d3fd6:	49 8d 1c 16          	lea    (%r14,%rdx,1),%rbx
  8d3fda:	49 01 ce             	add    %rcx,%r14
  8d3fdd:	ba 63 00 00 00       	mov    $0x63,%edx
  8d3fe2:	48 85 c0             	test   %rax,%rax
  8d3fe5:	48 0f 44 c2          	cmove  %rdx,%rax
  8d3fe9:	48 23 05 68 82 00 00 	and    0x8268(%rip),%rax        # 8dc258 <__default_kernel_pte_mask>
  8d3ff0:	48 89 47 28          	mov    %rax,0x28(%rdi)
  8d3ff4:	4c 39 f3             	cmp    %r14,%rbx
  8d3ff7:	0f 83 9b 00 00 00    	jae    8d4098 <kernel_ident_mapping_init+0xe8>
  8d3ffd:	8b 0d 29 82 00 00    	mov    0x8229(%rip),%ecx        # 8dc22c <pgdir_shift>
  8d4003:	48 89 d8             	mov    %rbx,%rax
  8d4006:	4c 89 e2             	mov    %r12,%rdx
  8d4009:	48 d3 e8             	shr    %cl,%rax
  8d400c:	48 d3 e2             	shl    %cl,%rdx
  8d400f:	8b 0d 1b 82 00 00    	mov    0x821b(%rip),%ecx        # 8dc230 <__pgtable_l5_enabled>
  8d4015:	25 ff 01 00 00       	and    $0x1ff,%eax
  8d401a:	4c 8d 6c c5 00       	lea    0x0(%rbp,%rax,8),%r13
  8d401f:	48 89 d0             	mov    %rdx,%rax
  8d4022:	48 f7 d8             	neg    %rax
  8d4025:	48 21 d8             	and    %rbx,%rax
  8d4028:	48 01 d0             	add    %rdx,%rax
  8d402b:	48 89 da             	mov    %rbx,%rdx
  8d402e:	49 39 c6             	cmp    %rax,%r14
  8d4031:	49 0f 46 c6          	cmovbe %r14,%rax
  8d4035:	48 89 c3             	mov    %rax,%rbx
  8d4038:	85 c9                	test   %ecx,%ecx
  8d403a:	74 71                	je     8d40ad <kernel_ident_mapping_init+0xfd>
  8d403c:	49 8b 45 00          	mov    0x0(%r13),%rax
  8d4040:	a8 01                	test   $0x1,%al
  8d4042:	75 5c                	jne    8d40a0 <kernel_ident_mapping_init+0xf0>
  8d4044:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  8d4049:	49 8b 7f 08          	mov    0x8(%r15),%rdi
  8d404d:	41 ff 17             	callq  *(%r15)
  8d4050:	48 89 c6             	mov    %rax,%rsi
  8d4053:	48 85 c0             	test   %rax,%rax
  8d4056:	0f 84 86 00 00 00    	je     8d40e2 <kernel_ident_mapping_init+0x132>
  8d405c:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d4061:	48 89 d9             	mov    %rbx,%rcx
  8d4064:	4c 89 ff             	mov    %r15,%rdi
  8d4067:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d406c:	e8 1f fc ff ff       	callq  8d3c90 <ident_p4d_init>
  8d4071:	85 c0                	test   %eax,%eax
  8d4073:	75 4a                	jne    8d40bf <kernel_ident_mapping_init+0x10f>
  8d4075:	8b 15 b5 81 00 00    	mov    0x81b5(%rip),%edx        # 8dc230 <__pgtable_l5_enabled>
  8d407b:	49 8b 47 28          	mov    0x28(%r15),%rax
  8d407f:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d4084:	85 d2                	test   %edx,%edx
  8d4086:	74 48                	je     8d40d0 <kernel_ident_mapping_init+0x120>
  8d4088:	48 09 f0             	or     %rsi,%rax
  8d408b:	49 89 45 00          	mov    %rax,0x0(%r13)
  8d408f:	4c 39 f3             	cmp    %r14,%rbx
  8d4092:	0f 82 65 ff ff ff    	jb     8d3ffd <kernel_ident_mapping_init+0x4d>
  8d4098:	31 c0                	xor    %eax,%eax
  8d409a:	eb 23                	jmp    8d40bf <kernel_ident_mapping_init+0x10f>
  8d409c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d40a0:	49 bd 00 f0 ff ff ff 	movabs $0xffffffffff000,%r13
  8d40a7:	ff 0f 00 
  8d40aa:	49 21 c5             	and    %rax,%r13
  8d40ad:	48 89 d9             	mov    %rbx,%rcx
  8d40b0:	4c 89 ee             	mov    %r13,%rsi
  8d40b3:	4c 89 ff             	mov    %r15,%rdi
  8d40b6:	e8 d5 fb ff ff       	callq  8d3c90 <ident_p4d_init>
  8d40bb:	85 c0                	test   %eax,%eax
  8d40bd:	74 d0                	je     8d408f <kernel_ident_mapping_init+0xdf>
  8d40bf:	48 83 c4 18          	add    $0x18,%rsp
  8d40c3:	5b                   	pop    %rbx
  8d40c4:	5d                   	pop    %rbp
  8d40c5:	41 5c                	pop    %r12
  8d40c7:	41 5d                	pop    %r13
  8d40c9:	41 5e                	pop    %r14
  8d40cb:	41 5f                	pop    %r15
  8d40cd:	c3                   	retq   
  8d40ce:	66 90                	xchg   %ax,%ax
  8d40d0:	48 bf 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdi
  8d40d7:	ff 0f 00 
  8d40da:	48 23 3e             	and    (%rsi),%rdi
  8d40dd:	48 89 fe             	mov    %rdi,%rsi
  8d40e0:	eb a6                	jmp    8d4088 <kernel_ident_mapping_init+0xd8>
  8d40e2:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8d40e7:	eb d6                	jmp    8d40bf <kernel_ident_mapping_init+0x10f>
  8d40e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)

00000000008d40f0 <add_identity_map>:
  8d40f0:	48 8d 4e ff          	lea    -0x1(%rsi),%rcx
  8d40f4:	48 89 fa             	mov    %rdi,%rdx
  8d40f7:	48 81 c9 ff ff 1f 00 	or     $0x1fffff,%rcx
  8d40fe:	48 81 e2 00 00 e0 ff 	and    $0xffffffffffe00000,%rdx
  8d4105:	48 83 c1 01          	add    $0x1,%rcx
  8d4109:	48 39 ca             	cmp    %rcx,%rdx
  8d410c:	72 02                	jb     8d4110 <add_identity_map+0x20>
  8d410e:	c3                   	retq   
  8d410f:	90                   	nop
  8d4110:	48 83 ec 08          	sub    $0x8,%rsp
  8d4114:	48 8b 35 15 d2 01 00 	mov    0x1d215(%rip),%rsi        # 8f1330 <top_level_pgt>
  8d411b:	48 8d 3d de d1 01 00 	lea    0x1d1de(%rip),%rdi        # 8f1300 <mapping_info>
  8d4122:	e8 89 fe ff ff       	callq  8d3fb0 <kernel_ident_mapping_init>
  8d4127:	85 c0                	test   %eax,%eax
  8d4129:	75 05                	jne    8d4130 <add_identity_map+0x40>
  8d412b:	48 83 c4 08          	add    $0x8,%rsp
  8d412f:	c3                   	retq   
  8d4130:	48 8d 3d 81 75 00 00 	lea    0x7581(%rip),%rdi        # 8db6b8 <kernel_info_end+0x528>
  8d4137:	e8 54 f4 ff ff       	callq  8d3590 <error>
  8d413c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d4140 <initialize_identity_maps>:
  8d4140:	f3 0f 1e fa          	endbr64 
  8d4144:	48 8d 05 a5 fc ff ff 	lea    -0x35b(%rip),%rax        # 8d3df0 <alloc_pgt_page>
  8d414b:	55                   	push   %rbp
  8d414c:	48 89 fd             	mov    %rdi,%rbp
  8d414f:	48 89 05 aa d1 01 00 	mov    %rax,0x1d1aa(%rip)        # 8f1300 <mapping_info>
  8d4156:	48 8d 05 e3 d1 01 00 	lea    0x1d1e3(%rip),%rax        # 8f1340 <pgt_data>
  8d415d:	48 89 05 a4 d1 01 00 	mov    %rax,0x1d1a4(%rip)        # 8f1308 <mapping_info+0x8>
  8d4164:	48 c7 05 a1 d1 01 00 	movq   $0x1e3,0x1d1a1(%rip)        # 8f1310 <mapping_info+0x10>
  8d416b:	e3 01 00 00 
  8d416f:	48 c7 05 ae d1 01 00 	movq   $0x63,0x1d1ae(%rip)        # 8f1328 <mapping_info+0x28>
  8d4176:	63 00 00 00 
  8d417a:	48 c7 05 cb d1 01 00 	movq   $0x0,0x1d1cb(%rip)        # 8f1350 <pgt_data+0x10>
  8d4181:	00 00 00 00 
  8d4185:	0f 20 d8             	mov    %cr3,%rax
  8d4188:	48 ba 00 f0 ff ff ff 	movabs $0x7ffffffffffff000,%rdx
  8d418f:	ff ff 7f 
  8d4192:	48 21 d0             	and    %rdx,%rax
  8d4195:	8b 15 95 80 00 00    	mov    0x8095(%rip),%edx        # 8dc230 <__pgtable_l5_enabled>
  8d419b:	48 89 05 8e d1 01 00 	mov    %rax,0x1d18e(%rip)        # 8f1330 <top_level_pgt>
  8d41a2:	85 d2                	test   %edx,%edx
  8d41a4:	74 10                	je     8d41b6 <initialize_identity_maps+0x76>
  8d41a6:	48 ba 00 f0 ff ff ff 	movabs $0xffffffffff000,%rdx
  8d41ad:	ff 0f 00 
  8d41b0:	48 23 10             	and    (%rax),%rdx
  8d41b3:	48 89 d0             	mov    %rdx,%rax
  8d41b6:	48 8d 3d 43 fe 01 00 	lea    0x1fe43(%rip),%rdi        # 8f4000 <pgtable>
  8d41bd:	48 39 f8             	cmp    %rdi,%rax
  8d41c0:	0f 84 aa 00 00 00    	je     8d4270 <initialize_identity_maps+0x130>
  8d41c6:	ba 00 60 00 00       	mov    $0x6000,%edx
  8d41cb:	31 f6                	xor    %esi,%esi
  8d41cd:	48 89 3d 6c d1 01 00 	mov    %rdi,0x1d16c(%rip)        # 8f1340 <pgt_data>
  8d41d4:	48 c7 05 69 d1 01 00 	movq   $0x6000,0x1d169(%rip)        # 8f1348 <pgt_data+0x8>
  8d41db:	00 60 00 00 
  8d41df:	e8 8c ee ff ff       	callq  8d3070 <memset>
  8d41e4:	48 8b 15 65 d1 01 00 	mov    0x1d165(%rip),%rdx        # 8f1350 <pgt_data+0x10>
  8d41eb:	48 3b 15 56 d1 01 00 	cmp    0x1d156(%rip),%rdx        # 8f1348 <pgt_data+0x8>
  8d41f2:	0f 83 a8 00 00 00    	jae    8d42a0 <initialize_identity_maps+0x160>
  8d41f8:	48 8b 05 41 d1 01 00 	mov    0x1d141(%rip),%rax        # 8f1340 <pgt_data>
  8d41ff:	48 01 d0             	add    %rdx,%rax
  8d4202:	48 81 c2 00 10 00 00 	add    $0x1000,%rdx
  8d4209:	48 89 15 40 d1 01 00 	mov    %rdx,0x1d140(%rip)        # 8f1350 <pgt_data+0x10>
  8d4210:	48 89 05 19 d1 01 00 	mov    %rax,0x1d119(%rip)        # 8f1330 <top_level_pgt>
  8d4217:	48 8d 35 e2 6d 02 00 	lea    0x26de2(%rip),%rsi        # 8fb000 <_end>
  8d421e:	48 8d 3d db bd 72 ff 	lea    -0x8d4225(%rip),%rdi        # 0 <startup_32>
  8d4225:	e8 c6 fe ff ff       	callq  8d40f0 <add_identity_map>
  8d422a:	48 8d b5 00 10 00 00 	lea    0x1000(%rbp),%rsi
  8d4231:	48 89 ef             	mov    %rbp,%rdi
  8d4234:	48 89 2d 25 f1 01 00 	mov    %rbp,0x1f125(%rip)        # 8f3360 <boot_params>
  8d423b:	e8 b0 fe ff ff       	callq  8d40f0 <add_identity_map>
  8d4240:	e8 9b f2 ff ff       	callq  8d34e0 <get_cmd_line_ptr>
  8d4245:	48 89 c7             	mov    %rax,%rdi
  8d4248:	48 8d b0 00 08 00 00 	lea    0x800(%rax),%rsi
  8d424f:	e8 9c fe ff ff       	callq  8d40f0 <add_identity_map>
  8d4254:	48 8b 3d d5 d0 01 00 	mov    0x1d0d5(%rip),%rdi        # 8f1330 <top_level_pgt>
  8d425b:	e8 50 03 00 00       	callq  8d45b0 <sev_verify_cbit>
  8d4260:	48 8b 05 c9 d0 01 00 	mov    0x1d0c9(%rip),%rax        # 8f1330 <top_level_pgt>
  8d4267:	0f 22 d8             	mov    %rax,%cr3
  8d426a:	5d                   	pop    %rbp
  8d426b:	c3                   	retq   
  8d426c:	0f 1f 40 00          	nopl   0x0(%rax)
  8d4270:	48 81 c7 00 60 00 00 	add    $0x6000,%rdi
  8d4277:	31 d2                	xor    %edx,%edx
  8d4279:	31 f6                	xor    %esi,%esi
  8d427b:	48 c7 05 c2 d0 01 00 	movq   $0x0,0x1d0c2(%rip)        # 8f1348 <pgt_data+0x8>
  8d4282:	00 00 00 00 
  8d4286:	48 89 3d b3 d0 01 00 	mov    %rdi,0x1d0b3(%rip)        # 8f1340 <pgt_data>
  8d428d:	e8 de ed ff ff       	callq  8d3070 <memset>
  8d4292:	e9 80 ff ff ff       	jmpq   8d4217 <initialize_identity_maps+0xd7>
  8d4297:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d429e:	00 00 
  8d42a0:	48 8d 3d 99 d0 01 00 	lea    0x1d099(%rip),%rdi        # 8f1340 <pgt_data>
  8d42a7:	e8 e4 fa ff ff       	callq  8d3d90 <alloc_pgt_page.part.0>
  8d42ac:	e9 5f ff ff ff       	jmpq   8d4210 <initialize_identity_maps+0xd0>
  8d42b1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d42b8:	00 00 00 00 
  8d42bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d42c0 <set_page_decrypted>:
  8d42c0:	f3 0f 1e fa          	endbr64 
  8d42c4:	31 f6                	xor    %esi,%esi
  8d42c6:	e9 55 fb ff ff       	jmpq   8d3e20 <set_clr_page_flags.constprop.0>
  8d42cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008d42d0 <set_page_encrypted>:
  8d42d0:	f3 0f 1e fa          	endbr64 
  8d42d4:	eb ea                	jmp    8d42c0 <set_page_decrypted>
  8d42d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d42dd:	00 00 00 

00000000008d42e0 <set_page_non_present>:
  8d42e0:	f3 0f 1e fa          	endbr64 
  8d42e4:	be 01 00 00 00       	mov    $0x1,%esi
  8d42e9:	e9 32 fb ff ff       	jmpq   8d3e20 <set_clr_page_flags.constprop.0>
  8d42ee:	66 90                	xchg   %ax,%ax

00000000008d42f0 <do_boot_page_fault>:
  8d42f0:	f3 0f 1e fa          	endbr64 
  8d42f4:	55                   	push   %rbp
  8d42f5:	53                   	push   %rbx
  8d42f6:	48 83 ec 18          	sub    $0x18,%rsp
  8d42fa:	0f 20 d5             	mov    %cr2,%rbp
  8d42fd:	48 81 e5 00 00 e0 ff 	and    $0xffffffffffe00000,%rbp
  8d4304:	40 f6 c6 0d          	test   $0xd,%sil
  8d4308:	75 18                	jne    8d4322 <do_boot_page_fault+0x32>
  8d430a:	4c 8d 85 00 00 20 00 	lea    0x200000(%rbp),%r8
  8d4311:	48 83 c4 18          	add    $0x18,%rsp
  8d4315:	48 89 ef             	mov    %rbp,%rdi
  8d4318:	5b                   	pop    %rbx
  8d4319:	4c 89 c6             	mov    %r8,%rsi
  8d431c:	5d                   	pop    %rbp
  8d431d:	e9 ce fd ff ff       	jmpq   8d40f0 <add_identity_map>
  8d4322:	48 8b 9f 80 00 00 00 	mov    0x80(%rdi),%rbx
  8d4329:	48 8d 3d e5 73 00 00 	lea    0x73e5(%rip),%rdi        # 8db715 <kernel_info_end+0x585>
  8d4330:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8d4335:	e8 c6 df ff ff       	callq  8d2300 <__putstr>
  8d433a:	48 8d 3d eb 73 00 00 	lea    0x73eb(%rip),%rdi        # 8db72c <kernel_info_end+0x59c>
  8d4341:	e8 ba df ff ff       	callq  8d2300 <__putstr>
  8d4346:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d434b:	48 89 f7             	mov    %rsi,%rdi
  8d434e:	e8 4d e1 ff ff       	callq  8d24a0 <__puthex>
  8d4353:	48 8d 3d e0 73 00 00 	lea    0x73e0(%rip),%rdi        # 8db73a <kernel_info_end+0x5aa>
  8d435a:	e8 a1 df ff ff       	callq  8d2300 <__putstr>
  8d435f:	48 89 ef             	mov    %rbp,%rdi
  8d4362:	e8 39 e1 ff ff       	callq  8d24a0 <__puthex>
  8d4367:	48 8d 3d d5 73 00 00 	lea    0x73d5(%rip),%rdi        # 8db743 <kernel_info_end+0x5b3>
  8d436e:	e8 8d df ff ff       	callq  8d2300 <__putstr>
  8d4373:	48 8d 05 86 bc 72 ff 	lea    -0x8d437a(%rip),%rax        # 0 <startup_32>
  8d437a:	48 29 c3             	sub    %rax,%rbx
  8d437d:	48 89 df             	mov    %rbx,%rdi
  8d4380:	e8 1b e1 ff ff       	callq  8d24a0 <__puthex>
  8d4385:	48 8d 3d 9f 72 00 00 	lea    0x729f(%rip),%rdi        # 8db62b <kernel_info_end+0x49b>
  8d438c:	e8 6f df ff ff       	callq  8d2300 <__putstr>
  8d4391:	48 8d 3d c6 73 00 00 	lea    0x73c6(%rip),%rdi        # 8db75e <kernel_info_end+0x5ce>
  8d4398:	e8 f3 f1 ff ff       	callq  8d3590 <error>
  8d439d:	0f 1f 00             	nopl   (%rax)

00000000008d43a0 <load_stage1_idt>:
  8d43a0:	f3 0f 1e fa          	endbr64 
  8d43a4:	48 8d 05 55 7c 00 00 	lea    0x7c55(%rip),%rax        # 8dc000 <boot_idt>
  8d43ab:	48 89 05 40 7c 00 00 	mov    %rax,0x7c40(%rip)        # 8dbff2 <boot_idt_desc+0x2>
  8d43b2:	0f 01 1d 37 7c 00 00 	lidt   0x7c37(%rip)        # 8dbff0 <boot_idt_desc>
  8d43b9:	c3                   	retq   
  8d43ba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d43c0 <load_stage2_idt>:
  8d43c0:	f3 0f 1e fa          	endbr64 
  8d43c4:	55                   	push   %rbp
  8d43c5:	31 f6                	xor    %esi,%esi
  8d43c7:	48 8d 05 32 7c 00 00 	lea    0x7c32(%rip),%rax        # 8dc000 <boot_idt>
  8d43ce:	ba 10 00 00 00       	mov    $0x10,%edx
  8d43d3:	53                   	push   %rbx
  8d43d4:	48 8d 1d 85 00 00 00 	lea    0x85(%rip),%rbx        # 8d4460 <boot_page_fault>
  8d43db:	48 83 ec 18          	sub    $0x18,%rsp
  8d43df:	48 89 05 0c 7c 00 00 	mov    %rax,0x7c0c(%rip)        # 8dbff2 <boot_idt_desc+0x2>
  8d43e6:	48 89 e5             	mov    %rsp,%rbp
  8d43e9:	48 89 ef             	mov    %rbp,%rdi
  8d43ec:	e8 7f ec ff ff       	callq  8d3070 <memset>
  8d43f1:	8b 44 24 02          	mov    0x2(%rsp),%eax
  8d43f5:	48 89 ee             	mov    %rbp,%rsi
  8d43f8:	ba 10 00 00 00       	mov    $0x10,%edx
  8d43fd:	66 89 1c 24          	mov    %bx,(%rsp)
  8d4401:	48 8d 3d d8 7c 00 00 	lea    0x7cd8(%rip),%rdi        # 8dc0e0 <boot_idt+0xe0>
  8d4408:	25 00 00 ff 60       	and    $0x60ff0000,%eax
  8d440d:	0d 10 00 00 8f       	or     $0x8f000010,%eax
  8d4412:	89 44 24 02          	mov    %eax,0x2(%rsp)
  8d4416:	48 89 d8             	mov    %rbx,%rax
  8d4419:	48 c1 eb 20          	shr    $0x20,%rbx
  8d441d:	48 c1 e8 10          	shr    $0x10,%rax
  8d4421:	89 5c 24 08          	mov    %ebx,0x8(%rsp)
  8d4425:	66 89 44 24 06       	mov    %ax,0x6(%rsp)
  8d442a:	e8 c1 ec ff ff       	callq  8d30f0 <memcpy>
  8d442f:	0f 01 1d ba 7b 00 00 	lidt   0x7bba(%rip)        # 8dbff0 <boot_idt_desc>
  8d4436:	48 83 c4 18          	add    $0x18,%rsp
  8d443a:	5b                   	pop    %rbx
  8d443b:	5d                   	pop    %rbp
  8d443c:	c3                   	retq   
  8d443d:	0f 1f 00             	nopl   (%rax)

00000000008d4440 <cleanup_exception_handling>:
  8d4440:	f3 0f 1e fa          	endbr64 
  8d4444:	48 c7 05 a3 7b 00 00 	movq   $0x0,0x7ba3(%rip)        # 8dbff2 <boot_idt_desc+0x2>
  8d444b:	00 00 00 00 
  8d444f:	31 c0                	xor    %eax,%eax
  8d4451:	66 89 05 98 7b 00 00 	mov    %ax,0x7b98(%rip)        # 8dbff0 <boot_idt_desc>
  8d4458:	0f 01 1d 91 7b 00 00 	lidt   0x7b91(%rip)        # 8dbff0 <boot_idt_desc>
  8d445f:	c3                   	retq   

00000000008d4460 <boot_page_fault>:
  8d4460:	57                   	push   %rdi
  8d4461:	56                   	push   %rsi
  8d4462:	52                   	push   %rdx
  8d4463:	51                   	push   %rcx
  8d4464:	50                   	push   %rax
  8d4465:	41 50                	push   %r8
  8d4467:	41 51                	push   %r9
  8d4469:	41 52                	push   %r10
  8d446b:	41 53                	push   %r11
  8d446d:	53                   	push   %rbx
  8d446e:	55                   	push   %rbp
  8d446f:	41 54                	push   %r12
  8d4471:	41 55                	push   %r13
  8d4473:	41 56                	push   %r14
  8d4475:	41 57                	push   %r15
  8d4477:	48 89 e7             	mov    %rsp,%rdi
  8d447a:	48 8b 74 24 78       	mov    0x78(%rsp),%rsi
  8d447f:	e8 6c fe ff ff       	callq  8d42f0 <do_boot_page_fault>
  8d4484:	41 5f                	pop    %r15
  8d4486:	41 5e                	pop    %r14
  8d4488:	41 5d                	pop    %r13
  8d448a:	41 5c                	pop    %r12
  8d448c:	5d                   	pop    %rbp
  8d448d:	5b                   	pop    %rbx
  8d448e:	41 5b                	pop    %r11
  8d4490:	41 5a                	pop    %r10
  8d4492:	41 59                	pop    %r9
  8d4494:	41 58                	pop    %r8
  8d4496:	58                   	pop    %rax
  8d4497:	59                   	pop    %rcx
  8d4498:	5a                   	pop    %rdx
  8d4499:	5e                   	pop    %rsi
  8d449a:	5f                   	pop    %rdi
  8d449b:	48 83 c4 08          	add    $0x8,%rsp
  8d449f:	48 cf                	iretq  
  8d44a1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d44a8:	00 00 00 
  8d44ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008d44b0 <get_sev_encryption_bit>:
  8d44b0:	31 c0                	xor    %eax,%eax
  8d44b2:	c3                   	retq   
  8d44b3:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d44ba:	00 00 00 00 
  8d44be:	66 90                	xchg   %ax,%ax

00000000008d44c0 <sev_es_req_cpuid>:
  8d44c0:	c1 e0 1e             	shl    $0x1e,%eax
  8d44c3:	83 c8 04             	or     $0x4,%eax
  8d44c6:	b9 30 01 01 c0       	mov    $0xc0010130,%ecx
  8d44cb:	0f 30                	wrmsr  
  8d44cd:	f3 0f 01 d9          	repz vmmcall 
  8d44d1:	0f 32                	rdmsr  
  8d44d3:	89 c1                	mov    %eax,%ecx
  8d44d5:	81 e1 00 f0 ff 3f    	and    $0x3ffff000,%ecx
  8d44db:	75 0d                	jne    8d44ea <sev_es_req_cpuid+0x2a>
  8d44dd:	25 ff 0f 00 00       	and    $0xfff,%eax
  8d44e2:	83 f8 05             	cmp    $0x5,%eax
  8d44e5:	75 03                	jne    8d44ea <sev_es_req_cpuid+0x2a>
  8d44e7:	31 c0                	xor    %eax,%eax
  8d44e9:	c3                   	retq   
  8d44ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d44ef:	eb f8                	jmp    8d44e9 <sev_es_req_cpuid+0x29>
  8d44f1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d44f8:	00 00 00 00 
  8d44fc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d4500 <startup32_vc_handler>:
  8d4500:	50                   	push   %rax
  8d4501:	53                   	push   %rbx
  8d4502:	51                   	push   %rcx
  8d4503:	52                   	push   %rdx
  8d4504:	89 c3                	mov    %eax,%ebx
  8d4506:	83 7c 24 10 72       	cmpl   $0x72,0x10(%rsp)
  8d450b:	75 7f                	jne    8d458c <startup32_vc_handler+0x8c>
  8d450d:	b8 00 00 00 00       	mov    $0x0,%eax
  8d4512:	89 da                	mov    %ebx,%edx
  8d4514:	e8 a7 ff ff ff       	callq  8d44c0 <sev_es_req_cpuid>
  8d4519:	85 c0                	test   %eax,%eax
  8d451b:	75 6f                	jne    8d458c <startup32_vc_handler+0x8c>
  8d451d:	89 54 24 0c          	mov    %edx,0xc(%rsp)
  8d4521:	b8 01 00 00 00       	mov    $0x1,%eax
  8d4526:	89 da                	mov    %ebx,%edx
  8d4528:	e8 93 ff ff ff       	callq  8d44c0 <sev_es_req_cpuid>
  8d452d:	85 c0                	test   %eax,%eax
  8d452f:	75 5b                	jne    8d458c <startup32_vc_handler+0x8c>
  8d4531:	89 54 24 08          	mov    %edx,0x8(%rsp)
  8d4535:	b8 02 00 00 00       	mov    $0x2,%eax
  8d453a:	89 da                	mov    %ebx,%edx
  8d453c:	e8 7f ff ff ff       	callq  8d44c0 <sev_es_req_cpuid>
  8d4541:	85 c0                	test   %eax,%eax
  8d4543:	75 47                	jne    8d458c <startup32_vc_handler+0x8c>
  8d4545:	89 54 24 04          	mov    %edx,0x4(%rsp)
  8d4549:	b8 03 00 00 00       	mov    $0x3,%eax
  8d454e:	89 da                	mov    %ebx,%edx
  8d4550:	e8 6b ff ff ff       	callq  8d44c0 <sev_es_req_cpuid>
  8d4555:	85 c0                	test   %eax,%eax
  8d4557:	75 33                	jne    8d458c <startup32_vc_handler+0x8c>
  8d4559:	89 14 24             	mov    %edx,(%rsp)
  8d455c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
  8d4562:	75 0c                	jne    8d4570 <startup32_vc_handler+0x70>
  8d4564:	81 7c 24 0c 1f 00 00 	cmpl   $0x8000001f,0xc(%rsp)
  8d456b:	80 
  8d456c:	72 1e                	jb     8d458c <startup32_vc_handler+0x8c>
  8d456e:	eb 10                	jmp    8d4580 <startup32_vc_handler+0x80>
  8d4570:	81 fb 1f 00 00 80    	cmp    $0x8000001f,%ebx
  8d4576:	75 08                	jne    8d4580 <startup32_vc_handler+0x80>
  8d4578:	0f ba 64 24 0c 01    	btl    $0x1,0xc(%rsp)
  8d457e:	73 0c                	jae    8d458c <startup32_vc_handler+0x8c>
  8d4580:	5a                   	pop    %rdx
  8d4581:	59                   	pop    %rcx
  8d4582:	5b                   	pop    %rbx
  8d4583:	58                   	pop    %rax
  8d4584:	83 c4 04             	add    $0x4,%esp
  8d4587:	83 04 24 02          	addl   $0x2,(%rsp)
  8d458b:	cf                   	iret   
  8d458c:	b8 00 01 00 00       	mov    $0x100,%eax
  8d4591:	31 d2                	xor    %edx,%edx
  8d4593:	b9 30 01 01 c0       	mov    $0xc0010130,%ecx
  8d4598:	0f 30                	wrmsr  
  8d459a:	f3 0f 01 d9          	repz vmmcall 
  8d459e:	f4                   	hlt    
  8d459f:	eb eb                	jmp    8d458c <startup32_vc_handler+0x8c>
  8d45a1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d45a8:	00 00 00 00 
  8d45ac:	0f 1f 40 00          	nopl   0x0(%rax)

00000000008d45b0 <sev_verify_cbit>:
  8d45b0:	48 89 f8             	mov    %rdi,%rax
  8d45b3:	c3                   	retq   
  8d45b4:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d45bb:	00 00 00 00 
  8d45bf:	90                   	nop

00000000008d45c0 <set_sev_encryption_mask>:
  8d45c0:	48 31 c0             	xor    %rax,%rax
  8d45c3:	c3                   	retq   
  8d45c4:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d45cb:	00 00 00 
  8d45ce:	66 90                	xchg   %ax,%ax

00000000008d45d0 <paging_prepare>:
  8d45d0:	f3 0f 1e fa          	endbr64 
  8d45d4:	41 54                	push   %r12
  8d45d6:	55                   	push   %rbp
  8d45d7:	53                   	push   %rbx
  8d45d8:	48 89 3d 81 ed 01 00 	mov    %rdi,0x1ed81(%rip)        # 8f3360 <boot_params>
  8d45df:	48 8d 3d 83 71 00 00 	lea    0x7183(%rip),%rdi        # 8db769 <kernel_info_end+0x5d9>
  8d45e6:	e8 45 ef ff ff       	callq  8d3530 <cmdline_find_option_bool>
  8d45eb:	85 c0                	test   %eax,%eax
  8d45ed:	75 0f                	jne    8d45fe <paging_prepare+0x2e>
  8d45ef:	89 c6                	mov    %eax,%esi
  8d45f1:	89 c1                	mov    %eax,%ecx
  8d45f3:	0f a2                	cpuid  
  8d45f5:	83 f8 06             	cmp    $0x6,%eax
  8d45f8:	0f 87 02 02 00 00    	ja     8d4800 <paging_prepare+0x230>
  8d45fe:	45 31 e4             	xor    %r12d,%r12d
  8d4601:	48 8b 05 58 ed 01 00 	mov    0x1ed58(%rip),%rax        # 8f3360 <boot_params>
  8d4608:	ba 04 00 00 00       	mov    $0x4,%edx
  8d460d:	48 8d 35 5c 71 00 00 	lea    0x715c(%rip),%rsi        # 8db770 <kernel_info_end+0x5e0>
  8d4614:	48 8d a8 c0 01 00 00 	lea    0x1c0(%rax),%rbp
  8d461b:	48 89 ef             	mov    %rbp,%rdi
  8d461e:	e8 5d e7 ff ff       	callq  8d2d80 <strncmp>
  8d4623:	85 c0                	test   %eax,%eax
  8d4625:	0f 85 f5 01 00 00    	jne    8d4820 <paging_prepare+0x250>
  8d462b:	b8 00 f0 09 00       	mov    $0x9f000,%eax
  8d4630:	48 8b 3d 29 ed 01 00 	mov    0x1ed29(%rip),%rdi        # 8f3360 <boot_params>
  8d4637:	0f b6 8f e8 01 00 00 	movzbl 0x1e8(%rdi),%ecx
  8d463e:	84 c9                	test   %cl,%cl
  8d4640:	0f 84 a7 01 00 00    	je     8d47ed <paging_prepare+0x21d>
  8d4646:	0f b6 d1             	movzbl %cl,%edx
  8d4649:	83 e9 01             	sub    $0x1,%ecx
  8d464c:	48 8d 34 92          	lea    (%rdx,%rdx,4),%rsi
  8d4650:	48 8d 0c 89          	lea    (%rcx,%rcx,4),%rcx
  8d4654:	48 c1 e6 02          	shl    $0x2,%rsi
  8d4658:	48 c1 e1 02          	shl    $0x2,%rcx
  8d465c:	48 8d 14 37          	lea    (%rdi,%rsi,1),%rdx
  8d4660:	48 8d 74 37 ec       	lea    -0x14(%rdi,%rsi,1),%rsi
  8d4665:	48 29 ce             	sub    %rcx,%rsi
  8d4668:	48 8b 8a bc 02 00 00 	mov    0x2bc(%rdx),%rcx
  8d466f:	48 39 c1             	cmp    %rax,%rcx
  8d4672:	0f 83 68 01 00 00    	jae    8d47e0 <paging_prepare+0x210>
  8d4678:	83 ba cc 02 00 00 01 	cmpl   $0x1,0x2cc(%rdx)
  8d467f:	0f 85 5b 01 00 00    	jne    8d47e0 <paging_prepare+0x210>
  8d4685:	4c 8b 82 c4 02 00 00 	mov    0x2c4(%rdx),%r8
  8d468c:	49 01 c8             	add    %rcx,%r8
  8d468f:	49 39 c0             	cmp    %rax,%r8
  8d4692:	4c 0f 47 c0          	cmova  %rax,%r8
  8d4696:	49 81 e0 00 f0 ff ff 	and    $0xfffffffffffff000,%r8
  8d469d:	49 81 e8 00 20 00 00 	sub    $0x2000,%r8
  8d46a4:	4c 39 c1             	cmp    %r8,%rcx
  8d46a7:	0f 87 33 01 00 00    	ja     8d47e0 <paging_prepare+0x210>
  8d46ad:	48 8d 90 00 e0 ff ff 	lea    -0x2000(%rax),%rdx
  8d46b4:	49 39 c0             	cmp    %rax,%r8
  8d46b7:	4c 0f 47 c2          	cmova  %rdx,%r8
  8d46bb:	b8 00 04 00 00       	mov    $0x400,%eax
  8d46c0:	4c 89 05 59 7b 00 00 	mov    %r8,0x7b59(%rip)        # 8dc220 <trampoline_32bit>
  8d46c7:	4c 89 c6             	mov    %r8,%rsi
  8d46ca:	48 89 c1             	mov    %rax,%rcx
  8d46cd:	48 8d 3d 8c cc 01 00 	lea    0x1cc8c(%rip),%rdi        # 8f1360 <trampoline_save>
  8d46d4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d46d7:	4c 89 c7             	mov    %r8,%rdi
  8d46da:	48 89 c8             	mov    %rcx,%rax
  8d46dd:	b9 00 04 00 00       	mov    $0x400,%ecx
  8d46e2:	f3 48 ab             	rep stos %rax,%es:(%rdi)
  8d46e5:	48 8b 15 34 7b 00 00 	mov    0x7b34(%rip),%rdx        # 8dc220 <trampoline_32bit>
  8d46ec:	48 8b 0d 8d b1 ff ff 	mov    -0x4e73(%rip),%rcx        # 8cf880 <trampoline_32bit_src>
  8d46f3:	48 89 8a 00 10 00 00 	mov    %rcx,0x1000(%rdx)
  8d46fa:	48 8b 0d 87 b1 ff ff 	mov    -0x4e79(%rip),%rcx        # 8cf888 <trampoline_32bit_src+0x8>
  8d4701:	48 89 8a 08 10 00 00 	mov    %rcx,0x1008(%rdx)
  8d4708:	48 8b 0d 81 b1 ff ff 	mov    -0x4e7f(%rip),%rcx        # 8cf890 <trampoline_32bit_src+0x10>
  8d470f:	48 89 8a 10 10 00 00 	mov    %rcx,0x1010(%rdx)
  8d4716:	48 8b 0d 7b b1 ff ff 	mov    -0x4e85(%rip),%rcx        # 8cf898 <trampoline_32bit_src+0x18>
  8d471d:	48 89 8a 18 10 00 00 	mov    %rcx,0x1018(%rdx)
  8d4724:	48 8b 0d 75 b1 ff ff 	mov    -0x4e8b(%rip),%rcx        # 8cf8a0 <trampoline_32bit_src+0x20>
  8d472b:	48 89 8a 20 10 00 00 	mov    %rcx,0x1020(%rdx)
  8d4732:	48 8b 0d 6f b1 ff ff 	mov    -0x4e91(%rip),%rcx        # 8cf8a8 <trampoline_32bit_src+0x28>
  8d4739:	48 89 8a 28 10 00 00 	mov    %rcx,0x1028(%rdx)
  8d4740:	48 8b 0d 69 b1 ff ff 	mov    -0x4e97(%rip),%rcx        # 8cf8b0 <trampoline_32bit_src+0x30>
  8d4747:	48 89 8a 30 10 00 00 	mov    %rcx,0x1030(%rdx)
  8d474e:	48 8b 0d 63 b1 ff ff 	mov    -0x4e9d(%rip),%rcx        # 8cf8b8 <trampoline_32bit_src+0x38>
  8d4755:	48 89 8a 38 10 00 00 	mov    %rcx,0x1038(%rdx)
  8d475c:	48 8b 0d 5d b1 ff ff 	mov    -0x4ea3(%rip),%rcx        # 8cf8c0 <trampoline_32bit_src+0x40>
  8d4763:	48 89 8a 40 10 00 00 	mov    %rcx,0x1040(%rdx)
  8d476a:	48 8b 0d 57 b1 ff ff 	mov    -0x4ea9(%rip),%rcx        # 8cf8c8 <trampoline_32bit_src+0x48>
  8d4771:	48 89 8a 48 10 00 00 	mov    %rcx,0x1048(%rdx)
  8d4778:	48 8b 0d 51 b1 ff ff 	mov    -0x4eaf(%rip),%rcx        # 8cf8d0 <trampoline_32bit_src+0x50>
  8d477f:	48 89 8a 50 10 00 00 	mov    %rcx,0x1050(%rdx)
  8d4786:	48 8b 0d 4b b1 ff ff 	mov    -0x4eb5(%rip),%rcx        # 8cf8d8 <trampoline_32bit_src+0x58>
  8d478d:	48 89 8a 58 10 00 00 	mov    %rcx,0x1058(%rdx)
  8d4794:	48 8b 0d 45 b1 ff ff 	mov    -0x4ebb(%rip),%rcx        # 8cf8e0 <trampoline_32bit_src+0x60>
  8d479b:	48 89 8a 60 10 00 00 	mov    %rcx,0x1060(%rdx)
  8d47a2:	48 8b 0d 3f b1 ff ff 	mov    -0x4ec1(%rip),%rcx        # 8cf8e8 <trampoline_32bit_src+0x68>
  8d47a9:	48 89 8a 68 10 00 00 	mov    %rcx,0x1068(%rdx)
  8d47b0:	0f 20 e0             	mov    %cr4,%rax
  8d47b3:	48 c1 e8 0c          	shr    $0xc,%rax
  8d47b7:	83 e0 01             	and    $0x1,%eax
  8d47ba:	4c 39 e0             	cmp    %r12,%rax
  8d47bd:	74 13                	je     8d47d2 <paging_prepare+0x202>
  8d47bf:	4d 85 e4             	test   %r12,%r12
  8d47c2:	0f 84 c8 00 00 00    	je     8d4890 <paging_prepare+0x2c0>
  8d47c8:	0f 20 d8             	mov    %cr3,%rax
  8d47cb:	48 83 c8 67          	or     $0x67,%rax
  8d47cf:	48 89 02             	mov    %rax,(%rdx)
  8d47d2:	4c 89 e2             	mov    %r12,%rdx
  8d47d5:	5b                   	pop    %rbx
  8d47d6:	4c 89 c0             	mov    %r8,%rax
  8d47d9:	5d                   	pop    %rbp
  8d47da:	41 5c                	pop    %r12
  8d47dc:	c3                   	retq   
  8d47dd:	0f 1f 00             	nopl   (%rax)
  8d47e0:	48 83 ea 14          	sub    $0x14,%rdx
  8d47e4:	48 39 f2             	cmp    %rsi,%rdx
  8d47e7:	0f 85 7b fe ff ff    	jne    8d4668 <paging_prepare+0x98>
  8d47ed:	4c 8d 80 00 e0 ff ff 	lea    -0x2000(%rax),%r8
  8d47f4:	e9 c2 fe ff ff       	jmpq   8d46bb <paging_prepare+0xeb>
  8d47f9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d4800:	b8 07 00 00 00       	mov    $0x7,%eax
  8d4805:	89 f1                	mov    %esi,%ecx
  8d4807:	0f a2                	cpuid  
  8d4809:	c1 e9 10             	shr    $0x10,%ecx
  8d480c:	41 89 cc             	mov    %ecx,%r12d
  8d480f:	41 83 e4 01          	and    $0x1,%r12d
  8d4813:	e9 e9 fd ff ff       	jmpq   8d4601 <paging_prepare+0x31>
  8d4818:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d481f:	00 
  8d4820:	ba 04 00 00 00       	mov    $0x4,%edx
  8d4825:	48 8d 35 49 6f 00 00 	lea    0x6f49(%rip),%rsi        # 8db775 <kernel_info_end+0x5e5>
  8d482c:	48 89 ef             	mov    %rbp,%rdi
  8d482f:	e8 4c e5 ff ff       	callq  8d2d80 <strncmp>
  8d4834:	85 c0                	test   %eax,%eax
  8d4836:	0f 84 ef fd ff ff    	je     8d462b <paging_prepare+0x5b>
  8d483c:	0f b7 14 25 13 04 00 	movzwl 0x413,%edx
  8d4843:	00 
  8d4844:	0f b7 04 25 0e 04 00 	movzwl 0x40e,%eax
  8d484b:	00 
  8d484c:	c1 e2 0a             	shl    $0xa,%edx
  8d484f:	c1 e0 04             	shl    $0x4,%eax
  8d4852:	48 63 d2             	movslq %edx,%rdx
  8d4855:	48 98                	cltq   
  8d4857:	48 8d 8a 00 00 fe ff 	lea    -0x20000(%rdx),%rcx
  8d485e:	48 81 f9 01 f0 07 00 	cmp    $0x7f001,%rcx
  8d4865:	b9 00 f0 09 00       	mov    $0x9f000,%ecx
  8d486a:	48 0f 43 d1          	cmovae %rcx,%rdx
  8d486e:	48 3d 00 00 02 00    	cmp    $0x20000,%rax
  8d4874:	76 66                	jbe    8d48dc <paging_prepare+0x30c>
  8d4876:	48 39 d0             	cmp    %rdx,%rax
  8d4879:	73 61                	jae    8d48dc <paging_prepare+0x30c>
  8d487b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8d4881:	e9 aa fd ff ff       	jmpq   8d4630 <paging_prepare+0x60>
  8d4886:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d488d:	00 00 00 
  8d4890:	f3 0f 1e fa          	endbr64 
  8d4894:	0f 20 d8             	mov    %cr3,%rax
  8d4897:	48 8b 30             	mov    (%rax),%rsi
  8d489a:	48 8d 7a 08          	lea    0x8(%rdx),%rdi
  8d489e:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
  8d48a2:	48 81 e6 00 f0 ff ff 	and    $0xfffffffffffff000,%rsi
  8d48a9:	48 8b 06             	mov    (%rsi),%rax
  8d48ac:	48 89 02             	mov    %rax,(%rdx)
  8d48af:	48 8b 86 f8 0f 00 00 	mov    0xff8(%rsi),%rax
  8d48b6:	48 89 82 f8 0f 00 00 	mov    %rax,0xff8(%rdx)
  8d48bd:	48 29 fa             	sub    %rdi,%rdx
  8d48c0:	4c 89 c0             	mov    %r8,%rax
  8d48c3:	48 29 d6             	sub    %rdx,%rsi
  8d48c6:	81 c2 00 10 00 00    	add    $0x1000,%edx
  8d48cc:	c1 ea 03             	shr    $0x3,%edx
  8d48cf:	89 d1                	mov    %edx,%ecx
  8d48d1:	4c 89 e2             	mov    %r12,%rdx
  8d48d4:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d48d7:	5b                   	pop    %rbx
  8d48d8:	5d                   	pop    %rbp
  8d48d9:	41 5c                	pop    %r12
  8d48db:	c3                   	retq   
  8d48dc:	48 89 d0             	mov    %rdx,%rax
  8d48df:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  8d48e5:	e9 46 fd ff ff       	jmpq   8d4630 <paging_prepare+0x60>
  8d48ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000008d48f0 <cleanup_trampoline>:
  8d48f0:	f3 0f 1e fa          	endbr64 
  8d48f4:	48 8b 35 25 79 00 00 	mov    0x7925(%rip),%rsi        # 8dc220 <trampoline_32bit>
  8d48fb:	48 89 f8             	mov    %rdi,%rax
  8d48fe:	0f 20 da             	mov    %cr3,%rdx
  8d4901:	48 39 d6             	cmp    %rdx,%rsi
  8d4904:	74 6a                	je     8d4970 <cleanup_trampoline+0x80>
  8d4906:	48 8b 05 53 ca 01 00 	mov    0x1ca53(%rip),%rax        # 8f1360 <trampoline_save>
  8d490d:	48 8d 7e 08          	lea    0x8(%rsi),%rdi
  8d4911:	48 89 f1             	mov    %rsi,%rcx
  8d4914:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
  8d4918:	48 89 06             	mov    %rax,(%rsi)
  8d491b:	48 8b 05 36 ea 01 00 	mov    0x1ea36(%rip),%rax        # 8f3358 <trampoline_save+0x1ff8>
  8d4922:	48 29 f9             	sub    %rdi,%rcx
  8d4925:	48 89 86 f8 1f 00 00 	mov    %rax,0x1ff8(%rsi)
  8d492c:	48 8d 35 2d ca 01 00 	lea    0x1ca2d(%rip),%rsi        # 8f1360 <trampoline_save>
  8d4933:	48 29 ce             	sub    %rcx,%rsi
  8d4936:	81 c1 00 20 00 00    	add    $0x2000,%ecx
  8d493c:	c1 e9 03             	shr    $0x3,%ecx
  8d493f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d4942:	0f 20 e0             	mov    %cr4,%rax
  8d4945:	f6 c4 10             	test   $0x10,%ah
  8d4948:	74 1e                	je     8d4968 <cleanup_trampoline+0x78>
  8d494a:	c7 05 dc 78 00 00 01 	movl   $0x1,0x78dc(%rip)        # 8dc230 <__pgtable_l5_enabled>
  8d4951:	00 00 00 
  8d4954:	c7 05 ce 78 00 00 30 	movl   $0x30,0x78ce(%rip)        # 8dc22c <pgdir_shift>
  8d495b:	00 00 00 
  8d495e:	c7 05 c0 78 00 00 00 	movl   $0x200,0x78c0(%rip)        # 8dc228 <ptrs_per_p4d>
  8d4965:	02 00 00 
  8d4968:	c3                   	retq   
  8d4969:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d4970:	48 8b 16             	mov    (%rsi),%rdx
  8d4973:	48 8d 7f 08          	lea    0x8(%rdi),%rdi
  8d4977:	48 89 c1             	mov    %rax,%rcx
  8d497a:	48 89 57 f8          	mov    %rdx,-0x8(%rdi)
  8d497e:	48 8b 96 f8 0f 00 00 	mov    0xff8(%rsi),%rdx
  8d4985:	48 89 97 f0 0f 00 00 	mov    %rdx,0xff0(%rdi)
  8d498c:	48 83 e7 f8          	and    $0xfffffffffffffff8,%rdi
  8d4990:	48 29 f9             	sub    %rdi,%rcx
  8d4993:	48 29 ce             	sub    %rcx,%rsi
  8d4996:	81 c1 00 10 00 00    	add    $0x1000,%ecx
  8d499c:	c1 e9 03             	shr    $0x3,%ecx
  8d499f:	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)
  8d49a2:	0f 22 d8             	mov    %rax,%cr3
  8d49a5:	48 8b 35 74 78 00 00 	mov    0x7874(%rip),%rsi        # 8dc220 <trampoline_32bit>
  8d49ac:	e9 55 ff ff ff       	jmpq   8d4906 <cleanup_trampoline+0x16>
  8d49b1:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d49b8:	00 00 00 
  8d49bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000008d49c0 <scan_mem_for_rsdp>:
  8d49c0:	41 54                	push   %r12
  8d49c2:	55                   	push   %rbp
  8d49c3:	89 f5                	mov    %esi,%ebp
  8d49c5:	48 01 fd             	add    %rdi,%rbp
  8d49c8:	53                   	push   %rbx
  8d49c9:	48 39 ef             	cmp    %rbp,%rdi
  8d49cc:	73 7a                	jae    8d4a48 <scan_mem_for_rsdp+0x88>
  8d49ce:	48 8d 5f 14          	lea    0x14(%rdi),%rbx
  8d49d2:	eb 10                	jmp    8d49e4 <scan_mem_for_rsdp+0x24>
  8d49d4:	0f 1f 40 00          	nopl   0x0(%rax)
  8d49d8:	48 83 eb 04          	sub    $0x4,%rbx
  8d49dc:	48 39 dd             	cmp    %rbx,%rbp
  8d49df:	76 67                	jbe    8d4a48 <scan_mem_for_rsdp+0x88>
  8d49e1:	48 89 cb             	mov    %rcx,%rbx
  8d49e4:	4c 8d 63 ec          	lea    -0x14(%rbx),%r12
  8d49e8:	ba 08 00 00 00       	mov    $0x8,%edx
  8d49ed:	48 8d 35 86 6d 00 00 	lea    0x6d86(%rip),%rsi        # 8db77a <kernel_info_end+0x5ea>
  8d49f4:	4c 89 e7             	mov    %r12,%rdi
  8d49f7:	e8 84 e3 ff ff       	callq  8d2d80 <strncmp>
  8d49fc:	48 8d 4b 10          	lea    0x10(%rbx),%rcx
  8d4a00:	85 c0                	test   %eax,%eax
  8d4a02:	75 d4                	jne    8d49d8 <scan_mem_for_rsdp+0x18>
  8d4a04:	4c 89 e0             	mov    %r12,%rax
  8d4a07:	31 d2                	xor    %edx,%edx
  8d4a09:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d4a10:	48 83 c0 01          	add    $0x1,%rax
  8d4a14:	02 50 ff             	add    -0x1(%rax),%dl
  8d4a17:	48 39 d8             	cmp    %rbx,%rax
  8d4a1a:	75 f4                	jne    8d4a10 <scan_mem_for_rsdp+0x50>
  8d4a1c:	48 8d 4b 10          	lea    0x10(%rbx),%rcx
  8d4a20:	84 d2                	test   %dl,%dl
  8d4a22:	75 b4                	jne    8d49d8 <scan_mem_for_rsdp+0x18>
  8d4a24:	80 7b fb 01          	cmpb   $0x1,-0x5(%rbx)
  8d4a28:	76 16                	jbe    8d4a40 <scan_mem_for_rsdp+0x80>
  8d4a2a:	4c 89 e0             	mov    %r12,%rax
  8d4a2d:	0f 1f 00             	nopl   (%rax)
  8d4a30:	48 83 c0 01          	add    $0x1,%rax
  8d4a34:	02 50 ff             	add    -0x1(%rax),%dl
  8d4a37:	48 39 c8             	cmp    %rcx,%rax
  8d4a3a:	75 f4                	jne    8d4a30 <scan_mem_for_rsdp+0x70>
  8d4a3c:	84 d2                	test   %dl,%dl
  8d4a3e:	75 98                	jne    8d49d8 <scan_mem_for_rsdp+0x18>
  8d4a40:	4c 89 e0             	mov    %r12,%rax
  8d4a43:	5b                   	pop    %rbx
  8d4a44:	5d                   	pop    %rbp
  8d4a45:	41 5c                	pop    %r12
  8d4a47:	c3                   	retq   
  8d4a48:	45 31 e4             	xor    %r12d,%r12d
  8d4a4b:	5b                   	pop    %rbx
  8d4a4c:	5d                   	pop    %rbp
  8d4a4d:	4c 89 e0             	mov    %r12,%rax
  8d4a50:	41 5c                	pop    %r12
  8d4a52:	c3                   	retq   
  8d4a53:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d4a5a:	00 00 00 00 
  8d4a5e:	66 90                	xchg   %ax,%ax

00000000008d4a60 <__efi_get_rsdp_addr>:
  8d4a60:	41 57                	push   %r15
  8d4a62:	41 56                	push   %r14
  8d4a64:	41 55                	push   %r13
  8d4a66:	41 54                	push   %r12
  8d4a68:	55                   	push   %rbp
  8d4a69:	53                   	push   %rbx
  8d4a6a:	48 83 ec 28          	sub    $0x28,%rsp
  8d4a6e:	85 f6                	test   %esi,%esi
  8d4a70:	0f 84 d9 00 00 00    	je     8d4b4f <__efi_get_rsdp_addr+0xef>
  8d4a76:	8d 46 ff             	lea    -0x1(%rsi),%eax
  8d4a79:	45 31 ff             	xor    %r15d,%r15d
  8d4a7c:	48 89 fe             	mov    %rdi,%rsi
  8d4a7f:	49 89 e6             	mov    %rsp,%r14
  8d4a82:	48 8d 04 40          	lea    (%rax,%rax,2),%rax
  8d4a86:	4c 8d 6c 24 10       	lea    0x10(%rsp),%r13
  8d4a8b:	49 b9 30 2d 9d eb 88 	movabs $0x11d32d88eb9d2d30,%r9
  8d4a92:	2d d3 11 
  8d4a95:	48 bb 9a 16 00 90 27 	movabs $0x4dc13f279000169a,%rbx
  8d4a9c:	3f c1 4d 
  8d4a9f:	49 ba 71 e8 68 88 f1 	movabs $0x11d3e4f18868e871,%r10
  8d4aa6:	e4 d3 11 
  8d4aa9:	48 8d 6c c7 18       	lea    0x18(%rdi,%rax,8),%rbp
  8d4aae:	49 bc bc 22 00 80 c7 	movabs $0x81883cc7800022bc,%r12
  8d4ab5:	3c 88 81 
  8d4ab8:	eb 4e                	jmp    8d4b08 <__efi_get_rsdp_addr+0xa8>
  8d4aba:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d4ac0:	48 8b 07             	mov    (%rdi),%rax
  8d4ac3:	4c 8b 47 08          	mov    0x8(%rdi),%r8
  8d4ac7:	4c 8b 5f 10          	mov    0x10(%rdi),%r11
  8d4acb:	48 89 04 24          	mov    %rax,(%rsp)
  8d4acf:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  8d4ad4:	4c 89 4c 24 10       	mov    %r9,0x10(%rsp)
  8d4ad9:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
  8d4ade:	4c 39 c8             	cmp    %r9,%rax
  8d4ae1:	74 3d                	je     8d4b20 <__efi_get_rsdp_addr+0xc0>
  8d4ae3:	48 89 04 24          	mov    %rax,(%rsp)
  8d4ae7:	4c 89 44 24 08       	mov    %r8,0x8(%rsp)
  8d4aec:	4c 89 54 24 10       	mov    %r10,0x10(%rsp)
  8d4af1:	4c 89 64 24 18       	mov    %r12,0x18(%rsp)
  8d4af6:	4c 39 d0             	cmp    %r10,%rax
  8d4af9:	74 35                	je     8d4b30 <__efi_get_rsdp_addr+0xd0>
  8d4afb:	48 83 c7 18          	add    $0x18,%rdi
  8d4aff:	48 83 c6 14          	add    $0x14,%rsi
  8d4b03:	48 39 ef             	cmp    %rbp,%rdi
  8d4b06:	74 35                	je     8d4b3d <__efi_get_rsdp_addr+0xdd>
  8d4b08:	84 d2                	test   %dl,%dl
  8d4b0a:	75 b4                	jne    8d4ac0 <__efi_get_rsdp_addr+0x60>
  8d4b0c:	48 8b 06             	mov    (%rsi),%rax
  8d4b0f:	4c 8b 46 08          	mov    0x8(%rsi),%r8
  8d4b13:	44 8b 5e 10          	mov    0x10(%rsi),%r11d
  8d4b17:	eb b2                	jmp    8d4acb <__efi_get_rsdp_addr+0x6b>
  8d4b19:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  8d4b20:	49 8b 4d 08          	mov    0x8(%r13),%rcx
  8d4b24:	49 39 4e 08          	cmp    %rcx,0x8(%r14)
  8d4b28:	75 b9                	jne    8d4ae3 <__efi_get_rsdp_addr+0x83>
  8d4b2a:	4d 89 df             	mov    %r11,%r15
  8d4b2d:	eb cc                	jmp    8d4afb <__efi_get_rsdp_addr+0x9b>
  8d4b2f:	90                   	nop
  8d4b30:	49 8b 45 08          	mov    0x8(%r13),%rax
  8d4b34:	49 39 46 08          	cmp    %rax,0x8(%r14)
  8d4b38:	75 c1                	jne    8d4afb <__efi_get_rsdp_addr+0x9b>
  8d4b3a:	4d 89 df             	mov    %r11,%r15
  8d4b3d:	48 83 c4 28          	add    $0x28,%rsp
  8d4b41:	4c 89 f8             	mov    %r15,%rax
  8d4b44:	5b                   	pop    %rbx
  8d4b45:	5d                   	pop    %rbp
  8d4b46:	41 5c                	pop    %r12
  8d4b48:	41 5d                	pop    %r13
  8d4b4a:	41 5e                	pop    %r14
  8d4b4c:	41 5f                	pop    %r15
  8d4b4e:	c3                   	retq   
  8d4b4f:	45 31 ff             	xor    %r15d,%r15d
  8d4b52:	eb e9                	jmp    8d4b3d <__efi_get_rsdp_addr+0xdd>
  8d4b54:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  8d4b5b:	00 00 00 00 
  8d4b5f:	90                   	nop

00000000008d4b60 <get_rsdp_addr>:
  8d4b60:	f3 0f 1e fa          	endbr64 
  8d4b64:	41 54                	push   %r12
  8d4b66:	55                   	push   %rbp
  8d4b67:	53                   	push   %rbx
  8d4b68:	48 8b 1d f1 e7 01 00 	mov    0x1e7f1(%rip),%rbx        # 8f3360 <boot_params>
  8d4b6f:	4c 8b 63 70          	mov    0x70(%rbx),%r12
  8d4b73:	4d 85 e4             	test   %r12,%r12
  8d4b76:	74 08                	je     8d4b80 <get_rsdp_addr+0x20>
  8d4b78:	4c 89 e0             	mov    %r12,%rax
  8d4b7b:	5b                   	pop    %rbx
  8d4b7c:	5d                   	pop    %rbp
  8d4b7d:	41 5c                	pop    %r12
  8d4b7f:	c3                   	retq   
  8d4b80:	48 8b 83 50 02 00 00 	mov    0x250(%rbx),%rax
  8d4b87:	48 85 c0             	test   %rax,%rax
  8d4b8a:	75 0c                	jne    8d4b98 <get_rsdp_addr+0x38>
  8d4b8c:	eb 7f                	jmp    8d4c0d <get_rsdp_addr+0xad>
  8d4b8e:	66 90                	xchg   %ax,%ax
  8d4b90:	48 8b 00             	mov    (%rax),%rax
  8d4b93:	48 85 c0             	test   %rax,%rax
  8d4b96:	74 75                	je     8d4c0d <get_rsdp_addr+0xad>
  8d4b98:	83 78 08 04          	cmpl   $0x4,0x8(%rax)
  8d4b9c:	75 f2                	jne    8d4b90 <get_rsdp_addr+0x30>
  8d4b9e:	48 8d 68 10          	lea    0x10(%rax),%rbp
  8d4ba2:	48 83 f8 f0          	cmp    $0xfffffffffffffff0,%rax
  8d4ba6:	74 65                	je     8d4c0d <get_rsdp_addr+0xad>
  8d4ba8:	48 83 7d 10 00       	cmpq   $0x0,0x10(%rbp)
  8d4bad:	0f 84 4d 01 00 00    	je     8d4d00 <get_rsdp_addr+0x1a0>
  8d4bb3:	48 8d bb c0 01 00 00 	lea    0x1c0(%rbx),%rdi
  8d4bba:	ba 04 00 00 00       	mov    $0x4,%edx
  8d4bbf:	48 8d 35 af 6b 00 00 	lea    0x6baf(%rip),%rsi        # 8db775 <kernel_info_end+0x5e5>
  8d4bc6:	e8 b5 e1 ff ff       	callq  8d2d80 <strncmp>
  8d4bcb:	85 c0                	test   %eax,%eax
  8d4bcd:	0f 85 4d 01 00 00    	jne    8d4d20 <get_rsdp_addr+0x1c0>
  8d4bd3:	8b 83 d8 01 00 00    	mov    0x1d8(%rbx),%eax
  8d4bd9:	8b 93 c4 01 00 00    	mov    0x1c4(%rbx),%edx
  8d4bdf:	48 c1 e0 20          	shl    $0x20,%rax
  8d4be3:	48 09 d0             	or     %rdx,%rax
  8d4be6:	0f 84 65 01 00 00    	je     8d4d51 <get_rsdp_addr+0x1f1>
  8d4bec:	8b 70 68             	mov    0x68(%rax),%esi
  8d4bef:	48 8b 7d 10          	mov    0x10(%rbp),%rdi
  8d4bf3:	ba 01 00 00 00       	mov    $0x1,%edx
  8d4bf8:	e8 63 fe ff ff       	callq  8d4a60 <__efi_get_rsdp_addr>
  8d4bfd:	48 85 c0             	test   %rax,%rax
  8d4c00:	0f 85 86 00 00 00    	jne    8d4c8c <get_rsdp_addr+0x12c>
  8d4c06:	48 8b 1d 53 e7 01 00 	mov    0x1e753(%rip),%rbx        # 8f3360 <boot_params>
  8d4c0d:	48 8d ab c0 01 00 00 	lea    0x1c0(%rbx),%rbp
  8d4c14:	ba 04 00 00 00       	mov    $0x4,%edx
  8d4c19:	48 8d 35 55 6b 00 00 	lea    0x6b55(%rip),%rsi        # 8db775 <kernel_info_end+0x5e5>
  8d4c20:	48 89 ef             	mov    %rbp,%rdi
  8d4c23:	e8 58 e1 ff ff       	callq  8d2d80 <strncmp>
  8d4c28:	85 c0                	test   %eax,%eax
  8d4c2a:	0f 85 90 00 00 00    	jne    8d4cc0 <get_rsdp_addr+0x160>
  8d4c30:	8b 83 d8 01 00 00    	mov    0x1d8(%rbx),%eax
  8d4c36:	8b 93 c4 01 00 00    	mov    0x1c4(%rbx),%edx
  8d4c3c:	48 c1 e0 20          	shl    $0x20,%rax
  8d4c40:	48 09 d0             	or     %rdx,%rax
  8d4c43:	0f 84 14 01 00 00    	je     8d4d5d <get_rsdp_addr+0x1fd>
  8d4c49:	48 8b 78 70          	mov    0x70(%rax),%rdi
  8d4c4d:	8b 70 68             	mov    0x68(%rax),%esi
  8d4c50:	ba 01 00 00 00       	mov    $0x1,%edx
  8d4c55:	48 85 ff             	test   %rdi,%rdi
  8d4c58:	0f 84 0b 01 00 00    	je     8d4d69 <get_rsdp_addr+0x209>
  8d4c5e:	e8 fd fd ff ff       	callq  8d4a60 <__efi_get_rsdp_addr>
  8d4c63:	48 85 c0             	test   %rax,%rax
  8d4c66:	75 24                	jne    8d4c8c <get_rsdp_addr+0x12c>
  8d4c68:	0f b7 04 25 0e 04 00 	movzwl 0x40e,%eax
  8d4c6f:	00 
  8d4c70:	48 89 c7             	mov    %rax,%rdi
  8d4c73:	48 c1 e7 04          	shl    $0x4,%rdi
  8d4c77:	48 83 f8 40          	cmp    $0x40,%rax
  8d4c7b:	76 23                	jbe    8d4ca0 <get_rsdp_addr+0x140>
  8d4c7d:	be 00 04 00 00       	mov    $0x400,%esi
  8d4c82:	e8 39 fd ff ff       	callq  8d49c0 <scan_mem_for_rsdp>
  8d4c87:	48 85 c0             	test   %rax,%rax
  8d4c8a:	74 14                	je     8d4ca0 <get_rsdp_addr+0x140>
  8d4c8c:	49 89 c4             	mov    %rax,%r12
  8d4c8f:	5b                   	pop    %rbx
  8d4c90:	5d                   	pop    %rbp
  8d4c91:	4c 89 e0             	mov    %r12,%rax
  8d4c94:	41 5c                	pop    %r12
  8d4c96:	c3                   	retq   
  8d4c97:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  8d4c9e:	00 00 
  8d4ca0:	be 00 00 02 00       	mov    $0x20000,%esi
  8d4ca5:	bf 00 00 0e 00       	mov    $0xe0000,%edi
  8d4caa:	e8 11 fd ff ff       	callq  8d49c0 <scan_mem_for_rsdp>
  8d4caf:	5b                   	pop    %rbx
  8d4cb0:	5d                   	pop    %rbp
  8d4cb1:	48 85 c0             	test   %rax,%rax
  8d4cb4:	4c 0f 45 e0          	cmovne %rax,%r12
  8d4cb8:	4c 89 e0             	mov    %r12,%rax
  8d4cbb:	41 5c                	pop    %r12
  8d4cbd:	c3                   	retq   
  8d4cbe:	66 90                	xchg   %ax,%ax
  8d4cc0:	ba 04 00 00 00       	mov    $0x4,%edx
  8d4cc5:	48 8d 35 a4 6a 00 00 	lea    0x6aa4(%rip),%rsi        # 8db770 <kernel_info_end+0x5e0>
  8d4ccc:	48 89 ef             	mov    %rbp,%rdi
  8d4ccf:	e8 ac e0 ff ff       	callq  8d2d80 <strncmp>
  8d4cd4:	85 c0                	test   %eax,%eax
  8d4cd6:	75 68                	jne    8d4d40 <get_rsdp_addr+0x1e0>
  8d4cd8:	8b 83 d8 01 00 00    	mov    0x1d8(%rbx),%eax
  8d4cde:	8b 93 c4 01 00 00    	mov    0x1c4(%rbx),%edx
  8d4ce4:	48 c1 e0 20          	shl    $0x20,%rax
  8d4ce8:	48 09 d0             	or     %rdx,%rax
  8d4ceb:	74 70                	je     8d4d5d <get_rsdp_addr+0x1fd>
  8d4ced:	8b 78 44             	mov    0x44(%rax),%edi
  8d4cf0:	8b 70 40             	mov    0x40(%rax),%esi
  8d4cf3:	31 d2                	xor    %edx,%edx
  8d4cf5:	e9 5b ff ff ff       	jmpq   8d4c55 <get_rsdp_addr+0xf5>
  8d4cfa:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
  8d4d00:	48 8d 3d 7c 6a 00 00 	lea    0x6a7c(%rip),%rdi        # 8db783 <kernel_info_end+0x5f3>
  8d4d07:	e8 f4 d5 ff ff       	callq  8d2300 <__putstr>
  8d4d0c:	48 8b 1d 4d e6 01 00 	mov    0x1e64d(%rip),%rbx        # 8f3360 <boot_params>
  8d4d13:	e9 f5 fe ff ff       	jmpq   8d4c0d <get_rsdp_addr+0xad>
  8d4d18:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d4d1f:	00 
  8d4d20:	48 8d 3d d1 6a 00 00 	lea    0x6ad1(%rip),%rdi        # 8db7f8 <kernel_info_end+0x668>
  8d4d27:	e8 d4 d5 ff ff       	callq  8d2300 <__putstr>
  8d4d2c:	48 8b 1d 2d e6 01 00 	mov    0x1e62d(%rip),%rbx        # 8f3360 <boot_params>
  8d4d33:	e9 d5 fe ff ff       	jmpq   8d4c0d <get_rsdp_addr+0xad>
  8d4d38:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  8d4d3f:	00 
  8d4d40:	48 8d 3d 59 6a 00 00 	lea    0x6a59(%rip),%rdi        # 8db7a0 <kernel_info_end+0x610>
  8d4d47:	e8 b4 d5 ff ff       	callq  8d2300 <__putstr>
  8d4d4c:	e9 17 ff ff ff       	jmpq   8d4c68 <get_rsdp_addr+0x108>
  8d4d51:	48 8d 3d c8 6a 00 00 	lea    0x6ac8(%rip),%rdi        # 8db820 <kernel_info_end+0x690>
  8d4d58:	e8 33 e8 ff ff       	callq  8d3590 <error>
  8d4d5d:	48 8d 3d 59 6a 00 00 	lea    0x6a59(%rip),%rdi        # 8db7bd <kernel_info_end+0x62d>
  8d4d64:	e8 27 e8 ff ff       	callq  8d3590 <error>
  8d4d69:	48 8d 3d 69 6a 00 00 	lea    0x6a69(%rip),%rdi        # 8db7d9 <kernel_info_end+0x649>
  8d4d70:	e8 1b e8 ff ff       	callq  8d3590 <error>
  8d4d75:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d4d7c:	00 00 00 
  8d4d7f:	90                   	nop

00000000008d4d80 <__efi64_thunk>:
  8d4d80:	55                   	push   %rbp
  8d4d81:	53                   	push   %rbx
  8d4d82:	48 8d 2d 5f 00 00 00 	lea    0x5f(%rip),%rbp        # 8d4de8 <__efi64_thunk+0x68>
  8d4d89:	8c d8                	mov    %ds,%eax
  8d4d8b:	50                   	push   %rax
  8d4d8c:	8c c0                	mov    %es,%eax
  8d4d8e:	50                   	push   %rax
  8d4d8f:	8c d0                	mov    %ss,%eax
  8d4d91:	50                   	push   %rax
  8d4d92:	48 83 ec 40          	sub    $0x40,%rsp
  8d4d96:	89 34 24             	mov    %esi,(%rsp)
  8d4d99:	89 54 24 04          	mov    %edx,0x4(%rsp)
  8d4d9d:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  8d4da1:	44 89 44 24 0c       	mov    %r8d,0xc(%rsp)
  8d4da6:	44 89 4c 24 10       	mov    %r9d,0x10(%rsp)
  8d4dab:	48 8d 5c 24 14       	lea    0x14(%rsp),%rbx
  8d4db0:	0f 01 03             	sgdt   (%rbx)
  8d4db3:	48 83 c3 10          	add    $0x10,%rbx
  8d4db7:	0f 01 0b             	sidt   (%rbx)
  8d4dba:	48 8d 05 81 74 00 00 	lea    0x7481(%rip),%rax        # 8dc242 <efi32_boot_idt>
  8d4dc1:	0f 01 18             	lidt   (%rax)
  8d4dc4:	48 8d 05 6d 74 00 00 	lea    0x746d(%rip),%rax        # 8dc238 <efi32_boot_gdt>
  8d4dcb:	0f 01 10             	lgdt   (%rax)
  8d4dce:	0f b7 15 79 74 00 00 	movzwl 0x7479(%rip),%edx        # 8dc24e <efi32_boot_ds>
  8d4dd5:	48 0f b7 05 6f 74 00 	movzwq 0x746f(%rip),%rax        # 8dc24c <efi32_boot_cs>
  8d4ddc:	00 
  8d4ddd:	50                   	push   %rax
  8d4dde:	48 8d 05 2b 00 00 00 	lea    0x2b(%rip),%rax        # 8d4e10 <efi_enter32>
  8d4de5:	50                   	push   %rax
  8d4de6:	48 cb                	lretq  
  8d4de8:	48 83 c4 40          	add    $0x40,%rsp
  8d4dec:	48 89 f8             	mov    %rdi,%rax
  8d4def:	5b                   	pop    %rbx
  8d4df0:	8e d3                	mov    %ebx,%ss
  8d4df2:	5b                   	pop    %rbx
  8d4df3:	8e c3                	mov    %ebx,%es
  8d4df5:	5b                   	pop    %rbx
  8d4df6:	8e db                	mov    %ebx,%ds
  8d4df8:	31 db                	xor    %ebx,%ebx
  8d4dfa:	8e e3                	mov    %ebx,%fs
  8d4dfc:	8e eb                	mov    %ebx,%gs
  8d4dfe:	d1 c0                	rol    %eax
  8d4e00:	48 d1 c8             	ror    %rax
  8d4e03:	5b                   	pop    %rbx
  8d4e04:	5d                   	pop    %rbp
  8d4e05:	c3                   	retq   
  8d4e06:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  8d4e0d:	00 00 00 

00000000008d4e10 <efi_enter32>:
  8d4e10:	8e da                	mov    %edx,%ds
  8d4e12:	8e c2                	mov    %edx,%es
  8d4e14:	8e e2                	mov    %edx,%fs
  8d4e16:	8e ea                	mov    %edx,%gs
  8d4e18:	8e d2                	mov    %edx,%ss
  8d4e1a:	0f 20 d8             	mov    %cr3,%rax
  8d4e1d:	0f 22 d8             	mov    %rax,%cr3
  8d4e20:	0f 20 c0             	mov    %cr0,%rax
  8d4e23:	0f ba f0 1f          	btr    $0x1f,%eax
  8d4e27:	0f 22 c0             	mov    %rax,%cr0
  8d4e2a:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  8d4e2f:	0f 32                	rdmsr  
  8d4e31:	0f ba f0 08          	btr    $0x8,%eax
  8d4e35:	0f 30                	wrmsr  
  8d4e37:	ff d7                	callq  *%rdi
  8d4e39:	89 c7                	mov    %eax,%edi
  8d4e3b:	fa                   	cli    
  8d4e3c:	0f 01 1b             	lidt   (%rbx)
  8d4e3f:	83 eb 10             	sub    $0x10,%ebx
  8d4e42:	0f 01 13             	lgdt   (%rbx)
  8d4e45:	0f 20 e0             	mov    %cr4,%rax
  8d4e48:	0f ba e8 05          	bts    $0x5,%eax
  8d4e4c:	0f 22 e0             	mov    %rax,%cr4
  8d4e4f:	0f 20 d8             	mov    %cr3,%rax
  8d4e52:	0f 22 d8             	mov    %rax,%cr3
  8d4e55:	b9 80 00 00 c0       	mov    $0xc0000080,%ecx
  8d4e5a:	0f 32                	rdmsr  
  8d4e5c:	0f ba e8 08          	bts    $0x8,%eax
  8d4e60:	0f 30                	wrmsr  
  8d4e62:	31 c0                	xor    %eax,%eax
  8d4e64:	0f 00 d0             	lldt   %ax
  8d4e67:	6a 10                	pushq  $0x10
  8d4e69:	55                   	push   %rbp
  8d4e6a:	0f 20 c0             	mov    %cr0,%rax
  8d4e6d:	0f ba e8 1f          	bts    $0x1f,%eax
  8d4e71:	0f 22 c0             	mov    %rax,%cr0
  8d4e74:	cb                   	lret   

00000000008d4e75 <efi_exit>:
  8d4e75:	50                   	push   %rax
  8d4e76:	58                   	pop    %rax
  8d4e77:	50                   	push   %rax
  8d4e78:	80 3d 91 73 00 00 00 	cmpb   $0x0,0x7391(%rip)        # 8dc210 <efi_is64>
  8d4e7f:	49 89 fa             	mov    %rdi,%r10
  8d4e82:	48 89 f2             	mov    %rsi,%rdx
  8d4e85:	48 8b 05 74 ed 01 00 	mov    0x1ed74(%rip),%rax        # 8f3c00 <efi_system_table>
  8d4e8c:	74 17                	je     8d4ea5 <efi_exit+0x30>
  8d4e8e:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d4e92:	48 83 ec 20          	sub    $0x20,%rsp
  8d4e96:	45 31 c9             	xor    %r9d,%r9d
  8d4e99:	45 31 c0             	xor    %r8d,%r8d
  8d4e9c:	48 89 f9             	mov    %rdi,%rcx
  8d4e9f:	ff 90 d8 00 00 00    	callq  *0xd8(%rax)
  8d4ea5:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d4ea8:	48 c1 ee 20          	shr    $0x20,%rsi
  8d4eac:	45 31 c0             	xor    %r8d,%r8d
  8d4eaf:	31 c9                	xor    %ecx,%ecx
  8d4eb1:	09 f2                	or     %esi,%edx
  8d4eb3:	4c 89 d6             	mov    %r10,%rsi
  8d4eb6:	8b 78 78             	mov    0x78(%rax),%edi
  8d4eb9:	31 c0                	xor    %eax,%eax
  8d4ebb:	e8 c0 fe ff ff       	callq  8d4d80 <__efi64_thunk>
  8d4ec0:	f4                   	hlt    
  8d4ec1:	eb fd                	jmp    8d4ec0 <efi_exit+0x4b>

00000000008d4ec3 <exit_boot_func>:
  8d4ec3:	f3 0f 1e fa          	endbr64 
  8d4ec7:	55                   	push   %rbp
  8d4ec8:	48 89 fd             	mov    %rdi,%rbp
  8d4ecb:	ba 04 00 00 00       	mov    $0x4,%edx
  8d4ed0:	53                   	push   %rbx
  8d4ed1:	48 89 f3             	mov    %rsi,%rbx
  8d4ed4:	48 8d 35 9a 68 00 00 	lea    0x689a(%rip),%rsi        # 8db775 <kernel_info_end+0x5e5>
  8d4edb:	50                   	push   %rax
  8d4edc:	48 8d 05 8d 68 00 00 	lea    0x688d(%rip),%rax        # 8db770 <kernel_info_end+0x5e0>
  8d4ee3:	80 3d 26 73 00 00 00 	cmpb   $0x0,0x7326(%rip)        # 8dc210 <efi_is64>
  8d4eea:	48 0f 44 f0          	cmove  %rax,%rsi
  8d4eee:	48 8b 7b 08          	mov    0x8(%rbx),%rdi
  8d4ef2:	e8 f9 e1 ff ff       	callq  8d30f0 <memcpy>
  8d4ef7:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d4efb:	48 8b 05 fe ec 01 00 	mov    0x1ecfe(%rip),%rax        # 8f3c00 <efi_system_table>
  8d4f02:	89 42 04             	mov    %eax,0x4(%rdx)
  8d4f05:	48 c1 e8 20          	shr    $0x20,%rax
  8d4f09:	89 42 18             	mov    %eax,0x18(%rdx)
  8d4f0c:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8d4f10:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d4f14:	48 8b 12             	mov    (%rdx),%rdx
  8d4f17:	89 50 08             	mov    %edx,0x8(%rax)
  8d4f1a:	48 8b 55 18          	mov    0x18(%rbp),%rdx
  8d4f1e:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d4f22:	8b 12                	mov    (%rdx),%edx
  8d4f24:	89 50 0c             	mov    %edx,0xc(%rax)
  8d4f27:	48 8b 45 00          	mov    0x0(%rbp),%rax
  8d4f2b:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d4f2f:	48 8b 00             	mov    (%rax),%rax
  8d4f32:	89 42 10             	mov    %eax,0x10(%rdx)
  8d4f35:	48 c1 e8 20          	shr    $0x20,%rax
  8d4f39:	89 42 1c             	mov    %eax,0x1c(%rdx)
  8d4f3c:	48 8b 55 08          	mov    0x8(%rbp),%rdx
  8d4f40:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d4f44:	48 8b 12             	mov    (%rdx),%rdx
  8d4f47:	89 50 14             	mov    %edx,0x14(%rax)
  8d4f4a:	31 c0                	xor    %eax,%eax
  8d4f4c:	5a                   	pop    %rdx
  8d4f4d:	5b                   	pop    %rbx
  8d4f4e:	5d                   	pop    %rbp
  8d4f4f:	c3                   	retq   

00000000008d4f50 <efi_pe_entry>:
  8d4f50:	f3 0f 1e fa          	endbr64 
  8d4f54:	48 b8 a1 31 1b 5b 62 	movabs $0x11d295625b1b31a1,%rax
  8d4f5b:	95 d2 11 
  8d4f5e:	41 55                	push   %r13
  8d4f60:	41 54                	push   %r12
  8d4f62:	55                   	push   %rbp
  8d4f63:	48 89 cd             	mov    %rcx,%rbp
  8d4f66:	57                   	push   %rdi
  8d4f67:	56                   	push   %rsi
  8d4f68:	48 be 02 00 00 00 00 	movabs $0x8000000000000002,%rsi
  8d4f6f:	00 00 80 
  8d4f72:	53                   	push   %rbx
  8d4f73:	48 83 ec 48          	sub    $0x48,%rsp
  8d4f77:	48 89 15 82 ec 01 00 	mov    %rdx,0x1ec82(%rip)        # 8f3c00 <efi_system_table>
  8d4f7e:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8d4f83:	48 b8 8e 3f 00 a0 c9 	movabs $0x3b7269c9a0003f8e,%rax
  8d4f8a:	69 72 3b 
  8d4f8d:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8d4f92:	48 b8 49 42 49 20 53 	movabs $0x5453595320494249,%rax
  8d4f99:	59 53 54 
  8d4f9c:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%rsp)
  8d4fa3:	00 
  8d4fa4:	48 39 02             	cmp    %rax,(%rdx)
  8d4fa7:	75 67                	jne    8d5010 <efi_pe_entry+0xc0>
  8d4fa9:	80 3d 60 72 00 00 00 	cmpb   $0x0,0x7260(%rip)        # 8dc210 <efi_is64>
  8d4fb0:	49 89 d5             	mov    %rdx,%r13
  8d4fb3:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  8d4fb8:	74 1b                	je     8d4fd5 <efi_pe_entry+0x85>
  8d4fba:	49 8b 45 60          	mov    0x60(%r13),%rax
  8d4fbe:	4c 8d 05 9b 72 00 00 	lea    0x729b(%rip),%r8        # 8dc260 <image>
  8d4fc5:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d4fcb:	49 89 c4             	mov    %rax,%r12
  8d4fce:	48 85 c0             	test   %rax,%rax
  8d4fd1:	75 2c                	jne    8d4fff <efi_pe_entry+0xaf>
  8d4fd3:	eb 43                	jmp    8d5018 <efi_pe_entry+0xc8>
  8d4fd5:	41 8b 45 3c          	mov    0x3c(%r13),%eax
  8d4fd9:	48 89 ee             	mov    %rbp,%rsi
  8d4fdc:	48 8d 0d 7d 72 00 00 	lea    0x727d(%rip),%rcx        # 8dc260 <image>
  8d4fe3:	c7 05 77 72 00 00 00 	movl   $0x0,0x7277(%rip)        # 8dc264 <image+0x4>
  8d4fea:	00 00 00 
  8d4fed:	8b 78 58             	mov    0x58(%rax),%edi
  8d4ff0:	31 c0                	xor    %eax,%eax
  8d4ff2:	e8 89 fd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d4ff7:	49 89 c4             	mov    %rax,%r12
  8d4ffa:	48 85 c0             	test   %rax,%rax
  8d4ffd:	74 26                	je     8d5025 <efi_pe_entry+0xd5>
  8d4fff:	48 8d 3d 4b 68 00 00 	lea    0x684b(%rip),%rdi        # 8db851 <kernel_info_end+0x6c1>
  8d5006:	31 c0                	xor    %eax,%eax
  8d5008:	e8 bf 11 00 00       	callq  8d61cc <efi_printk>
  8d500d:	4c 89 e6             	mov    %r12,%rsi
  8d5010:	48 89 ef             	mov    %rbp,%rdi
  8d5013:	e8 5d fe ff ff       	callq  8d4e75 <efi_exit>
  8d5018:	48 8b 05 41 72 00 00 	mov    0x7241(%rip),%rax        # 8dc260 <image>
  8d501f:	48 8b 58 40          	mov    0x40(%rax),%rbx
  8d5023:	eb 0a                	jmp    8d502f <efi_pe_entry+0xdf>
  8d5025:	48 8b 05 34 72 00 00 	mov    0x7234(%rip),%rax        # 8dc260 <image>
  8d502c:	8b 58 20             	mov    0x20(%rax),%ebx
  8d502f:	48 8d 05 ca af 72 ff 	lea    -0x8d5036(%rip),%rax        # 0 <startup_32>
  8d5036:	bf 00 10 00 00       	mov    $0x1000,%edi
  8d503b:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  8d5040:	48 83 ca ff          	or     $0xffffffffffffffff,%rdx
  8d5044:	48 29 d8             	sub    %rbx,%rax
  8d5047:	89 05 b3 71 00 00    	mov    %eax,0x71b3(%rip)        # 8dc200 <image_offset>
  8d504d:	e8 f3 36 00 00       	callq  8d8745 <efi_allocate_pages>
  8d5052:	48 8d 3d 31 68 00 00 	lea    0x6831(%rip),%rdi        # 8db88a <kernel_info_end+0x6fa>
  8d5059:	49 89 c4             	mov    %rax,%r12
  8d505c:	48 85 c0             	test   %rax,%rax
  8d505f:	75 a5                	jne    8d5006 <efi_pe_entry+0xb6>
  8d5061:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8d5066:	31 f6                	xor    %esi,%esi
  8d5068:	ba 00 10 00 00       	mov    $0x1000,%edx
  8d506d:	e8 fe df ff ff       	callq  8d3070 <memset>
  8d5072:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8d5077:	ba 6c 00 00 00       	mov    $0x6c,%edx
  8d507c:	48 8d b3 00 02 00 00 	lea    0x200(%rbx),%rsi
  8d5083:	49 8d bc 24 00 02 00 	lea    0x200(%r12),%rdi
  8d508a:	00 
  8d508b:	e8 60 e0 ff ff       	callq  8d30f0 <memcpy>
  8d5090:	48 8b 3d c9 71 00 00 	mov    0x71c9(%rip),%rdi        # 8dc260 <image>
  8d5097:	66 41 c7 84 24 f2 01 	movw   $0x1,0x1f2(%r12)
  8d509e:	00 00 01 00 
  8d50a2:	66 41 c7 84 24 fa 01 	movw   $0xffff,0x1fa(%r12)
  8d50a9:	00 00 ff ff 
  8d50ad:	48 8d 74 24 24       	lea    0x24(%rsp),%rsi
  8d50b2:	66 41 c7 84 24 fe 01 	movw   $0xaa55,0x1fe(%r12)
  8d50b9:	00 00 55 aa 
  8d50bd:	41 c6 84 24 10 02 00 	movb   $0x21,0x210(%r12)
  8d50c4:	00 21 
  8d50c6:	e8 bd 15 00 00       	callq  8d6688 <efi_convert_cmdline>
  8d50cb:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d50d0:	48 85 c0             	test   %rax,%rax
  8d50d3:	75 14                	jne    8d50e9 <efi_pe_entry+0x199>
  8d50d5:	48 89 d6             	mov    %rdx,%rsi
  8d50d8:	bf 00 10 00 00       	mov    $0x1000,%edi
  8d50dd:	e8 ec 36 00 00       	callq  8d87ce <efi_free>
  8d50e2:	31 f6                	xor    %esi,%esi
  8d50e4:	e9 27 ff ff ff       	jmpq   8d5010 <efi_pe_entry+0xc0>
  8d50e9:	41 89 84 24 28 02 00 	mov    %eax,0x228(%r12)
  8d50f0:	00 
  8d50f1:	48 c1 e8 20          	shr    $0x20,%rax
  8d50f5:	4c 89 ee             	mov    %r13,%rsi
  8d50f8:	48 89 ef             	mov    %rbp,%rdi
  8d50fb:	89 82 c8 00 00 00    	mov    %eax,0xc8(%rdx)
  8d5101:	49 c7 84 24 18 02 00 	movq   $0x0,0x218(%r12)
  8d5108:	00 00 00 00 00 
  8d510d:	e8 7e b2 72 ff       	callq  390 <efi64_stub_entry>

00000000008d5112 <efi_main>:
  8d5112:	f3 0f 1e fa          	endbr64 
  8d5116:	48 b8 49 42 49 20 53 	movabs $0x5453595320494249,%rax
  8d511d:	59 53 54 
  8d5120:	41 57                	push   %r15
  8d5122:	41 56                	push   %r14
  8d5124:	41 55                	push   %r13
  8d5126:	41 54                	push   %r12
  8d5128:	55                   	push   %rbp
  8d5129:	53                   	push   %rbx
  8d512a:	48 81 ec d8 00 00 00 	sub    $0xd8,%rsp
  8d5131:	48 89 35 c8 ea 01 00 	mov    %rsi,0x1eac8(%rip)        # 8f3c00 <efi_system_table>
  8d5138:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8d513d:	48 8d 3d bc ae 72 ff 	lea    -0x8d5144(%rip),%rdi        # 0 <startup_32>
  8d5144:	48 89 7c 24 38       	mov    %rdi,0x38(%rsp)
  8d5149:	48 39 06             	cmp    %rax,(%rsi)
  8d514c:	74 0f                	je     8d515d <efi_main+0x4b>
  8d514e:	48 be 02 00 00 00 00 	movabs $0x8000000000000002,%rsi
  8d5155:	00 00 80 
  8d5158:	e9 f4 0e 00 00       	jmpq   8d6051 <efi_main+0xf3f>
  8d515d:	48 89 d3             	mov    %rdx,%rbx
  8d5160:	8b 15 9a 70 00 00    	mov    0x709a(%rip),%edx        # 8dc200 <image_offset>
  8d5166:	48 8d 05 92 ae 72 ff 	lea    -0x8d516e(%rip),%rax        # ffffffffffffffff <z_output_len+0xfffffffffdf86657>
  8d516d:	44 8b 83 30 02 00 00 	mov    0x230(%rbx),%r8d
  8d5174:	48 89 d1             	mov    %rdx,%rcx
  8d5177:	48 29 d0             	sub    %rdx,%rax
  8d517a:	4c 89 c2             	mov    %r8,%rdx
  8d517d:	4c 01 c0             	add    %r8,%rax
  8d5180:	48 f7 da             	neg    %rdx
  8d5183:	48 21 d0             	and    %rdx,%rax
  8d5186:	8b 93 60 02 00 00    	mov    0x260(%rbx),%edx
  8d518c:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8d5192:	40 0f 96 c6          	setbe  %sil
  8d5196:	85 c9                	test   %ecx,%ecx
  8d5198:	0f 94 c1             	sete   %cl
  8d519b:	40 08 ce             	or     %cl,%sil
  8d519e:	75 11                	jne    8d51b1 <efi_main+0x9f>
  8d51a0:	b9 01 00 00 00       	mov    $0x1,%ecx
  8d51a5:	48 01 d0             	add    %rdx,%rax
  8d51a8:	48 c1 e1 2e          	shl    $0x2e,%rcx
  8d51ac:	48 39 c8             	cmp    %rcx,%rax
  8d51af:	76 3e                	jbe    8d51ef <efi_main+0xdd>
  8d51b1:	48 8b 8b 58 02 00 00 	mov    0x258(%rbx),%rcx
  8d51b8:	48 8d 35 01 71 00 00 	lea    0x7101(%rip),%rsi        # 8dc2c0 <boot_heap>
  8d51bf:	41 b9 00 00 00 01    	mov    $0x1000000,%r9d
  8d51c5:	48 29 fe             	sub    %rdi,%rsi
  8d51c8:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  8d51cd:	e8 14 41 00 00       	callq  8d92e6 <efi_relocate_kernel>
  8d51d2:	48 8d 3d e5 66 00 00 	lea    0x66e5(%rip),%rdi        # 8db8be <kernel_info_end+0x72e>
  8d51d9:	49 89 c4             	mov    %rax,%r12
  8d51dc:	48 85 c0             	test   %rax,%rax
  8d51df:	0f 85 54 0e 00 00    	jne    8d6039 <efi_main+0xf27>
  8d51e5:	c7 05 11 70 00 00 00 	movl   $0x0,0x7011(%rip)        # 8dc200 <image_offset>
  8d51ec:	00 00 00 
  8d51ef:	8b bb c8 00 00 00    	mov    0xc8(%rbx),%edi
  8d51f5:	8b 83 28 02 00 00    	mov    0x228(%rbx),%eax
  8d51fb:	48 c1 e7 20          	shl    $0x20,%rdi
  8d51ff:	48 09 c7             	or     %rax,%rdi
  8d5202:	e8 d8 10 00 00       	callq  8d62df <efi_parse_options>
  8d5207:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d520c:	48 85 c0             	test   %rax,%rax
  8d520f:	74 18                	je     8d5229 <efi_main+0x117>
  8d5211:	48 8d 3d ce 66 00 00 	lea    0x66ce(%rip),%rdi        # 8db8e6 <kernel_info_end+0x756>
  8d5218:	31 c0                	xor    %eax,%eax
  8d521a:	e8 ad 0f 00 00       	callq  8d61cc <efi_printk>
  8d521f:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
  8d5224:	e9 17 0e 00 00       	jmpq   8d6040 <efi_main+0xf2e>
  8d5229:	80 3d da e9 01 00 00 	cmpb   $0x0,0x1e9da(%rip)        # 8f3c0a <efi_noinitrd>
  8d5230:	75 6e                	jne    8d52a0 <efi_main+0x18e>
  8d5232:	48 8b 3d 27 70 00 00 	mov    0x7027(%rip),%rdi        # 8dc260 <image>
  8d5239:	8b 8b 2c 02 00 00    	mov    0x22c(%rbx),%ecx
  8d523f:	49 83 c8 ff          	or     $0xffffffffffffffff,%r8
  8d5243:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  8d524a:	00 
  8d524b:	48 8d b4 24 90 00 00 	lea    0x90(%rsp),%rsi
  8d5252:	00 
  8d5253:	e8 77 18 00 00       	callq  8d6acf <efi_load_initrd>
  8d5258:	48 8d 3d a9 66 00 00 	lea    0x66a9(%rip),%rdi        # 8db908 <kernel_info_end+0x778>
  8d525f:	49 89 c4             	mov    %rax,%r12
  8d5262:	48 85 c0             	test   %rax,%rax
  8d5265:	0f 85 ce 0d 00 00    	jne    8d6039 <efi_main+0xf27>
  8d526b:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
  8d5272:	00 
  8d5273:	48 85 c0             	test   %rax,%rax
  8d5276:	74 28                	je     8d52a0 <efi_main+0x18e>
  8d5278:	48 8b 94 24 90 00 00 	mov    0x90(%rsp),%rdx
  8d527f:	00 
  8d5280:	89 83 1c 02 00 00    	mov    %eax,0x21c(%rbx)
  8d5286:	48 c1 e8 20          	shr    $0x20,%rax
  8d528a:	89 83 c4 00 00 00    	mov    %eax,0xc4(%rbx)
  8d5290:	89 93 18 02 00 00    	mov    %edx,0x218(%rbx)
  8d5296:	48 c1 ea 20          	shr    $0x20,%rdx
  8d529a:	89 93 c0 00 00 00    	mov    %edx,0xc0(%rbx)
  8d52a0:	80 bb ec 01 00 00 00 	cmpb   $0x0,0x1ec(%rbx)
  8d52a7:	75 0b                	jne    8d52b4 <efi_main+0x1a2>
  8d52a9:	e8 b2 41 00 00       	callq  8d9460 <efi_get_secureboot>
  8d52ae:	88 83 ec 01 00 00    	mov    %al,0x1ec(%rbx)
  8d52b4:	e8 ae 3b 00 00       	callq  8d8e67 <efi_random_get_seed>
  8d52b9:	e8 2e 44 00 00       	callq  8d96ec <efi_retrieve_tpm2_eventlog>
  8d52be:	31 f6                	xor    %esi,%esi
  8d52c0:	ba 40 00 00 00       	mov    $0x40,%edx
  8d52c5:	48 89 df             	mov    %rbx,%rdi
  8d52c8:	48 b8 de a9 42 90 dc 	movabs $0x4a3823dc9042a9de,%rax
  8d52cf:	23 38 4a 
  8d52d2:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  8d52d9:	00 
  8d52da:	48 b8 96 fb 7a de d0 	movabs $0x6a5180d0de7afb96,%rax
  8d52e1:	80 51 6a 
  8d52e4:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  8d52eb:	00 
  8d52ec:	48 b8 8b 29 2c 98 fa 	movabs $0x41cbf4fa982c298b,%rax
  8d52f3:	f4 cb 41 
  8d52f6:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
  8d52fd:	00 
  8d52fe:	48 b8 b8 38 77 aa 68 	movabs $0x39b88f68aa7738b8,%rax
  8d5305:	8f b8 39 
  8d5308:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  8d530f:	00 
  8d5310:	e8 5b dd ff ff       	callq  8d3070 <memset>
  8d5315:	40 8a 2d f4 6e 00 00 	mov    0x6ef4(%rip),%bpl        # 8dc210 <efi_is64>
  8d531c:	48 8b 05 dd e8 01 00 	mov    0x1e8dd(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5323:	48 c7 44 24 58 00 00 	movq   $0x0,0x58(%rsp)
  8d532a:	00 00 
  8d532c:	4c 8d 64 24 58       	lea    0x58(%rsp),%r12
  8d5331:	4c 8d ac 24 80 00 00 	lea    0x80(%rsp),%r13
  8d5338:	00 
  8d5339:	40 84 ed             	test   %bpl,%bpl
  8d533c:	74 26                	je     8d5364 <efi_main+0x252>
  8d533e:	41 57                	push   %r15
  8d5340:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5344:	4d 89 e1             	mov    %r12,%r9
  8d5347:	45 31 c0             	xor    %r8d,%r8d
  8d534a:	6a 00                	pushq  $0x0
  8d534c:	4c 89 ea             	mov    %r13,%rdx
  8d534f:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5354:	48 83 ec 20          	sub    $0x20,%rsp
  8d5358:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d535e:	48 83 c4 30          	add    $0x30,%rsp
  8d5362:	eb 1d                	jmp    8d5381 <efi_main+0x26f>
  8d5364:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5367:	45 31 c9             	xor    %r9d,%r9d
  8d536a:	4d 89 e0             	mov    %r12,%r8
  8d536d:	31 c9                	xor    %ecx,%ecx
  8d536f:	4c 89 ea             	mov    %r13,%rdx
  8d5372:	be 02 00 00 00       	mov    $0x2,%esi
  8d5377:	8b 78 64             	mov    0x64(%rax),%edi
  8d537a:	31 c0                	xor    %eax,%eax
  8d537c:	e8 ff f9 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5381:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d5388:	00 00 80 
  8d538b:	48 39 d0             	cmp    %rdx,%rax
  8d538e:	75 10                	jne    8d53a0 <efi_main+0x28e>
  8d5390:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8d5395:	4c 89 ee             	mov    %r13,%rsi
  8d5398:	48 89 df             	mov    %rbx,%rdi
  8d539b:	e8 00 24 00 00       	callq  8d77a0 <efi_setup_gop>
  8d53a0:	48 85 c0             	test   %rax,%rax
  8d53a3:	0f 84 8d 03 00 00    	je     8d5736 <efi_main+0x624>
  8d53a9:	40 84 ed             	test   %bpl,%bpl
  8d53ac:	48 8b 05 4d e8 01 00 	mov    0x1e84d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d53b3:	48 c7 44 24 58 00 00 	movq   $0x0,0x58(%rsp)
  8d53ba:	00 00 
  8d53bc:	4c 8d ac 24 90 00 00 	lea    0x90(%rsp),%r13
  8d53c3:	00 
  8d53c4:	74 26                	je     8d53ec <efi_main+0x2da>
  8d53c6:	41 56                	push   %r14
  8d53c8:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d53cc:	4d 89 e1             	mov    %r12,%r9
  8d53cf:	45 31 c0             	xor    %r8d,%r8d
  8d53d2:	6a 00                	pushq  $0x0
  8d53d4:	4c 89 ea             	mov    %r13,%rdx
  8d53d7:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d53dc:	48 83 ec 20          	sub    $0x20,%rsp
  8d53e0:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d53e6:	48 83 c4 30          	add    $0x30,%rsp
  8d53ea:	eb 1d                	jmp    8d5409 <efi_main+0x2f7>
  8d53ec:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d53ef:	45 31 c9             	xor    %r9d,%r9d
  8d53f2:	4d 89 e0             	mov    %r12,%r8
  8d53f5:	31 c9                	xor    %ecx,%ecx
  8d53f7:	4c 89 ea             	mov    %r13,%rdx
  8d53fa:	be 02 00 00 00       	mov    $0x2,%esi
  8d53ff:	8b 78 64             	mov    0x64(%rax),%edi
  8d5402:	31 c0                	xor    %eax,%eax
  8d5404:	e8 77 f9 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5409:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d5410:	00 00 80 
  8d5413:	48 39 d0             	cmp    %rdx,%rax
  8d5416:	0f 85 1a 03 00 00    	jne    8d5736 <efi_main+0x624>
  8d541c:	48 8b 54 24 58       	mov    0x58(%rsp),%rdx
  8d5421:	40 84 ed             	test   %bpl,%bpl
  8d5424:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  8d542b:	00 00 
  8d542d:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d5432:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  8d5439:	00 00 
  8d543b:	48 8b 05 be e7 01 00 	mov    0x1e7be(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5442:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
  8d5447:	74 1e                	je     8d5467 <efi_main+0x355>
  8d5449:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d544d:	48 83 ec 20          	sub    $0x20,%rsp
  8d5451:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5456:	ff 50 40             	callq  *0x40(%rax)
  8d5459:	48 83 c4 20          	add    $0x20,%rsp
  8d545d:	48 85 c0             	test   %rax,%rax
  8d5460:	74 30                	je     8d5492 <efi_main+0x380>
  8d5462:	e9 cf 02 00 00       	jmpq   8d5736 <efi_main+0x624>
  8d5467:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d546e:	00 
  8d546f:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5472:	4c 89 c1             	mov    %r8,%rcx
  8d5475:	be 02 00 00 00       	mov    $0x2,%esi
  8d547a:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d547d:	31 c0                	xor    %eax,%eax
  8d547f:	e8 fc f8 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5484:	48 85 c0             	test   %rax,%rax
  8d5487:	0f 84 4b 01 00 00    	je     8d55d8 <efi_main+0x4c6>
  8d548d:	e9 a4 02 00 00       	jmpq   8d5736 <efi_main+0x624>
  8d5492:	48 8b 05 67 e7 01 00 	mov    0x1e767(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5499:	41 53                	push   %r11
  8d549b:	45 31 c0             	xor    %r8d,%r8d
  8d549e:	4c 89 ea             	mov    %r13,%rdx
  8d54a1:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d54a6:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d54aa:	ff 74 24 70          	pushq  0x70(%rsp)
  8d54ae:	48 83 ec 20          	sub    $0x20,%rsp
  8d54b2:	4c 8d 8c 24 90 00 00 	lea    0x90(%rsp),%r9
  8d54b9:	00 
  8d54ba:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d54c0:	48 83 c4 30          	add    $0x30,%rsp
  8d54c4:	48 85 c0             	test   %rax,%rax
  8d54c7:	0f 85 e8 00 00 00    	jne    8d55b5 <efi_main+0x4a3>
  8d54cd:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  8d54d4:	00 00 
  8d54d6:	40 80 fd 01          	cmp    $0x1,%bpl
  8d54da:	48 19 c0             	sbb    %rax,%rax
  8d54dd:	45 31 ed             	xor    %r13d,%r13d
  8d54e0:	45 31 f6             	xor    %r14d,%r14d
  8d54e3:	45 31 ff             	xor    %r15d,%r15d
  8d54e6:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d54eb:	48 83 64 24 10 fc    	andq   $0xfffffffffffffffc,0x10(%rsp)
  8d54f1:	48 83 44 24 10 08    	addq   $0x8,0x10(%rsp)
  8d54f7:	eb 6f                	jmp    8d5568 <efi_main+0x456>
  8d54f9:	40 84 ed             	test   %bpl,%bpl
  8d54fc:	0f 84 0c 01 00 00    	je     8d560e <efi_main+0x4fc>
  8d5502:	4e 8b 24 e9          	mov    (%rcx,%r13,8),%r12
  8d5506:	40 84 ed             	test   %bpl,%bpl
  8d5509:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  8d5510:	00 
  8d5511:	4c 8d 44 24 70       	lea    0x70(%rsp),%r8
  8d5516:	48 b8 00 b2 f5 4c b8 	movabs $0x4ca568b84cf5b200,%rax
  8d551d:	68 a5 4c 
  8d5520:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  8d5527:	00 
  8d5528:	48 b8 9e ec b2 3e 3f 	movabs $0x9a02503f3eb2ec9e,%rax
  8d552f:	50 02 9a 
  8d5532:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  8d5539:	00 
  8d553a:	48 8b 05 bf e6 01 00 	mov    0x1e6bf(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5541:	0f 84 d0 00 00 00    	je     8d5617 <efi_main+0x505>
  8d5547:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d554b:	48 83 ec 20          	sub    $0x20,%rsp
  8d554f:	4c 89 e1             	mov    %r12,%rcx
  8d5552:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d5558:	48 83 c4 20          	add    $0x20,%rsp
  8d555c:	48 85 c0             	test   %rax,%rax
  8d555f:	0f 84 d2 00 00 00    	je     8d5637 <efi_main+0x525>
  8d5565:	49 ff c5             	inc    %r13
  8d5568:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d556d:	31 d2                	xor    %edx,%edx
  8d556f:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d5574:	48 f7 74 24 10       	divq   0x10(%rsp)
  8d5579:	4c 39 e8             	cmp    %r13,%rax
  8d557c:	0f 87 77 ff ff ff    	ja     8d54f9 <efi_main+0x3e7>
  8d5582:	44 89 f8             	mov    %r15d,%eax
  8d5585:	44 09 f0             	or     %r14d,%eax
  8d5588:	74 22                	je     8d55ac <efi_main+0x49a>
  8d558a:	48 b8 08 10 08 08 08 	movabs $0x1808000808081008,%rax
  8d5591:	00 08 18 
  8d5594:	c6 43 0f 70          	movb   $0x70,0xf(%rbx)
  8d5598:	66 c7 43 16 20 00    	movw   $0x20,0x16(%rbx)
  8d559e:	66 44 89 7b 12       	mov    %r15w,0x12(%rbx)
  8d55a3:	66 44 89 73 14       	mov    %r14w,0x14(%rbx)
  8d55a8:	48 89 43 26          	mov    %rax,0x26(%rbx)
  8d55ac:	40 84 ed             	test   %bpl,%bpl
  8d55af:	0f 84 68 01 00 00    	je     8d571d <efi_main+0x60b>
  8d55b5:	48 8b 05 44 e6 01 00 	mov    0x1e644(%rip),%rax        # 8f3c00 <efi_system_table>
  8d55bc:	48 83 ec 20          	sub    $0x20,%rsp
  8d55c0:	48 8b 8c 24 88 00 00 	mov    0x88(%rsp),%rcx
  8d55c7:	00 
  8d55c8:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d55cc:	ff 50 48             	callq  *0x48(%rax)
  8d55cf:	48 83 c4 20          	add    $0x20,%rsp
  8d55d3:	e9 5e 01 00 00       	jmpq   8d5736 <efi_main+0x624>
  8d55d8:	4c 8b 4c 24 68       	mov    0x68(%rsp),%r9
  8d55dd:	31 c9                	xor    %ecx,%ecx
  8d55df:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  8d55e4:	4c 89 ea             	mov    %r13,%rdx
  8d55e7:	48 8b 05 12 e6 01 00 	mov    0x1e612(%rip),%rax        # 8f3c00 <efi_system_table>
  8d55ee:	be 02 00 00 00       	mov    $0x2,%esi
  8d55f3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d55f6:	8b 78 64             	mov    0x64(%rax),%edi
  8d55f9:	31 c0                	xor    %eax,%eax
  8d55fb:	e8 80 f7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5600:	48 85 c0             	test   %rax,%rax
  8d5603:	0f 84 c4 fe ff ff    	je     8d54cd <efi_main+0x3bb>
  8d5609:	e9 0f 01 00 00       	jmpq   8d571d <efi_main+0x60b>
  8d560e:	46 8b 24 a9          	mov    (%rcx,%r13,4),%r12d
  8d5612:	e9 ef fe ff ff       	jmpq   8d5506 <efi_main+0x3f4>
  8d5617:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d561e:	00 
  8d561f:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5622:	4c 89 c1             	mov    %r8,%rcx
  8d5625:	4c 89 e6             	mov    %r12,%rsi
  8d5628:	8b 78 58             	mov    0x58(%rax),%edi
  8d562b:	31 c0                	xor    %eax,%eax
  8d562d:	e8 4e f7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5632:	e9 25 ff ff ff       	jmpq   8d555c <efi_main+0x44a>
  8d5637:	40 84 ed             	test   %bpl,%bpl
  8d563a:	48 8b 05 bf e5 01 00 	mov    0x1e5bf(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5641:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  8d5648:	00 00 
  8d564a:	48 8d 94 24 a0 00 00 	lea    0xa0(%rsp),%rdx
  8d5651:	00 
  8d5652:	4c 8d 44 24 78       	lea    0x78(%rsp),%r8
  8d5657:	74 43                	je     8d569c <efi_main+0x58a>
  8d5659:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d565d:	48 83 ec 20          	sub    $0x20,%rsp
  8d5661:	4c 89 e1             	mov    %r12,%rcx
  8d5664:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d566a:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5671:	00 
  8d5672:	48 83 c4 20          	add    $0x20,%rsp
  8d5676:	48 8d 54 24 34       	lea    0x34(%rsp),%rdx
  8d567b:	41 52                	push   %r10
  8d567d:	48 8d 4c 24 58       	lea    0x58(%rsp),%rcx
  8d5682:	51                   	push   %rcx
  8d5683:	48 89 c1             	mov    %rax,%rcx
  8d5686:	48 83 ec 20          	sub    $0x20,%rsp
  8d568a:	4c 8d 4c 24 78       	lea    0x78(%rsp),%r9
  8d568f:	4c 8d 44 24 70       	lea    0x70(%rsp),%r8
  8d5694:	ff 10                	callq  *(%rax)
  8d5696:	48 83 c4 30          	add    $0x30,%rsp
  8d569a:	eb 40                	jmp    8d56dc <efi_main+0x5ca>
  8d569c:	c7 44 24 7c 00 00 00 	movl   $0x0,0x7c(%rsp)
  8d56a3:	00 
  8d56a4:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d56a7:	4c 89 c1             	mov    %r8,%rcx
  8d56aa:	4c 89 e6             	mov    %r12,%rsi
  8d56ad:	8b 78 58             	mov    0x58(%rax),%edi
  8d56b0:	31 c0                	xor    %eax,%eax
  8d56b2:	e8 c9 f6 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d56b7:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8d56bc:	48 8d 4c 24 40       	lea    0x40(%rsp),%rcx
  8d56c1:	48 8d 54 24 34       	lea    0x34(%rsp),%rdx
  8d56c6:	8b 38                	mov    (%rax),%edi
  8d56c8:	48 89 c6             	mov    %rax,%rsi
  8d56cb:	4c 8d 4c 24 50       	lea    0x50(%rsp),%r9
  8d56d0:	4c 8d 44 24 48       	lea    0x48(%rsp),%r8
  8d56d5:	31 c0                	xor    %eax,%eax
  8d56d7:	e8 a4 f6 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d56dc:	48 85 c0             	test   %rax,%rax
  8d56df:	0f 85 80 fe ff ff    	jne    8d5565 <efi_main+0x453>
  8d56e5:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  8d56eb:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8d56f0:	74 09                	je     8d56fb <efi_main+0x5e9>
  8d56f2:	48 85 c0             	test   %rax,%rax
  8d56f5:	0f 84 6a fe ff ff    	je     8d5565 <efi_main+0x453>
  8d56fb:	44 8b 7c 24 34       	mov    0x34(%rsp),%r15d
  8d5700:	44 8b 74 24 40       	mov    0x40(%rsp),%r14d
  8d5705:	48 85 c0             	test   %rax,%rax
  8d5708:	0f 85 74 fe ff ff    	jne    8d5582 <efi_main+0x470>
  8d570e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8d5713:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d5718:	e9 48 fe ff ff       	jmpq   8d5565 <efi_main+0x453>
  8d571d:	48 8b 05 dc e4 01 00 	mov    0x1e4dc(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5724:	48 8b 74 24 68       	mov    0x68(%rsp),%rsi
  8d5729:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d572c:	8b 78 30             	mov    0x30(%rax),%edi
  8d572f:	31 c0                	xor    %eax,%eax
  8d5731:	e8 4a f6 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5736:	40 84 ed             	test   %bpl,%bpl
  8d5739:	4c 8d 6c 24 78       	lea    0x78(%rsp),%r13
  8d573e:	48 b8 00 b2 f5 4c b8 	movabs $0x4ca568b84cf5b200,%rax
  8d5745:	68 a5 4c 
  8d5748:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  8d574f:	00 00 
  8d5751:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  8d5758:	00 
  8d5759:	4c 8d a4 24 a0 00 00 	lea    0xa0(%rsp),%r12
  8d5760:	00 
  8d5761:	48 b8 9e ec b2 3e 3f 	movabs $0x9a02503f3eb2ec9e,%rax
  8d5768:	50 02 9a 
  8d576b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  8d5772:	00 
  8d5773:	48 8b 05 86 e4 01 00 	mov    0x1e486(%rip),%rax        # 8f3c00 <efi_system_table>
  8d577a:	48 c7 44 24 78 00 00 	movq   $0x0,0x78(%rsp)
  8d5781:	00 00 
  8d5783:	74 39                	je     8d57be <efi_main+0x6ac>
  8d5785:	41 51                	push   %r9
  8d5787:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d578b:	4c 89 e2             	mov    %r12,%rdx
  8d578e:	4d 89 e9             	mov    %r13,%r9
  8d5791:	6a 00                	pushq  $0x0
  8d5793:	45 31 c0             	xor    %r8d,%r8d
  8d5796:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d579b:	48 83 ec 20          	sub    $0x20,%rsp
  8d579f:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d57a5:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d57ac:	00 00 80 
  8d57af:	48 83 c4 30          	add    $0x30,%rsp
  8d57b3:	48 39 d0             	cmp    %rdx,%rax
  8d57b6:	0f 85 ff 00 00 00    	jne    8d58bb <efi_main+0x7a9>
  8d57bc:	eb 32                	jmp    8d57f0 <efi_main+0x6de>
  8d57be:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d57c1:	4c 89 e2             	mov    %r12,%rdx
  8d57c4:	45 31 c9             	xor    %r9d,%r9d
  8d57c7:	4d 89 e8             	mov    %r13,%r8
  8d57ca:	31 c9                	xor    %ecx,%ecx
  8d57cc:	be 02 00 00 00       	mov    $0x2,%esi
  8d57d1:	8b 78 64             	mov    0x64(%rax),%edi
  8d57d4:	31 c0                	xor    %eax,%eax
  8d57d6:	e8 a5 f5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d57db:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d57e2:	00 00 80 
  8d57e5:	48 39 d0             	cmp    %rdx,%rax
  8d57e8:	0f 85 ba 04 00 00    	jne    8d5ca8 <efi_main+0xb96>
  8d57ee:	eb 43                	jmp    8d5833 <efi_main+0x721>
  8d57f0:	48 8b 05 09 e4 01 00 	mov    0x1e409(%rip),%rax        # 8f3c00 <efi_system_table>
  8d57f7:	48 83 ec 20          	sub    $0x20,%rsp
  8d57fb:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5800:	48 8b 94 24 98 00 00 	mov    0x98(%rsp),%rdx
  8d5807:	00 
  8d5808:	4c 8d 84 24 90 00 00 	lea    0x90(%rsp),%r8
  8d580f:	00 
  8d5810:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5814:	ff 50 40             	callq  *0x40(%rax)
  8d5817:	48 83 c4 20          	add    $0x20,%rsp
  8d581b:	48 85 c0             	test   %rax,%rax
  8d581e:	74 6e                	je     8d588e <efi_main+0x77c>
  8d5820:	48 8d 3d 02 61 00 00 	lea    0x6102(%rip),%rdi        # 8db929 <kernel_info_end+0x799>
  8d5827:	31 c0                	xor    %eax,%eax
  8d5829:	e8 9e 09 00 00       	callq  8d61cc <efi_printk>
  8d582e:	e9 97 04 00 00       	jmpq   8d5cca <efi_main+0xbb8>
  8d5833:	48 8b 54 24 78       	mov    0x78(%rsp),%rdx
  8d5838:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  8d583d:	be 02 00 00 00       	mov    $0x2,%esi
  8d5842:	48 8b 05 b7 e3 01 00 	mov    0x1e3b7(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5849:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d5850:	00 
  8d5851:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5854:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d5857:	31 c0                	xor    %eax,%eax
  8d5859:	e8 22 f5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d585e:	48 85 c0             	test   %rax,%rax
  8d5861:	75 bd                	jne    8d5820 <efi_main+0x70e>
  8d5863:	48 8b 05 96 e3 01 00 	mov    0x1e396(%rip),%rax        # 8f3c00 <efi_system_table>
  8d586a:	4d 89 e8             	mov    %r13,%r8
  8d586d:	31 c9                	xor    %ecx,%ecx
  8d586f:	4c 89 e2             	mov    %r12,%rdx
  8d5872:	4c 8b 4c 24 70       	mov    0x70(%rsp),%r9
  8d5877:	be 02 00 00 00       	mov    $0x2,%esi
  8d587c:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d587f:	8b 78 64             	mov    0x64(%rax),%edi
  8d5882:	31 c0                	xor    %eax,%eax
  8d5884:	e8 f7 f4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5889:	e9 1a 04 00 00       	jmpq   8d5ca8 <efi_main+0xb96>
  8d588e:	48 8b 05 6b e3 01 00 	mov    0x1e36b(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5895:	41 50                	push   %r8
  8d5897:	4d 89 e9             	mov    %r13,%r9
  8d589a:	45 31 c0             	xor    %r8d,%r8d
  8d589d:	4c 89 e2             	mov    %r12,%rdx
  8d58a0:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d58a5:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d58a9:	ff 74 24 78          	pushq  0x78(%rsp)
  8d58ad:	48 83 ec 20          	sub    $0x20,%rsp
  8d58b1:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d58b7:	48 83 c4 30          	add    $0x30,%rsp
  8d58bb:	48 85 c0             	test   %rax,%rax
  8d58be:	75 64                	jne    8d5924 <efi_main+0x812>
  8d58c0:	4c 8b a3 50 02 00 00 	mov    0x250(%rbx),%r12
  8d58c7:	eb 0c                	jmp    8d58d5 <efi_main+0x7c3>
  8d58c9:	49 8b 04 24          	mov    (%r12),%rax
  8d58cd:	48 85 c0             	test   %rax,%rax
  8d58d0:	74 08                	je     8d58da <efi_main+0x7c8>
  8d58d2:	49 89 c4             	mov    %rax,%r12
  8d58d5:	4d 85 e4             	test   %r12,%r12
  8d58d8:	75 ef                	jne    8d58c9 <efi_main+0x7b7>
  8d58da:	40 80 fd 01          	cmp    $0x1,%bpl
  8d58de:	48 19 c0             	sbb    %rax,%rax
  8d58e1:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d58e6:	48 8d 84 24 a0 00 00 	lea    0xa0(%rsp),%rax
  8d58ed:	00 
  8d58ee:	48 83 64 24 20 fc    	andq   $0xfffffffffffffffc,0x20(%rsp)
  8d58f4:	48 83 44 24 20 08    	addq   $0x8,0x20(%rsp)
  8d58fa:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d58ff:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8d5904:	31 d2                	xor    %edx,%edx
  8d5906:	48 8b 4c 24 70       	mov    0x70(%rsp),%rcx
  8d590b:	48 f7 74 24 20       	divq   0x20(%rsp)
  8d5910:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
  8d5915:	77 30                	ja     8d5947 <efi_main+0x835>
  8d5917:	f3 0f 1e fa          	endbr64 
  8d591b:	40 84 ed             	test   %bpl,%bpl
  8d591e:	0f 84 8d 03 00 00    	je     8d5cb1 <efi_main+0xb9f>
  8d5924:	48 8b 05 d5 e2 01 00 	mov    0x1e2d5(%rip),%rax        # 8f3c00 <efi_system_table>
  8d592b:	48 83 ec 20          	sub    $0x20,%rsp
  8d592f:	48 8b 8c 24 90 00 00 	mov    0x90(%rsp),%rcx
  8d5936:	00 
  8d5937:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d593b:	ff 50 48             	callq  *0x48(%rax)
  8d593e:	48 83 c4 20          	add    $0x20,%rsp
  8d5942:	e9 83 03 00 00       	jmpq   8d5cca <efi_main+0xbb8>
  8d5947:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d594c:	40 84 ed             	test   %bpl,%bpl
  8d594f:	74 06                	je     8d5957 <efi_main+0x845>
  8d5951:	48 8b 34 c1          	mov    (%rcx,%rax,8),%rsi
  8d5955:	eb 03                	jmp    8d595a <efi_main+0x848>
  8d5957:	8b 34 81             	mov    (%rcx,%rax,4),%esi
  8d595a:	40 84 ed             	test   %bpl,%bpl
  8d595d:	48 8b 05 9c e2 01 00 	mov    0x1e29c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5964:	48 c7 84 24 80 00 00 	movq   $0x0,0x80(%rsp)
  8d596b:	00 00 00 00 00 
  8d5970:	4c 8d 84 24 80 00 00 	lea    0x80(%rsp),%r8
  8d5977:	00 
  8d5978:	74 1c                	je     8d5996 <efi_main+0x884>
  8d597a:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d597e:	48 83 ec 20          	sub    $0x20,%rsp
  8d5982:	48 89 f1             	mov    %rsi,%rcx
  8d5985:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8d598a:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d5990:	48 83 c4 20          	add    $0x20,%rsp
  8d5994:	eb 20                	jmp    8d59b6 <efi_main+0x8a4>
  8d5996:	c7 84 24 84 00 00 00 	movl   $0x0,0x84(%rsp)
  8d599d:	00 00 00 00 
  8d59a1:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d59a4:	4c 89 c1             	mov    %r8,%rcx
  8d59a7:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d59ac:	8b 78 58             	mov    0x58(%rax),%edi
  8d59af:	31 c0                	xor    %eax,%eax
  8d59b1:	e8 ca f3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d59b6:	48 85 c0             	test   %rax,%rax
  8d59b9:	0f 85 d9 02 00 00    	jne    8d5c98 <efi_main+0xb86>
  8d59bf:	4c 8b bc 24 80 00 00 	mov    0x80(%rsp),%r15
  8d59c6:	00 
  8d59c7:	4d 85 ff             	test   %r15,%r15
  8d59ca:	0f 84 c8 02 00 00    	je     8d5c98 <efi_main+0xb86>
  8d59d0:	48 c7 84 24 90 00 00 	movq   $0x0,0x90(%rsp)
  8d59d7:	00 00 00 00 00 
  8d59dc:	40 84 ed             	test   %bpl,%bpl
  8d59df:	74 15                	je     8d59f6 <efi_main+0x8e4>
  8d59e1:	49 8b 87 98 00 00 00 	mov    0x98(%r15),%rax
  8d59e8:	4d 8b b7 90 00 00 00 	mov    0x90(%r15),%r14
  8d59ef:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d59f4:	eb 0d                	jmp    8d5a03 <efi_main+0x8f1>
  8d59f6:	41 8b 47 50          	mov    0x50(%r15),%eax
  8d59fa:	4d 8b 77 48          	mov    0x48(%r15),%r14
  8d59fe:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d5a03:	49 8d 46 ff          	lea    -0x1(%r14),%rax
  8d5a07:	48 3d ff ff ff 00    	cmp    $0xffffff,%rax
  8d5a0d:	0f 87 85 02 00 00    	ja     8d5c98 <efi_main+0xb86>
  8d5a13:	48 83 7c 24 10 00    	cmpq   $0x0,0x10(%rsp)
  8d5a19:	0f 84 79 02 00 00    	je     8d5c98 <efi_main+0xb86>
  8d5a1f:	40 84 ed             	test   %bpl,%bpl
  8d5a22:	48 8b 05 d7 e1 01 00 	mov    0x1e1d7(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5a29:	4d 8d 6e 40          	lea    0x40(%r14),%r13
  8d5a2d:	4c 8d 84 24 90 00 00 	lea    0x90(%rsp),%r8
  8d5a34:	00 
  8d5a35:	74 19                	je     8d5a50 <efi_main+0x93e>
  8d5a37:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5a3b:	48 83 ec 20          	sub    $0x20,%rsp
  8d5a3f:	4c 89 ea             	mov    %r13,%rdx
  8d5a42:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5a47:	ff 50 40             	callq  *0x40(%rax)
  8d5a4a:	48 83 c4 20          	add    $0x20,%rsp
  8d5a4e:	eb 23                	jmp    8d5a73 <efi_main+0x961>
  8d5a50:	4c 89 c1             	mov    %r8,%rcx
  8d5a53:	4c 89 ea             	mov    %r13,%rdx
  8d5a56:	be 02 00 00 00       	mov    $0x2,%esi
  8d5a5b:	c7 84 24 94 00 00 00 	movl   $0x0,0x94(%rsp)
  8d5a62:	00 00 00 00 
  8d5a66:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5a69:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d5a6c:	31 c0                	xor    %eax,%eax
  8d5a6e:	e8 0d f3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5a73:	48 85 c0             	test   %rax,%rax
  8d5a76:	74 13                	je     8d5a8b <efi_main+0x979>
  8d5a78:	48 8d 3d df 5e 00 00 	lea    0x5edf(%rip),%rdi        # 8db95e <kernel_info_end+0x7ce>
  8d5a7f:	31 c0                	xor    %eax,%eax
  8d5a81:	e8 46 07 00 00       	callq  8d61cc <efi_printk>
  8d5a86:	e9 0d 02 00 00       	jmpq   8d5c98 <efi_main+0xb86>
  8d5a8b:	48 8b bc 24 90 00 00 	mov    0x90(%rsp),%rdi
  8d5a92:	00 
  8d5a93:	31 f6                	xor    %esi,%esi
  8d5a95:	ba 40 00 00 00       	mov    $0x40,%edx
  8d5a9a:	41 83 ed 10          	sub    $0x10,%r13d
  8d5a9e:	e8 cd d5 ff ff       	callq  8d3070 <memset>
  8d5aa3:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5aaa:	00 
  8d5aab:	40 84 ed             	test   %bpl,%bpl
  8d5aae:	c7 40 08 03 00 00 00 	movl   $0x3,0x8(%rax)
  8d5ab5:	44 89 68 0c          	mov    %r13d,0xc(%rax)
  8d5ab9:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  8d5ac0:	4c 8b ac 24 90 00 00 	mov    0x90(%rsp),%r13
  8d5ac7:	00 
  8d5ac8:	49 8b 87 90 00 00 00 	mov    0x90(%r15),%rax
  8d5acf:	4d 8d 4d 10          	lea    0x10(%r13),%r9
  8d5ad3:	49 89 45 18          	mov    %rax,0x18(%r13)
  8d5ad7:	74 2e                	je     8d5b07 <efi_main+0x9f5>
  8d5ad9:	57                   	push   %rdi
  8d5ada:	45 31 c0             	xor    %r8d,%r8d
  8d5add:	ba 01 00 00 00       	mov    $0x1,%edx
  8d5ae2:	4c 89 f9             	mov    %r15,%rcx
  8d5ae5:	41 51                	push   %r9
  8d5ae7:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d5aed:	48 83 ec 20          	sub    $0x20,%rsp
  8d5af1:	41 ff 57 30          	callq  *0x30(%r15)
  8d5af5:	48 83 c4 30          	add    $0x30,%rsp
  8d5af9:	48 85 c0             	test   %rax,%rax
  8d5afc:	74 2b                	je     8d5b29 <efi_main+0xa17>
  8d5afe:	48 8d 3d 87 5e 00 00 	lea    0x5e87(%rip),%rdi        # 8db98c <kernel_info_end+0x7fc>
  8d5b05:	eb 5c                	jmp    8d5b63 <efi_main+0xa51>
  8d5b07:	41 8b 7f 18          	mov    0x18(%r15),%edi
  8d5b0b:	31 c9                	xor    %ecx,%ecx
  8d5b0d:	31 c0                	xor    %eax,%eax
  8d5b0f:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d5b15:	ba 01 00 00 00       	mov    $0x1,%edx
  8d5b1a:	4c 89 fe             	mov    %r15,%rsi
  8d5b1d:	e8 5e f2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5b22:	48 85 c0             	test   %rax,%rax
  8d5b25:	74 55                	je     8d5b7c <efi_main+0xa6a>
  8d5b27:	eb d5                	jmp    8d5afe <efi_main+0x9ec>
  8d5b29:	56                   	push   %rsi
  8d5b2a:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d5b30:	41 b8 02 00 00 00    	mov    $0x2,%r8d
  8d5b36:	4c 89 f9             	mov    %r15,%rcx
  8d5b39:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8d5b40:	00 
  8d5b41:	ba 01 00 00 00       	mov    $0x1,%edx
  8d5b46:	48 83 c0 12          	add    $0x12,%rax
  8d5b4a:	50                   	push   %rax
  8d5b4b:	48 83 ec 20          	sub    $0x20,%rsp
  8d5b4f:	41 ff 57 30          	callq  *0x30(%r15)
  8d5b53:	48 83 c4 30          	add    $0x30,%rsp
  8d5b57:	48 85 c0             	test   %rax,%rax
  8d5b5a:	74 51                	je     8d5bad <efi_main+0xa9b>
  8d5b5c:	48 8d 3d 4e 5e 00 00 	lea    0x5e4e(%rip),%rdi        # 8db9b1 <kernel_info_end+0x821>
  8d5b63:	f3 0f 1e fa          	endbr64 
  8d5b67:	31 c0                	xor    %eax,%eax
  8d5b69:	e8 5e 06 00 00       	callq  8d61cc <efi_printk>
  8d5b6e:	40 84 ed             	test   %bpl,%bpl
  8d5b71:	0f 85 8f 00 00 00    	jne    8d5c06 <efi_main+0xaf4>
  8d5b77:	e9 f5 00 00 00       	jmpq   8d5c71 <efi_main+0xb5f>
  8d5b7c:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5b83:	00 
  8d5b84:	41 8b 7f 18          	mov    0x18(%r15),%edi
  8d5b88:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d5b8e:	4c 89 fe             	mov    %r15,%rsi
  8d5b91:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5b96:	ba 01 00 00 00       	mov    $0x1,%edx
  8d5b9b:	4c 8d 48 12          	lea    0x12(%rax),%r9
  8d5b9f:	31 c0                	xor    %eax,%eax
  8d5ba1:	e8 da f1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5ba6:	48 85 c0             	test   %rax,%rax
  8d5ba9:	74 7b                	je     8d5c26 <efi_main+0xb14>
  8d5bab:	eb af                	jmp    8d5b5c <efi_main+0xa4a>
  8d5bad:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5bb4:	00 
  8d5bb5:	51                   	push   %rcx
  8d5bb6:	48 8d 48 38          	lea    0x38(%rax),%rcx
  8d5bba:	48 8d 50 20          	lea    0x20(%rax),%rdx
  8d5bbe:	51                   	push   %rcx
  8d5bbf:	4c 8d 48 30          	lea    0x30(%rax),%r9
  8d5bc3:	4c 8d 40 28          	lea    0x28(%rax),%r8
  8d5bc7:	4c 89 f9             	mov    %r15,%rcx
  8d5bca:	48 83 ec 20          	sub    $0x20,%rsp
  8d5bce:	41 ff 57 70          	callq  *0x70(%r15)
  8d5bd2:	48 83 c4 30          	add    $0x30,%rsp
  8d5bd6:	48 85 c0             	test   %rax,%rax
  8d5bd9:	75 2b                	jne    8d5c06 <efi_main+0xaf4>
  8d5bdb:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5be2:	00 
  8d5be3:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d5be8:	4c 89 f2             	mov    %r14,%rdx
  8d5beb:	48 8d 78 40          	lea    0x40(%rax),%rdi
  8d5bef:	e8 fc d4 ff ff       	callq  8d30f0 <memcpy>
  8d5bf4:	4d 85 e4             	test   %r12,%r12
  8d5bf7:	0f 84 92 00 00 00    	je     8d5c8f <efi_main+0xb7d>
  8d5bfd:	4d 89 2c 24          	mov    %r13,(%r12)
  8d5c01:	e9 95 00 00 00       	jmpq   8d5c9b <efi_main+0xb89>
  8d5c06:	48 8b 05 f3 df 01 00 	mov    0x1dff3(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5c0d:	48 83 ec 20          	sub    $0x20,%rsp
  8d5c11:	48 8b 8c 24 b0 00 00 	mov    0xb0(%rsp),%rcx
  8d5c18:	00 
  8d5c19:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5c1d:	ff 50 48             	callq  *0x48(%rax)
  8d5c20:	48 83 c4 20          	add    $0x20,%rsp
  8d5c24:	eb 72                	jmp    8d5c98 <efi_main+0xb86>
  8d5c26:	48 8b 84 24 90 00 00 	mov    0x90(%rsp),%rax
  8d5c2d:	00 
  8d5c2e:	4c 89 fe             	mov    %r15,%rsi
  8d5c31:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%rax)
  8d5c38:	48 8d 48 28          	lea    0x28(%rax),%rcx
  8d5c3c:	48 8d 50 20          	lea    0x20(%rax),%rdx
  8d5c40:	c7 40 34 00 00 00 00 	movl   $0x0,0x34(%rax)
  8d5c47:	4c 8d 48 38          	lea    0x38(%rax),%r9
  8d5c4b:	4c 8d 40 30          	lea    0x30(%rax),%r8
  8d5c4f:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%rax)
  8d5c56:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%rax)
  8d5c5d:	41 8b 7f 38          	mov    0x38(%r15),%edi
  8d5c61:	31 c0                	xor    %eax,%eax
  8d5c63:	e8 18 f1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5c68:	48 85 c0             	test   %rax,%rax
  8d5c6b:	0f 84 6a ff ff ff    	je     8d5bdb <efi_main+0xac9>
  8d5c71:	48 8b 05 88 df 01 00 	mov    0x1df88(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5c78:	48 8b b4 24 90 00 00 	mov    0x90(%rsp),%rsi
  8d5c7f:	00 
  8d5c80:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5c83:	8b 78 30             	mov    0x30(%rax),%edi
  8d5c86:	31 c0                	xor    %eax,%eax
  8d5c88:	e8 f3 f0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5c8d:	eb 09                	jmp    8d5c98 <efi_main+0xb86>
  8d5c8f:	4c 89 ab 50 02 00 00 	mov    %r13,0x250(%rbx)
  8d5c96:	eb 03                	jmp    8d5c9b <efi_main+0xb89>
  8d5c98:	4d 89 e5             	mov    %r12,%r13
  8d5c9b:	48 ff 44 24 08       	incq   0x8(%rsp)
  8d5ca0:	4d 89 ec             	mov    %r13,%r12
  8d5ca3:	e9 57 fc ff ff       	jmpq   8d58ff <efi_main+0x7ed>
  8d5ca8:	48 85 c0             	test   %rax,%rax
  8d5cab:	0f 84 0f fc ff ff    	je     8d58c0 <efi_main+0x7ae>
  8d5cb1:	48 8b 05 48 df 01 00 	mov    0x1df48(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5cb8:	48 8b 74 24 70       	mov    0x70(%rsp),%rsi
  8d5cbd:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5cc0:	8b 78 30             	mov    0x30(%rax),%edi
  8d5cc3:	31 c0                	xor    %eax,%eax
  8d5cc5:	e8 b6 f0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5cca:	48 8b 05 2f df 01 00 	mov    0x1df2f(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5cd1:	40 84 ed             	test   %bpl,%bpl
  8d5cd4:	74 06                	je     8d5cdc <efi_main+0xbca>
  8d5cd6:	48 8b 78 18          	mov    0x18(%rax),%rdi
  8d5cda:	eb 03                	jmp    8d5cdf <efi_main+0xbcd>
  8d5cdc:	8b 78 18             	mov    0x18(%rax),%edi
  8d5cdf:	48 8d 35 7a 52 00 00 	lea    0x527a(%rip),%rsi        # 8daf60 <apple>
  8d5ce6:	ba 0c 00 00 00       	mov    $0xc,%edx
  8d5ceb:	e8 40 d0 ff ff       	callq  8d2d30 <memcmp>
  8d5cf0:	40 84 ed             	test   %bpl,%bpl
  8d5cf3:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
  8d5cf8:	48 8d 74 24 70       	lea    0x70(%rsp),%rsi
  8d5cfd:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  8d5d04:	00 00 
  8d5d06:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  8d5d0d:	00 
  8d5d0e:	48 8d 44 24 40       	lea    0x40(%rsp),%rax
  8d5d13:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
  8d5d1a:	00 
  8d5d1b:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
  8d5d22:	00 
  8d5d23:	48 8d 44 24 50       	lea    0x50(%rsp),%rax
  8d5d28:	4c 8d 44 24 78       	lea    0x78(%rsp),%r8
  8d5d2d:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  8d5d34:	00 
  8d5d35:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
  8d5d3a:	4c 8d 4c 24 34       	lea    0x34(%rsp),%r9
  8d5d3f:	48 89 84 24 b8 00 00 	mov    %rax,0xb8(%rsp)
  8d5d46:	00 
  8d5d47:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
  8d5d4c:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
  8d5d53:	00 
  8d5d54:	48 8d 44 24 58       	lea    0x58(%rsp),%rax
  8d5d59:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
  8d5d60:	00 
  8d5d61:	48 8d 83 c0 01 00 00 	lea    0x1c0(%rbx),%rax
  8d5d68:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
  8d5d6f:	00 
  8d5d70:	48 8b 05 89 de 01 00 	mov    0x1de89(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5d77:	48 89 9c 24 90 00 00 	mov    %rbx,0x90(%rsp)
  8d5d7e:	00 
  8d5d7f:	48 c7 44 24 70 00 00 	movq   $0x0,0x70(%rsp)
  8d5d86:	00 00 
  8d5d88:	74 22                	je     8d5dac <efi_main+0xc9a>
  8d5d8a:	52                   	push   %rdx
  8d5d8b:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5d8f:	31 d2                	xor    %edx,%edx
  8d5d91:	41 51                	push   %r9
  8d5d93:	4d 89 c1             	mov    %r8,%r9
  8d5d96:	49 89 c8             	mov    %rcx,%r8
  8d5d99:	48 89 f1             	mov    %rsi,%rcx
  8d5d9c:	48 83 ec 20          	sub    $0x20,%rsp
  8d5da0:	ff 50 38             	callq  *0x38(%rax)
  8d5da3:	49 89 c4             	mov    %rax,%r12
  8d5da6:	48 83 c4 30          	add    $0x30,%rsp
  8d5daa:	eb 25                	jmp    8d5dd1 <efi_main+0xcbf>
  8d5dac:	c7 44 24 7c 00 00 00 	movl   $0x0,0x7c(%rsp)
  8d5db3:	00 
  8d5db4:	31 d2                	xor    %edx,%edx
  8d5db6:	c7 84 24 84 00 00 00 	movl   $0x0,0x84(%rsp)
  8d5dbd:	00 00 00 00 
  8d5dc1:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5dc4:	8b 78 28             	mov    0x28(%rax),%edi
  8d5dc7:	31 c0                	xor    %eax,%eax
  8d5dc9:	e8 b2 ef ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5dce:	49 89 c4             	mov    %rax,%r12
  8d5dd1:	48 b8 05 00 00 00 00 	movabs $0x8000000000000005,%rax
  8d5dd8:	00 00 80 
  8d5ddb:	49 39 c4             	cmp    %rax,%r12
  8d5dde:	74 18                	je     8d5df8 <efi_main+0xce6>
  8d5de0:	4d 85 e4             	test   %r12,%r12
  8d5de3:	0f 85 49 02 00 00    	jne    8d6032 <efi_main+0xf20>
  8d5de9:	49 bc 03 00 00 00 00 	movabs $0x8000000000000003,%r12
  8d5df0:	00 00 80 
  8d5df3:	e9 3a 02 00 00       	jmpq   8d6032 <efi_main+0xf20>
  8d5df8:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8d5dfd:	31 d2                	xor    %edx,%edx
  8d5dff:	48 f7 74 24 78       	divq   0x78(%rsp)
  8d5e04:	8d 50 08             	lea    0x8(%rax),%edx
  8d5e07:	81 fa 80 00 00 00    	cmp    $0x80,%edx
  8d5e0d:	77 07                	ja     8d5e16 <efi_main+0xd04>
  8d5e0f:	31 ed                	xor    %ebp,%ebp
  8d5e11:	e9 a2 00 00 00       	jmpq   8d5eb8 <efi_main+0xda6>
  8d5e16:	44 8d 68 88          	lea    -0x78(%rax),%r13d
  8d5e1a:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d5e1f:	4d 6b ed 14          	imul   $0x14,%r13,%r13
  8d5e23:	49 83 c5 10          	add    $0x10,%r13
  8d5e27:	48 85 c9             	test   %rcx,%rcx
  8d5e2a:	74 36                	je     8d5e62 <efi_main+0xd50>
  8d5e2c:	48 8b 05 cd dd 01 00 	mov    0x1ddcd(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5e33:	40 84 ed             	test   %bpl,%bpl
  8d5e36:	74 11                	je     8d5e49 <efi_main+0xd37>
  8d5e38:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5e3c:	48 83 ec 20          	sub    $0x20,%rsp
  8d5e40:	ff 50 48             	callq  *0x48(%rax)
  8d5e43:	48 83 c4 20          	add    $0x20,%rsp
  8d5e47:	eb 10                	jmp    8d5e59 <efi_main+0xd47>
  8d5e49:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5e4c:	48 89 ce             	mov    %rcx,%rsi
  8d5e4f:	8b 78 30             	mov    0x30(%rax),%edi
  8d5e52:	31 c0                	xor    %eax,%eax
  8d5e54:	e8 27 ef ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5e59:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  8d5e60:	00 00 
  8d5e62:	40 84 ed             	test   %bpl,%bpl
  8d5e65:	48 8b 05 94 dd 01 00 	mov    0x1dd94(%rip),%rax        # 8f3c00 <efi_system_table>
  8d5e6c:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d5e71:	74 19                	je     8d5e8c <efi_main+0xd7a>
  8d5e73:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d5e77:	48 83 ec 20          	sub    $0x20,%rsp
  8d5e7b:	4c 89 ea             	mov    %r13,%rdx
  8d5e7e:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d5e83:	ff 50 40             	callq  *0x40(%rax)
  8d5e86:	48 83 c4 20          	add    $0x20,%rsp
  8d5e8a:	eb 20                	jmp    8d5eac <efi_main+0xd9a>
  8d5e8c:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d5e93:	00 
  8d5e94:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d5e97:	4c 89 c1             	mov    %r8,%rcx
  8d5e9a:	4c 89 ea             	mov    %r13,%rdx
  8d5e9d:	be 02 00 00 00       	mov    $0x2,%esi
  8d5ea2:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d5ea5:	31 c0                	xor    %eax,%eax
  8d5ea7:	e8 d4 ee ff ff       	callq  8d4d80 <__efi64_thunk>
  8d5eac:	48 85 c0             	test   %rax,%rax
  8d5eaf:	0f 85 7a 01 00 00    	jne    8d602f <efi_main+0xf1d>
  8d5eb5:	44 89 ed             	mov    %r13d,%ebp
  8d5eb8:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d5ebd:	48 8d 94 24 90 00 00 	lea    0x90(%rsp),%rdx
  8d5ec4:	00 
  8d5ec5:	48 8d b4 24 a0 00 00 	lea    0xa0(%rsp),%rsi
  8d5ecc:	00 
  8d5ecd:	48 8d 0d ef ef ff ff 	lea    -0x1011(%rip),%rcx        # 8d4ec3 <exit_boot_func>
  8d5ed4:	e8 66 09 00 00       	callq  8d683f <efi_exit_boot_services>
  8d5ed9:	48 85 c0             	test   %rax,%rax
  8d5edc:	0f 85 4d 01 00 00    	jne    8d602f <efi_main+0xf1d>
  8d5ee2:	8b 83 d4 01 00 00    	mov    0x1d4(%rbx),%eax
  8d5ee8:	31 d2                	xor    %edx,%edx
  8d5eea:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  8d5eef:	45 31 d2             	xor    %r10d,%r10d
  8d5ef2:	c7 83 e0 01 00 00 00 	movl   $0x8000,0x1e0(%rbx)
  8d5ef9:	80 00 00 
  8d5efc:	4c 8d 83 d0 02 00 00 	lea    0x2d0(%rbx),%r8
  8d5f03:	31 c9                	xor    %ecx,%ecx
  8d5f05:	45 31 c9             	xor    %r9d,%r9d
  8d5f08:	48 8d 77 10          	lea    0x10(%rdi),%rsi
  8d5f0c:	4c 8d 35 3d 50 00 00 	lea    0x503d(%rip),%r14        # 8daf50 <CSWTCH.211>
  8d5f13:	f7 b3 c8 01 00 00    	divl   0x1c8(%rbx)
  8d5f19:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8d5f1e:	44 6b d8 14          	imul   $0x14,%eax,%r11d
  8d5f22:	44 39 d0             	cmp    %r10d,%eax
  8d5f25:	0f 84 a7 00 00 00    	je     8d5fd2 <efi_main+0xec0>
  8d5f2b:	8b b3 dc 01 00 00    	mov    0x1dc(%rbx),%esi
  8d5f31:	8b 93 d0 01 00 00    	mov    0x1d0(%rbx),%edx
  8d5f37:	48 c1 e6 20          	shl    $0x20,%rsi
  8d5f3b:	48 09 d6             	or     %rdx,%rsi
  8d5f3e:	44 89 d2             	mov    %r10d,%edx
  8d5f41:	0f af 93 c8 01 00 00 	imul   0x1c8(%rbx),%edx
  8d5f48:	48 01 d6             	add    %rdx,%rsi
  8d5f4b:	8b 16                	mov    (%rsi),%edx
  8d5f4d:	83 fa 0e             	cmp    $0xe,%edx
  8d5f50:	77 74                	ja     8d5fc6 <efi_main+0xeb4>
  8d5f52:	41 0f b6 14 16       	movzbl (%r14,%rdx,1),%edx
  8d5f57:	4d 85 c9             	test   %r9,%r9
  8d5f5a:	74 27                	je     8d5f83 <efi_main+0xe71>
  8d5f5c:	41 3b 51 10          	cmp    0x10(%r9),%edx
  8d5f60:	75 21                	jne    8d5f83 <efi_main+0xe71>
  8d5f62:	4d 8b 69 08          	mov    0x8(%r9),%r13
  8d5f66:	4d 8b 39             	mov    (%r9),%r15
  8d5f69:	4d 01 ef             	add    %r13,%r15
  8d5f6c:	4c 3b 7e 08          	cmp    0x8(%rsi),%r15
  8d5f70:	75 11                	jne    8d5f83 <efi_main+0xe71>
  8d5f72:	48 8b 56 18          	mov    0x18(%rsi),%rdx
  8d5f76:	48 c1 e2 0c          	shl    $0xc,%rdx
  8d5f7a:	49 01 d5             	add    %rdx,%r13
  8d5f7d:	4d 89 69 08          	mov    %r13,0x8(%r9)
  8d5f81:	eb 43                	jmp    8d5fc6 <efi_main+0xeb4>
  8d5f83:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  8d5f89:	75 1b                	jne    8d5fa6 <efi_main+0xe94>
  8d5f8b:	45 8d 43 10          	lea    0x10(%r11),%r8d
  8d5f8f:	44 39 c5             	cmp    %r8d,%ebp
  8d5f92:	0f 82 9a 00 00 00    	jb     8d6032 <efi_main+0xf20>
  8d5f98:	48 85 ff             	test   %rdi,%rdi
  8d5f9b:	0f 84 91 00 00 00    	je     8d6032 <efi_main+0xf20>
  8d5fa1:	4c 8b 44 24 08       	mov    0x8(%rsp),%r8
  8d5fa6:	4c 8b 4e 08          	mov    0x8(%rsi),%r9
  8d5faa:	ff c1                	inc    %ecx
  8d5fac:	4d 89 08             	mov    %r9,(%r8)
  8d5faf:	48 8b 76 18          	mov    0x18(%rsi),%rsi
  8d5fb3:	4d 89 c1             	mov    %r8,%r9
  8d5fb6:	49 83 c0 14          	add    $0x14,%r8
  8d5fba:	41 89 50 fc          	mov    %edx,-0x4(%r8)
  8d5fbe:	48 c1 e6 0c          	shl    $0xc,%rsi
  8d5fc2:	49 89 70 f4          	mov    %rsi,-0xc(%r8)
  8d5fc6:	41 ff c2             	inc    %r10d
  8d5fc9:	41 83 eb 14          	sub    $0x14,%r11d
  8d5fcd:	e9 50 ff ff ff       	jmpq   8d5f22 <efi_main+0xe10>
  8d5fd2:	81 f9 80 00 00 00    	cmp    $0x80,%ecx
  8d5fd8:	76 38                	jbe    8d6012 <efi_main+0xf00>
  8d5fda:	83 c1 80             	add    $0xffffff80,%ecx
  8d5fdd:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%rdi)
  8d5fe4:	6b c9 14             	imul   $0x14,%ecx,%ecx
  8d5fe7:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
  8d5fee:	89 4f 0c             	mov    %ecx,0xc(%rdi)
  8d5ff1:	48 8b 83 50 02 00 00 	mov    0x250(%rbx),%rax
  8d5ff8:	48 85 c0             	test   %rax,%rax
  8d5ffb:	74 5e                	je     8d605b <efi_main+0xf49>
  8d5ffd:	48 8b 10             	mov    (%rax),%rdx
  8d6000:	48 85 d2             	test   %rdx,%rdx
  8d6003:	74 05                	je     8d600a <efi_main+0xef8>
  8d6005:	48 89 d0             	mov    %rdx,%rax
  8d6008:	eb ee                	jmp    8d5ff8 <efi_main+0xee6>
  8d600a:	48 89 38             	mov    %rdi,(%rax)
  8d600d:	b9 80 00 00 00       	mov    $0x80,%ecx
  8d6012:	88 8b e8 01 00 00    	mov    %cl,0x1e8(%rbx)
  8d6018:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8d601d:	48 81 c4 d8 00 00 00 	add    $0xd8,%rsp
  8d6024:	5b                   	pop    %rbx
  8d6025:	5d                   	pop    %rbp
  8d6026:	41 5c                	pop    %r12
  8d6028:	41 5d                	pop    %r13
  8d602a:	41 5e                	pop    %r14
  8d602c:	41 5f                	pop    %r15
  8d602e:	c3                   	retq   
  8d602f:	49 89 c4             	mov    %rax,%r12
  8d6032:	48 8d 3d b9 59 00 00 	lea    0x59b9(%rip),%rdi        # 8db9f2 <kernel_info_end+0x862>
  8d6039:	31 c0                	xor    %eax,%eax
  8d603b:	e8 8c 01 00 00       	callq  8d61cc <efi_printk>
  8d6040:	48 8d 3d 8e 59 00 00 	lea    0x598e(%rip),%rdi        # 8db9d5 <kernel_info_end+0x845>
  8d6047:	31 c0                	xor    %eax,%eax
  8d6049:	e8 7e 01 00 00       	callq  8d61cc <efi_printk>
  8d604e:	4c 89 e6             	mov    %r12,%rsi
  8d6051:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d6056:	e8 1a ee ff ff       	callq  8d4e75 <efi_exit>
  8d605b:	48 89 bb 50 02 00 00 	mov    %rdi,0x250(%rbx)
  8d6062:	eb a9                	jmp    8d600d <efi_main+0xefb>

00000000008d6064 <__efi_soft_reserve_enabled>:
  8d6064:	f3 0f 1e fa          	endbr64 
  8d6068:	8a 05 fd 61 00 00    	mov    0x61fd(%rip),%al        # 8dc26b <efi_nosoftreserve>
  8d606e:	83 f0 01             	xor    $0x1,%eax
  8d6071:	c3                   	retq   

00000000008d6072 <efi_char16_puts>:
  8d6072:	f3 0f 1e fa          	endbr64 
  8d6076:	80 3d 93 61 00 00 00 	cmpb   $0x0,0x6193(%rip)        # 8dc210 <efi_is64>
  8d607d:	48 8b 05 7c db 01 00 	mov    0x1db7c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6084:	48 89 fa             	mov    %rdi,%rdx
  8d6087:	74 13                	je     8d609c <efi_char16_puts+0x2a>
  8d6089:	48 83 ec 28          	sub    $0x28,%rsp
  8d608d:	48 8b 40 40          	mov    0x40(%rax),%rax
  8d6091:	48 89 c1             	mov    %rax,%rcx
  8d6094:	ff 50 08             	callq  *0x8(%rax)
  8d6097:	48 83 c4 28          	add    $0x28,%rsp
  8d609b:	c3                   	retq   
  8d609c:	8b 70 2c             	mov    0x2c(%rax),%esi
  8d609f:	31 c0                	xor    %eax,%eax
  8d60a1:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d60a4:	e9 d7 ec ff ff       	jmpq   8d4d80 <__efi64_thunk>

00000000008d60a9 <efi_puts>:
  8d60a9:	f3 0f 1e fa          	endbr64 
  8d60ad:	55                   	push   %rbp
  8d60ae:	31 f6                	xor    %esi,%esi
  8d60b0:	53                   	push   %rbx
  8d60b1:	48 81 ec 08 01 00 00 	sub    $0x108,%rsp
  8d60b8:	48 89 e5             	mov    %rsp,%rbp
  8d60bb:	44 8a 07             	mov    (%rdi),%r8b
  8d60be:	45 84 c0             	test   %r8b,%r8b
  8d60c1:	0f 84 fb 00 00 00    	je     8d61c2 <efi_puts+0x119>
  8d60c7:	41 80 f8 0a          	cmp    $0xa,%r8b
  8d60cb:	75 09                	jne    8d60d6 <efi_puts+0x2d>
  8d60cd:	66 c7 04 74 0d 00    	movw   $0xd,(%rsp,%rsi,2)
  8d60d3:	48 ff c6             	inc    %rsi
  8d60d6:	48 8d 5f 01          	lea    0x1(%rdi),%rbx
  8d60da:	44 89 c0             	mov    %r8d,%eax
  8d60dd:	31 c9                	xor    %ecx,%ecx
  8d60df:	84 c0                	test   %al,%al
  8d60e1:	79 07                	jns    8d60ea <efi_puts+0x41>
  8d60e3:	01 c0                	add    %eax,%eax
  8d60e5:	48 ff c1             	inc    %rcx
  8d60e8:	eb f5                	jmp    8d60df <efi_puts+0x36>
  8d60ea:	48 8d 51 fe          	lea    -0x2(%rcx),%rdx
  8d60ee:	48 83 fa 02          	cmp    $0x2,%rdx
  8d60f2:	77 72                	ja     8d6166 <efi_puts+0xbd>
  8d60f4:	0f b6 c0             	movzbl %al,%eax
  8d60f7:	4c 8d 49 ff          	lea    -0x1(%rcx),%r9
  8d60fb:	45 31 d2             	xor    %r10d,%r10d
  8d60fe:	d3 f8                	sar    %cl,%eax
  8d6100:	42 8a 54 17 01       	mov    0x1(%rdi,%r10,1),%dl
  8d6105:	83 c2 80             	add    $0xffffff80,%edx
  8d6108:	f6 c2 c0             	test   $0xc0,%dl
  8d610b:	75 59                	jne    8d6166 <efi_puts+0xbd>
  8d610d:	c1 e0 06             	shl    $0x6,%eax
  8d6110:	0f b6 d2             	movzbl %dl,%edx
  8d6113:	49 ff c2             	inc    %r10
  8d6116:	09 d0                	or     %edx,%eax
  8d6118:	4d 39 d1             	cmp    %r10,%r9
  8d611b:	77 e3                	ja     8d6100 <efi_puts+0x57>
  8d611d:	4c 8d 56 01          	lea    0x1(%rsi),%r10
  8d6121:	3d ff ff 10 00       	cmp    $0x10ffff,%eax
  8d6126:	77 3e                	ja     8d6166 <efi_puts+0xbd>
  8d6128:	89 c2                	mov    %eax,%edx
  8d612a:	81 e2 00 f8 00 00    	and    $0xf800,%edx
  8d6130:	81 fa 00 d8 00 00    	cmp    $0xd800,%edx
  8d6136:	74 2e                	je     8d6166 <efi_puts+0xbd>
  8d6138:	31 d2                	xor    %edx,%edx
  8d613a:	83 f8 7f             	cmp    $0x7f,%eax
  8d613d:	0f 97 c2             	seta   %dl
  8d6140:	45 31 db             	xor    %r11d,%r11d
  8d6143:	3d ff 07 00 00       	cmp    $0x7ff,%eax
  8d6148:	41 0f 97 c3          	seta   %r11b
  8d614c:	44 01 da             	add    %r11d,%edx
  8d614f:	45 31 db             	xor    %r11d,%r11d
  8d6152:	3d ff ff 00 00       	cmp    $0xffff,%eax
  8d6157:	41 0f 97 c3          	seta   %r11b
  8d615b:	44 01 da             	add    %r11d,%edx
  8d615e:	48 63 d2             	movslq %edx,%rdx
  8d6161:	49 39 d1             	cmp    %rdx,%r9
  8d6164:	74 06                	je     8d616c <efi_puts+0xc3>
  8d6166:	41 0f b6 c0          	movzbl %r8b,%eax
  8d616a:	eb 0b                	jmp    8d6177 <efi_puts+0xce>
  8d616c:	48 8d 1c 0f          	lea    (%rdi,%rcx,1),%rbx
  8d6170:	3d ff ff 00 00       	cmp    $0xffff,%eax
  8d6175:	77 09                	ja     8d6180 <efi_puts+0xd7>
  8d6177:	66 89 04 74          	mov    %ax,(%rsp,%rsi,2)
  8d617b:	48 ff c6             	inc    %rsi
  8d617e:	eb 1f                	jmp    8d619f <efi_puts+0xf6>
  8d6180:	89 c2                	mov    %eax,%edx
  8d6182:	66 25 ff 03          	and    $0x3ff,%ax
  8d6186:	c1 ea 0a             	shr    $0xa,%edx
  8d6189:	66 2d 00 24          	sub    $0x2400,%ax
  8d618d:	66 81 ea 40 28       	sub    $0x2840,%dx
  8d6192:	66 89 14 74          	mov    %dx,(%rsp,%rsi,2)
  8d6196:	48 83 c6 02          	add    $0x2,%rsi
  8d619a:	66 42 89 04 54       	mov    %ax,(%rsp,%r10,2)
  8d619f:	80 3b 00             	cmpb   $0x0,(%rbx)
  8d61a2:	74 06                	je     8d61aa <efi_puts+0x101>
  8d61a4:	48 83 fe 7d          	cmp    $0x7d,%rsi
  8d61a8:	76 10                	jbe    8d61ba <efi_puts+0x111>
  8d61aa:	48 89 ef             	mov    %rbp,%rdi
  8d61ad:	66 c7 04 74 00 00    	movw   $0x0,(%rsp,%rsi,2)
  8d61b3:	e8 ba fe ff ff       	callq  8d6072 <efi_char16_puts>
  8d61b8:	31 f6                	xor    %esi,%esi
  8d61ba:	48 89 df             	mov    %rbx,%rdi
  8d61bd:	e9 f9 fe ff ff       	jmpq   8d60bb <efi_puts+0x12>
  8d61c2:	48 81 c4 08 01 00 00 	add    $0x108,%rsp
  8d61c9:	5b                   	pop    %rbx
  8d61ca:	5d                   	pop    %rbp
  8d61cb:	c3                   	retq   

00000000008d61cc <efi_printk>:
  8d61cc:	f3 0f 1e fa          	endbr64 
  8d61d0:	41 54                	push   %r12
  8d61d2:	49 89 fc             	mov    %rdi,%r12
  8d61d5:	55                   	push   %rbp
  8d61d6:	48 81 ec 68 01 00 00 	sub    $0x168,%rsp
  8d61dd:	48 89 94 24 40 01 00 	mov    %rdx,0x140(%rsp)
  8d61e4:	00 
  8d61e5:	31 d2                	xor    %edx,%edx
  8d61e7:	48 89 b4 24 38 01 00 	mov    %rsi,0x138(%rsp)
  8d61ee:	00 
  8d61ef:	48 89 8c 24 48 01 00 	mov    %rcx,0x148(%rsp)
  8d61f6:	00 
  8d61f7:	4c 89 84 24 50 01 00 	mov    %r8,0x150(%rsp)
  8d61fe:	00 
  8d61ff:	4c 89 8c 24 58 01 00 	mov    %r9,0x158(%rsp)
  8d6206:	00 
  8d6207:	80 3f 01             	cmpb   $0x1,(%rdi)
  8d620a:	75 18                	jne    8d6224 <efi_printk+0x58>
  8d620c:	8a 47 01             	mov    0x1(%rdi),%al
  8d620f:	84 c0                	test   %al,%al
  8d6211:	74 11                	je     8d6224 <efi_printk+0x58>
  8d6213:	3c 37                	cmp    $0x37,%al
  8d6215:	7f 06                	jg     8d621d <efi_printk+0x51>
  8d6217:	3c 2f                	cmp    $0x2f,%al
  8d6219:	7e 09                	jle    8d6224 <efi_printk+0x58>
  8d621b:	eb 04                	jmp    8d6221 <efi_printk+0x55>
  8d621d:	3c 63                	cmp    $0x63,%al
  8d621f:	75 03                	jne    8d6224 <efi_printk+0x58>
  8d6221:	0f be d0             	movsbl %al,%edx
  8d6224:	83 ea 30             	sub    $0x30,%edx
  8d6227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8d622c:	83 fa 09             	cmp    $0x9,%edx
  8d622f:	0f 47 d0             	cmova  %eax,%edx
  8d6232:	31 c0                	xor    %eax,%eax
  8d6234:	39 15 16 60 00 00    	cmp    %edx,0x6016(%rip)        # 8dc250 <efi_loglevel>
  8d623a:	0f 8e 94 00 00 00    	jle    8d62d4 <efi_printk+0x108>
  8d6240:	ff c2                	inc    %edx
  8d6242:	74 0c                	je     8d6250 <efi_printk+0x84>
  8d6244:	48 8d 3d c5 57 00 00 	lea    0x57c5(%rip),%rdi        # 8dba10 <kernel_info_end+0x880>
  8d624b:	e8 59 fe ff ff       	callq  8d60a9 <efi_puts>
  8d6250:	41 80 3c 24 01       	cmpb   $0x1,(%r12)
  8d6255:	75 1b                	jne    8d6272 <efi_printk+0xa6>
  8d6257:	41 8a 44 24 01       	mov    0x1(%r12),%al
  8d625c:	84 c0                	test   %al,%al
  8d625e:	74 12                	je     8d6272 <efi_printk+0xa6>
  8d6260:	3c 37                	cmp    $0x37,%al
  8d6262:	7f 06                	jg     8d626a <efi_printk+0x9e>
  8d6264:	3c 2f                	cmp    $0x2f,%al
  8d6266:	7e 0a                	jle    8d6272 <efi_printk+0xa6>
  8d6268:	eb 04                	jmp    8d626e <efi_printk+0xa2>
  8d626a:	3c 63                	cmp    $0x63,%al
  8d626c:	75 04                	jne    8d6272 <efi_printk+0xa6>
  8d626e:	49 83 c4 02          	add    $0x2,%r12
  8d6272:	48 8d 84 24 80 01 00 	lea    0x180(%rsp),%rax
  8d6279:	00 
  8d627a:	48 8d 6c 24 30       	lea    0x30(%rsp),%rbp
  8d627f:	4c 89 e2             	mov    %r12,%rdx
  8d6282:	be 00 01 00 00       	mov    $0x100,%esi
  8d6287:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d628c:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  8d6291:	48 8d 84 24 30 01 00 	lea    0x130(%rsp),%rax
  8d6298:	00 
  8d6299:	48 89 ef             	mov    %rbp,%rdi
  8d629c:	c7 44 24 18 08 00 00 	movl   $0x8,0x18(%rsp)
  8d62a3:	00 
  8d62a4:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d62a9:	e8 63 38 00 00       	callq  8d9b11 <vsnprintf>
  8d62ae:	48 89 ef             	mov    %rbp,%rdi
  8d62b1:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  8d62b5:	e8 ef fd ff ff       	callq  8d60a9 <efi_puts>
  8d62ba:	8b 44 24 0c          	mov    0xc(%rsp),%eax
  8d62be:	3d ff 00 00 00       	cmp    $0xff,%eax
  8d62c3:	76 0f                	jbe    8d62d4 <efi_printk+0x108>
  8d62c5:	48 8d 3d 4f 57 00 00 	lea    0x574f(%rip),%rdi        # 8dba1b <kernel_info_end+0x88b>
  8d62cc:	e8 d8 fd ff ff       	callq  8d60a9 <efi_puts>
  8d62d1:	83 c8 ff             	or     $0xffffffff,%eax
  8d62d4:	48 81 c4 68 01 00 00 	add    $0x168,%rsp
  8d62db:	5d                   	pop    %rbp
  8d62dc:	41 5c                	pop    %r12
  8d62de:	c3                   	retq   

00000000008d62df <efi_parse_options>:
  8d62df:	f3 0f 1e fa          	endbr64 
  8d62e3:	41 56                	push   %r14
  8d62e5:	41 55                	push   %r13
  8d62e7:	41 54                	push   %r12
  8d62e9:	45 31 e4             	xor    %r12d,%r12d
  8d62ec:	55                   	push   %rbp
  8d62ed:	53                   	push   %rbx
  8d62ee:	48 83 ec 20          	sub    $0x20,%rsp
  8d62f2:	48 85 ff             	test   %rdi,%rdi
  8d62f5:	0f 84 8b 02 00 00    	je     8d6586 <efi_parse_options+0x2a7>
  8d62fb:	be ff 07 00 00       	mov    $0x7ff,%esi
  8d6300:	49 89 fd             	mov    %rdi,%r13
  8d6303:	e8 b8 ca ff ff       	callq  8d2dc0 <strnlen>
  8d6308:	8a 1d 02 5f 00 00    	mov    0x5f02(%rip),%bl        # 8dc210 <efi_is64>
  8d630e:	48 89 c5             	mov    %rax,%rbp
  8d6311:	48 8d 50 01          	lea    0x1(%rax),%rdx
  8d6315:	4c 8d 44 24 08       	lea    0x8(%rsp),%r8
  8d631a:	48 8b 05 df d8 01 00 	mov    0x1d8df(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6321:	84 db                	test   %bl,%bl
  8d6323:	74 19                	je     8d633e <efi_parse_options+0x5f>
  8d6325:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6329:	48 83 ec 20          	sub    $0x20,%rsp
  8d632d:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d6332:	ff 50 40             	callq  *0x40(%rax)
  8d6335:	49 89 c4             	mov    %rax,%r12
  8d6338:	48 83 c4 20          	add    $0x20,%rsp
  8d633c:	eb 20                	jmp    8d635e <efi_parse_options+0x7f>
  8d633e:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6341:	4c 89 c1             	mov    %r8,%rcx
  8d6344:	be 02 00 00 00       	mov    $0x2,%esi
  8d6349:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%rsp)
  8d6350:	00 
  8d6351:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d6354:	31 c0                	xor    %eax,%eax
  8d6356:	e8 25 ea ff ff       	callq  8d4d80 <__efi64_thunk>
  8d635b:	49 89 c4             	mov    %rax,%r12
  8d635e:	4d 85 e4             	test   %r12,%r12
  8d6361:	0f 85 1f 02 00 00    	jne    8d6586 <efi_parse_options+0x2a7>
  8d6367:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d636c:	48 89 ea             	mov    %rbp,%rdx
  8d636f:	4c 89 ee             	mov    %r13,%rsi
  8d6372:	e8 79 cd ff ff       	callq  8d30f0 <memcpy>
  8d6377:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d637c:	c6 04 28 00          	movb   $0x0,(%rax,%rbp,1)
  8d6380:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d6385:	e8 3f 32 00 00       	callq  8d95c9 <skip_spaces>
  8d638a:	48 89 c5             	mov    %rax,%rbp
  8d638d:	4c 8d 74 24 18       	lea    0x18(%rsp),%r14
  8d6392:	80 7d 00 00          	cmpb   $0x0,0x0(%rbp)
  8d6396:	0f 84 b9 01 00 00    	je     8d6555 <efi_parse_options+0x276>
  8d639c:	48 89 ef             	mov    %rbp,%rdi
  8d639f:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  8d63a4:	4c 89 f2             	mov    %r14,%rdx
  8d63a7:	e8 a0 20 00 00       	callq  8d844c <next_arg>
  8d63ac:	48 83 7c 24 18 00    	cmpq   $0x0,0x18(%rsp)
  8d63b2:	48 89 c5             	mov    %rax,%rbp
  8d63b5:	74 1e                	je     8d63d5 <efi_parse_options+0xf6>
  8d63b7:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d63bc:	48 8d 35 6d 56 00 00 	lea    0x566d(%rip),%rsi        # 8dba30 <kernel_info_end+0x8a0>
  8d63c3:	e8 88 c9 ff ff       	callq  8d2d50 <strcmp>
  8d63c8:	85 c0                	test   %eax,%eax
  8d63ca:	75 23                	jne    8d63ef <efi_parse_options+0x110>
  8d63cc:	c6 05 81 5e 00 00 01 	movb   $0x1,0x5e81(%rip)        # 8dc254 <efi_nokaslr>
  8d63d3:	eb bd                	jmp    8d6392 <efi_parse_options+0xb3>
  8d63d5:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d63da:	48 8d 35 57 56 00 00 	lea    0x5657(%rip),%rsi        # 8dba38 <kernel_info_end+0x8a8>
  8d63e1:	e8 6a c9 ff ff       	callq  8d2d50 <strcmp>
  8d63e6:	85 c0                	test   %eax,%eax
  8d63e8:	75 cd                	jne    8d63b7 <efi_parse_options+0xd8>
  8d63ea:	e9 66 01 00 00       	jmpq   8d6555 <efi_parse_options+0x276>
  8d63ef:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d63f4:	48 8d 35 40 56 00 00 	lea    0x5640(%rip),%rsi        # 8dba3b <kernel_info_end+0x8ab>
  8d63fb:	e8 50 c9 ff ff       	callq  8d2d50 <strcmp>
  8d6400:	85 c0                	test   %eax,%eax
  8d6402:	75 0c                	jne    8d6410 <efi_parse_options+0x131>
  8d6404:	c7 05 42 5e 00 00 04 	movl   $0x4,0x5e42(%rip)        # 8dc250 <efi_loglevel>
  8d640b:	00 00 00 
  8d640e:	eb 82                	jmp    8d6392 <efi_parse_options+0xb3>
  8d6410:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d6415:	48 8d 35 25 56 00 00 	lea    0x5625(%rip),%rsi        # 8dba41 <kernel_info_end+0x8b1>
  8d641c:	e8 2f c9 ff ff       	callq  8d2d50 <strcmp>
  8d6421:	85 c0                	test   %eax,%eax
  8d6423:	75 0c                	jne    8d6431 <efi_parse_options+0x152>
  8d6425:	c6 05 de d7 01 00 01 	movb   $0x1,0x1d7de(%rip)        # 8f3c0a <efi_noinitrd>
  8d642c:	e9 61 ff ff ff       	jmpq   8d6392 <efi_parse_options+0xb3>
  8d6431:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d6436:	48 8d 35 0d 56 00 00 	lea    0x560d(%rip),%rsi        # 8dba4a <kernel_info_end+0x8ba>
  8d643d:	e8 0e c9 ff ff       	callq  8d2d50 <strcmp>
  8d6442:	85 c0                	test   %eax,%eax
  8d6444:	0f 85 9e 00 00 00    	jne    8d64e8 <efi_parse_options+0x209>
  8d644a:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d644f:	48 85 ff             	test   %rdi,%rdi
  8d6452:	0f 84 90 00 00 00    	je     8d64e8 <efi_parse_options+0x209>
  8d6458:	48 8d 35 ef 55 00 00 	lea    0x55ef(%rip),%rsi        # 8dba4e <kernel_info_end+0x8be>
  8d645f:	e8 82 1f 00 00       	callq  8d83e6 <parse_option_str>
  8d6464:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d6469:	48 8d 35 e6 55 00 00 	lea    0x55e6(%rip),%rsi        # 8dba56 <kernel_info_end+0x8c6>
  8d6470:	88 05 92 d7 01 00    	mov    %al,0x1d792(%rip)        # 8f3c08 <efi_nochunk>
  8d6476:	e8 6b 1f 00 00       	callq  8d83e6 <parse_option_str>
  8d647b:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d6480:	48 8d 35 da 55 00 00 	lea    0x55da(%rip),%rsi        # 8dba61 <kernel_info_end+0x8d1>
  8d6487:	c6 05 dd 5d 00 00 00 	movb   $0x0,0x5ddd(%rip)        # 8dc26b <efi_nosoftreserve>
  8d648e:	88 05 75 d7 01 00    	mov    %al,0x1d775(%rip)        # 8f3c09 <efi_novamap>
  8d6494:	e8 4d 1f 00 00       	callq  8d83e6 <parse_option_str>
  8d6499:	84 c0                	test   %al,%al
  8d649b:	74 07                	je     8d64a4 <efi_parse_options+0x1c5>
  8d649d:	c6 05 c6 5d 00 00 01 	movb   $0x1,0x5dc6(%rip)        # 8dc26a <efi_disable_pci_dma>
  8d64a4:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d64a9:	48 8d 35 ae 55 00 00 	lea    0x55ae(%rip),%rsi        # 8dba5e <kernel_info_end+0x8ce>
  8d64b0:	e8 31 1f 00 00       	callq  8d83e6 <parse_option_str>
  8d64b5:	84 c0                	test   %al,%al
  8d64b7:	74 07                	je     8d64c0 <efi_parse_options+0x1e1>
  8d64b9:	c6 05 aa 5d 00 00 00 	movb   $0x0,0x5daa(%rip)        # 8dc26a <efi_disable_pci_dma>
  8d64c0:	48 8b 7c 24 18       	mov    0x18(%rsp),%rdi
  8d64c5:	48 8d 35 ab 55 00 00 	lea    0x55ab(%rip),%rsi        # 8dba77 <kernel_info_end+0x8e7>
  8d64cc:	e8 15 1f 00 00       	callq  8d83e6 <parse_option_str>
  8d64d1:	84 c0                	test   %al,%al
  8d64d3:	0f 84 b9 fe ff ff    	je     8d6392 <efi_parse_options+0xb3>
  8d64d9:	c7 05 6d 5d 00 00 0a 	movl   $0xa,0x5d6d(%rip)        # 8dc250 <efi_loglevel>
  8d64e0:	00 00 00 
  8d64e3:	e9 aa fe ff ff       	jmpq   8d6392 <efi_parse_options+0xb3>
  8d64e8:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d64ed:	48 8d 35 89 55 00 00 	lea    0x5589(%rip),%rsi        # 8dba7d <kernel_info_end+0x8ed>
  8d64f4:	e8 57 c8 ff ff       	callq  8d2d50 <strcmp>
  8d64f9:	85 c0                	test   %eax,%eax
  8d64fb:	0f 85 91 fe ff ff    	jne    8d6392 <efi_parse_options+0xb3>
  8d6501:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  8d6506:	4d 85 ed             	test   %r13,%r13
  8d6509:	0f 84 83 fe ff ff    	je     8d6392 <efi_parse_options+0xb3>
  8d650f:	48 8d 3d 6d 55 00 00 	lea    0x556d(%rip),%rdi        # 8dba83 <kernel_info_end+0x8f3>
  8d6516:	e8 15 ca ff ff       	callq  8d2f30 <strlen>
  8d651b:	48 8d 35 61 55 00 00 	lea    0x5561(%rip),%rsi        # 8dba83 <kernel_info_end+0x8f3>
  8d6522:	4c 89 ef             	mov    %r13,%rdi
  8d6525:	48 89 c2             	mov    %rax,%rdx
  8d6528:	e8 53 c8 ff ff       	callq  8d2d80 <strncmp>
  8d652d:	85 c0                	test   %eax,%eax
  8d652f:	0f 85 5d fe ff ff    	jne    8d6392 <efi_parse_options+0xb3>
  8d6535:	4c 8b 6c 24 18       	mov    0x18(%rsp),%r13
  8d653a:	48 8d 3d 42 55 00 00 	lea    0x5542(%rip),%rdi        # 8dba83 <kernel_info_end+0x8f3>
  8d6541:	e8 ea c9 ff ff       	callq  8d2f30 <strlen>
  8d6546:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
  8d654b:	e8 f7 0f 00 00       	callq  8d7547 <efi_parse_option_graphics>
  8d6550:	e9 3d fe ff ff       	jmpq   8d6392 <efi_parse_options+0xb3>
  8d6555:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  8d655a:	48 8b 05 9f d6 01 00 	mov    0x1d69f(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6561:	84 db                	test   %bl,%bl
  8d6563:	74 11                	je     8d6576 <efi_parse_options+0x297>
  8d6565:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6569:	48 83 ec 20          	sub    $0x20,%rsp
  8d656d:	ff 50 48             	callq  *0x48(%rax)
  8d6570:	48 83 c4 20          	add    $0x20,%rsp
  8d6574:	eb 10                	jmp    8d6586 <efi_parse_options+0x2a7>
  8d6576:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6579:	48 89 ce             	mov    %rcx,%rsi
  8d657c:	8b 78 30             	mov    0x30(%rax),%edi
  8d657f:	31 c0                	xor    %eax,%eax
  8d6581:	e8 fa e7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6586:	48 83 c4 20          	add    $0x20,%rsp
  8d658a:	4c 89 e0             	mov    %r12,%rax
  8d658d:	5b                   	pop    %rbx
  8d658e:	5d                   	pop    %rbp
  8d658f:	41 5c                	pop    %r12
  8d6591:	41 5d                	pop    %r13
  8d6593:	41 5e                	pop    %r14
  8d6595:	c3                   	retq   

00000000008d6596 <efi_apply_loadoptions_quirk>:
  8d6596:	f3 0f 1e fa          	endbr64 
  8d659a:	48 8b 0f             	mov    (%rdi),%rcx
  8d659d:	48 85 c9             	test   %rcx,%rcx
  8d65a0:	0f 84 e1 00 00 00    	je     8d6687 <efi_apply_loadoptions_quirk+0xf1>
  8d65a6:	41 55                	push   %r13
  8d65a8:	41 54                	push   %r12
  8d65aa:	49 89 f4             	mov    %rsi,%r12
  8d65ad:	55                   	push   %rbp
  8d65ae:	53                   	push   %rbx
  8d65af:	52                   	push   %rdx
  8d65b0:	48 63 1e             	movslq (%rsi),%rbx
  8d65b3:	83 fb 05             	cmp    $0x5,%ebx
  8d65b6:	0f 86 c3 00 00 00    	jbe    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d65bc:	f7 01 f6 e0 ff ff    	testl  $0xffffe0f6,(%rcx)
  8d65c2:	0f 85 b7 00 00 00    	jne    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d65c8:	49 89 fd             	mov    %rdi,%r13
  8d65cb:	48 8d 41 06          	lea    0x6(%rcx),%rax
  8d65cf:	48 83 eb 06          	sub    $0x6,%rbx
  8d65d3:	48 83 fb 01          	cmp    $0x1,%rbx
  8d65d7:	0f 86 a2 00 00 00    	jbe    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d65dd:	66 8b 10             	mov    (%rax),%dx
  8d65e0:	48 83 eb 02          	sub    $0x2,%rbx
  8d65e4:	48 83 c0 02          	add    $0x2,%rax
  8d65e8:	66 85 d2             	test   %dx,%dx
  8d65eb:	75 e6                	jne    8d65d3 <efi_apply_loadoptions_quirk+0x3d>
  8d65ed:	48 89 c5             	mov    %rax,%rbp
  8d65f0:	48 83 fb 03          	cmp    $0x3,%rbx
  8d65f4:	0f 86 85 00 00 00    	jbe    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d65fa:	0f b7 55 02          	movzwl 0x2(%rbp),%edx
  8d65fe:	40 8a 75 00          	mov    0x0(%rbp),%sil
  8d6602:	40 8a 7d 01          	mov    0x1(%rbp),%dil
  8d6606:	66 83 fa 03          	cmp    $0x3,%dx
  8d660a:	76 73                	jbe    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d660c:	48 39 d3             	cmp    %rdx,%rbx
  8d660f:	72 6e                	jb     8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d6611:	83 e6 7f             	and    $0x7f,%esi
  8d6614:	48 01 d5             	add    %rdx,%rbp
  8d6617:	48 29 d3             	sub    %rdx,%rbx
  8d661a:	40 80 fe 7f          	cmp    $0x7f,%sil
  8d661e:	75 d0                	jne    8d65f0 <efi_apply_loadoptions_quirk+0x5a>
  8d6620:	40 fe c7             	inc    %dil
  8d6623:	75 cb                	jne    8d65f0 <efi_apply_loadoptions_quirk+0x5a>
  8d6625:	0f b7 51 04          	movzwl 0x4(%rcx),%edx
  8d6629:	48 01 d0             	add    %rdx,%rax
  8d662c:	48 39 c5             	cmp    %rax,%rbp
  8d662f:	75 4e                	jne    8d667f <efi_apply_loadoptions_quirk+0xe9>
  8d6631:	48 85 db             	test   %rbx,%rbx
  8d6634:	b8 00 00 00 00       	mov    $0x0,%eax
  8d6639:	48 0f 44 e8          	cmove  %rax,%rbp
  8d663d:	80 3d 25 5c 00 00 00 	cmpb   $0x0,0x5c25(%rip)        # 8dc269 <__print_once.49195>
  8d6644:	75 13                	jne    8d6659 <efi_apply_loadoptions_quirk+0xc3>
  8d6646:	48 8d 3d 3d 54 00 00 	lea    0x543d(%rip),%rdi        # 8dba8a <kernel_info_end+0x8fa>
  8d664d:	c6 05 15 5c 00 00 01 	movb   $0x1,0x5c15(%rip)        # 8dc269 <__print_once.49195>
  8d6654:	e8 73 fb ff ff       	callq  8d61cc <efi_printk>
  8d6659:	80 3d 08 5c 00 00 00 	cmpb   $0x0,0x5c08(%rip)        # 8dc268 <__print_once.49198>
  8d6660:	75 15                	jne    8d6677 <efi_apply_loadoptions_quirk+0xe1>
  8d6662:	48 8d 3d 6a 54 00 00 	lea    0x546a(%rip),%rdi        # 8dbad3 <kernel_info_end+0x943>
  8d6669:	31 c0                	xor    %eax,%eax
  8d666b:	c6 05 f6 5b 00 00 01 	movb   $0x1,0x5bf6(%rip)        # 8dc268 <__print_once.49198>
  8d6672:	e8 55 fb ff ff       	callq  8d61cc <efi_printk>
  8d6677:	49 89 6d 00          	mov    %rbp,0x0(%r13)
  8d667b:	41 89 1c 24          	mov    %ebx,(%r12)
  8d667f:	58                   	pop    %rax
  8d6680:	5b                   	pop    %rbx
  8d6681:	5d                   	pop    %rbp
  8d6682:	41 5c                	pop    %r12
  8d6684:	41 5d                	pop    %r13
  8d6686:	c3                   	retq   
  8d6687:	c3                   	retq   

00000000008d6688 <efi_convert_cmdline>:
  8d6688:	f3 0f 1e fa          	endbr64 
  8d668c:	41 55                	push   %r13
  8d668e:	41 54                	push   %r12
  8d6690:	55                   	push   %rbp
  8d6691:	53                   	push   %rbx
  8d6692:	48 89 f3             	mov    %rsi,%rbx
  8d6695:	48 83 ec 28          	sub    $0x28,%rsp
  8d6699:	40 8a 2d 70 5b 00 00 	mov    0x5b70(%rip),%bpl        # 8dc210 <efi_is64>
  8d66a0:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  8d66a7:	00 00 
  8d66a9:	40 84 ed             	test   %bpl,%bpl
  8d66ac:	74 05                	je     8d66b3 <efi_convert_cmdline+0x2b>
  8d66ae:	8b 47 30             	mov    0x30(%rdi),%eax
  8d66b1:	eb 03                	jmp    8d66b6 <efi_convert_cmdline+0x2e>
  8d66b3:	8b 47 18             	mov    0x18(%rdi),%eax
  8d66b6:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  8d66ba:	40 84 ed             	test   %bpl,%bpl
  8d66bd:	74 06                	je     8d66c5 <efi_convert_cmdline+0x3d>
  8d66bf:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8d66c3:	eb 03                	jmp    8d66c8 <efi_convert_cmdline+0x40>
  8d66c5:	8b 47 1c             	mov    0x1c(%rdi),%eax
  8d66c8:	48 8d 74 24 0c       	lea    0xc(%rsp),%rsi
  8d66cd:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
  8d66d2:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d66d7:	45 31 e4             	xor    %r12d,%r12d
  8d66da:	e8 b7 fe ff ff       	callq  8d6596 <efi_apply_loadoptions_quirk>
  8d66df:	48 63 44 24 0c       	movslq 0xc(%rsp),%rax
  8d66e4:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d66e9:	48 d1 e8             	shr    %rax
  8d66ec:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  8d66f0:	48 85 d2             	test   %rdx,%rdx
  8d66f3:	0f 84 bd 00 00 00    	je     8d67b6 <efi_convert_cmdline+0x12e>
  8d66f9:	31 f6                	xor    %esi,%esi
  8d66fb:	45 31 ed             	xor    %r13d,%r13d
  8d66fe:	4c 8d 0d db 48 00 00 	lea    0x48db(%rip),%r9        # 8dafe0 <_ctype>
  8d6705:	45 31 e4             	xor    %r12d,%r12d
  8d6708:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  8d670c:	8d 79 ff             	lea    -0x1(%rcx),%edi
  8d670f:	89 7c 24 0c          	mov    %edi,0xc(%rsp)
  8d6713:	85 c9                	test   %ecx,%ecx
  8d6715:	0f 84 9b 00 00 00    	je     8d67b6 <efi_convert_cmdline+0x12e>
  8d671b:	0f b7 02             	movzwl (%rdx),%eax
  8d671e:	4c 8d 42 02          	lea    0x2(%rdx),%r8
  8d6722:	66 83 f8 7f          	cmp    $0x7f,%ax
  8d6726:	77 2d                	ja     8d6755 <efi_convert_cmdline+0xcd>
  8d6728:	66 85 c0             	test   %ax,%ax
  8d672b:	0f 84 85 00 00 00    	je     8d67b6 <efi_convert_cmdline+0x12e>
  8d6731:	66 83 f8 0a          	cmp    $0xa,%ax
  8d6735:	74 7f                	je     8d67b6 <efi_convert_cmdline+0x12e>
  8d6737:	66 83 f8 22          	cmp    $0x22,%ax
  8d673b:	75 05                	jne    8d6742 <efi_convert_cmdline+0xba>
  8d673d:	83 f6 01             	xor    $0x1,%esi
  8d6740:	eb 0e                	jmp    8d6750 <efi_convert_cmdline+0xc8>
  8d6742:	40 84 f6             	test   %sil,%sil
  8d6745:	75 09                	jne    8d6750 <efi_convert_cmdline+0xc8>
  8d6747:	41 f6 04 01 20       	testb  $0x20,(%r9,%rax,1)
  8d674c:	45 0f 45 ec          	cmovne %r12d,%r13d
  8d6750:	41 ff c4             	inc    %r12d
  8d6753:	eb 3c                	jmp    8d6791 <efi_convert_cmdline+0x109>
  8d6755:	66 3d 00 08          	cmp    $0x800,%ax
  8d6759:	45 19 d2             	sbb    %r10d,%r10d
  8d675c:	66 25 00 fc          	and    $0xfc00,%ax
  8d6760:	47 8d 64 14 03       	lea    0x3(%r12,%r10,1),%r12d
  8d6765:	66 3d 00 d8          	cmp    $0xd800,%ax
  8d6769:	75 26                	jne    8d6791 <efi_convert_cmdline+0x109>
  8d676b:	85 ff                	test   %edi,%edi
  8d676d:	75 06                	jne    8d6775 <efi_convert_cmdline+0xed>
  8d676f:	41 83 ec 03          	sub    $0x3,%r12d
  8d6773:	eb 25                	jmp    8d679a <efi_convert_cmdline+0x112>
  8d6775:	66 8b 42 02          	mov    0x2(%rdx),%ax
  8d6779:	66 25 00 fc          	and    $0xfc00,%ax
  8d677d:	66 3d 00 dc          	cmp    $0xdc00,%ax
  8d6781:	75 0e                	jne    8d6791 <efi_convert_cmdline+0x109>
  8d6783:	83 e9 02             	sub    $0x2,%ecx
  8d6786:	41 ff c4             	inc    %r12d
  8d6789:	4c 8d 42 04          	lea    0x4(%rdx),%r8
  8d678d:	89 4c 24 0c          	mov    %ecx,0xc(%rsp)
  8d6791:	41 81 fc ff 07 00 00 	cmp    $0x7ff,%r12d
  8d6798:	7f 08                	jg     8d67a2 <efi_convert_cmdline+0x11a>
  8d679a:	4c 89 c2             	mov    %r8,%rdx
  8d679d:	e9 66 ff ff ff       	jmpq   8d6708 <efi_convert_cmdline+0x80>
  8d67a2:	44 89 ee             	mov    %r13d,%esi
  8d67a5:	48 8d 3d 6c 53 00 00 	lea    0x536c(%rip),%rdi        # 8dbb18 <kernel_info_end+0x988>
  8d67ac:	31 c0                	xor    %eax,%eax
  8d67ae:	45 89 ec             	mov    %r13d,%r12d
  8d67b1:	e8 16 fa ff ff       	callq  8d61cc <efi_printk>
  8d67b6:	40 84 ed             	test   %bpl,%bpl
  8d67b9:	45 8d 6c 24 01       	lea    0x1(%r12),%r13d
  8d67be:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  8d67c3:	48 8b 05 36 d4 01 00 	mov    0x1d436(%rip),%rax        # 8f3c00 <efi_system_table>
  8d67ca:	74 19                	je     8d67e5 <efi_convert_cmdline+0x15d>
  8d67cc:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d67d0:	48 83 ec 20          	sub    $0x20,%rsp
  8d67d4:	49 63 d5             	movslq %r13d,%rdx
  8d67d7:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d67dc:	ff 50 40             	callq  *0x40(%rax)
  8d67df:	48 83 c4 20          	add    $0x20,%rsp
  8d67e3:	eb 20                	jmp    8d6805 <efi_convert_cmdline+0x17d>
  8d67e5:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d67e8:	4c 89 c1             	mov    %r8,%rcx
  8d67eb:	44 89 ea             	mov    %r13d,%edx
  8d67ee:	be 02 00 00 00       	mov    $0x2,%esi
  8d67f3:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  8d67fa:	00 
  8d67fb:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d67fe:	31 c0                	xor    %eax,%eax
  8d6800:	e8 7b e5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6805:	45 31 c0             	xor    %r8d,%r8d
  8d6808:	48 85 c0             	test   %rax,%rax
  8d680b:	75 24                	jne    8d6831 <efi_convert_cmdline+0x1a9>
  8d680d:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  8d6812:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
  8d6817:	49 63 f5             	movslq %r13d,%rsi
  8d681a:	44 89 e1             	mov    %r12d,%ecx
  8d681d:	48 8d 15 ee 52 00 00 	lea    0x52ee(%rip),%rdx        # 8dbb12 <kernel_info_end+0x982>
  8d6824:	e8 83 3b 00 00       	callq  8da3ac <snprintf>
  8d6829:	44 89 2b             	mov    %r13d,(%rbx)
  8d682c:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d6831:	48 83 c4 28          	add    $0x28,%rsp
  8d6835:	4c 89 c0             	mov    %r8,%rax
  8d6838:	5b                   	pop    %rbx
  8d6839:	5d                   	pop    %rbp
  8d683a:	41 5c                	pop    %r12
  8d683c:	41 5d                	pop    %r13
  8d683e:	c3                   	retq   

00000000008d683f <efi_exit_boot_services>:
  8d683f:	f3 0f 1e fa          	endbr64 
  8d6843:	41 57                	push   %r15
  8d6845:	49 89 d7             	mov    %rdx,%r15
  8d6848:	41 56                	push   %r14
  8d684a:	49 89 ce             	mov    %rcx,%r14
  8d684d:	41 55                	push   %r13
  8d684f:	49 89 fd             	mov    %rdi,%r13
  8d6852:	48 89 f7             	mov    %rsi,%rdi
  8d6855:	41 54                	push   %r12
  8d6857:	55                   	push   %rbp
  8d6858:	53                   	push   %rbx
  8d6859:	48 89 f3             	mov    %rsi,%rbx
  8d685c:	41 50                	push   %r8
  8d685e:	e8 ab 1c 00 00       	callq  8d850e <efi_get_memory_map>
  8d6863:	49 89 c4             	mov    %rax,%r12
  8d6866:	48 85 c0             	test   %rax,%rax
  8d6869:	0f 85 94 01 00 00    	jne    8d6a03 <efi_exit_boot_services+0x1c4>
  8d686f:	4c 89 fe             	mov    %r15,%rsi
  8d6872:	48 89 df             	mov    %rbx,%rdi
  8d6875:	41 ff d6             	callq  *%r14
  8d6878:	40 8a 2d 91 59 00 00 	mov    0x5991(%rip),%bpl        # 8dc210 <efi_is64>
  8d687f:	49 89 c4             	mov    %rax,%r12
  8d6882:	48 85 c0             	test   %rax,%rax
  8d6885:	74 26                	je     8d68ad <efi_exit_boot_services+0x6e>
  8d6887:	48 8b 03             	mov    (%rbx),%rax
  8d688a:	48 8b 08             	mov    (%rax),%rcx
  8d688d:	48 8b 05 6c d3 01 00 	mov    0x1d36c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6894:	40 84 ed             	test   %bpl,%bpl
  8d6897:	0f 84 56 01 00 00    	je     8d69f3 <efi_exit_boot_services+0x1b4>
  8d689d:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d68a1:	48 83 ec 20          	sub    $0x20,%rsp
  8d68a5:	ff 50 48             	callq  *0x48(%rax)
  8d68a8:	e9 40 01 00 00       	jmpq   8d69ed <efi_exit_boot_services+0x1ae>
  8d68ad:	80 3d b6 59 00 00 00 	cmpb   $0x0,0x59b6(%rip)        # 8dc26a <efi_disable_pci_dma>
  8d68b4:	74 05                	je     8d68bb <efi_exit_boot_services+0x7c>
  8d68b6:	e8 64 1f 00 00       	callq  8d881f <efi_pci_disable_bridge_busmaster>
  8d68bb:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8d68bf:	48 8b 10             	mov    (%rax),%rdx
  8d68c2:	48 8b 05 37 d3 01 00 	mov    0x1d337(%rip),%rax        # 8f3c00 <efi_system_table>
  8d68c9:	40 84 ed             	test   %bpl,%bpl
  8d68cc:	74 1a                	je     8d68e8 <efi_exit_boot_services+0xa9>
  8d68ce:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d68d2:	48 83 ec 20          	sub    $0x20,%rsp
  8d68d6:	4c 89 e9             	mov    %r13,%rcx
  8d68d9:	ff 90 e8 00 00 00    	callq  *0xe8(%rax)
  8d68df:	49 89 c4             	mov    %rax,%r12
  8d68e2:	48 83 c4 20          	add    $0x20,%rsp
  8d68e6:	eb 16                	jmp    8d68fe <efi_exit_boot_services+0xbf>
  8d68e8:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d68eb:	4c 89 ee             	mov    %r13,%rsi
  8d68ee:	8b b8 80 00 00 00    	mov    0x80(%rax),%edi
  8d68f4:	31 c0                	xor    %eax,%eax
  8d68f6:	e8 85 e4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d68fb:	49 89 c4             	mov    %rax,%r12
  8d68fe:	48 b8 02 00 00 00 00 	movabs $0x8000000000000002,%rax
  8d6905:	00 00 80 
  8d6908:	49 39 c4             	cmp    %rax,%r12
  8d690b:	0f 85 f2 00 00 00    	jne    8d6a03 <efi_exit_boot_services+0x1c4>
  8d6911:	48 8b 53 28          	mov    0x28(%rbx),%rdx
  8d6915:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d6919:	40 84 ed             	test   %bpl,%bpl
  8d691c:	48 8b 12             	mov    (%rdx),%rdx
  8d691f:	48 89 10             	mov    %rdx,(%rax)
  8d6922:	4c 8b 43 10          	mov    0x10(%rbx),%r8
  8d6926:	74 30                	je     8d6958 <efi_exit_boot_services+0x119>
  8d6928:	48 8b 05 d1 d2 01 00 	mov    0x1d2d1(%rip),%rax        # 8f3c00 <efi_system_table>
  8d692f:	48 8b 13             	mov    (%rbx),%rdx
  8d6932:	56                   	push   %rsi
  8d6933:	4d 89 c1             	mov    %r8,%r9
  8d6936:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  8d693a:	4c 8b 43 20          	mov    0x20(%rbx),%r8
  8d693e:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6942:	ff 73 18             	pushq  0x18(%rbx)
  8d6945:	48 8b 12             	mov    (%rdx),%rdx
  8d6948:	48 83 ec 20          	sub    $0x20,%rsp
  8d694c:	ff 50 38             	callq  *0x38(%rax)
  8d694f:	49 89 c4             	mov    %rax,%r12
  8d6952:	48 83 c4 30          	add    $0x30,%rsp
  8d6956:	eb 38                	jmp    8d6990 <efi_exit_boot_services+0x151>
  8d6958:	4c 8b 4b 18          	mov    0x18(%rbx),%r9
  8d695c:	41 c7 40 04 00 00 00 	movl   $0x0,0x4(%r8)
  8d6963:	00 
  8d6964:	48 8b 4b 20          	mov    0x20(%rbx),%rcx
  8d6968:	c7 41 04 00 00 00 00 	movl   $0x0,0x4(%rcx)
  8d696f:	48 8b 05 8a d2 01 00 	mov    0x1d28a(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6976:	48 8b 13             	mov    (%rbx),%rdx
  8d6979:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  8d697d:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6980:	48 8b 12             	mov    (%rdx),%rdx
  8d6983:	8b 78 28             	mov    0x28(%rax),%edi
  8d6986:	31 c0                	xor    %eax,%eax
  8d6988:	e8 f3 e3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d698d:	49 89 c4             	mov    %rax,%r12
  8d6990:	4d 85 e4             	test   %r12,%r12
  8d6993:	75 6e                	jne    8d6a03 <efi_exit_boot_services+0x1c4>
  8d6995:	4c 89 fe             	mov    %r15,%rsi
  8d6998:	48 89 df             	mov    %rbx,%rdi
  8d699b:	41 ff d6             	callq  *%r14
  8d699e:	49 89 c4             	mov    %rax,%r12
  8d69a1:	48 85 c0             	test   %rax,%rax
  8d69a4:	75 5d                	jne    8d6a03 <efi_exit_boot_services+0x1c4>
  8d69a6:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8d69aa:	48 8b 10             	mov    (%rax),%rdx
  8d69ad:	48 8b 05 4c d2 01 00 	mov    0x1d24c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d69b4:	40 84 ed             	test   %bpl,%bpl
  8d69b7:	74 16                	je     8d69cf <efi_exit_boot_services+0x190>
  8d69b9:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d69bd:	48 83 ec 20          	sub    $0x20,%rsp
  8d69c1:	4c 89 e9             	mov    %r13,%rcx
  8d69c4:	ff 90 e8 00 00 00    	callq  *0xe8(%rax)
  8d69ca:	49 89 c4             	mov    %rax,%r12
  8d69cd:	eb 1e                	jmp    8d69ed <efi_exit_boot_services+0x1ae>
  8d69cf:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d69d2:	4c 89 ee             	mov    %r13,%rsi
  8d69d5:	8b b8 80 00 00 00    	mov    0x80(%rax),%edi
  8d69db:	59                   	pop    %rcx
  8d69dc:	31 c0                	xor    %eax,%eax
  8d69de:	5b                   	pop    %rbx
  8d69df:	5d                   	pop    %rbp
  8d69e0:	41 5c                	pop    %r12
  8d69e2:	41 5d                	pop    %r13
  8d69e4:	41 5e                	pop    %r14
  8d69e6:	41 5f                	pop    %r15
  8d69e8:	e9 93 e3 ff ff       	jmpq   8d4d80 <__efi64_thunk>
  8d69ed:	48 83 c4 20          	add    $0x20,%rsp
  8d69f1:	eb 10                	jmp    8d6a03 <efi_exit_boot_services+0x1c4>
  8d69f3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d69f6:	48 89 ce             	mov    %rcx,%rsi
  8d69f9:	8b 78 30             	mov    0x30(%rax),%edi
  8d69fc:	31 c0                	xor    %eax,%eax
  8d69fe:	e8 7d e3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6a03:	5a                   	pop    %rdx
  8d6a04:	4c 89 e0             	mov    %r12,%rax
  8d6a07:	5b                   	pop    %rbx
  8d6a08:	5d                   	pop    %rbp
  8d6a09:	41 5c                	pop    %r12
  8d6a0b:	41 5d                	pop    %r13
  8d6a0d:	41 5e                	pop    %r14
  8d6a0f:	41 5f                	pop    %r15
  8d6a11:	c3                   	retq   

00000000008d6a12 <get_efi_config_table>:
  8d6a12:	f3 0f 1e fa          	endbr64 
  8d6a16:	41 57                	push   %r15
  8d6a18:	49 89 f7             	mov    %rsi,%r15
  8d6a1b:	41 56                	push   %r14
  8d6a1d:	49 89 fe             	mov    %rdi,%r14
  8d6a20:	41 55                	push   %r13
  8d6a22:	41 54                	push   %r12
  8d6a24:	55                   	push   %rbp
  8d6a25:	53                   	push   %rbx
  8d6a26:	48 83 ec 38          	sub    $0x38,%rsp
  8d6a2a:	80 3d df 57 00 00 00 	cmpb   $0x0,0x57df(%rip)        # 8dc210 <efi_is64>
  8d6a31:	48 8b 05 c8 d1 01 00 	mov    0x1d1c8(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6a38:	74 0a                	je     8d6a44 <get_efi_config_table+0x32>
  8d6a3a:	48 8b 58 70          	mov    0x70(%rax),%rbx
  8d6a3e:	44 8b 68 68          	mov    0x68(%rax),%r13d
  8d6a42:	eb 07                	jmp    8d6a4b <get_efi_config_table+0x39>
  8d6a44:	8b 58 44             	mov    0x44(%rax),%ebx
  8d6a47:	44 8b 68 40          	mov    0x40(%rax),%r13d
  8d6a4b:	80 3d be 57 00 00 01 	cmpb   $0x1,0x57be(%rip)        # 8dc210 <efi_is64>
  8d6a52:	48 8d 74 24 20       	lea    0x20(%rsp),%rsi
  8d6a57:	48 19 ed             	sbb    %rbp,%rbp
  8d6a5a:	45 31 e4             	xor    %r12d,%r12d
  8d6a5d:	48 83 e5 fc          	and    $0xfffffffffffffffc,%rbp
  8d6a61:	48 83 c5 18          	add    $0x18,%rbp
  8d6a65:	45 39 ec             	cmp    %r13d,%r12d
  8d6a68:	7d 54                	jge    8d6abe <get_efi_config_table+0xac>
  8d6a6a:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d6a6e:	48 8b 03             	mov    (%rbx),%rax
  8d6a71:	48 8d 7c 24 10       	lea    0x10(%rsp),%rdi
  8d6a76:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8d6a7b:	4c 89 74 24 20       	mov    %r14,0x20(%rsp)
  8d6a80:	48 89 54 24 18       	mov    %rdx,0x18(%rsp)
  8d6a85:	ba 10 00 00 00       	mov    $0x10,%edx
  8d6a8a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d6a8f:	4c 89 7c 24 28       	mov    %r15,0x28(%rsp)
  8d6a94:	e8 97 c2 ff ff       	callq  8d2d30 <memcmp>
  8d6a99:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d6a9e:	85 c0                	test   %eax,%eax
  8d6aa0:	75 14                	jne    8d6ab6 <get_efi_config_table+0xa4>
  8d6aa2:	80 3d 67 57 00 00 00 	cmpb   $0x0,0x5767(%rip)        # 8dc210 <efi_is64>
  8d6aa9:	74 06                	je     8d6ab1 <get_efi_config_table+0x9f>
  8d6aab:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8d6aaf:	eb 0f                	jmp    8d6ac0 <get_efi_config_table+0xae>
  8d6ab1:	8b 43 10             	mov    0x10(%rbx),%eax
  8d6ab4:	eb 0a                	jmp    8d6ac0 <get_efi_config_table+0xae>
  8d6ab6:	48 01 eb             	add    %rbp,%rbx
  8d6ab9:	41 ff c4             	inc    %r12d
  8d6abc:	eb a7                	jmp    8d6a65 <get_efi_config_table+0x53>
  8d6abe:	31 c0                	xor    %eax,%eax
  8d6ac0:	48 83 c4 38          	add    $0x38,%rsp
  8d6ac4:	5b                   	pop    %rbx
  8d6ac5:	5d                   	pop    %rbp
  8d6ac6:	41 5c                	pop    %r12
  8d6ac8:	41 5d                	pop    %r13
  8d6aca:	41 5e                	pop    %r14
  8d6acc:	41 5f                	pop    %r15
  8d6ace:	c3                   	retq   

00000000008d6acf <efi_load_initrd>:
  8d6acf:	f3 0f 1e fa          	endbr64 
  8d6ad3:	41 57                	push   %r15
  8d6ad5:	41 56                	push   %r14
  8d6ad7:	41 55                	push   %r13
  8d6ad9:	41 54                	push   %r12
  8d6adb:	55                   	push   %rbp
  8d6adc:	53                   	push   %rbx
  8d6add:	48 83 ec 58          	sub    $0x58,%rsp
  8d6ae1:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d6ae6:	48 85 f6             	test   %rsi,%rsi
  8d6ae9:	0f 84 1a 02 00 00    	je     8d6d09 <efi_load_initrd+0x23a>
  8d6aef:	48 89 d3             	mov    %rdx,%rbx
  8d6af2:	48 85 d2             	test   %rdx,%rdx
  8d6af5:	0f 84 0e 02 00 00    	je     8d6d09 <efi_load_initrd+0x23a>
  8d6afb:	80 3d 0e 57 00 00 00 	cmpb   $0x0,0x570e(%rip)        # 8dc210 <efi_is64>
  8d6b02:	4d 89 c5             	mov    %r8,%r13
  8d6b05:	49 89 fc             	mov    %rdi,%r12
  8d6b08:	48 89 f5             	mov    %rsi,%rbp
  8d6b0b:	48 b8 c1 c0 06 40 b3 	movabs $0x403efcb34006c0c1,%rax
  8d6b12:	fc 3e 40 
  8d6b15:	4c 8d 44 24 38       	lea    0x38(%rsp),%r8
  8d6b1a:	48 8d 54 24 18       	lea    0x18(%rsp),%rdx
  8d6b1f:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8d6b24:	4c 8d 7c 24 40       	lea    0x40(%rsp),%r15
  8d6b29:	48 b8 99 6d 4a 6c 87 	movabs $0x6de024876c4a6d99,%rax
  8d6b30:	24 e0 6d 
  8d6b33:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8d6b38:	48 8d 05 31 44 00 00 	lea    0x4431(%rip),%rax        # 8daf70 <initrd_dev_path>
  8d6b3f:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d6b44:	48 8b 05 b5 d0 01 00 	mov    0x1d0b5(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6b4b:	74 22                	je     8d6b6f <efi_load_initrd+0xa0>
  8d6b4d:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6b51:	48 83 ec 20          	sub    $0x20,%rsp
  8d6b55:	4c 89 f9             	mov    %r15,%rcx
  8d6b58:	ff 90 b8 00 00 00    	callq  *0xb8(%rax)
  8d6b5e:	49 89 c6             	mov    %rax,%r14
  8d6b61:	48 83 c4 20          	add    $0x20,%rsp
  8d6b65:	48 85 c0             	test   %rax,%rax
  8d6b68:	74 2d                	je     8d6b97 <efi_load_initrd+0xc8>
  8d6b6a:	e9 a9 01 00 00       	jmpq   8d6d18 <efi_load_initrd+0x249>
  8d6b6f:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6b72:	4c 89 c1             	mov    %r8,%rcx
  8d6b75:	4c 89 fe             	mov    %r15,%rsi
  8d6b78:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%rsp)
  8d6b7f:	00 
  8d6b80:	8b 78 68             	mov    0x68(%rax),%edi
  8d6b83:	31 c0                	xor    %eax,%eax
  8d6b85:	e8 f6 e1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6b8a:	49 89 c6             	mov    %rax,%r14
  8d6b8d:	48 85 c0             	test   %rax,%rax
  8d6b90:	74 5b                	je     8d6bed <efi_load_initrd+0x11e>
  8d6b92:	e9 f5 01 00 00       	jmpq   8d6d8c <efi_load_initrd+0x2bd>
  8d6b97:	48 8b 05 62 d0 01 00 	mov    0x1d062(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6b9e:	48 83 ec 20          	sub    $0x20,%rsp
  8d6ba2:	4c 89 fa             	mov    %r15,%rdx
  8d6ba5:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
  8d6baa:	4c 8d 44 24 40       	lea    0x40(%rsp),%r8
  8d6baf:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6bb3:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d6bb9:	49 89 c6             	mov    %rax,%r14
  8d6bbc:	48 83 c4 20          	add    $0x20,%rsp
  8d6bc0:	48 85 c0             	test   %rax,%rax
  8d6bc3:	0f 85 4f 01 00 00    	jne    8d6d18 <efi_load_initrd+0x249>
  8d6bc9:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8d6bce:	57                   	push   %rdi
  8d6bcf:	45 31 c0             	xor    %r8d,%r8d
  8d6bd2:	6a 00                	pushq  $0x0
  8d6bd4:	48 89 c1             	mov    %rax,%rcx
  8d6bd7:	48 83 ec 20          	sub    $0x20,%rsp
  8d6bdb:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8d6be0:	4c 8d 4c 24 60       	lea    0x60(%rsp),%r9
  8d6be5:	ff 10                	callq  *(%rax)
  8d6be7:	48 83 c4 30          	add    $0x30,%rsp
  8d6beb:	eb 5d                	jmp    8d6c4a <efi_load_initrd+0x17b>
  8d6bed:	48 8b 05 0c d0 01 00 	mov    0x1d00c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6bf4:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8d6bf9:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  8d6bfe:	4c 89 fa             	mov    %r15,%rdx
  8d6c01:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%rsp)
  8d6c08:	00 
  8d6c09:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6c0c:	8b 78 58             	mov    0x58(%rax),%edi
  8d6c0f:	31 c0                	xor    %eax,%eax
  8d6c11:	e8 6a e1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6c16:	49 89 c6             	mov    %rax,%r14
  8d6c19:	48 85 c0             	test   %rax,%rax
  8d6c1c:	0f 85 6a 01 00 00    	jne    8d6d8c <efi_load_initrd+0x2bd>
  8d6c22:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8d6c27:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d6c2c:	45 31 c9             	xor    %r9d,%r9d
  8d6c2f:	31 c9                	xor    %ecx,%ecx
  8d6c31:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%rsp)
  8d6c38:	00 
  8d6c39:	4c 8d 44 24 30       	lea    0x30(%rsp),%r8
  8d6c3e:	8b 38                	mov    (%rax),%edi
  8d6c40:	48 89 c6             	mov    %rax,%rsi
  8d6c43:	31 c0                	xor    %eax,%eax
  8d6c45:	e8 36 e1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6c4a:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d6c51:	00 00 80 
  8d6c54:	48 39 d0             	cmp    %rdx,%rax
  8d6c57:	0f 85 83 00 00 00    	jne    8d6ce0 <efi_load_initrd+0x211>
  8d6c5d:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d6c62:	48 8d 74 24 28       	lea    0x28(%rsp),%rsi
  8d6c67:	4c 89 ea             	mov    %r13,%rdx
  8d6c6a:	e8 d6 1a 00 00       	callq  8d8745 <efi_allocate_pages>
  8d6c6f:	49 89 c6             	mov    %rax,%r14
  8d6c72:	48 85 c0             	test   %rax,%rax
  8d6c75:	0f 85 9d 00 00 00    	jne    8d6d18 <efi_load_initrd+0x249>
  8d6c7b:	4c 8b 4c 24 28       	mov    0x28(%rsp),%r9
  8d6c80:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d6c85:	4c 8d 44 24 30       	lea    0x30(%rsp),%r8
  8d6c8a:	80 3d 7f 55 00 00 00 	cmpb   $0x0,0x557f(%rip)        # 8dc210 <efi_is64>
  8d6c91:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
  8d6c96:	74 1b                	je     8d6cb3 <efi_load_initrd+0x1e4>
  8d6c98:	56                   	push   %rsi
  8d6c99:	48 89 c1             	mov    %rax,%rcx
  8d6c9c:	41 51                	push   %r9
  8d6c9e:	4d 89 c1             	mov    %r8,%r9
  8d6ca1:	45 31 c0             	xor    %r8d,%r8d
  8d6ca4:	48 83 ec 20          	sub    $0x20,%rsp
  8d6ca8:	ff 10                	callq  *(%rax)
  8d6caa:	49 89 c6             	mov    %rax,%r14
  8d6cad:	48 83 c4 30          	add    $0x30,%rsp
  8d6cb1:	eb 19                	jmp    8d6ccc <efi_load_initrd+0x1fd>
  8d6cb3:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%rsp)
  8d6cba:	00 
  8d6cbb:	8b 38                	mov    (%rax),%edi
  8d6cbd:	48 89 c6             	mov    %rax,%rsi
  8d6cc0:	31 c9                	xor    %ecx,%ecx
  8d6cc2:	31 c0                	xor    %eax,%eax
  8d6cc4:	e8 b7 e0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6cc9:	49 89 c6             	mov    %rax,%r14
  8d6ccc:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8d6cd1:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d6cd6:	4d 85 f6             	test   %r14,%r14
  8d6cd9:	74 14                	je     8d6cef <efi_load_initrd+0x220>
  8d6cdb:	e8 ee 1a 00 00       	callq  8d87ce <efi_free>
  8d6ce0:	49 be 01 00 00 00 00 	movabs $0x8000000000000001,%r14
  8d6ce7:	00 00 80 
  8d6cea:	e9 ac 00 00 00       	jmpq   8d6d9b <efi_load_initrd+0x2cc>
  8d6cef:	48 89 75 00          	mov    %rsi,0x0(%rbp)
  8d6cf3:	31 c0                	xor    %eax,%eax
  8d6cf5:	48 89 3b             	mov    %rdi,(%rbx)
  8d6cf8:	48 8d 3d 53 4e 00 00 	lea    0x4e53(%rip),%rdi        # 8dbb52 <kernel_info_end+0x9c2>
  8d6cff:	e8 c8 f4 ff ff       	callq  8d61cc <efi_printk>
  8d6d04:	e9 92 00 00 00       	jmpq   8d6d9b <efi_load_initrd+0x2cc>
  8d6d09:	49 be 02 00 00 00 00 	movabs $0x8000000000000002,%r14
  8d6d10:	00 00 80 
  8d6d13:	e9 83 00 00 00       	jmpq   8d6d9b <efi_load_initrd+0x2cc>
  8d6d18:	48 b8 0e 00 00 00 00 	movabs $0x800000000000000e,%rax
  8d6d1f:	00 00 80 
  8d6d22:	49 39 c6             	cmp    %rax,%r14
  8d6d25:	75 74                	jne    8d6d9b <efi_load_initrd+0x2cc>
  8d6d27:	80 3d e2 54 00 00 01 	cmpb   $0x1,0x54e2(%rip)        # 8dc210 <efi_is64>
  8d6d2e:	75 05                	jne    8d6d35 <efi_load_initrd+0x266>
  8d6d30:	4d 85 e4             	test   %r12,%r12
  8d6d33:	75 11                	jne    8d6d46 <efi_load_initrd+0x277>
  8d6d35:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
  8d6d3c:	48 c7 45 00 00 00 00 	movq   $0x0,0x0(%rbp)
  8d6d43:	00 
  8d6d44:	eb 2b                	jmp    8d6d71 <efi_load_initrd+0x2a2>
  8d6d46:	50                   	push   %rax
  8d6d47:	ba 0e 00 00 00       	mov    $0xe,%edx
  8d6d4c:	49 89 e9             	mov    %rbp,%r9
  8d6d4f:	4d 89 e8             	mov    %r13,%r8
  8d6d52:	53                   	push   %rbx
  8d6d53:	48 8b 4c 24 18       	mov    0x18(%rsp),%rcx
  8d6d58:	48 8d 35 5b 4e 00 00 	lea    0x4e5b(%rip),%rsi        # 8dbbba <kernel_info_end+0xa2a>
  8d6d5f:	4c 89 e7             	mov    %r12,%rdi
  8d6d62:	e8 5d 02 00 00       	callq  8d6fc4 <handle_cmdline_files>
  8d6d67:	5a                   	pop    %rdx
  8d6d68:	59                   	pop    %rcx
  8d6d69:	49 89 c6             	mov    %rax,%r14
  8d6d6c:	48 85 c0             	test   %rax,%rax
  8d6d6f:	75 2a                	jne    8d6d9b <efi_load_initrd+0x2cc>
  8d6d71:	4c 8b 33             	mov    (%rbx),%r14
  8d6d74:	4d 85 f6             	test   %r14,%r14
  8d6d77:	74 22                	je     8d6d9b <efi_load_initrd+0x2cc>
  8d6d79:	48 8d 3d 10 4e 00 00 	lea    0x4e10(%rip),%rdi        # 8dbb90 <kernel_info_end+0xa00>
  8d6d80:	31 c0                	xor    %eax,%eax
  8d6d82:	45 31 f6             	xor    %r14d,%r14d
  8d6d85:	e8 42 f4 ff ff       	callq  8d61cc <efi_printk>
  8d6d8a:	eb 0f                	jmp    8d6d9b <efi_load_initrd+0x2cc>
  8d6d8c:	48 b8 0e 00 00 00 00 	movabs $0x800000000000000e,%rax
  8d6d93:	00 00 80 
  8d6d96:	49 39 c6             	cmp    %rax,%r14
  8d6d99:	74 9a                	je     8d6d35 <efi_load_initrd+0x266>
  8d6d9b:	48 83 c4 58          	add    $0x58,%rsp
  8d6d9f:	4c 89 f0             	mov    %r14,%rax
  8d6da2:	5b                   	pop    %rbx
  8d6da3:	5d                   	pop    %rbp
  8d6da4:	41 5c                	pop    %r12
  8d6da6:	41 5d                	pop    %r13
  8d6da8:	41 5e                	pop    %r14
  8d6daa:	41 5f                	pop    %r15
  8d6dac:	c3                   	retq   

00000000008d6dad <efi_wait_for_key>:
  8d6dad:	f3 0f 1e fa          	endbr64 
  8d6db1:	41 56                	push   %r14
  8d6db3:	49 89 f6             	mov    %rsi,%r14
  8d6db6:	41 55                	push   %r13
  8d6db8:	41 54                	push   %r12
  8d6dba:	55                   	push   %rbp
  8d6dbb:	53                   	push   %rbx
  8d6dbc:	48 89 fb             	mov    %rdi,%rbx
  8d6dbf:	48 83 ec 20          	sub    $0x20,%rsp
  8d6dc3:	44 8a 2d 46 54 00 00 	mov    0x5446(%rip),%r13b        # 8dc210 <efi_is64>
  8d6dca:	48 8b 05 2f ce 01 00 	mov    0x1ce2f(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6dd1:	45 84 ed             	test   %r13b,%r13b
  8d6dd4:	74 18                	je     8d6dee <efi_wait_for_key+0x41>
  8d6dd6:	49 bc 03 00 00 00 00 	movabs $0x8000000000000003,%r12
  8d6ddd:	00 00 80 
  8d6de0:	48 8b 68 30          	mov    0x30(%rax),%rbp
  8d6de4:	48 85 ed             	test   %rbp,%rbp
  8d6de7:	75 1b                	jne    8d6e04 <efi_wait_for_key+0x57>
  8d6de9:	e9 c6 01 00 00       	jmpq   8d6fb4 <efi_wait_for_key+0x207>
  8d6dee:	49 bc 03 00 00 00 00 	movabs $0x8000000000000003,%r12
  8d6df5:	00 00 80 
  8d6df8:	8b 68 24             	mov    0x24(%rax),%ebp
  8d6dfb:	85 ed                	test   %ebp,%ebp
  8d6dfd:	75 66                	jne    8d6e65 <efi_wait_for_key+0xb8>
  8d6dff:	e9 b0 01 00 00       	jmpq   8d6fb4 <efi_wait_for_key+0x207>
  8d6e04:	48 8b 55 10          	mov    0x10(%rbp),%rdx
  8d6e08:	45 31 c9             	xor    %r9d,%r9d
  8d6e0b:	45 31 c0             	xor    %r8d,%r8d
  8d6e0e:	b9 00 00 00 80       	mov    $0x80000000,%ecx
  8d6e13:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
  8d6e18:	52                   	push   %rdx
  8d6e19:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6e1d:	48 8d 54 24 08       	lea    0x8(%rsp),%rdx
  8d6e22:	52                   	push   %rdx
  8d6e23:	31 d2                	xor    %edx,%edx
  8d6e25:	48 83 ec 20          	sub    $0x20,%rsp
  8d6e29:	ff 50 50             	callq  *0x50(%rax)
  8d6e2c:	49 89 c4             	mov    %rax,%r12
  8d6e2f:	48 83 c4 30          	add    $0x30,%rsp
  8d6e33:	48 85 c0             	test   %rax,%rax
  8d6e36:	0f 85 78 01 00 00    	jne    8d6fb4 <efi_wait_for_key+0x207>
  8d6e3c:	48 8b 05 bd cd 01 00 	mov    0x1cdbd(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6e43:	48 83 ec 20          	sub    $0x20,%rsp
  8d6e47:	4c 6b c3 0a          	imul   $0xa,%rbx,%r8
  8d6e4b:	ba 02 00 00 00       	mov    $0x2,%edx
  8d6e50:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8d6e55:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6e59:	ff 50 58             	callq  *0x58(%rax)
  8d6e5c:	49 89 c4             	mov    %rax,%r12
  8d6e5f:	48 83 c4 20          	add    $0x20,%rsp
  8d6e63:	eb 62                	jmp    8d6ec7 <efi_wait_for_key+0x11a>
  8d6e65:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6e68:	8b 55 08             	mov    0x8(%rbp),%edx
  8d6e6b:	49 89 e1             	mov    %rsp,%r9
  8d6e6e:	45 31 c0             	xor    %r8d,%r8d
  8d6e71:	31 c9                	xor    %ecx,%ecx
  8d6e73:	be 00 00 00 80       	mov    $0x80000000,%esi
  8d6e78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%rsp)
  8d6e7f:	00 
  8d6e80:	8b 78 34             	mov    0x34(%rax),%edi
  8d6e83:	89 54 24 10          	mov    %edx,0x10(%rsp)
  8d6e87:	31 c0                	xor    %eax,%eax
  8d6e89:	31 d2                	xor    %edx,%edx
  8d6e8b:	e8 f0 de ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6e90:	49 89 c4             	mov    %rax,%r12
  8d6e93:	48 85 c0             	test   %rax,%rax
  8d6e96:	0f 85 18 01 00 00    	jne    8d6fb4 <efi_wait_for_key+0x207>
  8d6e9c:	48 8b 05 5d cd 01 00 	mov    0x1cd5d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6ea3:	6b cb 0a             	imul   $0xa,%ebx,%ecx
  8d6ea6:	48 8b 34 24          	mov    (%rsp),%rsi
  8d6eaa:	ba 02 00 00 00       	mov    $0x2,%edx
  8d6eaf:	4c 6b c3 0a          	imul   $0xa,%rbx,%r8
  8d6eb3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6eb6:	8b 78 38             	mov    0x38(%rax),%edi
  8d6eb9:	49 c1 e8 20          	shr    $0x20,%r8
  8d6ebd:	31 c0                	xor    %eax,%eax
  8d6ebf:	e8 bc de ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6ec4:	49 89 c4             	mov    %rax,%r12
  8d6ec7:	4d 85 e4             	test   %r12,%r12
  8d6eca:	0f 85 e4 00 00 00    	jne    8d6fb4 <efi_wait_for_key+0x207>
  8d6ed0:	45 84 ed             	test   %r13b,%r13b
  8d6ed3:	48 8b 0c 24          	mov    (%rsp),%rcx
  8d6ed7:	4c 8d 44 24 08       	lea    0x8(%rsp),%r8
  8d6edc:	48 8b 05 1d cd 01 00 	mov    0x1cd1d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6ee3:	48 8d 54 24 10       	lea    0x10(%rsp),%rdx
  8d6ee8:	74 2b                	je     8d6f15 <efi_wait_for_key+0x168>
  8d6eea:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6eee:	48 89 4c 24 18       	mov    %rcx,0x18(%rsp)
  8d6ef3:	48 83 ec 20          	sub    $0x20,%rsp
  8d6ef7:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d6efc:	ff 50 60             	callq  *0x60(%rax)
  8d6eff:	49 89 c4             	mov    %rax,%r12
  8d6f02:	48 83 c4 20          	add    $0x20,%rsp
  8d6f06:	48 85 c0             	test   %rax,%rax
  8d6f09:	75 74                	jne    8d6f7f <efi_wait_for_key+0x1d2>
  8d6f0b:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  8d6f11:	74 2d                	je     8d6f40 <efi_wait_for_key+0x193>
  8d6f13:	eb 5b                	jmp    8d6f70 <efi_wait_for_key+0x1c3>
  8d6f15:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6f18:	89 4c 24 14          	mov    %ecx,0x14(%rsp)
  8d6f1c:	be 02 00 00 00       	mov    $0x2,%esi
  8d6f21:	4c 89 c1             	mov    %r8,%rcx
  8d6f24:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%rsp)
  8d6f2b:	00 
  8d6f2c:	8b 78 3c             	mov    0x3c(%rax),%edi
  8d6f2f:	31 c0                	xor    %eax,%eax
  8d6f31:	e8 4a de ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6f36:	49 89 c4             	mov    %rax,%r12
  8d6f39:	48 85 c0             	test   %rax,%rax
  8d6f3c:	74 cd                	je     8d6f0b <efi_wait_for_key+0x15e>
  8d6f3e:	eb 5c                	jmp    8d6f9c <efi_wait_for_key+0x1ef>
  8d6f40:	45 84 ed             	test   %r13b,%r13b
  8d6f43:	74 16                	je     8d6f5b <efi_wait_for_key+0x1ae>
  8d6f45:	48 83 ec 20          	sub    $0x20,%rsp
  8d6f49:	4c 89 f2             	mov    %r14,%rdx
  8d6f4c:	48 89 e9             	mov    %rbp,%rcx
  8d6f4f:	ff 55 08             	callq  *0x8(%rbp)
  8d6f52:	49 89 c4             	mov    %rax,%r12
  8d6f55:	48 83 c4 20          	add    $0x20,%rsp
  8d6f59:	eb 24                	jmp    8d6f7f <efi_wait_for_key+0x1d2>
  8d6f5b:	8b 7d 04             	mov    0x4(%rbp),%edi
  8d6f5e:	4c 89 f2             	mov    %r14,%rdx
  8d6f61:	48 89 ee             	mov    %rbp,%rsi
  8d6f64:	31 c0                	xor    %eax,%eax
  8d6f66:	e8 15 de ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6f6b:	49 89 c4             	mov    %rax,%r12
  8d6f6e:	eb 2c                	jmp    8d6f9c <efi_wait_for_key+0x1ef>
  8d6f70:	49 bc 12 00 00 00 00 	movabs $0x8000000000000012,%r12
  8d6f77:	00 00 80 
  8d6f7a:	45 84 ed             	test   %r13b,%r13b
  8d6f7d:	74 1d                	je     8d6f9c <efi_wait_for_key+0x1ef>
  8d6f7f:	48 8b 05 7a cc 01 00 	mov    0x1cc7a(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6f86:	48 83 ec 20          	sub    $0x20,%rsp
  8d6f8a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8d6f8f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d6f93:	ff 50 70             	callq  *0x70(%rax)
  8d6f96:	48 83 c4 20          	add    $0x20,%rsp
  8d6f9a:	eb 18                	jmp    8d6fb4 <efi_wait_for_key+0x207>
  8d6f9c:	48 8b 05 5d cc 01 00 	mov    0x1cc5d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d6fa3:	48 8b 34 24          	mov    (%rsp),%rsi
  8d6fa7:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d6faa:	8b 78 44             	mov    0x44(%rax),%edi
  8d6fad:	31 c0                	xor    %eax,%eax
  8d6faf:	e8 cc dd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d6fb4:	48 83 c4 20          	add    $0x20,%rsp
  8d6fb8:	4c 89 e0             	mov    %r12,%rax
  8d6fbb:	5b                   	pop    %rbx
  8d6fbc:	5d                   	pop    %rbp
  8d6fbd:	41 5c                	pop    %r12
  8d6fbf:	41 5d                	pop    %r13
  8d6fc1:	41 5e                	pop    %r14
  8d6fc3:	c3                   	retq   

00000000008d6fc4 <handle_cmdline_files>:
  8d6fc4:	f3 0f 1e fa          	endbr64 
  8d6fc8:	41 57                	push   %r15
  8d6fca:	41 56                	push   %r14
  8d6fcc:	41 55                	push   %r13
  8d6fce:	41 54                	push   %r12
  8d6fd0:	55                   	push   %rbp
  8d6fd1:	53                   	push   %rbx
  8d6fd2:	48 81 ec e8 02 00 00 	sub    $0x2e8,%rsp
  8d6fd9:	48 8b 47 38          	mov    0x38(%rdi),%rax
  8d6fdd:	48 89 7c 24 18       	mov    %rdi,0x18(%rsp)
  8d6fe2:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  8d6fe7:	8b 47 30             	mov    0x30(%rdi),%eax
  8d6fea:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
  8d6fef:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
  8d6ff4:	4c 89 44 24 28       	mov    %r8,0x28(%rsp)
  8d6ff9:	4c 89 4c 24 30       	mov    %r9,0x30(%rsp)
  8d6ffe:	89 44 24 54          	mov    %eax,0x54(%rsp)
  8d7002:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  8d7009:	00 00 
  8d700b:	4d 85 c9             	test   %r9,%r9
  8d700e:	0f 84 96 04 00 00    	je     8d74aa <handle_cmdline_files+0x4e6>
  8d7014:	48 83 bc 24 20 03 00 	cmpq   $0x0,0x320(%rsp)
  8d701b:	00 00 
  8d701d:	0f 84 87 04 00 00    	je     8d74aa <handle_cmdline_files+0x4e6>
  8d7023:	48 8d 74 24 54       	lea    0x54(%rsp),%rsi
  8d7028:	48 8d 7c 24 58       	lea    0x58(%rsp),%rdi
  8d702d:	89 d3                	mov    %edx,%ebx
  8d702f:	e8 62 f5 ff ff       	callq  8d6596 <efi_apply_loadoptions_quirk>
  8d7034:	48 63 44 24 54       	movslq 0x54(%rsp),%rax
  8d7039:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d703e:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  8d7045:	00 00 
  8d7047:	48 d1 e8             	shr    %rax
  8d704a:	80 3d b7 cb 01 00 01 	cmpb   $0x1,0x1cbb7(%rip)        # 8f3c08 <efi_nochunk>
  8d7051:	89 44 24 54          	mov    %eax,0x54(%rsp)
  8d7055:	48 19 c0             	sbb    %rax,%rax
  8d7058:	31 ed                	xor    %ebp,%ebp
  8d705a:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d705f:	89 d8                	mov    %ebx,%eax
  8d7061:	48 81 64 24 10 01 00 	andq   $0x100001,0x10(%rsp)
  8d7068:	10 00 
  8d706a:	99                   	cltd   
  8d706b:	f7 f9                	idiv   %ecx
  8d706d:	48 ff 4c 24 10       	decq   0x10(%rsp)
  8d7072:	89 44 24 44          	mov    %eax,0x44(%rsp)
  8d7076:	48 63 c3             	movslq %ebx,%rax
  8d7079:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8d707e:	4c 8b 6c 24 58       	mov    0x58(%rsp),%r13
  8d7083:	44 8b 64 24 54       	mov    0x54(%rsp),%r12d
  8d7088:	8b 5c 24 44          	mov    0x44(%rsp),%ebx
  8d708c:	4d 89 ee             	mov    %r13,%r14
  8d708f:	41 39 dc             	cmp    %ebx,%r12d
  8d7092:	0f 8e a1 03 00 00    	jle    8d7439 <handle_cmdline_files+0x475>
  8d7098:	48 8b 54 24 48       	mov    0x48(%rsp),%rdx
  8d709d:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8d70a2:	4c 89 f7             	mov    %r14,%rdi
  8d70a5:	49 83 c6 02          	add    $0x2,%r14
  8d70a9:	e8 82 bc ff ff       	callq  8d2d30 <memcmp>
  8d70ae:	85 c0                	test   %eax,%eax
  8d70b0:	75 05                	jne    8d70b7 <handle_cmdline_files+0xf3>
  8d70b2:	48 63 c3             	movslq %ebx,%rax
  8d70b5:	eb 15                	jmp    8d70cc <handle_cmdline_files+0x108>
  8d70b7:	ff c3                	inc    %ebx
  8d70b9:	eb d4                	jmp    8d708f <handle_cmdline_files+0xcb>
  8d70bb:	66 83 f9 5c          	cmp    $0x5c,%cx
  8d70bf:	75 1d                	jne    8d70de <handle_cmdline_files+0x11a>
  8d70c1:	48 ff c0             	inc    %rax
  8d70c4:	8d 56 01             	lea    0x1(%rsi),%edx
  8d70c7:	41 39 c4             	cmp    %eax,%r12d
  8d70ca:	7e 12                	jle    8d70de <handle_cmdline_files+0x11a>
  8d70cc:	66 41 8b 4c 45 00    	mov    0x0(%r13,%rax,2),%cx
  8d70d2:	89 c6                	mov    %eax,%esi
  8d70d4:	89 c2                	mov    %eax,%edx
  8d70d6:	66 83 f9 2f          	cmp    $0x2f,%cx
  8d70da:	75 df                	jne    8d70bb <handle_cmdline_files+0xf7>
  8d70dc:	eb e3                	jmp    8d70c1 <handle_cmdline_files+0xfd>
  8d70de:	48 63 c2             	movslq %edx,%rax
  8d70e1:	48 8d b4 24 e0 00 00 	lea    0xe0(%rsp),%rsi
  8d70e8:	00 
  8d70e9:	81 c2 ff 00 00 00    	add    $0xff,%edx
  8d70ef:	89 c1                	mov    %eax,%ecx
  8d70f1:	41 89 c6             	mov    %eax,%r14d
  8d70f4:	39 c2                	cmp    %eax,%edx
  8d70f6:	74 34                	je     8d712c <handle_cmdline_files+0x168>
  8d70f8:	41 39 c4             	cmp    %eax,%r12d
  8d70fb:	7e 2f                	jle    8d712c <handle_cmdline_files+0x168>
  8d70fd:	44 8d 71 01          	lea    0x1(%rcx),%r14d
  8d7101:	66 41 8b 4c 45 00    	mov    0x0(%r13,%rax,2),%cx
  8d7107:	66 f7 c1 df ff       	test   $0xffdf,%cx
  8d710c:	74 1e                	je     8d712c <handle_cmdline_files+0x168>
  8d710e:	66 83 f9 0a          	cmp    $0xa,%cx
  8d7112:	74 18                	je     8d712c <handle_cmdline_files+0x168>
  8d7114:	48 83 c6 02          	add    $0x2,%rsi
  8d7118:	66 83 f9 2f          	cmp    $0x2f,%cx
  8d711c:	75 05                	jne    8d7123 <handle_cmdline_files+0x15f>
  8d711e:	b9 5c 00 00 00       	mov    $0x5c,%ecx
  8d7123:	66 89 4e fe          	mov    %cx,-0x2(%rsi)
  8d7127:	48 ff c0             	inc    %rax
  8d712a:	eb c3                	jmp    8d70ef <handle_cmdline_files+0x12b>
  8d712c:	66 c7 06 00 00       	movw   $0x0,(%rsi)
  8d7131:	48 8b 54 24 60       	mov    0x60(%rsp),%rdx
  8d7136:	45 85 f6             	test   %r14d,%r14d
  8d7139:	0f 84 fa 02 00 00    	je     8d7439 <handle_cmdline_files+0x475>
  8d713f:	49 63 c6             	movslq %r14d,%rax
  8d7142:	44 29 74 24 54       	sub    %r14d,0x54(%rsp)
  8d7147:	48 01 c0             	add    %rax,%rax
  8d714a:	48 01 44 24 58       	add    %rax,0x58(%rsp)
  8d714f:	48 85 d2             	test   %rdx,%rdx
  8d7152:	0f 85 c0 00 00 00    	jne    8d7218 <handle_cmdline_files+0x254>
  8d7158:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  8d715d:	80 3d ac 50 00 00 00 	cmpb   $0x0,0x50ac(%rip)        # 8dc210 <efi_is64>
  8d7164:	4c 8d 44 24 78       	lea    0x78(%rsp),%r8
  8d7169:	48 8d 94 24 80 00 00 	lea    0x80(%rsp),%rdx
  8d7170:	00 
  8d7171:	48 8b 70 18          	mov    0x18(%rax),%rsi
  8d7175:	48 b8 22 5b 4e 96 59 	movabs $0x11d26459964e5b22,%rax
  8d717c:	64 d2 11 
  8d717f:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
  8d7186:	00 
  8d7187:	48 b8 8e 39 00 a0 c9 	movabs $0x3b7269c9a000398e,%rax
  8d718e:	69 72 3b 
  8d7191:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
  8d7198:	00 
  8d7199:	48 8b 05 60 ca 01 00 	mov    0x1ca60(%rip),%rax        # 8f3c00 <efi_system_table>
  8d71a0:	74 1a                	je     8d71bc <handle_cmdline_files+0x1f8>
  8d71a2:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d71a6:	48 83 ec 20          	sub    $0x20,%rsp
  8d71aa:	48 89 f1             	mov    %rsi,%rcx
  8d71ad:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d71b3:	49 89 c5             	mov    %rax,%r13
  8d71b6:	48 83 c4 20          	add    $0x20,%rsp
  8d71ba:	eb 1b                	jmp    8d71d7 <handle_cmdline_files+0x213>
  8d71bc:	c7 44 24 7c 00 00 00 	movl   $0x0,0x7c(%rsp)
  8d71c3:	00 
  8d71c4:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d71c7:	4c 89 c1             	mov    %r8,%rcx
  8d71ca:	8b 78 58             	mov    0x58(%rax),%edi
  8d71cd:	31 c0                	xor    %eax,%eax
  8d71cf:	e8 ac db ff ff       	callq  8d4d80 <__efi64_thunk>
  8d71d4:	49 89 c5             	mov    %rax,%r13
  8d71d7:	4d 85 ed             	test   %r13,%r13
  8d71da:	74 09                	je     8d71e5 <handle_cmdline_files+0x221>
  8d71dc:	48 8d 3d e7 49 00 00 	lea    0x49e7(%rip),%rdi        # 8dbbca <kernel_info_end+0xa3a>
  8d71e3:	eb 27                	jmp    8d720c <handle_cmdline_files+0x248>
  8d71e5:	48 8b 44 24 78       	mov    0x78(%rsp),%rax
  8d71ea:	48 8d 54 24 60       	lea    0x60(%rsp),%rdx
  8d71ef:	48 83 ec 20          	sub    $0x20,%rsp
  8d71f3:	48 89 c1             	mov    %rax,%rcx
  8d71f6:	ff 50 08             	callq  *0x8(%rax)
  8d71f9:	4c 63 e8             	movslq %eax,%r13
  8d71fc:	48 83 c4 20          	add    $0x20,%rsp
  8d7200:	4d 85 ed             	test   %r13,%r13
  8d7203:	74 13                	je     8d7218 <handle_cmdline_files+0x254>
  8d7205:	48 8d 3d e2 49 00 00 	lea    0x49e2(%rip),%rdi        # 8dbbee <kernel_info_end+0xa5e>
  8d720c:	31 c0                	xor    %eax,%eax
  8d720e:	e8 b9 ef ff ff       	callq  8d61cc <efi_printk>
  8d7213:	e9 9c 02 00 00       	jmpq   8d74b4 <handle_cmdline_files+0x4f0>
  8d7218:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d721d:	48 8d 54 24 70       	lea    0x70(%rsp),%rdx
  8d7222:	48 bb 92 6e 57 09 3f 	movabs $0x11d26d3f09576e92,%rbx
  8d7229:	6d d2 11 
  8d722c:	4c 8d a4 24 e0 00 00 	lea    0xe0(%rsp),%r12
  8d7233:	00 
  8d7234:	48 89 9c 24 80 00 00 	mov    %rbx,0x80(%rsp)
  8d723b:	00 
  8d723c:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d7242:	4d 89 e0             	mov    %r12,%r8
  8d7245:	48 bb 8e 39 00 a0 c9 	movabs $0x3b7269c9a000398e,%rbx
  8d724c:	69 72 3b 
  8d724f:	48 89 9c 24 88 00 00 	mov    %rbx,0x88(%rsp)
  8d7256:	00 
  8d7257:	48 8d 9c 24 90 00 00 	lea    0x90(%rsp),%rbx
  8d725e:	00 
  8d725f:	51                   	push   %rcx
  8d7260:	48 89 c1             	mov    %rax,%rcx
  8d7263:	6a 00                	pushq  $0x0
  8d7265:	48 83 ec 20          	sub    $0x20,%rsp
  8d7269:	ff 50 08             	callq  *0x8(%rax)
  8d726c:	49 89 c5             	mov    %rax,%r13
  8d726f:	48 83 c4 30          	add    $0x30,%rsp
  8d7273:	48 85 c0             	test   %rax,%rax
  8d7276:	74 16                	je     8d728e <handle_cmdline_files+0x2ca>
  8d7278:	4c 89 e6             	mov    %r12,%rsi
  8d727b:	48 8d 3d 8c 49 00 00 	lea    0x498c(%rip),%rdi        # 8dbc0e <kernel_info_end+0xa7e>
  8d7282:	31 c0                	xor    %eax,%eax
  8d7284:	e8 43 ef ff ff       	callq  8d61cc <efi_printk>
  8d7289:	e9 f7 01 00 00       	jmpq   8d7485 <handle_cmdline_files+0x4c1>
  8d728e:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8d7293:	48 8d 94 24 80 00 00 	lea    0x80(%rsp),%rdx
  8d729a:	00 
  8d729b:	48 83 ec 20          	sub    $0x20,%rsp
  8d729f:	48 c7 84 24 98 00 00 	movq   $0x250,0x98(%rsp)
  8d72a6:	00 50 02 00 00 
  8d72ab:	49 89 d9             	mov    %rbx,%r9
  8d72ae:	4c 8d 84 24 98 00 00 	lea    0x98(%rsp),%r8
  8d72b5:	00 
  8d72b6:	48 89 c1             	mov    %rax,%rcx
  8d72b9:	ff 50 40             	callq  *0x40(%rax)
  8d72bc:	49 89 c5             	mov    %rax,%r13
  8d72bf:	48 83 c4 20          	add    $0x20,%rsp
  8d72c3:	48 85 c0             	test   %rax,%rax
  8d72c6:	74 22                	je     8d72ea <handle_cmdline_files+0x326>
  8d72c8:	48 8d 3d 62 49 00 00 	lea    0x4962(%rip),%rdi        # 8dbc31 <kernel_info_end+0xaa1>
  8d72cf:	31 c0                	xor    %eax,%eax
  8d72d1:	e8 f6 ee ff ff       	callq  8d61cc <efi_printk>
  8d72d6:	48 8b 44 24 70       	mov    0x70(%rsp),%rax
  8d72db:	48 83 ec 20          	sub    $0x20,%rsp
  8d72df:	48 89 c1             	mov    %rax,%rcx
  8d72e2:	ff 50 10             	callq  *0x10(%rax)
  8d72e5:	e9 60 01 00 00       	jmpq   8d744a <handle_cmdline_files+0x486>
  8d72ea:	48 8b 84 24 98 00 00 	mov    0x98(%rsp),%rax
  8d72f1:	00 
  8d72f2:	4c 8b 64 24 70       	mov    0x70(%rsp),%r12
  8d72f7:	48 8d 5c 05 00       	lea    0x0(%rbp,%rax,1),%rbx
  8d72fc:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d7301:	48 8d 45 ff          	lea    -0x1(%rbp),%rax
  8d7305:	48 8d 53 ff          	lea    -0x1(%rbx),%rdx
  8d7309:	48 0d ff 0f 00 00    	or     $0xfff,%rax
  8d730f:	48 81 ca ff 0f 00 00 	or     $0xfff,%rdx
  8d7316:	48 ff c0             	inc    %rax
  8d7319:	48 ff c2             	inc    %rdx
  8d731c:	48 39 c2             	cmp    %rax,%rdx
  8d731f:	0f 86 84 00 00 00    	jbe    8d73a9 <handle_cmdline_files+0x3e5>
  8d7325:	4c 8b 7c 24 68       	mov    0x68(%rsp),%r15
  8d732a:	48 8b 7c 24 28       	mov    0x28(%rsp),%rdi
  8d732f:	48 39 7c 24 20       	cmp    %rdi,0x20(%rsp)
  8d7334:	72 17                	jb     8d734d <handle_cmdline_files+0x389>
  8d7336:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d733b:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  8d7340:	48 89 df             	mov    %rbx,%rdi
  8d7343:	e8 fd 13 00 00       	callq  8d8745 <efi_allocate_pages>
  8d7348:	49 89 c5             	mov    %rax,%r13
  8d734b:	eb 24                	jmp    8d7371 <handle_cmdline_files+0x3ad>
  8d734d:	48 8b 54 24 20       	mov    0x20(%rsp),%rdx
  8d7352:	48 8d 74 24 68       	lea    0x68(%rsp),%rsi
  8d7357:	48 89 df             	mov    %rbx,%rdi
  8d735a:	e8 e6 13 00 00       	callq  8d8745 <efi_allocate_pages>
  8d735f:	49 89 c5             	mov    %rax,%r13
  8d7362:	48 b8 09 00 00 00 00 	movabs $0x8000000000000009,%rax
  8d7369:	00 00 80 
  8d736c:	49 39 c5             	cmp    %rax,%r13
  8d736f:	74 c5                	je     8d7336 <handle_cmdline_files+0x372>
  8d7371:	4d 85 ed             	test   %r13,%r13
  8d7374:	74 13                	je     8d7389 <handle_cmdline_files+0x3c5>
  8d7376:	48 8d 3d d6 48 00 00 	lea    0x48d6(%rip),%rdi        # 8dbc53 <kernel_info_end+0xac3>
  8d737d:	31 c0                	xor    %eax,%eax
  8d737f:	e8 48 ee ff ff       	callq  8d61cc <efi_printk>
  8d7384:	e9 b5 00 00 00       	jmpq   8d743e <handle_cmdline_files+0x47a>
  8d7389:	4d 85 ff             	test   %r15,%r15
  8d738c:	74 1b                	je     8d73a9 <handle_cmdline_files+0x3e5>
  8d738e:	48 8b 7c 24 68       	mov    0x68(%rsp),%rdi
  8d7393:	4c 89 fe             	mov    %r15,%rsi
  8d7396:	48 89 ea             	mov    %rbp,%rdx
  8d7399:	e8 52 bd ff ff       	callq  8d30f0 <memcpy>
  8d739e:	4c 89 fe             	mov    %r15,%rsi
  8d73a1:	48 89 ef             	mov    %rbp,%rdi
  8d73a4:	e8 25 14 00 00       	callq  8d87ce <efi_free>
  8d73a9:	48 03 6c 24 68       	add    0x68(%rsp),%rbp
  8d73ae:	4c 8d bc 24 80 00 00 	lea    0x80(%rsp),%r15
  8d73b5:	00 
  8d73b6:	48 83 7c 24 08 00    	cmpq   $0x0,0x8(%rsp)
  8d73bc:	74 5e                	je     8d741c <handle_cmdline_files+0x458>
  8d73be:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d73c3:	48 39 7c 24 10       	cmp    %rdi,0x10(%rsp)
  8d73c8:	49 89 e8             	mov    %rbp,%r8
  8d73cb:	4c 89 fa             	mov    %r15,%rdx
  8d73ce:	4c 89 e1             	mov    %r12,%rcx
  8d73d1:	48 89 f8             	mov    %rdi,%rax
  8d73d4:	48 0f 46 44 24 10    	cmovbe 0x10(%rsp),%rax
  8d73da:	48 83 ec 20          	sub    $0x20,%rsp
  8d73de:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
  8d73e5:	00 
  8d73e6:	41 ff 54 24 20       	callq  *0x20(%r12)
  8d73eb:	49 89 c5             	mov    %rax,%r13
  8d73ee:	48 83 c4 20          	add    $0x20,%rsp
  8d73f2:	48 85 c0             	test   %rax,%rax
  8d73f5:	74 13                	je     8d740a <handle_cmdline_files+0x446>
  8d73f7:	48 8d 3d 83 48 00 00 	lea    0x4883(%rip),%rdi        # 8dbc81 <kernel_info_end+0xaf1>
  8d73fe:	31 c0                	xor    %eax,%eax
  8d7400:	48 89 dd             	mov    %rbx,%rbp
  8d7403:	e8 c4 ed ff ff       	callq  8d61cc <efi_printk>
  8d7408:	eb 34                	jmp    8d743e <handle_cmdline_files+0x47a>
  8d740a:	48 8b 84 24 80 00 00 	mov    0x80(%rsp),%rax
  8d7411:	00 
  8d7412:	48 29 44 24 08       	sub    %rax,0x8(%rsp)
  8d7417:	48 01 c5             	add    %rax,%rbp
  8d741a:	eb 9a                	jmp    8d73b6 <handle_cmdline_files+0x3f2>
  8d741c:	48 83 ec 20          	sub    $0x20,%rsp
  8d7420:	4c 89 e1             	mov    %r12,%rcx
  8d7423:	41 ff 54 24 10       	callq  *0x10(%r12)
  8d7428:	48 83 c4 20          	add    $0x20,%rsp
  8d742c:	45 85 f6             	test   %r14d,%r14d
  8d742f:	7e 1f                	jle    8d7450 <handle_cmdline_files+0x48c>
  8d7431:	48 89 dd             	mov    %rbx,%rbp
  8d7434:	e9 45 fc ff ff       	jmpq   8d707e <handle_cmdline_files+0xba>
  8d7439:	48 89 eb             	mov    %rbp,%rbx
  8d743c:	eb 12                	jmp    8d7450 <handle_cmdline_files+0x48c>
  8d743e:	48 83 ec 20          	sub    $0x20,%rsp
  8d7442:	4c 89 e1             	mov    %r12,%rcx
  8d7445:	41 ff 54 24 10       	callq  *0x10(%r12)
  8d744a:	48 83 c4 20          	add    $0x20,%rsp
  8d744e:	eb 35                	jmp    8d7485 <handle_cmdline_files+0x4c1>
  8d7450:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  8d7455:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8d745a:	45 31 ed             	xor    %r13d,%r13d
  8d745d:	48 89 06             	mov    %rax,(%rsi)
  8d7460:	48 8b 84 24 20 03 00 	mov    0x320(%rsp),%rax
  8d7467:	00 
  8d7468:	48 89 18             	mov    %rbx,(%rax)
  8d746b:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d7470:	48 85 c0             	test   %rax,%rax
  8d7473:	74 3f                	je     8d74b4 <handle_cmdline_files+0x4f0>
  8d7475:	48 83 ec 20          	sub    $0x20,%rsp
  8d7479:	48 89 c1             	mov    %rax,%rcx
  8d747c:	ff 50 10             	callq  *0x10(%rax)
  8d747f:	48 83 c4 20          	add    $0x20,%rsp
  8d7483:	eb 2f                	jmp    8d74b4 <handle_cmdline_files+0x4f0>
  8d7485:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d748a:	48 83 ec 20          	sub    $0x20,%rsp
  8d748e:	48 89 c1             	mov    %rax,%rcx
  8d7491:	ff 50 10             	callq  *0x10(%rax)
  8d7494:	48 8b b4 24 88 00 00 	mov    0x88(%rsp),%rsi
  8d749b:	00 
  8d749c:	48 89 ef             	mov    %rbp,%rdi
  8d749f:	48 83 c4 20          	add    $0x20,%rsp
  8d74a3:	e8 26 13 00 00       	callq  8d87ce <efi_free>
  8d74a8:	eb 0a                	jmp    8d74b4 <handle_cmdline_files+0x4f0>
  8d74aa:	49 bd 02 00 00 00 00 	movabs $0x8000000000000002,%r13
  8d74b1:	00 00 80 
  8d74b4:	48 81 c4 e8 02 00 00 	add    $0x2e8,%rsp
  8d74bb:	4c 89 e8             	mov    %r13,%rax
  8d74be:	5b                   	pop    %rbx
  8d74bf:	5d                   	pop    %rbp
  8d74c0:	41 5c                	pop    %r12
  8d74c2:	41 5d                	pop    %r13
  8d74c4:	41 5e                	pop    %r14
  8d74c6:	41 5f                	pop    %r15
  8d74c8:	c3                   	retq   

00000000008d74c9 <pixel_bpp>:
  8d74c9:	b0 20                	mov    $0x20,%al
  8d74cb:	83 ff 02             	cmp    $0x2,%edi
  8d74ce:	75 24                	jne    8d74f4 <pixel_bpp+0x2b>
  8d74d0:	48 89 f0             	mov    %rsi,%rax
  8d74d3:	48 c1 e8 20          	shr    $0x20,%rax
  8d74d7:	09 c6                	or     %eax,%esi
  8d74d9:	31 c0                	xor    %eax,%eax
  8d74db:	09 d6                	or     %edx,%esi
  8d74dd:	48 c1 ea 20          	shr    $0x20,%rdx
  8d74e1:	09 d6                	or     %edx,%esi
  8d74e3:	74 0f                	je     8d74f4 <pixel_bpp+0x2b>
  8d74e5:	89 f6                	mov    %esi,%esi
  8d74e7:	48 0f bd c6          	bsr    %rsi,%rax
  8d74eb:	ff c0                	inc    %eax
  8d74ed:	f3 48 0f bc f6       	tzcnt  %rsi,%rsi
  8d74f2:	29 f0                	sub    %esi,%eax
  8d74f4:	c3                   	retq   

00000000008d74f5 <strstarts>:
  8d74f5:	41 54                	push   %r12
  8d74f7:	49 89 fc             	mov    %rdi,%r12
  8d74fa:	48 89 f7             	mov    %rsi,%rdi
  8d74fd:	48 83 ec 10          	sub    $0x10,%rsp
  8d7501:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8d7506:	e8 25 ba ff ff       	callq  8d2f30 <strlen>
  8d750b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d7510:	4c 89 e7             	mov    %r12,%rdi
  8d7513:	48 89 c2             	mov    %rax,%rdx
  8d7516:	e8 65 b8 ff ff       	callq  8d2d80 <strncmp>
  8d751b:	85 c0                	test   %eax,%eax
  8d751d:	0f 94 c0             	sete   %al
  8d7520:	48 83 c4 10          	add    $0x10,%rsp
  8d7524:	41 5c                	pop    %r12
  8d7526:	c3                   	retq   

00000000008d7527 <find_bits>:
  8d7527:	85 ff                	test   %edi,%edi
  8d7529:	75 07                	jne    8d7532 <find_bits+0xb>
  8d752b:	c6 02 00             	movb   $0x0,(%rdx)
  8d752e:	c6 06 00             	movb   $0x0,(%rsi)
  8d7531:	c3                   	retq   
  8d7532:	89 ff                	mov    %edi,%edi
  8d7534:	f3 48 0f bc c7       	tzcnt  %rdi,%rax
  8d7539:	48 0f bd ff          	bsr    %rdi,%rdi
  8d753d:	ff c7                	inc    %edi
  8d753f:	88 06                	mov    %al,(%rsi)
  8d7541:	29 c7                	sub    %eax,%edi
  8d7543:	40 88 3a             	mov    %dil,(%rdx)
  8d7546:	c3                   	retq   

00000000008d7547 <efi_parse_option_graphics>:
  8d7547:	f3 0f 1e fa          	endbr64 
  8d754b:	41 55                	push   %r13
  8d754d:	41 54                	push   %r12
  8d754f:	55                   	push   %rbp
  8d7550:	53                   	push   %rbx
  8d7551:	48 89 fb             	mov    %rdi,%rbx
  8d7554:	48 83 ec 18          	sub    $0x18,%rsp
  8d7558:	48 8d 6c 24 08       	lea    0x8(%rsp),%rbp
  8d755d:	80 3b 00             	cmpb   $0x0,(%rbx)
  8d7560:	0f 84 2f 02 00 00    	je     8d7795 <efi_parse_option_graphics+0x24e>
  8d7566:	48 8d 35 32 47 00 00 	lea    0x4732(%rip),%rsi        # 8dbc9f <kernel_info_end+0xb0f>
  8d756d:	48 89 df             	mov    %rbx,%rdi
  8d7570:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  8d7575:	e8 7b ff ff ff       	callq  8d74f5 <strstarts>
  8d757a:	84 c0                	test   %al,%al
  8d757c:	75 16                	jne    8d7594 <efi_parse_option_graphics+0x4d>
  8d757e:	48 89 5c 24 08       	mov    %rbx,0x8(%rsp)
  8d7583:	0f be 03             	movsbl (%rbx),%eax
  8d7586:	83 e8 30             	sub    $0x30,%eax
  8d7589:	83 f8 09             	cmp    $0x9,%eax
  8d758c:	0f 87 6f 01 00 00    	ja     8d7701 <efi_parse_option_graphics+0x1ba>
  8d7592:	eb 52                	jmp    8d75e6 <efi_parse_option_graphics+0x9f>
  8d7594:	48 8d 3d 04 47 00 00 	lea    0x4704(%rip),%rdi        # 8dbc9f <kernel_info_end+0xb0f>
  8d759b:	e8 90 b9 ff ff       	callq  8d2f30 <strlen>
  8d75a0:	48 03 44 24 08       	add    0x8(%rsp),%rax
  8d75a5:	31 d2                	xor    %edx,%edx
  8d75a7:	48 89 ee             	mov    %rbp,%rsi
  8d75aa:	48 89 c7             	mov    %rax,%rdi
  8d75ad:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d75b2:	e8 89 b8 ff ff       	callq  8d2e40 <simple_strtoull>
  8d75b7:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d75bc:	80 3a 00             	cmpb   $0x0,(%rdx)
  8d75bf:	75 15                	jne    8d75d6 <efi_parse_option_graphics+0x8f>
  8d75c1:	c7 05 a5 4c 00 00 01 	movl   $0x1,0x4ca5(%rip)        # 8dc270 <cmdline>
  8d75c8:	00 00 00 
  8d75cb:	89 05 a3 4c 00 00    	mov    %eax,0x4ca3(%rip)        # 8dc274 <cmdline+0x4>
  8d75d1:	e9 13 01 00 00       	jmpq   8d76e9 <efi_parse_option_graphics+0x1a2>
  8d75d6:	48 8d 4a 01          	lea    0x1(%rdx),%rcx
  8d75da:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d75df:	80 3a 2c             	cmpb   $0x2c,(%rdx)
  8d75e2:	75 9a                	jne    8d757e <efi_parse_option_graphics+0x37>
  8d75e4:	eb db                	jmp    8d75c1 <efi_parse_option_graphics+0x7a>
  8d75e6:	48 89 df             	mov    %rbx,%rdi
  8d75e9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8d75ee:	48 89 ee             	mov    %rbp,%rsi
  8d75f1:	e8 4a b8 ff ff       	callq  8d2e40 <simple_strtoull>
  8d75f6:	49 89 c4             	mov    %rax,%r12
  8d75f9:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d75fe:	48 8d 78 01          	lea    0x1(%rax),%rdi
  8d7602:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d7607:	80 38 78             	cmpb   $0x78,(%rax)
  8d760a:	0f 85 f1 00 00 00    	jne    8d7701 <efi_parse_option_graphics+0x1ba>
  8d7610:	0f be 40 01          	movsbl 0x1(%rax),%eax
  8d7614:	83 e8 30             	sub    $0x30,%eax
  8d7617:	83 f8 09             	cmp    $0x9,%eax
  8d761a:	0f 87 e1 00 00 00    	ja     8d7701 <efi_parse_option_graphics+0x1ba>
  8d7620:	ba 0a 00 00 00       	mov    $0xa,%edx
  8d7625:	48 89 ee             	mov    %rbp,%rsi
  8d7628:	e8 13 b8 ff ff       	callq  8d2e40 <simple_strtoull>
  8d762d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d7632:	83 ca ff             	or     $0xffffffff,%edx
  8d7635:	49 89 c5             	mov    %rax,%r13
  8d7638:	80 3f 2d             	cmpb   $0x2d,(%rdi)
  8d763b:	75 7c                	jne    8d76b9 <efi_parse_option_graphics+0x172>
  8d763d:	48 ff c7             	inc    %rdi
  8d7640:	48 8d 35 5e 46 00 00 	lea    0x465e(%rip),%rsi        # 8dbca5 <kernel_info_end+0xb15>
  8d7647:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d764c:	e8 a4 fe ff ff       	callq  8d74f5 <strstarts>
  8d7651:	84 c0                	test   %al,%al
  8d7653:	74 15                	je     8d766a <efi_parse_option_graphics+0x123>
  8d7655:	48 8d 3d 49 46 00 00 	lea    0x4649(%rip),%rdi        # 8dbca5 <kernel_info_end+0xb15>
  8d765c:	e8 cf b8 ff ff       	callq  8d2f30 <strlen>
  8d7661:	31 d2                	xor    %edx,%edx
  8d7663:	48 01 44 24 08       	add    %rax,0x8(%rsp)
  8d7668:	eb 4f                	jmp    8d76b9 <efi_parse_option_graphics+0x172>
  8d766a:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d766f:	48 8d 35 33 46 00 00 	lea    0x4633(%rip),%rsi        # 8dbca9 <kernel_info_end+0xb19>
  8d7676:	e8 7a fe ff ff       	callq  8d74f5 <strstarts>
  8d767b:	84 c0                	test   %al,%al
  8d767d:	74 18                	je     8d7697 <efi_parse_option_graphics+0x150>
  8d767f:	48 8d 3d 23 46 00 00 	lea    0x4623(%rip),%rdi        # 8dbca9 <kernel_info_end+0xb19>
  8d7686:	e8 a5 b8 ff ff       	callq  8d2f30 <strlen>
  8d768b:	ba 01 00 00 00       	mov    $0x1,%edx
  8d7690:	48 01 44 24 08       	add    %rax,0x8(%rsp)
  8d7695:	eb 22                	jmp    8d76b9 <efi_parse_option_graphics+0x172>
  8d7697:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8d769c:	0f be 07             	movsbl (%rdi),%eax
  8d769f:	83 e8 30             	sub    $0x30,%eax
  8d76a2:	83 f8 09             	cmp    $0x9,%eax
  8d76a5:	77 5a                	ja     8d7701 <efi_parse_option_graphics+0x1ba>
  8d76a7:	ba 0a 00 00 00       	mov    $0xa,%edx
  8d76ac:	48 89 ee             	mov    %rbp,%rsi
  8d76af:	e8 8c b7 ff ff       	callq  8d2e40 <simple_strtoull>
  8d76b4:	83 ca ff             	or     $0xffffffff,%edx
  8d76b7:	eb 02                	jmp    8d76bb <efi_parse_option_graphics+0x174>
  8d76b9:	31 c0                	xor    %eax,%eax
  8d76bb:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  8d76c0:	80 39 00             	cmpb   $0x0,(%rcx)
  8d76c3:	75 2e                	jne    8d76f3 <efi_parse_option_graphics+0x1ac>
  8d76c5:	c7 05 a1 4b 00 00 02 	movl   $0x2,0x4ba1(%rip)        # 8dc270 <cmdline>
  8d76cc:	00 00 00 
  8d76cf:	44 89 25 9e 4b 00 00 	mov    %r12d,0x4b9e(%rip)        # 8dc274 <cmdline+0x4>
  8d76d6:	44 89 2d 9b 4b 00 00 	mov    %r13d,0x4b9b(%rip)        # 8dc278 <cmdline+0x8>
  8d76dd:	89 15 99 4b 00 00    	mov    %edx,0x4b99(%rip)        # 8dc27c <cmdline+0xc>
  8d76e3:	88 05 97 4b 00 00    	mov    %al,0x4b97(%rip)        # 8dc280 <cmdline+0x10>
  8d76e9:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  8d76ee:	e9 6a fe ff ff       	jmpq   8d755d <efi_parse_option_graphics+0x16>
  8d76f3:	48 8d 71 01          	lea    0x1(%rcx),%rsi
  8d76f7:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
  8d76fc:	80 39 2c             	cmpb   $0x2c,(%rcx)
  8d76ff:	74 c4                	je     8d76c5 <efi_parse_option_graphics+0x17e>
  8d7701:	48 8d 35 a5 45 00 00 	lea    0x45a5(%rip),%rsi        # 8dbcad <kernel_info_end+0xb1d>
  8d7708:	48 89 df             	mov    %rbx,%rdi
  8d770b:	e8 e5 fd ff ff       	callq  8d74f5 <strstarts>
  8d7710:	84 c0                	test   %al,%al
  8d7712:	74 29                	je     8d773d <efi_parse_option_graphics+0x1f6>
  8d7714:	48 8d 3d 92 45 00 00 	lea    0x4592(%rip),%rdi        # 8dbcad <kernel_info_end+0xb1d>
  8d771b:	e8 10 b8 ff ff       	callq  8d2f30 <strlen>
  8d7720:	48 01 d8             	add    %rbx,%rax
  8d7723:	8a 10                	mov    (%rax),%dl
  8d7725:	84 d2                	test   %dl,%dl
  8d7727:	74 08                	je     8d7731 <efi_parse_option_graphics+0x1ea>
  8d7729:	80 fa 2c             	cmp    $0x2c,%dl
  8d772c:	75 0f                	jne    8d773d <efi_parse_option_graphics+0x1f6>
  8d772e:	48 ff c0             	inc    %rax
  8d7731:	c7 05 35 4b 00 00 03 	movl   $0x3,0x4b35(%rip)        # 8dc270 <cmdline>
  8d7738:	00 00 00 
  8d773b:	eb 3a                	jmp    8d7777 <efi_parse_option_graphics+0x230>
  8d773d:	48 8d 35 6e 45 00 00 	lea    0x456e(%rip),%rsi        # 8dbcb2 <kernel_info_end+0xb22>
  8d7744:	48 89 df             	mov    %rbx,%rdi
  8d7747:	e8 a9 fd ff ff       	callq  8d74f5 <strstarts>
  8d774c:	84 c0                	test   %al,%al
  8d774e:	74 3a                	je     8d778a <efi_parse_option_graphics+0x243>
  8d7750:	48 8d 3d 5b 45 00 00 	lea    0x455b(%rip),%rdi        # 8dbcb2 <kernel_info_end+0xb22>
  8d7757:	e8 d4 b7 ff ff       	callq  8d2f30 <strlen>
  8d775c:	48 01 d8             	add    %rbx,%rax
  8d775f:	8a 10                	mov    (%rax),%dl
  8d7761:	84 d2                	test   %dl,%dl
  8d7763:	74 08                	je     8d776d <efi_parse_option_graphics+0x226>
  8d7765:	80 fa 2c             	cmp    $0x2c,%dl
  8d7768:	75 20                	jne    8d778a <efi_parse_option_graphics+0x243>
  8d776a:	48 ff c0             	inc    %rax
  8d776d:	c7 05 f9 4a 00 00 04 	movl   $0x4,0x4af9(%rip)        # 8dc270 <cmdline>
  8d7774:	00 00 00 
  8d7777:	48 89 c3             	mov    %rax,%rbx
  8d777a:	e9 de fd ff ff       	jmpq   8d755d <efi_parse_option_graphics+0x16>
  8d777f:	48 ff c3             	inc    %rbx
  8d7782:	3c 2c                	cmp    $0x2c,%al
  8d7784:	0f 84 d3 fd ff ff    	je     8d755d <efi_parse_option_graphics+0x16>
  8d778a:	8a 03                	mov    (%rbx),%al
  8d778c:	84 c0                	test   %al,%al
  8d778e:	75 ef                	jne    8d777f <efi_parse_option_graphics+0x238>
  8d7790:	e9 c8 fd ff ff       	jmpq   8d755d <efi_parse_option_graphics+0x16>
  8d7795:	48 83 c4 18          	add    $0x18,%rsp
  8d7799:	5b                   	pop    %rbx
  8d779a:	5d                   	pop    %rbp
  8d779b:	41 5c                	pop    %r12
  8d779d:	41 5d                	pop    %r13
  8d779f:	c3                   	retq   

00000000008d77a0 <efi_setup_gop>:
  8d77a0:	f3 0f 1e fa          	endbr64 
  8d77a4:	41 57                	push   %r15
  8d77a6:	41 56                	push   %r14
  8d77a8:	41 55                	push   %r13
  8d77aa:	49 89 fd             	mov    %rdi,%r13
  8d77ad:	41 54                	push   %r12
  8d77af:	55                   	push   %rbp
  8d77b0:	53                   	push   %rbx
  8d77b1:	48 89 f3             	mov    %rsi,%rbx
  8d77b4:	48 81 ec 88 00 00 00 	sub    $0x88,%rsp
  8d77bb:	44 8a 35 4e 4a 00 00 	mov    0x4a4e(%rip),%r14b        # 8dc210 <efi_is64>
  8d77c2:	48 8b 05 37 c4 01 00 	mov    0x1c437(%rip),%rax        # 8f3c00 <efi_system_table>
  8d77c9:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
  8d77ce:	4c 8d 44 24 58       	lea    0x58(%rsp),%r8
  8d77d3:	48 c7 44 24 58 00 00 	movq   $0x0,0x58(%rsp)
  8d77da:	00 00 
  8d77dc:	45 84 f6             	test   %r14b,%r14b
  8d77df:	74 21                	je     8d7802 <efi_setup_gop+0x62>
  8d77e1:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d77e5:	48 83 ec 20          	sub    $0x20,%rsp
  8d77e9:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d77ee:	ff 50 40             	callq  *0x40(%rax)
  8d77f1:	49 89 c4             	mov    %rax,%r12
  8d77f4:	48 83 c4 20          	add    $0x20,%rsp
  8d77f8:	48 85 c0             	test   %rax,%rax
  8d77fb:	74 2f                	je     8d782c <efi_setup_gop+0x8c>
  8d77fd:	e9 09 0a 00 00       	jmpq   8d820b <efi_setup_gop+0xa6b>
  8d7802:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7805:	4c 89 c1             	mov    %r8,%rcx
  8d7808:	be 02 00 00 00       	mov    $0x2,%esi
  8d780d:	c7 44 24 5c 00 00 00 	movl   $0x0,0x5c(%rsp)
  8d7814:	00 
  8d7815:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d7818:	31 c0                	xor    %eax,%eax
  8d781a:	e8 61 d5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d781f:	49 89 c4             	mov    %rax,%r12
  8d7822:	48 85 c0             	test   %rax,%rax
  8d7825:	74 71                	je     8d7898 <efi_setup_gop+0xf8>
  8d7827:	e9 df 09 00 00       	jmpq   8d820b <efi_setup_gop+0xa6b>
  8d782c:	48 8b 05 cd c3 01 00 	mov    0x1c3cd(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7833:	51                   	push   %rcx
  8d7834:	45 31 c0             	xor    %r8d,%r8d
  8d7837:	48 89 da             	mov    %rbx,%rdx
  8d783a:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d783f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7843:	ff 74 24 60          	pushq  0x60(%rsp)
  8d7847:	48 83 ec 20          	sub    $0x20,%rsp
  8d784b:	4c 8d 4c 24 78       	lea    0x78(%rsp),%r9
  8d7850:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d7856:	49 89 c4             	mov    %rax,%r12
  8d7859:	48 83 c4 30          	add    $0x30,%rsp
  8d785d:	48 85 c0             	test   %rax,%rax
  8d7860:	0f 85 6f 09 00 00    	jne    8d81d5 <efi_setup_gop+0xa35>
  8d7866:	41 80 fe 01          	cmp    $0x1,%r14b
  8d786a:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
  8d786f:	48 19 c9             	sbb    %rcx,%rcx
  8d7872:	31 d2                	xor    %edx,%edx
  8d7874:	31 ed                	xor    %ebp,%ebp
  8d7876:	45 31 ff             	xor    %r15d,%r15d
  8d7879:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d787e:	48 83 e1 fc          	and    $0xfffffffffffffffc,%rcx
  8d7882:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
  8d7887:	48 83 c1 08          	add    $0x8,%rcx
  8d788b:	48 f7 f1             	div    %rcx
  8d788e:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d7893:	e9 af 00 00 00       	jmpq   8d7947 <efi_setup_gop+0x1a7>
  8d7898:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
  8d789d:	4c 8d 44 24 48       	lea    0x48(%rsp),%r8
  8d78a2:	31 c9                	xor    %ecx,%ecx
  8d78a4:	48 89 da             	mov    %rbx,%rdx
  8d78a7:	48 8b 05 52 c3 01 00 	mov    0x1c352(%rip),%rax        # 8f3c00 <efi_system_table>
  8d78ae:	be 02 00 00 00       	mov    $0x2,%esi
  8d78b3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d78b6:	8b 78 64             	mov    0x64(%rax),%edi
  8d78b9:	31 c0                	xor    %eax,%eax
  8d78bb:	e8 c0 d4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d78c0:	49 89 c4             	mov    %rax,%r12
  8d78c3:	48 85 c0             	test   %rax,%rax
  8d78c6:	0f 85 26 09 00 00    	jne    8d81f2 <efi_setup_gop+0xa52>
  8d78cc:	eb 98                	jmp    8d7866 <efi_setup_gop+0xc6>
  8d78ce:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d78d3:	45 84 f6             	test   %r14b,%r14b
  8d78d6:	74 7b                	je     8d7953 <efi_setup_gop+0x1b3>
  8d78d8:	4c 8b 24 e8          	mov    (%rax,%rbp,8),%r12
  8d78dc:	48 b8 2c 6f b3 d3 51 	movabs $0x11d4d551d3b36f2c,%rax
  8d78e3:	d5 d4 11 
  8d78e6:	45 84 f6             	test   %r14b,%r14b
  8d78e9:	4c 8d 44 24 60       	lea    0x60(%rsp),%r8
  8d78ee:	48 c7 44 24 68 00 00 	movq   $0x0,0x68(%rsp)
  8d78f5:	00 00 
  8d78f7:	48 89 44 24 70       	mov    %rax,0x70(%rsp)
  8d78fc:	48 b8 9a 46 00 90 27 	movabs $0x4dc13f279000469a,%rax
  8d7903:	3f c1 4d 
  8d7906:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
  8d790b:	48 8b 05 ee c2 01 00 	mov    0x1c2ee(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7912:	74 45                	je     8d7959 <efi_setup_gop+0x1b9>
  8d7914:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7918:	48 83 ec 20          	sub    $0x20,%rsp
  8d791c:	48 89 da             	mov    %rbx,%rdx
  8d791f:	4c 89 e1             	mov    %r12,%rcx
  8d7922:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d7928:	48 83 c4 20          	add    $0x20,%rsp
  8d792c:	48 85 c0             	test   %rax,%rax
  8d792f:	75 13                	jne    8d7944 <efi_setup_gop+0x1a4>
  8d7931:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d7936:	48 8b 40 18          	mov    0x18(%rax),%rax
  8d793a:	48 8b 40 08          	mov    0x8(%rax),%rax
  8d793e:	83 78 0c 02          	cmpl   $0x2,0xc(%rax)
  8d7942:	7e 45                	jle    8d7989 <efi_setup_gop+0x1e9>
  8d7944:	48 ff c5             	inc    %rbp
  8d7947:	48 39 6c 24 10       	cmp    %rbp,0x10(%rsp)
  8d794c:	75 80                	jne    8d78ce <efi_setup_gop+0x12e>
  8d794e:	e9 9d 00 00 00       	jmpq   8d79f0 <efi_setup_gop+0x250>
  8d7953:	44 8b 24 a8          	mov    (%rax,%rbp,4),%r12d
  8d7957:	eb 83                	jmp    8d78dc <efi_setup_gop+0x13c>
  8d7959:	c7 44 24 64 00 00 00 	movl   $0x0,0x64(%rsp)
  8d7960:	00 
  8d7961:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7964:	4c 89 c1             	mov    %r8,%rcx
  8d7967:	48 89 da             	mov    %rbx,%rdx
  8d796a:	4c 89 e6             	mov    %r12,%rsi
  8d796d:	8b 78 58             	mov    0x58(%rax),%edi
  8d7970:	31 c0                	xor    %eax,%eax
  8d7972:	e8 09 d4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7977:	48 85 c0             	test   %rax,%rax
  8d797a:	75 c8                	jne    8d7944 <efi_setup_gop+0x1a4>
  8d797c:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
  8d7981:	8b 40 0c             	mov    0xc(%rax),%eax
  8d7984:	8b 40 08             	mov    0x8(%rax),%eax
  8d7987:	eb b5                	jmp    8d793e <efi_setup_gop+0x19e>
  8d7989:	45 84 f6             	test   %r14b,%r14b
  8d798c:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d7991:	48 8d 54 24 70       	lea    0x70(%rsp),%rdx
  8d7996:	48 8b 05 63 c2 01 00 	mov    0x1c263(%rip),%rax        # 8f3c00 <efi_system_table>
  8d799d:	74 17                	je     8d79b6 <efi_setup_gop+0x216>
  8d799f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d79a3:	48 83 ec 20          	sub    $0x20,%rsp
  8d79a7:	4c 89 e1             	mov    %r12,%rcx
  8d79aa:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d79b0:	48 83 c4 20          	add    $0x20,%rsp
  8d79b4:	eb 1b                	jmp    8d79d1 <efi_setup_gop+0x231>
  8d79b6:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d79bd:	00 
  8d79be:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d79c1:	4c 89 c1             	mov    %r8,%rcx
  8d79c4:	4c 89 e6             	mov    %r12,%rsi
  8d79c7:	8b 78 58             	mov    0x58(%rax),%edi
  8d79ca:	31 c0                	xor    %eax,%eax
  8d79cc:	e8 af d3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d79d1:	48 85 c0             	test   %rax,%rax
  8d79d4:	75 07                	jne    8d79dd <efi_setup_gop+0x23d>
  8d79d6:	4c 8b 7c 24 60       	mov    0x60(%rsp),%r15
  8d79db:	eb 13                	jmp    8d79f0 <efi_setup_gop+0x250>
  8d79dd:	4d 85 ff             	test   %r15,%r15
  8d79e0:	0f 85 5e ff ff ff    	jne    8d7944 <efi_setup_gop+0x1a4>
  8d79e6:	4c 8b 7c 24 60       	mov    0x60(%rsp),%r15
  8d79eb:	e9 54 ff ff ff       	jmpq   8d7944 <efi_setup_gop+0x1a4>
  8d79f0:	49 bc 0e 00 00 00 00 	movabs $0x800000000000000e,%r12
  8d79f7:	00 00 80 
  8d79fa:	4d 85 ff             	test   %r15,%r15
  8d79fd:	0f 84 cd 07 00 00    	je     8d81d0 <efi_setup_gop+0xa30>
  8d7a03:	8b 05 67 48 00 00    	mov    0x4867(%rip),%eax        # 8dc270 <cmdline>
  8d7a09:	83 f8 03             	cmp    $0x3,%eax
  8d7a0c:	0f 84 c6 02 00 00    	je     8d7cd8 <efi_setup_gop+0x538>
  8d7a12:	77 13                	ja     8d7a27 <efi_setup_gop+0x287>
  8d7a14:	83 f8 01             	cmp    $0x1,%eax
  8d7a17:	74 1c                	je     8d7a35 <efi_setup_gop+0x295>
  8d7a19:	83 f8 02             	cmp    $0x2,%eax
  8d7a1c:	0f 84 fb 00 00 00    	je     8d7b1d <efi_setup_gop+0x37d>
  8d7a22:	e9 7d 06 00 00       	jmpq   8d80a4 <efi_setup_gop+0x904>
  8d7a27:	83 f8 04             	cmp    $0x4,%eax
  8d7a2a:	0f 84 16 04 00 00    	je     8d7e46 <efi_setup_gop+0x6a6>
  8d7a30:	e9 6f 06 00 00       	jmpq   8d80a4 <efi_setup_gop+0x904>
  8d7a35:	45 84 f6             	test   %r14b,%r14b
  8d7a38:	74 06                	je     8d7a40 <efi_setup_gop+0x2a0>
  8d7a3a:	49 8b 47 18          	mov    0x18(%r15),%rax
  8d7a3e:	eb 04                	jmp    8d7a44 <efi_setup_gop+0x2a4>
  8d7a40:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8d7a44:	44 8b 60 04          	mov    0x4(%rax),%r12d
  8d7a48:	8b 15 26 48 00 00    	mov    0x4826(%rip),%edx        # 8dc274 <cmdline+0x4>
  8d7a4e:	44 39 e2             	cmp    %r12d,%edx
  8d7a51:	0f 84 e9 05 00 00    	je     8d8040 <efi_setup_gop+0x8a0>
  8d7a57:	8b 00                	mov    (%rax),%eax
  8d7a59:	45 84 f6             	test   %r14b,%r14b
  8d7a5c:	74 06                	je     8d7a64 <efi_setup_gop+0x2c4>
  8d7a5e:	39 d0                	cmp    %edx,%eax
  8d7a60:	77 0f                	ja     8d7a71 <efi_setup_gop+0x2d1>
  8d7a62:	eb 04                	jmp    8d7a68 <efi_setup_gop+0x2c8>
  8d7a64:	39 d0                	cmp    %edx,%eax
  8d7a66:	77 29                	ja     8d7a91 <efi_setup_gop+0x2f1>
  8d7a68:	48 8d 3d 50 42 00 00 	lea    0x4250(%rip),%rdi        # 8dbcbf <kernel_info_end+0xb2f>
  8d7a6f:	eb 53                	jmp    8d7ac4 <efi_setup_gop+0x324>
  8d7a71:	48 83 ec 20          	sub    $0x20,%rsp
  8d7a75:	4c 89 f9             	mov    %r15,%rcx
  8d7a78:	4c 8d 8c 24 88 00 00 	lea    0x88(%rsp),%r9
  8d7a7f:	00 
  8d7a80:	4c 8d 84 24 90 00 00 	lea    0x90(%rsp),%r8
  8d7a87:	00 
  8d7a88:	41 ff 17             	callq  *(%r15)
  8d7a8b:	48 83 c4 20          	add    $0x20,%rsp
  8d7a8f:	eb 27                	jmp    8d7ab8 <efi_setup_gop+0x318>
  8d7a91:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  8d7a96:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d7a9b:	4c 89 fe             	mov    %r15,%rsi
  8d7a9e:	31 c0                	xor    %eax,%eax
  8d7aa0:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d7aa7:	00 
  8d7aa8:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d7aaf:	00 
  8d7ab0:	41 8b 3f             	mov    (%r15),%edi
  8d7ab3:	e8 c8 d2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7ab8:	48 85 c0             	test   %rax,%rax
  8d7abb:	74 13                	je     8d7ad0 <efi_setup_gop+0x330>
  8d7abd:	48 8d 3d 1f 42 00 00 	lea    0x421f(%rip),%rdi        # 8dbce3 <kernel_info_end+0xb53>
  8d7ac4:	31 c0                	xor    %eax,%eax
  8d7ac6:	e8 01 e7 ff ff       	callq  8d61cc <efi_printk>
  8d7acb:	e9 70 05 00 00       	jmpq   8d8040 <efi_setup_gop+0x8a0>
  8d7ad0:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d7ad5:	48 8b 05 24 c1 01 00 	mov    0x1c124(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7adc:	8b 59 0c             	mov    0xc(%rcx),%ebx
  8d7adf:	45 84 f6             	test   %r14b,%r14b
  8d7ae2:	74 11                	je     8d7af5 <efi_setup_gop+0x355>
  8d7ae4:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7ae8:	48 83 ec 20          	sub    $0x20,%rsp
  8d7aec:	ff 50 48             	callq  *0x48(%rax)
  8d7aef:	48 83 c4 20          	add    $0x20,%rsp
  8d7af3:	eb 10                	jmp    8d7b05 <efi_setup_gop+0x365>
  8d7af5:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7af8:	48 89 ce             	mov    %rcx,%rsi
  8d7afb:	8b 78 30             	mov    0x30(%rax),%edi
  8d7afe:	31 c0                	xor    %eax,%eax
  8d7b00:	e8 7b d2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7b05:	48 8d 3d ff 41 00 00 	lea    0x41ff(%rip),%rdi        # 8dbd0b <kernel_info_end+0xb7b>
  8d7b0c:	83 fb 02             	cmp    $0x2,%ebx
  8d7b0f:	7f b3                	jg     8d7ac4 <efi_setup_gop+0x324>
  8d7b11:	44 8b 25 5c 47 00 00 	mov    0x475c(%rip),%r12d        # 8dc274 <cmdline+0x4>
  8d7b18:	e9 23 05 00 00       	jmpq   8d8040 <efi_setup_gop+0x8a0>
  8d7b1d:	45 84 f6             	test   %r14b,%r14b
  8d7b20:	74 0e                	je     8d7b30 <efi_setup_gop+0x390>
  8d7b22:	49 8b 4f 18          	mov    0x18(%r15),%rcx
  8d7b26:	44 8b 61 04          	mov    0x4(%rcx),%r12d
  8d7b2a:	48 8b 41 08          	mov    0x8(%rcx),%rax
  8d7b2e:	eb 0b                	jmp    8d7b3b <efi_setup_gop+0x39b>
  8d7b30:	41 8b 4f 0c          	mov    0xc(%r15),%ecx
  8d7b34:	44 8b 61 04          	mov    0x4(%rcx),%r12d
  8d7b38:	8b 41 08             	mov    0x8(%rcx),%eax
  8d7b3b:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  8d7b40:	48 8b 58 18          	mov    0x18(%rax),%rbx
  8d7b44:	8b 78 0c             	mov    0xc(%rax),%edi
  8d7b47:	48 8b 68 10          	mov    0x10(%rax),%rbp
  8d7b4b:	48 89 5c 24 10       	mov    %rbx,0x10(%rsp)
  8d7b50:	8b 1d 1e 47 00 00    	mov    0x471e(%rip),%ebx        # 8dc274 <cmdline+0x4>
  8d7b56:	39 58 04             	cmp    %ebx,0x4(%rax)
  8d7b59:	75 3f                	jne    8d7b9a <efi_setup_gop+0x3fa>
  8d7b5b:	8b 1d 17 47 00 00    	mov    0x4717(%rip),%ebx        # 8dc278 <cmdline+0x8>
  8d7b61:	39 58 08             	cmp    %ebx,0x8(%rax)
  8d7b64:	75 34                	jne    8d7b9a <efi_setup_gop+0x3fa>
  8d7b66:	8b 05 10 47 00 00    	mov    0x4710(%rip),%eax        # 8dc27c <cmdline+0xc>
  8d7b6c:	39 c7                	cmp    %eax,%edi
  8d7b6e:	74 04                	je     8d7b74 <efi_setup_gop+0x3d4>
  8d7b70:	85 c0                	test   %eax,%eax
  8d7b72:	79 26                	jns    8d7b9a <efi_setup_gop+0x3fa>
  8d7b74:	44 8a 0d 05 47 00 00 	mov    0x4705(%rip),%r9b        # 8dc280 <cmdline+0x10>
  8d7b7b:	45 84 c9             	test   %r9b,%r9b
  8d7b7e:	0f 84 bc 04 00 00    	je     8d8040 <efi_setup_gop+0x8a0>
  8d7b84:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  8d7b89:	48 89 ee             	mov    %rbp,%rsi
  8d7b8c:	e8 38 f9 ff ff       	callq  8d74c9 <pixel_bpp>
  8d7b91:	41 38 c1             	cmp    %al,%r9b
  8d7b94:	0f 84 a6 04 00 00    	je     8d8040 <efi_setup_gop+0x8a0>
  8d7b9a:	8b 01                	mov    (%rcx),%eax
  8d7b9c:	31 db                	xor    %ebx,%ebx
  8d7b9e:	89 44 24 20          	mov    %eax,0x20(%rsp)
  8d7ba2:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  8d7ba7:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d7bac:	39 5c 24 20          	cmp    %ebx,0x20(%rsp)
  8d7bb0:	0f 84 0e 01 00 00    	je     8d7cc4 <efi_setup_gop+0x524>
  8d7bb6:	44 39 e3             	cmp    %r12d,%ebx
  8d7bb9:	75 04                	jne    8d7bbf <efi_setup_gop+0x41f>
  8d7bbb:	ff c3                	inc    %ebx
  8d7bbd:	eb ed                	jmp    8d7bac <efi_setup_gop+0x40c>
  8d7bbf:	45 84 f6             	test   %r14b,%r14b
  8d7bc2:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  8d7bc7:	74 1a                	je     8d7be3 <efi_setup_gop+0x443>
  8d7bc9:	48 83 ec 20          	sub    $0x20,%rsp
  8d7bcd:	49 89 c8             	mov    %rcx,%r8
  8d7bd0:	89 da                	mov    %ebx,%edx
  8d7bd2:	4c 89 f9             	mov    %r15,%rcx
  8d7bd5:	4c 8b 4c 24 38       	mov    0x38(%rsp),%r9
  8d7bda:	41 ff 17             	callq  *(%r15)
  8d7bdd:	48 83 c4 20          	add    $0x20,%rsp
  8d7be1:	eb 24                	jmp    8d7c07 <efi_setup_gop+0x467>
  8d7be3:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d7bea:	00 
  8d7beb:	89 da                	mov    %ebx,%edx
  8d7bed:	4c 89 fe             	mov    %r15,%rsi
  8d7bf0:	31 c0                	xor    %eax,%eax
  8d7bf2:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d7bf9:	00 
  8d7bfa:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
  8d7bff:	41 8b 3f             	mov    (%r15),%edi
  8d7c02:	e8 79 d1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7c07:	48 85 c0             	test   %rax,%rax
  8d7c0a:	75 af                	jne    8d7bbb <efi_setup_gop+0x41b>
  8d7c0c:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d7c11:	8b 41 0c             	mov    0xc(%rcx),%eax
  8d7c14:	48 8b 69 10          	mov    0x10(%rcx),%rbp
  8d7c18:	89 44 24 08          	mov    %eax,0x8(%rsp)
  8d7c1c:	48 8b 41 18          	mov    0x18(%rcx),%rax
  8d7c20:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d7c25:	8b 41 04             	mov    0x4(%rcx),%eax
  8d7c28:	89 44 24 28          	mov    %eax,0x28(%rsp)
  8d7c2c:	8b 41 08             	mov    0x8(%rcx),%eax
  8d7c2f:	89 44 24 34          	mov    %eax,0x34(%rsp)
  8d7c33:	48 8b 05 c6 bf 01 00 	mov    0x1bfc6(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7c3a:	45 84 f6             	test   %r14b,%r14b
  8d7c3d:	74 11                	je     8d7c50 <efi_setup_gop+0x4b0>
  8d7c3f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7c43:	48 83 ec 20          	sub    $0x20,%rsp
  8d7c47:	ff 50 48             	callq  *0x48(%rax)
  8d7c4a:	48 83 c4 20          	add    $0x20,%rsp
  8d7c4e:	eb 10                	jmp    8d7c60 <efi_setup_gop+0x4c0>
  8d7c50:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7c53:	48 89 ce             	mov    %rcx,%rsi
  8d7c56:	8b 78 30             	mov    0x30(%rax),%edi
  8d7c59:	31 c0                	xor    %eax,%eax
  8d7c5b:	e8 20 d1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7c60:	83 7c 24 08 02       	cmpl   $0x2,0x8(%rsp)
  8d7c65:	0f 8f 50 ff ff ff    	jg     8d7bbb <efi_setup_gop+0x41b>
  8d7c6b:	8b 44 24 28          	mov    0x28(%rsp),%eax
  8d7c6f:	3b 05 ff 45 00 00    	cmp    0x45ff(%rip),%eax        # 8dc274 <cmdline+0x4>
  8d7c75:	0f 85 40 ff ff ff    	jne    8d7bbb <efi_setup_gop+0x41b>
  8d7c7b:	8b 44 24 34          	mov    0x34(%rsp),%eax
  8d7c7f:	3b 05 f3 45 00 00    	cmp    0x45f3(%rip),%eax        # 8dc278 <cmdline+0x8>
  8d7c85:	0f 85 30 ff ff ff    	jne    8d7bbb <efi_setup_gop+0x41b>
  8d7c8b:	8b 05 eb 45 00 00    	mov    0x45eb(%rip),%eax        # 8dc27c <cmdline+0xc>
  8d7c91:	85 c0                	test   %eax,%eax
  8d7c93:	78 0a                	js     8d7c9f <efi_setup_gop+0x4ff>
  8d7c95:	39 44 24 08          	cmp    %eax,0x8(%rsp)
  8d7c99:	0f 85 1c ff ff ff    	jne    8d7bbb <efi_setup_gop+0x41b>
  8d7c9f:	8a 0d db 45 00 00    	mov    0x45db(%rip),%cl        # 8dc280 <cmdline+0x10>
  8d7ca5:	84 c9                	test   %cl,%cl
  8d7ca7:	74 27                	je     8d7cd0 <efi_setup_gop+0x530>
  8d7ca9:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  8d7cae:	8b 7c 24 08          	mov    0x8(%rsp),%edi
  8d7cb2:	48 89 ee             	mov    %rbp,%rsi
  8d7cb5:	e8 0f f8 ff ff       	callq  8d74c9 <pixel_bpp>
  8d7cba:	38 c1                	cmp    %al,%cl
  8d7cbc:	0f 85 f9 fe ff ff    	jne    8d7bbb <efi_setup_gop+0x41b>
  8d7cc2:	eb 0c                	jmp    8d7cd0 <efi_setup_gop+0x530>
  8d7cc4:	48 8d 3d 5e 40 00 00 	lea    0x405e(%rip),%rdi        # 8dbd29 <kernel_info_end+0xb99>
  8d7ccb:	e9 f4 fd ff ff       	jmpq   8d7ac4 <efi_setup_gop+0x324>
  8d7cd0:	41 89 dc             	mov    %ebx,%r12d
  8d7cd3:	e9 68 03 00 00       	jmpq   8d8040 <efi_setup_gop+0x8a0>
  8d7cd8:	45 84 f6             	test   %r14b,%r14b
  8d7cdb:	74 17                	je     8d7cf4 <efi_setup_gop+0x554>
  8d7cdd:	49 8b 47 18          	mov    0x18(%r15),%rax
  8d7ce1:	8b 58 04             	mov    0x4(%rax),%ebx
  8d7ce4:	89 5c 24 10          	mov    %ebx,0x10(%rsp)
  8d7ce8:	8b 18                	mov    (%rax),%ebx
  8d7cea:	48 8b 40 08          	mov    0x8(%rax),%rax
  8d7cee:	89 5c 24 34          	mov    %ebx,0x34(%rsp)
  8d7cf2:	eb 14                	jmp    8d7d08 <efi_setup_gop+0x568>
  8d7cf4:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8d7cf8:	8b 58 04             	mov    0x4(%rax),%ebx
  8d7cfb:	89 5c 24 10          	mov    %ebx,0x10(%rsp)
  8d7cff:	8b 18                	mov    (%rax),%ebx
  8d7d01:	8b 40 08             	mov    0x8(%rax),%eax
  8d7d04:	89 5c 24 34          	mov    %ebx,0x34(%rsp)
  8d7d08:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  8d7d0d:	8b 50 04             	mov    0x4(%rax),%edx
  8d7d10:	0f af 50 08          	imul   0x8(%rax),%edx
  8d7d14:	48 8b 58 18          	mov    0x18(%rax),%rbx
  8d7d18:	48 8b 68 10          	mov    0x10(%rax),%rbp
  8d7d1c:	8b 78 0c             	mov    0xc(%rax),%edi
  8d7d1f:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
  8d7d24:	89 54 24 08          	mov    %edx,0x8(%rsp)
  8d7d28:	48 89 ee             	mov    %rbp,%rsi
  8d7d2b:	48 89 da             	mov    %rbx,%rdx
  8d7d2e:	31 db                	xor    %ebx,%ebx
  8d7d30:	e8 94 f7 ff ff       	callq  8d74c9 <pixel_bpp>
  8d7d35:	44 8b 64 24 10       	mov    0x10(%rsp),%r12d
  8d7d3a:	88 44 24 28          	mov    %al,0x28(%rsp)
  8d7d3e:	48 8d 44 24 68       	lea    0x68(%rsp),%rax
  8d7d43:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8d7d48:	3b 5c 24 34          	cmp    0x34(%rsp),%ebx
  8d7d4c:	0f 84 ee 02 00 00    	je     8d8040 <efi_setup_gop+0x8a0>
  8d7d52:	3b 5c 24 10          	cmp    0x10(%rsp),%ebx
  8d7d56:	0f 84 e3 00 00 00    	je     8d7e3f <efi_setup_gop+0x69f>
  8d7d5c:	45 84 f6             	test   %r14b,%r14b
  8d7d5f:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  8d7d64:	74 1a                	je     8d7d80 <efi_setup_gop+0x5e0>
  8d7d66:	48 83 ec 20          	sub    $0x20,%rsp
  8d7d6a:	49 89 c8             	mov    %rcx,%r8
  8d7d6d:	89 da                	mov    %ebx,%edx
  8d7d6f:	4c 89 f9             	mov    %r15,%rcx
  8d7d72:	4c 8b 4c 24 58       	mov    0x58(%rsp),%r9
  8d7d77:	41 ff 17             	callq  *(%r15)
  8d7d7a:	48 83 c4 20          	add    $0x20,%rsp
  8d7d7e:	eb 24                	jmp    8d7da4 <efi_setup_gop+0x604>
  8d7d80:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d7d87:	00 
  8d7d88:	89 da                	mov    %ebx,%edx
  8d7d8a:	4c 89 fe             	mov    %r15,%rsi
  8d7d8d:	31 c0                	xor    %eax,%eax
  8d7d8f:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d7d96:	00 
  8d7d97:	4c 8b 44 24 38       	mov    0x38(%rsp),%r8
  8d7d9c:	41 8b 3f             	mov    (%r15),%edi
  8d7d9f:	e8 dc cf ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7da4:	48 85 c0             	test   %rax,%rax
  8d7da7:	0f 85 92 00 00 00    	jne    8d7e3f <efi_setup_gop+0x69f>
  8d7dad:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d7db2:	8b 41 0c             	mov    0xc(%rcx),%eax
  8d7db5:	48 8b 69 10          	mov    0x10(%rcx),%rbp
  8d7db9:	89 44 24 20          	mov    %eax,0x20(%rsp)
  8d7dbd:	48 8b 41 18          	mov    0x18(%rcx),%rax
  8d7dc1:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d7dc6:	8b 41 04             	mov    0x4(%rcx),%eax
  8d7dc9:	89 44 24 40          	mov    %eax,0x40(%rsp)
  8d7dcd:	8b 41 08             	mov    0x8(%rcx),%eax
  8d7dd0:	89 44 24 44          	mov    %eax,0x44(%rsp)
  8d7dd4:	48 8b 05 25 be 01 00 	mov    0x1be25(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7ddb:	45 84 f6             	test   %r14b,%r14b
  8d7dde:	74 11                	je     8d7df1 <efi_setup_gop+0x651>
  8d7de0:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7de4:	48 83 ec 20          	sub    $0x20,%rsp
  8d7de8:	ff 50 48             	callq  *0x48(%rax)
  8d7deb:	48 83 c4 20          	add    $0x20,%rsp
  8d7def:	eb 10                	jmp    8d7e01 <efi_setup_gop+0x661>
  8d7df1:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7df4:	48 89 ce             	mov    %rcx,%rsi
  8d7df7:	8b 78 30             	mov    0x30(%rax),%edi
  8d7dfa:	31 c0                	xor    %eax,%eax
  8d7dfc:	e8 7f cf ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7e01:	83 7c 24 20 02       	cmpl   $0x2,0x20(%rsp)
  8d7e06:	7f 37                	jg     8d7e3f <efi_setup_gop+0x69f>
  8d7e08:	8b 4c 24 40          	mov    0x40(%rsp),%ecx
  8d7e0c:	0f af 4c 24 44       	imul   0x44(%rsp),%ecx
  8d7e11:	3b 4c 24 08          	cmp    0x8(%rsp),%ecx
  8d7e15:	72 28                	jb     8d7e3f <efi_setup_gop+0x69f>
  8d7e17:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d7e1c:	8b 7c 24 20          	mov    0x20(%rsp),%edi
  8d7e20:	48 89 ee             	mov    %rbp,%rsi
  8d7e23:	e8 a1 f6 ff ff       	callq  8d74c9 <pixel_bpp>
  8d7e28:	3b 4c 24 08          	cmp    0x8(%rsp),%ecx
  8d7e2c:	77 06                	ja     8d7e34 <efi_setup_gop+0x694>
  8d7e2e:	3a 44 24 28          	cmp    0x28(%rsp),%al
  8d7e32:	76 0b                	jbe    8d7e3f <efi_setup_gop+0x69f>
  8d7e34:	88 44 24 28          	mov    %al,0x28(%rsp)
  8d7e38:	41 89 dc             	mov    %ebx,%r12d
  8d7e3b:	89 4c 24 08          	mov    %ecx,0x8(%rsp)
  8d7e3f:	ff c3                	inc    %ebx
  8d7e41:	e9 02 ff ff ff       	jmpq   8d7d48 <efi_setup_gop+0x5a8>
  8d7e46:	45 84 f6             	test   %r14b,%r14b
  8d7e49:	74 06                	je     8d7e51 <efi_setup_gop+0x6b1>
  8d7e4b:	49 8b 47 18          	mov    0x18(%r15),%rax
  8d7e4f:	eb 04                	jmp    8d7e55 <efi_setup_gop+0x6b5>
  8d7e51:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8d7e55:	44 8b 60 04          	mov    0x4(%rax),%r12d
  8d7e59:	8b 00                	mov    (%rax),%eax
  8d7e5b:	48 8d 3d ee 3e 00 00 	lea    0x3eee(%rip),%rdi        # 8dbd50 <kernel_info_end+0xbc0>
  8d7e62:	31 db                	xor    %ebx,%ebx
  8d7e64:	89 44 24 08          	mov    %eax,0x8(%rsp)
  8d7e68:	8b 44 24 08          	mov    0x8(%rsp),%eax
  8d7e6c:	8d 70 ff             	lea    -0x1(%rax),%esi
  8d7e6f:	31 c0                	xor    %eax,%eax
  8d7e71:	e8 56 e3 ff ff       	callq  8d61cc <efi_printk>
  8d7e76:	48 8d 3d f6 3e 00 00 	lea    0x3ef6(%rip),%rdi        # 8dbd73 <kernel_info_end+0xbe3>
  8d7e7d:	e8 27 e2 ff ff       	callq  8d60a9 <efi_puts>
  8d7e82:	39 5c 24 08          	cmp    %ebx,0x8(%rsp)
  8d7e86:	0f 84 3b 01 00 00    	je     8d7fc7 <efi_setup_gop+0x827>
  8d7e8c:	45 84 f6             	test   %r14b,%r14b
  8d7e8f:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d7e94:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
  8d7e99:	74 18                	je     8d7eb3 <efi_setup_gop+0x713>
  8d7e9b:	48 83 ec 20          	sub    $0x20,%rsp
  8d7e9f:	4d 89 c1             	mov    %r8,%r9
  8d7ea2:	89 da                	mov    %ebx,%edx
  8d7ea4:	49 89 c8             	mov    %rcx,%r8
  8d7ea7:	4c 89 f9             	mov    %r15,%rcx
  8d7eaa:	41 ff 17             	callq  *(%r15)
  8d7ead:	48 83 c4 20          	add    $0x20,%rsp
  8d7eb1:	eb 1f                	jmp    8d7ed2 <efi_setup_gop+0x732>
  8d7eb3:	c7 44 24 6c 00 00 00 	movl   $0x0,0x6c(%rsp)
  8d7eba:	00 
  8d7ebb:	89 da                	mov    %ebx,%edx
  8d7ebd:	4c 89 fe             	mov    %r15,%rsi
  8d7ec0:	31 c0                	xor    %eax,%eax
  8d7ec2:	c7 44 24 74 00 00 00 	movl   $0x0,0x74(%rsp)
  8d7ec9:	00 
  8d7eca:	41 8b 3f             	mov    (%r15),%edi
  8d7ecd:	e8 ae ce ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7ed2:	48 85 c0             	test   %rax,%rax
  8d7ed5:	0f 85 e5 00 00 00    	jne    8d7fc0 <efi_setup_gop+0x820>
  8d7edb:	48 8b 4c 24 68       	mov    0x68(%rsp),%rcx
  8d7ee0:	48 8b 41 10          	mov    0x10(%rcx),%rax
  8d7ee4:	8b 69 0c             	mov    0xc(%rcx),%ebp
  8d7ee7:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d7eec:	48 8b 41 18          	mov    0x18(%rcx),%rax
  8d7ef0:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d7ef5:	8b 41 04             	mov    0x4(%rcx),%eax
  8d7ef8:	89 44 24 10          	mov    %eax,0x10(%rsp)
  8d7efc:	8b 41 08             	mov    0x8(%rcx),%eax
  8d7eff:	89 44 24 18          	mov    %eax,0x18(%rsp)
  8d7f03:	48 8b 05 f6 bc 01 00 	mov    0x1bcf6(%rip),%rax        # 8f3c00 <efi_system_table>
  8d7f0a:	45 84 f6             	test   %r14b,%r14b
  8d7f0d:	74 11                	je     8d7f20 <efi_setup_gop+0x780>
  8d7f0f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d7f13:	48 83 ec 20          	sub    $0x20,%rsp
  8d7f17:	ff 50 48             	callq  *0x48(%rax)
  8d7f1a:	48 83 c4 20          	add    $0x20,%rsp
  8d7f1e:	eb 10                	jmp    8d7f30 <efi_setup_gop+0x790>
  8d7f20:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d7f23:	48 89 ce             	mov    %rcx,%rsi
  8d7f26:	8b 78 30             	mov    0x30(%rax),%edi
  8d7f29:	31 c0                	xor    %eax,%eax
  8d7f2b:	e8 50 ce ff ff       	callq  8d4d80 <__efi64_thunk>
  8d7f30:	83 fd 02             	cmp    $0x2,%ebp
  8d7f33:	74 34                	je     8d7f69 <efi_setup_gop+0x7c9>
  8d7f35:	7f 19                	jg     8d7f50 <efi_setup_gop+0x7b0>
  8d7f37:	48 8d 35 67 3d 00 00 	lea    0x3d67(%rip),%rsi        # 8dbca5 <kernel_info_end+0xb15>
  8d7f3e:	31 c0                	xor    %eax,%eax
  8d7f40:	85 ed                	test   %ebp,%ebp
  8d7f42:	74 40                	je     8d7f84 <efi_setup_gop+0x7e4>
  8d7f44:	83 fd 01             	cmp    $0x1,%ebp
  8d7f47:	48 8d 35 5b 3d 00 00 	lea    0x3d5b(%rip),%rsi        # 8dbca9 <kernel_info_end+0xb19>
  8d7f4e:	eb 0a                	jmp    8d7f5a <efi_setup_gop+0x7ba>
  8d7f50:	83 fd 03             	cmp    $0x3,%ebp
  8d7f53:	48 8d 35 61 3d 00 00 	lea    0x3d61(%rip),%rsi        # 8dbcbb <kernel_info_end+0xb2b>
  8d7f5a:	48 8d 05 56 3d 00 00 	lea    0x3d56(%rip),%rax        # 8dbcb7 <kernel_info_end+0xb27>
  8d7f61:	48 0f 45 f0          	cmovne %rax,%rsi
  8d7f65:	31 c0                	xor    %eax,%eax
  8d7f67:	eb 1b                	jmp    8d7f84 <efi_setup_gop+0x7e4>
  8d7f69:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8d7f6e:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d7f73:	bf 02 00 00 00       	mov    $0x2,%edi
  8d7f78:	e8 4c f5 ff ff       	callq  8d74c9 <pixel_bpp>
  8d7f7d:	48 8d 35 a8 36 00 00 	lea    0x36a8(%rip),%rsi        # 8db62c <kernel_info_end+0x49c>
  8d7f84:	bf 20 00 00 00       	mov    $0x20,%edi
  8d7f89:	0f b6 c0             	movzbl %al,%eax
  8d7f8c:	83 fd 02             	cmp    $0x2,%ebp
  8d7f8f:	b9 2d 00 00 00       	mov    $0x2d,%ecx
  8d7f94:	50                   	push   %rax
  8d7f95:	0f 4e cf             	cmovle %edi,%ecx
  8d7f98:	ba 2a 00 00 00       	mov    $0x2a,%edx
  8d7f9d:	44 39 e3             	cmp    %r12d,%ebx
  8d7fa0:	56                   	push   %rsi
  8d7fa1:	0f 45 d7             	cmovne %edi,%edx
  8d7fa4:	44 8b 4c 24 28       	mov    0x28(%rsp),%r9d
  8d7fa9:	89 de                	mov    %ebx,%esi
  8d7fab:	44 8b 44 24 20       	mov    0x20(%rsp),%r8d
  8d7fb0:	48 8d 3d e4 3d 00 00 	lea    0x3de4(%rip),%rdi        # 8dbd9b <kernel_info_end+0xc0b>
  8d7fb7:	31 c0                	xor    %eax,%eax
  8d7fb9:	e8 0e e2 ff ff       	callq  8d61cc <efi_printk>
  8d7fbe:	58                   	pop    %rax
  8d7fbf:	5a                   	pop    %rdx
  8d7fc0:	ff c3                	inc    %ebx
  8d7fc2:	e9 bb fe ff ff       	jmpq   8d7e82 <efi_setup_gop+0x6e2>
  8d7fc7:	48 8d 3d f7 3d 00 00 	lea    0x3df7(%rip),%rdi        # 8dbdc5 <kernel_info_end+0xc35>
  8d7fce:	e8 d6 e0 ff ff       	callq  8d60a9 <efi_puts>
  8d7fd3:	bf 80 96 98 00       	mov    $0x989680,%edi
  8d7fd8:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
  8d7fdd:	e8 cb ed ff ff       	callq  8d6dad <efi_wait_for_key>
  8d7fe2:	48 85 c0             	test   %rax,%rax
  8d7fe5:	74 59                	je     8d8040 <efi_setup_gop+0x8a0>
  8d7fe7:	48 ba 12 00 00 00 00 	movabs $0x8000000000000012,%rdx
  8d7fee:	00 00 80 
  8d7ff1:	48 39 d0             	cmp    %rdx,%rax
  8d7ff4:	74 4a                	je     8d8040 <efi_setup_gop+0x8a0>
  8d7ff6:	31 c0                	xor    %eax,%eax
  8d7ff8:	48 8d 3d f7 3d 00 00 	lea    0x3df7(%rip),%rdi        # 8dbdf6 <kernel_info_end+0xc66>
  8d7fff:	e8 c8 e1 ff ff       	callq  8d61cc <efi_printk>
  8d8004:	45 84 f6             	test   %r14b,%r14b
  8d8007:	48 8b 05 f2 bb 01 00 	mov    0x1bbf2(%rip),%rax        # 8f3c00 <efi_system_table>
  8d800e:	74 19                	je     8d8029 <efi_setup_gop+0x889>
  8d8010:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8014:	48 83 ec 20          	sub    $0x20,%rsp
  8d8018:	b9 80 96 98 00       	mov    $0x989680,%ecx
  8d801d:	ff 90 f8 00 00 00    	callq  *0xf8(%rax)
  8d8023:	48 83 c4 20          	add    $0x20,%rsp
  8d8027:	eb 17                	jmp    8d8040 <efi_setup_gop+0x8a0>
  8d8029:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d802c:	be 80 96 98 00       	mov    $0x989680,%esi
  8d8031:	8b b8 88 00 00 00    	mov    0x88(%rax),%edi
  8d8037:	31 c0                	xor    %eax,%eax
  8d8039:	e8 42 cd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d803e:	eb 19                	jmp    8d8059 <efi_setup_gop+0x8b9>
  8d8040:	45 84 f6             	test   %r14b,%r14b
  8d8043:	74 14                	je     8d8059 <efi_setup_gop+0x8b9>
  8d8045:	49 8b 47 18          	mov    0x18(%r15),%rax
  8d8049:	44 39 60 04          	cmp    %r12d,0x4(%rax)
  8d804d:	75 16                	jne    8d8065 <efi_setup_gop+0x8c5>
  8d804f:	49 8b 47 18          	mov    0x18(%r15),%rax
  8d8053:	48 8b 50 08          	mov    0x8(%rax),%rdx
  8d8057:	eb 57                	jmp    8d80b0 <efi_setup_gop+0x910>
  8d8059:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8d805d:	44 39 60 04          	cmp    %r12d,0x4(%rax)
  8d8061:	75 29                	jne    8d808c <efi_setup_gop+0x8ec>
  8d8063:	eb 44                	jmp    8d80a9 <efi_setup_gop+0x909>
  8d8065:	48 83 ec 20          	sub    $0x20,%rsp
  8d8069:	44 89 e2             	mov    %r12d,%edx
  8d806c:	4c 89 f9             	mov    %r15,%rcx
  8d806f:	41 ff 57 08          	callq  *0x8(%r15)
  8d8073:	48 83 c4 20          	add    $0x20,%rsp
  8d8077:	48 85 c0             	test   %rax,%rax
  8d807a:	74 d3                	je     8d804f <efi_setup_gop+0x8af>
  8d807c:	48 8d 3d aa 3d 00 00 	lea    0x3daa(%rip),%rdi        # 8dbe2d <kernel_info_end+0xc9d>
  8d8083:	31 c0                	xor    %eax,%eax
  8d8085:	e8 42 e1 ff ff       	callq  8d61cc <efi_printk>
  8d808a:	eb 18                	jmp    8d80a4 <efi_setup_gop+0x904>
  8d808c:	41 8b 7f 04          	mov    0x4(%r15),%edi
  8d8090:	31 c0                	xor    %eax,%eax
  8d8092:	44 89 e2             	mov    %r12d,%edx
  8d8095:	4c 89 fe             	mov    %r15,%rsi
  8d8098:	e8 e3 cc ff ff       	callq  8d4d80 <__efi64_thunk>
  8d809d:	48 85 c0             	test   %rax,%rax
  8d80a0:	74 07                	je     8d80a9 <efi_setup_gop+0x909>
  8d80a2:	eb d8                	jmp    8d807c <efi_setup_gop+0x8dc>
  8d80a4:	45 84 f6             	test   %r14b,%r14b
  8d80a7:	75 a6                	jne    8d804f <efi_setup_gop+0x8af>
  8d80a9:	41 8b 47 0c          	mov    0xc(%r15),%eax
  8d80ad:	8b 50 08             	mov    0x8(%rax),%edx
  8d80b0:	41 c6 45 0f 70       	movb   $0x70,0xf(%r13)
  8d80b5:	8b 4a 04             	mov    0x4(%rdx),%ecx
  8d80b8:	66 41 89 4d 12       	mov    %cx,0x12(%r13)
  8d80bd:	8b 4a 08             	mov    0x8(%rdx),%ecx
  8d80c0:	66 41 89 4d 14       	mov    %cx,0x14(%r13)
  8d80c5:	45 84 f6             	test   %r14b,%r14b
  8d80c8:	74 06                	je     8d80d0 <efi_setup_gop+0x930>
  8d80ca:	48 8b 40 18          	mov    0x18(%rax),%rax
  8d80ce:	eb 04                	jmp    8d80d4 <efi_setup_gop+0x934>
  8d80d0:	48 8b 40 10          	mov    0x10(%rax),%rax
  8d80d4:	41 89 45 18          	mov    %eax,0x18(%r13)
  8d80d8:	48 c1 e8 20          	shr    $0x20,%rax
  8d80dc:	41 89 45 3a          	mov    %eax,0x3a(%r13)
  8d80e0:	74 05                	je     8d80e7 <efi_setup_gop+0x947>
  8d80e2:	41 83 4d 36 02       	orl    $0x2,0x36(%r13)
  8d80e7:	66 41 c7 45 32 01 00 	movw   $0x1,0x32(%r13)
  8d80ee:	8b 42 0c             	mov    0xc(%rdx),%eax
  8d80f1:	8b 4a 20             	mov    0x20(%rdx),%ecx
  8d80f4:	83 f8 02             	cmp    $0x2,%eax
  8d80f7:	75 79                	jne    8d8172 <efi_setup_gop+0x9d2>
  8d80f9:	4d 8d 5d 26          	lea    0x26(%r13),%r11
  8d80fd:	8b 7a 10             	mov    0x10(%rdx),%edi
  8d8100:	44 8b 52 14          	mov    0x14(%rdx),%r10d
  8d8104:	49 8d 75 27          	lea    0x27(%r13),%rsi
  8d8108:	44 8b 4a 18          	mov    0x18(%rdx),%r9d
  8d810c:	44 8b 42 1c          	mov    0x1c(%rdx),%r8d
  8d8110:	4c 89 da             	mov    %r11,%rdx
  8d8113:	e8 0f f4 ff ff       	callq  8d7527 <find_bits>
  8d8118:	49 8d 55 28          	lea    0x28(%r13),%rdx
  8d811c:	49 8d 75 29          	lea    0x29(%r13),%rsi
  8d8120:	44 89 d7             	mov    %r10d,%edi
  8d8123:	e8 ff f3 ff ff       	callq  8d7527 <find_bits>
  8d8128:	49 8d 55 2a          	lea    0x2a(%r13),%rdx
  8d812c:	49 8d 75 2b          	lea    0x2b(%r13),%rsi
  8d8130:	44 89 cf             	mov    %r9d,%edi
  8d8133:	e8 ef f3 ff ff       	callq  8d7527 <find_bits>
  8d8138:	49 8d 55 2c          	lea    0x2c(%r13),%rdx
  8d813c:	49 8d 75 2d          	lea    0x2d(%r13),%rsi
  8d8140:	44 89 c7             	mov    %r8d,%edi
  8d8143:	e8 df f3 ff ff       	callq  8d7527 <find_bits>
  8d8148:	41 0f b6 45 28       	movzbl 0x28(%r13),%eax
  8d814d:	41 0f b6 55 26       	movzbl 0x26(%r13),%edx
  8d8152:	01 c2                	add    %eax,%edx
  8d8154:	41 0f b6 45 2a       	movzbl 0x2a(%r13),%eax
  8d8159:	01 c2                	add    %eax,%edx
  8d815b:	41 0f b6 45 2c       	movzbl 0x2c(%r13),%eax
  8d8160:	01 d0                	add    %edx,%eax
  8d8162:	66 41 89 45 16       	mov    %ax,0x16(%r13)
  8d8167:	0f b7 c0             	movzwl %ax,%eax
  8d816a:	0f af c1             	imul   %ecx,%eax
  8d816d:	c1 e8 03             	shr    $0x3,%eax
  8d8170:	eb 40                	jmp    8d81b2 <efi_setup_gop+0xa12>
  8d8172:	85 c0                	test   %eax,%eax
  8d8174:	75 0c                	jne    8d8182 <efi_setup_gop+0x9e2>
  8d8176:	41 c6 45 27 00       	movb   $0x0,0x27(%r13)
  8d817b:	41 c6 45 2b 10       	movb   $0x10,0x2b(%r13)
  8d8180:	eb 0a                	jmp    8d818c <efi_setup_gop+0x9ec>
  8d8182:	41 c6 45 2b 00       	movb   $0x0,0x2b(%r13)
  8d8187:	41 c6 45 27 10       	movb   $0x10,0x27(%r13)
  8d818c:	66 41 c7 45 2c 08 18 	movw   $0x1808,0x2c(%r13)
  8d8193:	8d 04 8d 00 00 00 00 	lea    0x0(,%rcx,4),%eax
  8d819a:	66 41 c7 45 28 08 08 	movw   $0x808,0x28(%r13)
  8d81a1:	41 c6 45 2a 08       	movb   $0x8,0x2a(%r13)
  8d81a6:	41 c6 45 26 08       	movb   $0x8,0x26(%r13)
  8d81ab:	66 41 c7 45 16 20 00 	movw   $0x20,0x16(%r13)
  8d81b2:	66 41 89 45 24       	mov    %ax,0x24(%r13)
  8d81b7:	41 0f b7 55 14       	movzwl 0x14(%r13),%edx
  8d81bc:	45 31 e4             	xor    %r12d,%r12d
  8d81bf:	41 0f b7 45 24       	movzwl 0x24(%r13),%eax
  8d81c4:	41 83 4d 36 01       	orl    $0x1,0x36(%r13)
  8d81c9:	0f af c2             	imul   %edx,%eax
  8d81cc:	41 89 45 1c          	mov    %eax,0x1c(%r13)
  8d81d0:	45 84 f6             	test   %r14b,%r14b
  8d81d3:	74 1d                	je     8d81f2 <efi_setup_gop+0xa52>
  8d81d5:	48 8b 05 24 ba 01 00 	mov    0x1ba24(%rip),%rax        # 8f3c00 <efi_system_table>
  8d81dc:	48 83 ec 20          	sub    $0x20,%rsp
  8d81e0:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
  8d81e5:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d81e9:	ff 50 48             	callq  *0x48(%rax)
  8d81ec:	48 83 c4 20          	add    $0x20,%rsp
  8d81f0:	eb 19                	jmp    8d820b <efi_setup_gop+0xa6b>
  8d81f2:	48 8b 05 07 ba 01 00 	mov    0x1ba07(%rip),%rax        # 8f3c00 <efi_system_table>
  8d81f9:	48 8b 74 24 58       	mov    0x58(%rsp),%rsi
  8d81fe:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8201:	8b 78 30             	mov    0x30(%rax),%edi
  8d8204:	31 c0                	xor    %eax,%eax
  8d8206:	e8 75 cb ff ff       	callq  8d4d80 <__efi64_thunk>
  8d820b:	48 81 c4 88 00 00 00 	add    $0x88,%rsp
  8d8212:	4c 89 e0             	mov    %r12,%rax
  8d8215:	5b                   	pop    %rbx
  8d8216:	5d                   	pop    %rbp
  8d8217:	41 5c                	pop    %r12
  8d8219:	41 5d                	pop    %r13
  8d821b:	41 5e                	pop    %r14
  8d821d:	41 5f                	pop    %r15
  8d821f:	c3                   	retq   

00000000008d8220 <get_option>:
  8d8220:	f3 0f 1e fa          	endbr64 
  8d8224:	41 54                	push   %r12
  8d8226:	55                   	push   %rbp
  8d8227:	53                   	push   %rbx
  8d8228:	48 8b 2f             	mov    (%rdi),%rbp
  8d822b:	48 85 ed             	test   %rbp,%rbp
  8d822e:	75 04                	jne    8d8234 <get_option+0x14>
  8d8230:	31 c0                	xor    %eax,%eax
  8d8232:	eb 63                	jmp    8d8297 <get_option+0x77>
  8d8234:	8a 45 00             	mov    0x0(%rbp),%al
  8d8237:	84 c0                	test   %al,%al
  8d8239:	74 f5                	je     8d8230 <get_option+0x10>
  8d823b:	48 89 fb             	mov    %rdi,%rbx
  8d823e:	49 89 f4             	mov    %rsi,%r12
  8d8241:	3c 2d                	cmp    $0x2d,%al
  8d8243:	75 14                	jne    8d8259 <get_option+0x39>
  8d8245:	48 ff c5             	inc    %rbp
  8d8248:	48 89 fe             	mov    %rdi,%rsi
  8d824b:	31 d2                	xor    %edx,%edx
  8d824d:	48 89 ef             	mov    %rbp,%rdi
  8d8250:	e8 eb ab ff ff       	callq  8d2e40 <simple_strtoull>
  8d8255:	f7 d8                	neg    %eax
  8d8257:	eb 0d                	jmp    8d8266 <get_option+0x46>
  8d8259:	48 89 fe             	mov    %rdi,%rsi
  8d825c:	31 d2                	xor    %edx,%edx
  8d825e:	48 89 ef             	mov    %rbp,%rdi
  8d8261:	e8 da ab ff ff       	callq  8d2e40 <simple_strtoull>
  8d8266:	4d 85 e4             	test   %r12,%r12
  8d8269:	74 04                	je     8d826f <get_option+0x4f>
  8d826b:	41 89 04 24          	mov    %eax,(%r12)
  8d826f:	48 8b 03             	mov    (%rbx),%rax
  8d8272:	48 39 e8             	cmp    %rbp,%rax
  8d8275:	74 b9                	je     8d8230 <get_option+0x10>
  8d8277:	8a 10                	mov    (%rax),%dl
  8d8279:	80 fa 2c             	cmp    $0x2c,%dl
  8d827c:	75 0d                	jne    8d828b <get_option+0x6b>
  8d827e:	48 ff c0             	inc    %rax
  8d8281:	48 89 03             	mov    %rax,(%rbx)
  8d8284:	b8 02 00 00 00       	mov    $0x2,%eax
  8d8289:	eb 0c                	jmp    8d8297 <get_option+0x77>
  8d828b:	31 c0                	xor    %eax,%eax
  8d828d:	80 fa 2d             	cmp    $0x2d,%dl
  8d8290:	0f 94 c0             	sete   %al
  8d8293:	8d 44 00 01          	lea    0x1(%rax,%rax,1),%eax
  8d8297:	5b                   	pop    %rbx
  8d8298:	5d                   	pop    %rbp
  8d8299:	41 5c                	pop    %r12
  8d829b:	c3                   	retq   

00000000008d829c <get_options>:
  8d829c:	f3 0f 1e fa          	endbr64 
  8d82a0:	41 57                	push   %r15
  8d82a2:	41 56                	push   %r14
  8d82a4:	41 55                	push   %r13
  8d82a6:	41 54                	push   %r12
  8d82a8:	49 89 d4             	mov    %rdx,%r12
  8d82ab:	55                   	push   %rbp
  8d82ac:	89 f5                	mov    %esi,%ebp
  8d82ae:	53                   	push   %rbx
  8d82af:	bb 01 00 00 00       	mov    $0x1,%ebx
  8d82b4:	48 83 ec 18          	sub    $0x18,%rsp
  8d82b8:	85 f6                	test   %esi,%esi
  8d82ba:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d82bf:	0f 94 44 24 07       	sete   0x7(%rsp)
  8d82c4:	39 eb                	cmp    %ebp,%ebx
  8d82c6:	7d 7c                	jge    8d8344 <get_options+0xa8>
  8d82c8:	4d 89 e7             	mov    %r12,%r15
  8d82cb:	85 ed                	test   %ebp,%ebp
  8d82cd:	74 07                	je     8d82d6 <get_options+0x3a>
  8d82cf:	48 63 c3             	movslq %ebx,%rax
  8d82d2:	4d 8d 3c 84          	lea    (%r12,%rax,4),%r15
  8d82d6:	48 8d 7c 24 08       	lea    0x8(%rsp),%rdi
  8d82db:	4c 89 fe             	mov    %r15,%rsi
  8d82de:	e8 3d ff ff ff       	callq  8d8220 <get_option>
  8d82e3:	41 89 c6             	mov    %eax,%r14d
  8d82e6:	85 c0                	test   %eax,%eax
  8d82e8:	74 65                	je     8d834f <get_options+0xb3>
  8d82ea:	83 f8 03             	cmp    $0x3,%eax
  8d82ed:	75 4c                	jne    8d833b <get_options+0x9f>
  8d82ef:	45 31 ed             	xor    %r13d,%r13d
  8d82f2:	85 ed                	test   %ebp,%ebp
  8d82f4:	74 06                	je     8d82fc <get_options+0x60>
  8d82f6:	41 89 ed             	mov    %ebp,%r13d
  8d82f9:	41 29 dd             	sub    %ebx,%r13d
  8d82fc:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d8301:	31 d2                	xor    %edx,%edx
  8d8303:	31 f6                	xor    %esi,%esi
  8d8305:	48 8d 78 01          	lea    0x1(%rax),%rdi
  8d8309:	48 89 7c 24 08       	mov    %rdi,0x8(%rsp)
  8d830e:	e8 fd ab ff ff       	callq  8d2f10 <simple_strtol>
  8d8313:	41 8b 3f             	mov    (%r15),%edi
  8d8316:	31 d2                	xor    %edx,%edx
  8d8318:	41 89 c0             	mov    %eax,%r8d
  8d831b:	29 f8                	sub    %edi,%eax
  8d831d:	8d 34 17             	lea    (%rdi,%rdx,1),%esi
  8d8320:	41 39 d5             	cmp    %edx,%r13d
  8d8323:	74 0e                	je     8d8333 <get_options+0x97>
  8d8325:	41 39 f0             	cmp    %esi,%r8d
  8d8328:	7e 09                	jle    8d8333 <get_options+0x97>
  8d832a:	41 89 34 97          	mov    %esi,(%r15,%rdx,4)
  8d832e:	48 ff c2             	inc    %rdx
  8d8331:	eb ea                	jmp    8d831d <get_options+0x81>
  8d8333:	85 c0                	test   %eax,%eax
  8d8335:	78 18                	js     8d834f <get_options+0xb3>
  8d8337:	8d 5c 03 ff          	lea    -0x1(%rbx,%rax,1),%ebx
  8d833b:	ff c3                	inc    %ebx
  8d833d:	41 ff ce             	dec    %r14d
  8d8340:	75 82                	jne    8d82c4 <get_options+0x28>
  8d8342:	eb 0b                	jmp    8d834f <get_options+0xb3>
  8d8344:	80 7c 24 07 00       	cmpb   $0x0,0x7(%rsp)
  8d8349:	0f 85 79 ff ff ff    	jne    8d82c8 <get_options+0x2c>
  8d834f:	ff cb                	dec    %ebx
  8d8351:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d8356:	41 89 1c 24          	mov    %ebx,(%r12)
  8d835a:	48 83 c4 18          	add    $0x18,%rsp
  8d835e:	5b                   	pop    %rbx
  8d835f:	5d                   	pop    %rbp
  8d8360:	41 5c                	pop    %r12
  8d8362:	41 5d                	pop    %r13
  8d8364:	41 5e                	pop    %r14
  8d8366:	41 5f                	pop    %r15
  8d8368:	c3                   	retq   

00000000008d8369 <memparse>:
  8d8369:	f3 0f 1e fa          	endbr64 
  8d836d:	53                   	push   %rbx
  8d836e:	31 d2                	xor    %edx,%edx
  8d8370:	48 89 f3             	mov    %rsi,%rbx
  8d8373:	48 83 ec 10          	sub    $0x10,%rsp
  8d8377:	48 8d 74 24 08       	lea    0x8(%rsp),%rsi
  8d837c:	e8 bf aa ff ff       	callq  8d2e40 <simple_strtoull>
  8d8381:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  8d8386:	8a 11                	mov    (%rcx),%dl
  8d8388:	80 fa 54             	cmp    $0x54,%dl
  8d838b:	7f 21                	jg     8d83ae <memparse+0x45>
  8d838d:	80 fa 44             	cmp    $0x44,%dl
  8d8390:	7e 41                	jle    8d83d3 <memparse+0x6a>
  8d8392:	83 ea 45             	sub    $0x45,%edx
  8d8395:	80 fa 0f             	cmp    $0xf,%dl
  8d8398:	77 39                	ja     8d83d3 <memparse+0x6a>
  8d839a:	48 8d 35 e7 2b 00 00 	lea    0x2be7(%rip),%rsi        # 8daf88 <initrd_dev_path+0x18>
  8d83a1:	0f b6 d2             	movzbl %dl,%edx
  8d83a4:	48 63 14 96          	movslq (%rsi,%rdx,4),%rdx
  8d83a8:	48 01 f2             	add    %rsi,%rdx
  8d83ab:	3e ff e2             	notrack jmpq *%rdx
  8d83ae:	83 ea 65             	sub    $0x65,%edx
  8d83b1:	eb e2                	jmp    8d8395 <memparse+0x2c>
  8d83b3:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83b7:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83bb:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83bf:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83c3:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83c7:	48 ff c1             	inc    %rcx
  8d83ca:	48 c1 e0 0a          	shl    $0xa,%rax
  8d83ce:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d83d3:	48 85 db             	test   %rbx,%rbx
  8d83d6:	74 08                	je     8d83e0 <memparse+0x77>
  8d83d8:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d83dd:	48 89 13             	mov    %rdx,(%rbx)
  8d83e0:	48 83 c4 10          	add    $0x10,%rsp
  8d83e4:	5b                   	pop    %rbx
  8d83e5:	c3                   	retq   

00000000008d83e6 <parse_option_str>:
  8d83e6:	f3 0f 1e fa          	endbr64 
  8d83ea:	55                   	push   %rbp
  8d83eb:	48 89 f5             	mov    %rsi,%rbp
  8d83ee:	53                   	push   %rbx
  8d83ef:	48 89 fb             	mov    %rdi,%rbx
  8d83f2:	51                   	push   %rcx
  8d83f3:	80 3b 00             	cmpb   $0x0,(%rbx)
  8d83f6:	74 4e                	je     8d8446 <parse_option_str+0x60>
  8d83f8:	48 89 ef             	mov    %rbp,%rdi
  8d83fb:	e8 30 ab ff ff       	callq  8d2f30 <strlen>
  8d8400:	48 89 ee             	mov    %rbp,%rsi
  8d8403:	48 89 df             	mov    %rbx,%rdi
  8d8406:	48 89 c2             	mov    %rax,%rdx
  8d8409:	e8 72 a9 ff ff       	callq  8d2d80 <strncmp>
  8d840e:	85 c0                	test   %eax,%eax
  8d8410:	75 25                	jne    8d8437 <parse_option_str+0x51>
  8d8412:	48 89 ef             	mov    %rbp,%rdi
  8d8415:	e8 16 ab ff ff       	callq  8d2f30 <strlen>
  8d841a:	48 01 c3             	add    %rax,%rbx
  8d841d:	8a 13                	mov    (%rbx),%dl
  8d841f:	84 d2                	test   %dl,%dl
  8d8421:	0f 94 c0             	sete   %al
  8d8424:	80 fa 2c             	cmp    $0x2c,%dl
  8d8427:	0f 94 c2             	sete   %dl
  8d842a:	08 d0                	or     %dl,%al
  8d842c:	74 09                	je     8d8437 <parse_option_str+0x51>
  8d842e:	eb 18                	jmp    8d8448 <parse_option_str+0x62>
  8d8430:	3c 2c                	cmp    $0x2c,%al
  8d8432:	74 0d                	je     8d8441 <parse_option_str+0x5b>
  8d8434:	48 ff c3             	inc    %rbx
  8d8437:	8a 03                	mov    (%rbx),%al
  8d8439:	84 c0                	test   %al,%al
  8d843b:	75 f3                	jne    8d8430 <parse_option_str+0x4a>
  8d843d:	3c 2c                	cmp    $0x2c,%al
  8d843f:	75 b2                	jne    8d83f3 <parse_option_str+0xd>
  8d8441:	48 ff c3             	inc    %rbx
  8d8444:	eb ad                	jmp    8d83f3 <parse_option_str+0xd>
  8d8446:	31 c0                	xor    %eax,%eax
  8d8448:	5a                   	pop    %rdx
  8d8449:	5b                   	pop    %rbx
  8d844a:	5d                   	pop    %rbp
  8d844b:	c3                   	retq   

00000000008d844c <next_arg>:
  8d844c:	f3 0f 1e fa          	endbr64 
  8d8450:	55                   	push   %rbp
  8d8451:	45 31 d2             	xor    %r10d,%r10d
  8d8454:	53                   	push   %rbx
  8d8455:	80 3f 22             	cmpb   $0x22,(%rdi)
  8d8458:	75 09                	jne    8d8463 <next_arg+0x17>
  8d845a:	48 ff c7             	inc    %rdi
  8d845d:	41 ba 01 00 00 00    	mov    $0x1,%r10d
  8d8463:	45 89 d3             	mov    %r10d,%r11d
  8d8466:	31 c9                	xor    %ecx,%ecx
  8d8468:	48 8d 1d 71 2b 00 00 	lea    0x2b71(%rip),%rbx        # 8dafe0 <_ctype>
  8d846f:	31 c0                	xor    %eax,%eax
  8d8471:	41 89 c0             	mov    %eax,%r8d
  8d8474:	49 01 f8             	add    %rdi,%r8
  8d8477:	45 8a 08             	mov    (%r8),%r9b
  8d847a:	45 84 c9             	test   %r9b,%r9b
  8d847d:	74 10                	je     8d848f <next_arg+0x43>
  8d847f:	41 0f b6 e9          	movzbl %r9b,%ebp
  8d8483:	f6 04 2b 20          	testb  $0x20,(%rbx,%rbp,1)
  8d8487:	74 16                	je     8d849f <next_arg+0x53>
  8d8489:	41 f6 c3 01          	test   $0x1,%r11b
  8d848d:	75 10                	jne    8d849f <next_arg+0x53>
  8d848f:	48 89 3e             	mov    %rdi,(%rsi)
  8d8492:	85 c9                	test   %ecx,%ecx
  8d8494:	75 25                	jne    8d84bb <next_arg+0x6f>
  8d8496:	48 c7 02 00 00 00 00 	movq   $0x0,(%rdx)
  8d849d:	eb 41                	jmp    8d84e0 <next_arg+0x94>
  8d849f:	85 c9                	test   %ecx,%ecx
  8d84a1:	75 06                	jne    8d84a9 <next_arg+0x5d>
  8d84a3:	41 80 f9 3d          	cmp    $0x3d,%r9b
  8d84a7:	74 0c                	je     8d84b5 <next_arg+0x69>
  8d84a9:	41 80 f9 22          	cmp    $0x22,%r9b
  8d84ad:	75 08                	jne    8d84b7 <next_arg+0x6b>
  8d84af:	41 83 f3 01          	xor    $0x1,%r11d
  8d84b3:	eb 02                	jmp    8d84b7 <next_arg+0x6b>
  8d84b5:	89 c1                	mov    %eax,%ecx
  8d84b7:	ff c0                	inc    %eax
  8d84b9:	eb b6                	jmp    8d8471 <next_arg+0x25>
  8d84bb:	c6 04 0f 00          	movb   $0x0,(%rdi,%rcx,1)
  8d84bf:	48 8d 4c 0f 01       	lea    0x1(%rdi,%rcx,1),%rcx
  8d84c4:	48 89 0a             	mov    %rcx,(%rdx)
  8d84c7:	80 39 22             	cmpb   $0x22,(%rcx)
  8d84ca:	75 14                	jne    8d84e0 <next_arg+0x94>
  8d84cc:	48 ff c1             	inc    %rcx
  8d84cf:	48 89 0a             	mov    %rcx,(%rdx)
  8d84d2:	8d 50 ff             	lea    -0x1(%rax),%edx
  8d84d5:	48 01 fa             	add    %rdi,%rdx
  8d84d8:	80 3a 22             	cmpb   $0x22,(%rdx)
  8d84db:	75 03                	jne    8d84e0 <next_arg+0x94>
  8d84dd:	c6 02 00             	movb   $0x0,(%rdx)
  8d84e0:	45 85 d2             	test   %r10d,%r10d
  8d84e3:	74 0e                	je     8d84f3 <next_arg+0xa7>
  8d84e5:	8d 50 ff             	lea    -0x1(%rax),%edx
  8d84e8:	48 01 fa             	add    %rdi,%rdx
  8d84eb:	80 3a 22             	cmpb   $0x22,(%rdx)
  8d84ee:	75 03                	jne    8d84f3 <next_arg+0xa7>
  8d84f0:	c6 02 00             	movb   $0x0,(%rdx)
  8d84f3:	41 80 38 00          	cmpb   $0x0,(%r8)
  8d84f7:	74 0b                	je     8d8504 <next_arg+0xb8>
  8d84f9:	41 c6 00 00          	movb   $0x0,(%r8)
  8d84fd:	44 8d 40 01          	lea    0x1(%rax),%r8d
  8d8501:	49 01 f8             	add    %rdi,%r8
  8d8504:	5b                   	pop    %rbx
  8d8505:	4c 89 c7             	mov    %r8,%rdi
  8d8508:	5d                   	pop    %rbp
  8d8509:	e9 bb 10 00 00       	jmpq   8d95c9 <skip_spaces>

00000000008d850e <efi_get_memory_map>:
  8d850e:	f3 0f 1e fa          	endbr64 
  8d8512:	41 54                	push   %r12
  8d8514:	55                   	push   %rbp
  8d8515:	53                   	push   %rbx
  8d8516:	48 89 fb             	mov    %rdi,%rbx
  8d8519:	48 83 ec 20          	sub    $0x20,%rsp
  8d851d:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8d8521:	40 8a 2d e8 3c 00 00 	mov    0x3ce8(%rip),%bpl        # 8dc210 <efi_is64>
  8d8528:	48 c7 44 24 10 00 00 	movq   $0x0,0x10(%rsp)
  8d852f:	00 00 
  8d8531:	48 c7 00 28 00 00 00 	movq   $0x28,(%rax)
  8d8538:	48 8b 47 10          	mov    0x10(%rdi),%rax
  8d853c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8d8540:	48 8b 00             	mov    (%rax),%rax
  8d8543:	48 c1 e0 05          	shl    $0x5,%rax
  8d8547:	48 89 02             	mov    %rax,(%rdx)
  8d854a:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  8d854e:	48 8b 47 28          	mov    0x28(%rdi),%rax
  8d8552:	48 8b 12             	mov    (%rdx),%rdx
  8d8555:	48 89 10             	mov    %rdx,(%rax)
  8d8558:	40 84 ed             	test   %bpl,%bpl
  8d855b:	48 8b 43 08          	mov    0x8(%rbx),%rax
  8d855f:	4c 8d 44 24 10       	lea    0x10(%rsp),%r8
  8d8564:	48 8b 15 95 b6 01 00 	mov    0x1b695(%rip),%rdx        # 8f3c00 <efi_system_table>
  8d856b:	74 1c                	je     8d8589 <efi_get_memory_map+0x7b>
  8d856d:	48 8b 72 60          	mov    0x60(%rdx),%rsi
  8d8571:	48 83 ec 20          	sub    $0x20,%rsp
  8d8575:	48 8b 10             	mov    (%rax),%rdx
  8d8578:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d857d:	ff 56 40             	callq  *0x40(%rsi)
  8d8580:	49 89 c4             	mov    %rax,%r12
  8d8583:	48 83 c4 20          	add    $0x20,%rsp
  8d8587:	eb 23                	jmp    8d85ac <efi_get_memory_map+0x9e>
  8d8589:	8b 52 3c             	mov    0x3c(%rdx),%edx
  8d858c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%rsp)
  8d8593:	00 
  8d8594:	4c 89 c1             	mov    %r8,%rcx
  8d8597:	be 02 00 00 00       	mov    $0x2,%esi
  8d859c:	8b 7a 2c             	mov    0x2c(%rdx),%edi
  8d859f:	48 8b 10             	mov    (%rax),%rdx
  8d85a2:	31 c0                	xor    %eax,%eax
  8d85a4:	e8 d7 c7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d85a9:	49 89 c4             	mov    %rax,%r12
  8d85ac:	4d 85 e4             	test   %r12,%r12
  8d85af:	0f 85 79 01 00 00    	jne    8d872e <efi_get_memory_map+0x220>
  8d85b5:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8d85b9:	40 84 ed             	test   %bpl,%bpl
  8d85bc:	48 8d 4c 24 18       	lea    0x18(%rsp),%rcx
  8d85c1:	4c 8d 4c 24 0c       	lea    0xc(%rsp),%r9
  8d85c6:	48 c7 00 00 00 00 00 	movq   $0x0,(%rax)
  8d85cd:	4c 8b 43 10          	mov    0x10(%rbx),%r8
  8d85d1:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  8d85d8:	00 00 
  8d85da:	74 5a                	je     8d8636 <efi_get_memory_map+0x128>
  8d85dc:	50                   	push   %rax
  8d85dd:	48 8b 05 1c b6 01 00 	mov    0x1b61c(%rip),%rax        # 8f3c00 <efi_system_table>
  8d85e4:	4c 8b 53 08          	mov    0x8(%rbx),%r10
  8d85e8:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d85ec:	41 51                	push   %r9
  8d85ee:	4d 89 c1             	mov    %r8,%r9
  8d85f1:	49 89 c8             	mov    %rcx,%r8
  8d85f4:	4c 89 d1             	mov    %r10,%rcx
  8d85f7:	48 83 ec 20          	sub    $0x20,%rsp
  8d85fb:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
  8d8600:	ff 50 38             	callq  *0x38(%rax)
  8d8603:	49 89 c4             	mov    %rax,%r12
  8d8606:	48 83 c4 30          	add    $0x30,%rsp
  8d860a:	48 b8 05 00 00 00 00 	movabs $0x8000000000000005,%rax
  8d8611:	00 00 80 
  8d8614:	49 39 c4             	cmp    %rax,%r12
  8d8617:	75 5c                	jne    8d8675 <efi_get_memory_map+0x167>
  8d8619:	48 8b 05 e0 b5 01 00 	mov    0x1b5e0(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8620:	48 83 ec 20          	sub    $0x20,%rsp
  8d8624:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8d8629:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d862d:	ff 50 48             	callq  *0x48(%rax)
  8d8630:	48 83 c4 20          	add    $0x20,%rsp
  8d8634:	eb 7a                	jmp    8d86b0 <efi_get_memory_map+0x1a2>
  8d8636:	41 c7 40 04 00 00 00 	movl   $0x0,0x4(%r8)
  8d863d:	00 
  8d863e:	48 8b 05 bb b5 01 00 	mov    0x1b5bb(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8645:	48 8b 73 08          	mov    0x8(%rbx),%rsi
  8d8649:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  8d864e:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%rsp)
  8d8655:	00 
  8d8656:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8659:	8b 78 28             	mov    0x28(%rax),%edi
  8d865c:	31 c0                	xor    %eax,%eax
  8d865e:	e8 1d c7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8663:	49 89 c4             	mov    %rax,%r12
  8d8666:	48 b8 05 00 00 00 00 	movabs $0x8000000000000005,%rax
  8d866d:	00 00 80 
  8d8670:	49 39 c4             	cmp    %rax,%r12
  8d8673:	74 22                	je     8d8697 <efi_get_memory_map+0x189>
  8d8675:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d8679:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8d867d:	48 8b 73 10          	mov    0x10(%rbx),%rsi
  8d8681:	48 8b 00             	mov    (%rax),%rax
  8d8684:	48 2b 02             	sub    (%rdx),%rax
  8d8687:	31 d2                	xor    %edx,%edx
  8d8689:	48 f7 36             	divq   (%rsi)
  8d868c:	48 83 f8 07          	cmp    $0x7,%rax
  8d8690:	77 43                	ja     8d86d5 <efi_get_memory_map+0x1c7>
  8d8692:	40 84 ed             	test   %bpl,%bpl
  8d8695:	75 82                	jne    8d8619 <efi_get_memory_map+0x10b>
  8d8697:	48 8b 05 62 b5 01 00 	mov    0x1b562(%rip),%rax        # 8f3c00 <efi_system_table>
  8d869e:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
  8d86a3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d86a6:	8b 78 30             	mov    0x30(%rax),%edi
  8d86a9:	31 c0                	xor    %eax,%eax
  8d86ab:	e8 d0 c6 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d86b0:	48 8b 43 10          	mov    0x10(%rbx),%rax
  8d86b4:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d86b8:	48 8b 00             	mov    (%rax),%rax
  8d86bb:	48 c1 e0 03          	shl    $0x3,%rax
  8d86bf:	48 01 02             	add    %rax,(%rdx)
  8d86c2:	48 8b 53 08          	mov    0x8(%rbx),%rdx
  8d86c6:	48 8b 43 28          	mov    0x28(%rbx),%rax
  8d86ca:	48 8b 12             	mov    (%rdx),%rdx
  8d86cd:	48 89 10             	mov    %rdx,(%rax)
  8d86d0:	e9 83 fe ff ff       	jmpq   8d8558 <efi_get_memory_map+0x4a>
  8d86d5:	4d 85 e4             	test   %r12,%r12
  8d86d8:	75 22                	jne    8d86fc <efi_get_memory_map+0x1ee>
  8d86da:	48 8b 43 20          	mov    0x20(%rbx),%rax
  8d86de:	48 85 c0             	test   %rax,%rax
  8d86e1:	74 08                	je     8d86eb <efi_get_memory_map+0x1dd>
  8d86e3:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d86e8:	48 89 10             	mov    %rdx,(%rax)
  8d86eb:	48 8b 43 18          	mov    0x18(%rbx),%rax
  8d86ef:	48 85 c0             	test   %rax,%rax
  8d86f2:	74 3a                	je     8d872e <efi_get_memory_map+0x220>
  8d86f4:	8b 54 24 0c          	mov    0xc(%rsp),%edx
  8d86f8:	89 10                	mov    %edx,(%rax)
  8d86fa:	eb 32                	jmp    8d872e <efi_get_memory_map+0x220>
  8d86fc:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
  8d8701:	48 8b 05 f8 b4 01 00 	mov    0x1b4f8(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8708:	40 84 ed             	test   %bpl,%bpl
  8d870b:	74 11                	je     8d871e <efi_get_memory_map+0x210>
  8d870d:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8711:	48 83 ec 20          	sub    $0x20,%rsp
  8d8715:	ff 50 48             	callq  *0x48(%rax)
  8d8718:	48 83 c4 20          	add    $0x20,%rsp
  8d871c:	eb 10                	jmp    8d872e <efi_get_memory_map+0x220>
  8d871e:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8721:	48 89 ce             	mov    %rcx,%rsi
  8d8724:	8b 78 30             	mov    0x30(%rax),%edi
  8d8727:	31 c0                	xor    %eax,%eax
  8d8729:	e8 52 c6 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d872e:	48 8b 03             	mov    (%rbx),%rax
  8d8731:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
  8d8736:	48 89 10             	mov    %rdx,(%rax)
  8d8739:	48 83 c4 20          	add    $0x20,%rsp
  8d873d:	4c 89 e0             	mov    %r12,%rax
  8d8740:	5b                   	pop    %rbx
  8d8741:	5d                   	pop    %rbp
  8d8742:	41 5c                	pop    %r12
  8d8744:	c3                   	retq   

00000000008d8745 <efi_allocate_pages>:
  8d8745:	f3 0f 1e fa          	endbr64 
  8d8749:	53                   	push   %rbx
  8d874a:	48 ff c2             	inc    %rdx
  8d874d:	48 8d 8f ff 0f 00 00 	lea    0xfff(%rdi),%rcx
  8d8754:	48 89 f3             	mov    %rsi,%rbx
  8d8757:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  8d875e:	48 c1 e9 0c          	shr    $0xc,%rcx
  8d8762:	48 ff ca             	dec    %rdx
  8d8765:	48 83 ec 10          	sub    $0x10,%rsp
  8d8769:	80 3d a0 3a 00 00 00 	cmpb   $0x0,0x3aa0(%rip)        # 8dc210 <efi_is64>
  8d8770:	48 8b 05 89 b4 01 00 	mov    0x1b489(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8777:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  8d877c:	4c 8d 44 24 08       	lea    0x8(%rsp),%r8
  8d8781:	74 21                	je     8d87a4 <efi_allocate_pages+0x5f>
  8d8783:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8787:	48 83 ec 20          	sub    $0x20,%rsp
  8d878b:	4d 89 c1             	mov    %r8,%r9
  8d878e:	ba 02 00 00 00       	mov    $0x2,%edx
  8d8793:	49 89 c8             	mov    %rcx,%r8
  8d8796:	b9 01 00 00 00       	mov    $0x1,%ecx
  8d879b:	ff 50 28             	callq  *0x28(%rax)
  8d879e:	48 83 c4 20          	add    $0x20,%rsp
  8d87a2:	eb 17                	jmp    8d87bb <efi_allocate_pages+0x76>
  8d87a4:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d87a7:	ba 02 00 00 00       	mov    $0x2,%edx
  8d87ac:	be 01 00 00 00       	mov    $0x1,%esi
  8d87b1:	8b 78 20             	mov    0x20(%rax),%edi
  8d87b4:	31 c0                	xor    %eax,%eax
  8d87b6:	e8 c5 c5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d87bb:	48 85 c0             	test   %rax,%rax
  8d87be:	75 08                	jne    8d87c8 <efi_allocate_pages+0x83>
  8d87c0:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d87c5:	48 89 13             	mov    %rdx,(%rbx)
  8d87c8:	48 83 c4 10          	add    $0x10,%rsp
  8d87cc:	5b                   	pop    %rbx
  8d87cd:	c3                   	retq   

00000000008d87ce <efi_free>:
  8d87ce:	f3 0f 1e fa          	endbr64 
  8d87d2:	48 85 ff             	test   %rdi,%rdi
  8d87d5:	74 47                	je     8d881e <efi_free+0x50>
  8d87d7:	48 8d 57 ff          	lea    -0x1(%rdi),%rdx
  8d87db:	48 8b 05 1e b4 01 00 	mov    0x1b41e(%rip),%rax        # 8f3c00 <efi_system_table>
  8d87e2:	48 81 ca ff 0f 00 00 	or     $0xfff,%rdx
  8d87e9:	48 ff c2             	inc    %rdx
  8d87ec:	48 c1 ea 0c          	shr    $0xc,%rdx
  8d87f0:	80 3d 19 3a 00 00 00 	cmpb   $0x0,0x3a19(%rip)        # 8dc210 <efi_is64>
  8d87f7:	74 13                	je     8d880c <efi_free+0x3e>
  8d87f9:	48 83 ec 28          	sub    $0x28,%rsp
  8d87fd:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8801:	48 89 f1             	mov    %rsi,%rcx
  8d8804:	ff 50 30             	callq  *0x30(%rax)
  8d8807:	48 83 c4 28          	add    $0x28,%rsp
  8d880b:	c3                   	retq   
  8d880c:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d880f:	48 89 d1             	mov    %rdx,%rcx
  8d8812:	31 d2                	xor    %edx,%edx
  8d8814:	8b 78 24             	mov    0x24(%rax),%edi
  8d8817:	31 c0                	xor    %eax,%eax
  8d8819:	e9 62 c5 ff ff       	jmpq   8d4d80 <__efi64_thunk>
  8d881e:	c3                   	retq   

00000000008d881f <efi_pci_disable_bridge_busmaster>:
  8d881f:	f3 0f 1e fa          	endbr64 
  8d8823:	48 b8 00 b2 f5 4c b8 	movabs $0x4ca568b84cf5b200,%rax
  8d882a:	68 a5 4c 
  8d882d:	41 57                	push   %r15
  8d882f:	41 56                	push   %r14
  8d8831:	41 55                	push   %r13
  8d8833:	41 54                	push   %r12
  8d8835:	55                   	push   %rbp
  8d8836:	53                   	push   %rbx
  8d8837:	48 83 ec 68          	sub    $0x68,%rsp
  8d883b:	40 8a 2d ce 39 00 00 	mov    0x39ce(%rip),%bpl        # 8dc210 <efi_is64>
  8d8842:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d8847:	48 8d 5c 24 18       	lea    0x18(%rsp),%rbx
  8d884c:	4c 8d 64 24 50       	lea    0x50(%rsp),%r12
  8d8851:	48 b8 9e ec b2 3e 3f 	movabs $0x9a02503f3eb2ec9e,%rax
  8d8858:	50 02 9a 
  8d885b:	40 84 ed             	test   %bpl,%bpl
  8d885e:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  8d8863:	48 8b 05 96 b3 01 00 	mov    0x1b396(%rip),%rax        # 8f3c00 <efi_system_table>
  8d886a:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
  8d8871:	00 00 
  8d8873:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  8d887a:	00 00 
  8d887c:	74 35                	je     8d88b3 <efi_pci_disable_bridge_busmaster+0x94>
  8d887e:	41 52                	push   %r10
  8d8880:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8884:	4c 89 e2             	mov    %r12,%rdx
  8d8887:	49 89 d9             	mov    %rbx,%r9
  8d888a:	6a 00                	pushq  $0x0
  8d888c:	45 31 c0             	xor    %r8d,%r8d
  8d888f:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d8894:	48 83 ec 20          	sub    $0x20,%rsp
  8d8898:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d889e:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d88a5:	00 00 80 
  8d88a8:	48 83 c4 30          	add    $0x30,%rsp
  8d88ac:	48 39 d0             	cmp    %rdx,%rax
  8d88af:	74 53                	je     8d8904 <efi_pci_disable_bridge_busmaster+0xe5>
  8d88b1:	eb 2c                	jmp    8d88df <efi_pci_disable_bridge_busmaster+0xc0>
  8d88b3:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d88b6:	4c 89 e2             	mov    %r12,%rdx
  8d88b9:	45 31 c9             	xor    %r9d,%r9d
  8d88bc:	49 89 d8             	mov    %rbx,%r8
  8d88bf:	31 c9                	xor    %ecx,%ecx
  8d88c1:	be 02 00 00 00       	mov    $0x2,%esi
  8d88c6:	8b 78 64             	mov    0x64(%rax),%edi
  8d88c9:	31 c0                	xor    %eax,%eax
  8d88cb:	e8 b0 c4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d88d0:	48 ba 05 00 00 00 00 	movabs $0x8000000000000005,%rdx
  8d88d7:	00 00 80 
  8d88da:	48 39 d0             	cmp    %rdx,%rax
  8d88dd:	74 62                	je     8d8941 <efi_pci_disable_bridge_busmaster+0x122>
  8d88df:	48 85 c0             	test   %rax,%rax
  8d88e2:	0f 84 a4 04 00 00    	je     8d8d8c <efi_pci_disable_bridge_busmaster+0x56d>
  8d88e8:	48 ba 0e 00 00 00 00 	movabs $0x800000000000000e,%rdx
  8d88ef:	00 00 80 
  8d88f2:	48 8d 3d 5b 35 00 00 	lea    0x355b(%rip),%rdi        # 8dbe54 <kernel_info_end+0xcc4>
  8d88f9:	48 39 d0             	cmp    %rdx,%rax
  8d88fc:	0f 84 8a 04 00 00    	je     8d8d8c <efi_pci_disable_bridge_busmaster+0x56d>
  8d8902:	eb 31                	jmp    8d8935 <efi_pci_disable_bridge_busmaster+0x116>
  8d8904:	48 8b 05 f5 b2 01 00 	mov    0x1b2f5(%rip),%rax        # 8f3c00 <efi_system_table>
  8d890b:	48 83 ec 20          	sub    $0x20,%rsp
  8d890f:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d8914:	48 8b 54 24 38       	mov    0x38(%rsp),%rdx
  8d8919:	4c 8d 44 24 40       	lea    0x40(%rsp),%r8
  8d891e:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8922:	ff 50 40             	callq  *0x40(%rax)
  8d8925:	48 83 c4 20          	add    $0x20,%rsp
  8d8929:	48 85 c0             	test   %rax,%rax
  8d892c:	74 6e                	je     8d899c <efi_pci_disable_bridge_busmaster+0x17d>
  8d892e:	48 8d 3d f4 2f 00 00 	lea    0x2ff4(%rip),%rdi        # 8db929 <kernel_info_end+0x799>
  8d8935:	31 c0                	xor    %eax,%eax
  8d8937:	e8 90 d8 ff ff       	callq  8d61cc <efi_printk>
  8d893c:	e9 4b 04 00 00       	jmpq   8d8d8c <efi_pci_disable_bridge_busmaster+0x56d>
  8d8941:	48 8b 54 24 18       	mov    0x18(%rsp),%rdx
  8d8946:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  8d894b:	48 8b 05 ae b2 01 00 	mov    0x1b2ae(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8952:	be 02 00 00 00       	mov    $0x2,%esi
  8d8957:	c7 44 24 24 00 00 00 	movl   $0x0,0x24(%rsp)
  8d895e:	00 
  8d895f:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8962:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d8965:	31 c0                	xor    %eax,%eax
  8d8967:	e8 14 c4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d896c:	48 85 c0             	test   %rax,%rax
  8d896f:	75 bd                	jne    8d892e <efi_pci_disable_bridge_busmaster+0x10f>
  8d8971:	48 8b 05 88 b2 01 00 	mov    0x1b288(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8978:	49 89 d8             	mov    %rbx,%r8
  8d897b:	31 c9                	xor    %ecx,%ecx
  8d897d:	4c 89 e2             	mov    %r12,%rdx
  8d8980:	4c 8b 4c 24 20       	mov    0x20(%rsp),%r9
  8d8985:	be 02 00 00 00       	mov    $0x2,%esi
  8d898a:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d898d:	8b 78 64             	mov    0x64(%rax),%edi
  8d8990:	31 c0                	xor    %eax,%eax
  8d8992:	e8 e9 c3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8997:	48 89 c3             	mov    %rax,%rbx
  8d899a:	eb 30                	jmp    8d89cc <efi_pci_disable_bridge_busmaster+0x1ad>
  8d899c:	48 8b 05 5d b2 01 00 	mov    0x1b25d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d89a3:	41 51                	push   %r9
  8d89a5:	45 31 c0             	xor    %r8d,%r8d
  8d89a8:	49 89 d9             	mov    %rbx,%r9
  8d89ab:	4c 89 e2             	mov    %r12,%rdx
  8d89ae:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d89b3:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d89b7:	ff 74 24 28          	pushq  0x28(%rsp)
  8d89bb:	48 83 ec 20          	sub    $0x20,%rsp
  8d89bf:	ff 90 b0 00 00 00    	callq  *0xb0(%rax)
  8d89c5:	48 89 c3             	mov    %rax,%rbx
  8d89c8:	48 83 c4 30          	add    $0x30,%rsp
  8d89cc:	48 85 db             	test   %rbx,%rbx
  8d89cf:	75 1e                	jne    8d89ef <efi_pci_disable_bridge_busmaster+0x1d0>
  8d89d1:	40 80 fd 01          	cmp    $0x1,%bpl
  8d89d5:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  8d89da:	4d 19 ed             	sbb    %r13,%r13
  8d89dd:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d89e2:	45 31 f6             	xor    %r14d,%r14d
  8d89e5:	49 83 e5 fc          	and    $0xfffffffffffffffc,%r13
  8d89e9:	49 83 c5 08          	add    $0x8,%r13
  8d89ed:	eb 74                	jmp    8d8a63 <efi_pci_disable_bridge_busmaster+0x244>
  8d89ef:	48 8d 3d 5e 34 00 00 	lea    0x345e(%rip),%rdi        # 8dbe54 <kernel_info_end+0xcc4>
  8d89f6:	31 c0                	xor    %eax,%eax
  8d89f8:	e8 cf d7 ff ff       	callq  8d61cc <efi_printk>
  8d89fd:	e9 58 03 00 00       	jmpq   8d8d5a <efi_pci_disable_bridge_busmaster+0x53b>
  8d8a02:	40 84 ed             	test   %bpl,%bpl
  8d8a05:	0f 84 2f 01 00 00    	je     8d8b3a <efi_pci_disable_bridge_busmaster+0x31b>
  8d8a0b:	4e 8b 3c f6          	mov    (%rsi,%r14,8),%r15
  8d8a0f:	48 8b 41 60          	mov    0x60(%rcx),%rax
  8d8a13:	48 83 ec 20          	sub    $0x20,%rsp
  8d8a17:	4c 89 e2             	mov    %r12,%rdx
  8d8a1a:	4c 8b 44 24 28       	mov    0x28(%rsp),%r8
  8d8a1f:	4c 89 f9             	mov    %r15,%rcx
  8d8a22:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d8a28:	48 83 c4 20          	add    $0x20,%rsp
  8d8a2c:	48 85 c0             	test   %rax,%rax
  8d8a2f:	75 2f                	jne    8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8a31:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d8a36:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  8d8a3b:	41 50                	push   %r8
  8d8a3d:	48 8d 4c 24 50       	lea    0x50(%rsp),%rcx
  8d8a42:	51                   	push   %rcx
  8d8a43:	48 89 c1             	mov    %rax,%rcx
  8d8a46:	48 83 ec 20          	sub    $0x20,%rsp
  8d8a4a:	4c 8d 4c 24 70       	lea    0x70(%rsp),%r9
  8d8a4f:	4c 8d 44 24 68       	lea    0x68(%rsp),%r8
  8d8a54:	ff 50 70             	callq  *0x70(%rax)
  8d8a57:	48 83 c4 30          	add    $0x30,%rsp
  8d8a5b:	48 85 c0             	test   %rax,%rax
  8d8a5e:	74 28                	je     8d8a88 <efi_pci_disable_bridge_busmaster+0x269>
  8d8a60:	49 ff c6             	inc    %r14
  8d8a63:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  8d8a68:	31 d2                	xor    %edx,%edx
  8d8a6a:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8d8a6f:	48 8b 0d 8a b1 01 00 	mov    0x1b18a(%rip),%rcx        # 8f3c00 <efi_system_table>
  8d8a76:	49 f7 f5             	div    %r13
  8d8a79:	4c 39 f0             	cmp    %r14,%rax
  8d8a7c:	77 84                	ja     8d8a02 <efi_pci_disable_bridge_busmaster+0x1e3>
  8d8a7e:	4c 8d 74 24 48       	lea    0x48(%rsp),%r14
  8d8a83:	e9 57 01 00 00       	jmpq   8d8bdf <efi_pci_disable_bridge_busmaster+0x3c0>
  8d8a88:	48 83 7c 24 38 00    	cmpq   $0x0,0x38(%rsp)
  8d8a8e:	74 d0                	je     8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8a90:	40 84 ed             	test   %bpl,%bpl
  8d8a93:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8d8a98:	4c 8d 4c 24 16       	lea    0x16(%rsp),%r9
  8d8a9d:	74 24                	je     8d8ac3 <efi_pci_disable_bridge_busmaster+0x2a4>
  8d8a9f:	57                   	push   %rdi
  8d8aa0:	41 b8 0a 00 00 00    	mov    $0xa,%r8d
  8d8aa6:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8aab:	48 89 f1             	mov    %rsi,%rcx
  8d8aae:	41 51                	push   %r9
  8d8ab0:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d8ab6:	48 83 ec 20          	sub    $0x20,%rsp
  8d8aba:	ff 56 30             	callq  *0x30(%rsi)
  8d8abd:	48 83 c4 30          	add    $0x30,%rsp
  8d8ac1:	eb 1a                	jmp    8d8add <efi_pci_disable_bridge_busmaster+0x2be>
  8d8ac3:	8b 7e 18             	mov    0x18(%rsi),%edi
  8d8ac6:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d8acc:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8d8ad1:	31 c0                	xor    %eax,%eax
  8d8ad3:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8ad8:	e8 a3 c2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8add:	48 85 c0             	test   %rax,%rax
  8d8ae0:	0f 85 7a ff ff ff    	jne    8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8ae6:	66 81 7c 24 16 00 03 	cmpw   $0x300,0x16(%rsp)
  8d8aed:	0f 84 6d ff ff ff    	je     8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8af3:	48 8b 05 06 b1 01 00 	mov    0x1b106(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8afa:	40 84 ed             	test   %bpl,%bpl
  8d8afd:	74 1f                	je     8d8b1e <efi_pci_disable_bridge_busmaster+0x2ff>
  8d8aff:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8b03:	48 83 ec 20          	sub    $0x20,%rsp
  8d8b07:	45 31 c0             	xor    %r8d,%r8d
  8d8b0a:	31 d2                	xor    %edx,%edx
  8d8b0c:	4c 89 f9             	mov    %r15,%rcx
  8d8b0f:	ff 90 10 01 00 00    	callq  *0x110(%rax)
  8d8b15:	48 83 c4 20          	add    $0x20,%rsp
  8d8b19:	e9 42 ff ff ff       	jmpq   8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8b1e:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8b21:	31 c9                	xor    %ecx,%ecx
  8d8b23:	31 d2                	xor    %edx,%edx
  8d8b25:	4c 89 fe             	mov    %r15,%rsi
  8d8b28:	8b b8 94 00 00 00    	mov    0x94(%rax),%edi
  8d8b2e:	31 c0                	xor    %eax,%eax
  8d8b30:	e8 4b c2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8b35:	e9 26 ff ff ff       	jmpq   8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8b3a:	8b 41 3c             	mov    0x3c(%rcx),%eax
  8d8b3d:	46 8b 3c b6          	mov    (%rsi,%r14,4),%r15d
  8d8b41:	4c 89 e2             	mov    %r12,%rdx
  8d8b44:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%rsp)
  8d8b4b:	00 
  8d8b4c:	48 8b 4c 24 08       	mov    0x8(%rsp),%rcx
  8d8b51:	8b 78 58             	mov    0x58(%rax),%edi
  8d8b54:	4c 89 fe             	mov    %r15,%rsi
  8d8b57:	31 c0                	xor    %eax,%eax
  8d8b59:	e8 22 c2 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8b5e:	48 85 c0             	test   %rax,%rax
  8d8b61:	0f 85 f9 fe ff ff    	jne    8d8a60 <efi_pci_disable_bridge_busmaster+0x241>
  8d8b67:	48 8b 74 24 28       	mov    0x28(%rsp),%rsi
  8d8b6c:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  8d8b73:	00 
  8d8b74:	48 8d 4c 24 38       	lea    0x38(%rsp),%rcx
  8d8b79:	48 8d 54 24 30       	lea    0x30(%rsp),%rdx
  8d8b7e:	c7 44 24 44 00 00 00 	movl   $0x0,0x44(%rsp)
  8d8b85:	00 
  8d8b86:	4c 8d 4c 24 48       	lea    0x48(%rsp),%r9
  8d8b8b:	4c 8d 44 24 40       	lea    0x40(%rsp),%r8
  8d8b90:	31 c0                	xor    %eax,%eax
  8d8b92:	8b 7e 38             	mov    0x38(%rsi),%edi
  8d8b95:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%rsp)
  8d8b9c:	00 
  8d8b9d:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%rsp)
  8d8ba4:	00 
  8d8ba5:	e8 d6 c1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8baa:	e9 ac fe ff ff       	jmpq   8d8a5b <efi_pci_disable_bridge_busmaster+0x23c>
  8d8baf:	40 84 ed             	test   %bpl,%bpl
  8d8bb2:	0f 84 7f 01 00 00    	je     8d8d37 <efi_pci_disable_bridge_busmaster+0x518>
  8d8bb8:	4c 8b 0c de          	mov    (%rsi,%rbx,8),%r9
  8d8bbc:	48 8b 41 60          	mov    0x60(%rcx),%rax
  8d8bc0:	48 83 ec 20          	sub    $0x20,%rsp
  8d8bc4:	4d 89 f0             	mov    %r14,%r8
  8d8bc7:	4c 89 e2             	mov    %r12,%rdx
  8d8bca:	4c 89 c9             	mov    %r9,%rcx
  8d8bcd:	ff 90 98 00 00 00    	callq  *0x98(%rax)
  8d8bd3:	48 83 c4 20          	add    $0x20,%rsp
  8d8bd7:	48 85 c0             	test   %rax,%rax
  8d8bda:	74 23                	je     8d8bff <efi_pci_disable_bridge_busmaster+0x3e0>
  8d8bdc:	48 ff c3             	inc    %rbx
  8d8bdf:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  8d8be4:	31 d2                	xor    %edx,%edx
  8d8be6:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8d8beb:	48 8b 0d 0e b0 01 00 	mov    0x1b00e(%rip),%rcx        # 8f3c00 <efi_system_table>
  8d8bf2:	49 f7 f5             	div    %r13
  8d8bf5:	48 39 d8             	cmp    %rbx,%rax
  8d8bf8:	77 b5                	ja     8d8baf <efi_pci_disable_bridge_busmaster+0x390>
  8d8bfa:	e9 5b 01 00 00       	jmpq   8d8d5a <efi_pci_disable_bridge_busmaster+0x53b>
  8d8bff:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8d8c04:	48 85 f6             	test   %rsi,%rsi
  8d8c07:	74 d3                	je     8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8c09:	40 84 ed             	test   %bpl,%bpl
  8d8c0c:	4c 8d 4c 24 16       	lea    0x16(%rsp),%r9
  8d8c11:	74 24                	je     8d8c37 <efi_pci_disable_bridge_busmaster+0x418>
  8d8c13:	51                   	push   %rcx
  8d8c14:	41 b8 0a 00 00 00    	mov    $0xa,%r8d
  8d8c1a:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8c1f:	48 89 f1             	mov    %rsi,%rcx
  8d8c22:	41 51                	push   %r9
  8d8c24:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d8c2a:	48 83 ec 20          	sub    $0x20,%rsp
  8d8c2e:	ff 56 30             	callq  *0x30(%rsi)
  8d8c31:	48 83 c4 30          	add    $0x30,%rsp
  8d8c35:	eb 1a                	jmp    8d8c51 <efi_pci_disable_bridge_busmaster+0x432>
  8d8c37:	8b 7e 18             	mov    0x18(%rsi),%edi
  8d8c3a:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d8c40:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8d8c45:	31 c0                	xor    %eax,%eax
  8d8c47:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8c4c:	e8 2f c1 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8c51:	48 85 c0             	test   %rax,%rax
  8d8c54:	75 86                	jne    8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8c56:	66 81 7c 24 16 04 06 	cmpw   $0x604,0x16(%rsp)
  8d8c5d:	0f 85 79 ff ff ff    	jne    8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8c63:	40 84 ed             	test   %bpl,%bpl
  8d8c66:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8d8c6b:	4c 8d 7c 24 40       	lea    0x40(%rsp),%r15
  8d8c70:	74 24                	je     8d8c96 <efi_pci_disable_bridge_busmaster+0x477>
  8d8c72:	52                   	push   %rdx
  8d8c73:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d8c79:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  8d8c7f:	48 89 f1             	mov    %rsi,%rcx
  8d8c82:	41 57                	push   %r15
  8d8c84:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8c89:	48 83 ec 20          	sub    $0x20,%rsp
  8d8c8d:	ff 56 30             	callq  *0x30(%rsi)
  8d8c90:	48 83 c4 30          	add    $0x30,%rsp
  8d8c94:	eb 1d                	jmp    8d8cb3 <efi_pci_disable_bridge_busmaster+0x494>
  8d8c96:	8b 7e 18             	mov    0x18(%rsi),%edi
  8d8c99:	4d 89 f9             	mov    %r15,%r9
  8d8c9c:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d8ca2:	31 c0                	xor    %eax,%eax
  8d8ca4:	b9 04 00 00 00       	mov    $0x4,%ecx
  8d8ca9:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8cae:	e8 cd c0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8cb3:	48 85 c0             	test   %rax,%rax
  8d8cb6:	0f 85 20 ff ff ff    	jne    8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8cbc:	8b 44 24 40          	mov    0x40(%rsp),%eax
  8d8cc0:	a8 04                	test   $0x4,%al
  8d8cc2:	0f 84 14 ff ff ff    	je     8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8cc8:	83 e0 fb             	and    $0xfffffffb,%eax
  8d8ccb:	48 8b 74 24 48       	mov    0x48(%rsp),%rsi
  8d8cd0:	66 89 44 24 40       	mov    %ax,0x40(%rsp)
  8d8cd5:	40 84 ed             	test   %bpl,%bpl
  8d8cd8:	74 24                	je     8d8cfe <efi_pci_disable_bridge_busmaster+0x4df>
  8d8cda:	50                   	push   %rax
  8d8cdb:	41 b9 01 00 00 00    	mov    $0x1,%r9d
  8d8ce1:	41 b8 04 00 00 00    	mov    $0x4,%r8d
  8d8ce7:	48 89 f1             	mov    %rsi,%rcx
  8d8cea:	41 57                	push   %r15
  8d8cec:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8cf1:	48 83 ec 20          	sub    $0x20,%rsp
  8d8cf5:	ff 56 38             	callq  *0x38(%rsi)
  8d8cf8:	48 83 c4 30          	add    $0x30,%rsp
  8d8cfc:	eb 1d                	jmp    8d8d1b <efi_pci_disable_bridge_busmaster+0x4fc>
  8d8cfe:	8b 7e 1c             	mov    0x1c(%rsi),%edi
  8d8d01:	4d 89 f9             	mov    %r15,%r9
  8d8d04:	41 b8 01 00 00 00    	mov    $0x1,%r8d
  8d8d0a:	31 c0                	xor    %eax,%eax
  8d8d0c:	b9 04 00 00 00       	mov    $0x4,%ecx
  8d8d11:	ba 01 00 00 00       	mov    $0x1,%edx
  8d8d16:	e8 65 c0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8d1b:	48 85 c0             	test   %rax,%rax
  8d8d1e:	0f 84 b8 fe ff ff    	je     8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8d24:	48 8d 3d 55 31 00 00 	lea    0x3155(%rip),%rdi        # 8dbe80 <kernel_info_end+0xcf0>
  8d8d2b:	31 c0                	xor    %eax,%eax
  8d8d2d:	e8 9a d4 ff ff       	callq  8d61cc <efi_printk>
  8d8d32:	e9 a5 fe ff ff       	jmpq   8d8bdc <efi_pci_disable_bridge_busmaster+0x3bd>
  8d8d37:	8b 34 9e             	mov    (%rsi,%rbx,4),%esi
  8d8d3a:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%rsp)
  8d8d41:	00 
  8d8d42:	4c 89 e2             	mov    %r12,%rdx
  8d8d45:	8b 41 3c             	mov    0x3c(%rcx),%eax
  8d8d48:	4c 89 f1             	mov    %r14,%rcx
  8d8d4b:	8b 78 58             	mov    0x58(%rax),%edi
  8d8d4e:	31 c0                	xor    %eax,%eax
  8d8d50:	e8 2b c0 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8d55:	e9 7d fe ff ff       	jmpq   8d8bd7 <efi_pci_disable_bridge_busmaster+0x3b8>
  8d8d5a:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8d8d5f:	48 8b 05 9a ae 01 00 	mov    0x1ae9a(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8d66:	40 84 ed             	test   %bpl,%bpl
  8d8d69:	74 11                	je     8d8d7c <efi_pci_disable_bridge_busmaster+0x55d>
  8d8d6b:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8d6f:	48 83 ec 20          	sub    $0x20,%rsp
  8d8d73:	ff 50 48             	callq  *0x48(%rax)
  8d8d76:	48 83 c4 20          	add    $0x20,%rsp
  8d8d7a:	eb 10                	jmp    8d8d8c <efi_pci_disable_bridge_busmaster+0x56d>
  8d8d7c:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8d7f:	48 89 ce             	mov    %rcx,%rsi
  8d8d82:	8b 78 30             	mov    0x30(%rax),%edi
  8d8d85:	31 c0                	xor    %eax,%eax
  8d8d87:	e8 f4 bf ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8d8c:	48 83 c4 68          	add    $0x68,%rsp
  8d8d90:	5b                   	pop    %rbx
  8d8d91:	5d                   	pop    %rbp
  8d8d92:	41 5c                	pop    %r12
  8d8d94:	41 5d                	pop    %r13
  8d8d96:	41 5e                	pop    %r14
  8d8d98:	41 5f                	pop    %r15
  8d8d9a:	c3                   	retq   

00000000008d8d9b <efi_get_random_bytes>:
  8d8d9b:	f3 0f 1e fa          	endbr64 
  8d8d9f:	48 b8 a5 bc 52 31 de 	movabs $0x433deade3152bca5,%rax
  8d8da6:	ea 3d 43 
  8d8da9:	41 54                	push   %r12
  8d8dab:	49 89 fc             	mov    %rdi,%r12
  8d8dae:	53                   	push   %rbx
  8d8daf:	48 89 f3             	mov    %rsi,%rbx
  8d8db2:	48 83 ec 28          	sub    $0x28,%rsp
  8d8db6:	80 3d 53 34 00 00 00 	cmpb   $0x0,0x3453(%rip)        # 8dc210 <efi_is64>
  8d8dbd:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d8dc2:	4c 8d 44 24 08       	lea    0x8(%rsp),%r8
  8d8dc7:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  8d8dcc:	48 b8 86 2e c0 1c dc 	movabs $0x441f29dc1cc02e86,%rax
  8d8dd3:	29 1f 44 
  8d8dd6:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d8ddb:	48 8b 05 1e ae 01 00 	mov    0x1ae1e(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8de2:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  8d8de9:	00 00 
  8d8deb:	74 39                	je     8d8e26 <efi_get_random_bytes+0x8b>
  8d8ded:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8df1:	48 83 ec 20          	sub    $0x20,%rsp
  8d8df5:	31 d2                	xor    %edx,%edx
  8d8df7:	48 89 f1             	mov    %rsi,%rcx
  8d8dfa:	ff 90 40 01 00 00    	callq  *0x140(%rax)
  8d8e00:	48 83 c4 20          	add    $0x20,%rsp
  8d8e04:	48 85 c0             	test   %rax,%rax
  8d8e07:	75 56                	jne    8d8e5f <efi_get_random_bytes+0xc4>
  8d8e09:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d8e0e:	49 89 d9             	mov    %rbx,%r9
  8d8e11:	48 83 ec 20          	sub    $0x20,%rsp
  8d8e15:	4d 89 e0             	mov    %r12,%r8
  8d8e18:	31 d2                	xor    %edx,%edx
  8d8e1a:	48 89 c1             	mov    %rax,%rcx
  8d8e1d:	ff 50 08             	callq  *0x8(%rax)
  8d8e20:	48 83 c4 20          	add    $0x20,%rsp
  8d8e24:	eb 39                	jmp    8d8e5f <efi_get_random_bytes+0xc4>
  8d8e26:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8e29:	31 d2                	xor    %edx,%edx
  8d8e2b:	4c 89 c1             	mov    %r8,%rcx
  8d8e2e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%rsp)
  8d8e35:	00 
  8d8e36:	8b b8 ac 00 00 00    	mov    0xac(%rax),%edi
  8d8e3c:	31 c0                	xor    %eax,%eax
  8d8e3e:	e8 3d bf ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8e43:	48 85 c0             	test   %rax,%rax
  8d8e46:	75 17                	jne    8d8e5f <efi_get_random_bytes+0xc4>
  8d8e48:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d8e4d:	49 89 d8             	mov    %rbx,%r8
  8d8e50:	4c 89 e1             	mov    %r12,%rcx
  8d8e53:	31 d2                	xor    %edx,%edx
  8d8e55:	31 c0                	xor    %eax,%eax
  8d8e57:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d8e5a:	e8 21 bf ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8e5f:	48 83 c4 28          	add    $0x28,%rsp
  8d8e63:	5b                   	pop    %rbx
  8d8e64:	41 5c                	pop    %r12
  8d8e66:	c3                   	retq   

00000000008d8e67 <efi_random_get_seed>:
  8d8e67:	f3 0f 1e fa          	endbr64 
  8d8e6b:	48 b8 a5 bc 52 31 de 	movabs $0x433deade3152bca5,%rax
  8d8e72:	ea 3d 43 
  8d8e75:	41 54                	push   %r12
  8d8e77:	53                   	push   %rbx
  8d8e78:	48 83 ec 48          	sub    $0x48,%rsp
  8d8e7c:	8a 1d 8e 33 00 00    	mov    0x338e(%rip),%bl        # 8dc210 <efi_is64>
  8d8e82:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8d8e87:	49 89 e0             	mov    %rsp,%r8
  8d8e8a:	48 8d 74 24 10       	lea    0x10(%rsp),%rsi
  8d8e8f:	48 b8 86 2e c0 1c dc 	movabs $0x441f29dc1cc02e86,%rax
  8d8e96:	29 1f 44 
  8d8e99:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8d8e9e:	84 db                	test   %bl,%bl
  8d8ea0:	48 b8 d7 76 31 e4 e8 	movabs $0x4827b6e8e43176d7,%rax
  8d8ea7:	b6 27 48 
  8d8eaa:	48 89 44 24 20       	mov    %rax,0x20(%rsp)
  8d8eaf:	48 b8 b7 84 7f fd c4 	movabs $0x6185b6c4fd7f84b7,%rax
  8d8eb6:	b6 85 61 
  8d8eb9:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d8ebe:	48 b8 bc e5 e1 1c eb 	movabs $0x42f27ceb1ce1e5bc,%rax
  8d8ec5:	7c f2 42 
  8d8ec8:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  8d8ecd:	48 b8 81 e5 8a ad f1 	movabs $0x7bf580f1ad8ae581,%rax
  8d8ed4:	80 f5 7b 
  8d8ed7:	48 89 44 24 38       	mov    %rax,0x38(%rsp)
  8d8edc:	48 8b 05 1d ad 01 00 	mov    0x1ad1d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8ee3:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8d8eea:	00 
  8d8eeb:	48 c7 44 24 08 00 00 	movq   $0x0,0x8(%rsp)
  8d8ef2:	00 00 
  8d8ef4:	74 24                	je     8d8f1a <efi_random_get_seed+0xb3>
  8d8ef6:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8efa:	48 83 ec 20          	sub    $0x20,%rsp
  8d8efe:	31 d2                	xor    %edx,%edx
  8d8f00:	48 89 f1             	mov    %rsi,%rcx
  8d8f03:	ff 90 40 01 00 00    	callq  *0x140(%rax)
  8d8f09:	49 89 c4             	mov    %rax,%r12
  8d8f0c:	48 83 c4 20          	add    $0x20,%rsp
  8d8f10:	48 85 c0             	test   %rax,%rax
  8d8f13:	74 2f                	je     8d8f44 <efi_random_get_seed+0xdd>
  8d8f15:	e9 eb 01 00 00       	jmpq   8d9105 <efi_random_get_seed+0x29e>
  8d8f1a:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8f1d:	4c 89 c1             	mov    %r8,%rcx
  8d8f20:	31 d2                	xor    %edx,%edx
  8d8f22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%rsp)
  8d8f29:	00 
  8d8f2a:	8b b8 ac 00 00 00    	mov    0xac(%rax),%edi
  8d8f30:	31 c0                	xor    %eax,%eax
  8d8f32:	e8 49 be ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8f37:	49 89 c4             	mov    %rax,%r12
  8d8f3a:	48 85 c0             	test   %rax,%rax
  8d8f3d:	74 37                	je     8d8f76 <efi_random_get_seed+0x10f>
  8d8f3f:	e9 c1 01 00 00       	jmpq   8d9105 <efi_random_get_seed+0x29e>
  8d8f44:	48 8b 05 b5 ac 01 00 	mov    0x1acb5(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8f4b:	48 83 ec 20          	sub    $0x20,%rsp
  8d8f4f:	ba 44 00 00 00       	mov    $0x44,%edx
  8d8f54:	b9 06 00 00 00       	mov    $0x6,%ecx
  8d8f59:	4c 8d 44 24 28       	lea    0x28(%rsp),%r8
  8d8f5e:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d8f62:	ff 50 40             	callq  *0x40(%rax)
  8d8f65:	49 89 c4             	mov    %rax,%r12
  8d8f68:	48 83 c4 20          	add    $0x20,%rsp
  8d8f6c:	48 85 c0             	test   %rax,%rax
  8d8f6f:	74 3d                	je     8d8fae <efi_random_get_seed+0x147>
  8d8f71:	e9 8f 01 00 00       	jmpq   8d9105 <efi_random_get_seed+0x29e>
  8d8f76:	48 8d 4c 24 08       	lea    0x8(%rsp),%rcx
  8d8f7b:	ba 44 00 00 00       	mov    $0x44,%edx
  8d8f80:	48 8b 05 79 ac 01 00 	mov    0x1ac79(%rip),%rax        # 8f3c00 <efi_system_table>
  8d8f87:	be 06 00 00 00       	mov    $0x6,%esi
  8d8f8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%rsp)
  8d8f93:	00 
  8d8f94:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d8f97:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d8f9a:	31 c0                	xor    %eax,%eax
  8d8f9c:	e8 df bd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d8fa1:	49 89 c4             	mov    %rax,%r12
  8d8fa4:	48 85 c0             	test   %rax,%rax
  8d8fa7:	74 69                	je     8d9012 <efi_random_get_seed+0x1ab>
  8d8fa9:	e9 57 01 00 00       	jmpq   8d9105 <efi_random_get_seed+0x29e>
  8d8fae:	48 8b 04 24          	mov    (%rsp),%rax
  8d8fb2:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  8d8fb7:	48 83 ec 20          	sub    $0x20,%rsp
  8d8fbb:	41 b8 40 00 00 00    	mov    $0x40,%r8d
  8d8fc1:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8d8fc6:	4c 8d 49 04          	lea    0x4(%rcx),%r9
  8d8fca:	48 89 c1             	mov    %rax,%rcx
  8d8fcd:	ff 50 08             	callq  *0x8(%rax)
  8d8fd0:	49 89 c4             	mov    %rax,%r12
  8d8fd3:	48 83 c4 20          	add    $0x20,%rsp
  8d8fd7:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  8d8fde:	00 00 80 
  8d8fe1:	49 39 c4             	cmp    %rax,%r12
  8d8fe4:	0f 85 82 00 00 00    	jne    8d906c <efi_random_get_seed+0x205>
  8d8fea:	48 8b 04 24          	mov    (%rsp),%rax
  8d8fee:	48 83 ec 20          	sub    $0x20,%rsp
  8d8ff2:	41 b8 40 00 00 00    	mov    $0x40,%r8d
  8d8ff8:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
  8d8ffd:	48 89 c1             	mov    %rax,%rcx
  8d9000:	4c 8d 4a 04          	lea    0x4(%rdx),%r9
  8d9004:	31 d2                	xor    %edx,%edx
  8d9006:	ff 50 08             	callq  *0x8(%rax)
  8d9009:	49 89 c4             	mov    %rax,%r12
  8d900c:	48 83 c4 20          	add    $0x20,%rsp
  8d9010:	eb 5a                	jmp    8d906c <efi_random_get_seed+0x205>
  8d9012:	48 8b 34 24          	mov    (%rsp),%rsi
  8d9016:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d901b:	48 8d 54 24 20       	lea    0x20(%rsp),%rdx
  8d9020:	b9 40 00 00 00       	mov    $0x40,%ecx
  8d9025:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d9028:	4c 8d 40 04          	lea    0x4(%rax),%r8
  8d902c:	31 c0                	xor    %eax,%eax
  8d902e:	e8 4d bd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9033:	49 89 c4             	mov    %rax,%r12
  8d9036:	48 b8 03 00 00 00 00 	movabs $0x8000000000000003,%rax
  8d903d:	00 00 80 
  8d9040:	49 39 c4             	cmp    %rax,%r12
  8d9043:	0f 85 9e 00 00 00    	jne    8d90e7 <efi_random_get_seed+0x280>
  8d9049:	48 8b 34 24          	mov    (%rsp),%rsi
  8d904d:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d9052:	b9 40 00 00 00       	mov    $0x40,%ecx
  8d9057:	31 d2                	xor    %edx,%edx
  8d9059:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d905c:	4c 8d 40 04          	lea    0x4(%rax),%r8
  8d9060:	31 c0                	xor    %eax,%eax
  8d9062:	e8 19 bd ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9067:	49 89 c4             	mov    %rax,%r12
  8d906a:	eb 7b                	jmp    8d90e7 <efi_random_get_seed+0x280>
  8d906c:	4d 85 e4             	test   %r12,%r12
  8d906f:	75 59                	jne    8d90ca <efi_random_get_seed+0x263>
  8d9071:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8d9076:	84 db                	test   %bl,%bl
  8d9078:	48 8d 4c 24 30       	lea    0x30(%rsp),%rcx
  8d907d:	c7 00 40 00 00 00    	movl   $0x40,(%rax)
  8d9083:	48 8b 05 76 ab 01 00 	mov    0x1ab76(%rip),%rax        # 8f3c00 <efi_system_table>
  8d908a:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d908f:	74 1f                	je     8d90b0 <efi_random_get_seed+0x249>
  8d9091:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d9095:	48 83 ec 20          	sub    $0x20,%rsp
  8d9099:	ff 90 c0 00 00 00    	callq  *0xc0(%rax)
  8d909f:	49 89 c4             	mov    %rax,%r12
  8d90a2:	48 83 c4 20          	add    $0x20,%rsp
  8d90a6:	48 85 c0             	test   %rax,%rax
  8d90a9:	75 1f                	jne    8d90ca <efi_random_get_seed+0x263>
  8d90ab:	45 31 e4             	xor    %r12d,%r12d
  8d90ae:	eb 55                	jmp    8d9105 <efi_random_get_seed+0x29e>
  8d90b0:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d90b3:	48 89 ce             	mov    %rcx,%rsi
  8d90b6:	8b 78 6c             	mov    0x6c(%rax),%edi
  8d90b9:	31 c0                	xor    %eax,%eax
  8d90bb:	e8 c0 bc ff ff       	callq  8d4d80 <__efi64_thunk>
  8d90c0:	49 89 c4             	mov    %rax,%r12
  8d90c3:	48 85 c0             	test   %rax,%rax
  8d90c6:	74 e3                	je     8d90ab <efi_random_get_seed+0x244>
  8d90c8:	eb 22                	jmp    8d90ec <efi_random_get_seed+0x285>
  8d90ca:	48 8b 05 2f ab 01 00 	mov    0x1ab2f(%rip),%rax        # 8f3c00 <efi_system_table>
  8d90d1:	48 83 ec 20          	sub    $0x20,%rsp
  8d90d5:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8d90da:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d90de:	ff 50 48             	callq  *0x48(%rax)
  8d90e1:	48 83 c4 20          	add    $0x20,%rsp
  8d90e5:	eb 1e                	jmp    8d9105 <efi_random_get_seed+0x29e>
  8d90e7:	4d 85 e4             	test   %r12,%r12
  8d90ea:	74 85                	je     8d9071 <efi_random_get_seed+0x20a>
  8d90ec:	48 8b 05 0d ab 01 00 	mov    0x1ab0d(%rip),%rax        # 8f3c00 <efi_system_table>
  8d90f3:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d90f8:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d90fb:	8b 78 30             	mov    0x30(%rax),%edi
  8d90fe:	31 c0                	xor    %eax,%eax
  8d9100:	e8 7b bc ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9105:	48 83 c4 48          	add    $0x48,%rsp
  8d9109:	4c 89 e0             	mov    %r12,%rax
  8d910c:	5b                   	pop    %rbx
  8d910d:	41 5c                	pop    %r12
  8d910f:	c3                   	retq   

00000000008d9110 <efi_low_alloc_above>:
  8d9110:	f3 0f 1e fa          	endbr64 
  8d9114:	41 57                	push   %r15
  8d9116:	49 89 d7             	mov    %rdx,%r15
  8d9119:	41 56                	push   %r14
  8d911b:	41 55                	push   %r13
  8d911d:	41 54                	push   %r12
  8d911f:	55                   	push   %rbp
  8d9120:	48 89 f5             	mov    %rsi,%rbp
  8d9123:	53                   	push   %rbx
  8d9124:	48 89 fb             	mov    %rdi,%rbx
  8d9127:	48 83 ec 78          	sub    $0x78,%rsp
  8d912b:	48 8d 44 24 30       	lea    0x30(%rsp),%rax
  8d9130:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  8d9135:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d913a:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8d913f:	48 8d 44 24 18       	lea    0x18(%rsp),%rax
  8d9144:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8d9149:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  8d914e:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9153:	48 8d 44 24 28       	lea    0x28(%rsp),%rax
  8d9158:	48 c7 44 24 58 00 00 	movq   $0x0,0x58(%rsp)
  8d915f:	00 00 
  8d9161:	48 c7 44 24 60 00 00 	movq   $0x0,0x60(%rsp)
  8d9168:	00 00 
  8d916a:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
  8d916f:	e8 9a f3 ff ff       	callq  8d850e <efi_get_memory_map>
  8d9174:	49 89 c5             	mov    %rax,%r13
  8d9177:	48 85 c0             	test   %rax,%rax
  8d917a:	0f 85 54 01 00 00    	jne    8d92d4 <efi_low_alloc_above+0x1c4>
  8d9180:	48 81 fd 00 10 00 00 	cmp    $0x1000,%rbp
  8d9187:	be 00 10 00 00       	mov    $0x1000,%esi
  8d918c:	48 0f 42 ee          	cmovb  %rsi,%rbp
  8d9190:	48 ff cb             	dec    %rbx
  8d9193:	45 31 e4             	xor    %r12d,%r12d
  8d9196:	48 81 cb ff 0f 00 00 	or     $0xfff,%rbx
  8d919d:	48 ff c3             	inc    %rbx
  8d91a0:	48 ff cd             	dec    %rbp
  8d91a3:	49 89 de             	mov    %rbx,%r14
  8d91a6:	49 c1 ee 0c          	shr    $0xc,%r14
  8d91aa:	48 8b 4c 24 20       	mov    0x20(%rsp),%rcx
  8d91af:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  8d91b4:	31 d2                	xor    %edx,%edx
  8d91b6:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8d91bb:	48 f7 f1             	div    %rcx
  8d91be:	4c 39 e0             	cmp    %r12,%rax
  8d91c1:	0f 86 b6 00 00 00    	jbe    8d927d <efi_low_alloc_above+0x16d>
  8d91c7:	49 0f af cc          	imul   %r12,%rcx
  8d91cb:	48 01 f1             	add    %rsi,%rcx
  8d91ce:	83 39 07             	cmpl   $0x7,(%rcx)
  8d91d1:	0f 85 9e 00 00 00    	jne    8d9275 <efi_low_alloc_above+0x165>
  8d91d7:	48 8b 41 18          	mov    0x18(%rcx),%rax
  8d91db:	4c 39 f0             	cmp    %r14,%rax
  8d91de:	0f 82 91 00 00 00    	jb     8d9275 <efi_low_alloc_above+0x165>
  8d91e4:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  8d91e8:	48 c1 e0 0c          	shl    $0xc,%rax
  8d91ec:	48 01 d0             	add    %rdx,%rax
  8d91ef:	48 3b 54 24 08       	cmp    0x8(%rsp),%rdx
  8d91f4:	48 0f 42 54 24 08    	cmovb  0x8(%rsp),%rdx
  8d91fa:	48 ff ca             	dec    %rdx
  8d91fd:	48 09 ea             	or     %rbp,%rdx
  8d9200:	48 ff c2             	inc    %rdx
  8d9203:	48 89 54 24 38       	mov    %rdx,0x38(%rsp)
  8d9208:	48 01 da             	add    %rbx,%rdx
  8d920b:	48 39 c2             	cmp    %rax,%rdx
  8d920e:	77 65                	ja     8d9275 <efi_low_alloc_above+0x165>
  8d9210:	80 3d f9 2f 00 00 00 	cmpb   $0x0,0x2ff9(%rip)        # 8dc210 <efi_is64>
  8d9217:	48 8b 05 e2 a9 01 00 	mov    0x1a9e2(%rip),%rax        # 8f3c00 <efi_system_table>
  8d921e:	4c 8d 44 24 38       	lea    0x38(%rsp),%r8
  8d9223:	74 24                	je     8d9249 <efi_low_alloc_above+0x139>
  8d9225:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d9229:	48 83 ec 20          	sub    $0x20,%rsp
  8d922d:	4d 89 c1             	mov    %r8,%r9
  8d9230:	ba 02 00 00 00       	mov    $0x2,%edx
  8d9235:	4d 89 f0             	mov    %r14,%r8
  8d9238:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d923d:	ff 50 28             	callq  *0x28(%rax)
  8d9240:	49 89 c5             	mov    %rax,%r13
  8d9243:	48 83 c4 20          	add    $0x20,%rsp
  8d9247:	eb 1d                	jmp    8d9266 <efi_low_alloc_above+0x156>
  8d9249:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d924c:	4c 89 f1             	mov    %r14,%rcx
  8d924f:	ba 02 00 00 00       	mov    $0x2,%edx
  8d9254:	be 02 00 00 00       	mov    $0x2,%esi
  8d9259:	8b 78 20             	mov    0x20(%rax),%edi
  8d925c:	31 c0                	xor    %eax,%eax
  8d925e:	e8 1d bb ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9263:	49 89 c5             	mov    %rax,%r13
  8d9266:	4d 85 ed             	test   %r13,%r13
  8d9269:	75 0a                	jne    8d9275 <efi_low_alloc_above+0x165>
  8d926b:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8d9270:	49 89 07             	mov    %rax,(%r15)
  8d9273:	eb 08                	jmp    8d927d <efi_low_alloc_above+0x16d>
  8d9275:	49 ff c4             	inc    %r12
  8d9278:	e9 2d ff ff ff       	jmpq   8d91aa <efi_low_alloc_above+0x9a>
  8d927d:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
  8d9282:	31 d2                	xor    %edx,%edx
  8d9284:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
  8d9289:	48 f7 74 24 20       	divq   0x20(%rsp)
  8d928e:	4c 39 e0             	cmp    %r12,%rax
  8d9291:	48 b8 0e 00 00 00 00 	movabs $0x800000000000000e,%rax
  8d9298:	00 00 80 
  8d929b:	4c 0f 44 e8          	cmove  %rax,%r13
  8d929f:	80 3d 6a 2f 00 00 00 	cmpb   $0x0,0x2f6a(%rip)        # 8dc210 <efi_is64>
  8d92a6:	48 8b 05 53 a9 01 00 	mov    0x1a953(%rip),%rax        # 8f3c00 <efi_system_table>
  8d92ad:	74 11                	je     8d92c0 <efi_low_alloc_above+0x1b0>
  8d92af:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d92b3:	48 83 ec 20          	sub    $0x20,%rsp
  8d92b7:	ff 50 48             	callq  *0x48(%rax)
  8d92ba:	48 83 c4 20          	add    $0x20,%rsp
  8d92be:	eb 14                	jmp    8d92d4 <efi_low_alloc_above+0x1c4>
  8d92c0:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d92c3:	48 89 ce             	mov    %rcx,%rsi
  8d92c6:	8b 78 30             	mov    0x30(%rax),%edi
  8d92c9:	31 c0                	xor    %eax,%eax
  8d92cb:	e8 b0 ba ff ff       	callq  8d4d80 <__efi64_thunk>
  8d92d0:	f3 0f 1e fa          	endbr64 
  8d92d4:	48 83 c4 78          	add    $0x78,%rsp
  8d92d8:	4c 89 e8             	mov    %r13,%rax
  8d92db:	5b                   	pop    %rbx
  8d92dc:	5d                   	pop    %rbp
  8d92dd:	41 5c                	pop    %r12
  8d92df:	41 5d                	pop    %r13
  8d92e1:	41 5e                	pop    %r14
  8d92e3:	41 5f                	pop    %r15
  8d92e5:	c3                   	retq   

00000000008d92e6 <efi_relocate_kernel>:
  8d92e6:	f3 0f 1e fa          	endbr64 
  8d92ea:	41 57                	push   %r15
  8d92ec:	49 89 d7             	mov    %rdx,%r15
  8d92ef:	41 56                	push   %r14
  8d92f1:	41 55                	push   %r13
  8d92f3:	41 54                	push   %r12
  8d92f5:	55                   	push   %rbp
  8d92f6:	53                   	push   %rbx
  8d92f7:	48 83 ec 18          	sub    $0x18,%rsp
  8d92fb:	48 85 f6             	test   %rsi,%rsi
  8d92fe:	0f 94 c0             	sete   %al
  8d9301:	48 39 d6             	cmp    %rdx,%rsi
  8d9304:	48 89 4c 24 08       	mov    %rcx,0x8(%rsp)
  8d9309:	0f 97 c2             	seta   %dl
  8d930c:	48 c7 04 24 00 00 00 	movq   $0x0,(%rsp)
  8d9313:	00 
  8d9314:	09 d0                	or     %edx,%eax
  8d9316:	4d 85 ff             	test   %r15,%r15
  8d9319:	0f 94 c2             	sete   %dl
  8d931c:	08 d0                	or     %dl,%al
  8d931e:	0f 85 c9 00 00 00    	jne    8d93ed <efi_relocate_kernel+0x107>
  8d9324:	48 89 fb             	mov    %rdi,%rbx
  8d9327:	48 85 ff             	test   %rdi,%rdi
  8d932a:	0f 84 bd 00 00 00    	je     8d93ed <efi_relocate_kernel+0x107>
  8d9330:	49 8d 4f ff          	lea    -0x1(%r15),%rcx
  8d9334:	4c 89 c5             	mov    %r8,%rbp
  8d9337:	4c 8b 37             	mov    (%rdi),%r14
  8d933a:	49 89 f4             	mov    %rsi,%r12
  8d933d:	48 81 c9 ff 0f 00 00 	or     $0xfff,%rcx
  8d9344:	48 8b 05 b5 a8 01 00 	mov    0x1a8b5(%rip),%rax        # 8f3c00 <efi_system_table>
  8d934b:	4d 89 cd             	mov    %r9,%r13
  8d934e:	4c 8d 44 24 08       	lea    0x8(%rsp),%r8
  8d9353:	48 ff c1             	inc    %rcx
  8d9356:	48 c1 e9 0c          	shr    $0xc,%rcx
  8d935a:	80 3d af 2e 00 00 00 	cmpb   $0x0,0x2eaf(%rip)        # 8dc210 <efi_is64>
  8d9361:	74 21                	je     8d9384 <efi_relocate_kernel+0x9e>
  8d9363:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d9367:	48 83 ec 20          	sub    $0x20,%rsp
  8d936b:	4d 89 c1             	mov    %r8,%r9
  8d936e:	ba 02 00 00 00       	mov    $0x2,%edx
  8d9373:	49 89 c8             	mov    %rcx,%r8
  8d9376:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d937b:	ff 50 28             	callq  *0x28(%rax)
  8d937e:	48 83 c4 20          	add    $0x20,%rsp
  8d9382:	eb 17                	jmp    8d939b <efi_relocate_kernel+0xb5>
  8d9384:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d9387:	ba 02 00 00 00       	mov    $0x2,%edx
  8d938c:	be 02 00 00 00       	mov    $0x2,%esi
  8d9391:	8b 78 20             	mov    0x20(%rax),%edi
  8d9394:	31 c0                	xor    %eax,%eax
  8d9396:	e8 e5 b9 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d939b:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d93a0:	48 89 14 24          	mov    %rdx,(%rsp)
  8d93a4:	48 85 c0             	test   %rax,%rax
  8d93a7:	74 29                	je     8d93d2 <efi_relocate_kernel+0xec>
  8d93a9:	4c 89 e9             	mov    %r13,%rcx
  8d93ac:	48 89 e2             	mov    %rsp,%rdx
  8d93af:	48 89 ee             	mov    %rbp,%rsi
  8d93b2:	4c 89 ff             	mov    %r15,%rdi
  8d93b5:	e8 56 fd ff ff       	callq  8d9110 <efi_low_alloc_above>
  8d93ba:	49 89 c5             	mov    %rax,%r13
  8d93bd:	48 85 c0             	test   %rax,%rax
  8d93c0:	74 10                	je     8d93d2 <efi_relocate_kernel+0xec>
  8d93c2:	48 8d 3d e4 2a 00 00 	lea    0x2ae4(%rip),%rdi        # 8dbead <kernel_info_end+0xd1d>
  8d93c9:	31 c0                	xor    %eax,%eax
  8d93cb:	e8 fc cd ff ff       	callq  8d61cc <efi_printk>
  8d93d0:	eb 25                	jmp    8d93f7 <efi_relocate_kernel+0x111>
  8d93d2:	48 8b 3c 24          	mov    (%rsp),%rdi
  8d93d6:	4c 89 e2             	mov    %r12,%rdx
  8d93d9:	4c 89 f6             	mov    %r14,%rsi
  8d93dc:	45 31 ed             	xor    %r13d,%r13d
  8d93df:	e8 0c 9d ff ff       	callq  8d30f0 <memcpy>
  8d93e4:	48 8b 04 24          	mov    (%rsp),%rax
  8d93e8:	48 89 03             	mov    %rax,(%rbx)
  8d93eb:	eb 0a                	jmp    8d93f7 <efi_relocate_kernel+0x111>
  8d93ed:	49 bd 02 00 00 00 00 	movabs $0x8000000000000002,%r13
  8d93f4:	00 00 80 
  8d93f7:	48 83 c4 18          	add    $0x18,%rsp
  8d93fb:	4c 89 e8             	mov    %r13,%rax
  8d93fe:	5b                   	pop    %rbx
  8d93ff:	5d                   	pop    %rbp
  8d9400:	41 5c                	pop    %r12
  8d9402:	41 5d                	pop    %r13
  8d9404:	41 5e                	pop    %r14
  8d9406:	41 5f                	pop    %r15
  8d9408:	c3                   	retq   

00000000008d9409 <get_var>:
  8d9409:	80 3d 00 2e 00 00 00 	cmpb   $0x0,0x2e00(%rip)        # 8dc210 <efi_is64>
  8d9410:	41 54                	push   %r12
  8d9412:	49 89 fa             	mov    %rdi,%r10
  8d9415:	49 89 d4             	mov    %rdx,%r12
  8d9418:	48 8b 05 e1 a7 01 00 	mov    0x1a7e1(%rip),%rax        # 8f3c00 <efi_system_table>
  8d941f:	4d 89 c1             	mov    %r8,%r9
  8d9422:	74 21                	je     8d9445 <get_var+0x3c>
  8d9424:	52                   	push   %rdx
  8d9425:	48 8b 40 58          	mov    0x58(%rax),%rax
  8d9429:	49 89 c9             	mov    %rcx,%r9
  8d942c:	48 89 f2             	mov    %rsi,%rdx
  8d942f:	41 50                	push   %r8
  8d9431:	48 89 f9             	mov    %rdi,%rcx
  8d9434:	4d 89 e0             	mov    %r12,%r8
  8d9437:	48 83 ec 20          	sub    $0x20,%rsp
  8d943b:	ff 50 48             	callq  *0x48(%rax)
  8d943e:	48 83 c4 30          	add    $0x30,%rsp
  8d9442:	41 5c                	pop    %r12
  8d9444:	c3                   	retq   
  8d9445:	8b 40 38             	mov    0x38(%rax),%eax
  8d9448:	49 89 c8             	mov    %rcx,%r8
  8d944b:	41 5c                	pop    %r12
  8d944d:	48 89 d1             	mov    %rdx,%rcx
  8d9450:	48 89 f2             	mov    %rsi,%rdx
  8d9453:	4c 89 d6             	mov    %r10,%rsi
  8d9456:	8b 78 30             	mov    0x30(%rax),%edi
  8d9459:	31 c0                	xor    %eax,%eax
  8d945b:	e9 20 b9 ff ff       	jmpq   8d4d80 <__efi64_thunk>

00000000008d9460 <efi_get_secureboot>:
  8d9460:	f3 0f 1e fa          	endbr64 
  8d9464:	41 55                	push   %r13
  8d9466:	31 d2                	xor    %edx,%edx
  8d9468:	48 8d 3d 75 2a 00 00 	lea    0x2a75(%rip),%rdi        # 8dbee4 <kernel_info_end+0xd54>
  8d946f:	49 bd 61 df e4 8b ca 	movabs $0x11d293ca8be4df61,%r13
  8d9476:	93 d2 11 
  8d9479:	41 54                	push   %r12
  8d947b:	55                   	push   %rbp
  8d947c:	48 bd aa 0d 00 e0 98 	movabs $0x8c2b0398e0000daa,%rbp
  8d9483:	03 2b 8c 
  8d9486:	53                   	push   %rbx
  8d9487:	48 83 ec 38          	sub    $0x38,%rsp
  8d948b:	48 8d 5c 24 08       	lea    0x8(%rsp),%rbx
  8d9490:	4c 8d 64 24 10       	lea    0x10(%rsp),%r12
  8d9495:	c6 44 24 07 00       	movb   $0x0,0x7(%rsp)
  8d949a:	4c 8d 44 24 06       	lea    0x6(%rsp),%r8
  8d949f:	48 89 d9             	mov    %rbx,%rcx
  8d94a2:	4c 89 e6             	mov    %r12,%rsi
  8d94a5:	4c 89 6c 24 10       	mov    %r13,0x10(%rsp)
  8d94aa:	48 c7 44 24 08 01 00 	movq   $0x1,0x8(%rsp)
  8d94b1:	00 00 
  8d94b3:	48 89 6c 24 18       	mov    %rbp,0x18(%rsp)
  8d94b8:	e8 4c ff ff ff       	callq  8d9409 <get_var>
  8d94bd:	48 ba 0e 00 00 00 00 	movabs $0x800000000000000e,%rdx
  8d94c4:	00 00 80 
  8d94c7:	48 39 d0             	cmp    %rdx,%rax
  8d94ca:	75 0a                	jne    8d94d6 <efi_get_secureboot+0x76>
  8d94cc:	b8 02 00 00 00       	mov    $0x2,%eax
  8d94d1:	e9 e8 00 00 00       	jmpq   8d95be <efi_get_secureboot+0x15e>
  8d94d6:	48 85 c0             	test   %rax,%rax
  8d94d9:	75 7f                	jne    8d955a <efi_get_secureboot+0xfa>
  8d94db:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
  8d94e0:	48 8d 6c 24 20       	lea    0x20(%rsp),%rbp
  8d94e5:	31 d2                	xor    %edx,%edx
  8d94e7:	48 89 d9             	mov    %rbx,%rcx
  8d94ea:	4c 8d 44 24 07       	lea    0x7(%rsp),%r8
  8d94ef:	48 89 ee             	mov    %rbp,%rsi
  8d94f2:	48 8d 3d 01 2a 00 00 	lea    0x2a01(%rip),%rdi        # 8dbefa <kernel_info_end+0xd6a>
  8d94f9:	48 c7 44 24 08 01 00 	movq   $0x1,0x8(%rsp)
  8d9500:	00 00 
  8d9502:	4c 89 6c 24 20       	mov    %r13,0x20(%rsp)
  8d9507:	e8 fd fe ff ff       	callq  8d9409 <get_var>
  8d950c:	80 7c 24 06 00       	cmpb   $0x0,0x6(%rsp)
  8d9511:	74 b9                	je     8d94cc <efi_get_secureboot+0x6c>
  8d9513:	80 7c 24 07 01       	cmpb   $0x1,0x7(%rsp)
  8d9518:	74 b2                	je     8d94cc <efi_get_secureboot+0x6c>
  8d951a:	80 3d ef 2c 00 00 00 	cmpb   $0x0,0x2cef(%rip)        # 8dc210 <efi_is64>
  8d9521:	48 8b 05 d8 a6 01 00 	mov    0x1a6d8(%rip),%rax        # 8f3c00 <efi_system_table>
  8d9528:	48 c7 44 24 20 01 00 	movq   $0x1,0x20(%rsp)
  8d952f:	00 00 
  8d9531:	74 3c                	je     8d956f <efi_get_secureboot+0x10f>
  8d9533:	52                   	push   %rdx
  8d9534:	48 8b 40 58          	mov    0x58(%rax),%rax
  8d9538:	49 89 e9             	mov    %rbp,%r9
  8d953b:	4d 89 e0             	mov    %r12,%r8
  8d953e:	53                   	push   %rbx
  8d953f:	48 8d 15 ba 1b 00 00 	lea    0x1bba(%rip),%rdx        # 8db100 <shim_guid>
  8d9546:	48 8d 0d 93 1b 00 00 	lea    0x1b93(%rip),%rcx        # 8db0e0 <shim_MokSBState_name>
  8d954d:	48 83 ec 20          	sub    $0x20,%rsp
  8d9551:	ff 50 48             	callq  *0x48(%rax)
  8d9554:	48 83 c4 30          	add    $0x30,%rsp
  8d9558:	eb 39                	jmp    8d9593 <efi_get_secureboot+0x133>
  8d955a:	48 8d 3d ad 29 00 00 	lea    0x29ad(%rip),%rdi        # 8dbf0e <kernel_info_end+0xd7e>
  8d9561:	31 c0                	xor    %eax,%eax
  8d9563:	e8 64 cc ff ff       	callq  8d61cc <efi_printk>
  8d9568:	b8 01 00 00 00       	mov    $0x1,%eax
  8d956d:	eb 4f                	jmp    8d95be <efi_get_secureboot+0x15e>
  8d956f:	8b 40 38             	mov    0x38(%rax),%eax
  8d9572:	49 89 d9             	mov    %rbx,%r9
  8d9575:	49 89 e8             	mov    %rbp,%r8
  8d9578:	4c 89 e1             	mov    %r12,%rcx
  8d957b:	48 8d 15 7e 1b 00 00 	lea    0x1b7e(%rip),%rdx        # 8db100 <shim_guid>
  8d9582:	48 8d 35 57 1b 00 00 	lea    0x1b57(%rip),%rsi        # 8db0e0 <shim_MokSBState_name>
  8d9589:	8b 78 30             	mov    0x30(%rax),%edi
  8d958c:	31 c0                	xor    %eax,%eax
  8d958e:	e8 ed b7 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9593:	48 85 c0             	test   %rax,%rax
  8d9596:	75 13                	jne    8d95ab <efi_get_secureboot+0x14b>
  8d9598:	f6 44 24 10 04       	testb  $0x4,0x10(%rsp)
  8d959d:	75 0c                	jne    8d95ab <efi_get_secureboot+0x14b>
  8d959f:	80 7c 24 08 01       	cmpb   $0x1,0x8(%rsp)
  8d95a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8d95a9:	74 13                	je     8d95be <efi_get_secureboot+0x15e>
  8d95ab:	48 8d 3d 93 29 00 00 	lea    0x2993(%rip),%rdi        # 8dbf45 <kernel_info_end+0xdb5>
  8d95b2:	31 c0                	xor    %eax,%eax
  8d95b4:	e8 13 cc ff ff       	callq  8d61cc <efi_printk>
  8d95b9:	b8 03 00 00 00       	mov    $0x3,%eax
  8d95be:	48 83 c4 38          	add    $0x38,%rsp
  8d95c2:	5b                   	pop    %rbx
  8d95c3:	5d                   	pop    %rbp
  8d95c4:	41 5c                	pop    %r12
  8d95c6:	41 5d                	pop    %r13
  8d95c8:	c3                   	retq   

00000000008d95c9 <skip_spaces>:
  8d95c9:	f3 0f 1e fa          	endbr64 
  8d95cd:	48 89 f8             	mov    %rdi,%rax
  8d95d0:	48 8d 0d 09 1a 00 00 	lea    0x1a09(%rip),%rcx        # 8dafe0 <_ctype>
  8d95d7:	0f b6 10             	movzbl (%rax),%edx
  8d95da:	f6 04 11 20          	testb  $0x20,(%rcx,%rdx,1)
  8d95de:	74 05                	je     8d95e5 <skip_spaces+0x1c>
  8d95e0:	48 ff c0             	inc    %rax
  8d95e3:	eb f2                	jmp    8d95d7 <skip_spaces+0xe>
  8d95e5:	c3                   	retq   

00000000008d95e6 <__calc_tpm2_event_size.constprop.0>:
  8d95e6:	41 57                	push   %r15
  8d95e8:	31 c0                	xor    %eax,%eax
  8d95ea:	b9 03 00 00 00       	mov    $0x3,%ecx
  8d95ef:	41 56                	push   %r14
  8d95f1:	41 55                	push   %r13
  8d95f3:	41 54                	push   %r12
  8d95f5:	49 89 fc             	mov    %rdi,%r12
  8d95f8:	55                   	push   %rbp
  8d95f9:	53                   	push   %rbx
  8d95fa:	48 83 ec 38          	sub    $0x38,%rsp
  8d95fe:	45 8b 74 24 08       	mov    0x8(%r12),%r14d
  8d9603:	83 3e 00             	cmpl   $0x0,(%rsi)
  8d9606:	48 c7 44 24 1c 00 00 	movq   $0x0,0x1c(%rsp)
  8d960d:	00 00 
  8d960f:	48 8d 7c 24 24       	lea    0x24(%rsp),%rdi
  8d9614:	f3 ab                	rep stos %eax,%es:(%rdi)
  8d9616:	41 8b 44 24 04       	mov    0x4(%r12),%eax
  8d961b:	89 44 24 0c          	mov    %eax,0xc(%rsp)
  8d961f:	0f 85 b6 00 00 00    	jne    8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d9625:	83 7e 04 03          	cmpl   $0x3,0x4(%rsi)
  8d9629:	48 89 f3             	mov    %rsi,%rbx
  8d962c:	0f 85 a9 00 00 00    	jne    8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d9632:	48 8d 74 24 1c       	lea    0x1c(%rsp),%rsi
  8d9637:	48 8d 7b 08          	lea    0x8(%rbx),%rdi
  8d963b:	ba 14 00 00 00       	mov    $0x14,%edx
  8d9640:	e8 eb 96 ff ff       	callq  8d2d30 <memcmp>
  8d9645:	85 c0                	test   %eax,%eax
  8d9647:	0f 85 8e 00 00 00    	jne    8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d964d:	48 8d 7b 20          	lea    0x20(%rbx),%rdi
  8d9651:	ba 10 00 00 00       	mov    $0x10,%edx
  8d9656:	48 8d 35 08 29 00 00 	lea    0x2908(%rip),%rsi        # 8dbf65 <kernel_info_end+0xdd5>
  8d965d:	e8 ce 96 ff ff       	callq  8d2d30 <memcmp>
  8d9662:	41 89 c5             	mov    %eax,%r13d
  8d9665:	85 c0                	test   %eax,%eax
  8d9667:	75 72                	jne    8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d9669:	8b 43 38             	mov    0x38(%rbx),%eax
  8d966c:	85 c0                	test   %eax,%eax
  8d966e:	74 6b                	je     8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d9670:	41 39 c6             	cmp    %eax,%r14d
  8d9673:	75 66                	jne    8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d9675:	49 8d 6c 24 0c       	lea    0xc(%r12),%rbp
  8d967a:	4c 8d 7c 24 1a       	lea    0x1a(%rsp),%r15
  8d967f:	45 39 f5             	cmp    %r14d,%r13d
  8d9682:	74 42                	je     8d96c6 <__calc_tpm2_event_size.constprop.0+0xe0>
  8d9684:	48 89 ee             	mov    %rbp,%rsi
  8d9687:	ba 02 00 00 00       	mov    $0x2,%edx
  8d968c:	4c 89 ff             	mov    %r15,%rdi
  8d968f:	48 83 c5 02          	add    $0x2,%rbp
  8d9693:	e8 58 9a ff ff       	callq  8d30f0 <memcpy>
  8d9698:	8b 4b 38             	mov    0x38(%rbx),%ecx
  8d969b:	66 8b 74 24 1a       	mov    0x1a(%rsp),%si
  8d96a0:	31 c0                	xor    %eax,%eax
  8d96a2:	48 63 d0             	movslq %eax,%rdx
  8d96a5:	39 c1                	cmp    %eax,%ecx
  8d96a7:	76 14                	jbe    8d96bd <__calc_tpm2_event_size.constprop.0+0xd7>
  8d96a9:	48 ff c0             	inc    %rax
  8d96ac:	66 39 74 83 38       	cmp    %si,0x38(%rbx,%rax,4)
  8d96b1:	75 ef                	jne    8d96a2 <__calc_tpm2_event_size.constprop.0+0xbc>
  8d96b3:	0f b7 44 93 3e       	movzwl 0x3e(%rbx,%rdx,4),%eax
  8d96b8:	48 01 c5             	add    %rax,%rbp
  8d96bb:	eb 04                	jmp    8d96c1 <__calc_tpm2_event_size.constprop.0+0xdb>
  8d96bd:	39 d1                	cmp    %edx,%ecx
  8d96bf:	74 1a                	je     8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d96c1:	41 ff c5             	inc    %r13d
  8d96c4:	eb b9                	jmp    8d967f <__calc_tpm2_event_size.constprop.0+0x99>
  8d96c6:	8b 45 00             	mov    0x0(%rbp),%eax
  8d96c9:	8b 4c 24 0c          	mov    0xc(%rsp),%ecx
  8d96cd:	09 c1                	or     %eax,%ecx
  8d96cf:	74 0a                	je     8d96db <__calc_tpm2_event_size.constprop.0+0xf5>
  8d96d1:	48 8d 44 05 04       	lea    0x4(%rbp,%rax,1),%rax
  8d96d6:	4c 29 e0             	sub    %r12,%rax
  8d96d9:	eb 02                	jmp    8d96dd <__calc_tpm2_event_size.constprop.0+0xf7>
  8d96db:	31 c0                	xor    %eax,%eax
  8d96dd:	48 83 c4 38          	add    $0x38,%rsp
  8d96e1:	5b                   	pop    %rbx
  8d96e2:	5d                   	pop    %rbp
  8d96e3:	41 5c                	pop    %r12
  8d96e5:	41 5d                	pop    %r13
  8d96e7:	41 5e                	pop    %r14
  8d96e9:	41 5f                	pop    %r15
  8d96eb:	c3                   	retq   

00000000008d96ec <efi_retrieve_tpm2_eventlog>:
  8d96ec:	f3 0f 1e fa          	endbr64 
  8d96f0:	48 b8 6c 76 7f 60 55 	movabs $0x42be7455607f766c,%rax
  8d96f7:	74 be 42 
  8d96fa:	41 57                	push   %r15
  8d96fc:	41 56                	push   %r14
  8d96fe:	41 55                	push   %r13
  8d9700:	41 54                	push   %r12
  8d9702:	55                   	push   %rbp
  8d9703:	53                   	push   %rbx
  8d9704:	48 83 ec 68          	sub    $0x68,%rsp
  8d9708:	80 3d 01 2b 00 00 00 	cmpb   $0x0,0x2b01(%rip)        # 8dc210 <efi_is64>
  8d970f:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
  8d9714:	4c 8d 44 24 38       	lea    0x38(%rsp),%r8
  8d9719:	48 b8 93 0b e4 d7 6d 	movabs $0xf72b26dd7e40b93,%rax
  8d9720:	b2 72 0f 
  8d9723:	48 8d 74 24 40       	lea    0x40(%rsp),%rsi
  8d9728:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  8d972d:	48 b8 b0 9c 79 b7 a2 	movabs $0x4943eca2b7799cb0,%rax
  8d9734:	ec 43 49 
  8d9737:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d973c:	48 b8 96 67 1f ae 07 	movabs $0xfa47b707ae1f6796,%rax
  8d9743:	b7 47 fa 
  8d9746:	48 89 44 24 58       	mov    %rax,0x58(%rsp)
  8d974b:	48 8b 05 ae a4 01 00 	mov    0x1a4ae(%rip),%rax        # 8f3c00 <efi_system_table>
  8d9752:	48 c7 44 24 20 00 00 	movq   $0x0,0x20(%rsp)
  8d9759:	00 00 
  8d975b:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
  8d9762:	00 00 
  8d9764:	48 c7 44 24 30 00 00 	movq   $0x0,0x30(%rsp)
  8d976b:	00 00 
  8d976d:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
  8d9774:	00 00 
  8d9776:	74 21                	je     8d9799 <efi_retrieve_tpm2_eventlog+0xad>
  8d9778:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d977c:	48 83 ec 20          	sub    $0x20,%rsp
  8d9780:	31 d2                	xor    %edx,%edx
  8d9782:	48 89 f1             	mov    %rsi,%rcx
  8d9785:	ff 90 40 01 00 00    	callq  *0x140(%rax)
  8d978b:	48 83 c4 20          	add    $0x20,%rsp
  8d978f:	48 85 c0             	test   %rax,%rax
  8d9792:	74 2c                	je     8d97c0 <efi_retrieve_tpm2_eventlog+0xd4>
  8d9794:	e9 b1 02 00 00       	jmpq   8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d9799:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d979c:	31 d2                	xor    %edx,%edx
  8d979e:	4c 89 c1             	mov    %r8,%rcx
  8d97a1:	c7 44 24 3c 00 00 00 	movl   $0x0,0x3c(%rsp)
  8d97a8:	00 
  8d97a9:	8b b8 ac 00 00 00    	mov    0xac(%rax),%edi
  8d97af:	31 c0                	xor    %eax,%eax
  8d97b1:	e8 ca b5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d97b6:	48 85 c0             	test   %rax,%rax
  8d97b9:	74 78                	je     8d9833 <efi_retrieve_tpm2_eventlog+0x147>
  8d97bb:	e9 8a 02 00 00       	jmpq   8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d97c0:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8d97c5:	51                   	push   %rcx
  8d97c6:	48 89 c1             	mov    %rax,%rcx
  8d97c9:	48 8d 54 24 27       	lea    0x27(%rsp),%rdx
  8d97ce:	52                   	push   %rdx
  8d97cf:	ba 02 00 00 00       	mov    $0x2,%edx
  8d97d4:	48 83 ec 20          	sub    $0x20,%rsp
  8d97d8:	4c 8d 4c 24 58       	lea    0x58(%rsp),%r9
  8d97dd:	4c 8d 44 24 50       	lea    0x50(%rsp),%r8
  8d97e2:	ff 50 08             	callq  *0x8(%rax)
  8d97e5:	48 83 c4 30          	add    $0x30,%rsp
  8d97e9:	48 85 c0             	test   %rax,%rax
  8d97ec:	75 1a                	jne    8d9808 <efi_retrieve_tpm2_eventlog+0x11c>
  8d97ee:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  8d97f4:	bd 02 00 00 00       	mov    $0x2,%ebp
  8d97f9:	0f 85 99 00 00 00    	jne    8d9898 <efi_retrieve_tpm2_eventlog+0x1ac>
  8d97ff:	80 3d 0a 2a 00 00 00 	cmpb   $0x0,0x2a0a(%rip)        # 8dc210 <efi_is64>
  8d9806:	74 53                	je     8d985b <efi_retrieve_tpm2_eventlog+0x16f>
  8d9808:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
  8d980d:	52                   	push   %rdx
  8d980e:	48 89 c1             	mov    %rax,%rcx
  8d9811:	48 8d 54 24 27       	lea    0x27(%rsp),%rdx
  8d9816:	52                   	push   %rdx
  8d9817:	ba 01 00 00 00       	mov    $0x1,%edx
  8d981c:	48 83 ec 20          	sub    $0x20,%rsp
  8d9820:	4c 8d 4c 24 58       	lea    0x58(%rsp),%r9
  8d9825:	4c 8d 44 24 50       	lea    0x50(%rsp),%r8
  8d982a:	ff 50 08             	callq  *0x8(%rax)
  8d982d:	48 83 c4 30          	add    $0x30,%rsp
  8d9831:	eb 4b                	jmp    8d987e <efi_retrieve_tpm2_eventlog+0x192>
  8d9833:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8d9838:	31 c0                	xor    %eax,%eax
  8d983a:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  8d983f:	4c 8d 4c 24 1f       	lea    0x1f(%rsp),%r9
  8d9844:	4c 8d 44 24 28       	lea    0x28(%rsp),%r8
  8d9849:	ba 02 00 00 00       	mov    $0x2,%edx
  8d984e:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d9851:	e8 2a b5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9856:	48 85 c0             	test   %rax,%rax
  8d9859:	74 93                	je     8d97ee <efi_retrieve_tpm2_eventlog+0x102>
  8d985b:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
  8d9860:	48 8d 4c 24 20       	lea    0x20(%rsp),%rcx
  8d9865:	4c 8d 4c 24 1f       	lea    0x1f(%rsp),%r9
  8d986a:	31 c0                	xor    %eax,%eax
  8d986c:	4c 8d 44 24 28       	lea    0x28(%rsp),%r8
  8d9871:	ba 01 00 00 00       	mov    $0x1,%edx
  8d9876:	8b 7e 04             	mov    0x4(%rsi),%edi
  8d9879:	e8 02 b5 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d987e:	48 85 c0             	test   %rax,%rax
  8d9881:	0f 85 c3 01 00 00    	jne    8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d9887:	48 83 7c 24 20 00    	cmpq   $0x0,0x20(%rsp)
  8d988d:	0f 84 b7 01 00 00    	je     8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d9893:	bd 01 00 00 00       	mov    $0x1,%ebp
  8d9898:	4c 8b 64 24 28       	mov    0x28(%rsp),%r12
  8d989d:	4c 8b 6c 24 20       	mov    0x20(%rsp),%r13
  8d98a2:	4d 85 e4             	test   %r12,%r12
  8d98a5:	74 28                	je     8d98cf <efi_retrieve_tpm2_eventlog+0x1e3>
  8d98a7:	83 fd 02             	cmp    $0x2,%ebp
  8d98aa:	75 10                	jne    8d98bc <efi_retrieve_tpm2_eventlog+0x1d0>
  8d98ac:	4c 89 e7             	mov    %r12,%rdi
  8d98af:	4c 89 ee             	mov    %r13,%rsi
  8d98b2:	e8 2f fd ff ff       	callq  8d95e6 <__calc_tpm2_event_size.constprop.0>
  8d98b7:	4c 63 e0             	movslq %eax,%r12
  8d98ba:	eb 09                	jmp    8d98c5 <efi_retrieve_tpm2_eventlog+0x1d9>
  8d98bc:	45 8b 64 24 1c       	mov    0x1c(%r12),%r12d
  8d98c1:	49 83 c4 20          	add    $0x20,%r12
  8d98c5:	4c 03 64 24 28       	add    0x28(%rsp),%r12
  8d98ca:	4c 2b 64 24 20       	sub    0x20(%rsp),%r12
  8d98cf:	80 3d 3a 29 00 00 00 	cmpb   $0x0,0x293a(%rip)        # 8dc210 <efi_is64>
  8d98d6:	4d 8d 7c 24 0c       	lea    0xc(%r12),%r15
  8d98db:	4c 8d 44 24 30       	lea    0x30(%rsp),%r8
  8d98e0:	48 8b 05 19 a3 01 00 	mov    0x1a319(%rip),%rax        # 8f3c00 <efi_system_table>
  8d98e7:	74 19                	je     8d9902 <efi_retrieve_tpm2_eventlog+0x216>
  8d98e9:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d98ed:	48 83 ec 20          	sub    $0x20,%rsp
  8d98f1:	4c 89 fa             	mov    %r15,%rdx
  8d98f4:	b9 02 00 00 00       	mov    $0x2,%ecx
  8d98f9:	ff 50 40             	callq  *0x40(%rax)
  8d98fc:	48 83 c4 20          	add    $0x20,%rsp
  8d9900:	eb 20                	jmp    8d9922 <efi_retrieve_tpm2_eventlog+0x236>
  8d9902:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d9905:	4c 89 c1             	mov    %r8,%rcx
  8d9908:	4c 89 fa             	mov    %r15,%rdx
  8d990b:	be 02 00 00 00       	mov    $0x2,%esi
  8d9910:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%rsp)
  8d9917:	00 
  8d9918:	8b 78 2c             	mov    0x2c(%rax),%edi
  8d991b:	31 c0                	xor    %eax,%eax
  8d991d:	e8 5e b4 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9922:	48 85 c0             	test   %rax,%rax
  8d9925:	74 13                	je     8d993a <efi_retrieve_tpm2_eventlog+0x24e>
  8d9927:	48 8d 3d 47 26 00 00 	lea    0x2647(%rip),%rdi        # 8dbf75 <kernel_info_end+0xde5>
  8d992e:	31 c0                	xor    %eax,%eax
  8d9930:	e8 97 c8 ff ff       	callq  8d61cc <efi_printk>
  8d9935:	e9 10 01 00 00       	jmpq   8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d993a:	83 fd 02             	cmp    $0x2,%ebp
  8d993d:	74 04                	je     8d9943 <efi_retrieve_tpm2_eventlog+0x257>
  8d993f:	31 db                	xor    %ebx,%ebx
  8d9941:	eb 54                	jmp    8d9997 <efi_retrieve_tpm2_eventlog+0x2ab>
  8d9943:	48 bf 96 d0 2e 1e e2 	movabs $0x425430e21e2ed096,%rdi
  8d994a:	30 54 42 
  8d994d:	48 be bd 89 86 3b be 	movabs $0x2523f8be3b8689bd,%rsi
  8d9954:	f8 23 25 
  8d9957:	e8 b6 d0 ff ff       	callq  8d6a12 <get_efi_config_table>
  8d995c:	48 89 c2             	mov    %rax,%rdx
  8d995f:	48 85 c0             	test   %rax,%rax
  8d9962:	74 db                	je     8d993f <efi_retrieve_tpm2_eventlog+0x253>
  8d9964:	4c 8b 70 08          	mov    0x8(%rax),%r14
  8d9968:	31 db                	xor    %ebx,%ebx
  8d996a:	4d 85 f6             	test   %r14,%r14
  8d996d:	74 d0                	je     8d993f <efi_retrieve_tpm2_eventlog+0x253>
  8d996f:	45 85 f6             	test   %r14d,%r14d
  8d9972:	7e 23                	jle    8d9997 <efi_retrieve_tpm2_eventlog+0x2ab>
  8d9974:	48 63 c3             	movslq %ebx,%rax
  8d9977:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
  8d997c:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
  8d9981:	41 ff ce             	dec    %r14d
  8d9984:	48 8d 7c 02 10       	lea    0x10(%rdx,%rax,1),%rdi
  8d9989:	e8 58 fc ff ff       	callq  8d95e6 <__calc_tpm2_event_size.constprop.0>
  8d998e:	48 8b 54 24 08       	mov    0x8(%rsp),%rdx
  8d9993:	01 c3                	add    %eax,%ebx
  8d9995:	eb d8                	jmp    8d996f <efi_retrieve_tpm2_eventlog+0x283>
  8d9997:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d999c:	31 f6                	xor    %esi,%esi
  8d999e:	4c 89 fa             	mov    %r15,%rdx
  8d99a1:	e8 ca 96 ff ff       	callq  8d3070 <memset>
  8d99a6:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8d99ab:	4c 89 e2             	mov    %r12,%rdx
  8d99ae:	4c 89 ee             	mov    %r13,%rsi
  8d99b1:	44 89 20             	mov    %r12d,(%rax)
  8d99b4:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
  8d99b9:	89 58 04             	mov    %ebx,0x4(%rax)
  8d99bc:	48 8b 7c 24 30       	mov    0x30(%rsp),%rdi
  8d99c1:	40 88 6f 08          	mov    %bpl,0x8(%rdi)
  8d99c5:	48 83 c7 09          	add    $0x9,%rdi
  8d99c9:	e8 22 97 ff ff       	callq  8d30f0 <memcpy>
  8d99ce:	80 3d 3b 28 00 00 00 	cmpb   $0x0,0x283b(%rip)        # 8dc210 <efi_is64>
  8d99d5:	48 8b 54 24 30       	mov    0x30(%rsp),%rdx
  8d99da:	48 8b 05 1f a2 01 00 	mov    0x1a21f(%rip),%rax        # 8f3c00 <efi_system_table>
  8d99e1:	48 8d 4c 24 50       	lea    0x50(%rsp),%rcx
  8d99e6:	74 34                	je     8d9a1c <efi_retrieve_tpm2_eventlog+0x330>
  8d99e8:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d99ec:	48 83 ec 20          	sub    $0x20,%rsp
  8d99f0:	ff 90 c0 00 00 00    	callq  *0xc0(%rax)
  8d99f6:	48 83 c4 20          	add    $0x20,%rsp
  8d99fa:	48 85 c0             	test   %rax,%rax
  8d99fd:	74 4b                	je     8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d99ff:	48 8b 05 fa a1 01 00 	mov    0x1a1fa(%rip),%rax        # 8f3c00 <efi_system_table>
  8d9a06:	48 83 ec 20          	sub    $0x20,%rsp
  8d9a0a:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9a0f:	48 8b 40 60          	mov    0x60(%rax),%rax
  8d9a13:	ff 50 48             	callq  *0x48(%rax)
  8d9a16:	48 83 c4 20          	add    $0x20,%rsp
  8d9a1a:	eb 2e                	jmp    8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d9a1c:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d9a1f:	48 89 ce             	mov    %rcx,%rsi
  8d9a22:	8b 78 6c             	mov    0x6c(%rax),%edi
  8d9a25:	31 c0                	xor    %eax,%eax
  8d9a27:	e8 54 b3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9a2c:	48 85 c0             	test   %rax,%rax
  8d9a2f:	74 19                	je     8d9a4a <efi_retrieve_tpm2_eventlog+0x35e>
  8d9a31:	48 8b 05 c8 a1 01 00 	mov    0x1a1c8(%rip),%rax        # 8f3c00 <efi_system_table>
  8d9a38:	48 8b 74 24 30       	mov    0x30(%rsp),%rsi
  8d9a3d:	8b 40 3c             	mov    0x3c(%rax),%eax
  8d9a40:	8b 78 30             	mov    0x30(%rax),%edi
  8d9a43:	31 c0                	xor    %eax,%eax
  8d9a45:	e8 36 b3 ff ff       	callq  8d4d80 <__efi64_thunk>
  8d9a4a:	48 83 c4 68          	add    $0x68,%rsp
  8d9a4e:	5b                   	pop    %rbx
  8d9a4f:	5d                   	pop    %rbp
  8d9a50:	41 5c                	pop    %r12
  8d9a52:	41 5d                	pop    %r13
  8d9a54:	41 5e                	pop    %r14
  8d9a56:	41 5f                	pop    %r15
  8d9a58:	c3                   	retq   

00000000008d9a59 <put_dec_full4>:
  8d9a59:	31 c9                	xor    %ecx,%ecx
  8d9a5b:	41 b1 0a             	mov    $0xa,%r9b
  8d9a5e:	89 f0                	mov    %esi,%eax
  8d9a60:	69 f6 cd 0c 00 00    	imul   $0xccd,%esi,%esi
  8d9a66:	8d 50 30             	lea    0x30(%rax),%edx
  8d9a69:	44 89 c8             	mov    %r9d,%eax
  8d9a6c:	c1 ee 0f             	shr    $0xf,%esi
  8d9a6f:	0f af c6             	imul   %esi,%eax
  8d9a72:	41 89 f0             	mov    %esi,%r8d
  8d9a75:	29 c2                	sub    %eax,%edx
  8d9a77:	88 54 0f ff          	mov    %dl,-0x1(%rdi,%rcx,1)
  8d9a7b:	48 ff c9             	dec    %rcx
  8d9a7e:	48 83 f9 fd          	cmp    $0xfffffffffffffffd,%rcx
  8d9a82:	75 da                	jne    8d9a5e <put_dec_full4+0x5>
  8d9a84:	41 83 c0 30          	add    $0x30,%r8d
  8d9a88:	44 88 47 fc          	mov    %r8b,-0x4(%rdi)
  8d9a8c:	c3                   	retq   

00000000008d9a8d <put_dec_helper4>:
  8d9a8d:	41 89 f2             	mov    %esi,%r10d
  8d9a90:	4d 69 d2 d7 c5 6d 34 	imul   $0x346dc5d7,%r10,%r10
  8d9a97:	49 c1 ea 2b          	shr    $0x2b,%r10
  8d9a9b:	41 69 c2 10 27 00 00 	imul   $0x2710,%r10d,%eax
  8d9aa2:	29 c6                	sub    %eax,%esi
  8d9aa4:	e8 b0 ff ff ff       	callq  8d9a59 <put_dec_full4>
  8d9aa9:	44 89 d0             	mov    %r10d,%eax
  8d9aac:	c3                   	retq   

00000000008d9aad <get_int>:
  8d9aad:	48 8b 17             	mov    (%rdi),%rdx
  8d9ab0:	0f be 02             	movsbl (%rdx),%eax
  8d9ab3:	89 c1                	mov    %eax,%ecx
  8d9ab5:	83 e8 30             	sub    $0x30,%eax
  8d9ab8:	83 f8 09             	cmp    $0x9,%eax
  8d9abb:	77 24                	ja     8d9ae1 <get_int+0x34>
  8d9abd:	31 c0                	xor    %eax,%eax
  8d9abf:	48 8b 0f             	mov    (%rdi),%rcx
  8d9ac2:	0f be 11             	movsbl (%rcx),%edx
  8d9ac5:	83 ea 30             	sub    $0x30,%edx
  8d9ac8:	83 fa 09             	cmp    $0x9,%edx
  8d9acb:	77 13                	ja     8d9ae0 <get_int+0x33>
  8d9acd:	6b c0 0a             	imul   $0xa,%eax,%eax
  8d9ad0:	48 8d 51 01          	lea    0x1(%rcx),%rdx
  8d9ad4:	48 89 17             	mov    %rdx,(%rdi)
  8d9ad7:	0f be 11             	movsbl (%rcx),%edx
  8d9ada:	8d 44 10 d0          	lea    -0x30(%rax,%rdx,1),%eax
  8d9ade:	eb df                	jmp    8d9abf <get_int+0x12>
  8d9ae0:	c3                   	retq   
  8d9ae1:	31 c0                	xor    %eax,%eax
  8d9ae3:	80 f9 2a             	cmp    $0x2a,%cl
  8d9ae6:	75 28                	jne    8d9b10 <get_int+0x63>
  8d9ae8:	48 ff c2             	inc    %rdx
  8d9aeb:	48 89 17             	mov    %rdx,(%rdi)
  8d9aee:	8b 16                	mov    (%rsi),%edx
  8d9af0:	83 fa 2f             	cmp    $0x2f,%edx
  8d9af3:	77 0d                	ja     8d9b02 <get_int+0x55>
  8d9af5:	89 d0                	mov    %edx,%eax
  8d9af7:	83 c2 08             	add    $0x8,%edx
  8d9afa:	48 03 46 10          	add    0x10(%rsi),%rax
  8d9afe:	89 16                	mov    %edx,(%rsi)
  8d9b00:	eb 0c                	jmp    8d9b0e <get_int+0x61>
  8d9b02:	48 8b 46 08          	mov    0x8(%rsi),%rax
  8d9b06:	48 8d 50 08          	lea    0x8(%rax),%rdx
  8d9b0a:	48 89 56 08          	mov    %rdx,0x8(%rsi)
  8d9b0e:	8b 00                	mov    (%rax),%eax
  8d9b10:	c3                   	retq   

00000000008d9b11 <vsnprintf>:
  8d9b11:	f3 0f 1e fa          	endbr64 
  8d9b15:	41 57                	push   %r15
  8d9b17:	49 89 f0             	mov    %rsi,%r8
  8d9b1a:	48 89 ce             	mov    %rcx,%rsi
  8d9b1d:	b9 06 00 00 00       	mov    $0x6,%ecx
  8d9b22:	41 56                	push   %r14
  8d9b24:	45 31 f6             	xor    %r14d,%r14d
  8d9b27:	41 55                	push   %r13
  8d9b29:	49 89 fd             	mov    %rdi,%r13
  8d9b2c:	41 54                	push   %r12
  8d9b2e:	55                   	push   %rbp
  8d9b2f:	53                   	push   %rbx
  8d9b30:	48 83 ec 68          	sub    $0x68,%rsp
  8d9b34:	48 8d 44 24 48       	lea    0x48(%rsp),%rax
  8d9b39:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
  8d9b3e:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  8d9b43:	48 89 c7             	mov    %rax,%rdi
  8d9b46:	f3 a5                	rep movsl %ds:(%rsi),%es:(%rdi)
  8d9b48:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d9b4d:	8a 08                	mov    (%rax),%cl
  8d9b4f:	84 c9                	test   %cl,%cl
  8d9b51:	0f 84 2e 08 00 00    	je     8da385 <vsnprintf+0x874>
  8d9b57:	80 f9 25             	cmp    $0x25,%cl
  8d9b5a:	74 13                	je     8d9b6f <vsnprintf+0x5e>
  8d9b5c:	4d 39 c6             	cmp    %r8,%r14
  8d9b5f:	73 21                	jae    8d9b82 <vsnprintf+0x71>
  8d9b61:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d9b66:	8a 00                	mov    (%rax),%al
  8d9b68:	43 88 44 35 00       	mov    %al,0x0(%r13,%r14,1)
  8d9b6d:	eb 13                	jmp    8d9b82 <vsnprintf+0x71>
  8d9b6f:	48 8d 48 01          	lea    0x1(%rax),%rcx
  8d9b73:	31 db                	xor    %ebx,%ebx
  8d9b75:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8d9b7a:	80 78 01 25          	cmpb   $0x25,0x1(%rax)
  8d9b7e:	74 dc                	je     8d9b5c <vsnprintf+0x4b>
  8d9b80:	eb 19                	jmp    8d9b9b <vsnprintf+0x8a>
  8d9b82:	49 ff c6             	inc    %r14
  8d9b85:	e9 f1 07 00 00       	jmpq   8da37b <vsnprintf+0x86a>
  8d9b8a:	7e 1c                	jle    8d9ba8 <vsnprintf+0x97>
  8d9b8c:	3c 2d                	cmp    $0x2d,%al
  8d9b8e:	75 25                	jne    8d9bb5 <vsnprintf+0xa4>
  8d9b90:	83 cb 10             	or     $0x10,%ebx
  8d9b93:	48 ff c1             	inc    %rcx
  8d9b96:	48 89 4c 24 28       	mov    %rcx,0x28(%rsp)
  8d9b9b:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  8d9ba0:	8a 01                	mov    (%rcx),%al
  8d9ba2:	3c 2b                	cmp    $0x2b,%al
  8d9ba4:	75 e4                	jne    8d9b8a <vsnprintf+0x79>
  8d9ba6:	eb 16                	jmp    8d9bbe <vsnprintf+0xad>
  8d9ba8:	3c 20                	cmp    $0x20,%al
  8d9baa:	74 17                	je     8d9bc3 <vsnprintf+0xb2>
  8d9bac:	3c 23                	cmp    $0x23,%al
  8d9bae:	75 18                	jne    8d9bc8 <vsnprintf+0xb7>
  8d9bb0:	83 cb 40             	or     $0x40,%ebx
  8d9bb3:	eb de                	jmp    8d9b93 <vsnprintf+0x82>
  8d9bb5:	3c 30                	cmp    $0x30,%al
  8d9bb7:	75 0f                	jne    8d9bc8 <vsnprintf+0xb7>
  8d9bb9:	83 cb 01             	or     $0x1,%ebx
  8d9bbc:	eb d5                	jmp    8d9b93 <vsnprintf+0x82>
  8d9bbe:	83 cb 04             	or     $0x4,%ebx
  8d9bc1:	eb d0                	jmp    8d9b93 <vsnprintf+0x82>
  8d9bc3:	83 cb 08             	or     $0x8,%ebx
  8d9bc6:	eb cb                	jmp    8d9b93 <vsnprintf+0x82>
  8d9bc8:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d9bcd:	48 8d 7c 24 28       	lea    0x28(%rsp),%rdi
  8d9bd2:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8d9bd7:	e8 d1 fe ff ff       	callq  8d9aad <get_int>
  8d9bdc:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d9be1:	85 c0                	test   %eax,%eax
  8d9be3:	89 c5                	mov    %eax,%ebp
  8d9be5:	79 05                	jns    8d9bec <vsnprintf+0xdb>
  8d9be7:	f7 dd                	neg    %ebp
  8d9be9:	83 cb 10             	or     $0x10,%ebx
  8d9bec:	f6 c3 10             	test   $0x10,%bl
  8d9bef:	74 03                	je     8d9bf4 <vsnprintf+0xe3>
  8d9bf1:	83 e3 fe             	and    $0xfffffffe,%ebx
  8d9bf4:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d9bf9:	49 83 cb ff          	or     $0xffffffffffffffff,%r11
  8d9bfd:	80 38 2e             	cmpb   $0x2e,(%rax)
  8d9c00:	75 27                	jne    8d9c29 <vsnprintf+0x118>
  8d9c02:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  8d9c07:	48 ff c0             	inc    %rax
  8d9c0a:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8d9c0f:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d9c14:	e8 94 fe ff ff       	callq  8d9aad <get_int>
  8d9c19:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d9c1e:	4c 63 d8             	movslq %eax,%r11
  8d9c21:	45 85 db             	test   %r11d,%r11d
  8d9c24:	78 03                	js     8d9c29 <vsnprintf+0x118>
  8d9c26:	83 e3 fe             	and    $0xfffffffe,%ebx
  8d9c29:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d9c2e:	83 c9 ff             	or     $0xffffffff,%ecx
  8d9c31:	40 8a 30             	mov    (%rax),%sil
  8d9c34:	89 f7                	mov    %esi,%edi
  8d9c36:	83 e7 fb             	and    $0xfffffffb,%edi
  8d9c39:	40 80 ff 68          	cmp    $0x68,%dil
  8d9c3d:	75 1f                	jne    8d9c5e <vsnprintf+0x14d>
  8d9c3f:	48 8d 78 01          	lea    0x1(%rax),%rdi
  8d9c43:	40 0f be ce          	movsbl %sil,%ecx
  8d9c47:	48 89 7c 24 28       	mov    %rdi,0x28(%rsp)
  8d9c4c:	40 3a 70 01          	cmp    0x1(%rax),%sil
  8d9c50:	75 0c                	jne    8d9c5e <vsnprintf+0x14d>
  8d9c52:	48 83 c0 02          	add    $0x2,%rax
  8d9c56:	83 e9 20             	sub    $0x20,%ecx
  8d9c59:	48 89 44 24 28       	mov    %rax,0x28(%rsp)
  8d9c5e:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
  8d9c63:	40 8a 30             	mov    (%rax),%sil
  8d9c66:	40 80 fe 58          	cmp    $0x58,%sil
  8d9c6a:	0f 84 f0 01 00 00    	je     8d9e60 <vsnprintf+0x34f>
  8d9c70:	8d 46 9d             	lea    -0x63(%rsi),%eax
  8d9c73:	3c 15                	cmp    $0x15,%al
  8d9c75:	0f 87 0a 07 00 00    	ja     8da385 <vsnprintf+0x874>
  8d9c7b:	48 8d 3d 8e 14 00 00 	lea    0x148e(%rip),%rdi        # 8db110 <shim_guid+0x10>
  8d9c82:	0f b6 c0             	movzbl %al,%eax
  8d9c85:	48 63 04 87          	movslq (%rdi,%rax,4),%rax
  8d9c89:	48 01 f8             	add    %rdi,%rax
  8d9c8c:	3e ff e0             	notrack jmpq *%rax
  8d9c8f:	83 e3 10             	and    $0x10,%ebx
  8d9c92:	83 f9 6c             	cmp    $0x6c,%ecx
  8d9c95:	8b 44 24 48          	mov    0x48(%rsp),%eax
  8d9c99:	4c 8d 64 24 32       	lea    0x32(%rsp),%r12
  8d9c9e:	75 3c                	jne    8d9cdc <vsnprintf+0x1cb>
  8d9ca0:	83 f8 2f             	cmp    $0x2f,%eax
  8d9ca3:	77 10                	ja     8d9cb5 <vsnprintf+0x1a4>
  8d9ca5:	89 c1                	mov    %eax,%ecx
  8d9ca7:	83 c0 08             	add    $0x8,%eax
  8d9caa:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9caf:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9cb3:	eb 0e                	jmp    8d9cc3 <vsnprintf+0x1b2>
  8d9cb5:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9cba:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9cbe:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9cc3:	8b 01                	mov    (%rcx),%eax
  8d9cc5:	41 bb ff ff ff 7f    	mov    $0x7fffffff,%r11d
  8d9ccb:	66 c7 44 24 34 00 00 	movw   $0x0,0x34(%rsp)
  8d9cd2:	66 89 44 24 32       	mov    %ax,0x32(%rsp)
  8d9cd7:	e9 95 00 00 00       	jmpq   8d9d71 <vsnprintf+0x260>
  8d9cdc:	83 f8 2f             	cmp    $0x2f,%eax
  8d9cdf:	77 10                	ja     8d9cf1 <vsnprintf+0x1e0>
  8d9ce1:	89 c1                	mov    %eax,%ecx
  8d9ce3:	83 c0 08             	add    $0x8,%eax
  8d9ce6:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9ceb:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9cef:	eb 0e                	jmp    8d9cff <vsnprintf+0x1ee>
  8d9cf1:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9cf6:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9cfa:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9cff:	8b 01                	mov    (%rcx),%eax
  8d9d01:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8d9d07:	31 c9                	xor    %ecx,%ecx
  8d9d09:	bf 01 00 00 00       	mov    $0x1,%edi
  8d9d0e:	88 44 24 32          	mov    %al,0x32(%rsp)
  8d9d12:	e9 80 04 00 00       	jmpq   8da197 <vsnprintf+0x686>
  8d9d17:	83 e3 10             	and    $0x10,%ebx
  8d9d1a:	45 85 db             	test   %r11d,%r11d
  8d9d1d:	79 06                	jns    8d9d25 <vsnprintf+0x214>
  8d9d1f:	41 bb ff ff ff 7f    	mov    $0x7fffffff,%r11d
  8d9d25:	8b 74 24 48          	mov    0x48(%rsp),%esi
  8d9d29:	83 fe 2f             	cmp    $0x2f,%esi
  8d9d2c:	77 10                	ja     8d9d3e <vsnprintf+0x22d>
  8d9d2e:	89 f0                	mov    %esi,%eax
  8d9d30:	83 c6 08             	add    $0x8,%esi
  8d9d33:	48 03 44 24 58       	add    0x58(%rsp),%rax
  8d9d38:	89 74 24 48          	mov    %esi,0x48(%rsp)
  8d9d3c:	eb 0e                	jmp    8d9d4c <vsnprintf+0x23b>
  8d9d3e:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8d9d43:	48 8d 70 08          	lea    0x8(%rax),%rsi
  8d9d47:	48 89 74 24 50       	mov    %rsi,0x50(%rsp)
  8d9d4c:	4c 8b 20             	mov    (%rax),%r12
  8d9d4f:	4d 85 e4             	test   %r12,%r12
  8d9d52:	75 18                	jne    8d9d6c <vsnprintf+0x25b>
  8d9d54:	41 83 fb 06          	cmp    $0x6,%r11d
  8d9d58:	4c 8d 25 cd 18 00 00 	lea    0x18cd(%rip),%r12        # 8db62c <kernel_info_end+0x49c>
  8d9d5f:	48 8d 05 41 22 00 00 	lea    0x2241(%rip),%rax        # 8dbfa7 <kernel_info_end+0xe17>
  8d9d66:	4c 0f 4d e0          	cmovge %rax,%r12
  8d9d6a:	eb 7b                	jmp    8d9de7 <vsnprintf+0x2d6>
  8d9d6c:	83 f9 6c             	cmp    $0x6c,%ecx
  8d9d6f:	75 76                	jne    8d9de7 <vsnprintf+0x2d6>
  8d9d71:	80 cb 80             	or     $0x80,%bl
  8d9d74:	4d 89 e7             	mov    %r12,%r15
  8d9d77:	31 ff                	xor    %edi,%edi
  8d9d79:	49 39 fb             	cmp    %rdi,%r11
  8d9d7c:	76 5f                	jbe    8d9ddd <vsnprintf+0x2cc>
  8d9d7e:	66 41 8b 0f          	mov    (%r15),%cx
  8d9d82:	66 85 c9             	test   %cx,%cx
  8d9d85:	74 56                	je     8d9ddd <vsnprintf+0x2cc>
  8d9d87:	66 81 f9 80 00       	cmp    $0x80,%cx
  8d9d8c:	49 8d 77 02          	lea    0x2(%r15),%rsi
  8d9d90:	45 19 d2             	sbb    %r10d,%r10d
  8d9d93:	31 c0                	xor    %eax,%eax
  8d9d95:	66 81 f9 ff 07       	cmp    $0x7ff,%cx
  8d9d9a:	0f 97 c0             	seta   %al
  8d9d9d:	45 8d 54 02 02       	lea    0x2(%r10,%rax,1),%r10d
  8d9da2:	4d 63 d2             	movslq %r10d,%r10
  8d9da5:	49 8d 04 3a          	lea    (%r10,%rdi,1),%rax
  8d9da9:	49 39 c3             	cmp    %rax,%r11
  8d9dac:	72 2f                	jb     8d9ddd <vsnprintf+0x2cc>
  8d9dae:	66 81 e1 00 fc       	and    $0xfc00,%cx
  8d9db3:	66 81 f9 00 d8       	cmp    $0xd800,%cx
  8d9db8:	75 1b                	jne    8d9dd5 <vsnprintf+0x2c4>
  8d9dba:	49 39 c3             	cmp    %rax,%r11
  8d9dbd:	74 1e                	je     8d9ddd <vsnprintf+0x2cc>
  8d9dbf:	66 41 8b 47 02       	mov    0x2(%r15),%ax
  8d9dc4:	66 25 00 fc          	and    $0xfc00,%ax
  8d9dc8:	66 3d 00 dc          	cmp    $0xdc00,%ax
  8d9dcc:	75 07                	jne    8d9dd5 <vsnprintf+0x2c4>
  8d9dce:	49 8d 77 04          	lea    0x4(%r15),%rsi
  8d9dd2:	49 ff c2             	inc    %r10
  8d9dd5:	4c 01 d7             	add    %r10,%rdi
  8d9dd8:	49 89 f7             	mov    %rsi,%r15
  8d9ddb:	eb 9c                	jmp    8d9d79 <vsnprintf+0x268>
  8d9ddd:	41 89 fb             	mov    %edi,%r11d
  8d9de0:	31 c9                	xor    %ecx,%ecx
  8d9de2:	e9 b0 03 00 00       	jmpq   8da197 <vsnprintf+0x686>
  8d9de7:	49 63 f3             	movslq %r11d,%rsi
  8d9dea:	4c 89 e7             	mov    %r12,%rdi
  8d9ded:	4c 89 44 24 10       	mov    %r8,0x10(%rsp)
  8d9df2:	e8 c9 8f ff ff       	callq  8d2dc0 <strnlen>
  8d9df7:	31 c9                	xor    %ecx,%ecx
  8d9df9:	4c 8b 44 24 10       	mov    0x10(%rsp),%r8
  8d9dfe:	48 89 c7             	mov    %rax,%rdi
  8d9e01:	41 89 c3             	mov    %eax,%r11d
  8d9e04:	e9 8e 03 00 00       	jmpq   8da197 <vsnprintf+0x686>
  8d9e09:	45 85 db             	test   %r11d,%r11d
  8d9e0c:	79 06                	jns    8d9e14 <vsnprintf+0x303>
  8d9e0e:	41 bb 10 00 00 00    	mov    $0x10,%r11d
  8d9e14:	83 cb 20             	or     $0x20,%ebx
  8d9e17:	41 ba 10 00 00 00    	mov    $0x10,%r10d
  8d9e1d:	eb 0c                	jmp    8d9e2b <vsnprintf+0x31a>
  8d9e1f:	83 cb 02             	or     $0x2,%ebx
  8d9e22:	83 e3 bf             	and    $0xffffffbf,%ebx
  8d9e25:	41 ba 0a 00 00 00    	mov    $0xa,%r10d
  8d9e2b:	40 80 fe 70          	cmp    $0x70,%sil
  8d9e2f:	75 3d                	jne    8d9e6e <vsnprintf+0x35d>
  8d9e31:	8b 4c 24 48          	mov    0x48(%rsp),%ecx
  8d9e35:	83 f9 2f             	cmp    $0x2f,%ecx
  8d9e38:	77 10                	ja     8d9e4a <vsnprintf+0x339>
  8d9e3a:	89 c8                	mov    %ecx,%eax
  8d9e3c:	83 c1 08             	add    $0x8,%ecx
  8d9e3f:	48 03 44 24 58       	add    0x58(%rsp),%rax
  8d9e44:	89 4c 24 48          	mov    %ecx,0x48(%rsp)
  8d9e48:	eb 0e                	jmp    8d9e58 <vsnprintf+0x347>
  8d9e4a:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
  8d9e4f:	48 8d 48 08          	lea    0x8(%rax),%rcx
  8d9e53:	48 89 4c 24 50       	mov    %rcx,0x50(%rsp)
  8d9e58:	48 8b 30             	mov    (%rax),%rsi
  8d9e5b:	e9 6d 01 00 00       	jmpq   8d9fcd <vsnprintf+0x4bc>
  8d9e60:	41 ba 10 00 00 00    	mov    $0x10,%r10d
  8d9e66:	eb 06                	jmp    8d9e6e <vsnprintf+0x35d>
  8d9e68:	41 ba 08 00 00 00    	mov    $0x8,%r10d
  8d9e6e:	8b 44 24 48          	mov    0x48(%rsp),%eax
  8d9e72:	f6 c3 02             	test   $0x2,%bl
  8d9e75:	0f 84 9f 00 00 00    	je     8d9f1a <vsnprintf+0x409>
  8d9e7b:	83 f9 68             	cmp    $0x68,%ecx
  8d9e7e:	74 17                	je     8d9e97 <vsnprintf+0x386>
  8d9e80:	7f 0a                	jg     8d9e8c <vsnprintf+0x37b>
  8d9e82:	83 f9 48             	cmp    $0x48,%ecx
  8d9e85:	74 3c                	je     8d9ec3 <vsnprintf+0x3b2>
  8d9e87:	83 f9 4c             	cmp    $0x4c,%ecx
  8d9e8a:	eb 03                	jmp    8d9e8f <vsnprintf+0x37e>
  8d9e8c:	83 f9 6c             	cmp    $0x6c,%ecx
  8d9e8f:	0f 84 9b 00 00 00    	je     8d9f30 <vsnprintf+0x41f>
  8d9e95:	eb 58                	jmp    8d9eef <vsnprintf+0x3de>
  8d9e97:	83 f8 2f             	cmp    $0x2f,%eax
  8d9e9a:	77 10                	ja     8d9eac <vsnprintf+0x39b>
  8d9e9c:	89 c1                	mov    %eax,%ecx
  8d9e9e:	83 c0 08             	add    $0x8,%eax
  8d9ea1:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9ea6:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9eaa:	eb 0e                	jmp    8d9eba <vsnprintf+0x3a9>
  8d9eac:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9eb1:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9eb5:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9eba:	48 0f bf 31          	movswq (%rcx),%rsi
  8d9ebe:	e9 0a 01 00 00       	jmpq   8d9fcd <vsnprintf+0x4bc>
  8d9ec3:	83 f8 2f             	cmp    $0x2f,%eax
  8d9ec6:	77 10                	ja     8d9ed8 <vsnprintf+0x3c7>
  8d9ec8:	89 c1                	mov    %eax,%ecx
  8d9eca:	83 c0 08             	add    $0x8,%eax
  8d9ecd:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9ed2:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9ed6:	eb 0e                	jmp    8d9ee6 <vsnprintf+0x3d5>
  8d9ed8:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9edd:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9ee1:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9ee6:	48 0f be 31          	movsbq (%rcx),%rsi
  8d9eea:	e9 de 00 00 00       	jmpq   8d9fcd <vsnprintf+0x4bc>
  8d9eef:	83 f8 2f             	cmp    $0x2f,%eax
  8d9ef2:	77 10                	ja     8d9f04 <vsnprintf+0x3f3>
  8d9ef4:	89 c1                	mov    %eax,%ecx
  8d9ef6:	83 c0 08             	add    $0x8,%eax
  8d9ef9:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9efe:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9f02:	eb 0e                	jmp    8d9f12 <vsnprintf+0x401>
  8d9f04:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9f09:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9f0d:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9f12:	48 63 31             	movslq (%rcx),%rsi
  8d9f15:	e9 b3 00 00 00       	jmpq   8d9fcd <vsnprintf+0x4bc>
  8d9f1a:	83 f9 68             	cmp    $0x68,%ecx
  8d9f1d:	74 39                	je     8d9f58 <vsnprintf+0x447>
  8d9f1f:	7f 0a                	jg     8d9f2b <vsnprintf+0x41a>
  8d9f21:	83 f9 48             	cmp    $0x48,%ecx
  8d9f24:	74 5a                	je     8d9f80 <vsnprintf+0x46f>
  8d9f26:	83 f9 4c             	cmp    $0x4c,%ecx
  8d9f29:	eb 03                	jmp    8d9f2e <vsnprintf+0x41d>
  8d9f2b:	83 f9 6c             	cmp    $0x6c,%ecx
  8d9f2e:	75 78                	jne    8d9fa8 <vsnprintf+0x497>
  8d9f30:	83 f8 2f             	cmp    $0x2f,%eax
  8d9f33:	77 10                	ja     8d9f45 <vsnprintf+0x434>
  8d9f35:	89 c1                	mov    %eax,%ecx
  8d9f37:	83 c0 08             	add    $0x8,%eax
  8d9f3a:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9f3f:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9f43:	eb 0e                	jmp    8d9f53 <vsnprintf+0x442>
  8d9f45:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9f4a:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9f4e:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9f53:	48 8b 31             	mov    (%rcx),%rsi
  8d9f56:	eb 75                	jmp    8d9fcd <vsnprintf+0x4bc>
  8d9f58:	83 f8 2f             	cmp    $0x2f,%eax
  8d9f5b:	77 10                	ja     8d9f6d <vsnprintf+0x45c>
  8d9f5d:	89 c1                	mov    %eax,%ecx
  8d9f5f:	83 c0 08             	add    $0x8,%eax
  8d9f62:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9f67:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9f6b:	eb 0e                	jmp    8d9f7b <vsnprintf+0x46a>
  8d9f6d:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9f72:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9f76:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9f7b:	0f b7 31             	movzwl (%rcx),%esi
  8d9f7e:	eb 4d                	jmp    8d9fcd <vsnprintf+0x4bc>
  8d9f80:	83 f8 2f             	cmp    $0x2f,%eax
  8d9f83:	77 10                	ja     8d9f95 <vsnprintf+0x484>
  8d9f85:	89 c1                	mov    %eax,%ecx
  8d9f87:	83 c0 08             	add    $0x8,%eax
  8d9f8a:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9f8f:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9f93:	eb 0e                	jmp    8d9fa3 <vsnprintf+0x492>
  8d9f95:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9f9a:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9f9e:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9fa3:	0f b6 31             	movzbl (%rcx),%esi
  8d9fa6:	eb 25                	jmp    8d9fcd <vsnprintf+0x4bc>
  8d9fa8:	83 f8 2f             	cmp    $0x2f,%eax
  8d9fab:	77 10                	ja     8d9fbd <vsnprintf+0x4ac>
  8d9fad:	89 c1                	mov    %eax,%ecx
  8d9faf:	83 c0 08             	add    $0x8,%eax
  8d9fb2:	48 03 4c 24 58       	add    0x58(%rsp),%rcx
  8d9fb7:	89 44 24 48          	mov    %eax,0x48(%rsp)
  8d9fbb:	eb 0e                	jmp    8d9fcb <vsnprintf+0x4ba>
  8d9fbd:	48 8b 4c 24 50       	mov    0x50(%rsp),%rcx
  8d9fc2:	48 8d 41 08          	lea    0x8(%rcx),%rax
  8d9fc6:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
  8d9fcb:	8b 31                	mov    (%rcx),%esi
  8d9fcd:	31 c9                	xor    %ecx,%ecx
  8d9fcf:	f6 c3 02             	test   $0x2,%bl
  8d9fd2:	74 20                	je     8d9ff4 <vsnprintf+0x4e3>
  8d9fd4:	48 85 f6             	test   %rsi,%rsi
  8d9fd7:	79 07                	jns    8d9fe0 <vsnprintf+0x4cf>
  8d9fd9:	48 f7 de             	neg    %rsi
  8d9fdc:	b1 2d                	mov    $0x2d,%cl
  8d9fde:	eb 12                	jmp    8d9ff2 <vsnprintf+0x4e1>
  8d9fe0:	f6 c3 04             	test   $0x4,%bl
  8d9fe3:	75 0b                	jne    8d9ff0 <vsnprintf+0x4df>
  8d9fe5:	31 c9                	xor    %ecx,%ecx
  8d9fe7:	f6 c3 08             	test   $0x8,%bl
  8d9fea:	74 08                	je     8d9ff4 <vsnprintf+0x4e3>
  8d9fec:	b1 20                	mov    $0x20,%cl
  8d9fee:	eb 02                	jmp    8d9ff2 <vsnprintf+0x4e1>
  8d9ff0:	b1 2b                	mov    $0x2b,%cl
  8d9ff2:	ff cd                	dec    %ebp
  8d9ff4:	48 89 f0             	mov    %rsi,%rax
  8d9ff7:	41 83 fa 0a          	cmp    $0xa,%r10d
  8d9ffb:	74 29                	je     8da026 <vsnprintf+0x515>
  8d9ffd:	41 83 fa 10          	cmp    $0x10,%r10d
  8da001:	74 14                	je     8da017 <vsnprintf+0x506>
  8da003:	41 83 fa 08          	cmp    $0x8,%r10d
  8da007:	0f 85 35 01 00 00    	jne    8da142 <vsnprintf+0x631>
  8da00d:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
  8da012:	e9 ec 00 00 00       	jmpq   8da103 <vsnprintf+0x5f2>
  8da017:	89 de                	mov    %ebx,%esi
  8da019:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
  8da01e:	83 e6 20             	and    $0x20,%esi
  8da021:	e9 f7 00 00 00       	jmpq   8da11d <vsnprintf+0x60c>
  8da026:	4c 8b 64 24 08       	mov    0x8(%rsp),%r12
  8da02b:	48 85 f6             	test   %rsi,%rsi
  8da02e:	0f 84 0e 01 00 00    	je     8da142 <vsnprintf+0x631>
  8da034:	c1 e8 10             	shr    $0x10,%eax
  8da037:	49 89 f4             	mov    %rsi,%r12
  8da03a:	0f b7 f6             	movzwl %si,%esi
  8da03d:	48 8b 7c 24 08       	mov    0x8(%rsp),%rdi
  8da042:	89 44 24 10          	mov    %eax,0x10(%rsp)
  8da046:	69 c0 a0 15 00 00    	imul   $0x15a0,%eax,%eax
  8da04c:	49 c1 ec 20          	shr    $0x20,%r12
  8da050:	45 0f b7 fc          	movzwl %r12w,%r15d
  8da054:	41 c1 ec 10          	shr    $0x10,%r12d
  8da058:	4c 89 44 24 20       	mov    %r8,0x20(%rsp)
  8da05d:	44 89 54 24 1c       	mov    %r10d,0x1c(%rsp)
  8da062:	01 c6                	add    %eax,%esi
  8da064:	41 69 c4 90 02 00 00 	imul   $0x290,%r12d,%eax
  8da06b:	88 4c 24 1b          	mov    %cl,0x1b(%rsp)
  8da06f:	01 c6                	add    %eax,%esi
  8da071:	41 69 c7 80 1c 00 00 	imul   $0x1c80,%r15d,%eax
  8da078:	01 c6                	add    %eax,%esi
  8da07a:	e8 0e fa ff ff       	callq  8d9a8d <put_dec_helper4>
  8da07f:	41 69 ff 18 25 00 00 	imul   $0x2518,%r15d,%edi
  8da086:	41 69 f4 f7 1d 00 00 	imul   $0x1df7,%r12d,%esi
  8da08d:	45 6b ff 2a          	imul   $0x2a,%r15d,%r15d
  8da091:	01 fe                	add    %edi,%esi
  8da093:	6b 7c 24 10 06       	imul   $0x6,0x10(%rsp),%edi
  8da098:	01 fe                	add    %edi,%esi
  8da09a:	48 8d 7c 24 44       	lea    0x44(%rsp),%rdi
  8da09f:	01 c6                	add    %eax,%esi
  8da0a1:	e8 e7 f9 ff ff       	callq  8d9a8d <put_dec_helper4>
  8da0a6:	41 69 f4 8d 12 00 00 	imul   $0x128d,%r12d,%esi
  8da0ad:	45 69 e4 19 01 00 00 	imul   $0x119,%r12d,%r12d
  8da0b4:	48 8d 7c 24 40       	lea    0x40(%rsp),%rdi
  8da0b9:	44 01 fe             	add    %r15d,%esi
  8da0bc:	01 c6                	add    %eax,%esi
  8da0be:	e8 ca f9 ff ff       	callq  8d9a8d <put_dec_helper4>
  8da0c3:	41 8d 34 04          	lea    (%r12,%rax,1),%esi
  8da0c7:	48 8d 7c 24 3c       	lea    0x3c(%rsp),%rdi
  8da0cc:	e8 bc f9 ff ff       	callq  8d9a8d <put_dec_helper4>
  8da0d1:	89 c6                	mov    %eax,%esi
  8da0d3:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
  8da0d8:	e8 7c f9 ff ff       	callq  8d9a59 <put_dec_full4>
  8da0dd:	8a 4c 24 1b          	mov    0x1b(%rsp),%cl
  8da0e1:	44 8b 54 24 1c       	mov    0x1c(%rsp),%r10d
  8da0e6:	4c 8b 44 24 20       	mov    0x20(%rsp),%r8
  8da0eb:	4c 8d 64 24 34       	lea    0x34(%rsp),%r12
  8da0f0:	41 80 3c 24 30       	cmpb   $0x30,(%r12)
  8da0f5:	75 4b                	jne    8da142 <vsnprintf+0x631>
  8da0f7:	49 ff c4             	inc    %r12
  8da0fa:	4c 3b 64 24 08       	cmp    0x8(%rsp),%r12
  8da0ff:	75 ef                	jne    8da0f0 <vsnprintf+0x5df>
  8da101:	eb 3f                	jmp    8da142 <vsnprintf+0x631>
  8da103:	48 85 c0             	test   %rax,%rax
  8da106:	74 3a                	je     8da142 <vsnprintf+0x631>
  8da108:	89 c6                	mov    %eax,%esi
  8da10a:	49 ff cc             	dec    %r12
  8da10d:	48 c1 e8 03          	shr    $0x3,%rax
  8da111:	83 e6 07             	and    $0x7,%esi
  8da114:	83 c6 30             	add    $0x30,%esi
  8da117:	41 88 34 24          	mov    %sil,(%r12)
  8da11b:	eb e6                	jmp    8da103 <vsnprintf+0x5f2>
  8da11d:	48 85 c0             	test   %rax,%rax
  8da120:	74 20                	je     8da142 <vsnprintf+0x631>
  8da122:	48 89 c7             	mov    %rax,%rdi
  8da125:	4c 8d 0d 44 10 00 00 	lea    0x1044(%rip),%r9        # 8db170 <digits.3077>
  8da12c:	49 ff cc             	dec    %r12
  8da12f:	48 c1 e8 04          	shr    $0x4,%rax
  8da133:	83 e7 0f             	and    $0xf,%edi
  8da136:	41 8a 14 39          	mov    (%r9,%rdi,1),%dl
  8da13a:	09 f2                	or     %esi,%edx
  8da13c:	41 88 14 24          	mov    %dl,(%r12)
  8da140:	eb db                	jmp    8da11d <vsnprintf+0x60c>
  8da142:	48 8b 44 24 08       	mov    0x8(%rsp),%rax
  8da147:	4c 29 e0             	sub    %r12,%rax
  8da14a:	48 89 c7             	mov    %rax,%rdi
  8da14d:	45 85 db             	test   %r11d,%r11d
  8da150:	79 06                	jns    8da158 <vsnprintf+0x647>
  8da152:	41 bb 01 00 00 00    	mov    $0x1,%r11d
  8da158:	49 63 f3             	movslq %r11d,%rsi
  8da15b:	48 39 c6             	cmp    %rax,%rsi
  8da15e:	44 0f 42 d8          	cmovb  %eax,%r11d
  8da162:	f6 c3 40             	test   $0x40,%bl
  8da165:	74 24                	je     8da18b <vsnprintf+0x67a>
  8da167:	41 83 fa 08          	cmp    $0x8,%r10d
  8da16b:	75 0b                	jne    8da178 <vsnprintf+0x667>
  8da16d:	49 63 f3             	movslq %r11d,%rsi
  8da170:	48 39 c6             	cmp    %rax,%rsi
  8da173:	75 03                	jne    8da178 <vsnprintf+0x667>
  8da175:	41 ff c3             	inc    %r11d
  8da178:	41 83 fa 10          	cmp    $0x10,%r10d
  8da17c:	75 0a                	jne    8da188 <vsnprintf+0x677>
  8da17e:	45 85 db             	test   %r11d,%r11d
  8da181:	7e 05                	jle    8da188 <vsnprintf+0x677>
  8da183:	83 ed 02             	sub    $0x2,%ebp
  8da186:	eb 03                	jmp    8da18b <vsnprintf+0x67a>
  8da188:	83 e3 bf             	and    $0xffffffbf,%ebx
  8da18b:	f6 c3 01             	test   $0x1,%bl
  8da18e:	74 07                	je     8da197 <vsnprintf+0x686>
  8da190:	41 39 eb             	cmp    %ebp,%r11d
  8da193:	44 0f 4c dd          	cmovl  %ebp,%r11d
  8da197:	44 29 dd             	sub    %r11d,%ebp
  8da19a:	f6 c3 10             	test   $0x10,%bl
  8da19d:	75 35                	jne    8da1d4 <vsnprintf+0x6c3>
  8da19f:	4c 89 f0             	mov    %r14,%rax
  8da1a2:	46 8d 54 35 00       	lea    0x0(%rbp,%r14,1),%r10d
  8da1a7:	44 89 d6             	mov    %r10d,%esi
  8da1aa:	29 c6                	sub    %eax,%esi
  8da1ac:	85 f6                	test   %esi,%esi
  8da1ae:	7e 10                	jle    8da1c0 <vsnprintf+0x6af>
  8da1b0:	4c 39 c0             	cmp    %r8,%rax
  8da1b3:	73 06                	jae    8da1bb <vsnprintf+0x6aa>
  8da1b5:	41 c6 44 05 00 20    	movb   $0x20,0x0(%r13,%rax,1)
  8da1bb:	48 ff c0             	inc    %rax
  8da1be:	eb e7                	jmp    8da1a7 <vsnprintf+0x696>
  8da1c0:	85 ed                	test   %ebp,%ebp
  8da1c2:	be 00 00 00 00       	mov    $0x0,%esi
  8da1c7:	0f 49 f5             	cmovns %ebp,%esi
  8da1ca:	ff cd                	dec    %ebp
  8da1cc:	48 63 c6             	movslq %esi,%rax
  8da1cf:	29 f5                	sub    %esi,%ebp
  8da1d1:	49 01 c6             	add    %rax,%r14
  8da1d4:	84 c9                	test   %cl,%cl
  8da1d6:	74 0d                	je     8da1e5 <vsnprintf+0x6d4>
  8da1d8:	4d 39 c6             	cmp    %r8,%r14
  8da1db:	73 05                	jae    8da1e2 <vsnprintf+0x6d1>
  8da1dd:	43 88 4c 35 00       	mov    %cl,0x0(%r13,%r14,1)
  8da1e2:	49 ff c6             	inc    %r14
  8da1e5:	f6 c3 40             	test   $0x40,%bl
  8da1e8:	74 25                	je     8da20f <vsnprintf+0x6fe>
  8da1ea:	4d 39 c6             	cmp    %r8,%r14
  8da1ed:	73 06                	jae    8da1f5 <vsnprintf+0x6e4>
  8da1ef:	43 c6 44 35 00 30    	movb   $0x30,0x0(%r13,%r14,1)
  8da1f5:	49 8d 46 01          	lea    0x1(%r14),%rax
  8da1f9:	49 39 c0             	cmp    %rax,%r8
  8da1fc:	76 0d                	jbe    8da20b <vsnprintf+0x6fa>
  8da1fe:	89 d8                	mov    %ebx,%eax
  8da200:	83 e0 20             	and    $0x20,%eax
  8da203:	83 c8 58             	or     $0x58,%eax
  8da206:	43 88 44 35 01       	mov    %al,0x1(%r13,%r14,1)
  8da20b:	49 83 c6 02          	add    $0x2,%r14
  8da20f:	4d 63 db             	movslq %r11d,%r11
  8da212:	4c 89 f0             	mov    %r14,%rax
  8da215:	4c 89 d9             	mov    %r11,%rcx
  8da218:	48 39 cf             	cmp    %rcx,%rdi
  8da21b:	73 13                	jae    8da230 <vsnprintf+0x71f>
  8da21d:	4c 39 c0             	cmp    %r8,%rax
  8da220:	73 06                	jae    8da228 <vsnprintf+0x717>
  8da222:	41 c6 44 05 00 30    	movb   $0x30,0x0(%r13,%rax,1)
  8da228:	48 ff c0             	inc    %rax
  8da22b:	48 ff c9             	dec    %rcx
  8da22e:	eb e8                	jmp    8da218 <vsnprintf+0x707>
  8da230:	4c 89 d8             	mov    %r11,%rax
  8da233:	b9 00 00 00 00       	mov    $0x0,%ecx
  8da238:	48 29 f8             	sub    %rdi,%rax
  8da23b:	4c 39 df             	cmp    %r11,%rdi
  8da23e:	41 bb 80 07 00 00    	mov    $0x780,%r11d
  8da244:	48 0f 47 c1          	cmova  %rcx,%rax
  8da248:	80 e3 80             	and    $0x80,%bl
  8da24b:	4a 8d 14 30          	lea    (%rax,%r14,1),%rdx
  8da24f:	75 40                	jne    8da291 <vsnprintf+0x780>
  8da251:	48 01 d7             	add    %rdx,%rdi
  8da254:	e9 ec 00 00 00       	jmpq   8da345 <vsnprintf+0x834>
  8da259:	41 0f b7 04 24       	movzwl (%r12),%eax
  8da25e:	49 8d 7c 24 02       	lea    0x2(%r12),%rdi
  8da263:	48 8d 5a 01          	lea    0x1(%rdx),%rbx
  8da267:	89 c1                	mov    %eax,%ecx
  8da269:	66 81 e1 00 f8       	and    $0xf800,%cx
  8da26e:	66 81 f9 00 d8       	cmp    $0xd800,%cx
  8da273:	74 2a                	je     8da29f <vsnprintf+0x78e>
  8da275:	0f b7 f0             	movzwl %ax,%esi
  8da278:	66 83 f8 7f          	cmp    $0x7f,%ax
  8da27c:	77 4b                	ja     8da2c9 <vsnprintf+0x7b8>
  8da27e:	4c 39 c2             	cmp    %r8,%rdx
  8da281:	73 05                	jae    8da288 <vsnprintf+0x777>
  8da283:	41 88 44 15 00       	mov    %al,0x0(%r13,%rdx,1)
  8da288:	48 89 da             	mov    %rbx,%rdx
  8da28b:	49 89 fc             	mov    %rdi,%r12
  8da28e:	4c 89 d7             	mov    %r10,%rdi
  8da291:	4c 8d 57 ff          	lea    -0x1(%rdi),%r10
  8da295:	48 85 ff             	test   %rdi,%rdi
  8da298:	75 bf                	jne    8da259 <vsnprintf+0x748>
  8da29a:	e9 ab 00 00 00       	jmpq   8da34a <vsnprintf+0x839>
  8da29f:	f6 c4 04             	test   $0x4,%ah
  8da2a2:	75 32                	jne    8da2d6 <vsnprintf+0x7c5>
  8da2a4:	41 0f b7 4c 24 02    	movzwl 0x2(%r12),%ecx
  8da2aa:	89 ce                	mov    %ecx,%esi
  8da2ac:	66 81 e6 00 fc       	and    $0xfc00,%si
  8da2b1:	66 81 fe 00 dc       	cmp    $0xdc00,%si
  8da2b6:	75 1e                	jne    8da2d6 <vsnprintf+0x7c5>
  8da2b8:	c1 e0 0a             	shl    $0xa,%eax
  8da2bb:	49 8d 7c 24 04       	lea    0x4(%r12),%rdi
  8da2c0:	8d b4 08 00 24 a0 fc 	lea    -0x35fdc00(%rax,%rcx,1),%esi
  8da2c7:	eb 12                	jmp    8da2db <vsnprintf+0x7ca>
  8da2c9:	81 fe 00 08 00 00    	cmp    $0x800,%esi
  8da2cf:	19 c9                	sbb    %ecx,%ecx
  8da2d1:	83 c1 02             	add    $0x2,%ecx
  8da2d4:	eb 0a                	jmp    8da2e0 <vsnprintf+0x7cf>
  8da2d6:	be fd ff 00 00       	mov    $0xfffd,%esi
  8da2db:	b9 02 00 00 00       	mov    $0x2,%ecx
  8da2e0:	31 c0                	xor    %eax,%eax
  8da2e2:	81 fe ff ff 00 00    	cmp    $0xffff,%esi
  8da2e8:	4d 8d 64 15 00       	lea    0x0(%r13,%rdx,1),%r12
  8da2ed:	0f 97 c0             	seta   %al
  8da2f0:	01 c1                	add    %eax,%ecx
  8da2f2:	48 63 c1             	movslq %ecx,%rax
  8da2f5:	49 29 c2             	sub    %rax,%r10
  8da2f8:	4c 39 c2             	cmp    %r8,%rdx
  8da2fb:	73 05                	jae    8da302 <vsnprintf+0x7f1>
  8da2fd:	41 c6 04 24 00       	movb   $0x0,(%r12)
  8da302:	48 8d 14 18          	lea    (%rax,%rbx,1),%rdx
  8da306:	49 39 d0             	cmp    %rdx,%r8
  8da309:	76 80                	jbe    8da28b <vsnprintf+0x77a>
  8da30b:	44 89 db             	mov    %r11d,%ebx
  8da30e:	d3 fb                	sar    %cl,%ebx
  8da310:	41 88 1c 24          	mov    %bl,(%r12)
  8da314:	89 f1                	mov    %esi,%ecx
  8da316:	c1 ee 06             	shr    $0x6,%esi
  8da319:	83 e1 3f             	and    $0x3f,%ecx
  8da31c:	83 c9 80             	or     $0xffffff80,%ecx
  8da31f:	41 88 0c 04          	mov    %cl,(%r12,%rax,1)
  8da323:	48 ff c8             	dec    %rax
  8da326:	75 ec                	jne    8da314 <vsnprintf+0x803>
  8da328:	41 08 34 24          	or     %sil,(%r12)
  8da32c:	e9 5a ff ff ff       	jmpq   8da28b <vsnprintf+0x77a>
  8da331:	4c 39 c2             	cmp    %r8,%rdx
  8da334:	73 0c                	jae    8da342 <vsnprintf+0x831>
  8da336:	41 8a 04 24          	mov    (%r12),%al
  8da33a:	49 ff c4             	inc    %r12
  8da33d:	41 88 44 15 00       	mov    %al,0x0(%r13,%rdx,1)
  8da342:	48 ff c2             	inc    %rdx
  8da345:	48 39 fa             	cmp    %rdi,%rdx
  8da348:	75 e7                	jne    8da331 <vsnprintf+0x820>
  8da34a:	48 89 d0             	mov    %rdx,%rax
  8da34d:	8d 74 15 00          	lea    0x0(%rbp,%rdx,1),%esi
  8da351:	eb 0e                	jmp    8da361 <vsnprintf+0x850>
  8da353:	4c 39 c0             	cmp    %r8,%rax
  8da356:	73 06                	jae    8da35e <vsnprintf+0x84d>
  8da358:	41 c6 44 05 00 20    	movb   $0x20,0x0(%r13,%rax,1)
  8da35e:	48 ff c0             	inc    %rax
  8da361:	89 f1                	mov    %esi,%ecx
  8da363:	29 c1                	sub    %eax,%ecx
  8da365:	85 c9                	test   %ecx,%ecx
  8da367:	7f ea                	jg     8da353 <vsnprintf+0x842>
  8da369:	85 ed                	test   %ebp,%ebp
  8da36b:	b8 00 00 00 00       	mov    $0x0,%eax
  8da370:	0f 48 e8             	cmovs  %eax,%ebp
  8da373:	48 63 ed             	movslq %ebp,%rbp
  8da376:	4c 8d 74 15 00       	lea    0x0(%rbp,%rdx,1),%r14
  8da37b:	48 ff 44 24 28       	incq   0x28(%rsp)
  8da380:	e9 c3 f7 ff ff       	jmpq   8d9b48 <vsnprintf+0x37>
  8da385:	4d 85 c0             	test   %r8,%r8
  8da388:	74 10                	je     8da39a <vsnprintf+0x889>
  8da38a:	49 ff c8             	dec    %r8
  8da38d:	4d 39 f0             	cmp    %r14,%r8
  8da390:	4d 0f 47 c6          	cmova  %r14,%r8
  8da394:	43 c6 44 05 00 00    	movb   $0x0,0x0(%r13,%r8,1)
  8da39a:	48 83 c4 68          	add    $0x68,%rsp
  8da39e:	44 89 f0             	mov    %r14d,%eax
  8da3a1:	5b                   	pop    %rbx
  8da3a2:	5d                   	pop    %rbp
  8da3a3:	41 5c                	pop    %r12
  8da3a5:	41 5d                	pop    %r13
  8da3a7:	41 5e                	pop    %r14
  8da3a9:	41 5f                	pop    %r15
  8da3ab:	c3                   	retq   

00000000008da3ac <snprintf>:
  8da3ac:	f3 0f 1e fa          	endbr64 
  8da3b0:	48 83 ec 58          	sub    $0x58,%rsp
  8da3b4:	48 8d 44 24 60       	lea    0x60(%rsp),%rax
  8da3b9:	48 89 4c 24 38       	mov    %rcx,0x38(%rsp)
  8da3be:	48 8d 4c 24 08       	lea    0x8(%rsp),%rcx
  8da3c3:	48 89 44 24 10       	mov    %rax,0x10(%rsp)
  8da3c8:	48 8d 44 24 20       	lea    0x20(%rsp),%rax
  8da3cd:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
  8da3d2:	4c 89 4c 24 48       	mov    %r9,0x48(%rsp)
  8da3d7:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%rsp)
  8da3de:	00 
  8da3df:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
  8da3e4:	e8 28 f7 ff ff       	callq  8d9b11 <vsnprintf>
  8da3e9:	48 83 c4 58          	add    $0x58,%rsp
  8da3ed:	c3                   	retq   

00000000008da3ee <fortify_panic>:
  8da3ee:	f3 0f 1e fa          	endbr64 
  8da3f2:	50                   	push   %rax
  8da3f3:	58                   	pop    %rax
  8da3f4:	48 8d 3d e5 0f 00 00 	lea    0xfe5(%rip),%rdi        # 8db3e0 <kernel_info_end+0x250>
  8da3fb:	50                   	push   %rax
  8da3fc:	e8 8f 91 ff ff       	callq  8d3590 <error>
