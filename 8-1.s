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
	movsd	%xmm0, -8(%rbp)		#double x
	pxor	%xmm0, %xmm0
	ucomisd	-8(%rbp), %xmm0
	jbe	.L7
	movsd	-8(%rbp), %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	jmp	.L5
.L7:
	movsd	-8(%rbp), %xmm0		#return
.L5:
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
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$72, %rsp
	movsd	%xmm0, -72(%rbp)	#double num
	pxor	%xmm0, %xmm0
	ucomisd	-72(%rbp), %xmm0
	jp	.L9
	pxor	%xmm0, %xmm0
	ucomisd	-72(%rbp), %xmm0
	jne	.L9
	pxor	%xmm0, %xmm0
	jmp	.L11
.L9:
	movsd	.LC2(%rip), %xmm0
	ucomisd	-72(%rbp), %xmm0
	jp	.L12
	movsd	.LC2(%rip), %xmm0
	ucomisd	-72(%rbp), %xmm0
	jne	.L12
	movsd	.LC2(%rip), %xmm0
	jmp	.L11
.L12:
	movsd	.LC3(%rip), %xmm0
	ucomisd	-72(%rbp), %xmm0
	jp	.L14
	movsd	.LC3(%rip), %xmm0
	ucomisd	-72(%rbp), %xmm0
	jne	.L14
	movsd	.LC3(%rip), %xmm0
	jmp	.L11
.L14:
	pxor	%xmm0, %xmm0
	ucomisd	-72(%rbp), %xmm0
	jbe	.L30
	movsd	-72(%rbp), %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	movsd	%xmm0, -72(%rbp)
	movl	$5, -52(%rbp)		#rootDegree = 5
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -8(%rbp)		#eps
	cvtsi2sd	-52(%rbp), %xmm0
	movsd	-72(%rbp), %xmm1
	divsd	%xmm0, %xmm1		# root =
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
	movsd	-72(%rbp), %xmm0
	movsd	%xmm0, -40(%rbp)
	jmp	.L18
.L21:
	movsd	-72(%rbp), %xmm0
	movsd	%xmm0, -40(%rbp)
	movl	$1, -64(%rbp)
	jmp	.L19
.L20:
	movsd	-40(%rbp), %xmm0
	divsd	-48(%rbp), %xmm0
	movsd	%xmm0, -40(%rbp)
	addl	$1, -64(%rbp)
.L19:
	cmpl	$4, -64(%rbp)
	jle	.L20
	movsd	-40(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-72(%rbp), %xmm1
	movsd	.LC2(%rip), %xmm0
	divsd	-72(%rbp), %xmm0
	movsd	.LC2(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	-48(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -48(%rbp)
.L18:
	movsd	-48(%rbp), %xmm0
	subsd	-40(%rbp), %xmm0	#(root - rn) to mabs
	call	mabs
	ucomisd	-8(%rbp), %xmm0		#result of mabs
	jnb	.L21
	movsd	-48(%rbp), %xmm1
	movq	.LC1(%rip), %xmm0
	xorpd	%xmm1, %xmm0
	jmp	.L11
.L30:
	movl	$5, -56(%rbp)		#rootDegree = 5
	movsd	.LC4(%rip), %xmm0
	movsd	%xmm0, -16(%rbp)
	cvtsi2sd	-56(%rbp), %xmm0
	movsd	-72(%rbp), %xmm1
	divsd	%xmm0, %xmm1
	movapd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
	movsd	-72(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	jmp	.L22
.L25:
	movsd	-72(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	movl	$1, -60(%rbp)
	jmp	.L23
.L24:
	movsd	-24(%rbp), %xmm0
	divsd	-32(%rbp), %xmm0
	movsd	%xmm0, -24(%rbp)
	addl	$1, -60(%rbp)
.L23:
	cmpl	$4, -60(%rbp)
	jle	.L24
	movsd	-24(%rbp), %xmm0
	movapd	%xmm0, %xmm1
	divsd	-72(%rbp), %xmm1
	movsd	.LC2(%rip), %xmm0
	divsd	-72(%rbp), %xmm0
	movsd	.LC2(%rip), %xmm2
	subsd	%xmm0, %xmm2
	movapd	%xmm2, %xmm0
	mulsd	-32(%rbp), %xmm0
	addsd	%xmm1, %xmm0
	movsd	%xmm0, -32(%rbp)
.L22:
	movsd	-32(%rbp), %xmm0
	subsd	-24(%rbp), %xmm0
	call	mabs
	ucomisd	-16(%rbp), %xmm0
	jnb	.L25
	movsd	-32(%rbp), %xmm0	#return root
.L11:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	root_res, .-root_res
	.section	.rodata
	.align 8
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
