    .intel_syntax noprefix
    .bss
    .lcomm integer_part, 8
    .lcomm decimal_part, 8
    .lcomm temp, 4
    .lcomm double_buffer, 8
    .text
    .global string_to_number
    .global string_to_float
    .global number_to_string
    .global float_to_string
    .global get_string_length
    .global string_compare
    .global find_substring
    .global string_copy
    .global find_char

# input: rax - src
# output: rbx - dst
string_copy:
    push rcx
    push rdx
    mov r8, rax
    mov r9, rbx
    call get_string_length
    mov rdx, rax
    xor rcx, rcx
    .copy_str_loop:
        cmp rcx, rdx
        jge .copy_str_exit
        mov al, byte ptr [r8 + rcx]
        mov byte ptr [r9 + rcx], al
        inc rcx
        jmp .copy_str_loop

    .copy_str_exit:
    pop rdx
    pop rcx
    ret


# input: rax - string 
# output: rax - number
string_to_number:
    push rbx
    push rcx
    push rdx
    push rsi
    xor rbx, rbx
    xor rcx, rcx
    xor rsi, rsi
    .s2n_next_iter:
        cmp byte ptr [rax+rbx], 0
        je .s2n_next_step
        mov cl, [rax+rbx]
        cmp cl, '-'
        jne .s2n_neg_num
        mov rsi, 1
        inc rbx
        jmp .s2n_next_iter
        .s2n_neg_num:
            sub cl, '0'
            push rcx
            inc rbx
            jmp .s2n_next_iter
    .s2n_next_step:
        mov rcx, 1
        xor rax, rax
        cmp rsi, 1
        jne .s2n_to_number
        dec rbx
    .s2n_to_number:
        cmp rbx, 0
        je .s2n_close
        pop rdx
        imul rdx, rcx
        imul rcx, 10
        add rax, rdx
        dec rbx
        jmp .s2n_to_number
    .s2n_close:
        cmp rsi, 0
        je .s2n_pos_num
        neg rax
        .s2n_pos_num:
            pop rsi
            pop rdx
            pop rcx
            pop rbx
            ret


# input: rax - string
# input: bl - min code
# output: rax - index or -1
find_char:
    push rcx
    mov r10, rax
    call get_string_length
    mov r11, rax
     xor rcx, rcx
    .find_char_loop:
        cmp rcx, r11
        jge .find_char_loop_nf
        xor rax, rax
        mov al, byte ptr [r10 + rcx]
        cmp rax, rbx
        jge .find_char_loop_success
        inc rcx
        jmp .find_char_loop
    .find_char_loop_success:
    mov rax, rcx
    jmp .find_char_loop_exit
    .find_char_loop_nf:
    mov rax, -1
    .find_char_loop_exit:
    pop rcx
    ret


# input: rax - string
# input: rbx - substring
# output: rax - index of -1
find_substring:
    push rcx
    push rdx
    push rsi
    mov r10, rax
    mov r11, rbx

    mov rax, r10
    call get_string_length
    mov r8, rax

    mov rax, r11
    call get_string_length
    mov r9, rax

    cmp r8, r9
    jge .find_string_s1
    mov rax, -1
    jmp .find_string_exit
    .find_string_s1:
    mov rax, -1
    xor rcx, rcx                            # counter for string
    xor rdx, rdx                            # counter for substring
    .find_string_loop:                      # main i loop
        xor rdx, rdx                        # j = 0
        cmp rcx, r8
        jge .find_string_nf
        mov al, byte ptr [r10 + rcx]        # get char form string
        mov bl, byte ptr [r11]              # get char from substring
        inc rcx
        cmp al, bl                          # compare them
        jne .find_string_loop               # if not equal - move to next char
        mov rsi, rcx
        inc rdx
        .find_string_second_loop:
            cmp rdx, r9
            jge .find_string_loop_success
            mov al, byte ptr [r10 + rcx]
            mov bl, byte ptr [r11 + rdx]
            cmp al, bl
            jne .find_string_second_loop_exit
            inc rdx
            inc rcx
            jmp .find_string_second_loop
        .find_string_second_loop_exit:
            mov rcx, rsi
            jmp .find_string_loop
    .find_string_loop_success:
    mov rax, rsi
    dec rax
    jmp .find_string_exit
    .find_string_nf:
    mov rax, -1
    .find_string_exit:
    pop rsi
    pop rdx
    pop rcx
    ret


# input: rax - first string
# input: rbx - second string
# output: rax: 1 if equal 0 if not
string_compare:
    push rcx
    push rdx
    push rsi
    mov rsi, rax
    call get_string_length  # get length of first string
    mov r8, rax         # save value into r8
    mov rax, rbx       
    call get_string_length  # get length of second string
    mov r9, rax         # save value into r9
    cmp r8, r9
    jne .scmp_false
    xor rdx, rdx        # counter
    .scmp_loop:
        cmp rdx, r8
        jge .scmp_true
        mov al, byte ptr [rsi + rdx] # get string1[counter]
        mov cl, byte ptr [rbx + rdx] # get string2[counter]
        cmp al, cl
        jne .scmp_false
        inc rdx
        jmp .scmp_loop

    .scmp_true:
        mov rax, 1
        jmp .scmp_ret

    .scmp_false:
        xor rax, rax
        jmp .scmp_ret

    .scmp_ret:
        pop rsi
        pop rdx
        pop rcx
        ret

# input: rax - string
# output: rax - length
get_string_length:
    push rbx            # save to stack
    push rdx            # save to stack
    xor rdx, rdx        # make rdx null
    .len_next_iter:    
        mov bl, byte ptr [rax + rdx]     
        cmp bl, 0      # compare current char to null
        je .len_close
        inc rdx
        jmp .len_next_iter
    .len_close:
        mov rax, rdx    # save result to rax
        pop rdx
        pop rbx
        ret

# input: rax - number
# input: rbx - buffer
# input: rcx - buffer size
number_to_string:
    push r12
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    mov rsi, rcx
    xor rcx, rcx
    mov r12, rax
    cmp rax, 0
    jl .n2s_neg
    jmp .n2s_next_iter
    .n2s_neg:
        neg rax
    .n2s_next_iter:
        push rbx
        mov rbx, 10
        xor rdx, rdx
        div rbx
        pop rbx
        add rdx, '0'
        push rdx
        inc rcx
        cmp rax, 0
        je .n2s_next_step
        jmp .n2s_next_iter
    .n2s_next_step:
        mov rdx, rcx
        xor rcx, rcx
        cmp r12, 0
        jge .n2s_to_string
        mov byte ptr [rbx], '-'
        inc rcx
        inc rdx
    .n2s_to_string:
        cmp rcx, rsi
        je .n2s_pop_iter
        cmp rcx, rdx
        je .n2s_null_char
        pop rax
        mov [rbx+rcx], rax
        inc rcx
        jmp .n2s_to_string
    .n2s_pop_iter:
        cmp rcx, rdx
        je .n2s_close
        pop rax
        inc rcx
        jmp .n2s_pop_iter
    .n2s_null_char:
        mov rsi, rdx
    .n2s_close:
        mov byte ptr [rbx+rsi], 0
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        pop rax
        pop r12
        ret

# input: rax - string buffer
# output: xmm0 - float number
string_to_float:
    push rbx
    push rcx
    push rdx
    push rsi
    mov rbx, rax
    mov rax, rbx
    call get_string_length
    mov rdx, rax
    xor rcx, rcx
    xor rsi, rsi
    .crf_loop_int:
        cmp rcx, rdx
        jge .crf_loop_exit
        mov al, '.'
        cmp al, byte ptr [rbx + rcx]
        je .crf_loop_dec
        mov al, byte ptr [rbx + rcx]
        mov [integer_part + rcx], al
        inc rcx
        jmp .crf_loop_int
    .crf_loop_dec:
        cmp rcx, rdx
        jge .crf_loop_exit
        mov al, '.'
        cmp al, byte ptr [rbx + rcx]
        je .crf_ld_1
        mov al, byte ptr [rbx + rcx]
        mov [decimal_part + rsi], al
        inc rsi
        .crf_ld_1:
        inc rcx
        jmp .crf_loop_dec
    .crf_loop_exit:
        mov rax, offset decimal_part
        call get_string_length
        mov rdx, rax
        mov rax, offset decimal_part
        call string_to_number
        movq double_buffer, rax
        mov rax, 10
        mov rbx, rdx
        call pow
        finit
        fild qword ptr [double_buffer]
        movq double_buffer, rax
        fild qword ptr [double_buffer]
        fdivp
        mov rax, offset integer_part
        call string_to_number
        cmp rax, 0
        jge .crf_pos
        neg rax
        movq double_buffer, rax
        fild qword ptr [double_buffer]
        faddp
        fchs
        fstp qword ptr [double_buffer]
        movq xmm0, double_buffer
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        ret
        .crf_pos:
        movq double_buffer, rax
        fild qword ptr [double_buffer]
        faddp
        fstp qword ptr [double_buffer]
        movq xmm0, double_buffer
        pop rsi
        pop rdx
        pop rcx
        pop rbx
        ret

# input: xmm0 - float number
# input: rbx - string buffer
float_to_string:
    ret
