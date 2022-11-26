	.intel_syntax noprefix
	.text
	.global time_now
	.global get_delta

# input: rax - container for time
time_now:
	mov rsi, rax
	mov rax, 228
    xor edi, edi
    syscall
    ret

# input: rax - start time seconds
# input: rbx - start time millis
# input: rcx - end time seconds
# input: rdx - end time millis
# input: r8 - delta seconds
# input: r9 - delta millis
get_delta:
	sub rcx, rax
    cmp rdx, rbx
    jge .subNanoOnly
    dec rcx
    add rdx, 1000000000
    .subNanoOnly:
    sub rdx, rbx
    mov [r8], rcx
    mov [r9], rdx
	ret
