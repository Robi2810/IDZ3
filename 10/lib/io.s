    .intel_syntax noprefix

    .bss
    .lcomm _char_buffer, 1
    .equ _str_buffer_size, 4096
    .lcomm _str_buffer, _str_buffer_size
    .lcomm fpu_controlword, 4
    .lcomm integer_part, 8
    .lcomm decimal_part, 8
    .lcomm temp, 4
    .lcomm double_buffer, 8

    .section .rodata        
    decimal_places: .word 10000


    .text
    .global _str_buffer
    .global console_write_char
    .global console_write_number
    .global console_write_string
    .global console_write_float
    .global console_write_big_string
    .global console_new_line
    .global console_read_string
    .global console_read_number
    .global console_read_float
    .global file_open
    .global file_read_line
    .global file_write_line
    .global file_close
    .global file_create
    .global file_read_all
    .global file_write_float

# output: rax - number
console_read_number:
    call console_read_string
    mov rax, offset _str_buffer
    call string_to_number
    ret

# output: _str_buffer - string
console_read_string:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi

    mov rsi, offset _str_buffer
    mov rdx, _str_buffer_size
    mov rax, 0
    mov rdi, 0
    syscall

    mov byte ptr [rsi+rax-1], 0

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

# input: rax - number to print
console_write_number:
    push rax
    push rbx
    push rcx
    push rdx
    xor rcx, rcx
    cmp rax, 0
    jl .num_is_minus            # if number is negative
    jmp .num_next_iter
    .num_is_minus:
        neg rax                 # make it positive
        push rax
        mov rax, '-'            # just add '-' before number
        call console_write_char
        pop rax
    .num_next_iter:
        mov rbx, 10
        xor rdx, rdx
        div rbx
        add rdx, '0'            # convert number to char to print
        push rdx
        inc rcx
        cmp rax, 0
        je .num_print_iter
        jmp .num_next_iter
    .num_print_iter:
        cmp rcx, 0
        je .num_close
        pop rax
        call console_write_char
        dec rcx
        jmp .num_print_iter
    .num_close:
        pop rdx
        pop rcx
        pop rbx
        pop rax
        ret

# input: rax - string to print
console_write_string:
    push rcx
    push rdi
    push rsi
    push rdx
    mov rcx, rax            # rax - input string save it to rcx
    call get_string_length  # get length of string and save it to rax
    mov rdx, rax            # move length to rdx
    mov rax, 1              # write
    mov rdi, 1              # stdout
    mov rsi, rcx            # string addr   
    syscall
    pop rdx
    pop rsi
    pop rdi
    pop rcx
    ret

# input: rax - char to print
console_write_char:
    push rax
    push rdi
    push rcx
    push rdx

    mov [_char_buffer], al

    mov rax, 1
    mov rdi, 1
    mov rsi, offset _char_buffer
    mov rdx, 1
    syscall
    pop rdx
    pop rcx
    pop rdi
    pop rax
    ret

# input: none
console_new_line:
    push rax
    push rbx
    push rcx
    push rcx
    mov rax, 0xA
    call console_write_char
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret

# input: rax - filename
# input: rbx - mode
# output: rax - error code if any or file desc
file_open:
    push rdx
    mov rdi, rax                    # filename
    mov rax, 2                      # open                    
    mov rsi, rbx                    # mode
    mov rdx, 436                    # -rw-rw-r--
    syscall
    pop rdx
    ret

# input: rax - file desc
# output: _str_buffer - data
file_read_line:
    push r12
    push r13
    push r14
    push rcx
    push rdx
    mov r12, rax
    mov r14, offset _str_buffer
    xor r13, r13
    .rd_ch_lp:                          # reading 1 byte and checking if it is eol
        mov rdi, r12                    # file
        mov rax, 0                      # read
        mov rsi, offset _char_buffer    # buffer
        mov rdx, 1                      # number of bytes to read
        syscall
        mov rax, _char_buffer
        cmp rax, 0xA
        je .rd_ch_lp_ex
        mov [r14 + r13], rax            # append to save to _str_buffer
        inc r13
        jmp .rd_ch_lp
    .rd_ch_lp_ex:
        pop rdx
        pop rcx
        pop r14
        pop r13
        pop r12
        ret

# input: rax - file desc
# input: rbx - string
# input: rcx - string length
# output: none
file_write_line:
    push rdx
    mov rdi, rax                    # file
    mov rax, 1                      # write
    mov rsi, rbx                    # value
    mov rdx, rcx                    # number of bytes to write                 
    syscall
    pop rdx
    ret

# input: rax - file
# output: none
file_close:
    mov rdi, 3
    syscall
    ret

# input: rax - fname
# output: rax - file desc
file_create:
    mov rdi, rax
    mov rax, 85                     # create output file
    mov rsi, 436                    # -rw-rw-r--
    syscall
    ret

# input: rax - file desc
# input: rbx - string array
# input: rcx - max length
file_read_all:
    push r12
    push r13
    push r14
    push r15
    push rdx
    mov r12, rax
    mov r14, rbx
    mov r15, rcx
    xor r13, r13
    .rd_ch_lp_2:                          # reading 1 byte and checking if it is eol
        mov rdi, r12                    # file
        mov rax, 0                      # read
        mov rsi, offset _char_buffer    # buffer
        mov rdx, 1                      # number of bytes to read
        syscall
        cmp rax, 0x0
        je .rd_ch_lp_ex_2
        mov rax, _char_buffer
        mov [r14 + r13], rax            # append to save to array
        inc r13
        cmp r13, r15
        jge .rd_ch_lp_ex_2
        jmp .rd_ch_lp_2
    .rd_ch_lp_ex_2:
        pop rdx
        pop r15
        pop r14
        pop r13
        pop r12
        ret

# input: rax - length of string
# input: rdi - addr of string
console_write_big_string:
    push rbx
    push rcx
    mov rcx, rax
    xor rbx, rbx
    .psa_loop:
        cmp rbx, rcx
        jge .psa_loop_ex
        mov al, byte ptr [rdi + rbx]
        call console_write_char
        inc rbx
        jmp .psa_loop
    .psa_loop_ex:
    pop rcx
    pop rbx
    ret

# output: rax - error code
# output: xmm0 - float number
console_read_float:
    call console_read_string
    mov rax, offset _str_buffer
    call string_to_float
    ret


# input: xmm0 - float number to print
console_write_float:
    push rbx
    push rdx
    push rcx
    movq  double_buffer, xmm0
    finit                               # initialize fpu
    fld      qword ptr [double_buffer]  # st0 := double_buffer
    fisttp   qword ptr [integer_part]   # store int from real
    finit                               # initialize fpu
    fld    qword ptr [double_buffer]    # push double_buffer to st1
    fild   qword ptr [integer_part]     # push integer_part to st0
    fsubp                               # st0 := st1 - st0
    fstp   qword ptr [temp]             # temporarily store subtract result
    finit                               # reset fpu
    fld    qword ptr [temp]             # st1 := temp
    fild   word ptr [decimal_places]    # st0 := decimal_places
    fmulp                               # st0 := st1 * st0
    fild   word ptr [decimal_places]
    fmulp
    fild   word ptr [decimal_places]
    fmulp
    fild   word ptr [decimal_places]
    fmulp
    fistp  qword ptr [decimal_part]     # save decimal_part
    mov rdx, [integer_part]          # get integer_part
    mov rax, [decimal_part]            # get decimal_part
    push rax
    mov rbx, offset _str_buffer
    mov rcx, 21
    call number_to_string
    mov rax, offset _str_buffer
    call get_string_length
    mov rcx, rax
    pop rax
    push rax
    mov rbx, rax      
    mov rax, 0x8000000000000000         # if negative
    and rbx, rax
    cmp rbx, 0
    pop rax
    je .cwf_pos
    not rax
    add rax, 1
    .cwf_pos:
    push rax
    mov rax, rdx
    call console_write_number
    mov rax, '.'
    call console_write_char
    cmp rcx, 16
    jge .cwf_ok
    sub rcx, 16
    neg rcx
    xor rdx, rdx
    .cwf_zero_loop:
        cmp rdx, rcx
        jge .cwf_zero_loop_exit
        mov rax, '0'
        call console_write_char
        inc rdx
        jmp .cwf_zero_loop
    .cwf_zero_loop_exit:
    .cwf_ok:
    pop rax
    call console_write_number
    pop rcx
    pop rdx
    pop rbx
    ret

# input: rax - file desctiptor
# input: xmm0 - float number
file_write_float:
    push r12
    push rbx
    push rdx
    push rcx
    mov r12, rax
    movq  double_buffer, xmm0
    finit                               # initialize fpu
    fld      qword ptr [double_buffer]  # st0 := double_buffer
    fisttp   qword ptr [integer_part]   # store int from real
    finit                               # initialize fpu
    fld    qword ptr [double_buffer]    # push double_buffer to st1
    fild   qword ptr [integer_part]     # push integer_part to st0
    fsubp                               # st0 := st1 - st0
    fstp   qword ptr [temp]             # temporarily store subtract result
    finit                               # reset fpu
    fld    qword ptr [temp]             # st1 := temp
    fild   word ptr [decimal_places]    # st0 := decimal_places
    fmulp                               # st0 := st1 * st0
    fild   word ptr [decimal_places]
    fmulp
    fild   word ptr [decimal_places]
    fmulp
    fild   word ptr [decimal_places]
    fmulp
    fistp  qword ptr [decimal_part]     # save decimal_part
    mov rdx, [integer_part]          # get integer_part
    mov rax, [decimal_part]            # get decimal_part
    push rax
    mov rbx, offset _str_buffer
    mov rcx, 21
    call number_to_string
    mov rax, offset _str_buffer
    call get_string_length
    mov rcx, rax
    pop rax
    push rax
    mov rbx, rax      
    mov rax, 0x8000000000000000         # if negative
    and rbx, rax
    cmp rbx, 0
    pop rax
    je .fwf_pos
    not rax
    add rax, 1
    push rax
    mov rax, r12
    mov rbx, '-'
    call file_write_char
    pop rax
    .fwf_pos:
    push rax
    push rcx
    mov rax, rdx
    mov rbx, offset _str_buffer
    mov rcx, 21
    call number_to_string
    mov rax, offset _str_buffer
    call get_string_length
    mov rcx, rax
    mov rax, r12
    mov rbx, offset _str_buffer
    call file_write_line
    pop rcx
    mov rax, r12
    mov rbx, '.'
    call file_write_char
    cmp rcx, 16
    jge .fwf_ok
    sub rcx, 16
    neg rcx
    xor rdx, rdx
    .fwf_zero_loop:
        cmp rdx, rcx
        jge .fwf_zero_loop_exit
        mov rax, r12
        mov rbx, '0'
        call file_write_char
        inc rdx
        jmp .fwf_zero_loop
    .fwf_zero_loop_exit:
    .fwf_ok:
    pop rax
    push rcx
    mov rbx, offset _str_buffer
    mov rcx, 21
    call number_to_string
    mov rax, offset _str_buffer
    call get_string_length
    mov rcx, rax
    mov rax, r12
    mov rbx, offset _str_buffer
    call file_write_line
    pop rcx
    pop rcx
    pop rdx
    pop rbx
    pop r12
    ret

# input: rax - file desc
# input: rbx - char
file_write_char:
    mov [_str_buffer], bl
    push rcx
    push rdx
    mov rdi, rax                    # file
    mov rax, 1                      # write
    mov rsi, offset _str_buffer     # value
    mov rdx, 1                      # number of bytes to write                 
    syscall
    pop rdx
    pop rcx
    ret
