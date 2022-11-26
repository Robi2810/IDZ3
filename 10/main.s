.intel_syntax noprefix
    .bss
    .lcomm _out_fname, 128
    .equ _string_limit, 4096
    .equ double_upper_limit, 6
    .equ double_lower_limit, -6
    .lcomm double_buffer, 8
    .lcomm double_ex, 8
    .lcomm double_ex2, 8
    .lcomm double_sum_buffer, 8
    .lcomm double_sum_buffer_prev, 8
    .lcomm double_delta, 8
    .lcomm string_buf, _string_limit
    .lcomm substring_buf, _string_limit
    ReadStartTime: .space 16
    ReadEndTime: .space 16
    ReadDeltaTime: .space 16
    CalcStartTime: .space 16
    CalcEndTime: .space 16
    CalcDeltaTime: .space 16
    WriteStartTime: .space 16
    WriteEndTime: .space 16
    WriteDeltaTime: .space 16

    .text
    .global _start
msg_inv_args:
    .string "Invalid args count. See README file for corect usage.\n"
msg_inv_flag:
    .string "Invalid flag. See README file for corect usage.\n"
msg_enter_float:
    .string "Enter the x value: "
msg_gen_float:
    .string "Generated x value: "
msg_result_value:
    .string "Value of sqrt5(x) = "
msg_delta:
    .string "Delta: "
msg_value:
    .string "Value: "
msg_err:
    .string "Error while opening a file: "
msg_inv_float:
    .string "Wrong float number format\n"
msg_time:
    .string "Elapsed time:  \n"
msg_time_read:
    .string "Read:          "
msg_time_calc:
    .string "Calculations:  "
msg_time_write:
    .string "Write:         "
flag_file:
    .string "-f"
flag_random:
    .string "-r"
flag_console:
    .string "-c"

.LC1:
    .long   0
    .long   -2147483648
    .long   0
    .long   0
    .align 8
.LC2:
    .long   0
    .long   1072693248
    .align 8
.LC3:
    .long   0
    .long   -1074790400
    .align 8
.LC4:
    .long   3539053052
    .long   1062232653
    .align 8
.LC8:
    .long   0
    .long   1093567616


mabs:
    push    rbp
    mov rbp, rsp
    movsd   QWORD PTR -8[rbp], xmm0
    pxor    xmm0, xmm0
    ucomisd xmm0, QWORD PTR -8[rbp]
    jbe .L7
    movsd   xmm1, QWORD PTR -8[rbp]
    movq    xmm0, QWORD PTR .LC1[rip]
    xorpd   xmm0, xmm1
    jmp .L5
.L7:
    movsd   xmm0, QWORD PTR -8[rbp]
.L5:
    pop rbp
    ret
    .size   mabs, .-mabs


_start:
    mov r12, [rsp]
    cmp r12, 2                          # check number of args
    jl inv_args_count                   # if < 2 display error message                                 
    mov rcx, 16[rsp]
    mov rax, rcx
    mov rbx, offset flag_console
    call string_compare
    cmp rax, 1
    je .console_input
    mov rax, rcx
    mov rbx, offset flag_random
    call string_compare
    cmp rax, 1
    je .random_input
    mov rax, rcx
    mov rbx, offset flag_file
    call string_compare
    cmp rax, 1
    je .file_input
    mov rax, offset msg_inv_flag
    call console_write_string
    jmp exit

.console_input:
    mov rax, offset msg_enter_float
    call console_write_string
    call console_read_float
    mov rax, offset msg_gen_float
    call console_write_string
    call console_write_float
    call console_new_line
    movq r12, xmm0
    mov r15, 0
    jmp .do_task

.random_input:
    cmp r12, 4
    jne inv_args_count
    mov rax, 24[rsp]                            # get lower rand value
    call string_to_number
    mov rcx, rax                                # save it to rcx
    mov rax, 32[rsp]                            # get upper rand value
    call string_to_number
    mov rbx, rax
    mov rax, rcx
    call get_random_number
    cvtsi2sd xmm0, rax
    movq r12, xmm0                                # store x in r12
    mov r15, 0
    mov rax, offset msg_gen_float
    call console_write_string
    call console_write_float
    call console_new_line
    jmp .do_task

.file_input:
    lea rax, ReadStartTime[rip]
    call time_now
    cmp r12, 4
    jne inv_args_count

    mov rax, 24[rsp]                    # store in rax filename input
    mov rdx, rax
    mov rbx, 0                          # 0 - read
    call file_open

    cmp rax, -1                         # if error
    jl .file_open_error

    push rax                            # push file descriptor
    call file_read_line                 # read x value from file
    mov rax, offset _str_buffer
    call string_to_float
    mov rax, offset msg_gen_float
    call console_write_string
    call console_write_float
    call console_new_line
    movq r12, xmm0                        # store x in r12
    pop rax
    call file_close

   

    mov rax, 32[rsp]
    mov rbx, offset _out_fname          # save output filename
    call string_copy
    lea rax, ReadEndTime[rip]
    call time_now
    mov r15, 1
    jmp .do_task

    
.do_task:
    lea rax, CalcStartTime[rip]
    call time_now

    # r12 has value
    movq xmm0, r12
    push    rbp
    mov rbp, rsp
    sub rsp, 56
    movsd   QWORD PTR -56[rbp], xmm0
    mov DWORD PTR -4[rbp], 0
    pxor    xmm0, xmm0
    ucomisd xmm0, QWORD PTR -56[rbp]
    jp  .do_task_if_2
    pxor    xmm0, xmm0
    ucomisd xmm0, QWORD PTR -56[rbp]
    jne .do_task_if_2
    pxor    xmm0, xmm0
    jmp .L11
.do_task_if_2:
    movsd   xmm0, QWORD PTR .LC2[rip]
    ucomisd xmm0, QWORD PTR -56[rbp]
    jp  .do_task_if_3
    movsd   xmm0, QWORD PTR .LC2[rip]
    ucomisd xmm0, QWORD PTR -56[rbp]
    jne .do_task_if_3
    movsd   xmm0, QWORD PTR .LC2[rip]
    jmp .L11
.do_task_if_3:
    movsd   xmm0, QWORD PTR .LC3[rip]
    ucomisd xmm0, QWORD PTR -56[rbp]
    jp  .do_task_if_4
    movsd   xmm0, QWORD PTR .LC3[rip]
    ucomisd xmm0, QWORD PTR -56[rbp]
    jne .do_task_if_4
    movsd   xmm0, QWORD PTR .LC3[rip]
    jmp .L11
.do_task_if_4:
    pxor    xmm0, xmm0
    ucomisd xmm0, QWORD PTR -56[rbp]
    jbe .do_task_main
    movsd   xmm1, QWORD PTR -56[rbp]
    movq    xmm0, QWORD PTR .LC1[rip]
    xorpd   xmm0, xmm1
    movsd   QWORD PTR -56[rbp], xmm0
    mov DWORD PTR -4[rbp], 1
.do_task_main:
    mov DWORD PTR -32[rbp], 5
    movsd   xmm0, QWORD PTR .LC4[rip]
    movsd   QWORD PTR -40[rbp], xmm0
    cvtsi2sd    xmm0, DWORD PTR -32[rbp]
    movsd   xmm1, QWORD PTR -56[rbp]
    divsd   xmm1, xmm0
    movapd  xmm0, xmm1
    movsd   QWORD PTR -16[rbp], xmm0
    movsd   xmm0, QWORD PTR -56[rbp]
    movsd   QWORD PTR -24[rbp], xmm0
    jmp .L18
.L21:
    movsd   xmm0, QWORD PTR -56[rbp]
    movsd   QWORD PTR -24[rbp], xmm0
    mov DWORD PTR -28[rbp], 1
    jmp .L19
.L20:
    movsd   xmm0, QWORD PTR -24[rbp]
    divsd   xmm0, QWORD PTR -16[rbp]
    movsd   QWORD PTR -24[rbp], xmm0
    add DWORD PTR -28[rbp], 1
.L19:
    cmp DWORD PTR -28[rbp], 4
    jle .L20
    movsd   xmm0, QWORD PTR -24[rbp]
    movapd  xmm1, xmm0
    divsd   xmm1, QWORD PTR -56[rbp]
    movsd   xmm0, QWORD PTR .LC2[rip]
    divsd   xmm0, QWORD PTR -56[rbp]
    movsd   xmm2, QWORD PTR .LC2[rip]
    subsd   xmm2, xmm0
    movapd  xmm0, xmm2
    mulsd   xmm0, QWORD PTR -16[rbp]
    addsd   xmm0, xmm1
    movsd   QWORD PTR -16[rbp], xmm0
.L18:
    movsd   xmm0, QWORD PTR -16[rbp]
    subsd   xmm0, QWORD PTR -24[rbp]
    call    mabs
    ucomisd xmm0, QWORD PTR -40[rbp]
    jnb .L21
    cmp DWORD PTR -4[rbp], 0
    jne .L22
    movsd   xmm0, QWORD PTR -16[rbp]
    jmp .L11
.L22:
    movsd   xmm1, QWORD PTR -16[rbp]
    movq    xmm0, QWORD PTR .LC1[rip]
    xorpd   xmm0, xmm1
.L11:
    movq double_sum_buffer, xmm0
    lea rax, CalcEndTime[rip]
    call time_now
    cmp r15, 0
    jg .file_output
    jmp .console_output

.console_output:
    mov rax, offset msg_result_value
    call console_write_string
    movq xmm0, double_sum_buffer
    call console_write_float
    call console_new_line
    jmp exit

.file_output:
    lea rax, WriteStartTime[rip]
    call time_now
    mov rax, offset _out_fname
    call file_create
    mov rbx, 289                        # write + append
    mov rax, offset _out_fname
    call file_open
    mov r13, rax

    movq xmm0,  double_sum_buffer
    call file_write_float

    mov rax, r13
    call file_close
    lea rax, WriteEndTime[rip]
    call time_now

.print_time:
    # print time results for file IO
    # for read
    mov rax, ReadStartTime[rip]
    mov rbx, ReadStartTime[rip + 8]
    mov rcx, ReadEndTime[rip]
    mov rdx, ReadEndTime[rip + 8]
    lea r8, ReadDeltaTime[rip]
    lea r9, ReadDeltaTime[rip + 8]
    call get_delta

    # for calc
    mov rax, CalcStartTime[rip]
    mov rbx, CalcStartTime[rip + 8]
    mov rcx, CalcEndTime[rip]
    mov rdx, CalcEndTime[rip + 8]
    lea r8, CalcDeltaTime[rip]
    lea r9, CalcDeltaTime[rip + 8]
    call get_delta
    
    # for write
    mov rax, WriteStartTime[rip]
    mov rbx, WriteStartTime[rip + 8]
    mov rcx, WriteEndTime[rip]
    mov rdx, WriteEndTime[rip + 8]
    lea r8, WriteDeltaTime[rip]
    lea r9, WriteDeltaTime[rip + 8]
    call get_delta

    
    mov rax, offset msg_time
    call console_write_string

    mov rax, offset msg_time_read
    call console_write_string
    mov rax, ReadDeltaTime[rip]
    call console_write_number
    mov rax, '.'
    call console_write_char
    mov rax, ReadDeltaTime[rip+8]
    call console_write_number
    call console_new_line
    
    mov rax, offset msg_time_calc
    call console_write_string
    mov rax, CalcDeltaTime[rip]
    call console_write_number
    mov rax, '.'
    call console_write_char
    mov rax, CalcDeltaTime[rip+8]
    call console_write_number
    call console_new_line

    mov rax, offset msg_time_write
    call console_write_string
    mov rax, WriteDeltaTime[rip]
    call console_write_number
    mov rax, '.'
    call console_write_char
    mov rax, WriteDeltaTime[rip+8]
    call console_write_number
    call console_new_line    
    jmp exit

.file_open_error:
    mov rax, offset msg_err
    call console_write_string
    mov rax, rdx
    call console_write_string
    call console_new_line
    jmp exit

inv_args_count:
    mov rax, offset msg_inv_args
    call console_write_string
    jmp exit         

exit:
	mov rax, 60
	mov rdi, 0
	syscall
