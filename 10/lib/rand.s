    .intel_syntax noprefix
    .text
    .global get_random_number
    .global get_random_string

# input: rax - lower limit
# input: rbx - upped limit
# output: rax - number
get_random_number:
    push rcx
    push rdx
    mov r8, rax
    mov r9, rbx
    sub r9, r8          # upper - lower + 1
    inc r9
    rdtsc
    xor rdx, rdx
    mov rcx, r9
    div rcx
    mov rax, rdx
    add rax, r8
    pop rdx
    pop rcx
    ret

# input: rax - length
# input: rbx - container for string
# output: rbx - generated string
get_random_string:
    push rdx
    push rcx
    push rsi
    mov rdx, rax
    inc rdx
    mov rsi, rbx
    xor rcx, rcx
    .get_random_string_loop:
        cmp rcx, rdx
        jge .get_random_string_loop_exit
        mov rax, 0
        mov rbx, 127
        call get_random_number
        mov byte ptr [rsi + rcx], al
        inc rcx
        jmp .get_random_string_loop
.get_random_string_loop_exit:
    mov byte ptr [rsi+rdx-1], 0
    mov rbx, rsi
    pop rsi
    pop rcx
    pop rdx
    ret
