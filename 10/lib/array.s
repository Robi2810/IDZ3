    .intel_syntax noprefix

    .text
    .global create_array
    .global free_array
    .global console_read_number_array
    .global console_write_number_array

msg_malloc_err:
    .string "Memory allocation error!\n"

# input: rax - bytes to reserve
# output: rdi - addr of array[0]
create_array:
    push rcx
    push rdx
    mov rsi, rax                    # length to reserve
    mov rdi, 0                      # from the start
    mov rdx, 3                      # READ | WRITE
    mov r10, 33
    mov r8, -1
    mov r9, 0
    mov rax, 9                      # 9 for sys_mmap
    syscall

    cmp rax, 0
    jl malloc_err                  # if error - exit
    mov rdi, rax
    pop rdx
    pop rcx
    ret

# input: rax - length
# input: rdi - addr
free_array:
    mov rsi, rax
    mov rax, 11
    syscall
    ret


# input: rax - length of array
# input: rdi - addr of array[0]
# output: rdi - addr of array[0]
console_read_number_array:
    push rcx
    push rax
    push rbx
    mov rcx, rax
    
    xor rbx, rbx
    .arr_lp_rd_it:
        cmp rbx, rcx
        jge .arr_lp_rd_ex
        call console_read_number
        mov [rdi + rbx * 8], rax
        inc rbx
        jmp .arr_lp_rd_it
    .arr_lp_rd_ex:
        pop rbx
        pop rax
        pop rcx
        ret

# input: rax - length of array
# input: rdi - addr of array[0]
# output: none
console_write_number_array:
    push rcx
    push rbx
    mov rcx, rax

    xor rbx, rbx
    .arr_lp_prt_it:
        cmp rbx, rcx
        jge .arr_lp_prt_ex
        mov rax, [rdi + rbx * 8]
        call console_write_number
        mov rax, ' '
        call console_write_char
        inc rbx
        jmp .arr_lp_prt_it
    .arr_lp_prt_ex:
        call console_new_line
        pop rbx
        pop rcx
        ret

malloc_err:
    mov rax, offset msg_malloc_err
    call console_write_string
    mov rax, 60
    mov rdi, 0
    syscall
