	.file	"8.c"
	.text
	.globl	mabs
	.type	mabs, @function
mabs:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, %xmm2		#xmm2 = x
	pxor	%xmm0, %xmm0
	ucomisd	%xmm2, %xmm0
	jbe	.L7
	movsd	%xmm2, %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	jmp	.L5
.L7:
	movsd	%xmm2, %xmm0		#return x
.L5:
	movq	%rbp, %rsp
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	mabs, .-mabs
	.globl	root_res
	.type	root_res, @function
root_res:
.LFB6:
	.cfi_startproc
	pushq	%rbp		#using this registers to numbers (1, 5...)
	pushq	%rbx		#rootDegree = 5
	pushq	%r12
	pushq	%r13		#r13 = 5 (rootDegree)
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movsd	%xmm0, %xmm3	#xmm3 = double num
	pxor	%xmm0, %xmm0
	ucomisd	%xmm3, %xmm0
	jp	.L9
	pxor	%xmm0, %xmm0
	ucomisd	%xmm3, %xmm0
	jne	.L9
	pxor	%xmm0, %xmm0
	jmp	.L11
.L9:
	movsd	.LC2(%rip), %xmm0
	ucomisd	%xmm3, %xmm0
	jp	.L12
	movsd	.LC2(%rip), %xmm0
	ucomisd	%xmm3, %xmm0
	jne	.L12
	movsd	.LC2(%rip), %xmm0
	jmp	.L11
.L12:
	movsd	.LC3(%rip), %xmm0
	ucomisd	%xmm3, %xmm0
	jp	.L14
	movsd	.LC3(%rip), %xmm0
	ucomisd	%xmm3, %xmm0
	jne	.L14
	movsd	.LC3(%rip), %xmm0
	jmp	.L11
.L14:
	pxor	%xmm0, %xmm0
	ucomisd	%xmm3, %xmm0
	jbe	.L30
	movsd	%xmm3, %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movsd	%xmm0, %xmm3
	movq	$5, %rbx
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, %xmm5
	cvtsi2sd	%rbx, %xmm0
	movsd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, %xmm6		#xmm6 = eps
	movsd	%xmm3, %xmm0
	movsd	%xmm0, %xmm7
	jmp	.L18
.L21:
	movsd	%xmm3, %xmm0
	movsd	%xmm0, %xmm7
	movq	$1, %r12
	jmp	.L19
.L20:
	movsd	%xmm7, %xmm0
	divsd	%xmm6, %xmm0
	movsd	%xmm0, %xmm7		#xmm7 = root 
	addq	$1, %r12
.L19:
	cmpq	$4, %r12
	jle	.L20
	movsd	%xmm7, %xmm0
	movapd	%xmm0, %xmm1
	divsd	%xmm3, %xmm1
	movsd	.LC2(%rip), %xmm0
	divsd	%xmm3, %xmm0
	movsd	.LC2(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm6, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, %xmm6
.L18:
	movsd	%xmm6, %xmm0
	subsd	%xmm7, %xmm0		#(root - rn)
	call	mabs
	ucomisd	%xmm5, %xmm0		#result of mabs
	jnb	.L21
	movsd	%xmm6, %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	jmp	.L11
.L30:
	movq	$5, %r13		#r13 = 5 (rootDegree)
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, %xmm10
	cvtsi2sd	%r13, %xmm0
	movsd	%xmm3, %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, %xmm11
	movsd	%xmm3, %xmm0
	movsd	%xmm0, %xmm12
	jmp	.L22
.L25:
	movsd	%xmm3, %xmm0
	movsd	%xmm0, %xmm12
	movq	$1, %r14
	jmp	.L23
.L24:
	movsd	%xmm12, %xmm0
	divsd	%xmm11, %xmm0
	movsd	%xmm0, %xmm12
	addq	$1, %r14
.L23:
	cmpq	$4, %r14
	jle	.L24
	movsd	%xmm12, %xmm0
	movapd	%xmm0, %xmm1
	divsd	%xmm3, %xmm1
	movsd	.LC2(%rip), %xmm0
	divsd	%xmm3, %xmm0
	movsd	.LC2(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	%xmm11, %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, %xmm11
.L22:
	movsd	%xmm11, %xmm0
	subsd	%xmm12, %xmm0
	call	mabs
	ucomisd	%xmm10, %xmm0
	jnb	.L25
	movsd	%xmm11, %xmm0		#save to return
.L11:
	movq	%rbp, %rsp
	popq	%r14
	popq	%r13
	popq	%r12
	popq	%rbx
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	root_res, .-root_res
	.section	.rodata
	.align 8
.LC5:
	.string	"Incrorrect input, check README.md"
.LC6:
	.string	"-r"
.LC7:
	.string	"random num = %lf\n"
.LC9:
	.string	"root: %lf\ntime: %.6lf\n"
.LC10:
	.string	"-h"
.LC11:
	.string	"\n-h help"
.LC12:
	.string	"-r create random number"
	.align 8
.LC13:
	.string	"-f use number from first file and save result in second file"
	.align 8
.LC14:
	.string	"-s take number from terminal and print result in terminal"
.LC15:
	.string	"-f"
.LC16:
	.string	"r"
.LC17:
	.string	"w"
.LC18:
	.string	"incorrect file"
.LC19:
	.string	"%lf"
.LC20:
	.string	"root = %lf\ntime: %.6lf\n"
.LC21:
	.string	"-s"
	.text
	.globl	main
	.type	main, @function
main:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movl	%edi, -100(%rbp)
	movq	%rsi, -112(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$2, -100(%rbp)
	je	.L32
	cmpl	$4, -100(%rbp)
	je	.L32
	leaq	.LC5(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L33
.L32:
	movq	-112(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC6(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L34
	movl	$0, %edi
	call	time@PLT
	movl	%eax, %edi
	call	srand@PLT
	call	rand@PLT
	movl	%eax, %ecx
	movl	$1759218605, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	$12, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	imull	$10000, %eax, %eax
	subl	%eax, %ecx
	movl	%ecx, %eax
	addl	$100, %eax
	movl	%eax, -92(%rbp)
	call	rand@PLT
	movl	%eax, %ecx
	movl	$1374389535, %edx
	movl	%ecx, %eax
	imull	%edx
	sarl	$3, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movl	%edx, %eax
	sall	$2, %eax
	addl	%edx, %eax
	leal	0(,%rax,4), %edx
	addl	%edx, %eax
	subl	%eax, %ecx
	movl	%ecx, %edx
	leal	1(%rdx), %eax
	cvtsi2sd	%eax, %xmm0
	movsd	%xmm0, -32(%rbp)
	cvtsi2sd	-92(%rbp), %xmm0
	divsd	-32(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	leaq	.LC7(%rip), %rdi
	movl	$1, %eax
	call	printf@PLT
	call	clock@PLT
	movq	%rax, -80(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	call	root_res
	movq	%xmm0, %rax
	movq	%rax, -16(%rbp)
	call	clock@PLT
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	subq	-80(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC8(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-16(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	leaq	.LC9(%rip), %rdi
	movl	$2, %eax
	call	printf@PLT
	jmp	.L35
.L34:
	movq	-112(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC10(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L36
	leaq	.LC11(%rip), %rdi
	call	puts@PLT
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	leaq	.LC13(%rip), %rdi
	call	puts@PLT
	leaq	.LC14(%rip), %rdi
	call	puts@PLT
	jmp	.L35
.L36:
	movq	-112(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC15(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L37
	movq	-112(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	leaq	.LC16(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -56(%rbp)
	movq	-112(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	leaq	.LC17(%rip), %rsi
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -48(%rbp)
	cmpq	$0, -56(%rbp)
	je	.L38
	cmpq	$0, -48(%rbp)
	jne	.L39
.L38:
	leaq	.LC18(%rip), %rdi
	call	puts@PLT
	movl	$0, %eax
	jmp	.L33
.L39:
	leaq	-88(%rbp), %rdx
	movq	-56(%rbp), %rax
	leaq	.LC19(%rip), %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_fscanf@PLT
	call	clock@PLT
	movq	%rax, -80(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	call	root_res
	movq	%xmm0, %rax
	movq	%rax, -40(%rbp)
	call	clock@PLT
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	subq	-80(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC8(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rdx, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	leaq	.LC20(%rip), %rsi
	movq	%rax, %rdi
	movl	$2, %eax
	call	fprintf@PLT
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L35
.L37:
	movq	-112(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC21(%rip), %rsi
	movq	%rax, %rdi
	call	strcmp@PLT
	testl	%eax, %eax
	jne	.L35
	leaq	-88(%rbp), %rax
	movq	%rax, %rsi
	leaq	.LC19(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	call	clock@PLT
	movq	%rax, -80(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	call	root_res
	movq	%xmm0, %rax
	movq	%rax, -72(%rbp)
	call	clock@PLT
	movq	%rax, -64(%rbp)
	movq	-64(%rbp), %rax
	subq	-80(%rbp), %rax
	cvtsi2sdq	%rax, %xmm0
	movsd	.LC8(%rip), %xmm1
	divsd	%xmm1, %xmm0
	movq	-72(%rbp), %rax
	movapd	%xmm0, %xmm1
	movq	%rax, -120(%rbp)
	movsd	-120(%rbp), %xmm0
	leaq	.LC20(%rip), %rdi
	movl	$2, %eax
	call	printf@PLT
.L35:
	movl	$0, %eax
.L33:
	movq	-8(%rbp), %rsi
	xorq	%fs:40, %rsi
	je	.L40
	call	__stack_chk_fail@PLT
.L40:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	main, .-main
	.section	.rodata
	.align 16
.LC1:
	.long	0
	.long	-2147483648
	.long	0
	.long	0
	.align 8
.LC2:
	.long	0
	.long	1072693248
	.align 8
.LC3:
	.long	0
	.long	-1074790400
	.align 8
.LC4:
	.long	3539053052
	.long	1062232653
	.align 8
.LC8:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
