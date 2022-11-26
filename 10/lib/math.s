.intel_syntax noprefix
    .bss
    .lcomm double_buffer, 8
    .lcomm temp, 8
    .text
    .global pow
    .global factorial
    .global pow_double

# input: rax - number 1
# input: rbx - number 2
# output: rax - result
pow:
    cmp rbx, 0
    jne .pow_next
    mov rax, 1
    ret
    .pow_next:
    push rcx
    push rbx
    
    mov rcx, rax
    .pow_loop:
        cmp rbx, 1
        jbe .pow_exit
        imul rax, rcx
        dec rbx
        jmp .pow_loop
    .pow_exit:
        pop rbx
        cmp rbx, 0
        jge .pow_pos
        push rax
        mov rax, rbx
        test rsp, rsp
        test ax, 1
        jz .pow_2
        neg rax
        .pow_2:
        pop rax
    .pow_pos:
        pop rcx
        ret

# input: rax - number
# output: rax - result
factorial:
    push rbx
    mov rbx, rax
    mov rax, 1
    .next_iter:
        cmp rbx, 1
        jle .close
        mul rbx
        dec rbx
        jmp .next_iter
    .close:
        pop rbx
        ret

# input: xmm0 - real number
# input: rax - integer power
# output: xmm0 - result
pow_double:
    cmp rax, 0
    jne .pow_double_nxt
    finit
    fld1
    fstp qword ptr [double_buffer]
    movq xmm0, double_buffer
    ret
    .pow_double_nxt:
    push rcx
    finit
    movq double_buffer, xmm0
    fld qword ptr [double_buffer]
    fabs
    fstp qword ptr [double_buffer]
    fld qword ptr [double_buffer]
    xor rcx, rcx
    inc rcx
    .pd_loop:
        cmp rcx, rax
        jge .pdl_exit
        fld qword ptr [double_buffer]
        fmulp
        inc rcx
        jmp .pd_loop
    .pdl_exit:
    and ax, 0x0180
    cmp ax, 0x0180
    jne .pow_double_exit
    fchs
    .pow_double_exit:
    fstp qword ptr [double_buffer]
    movq xmm0, double_buffer
    pop rcx
    ret
