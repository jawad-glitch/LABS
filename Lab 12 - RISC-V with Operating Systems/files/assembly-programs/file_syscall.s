.section .data
filename:
    .ascii "test_file.txt\0"

write_msg:
    .ascii "Hello from RISC-V Linux file I/O!\n"
.set write_len, .-write_msg

success_msg:
    .ascii "File operations completed successfully!\n"
.set success_len, .-success_msg

error_msg:
    .ascii "File operation failed!\n"
.set error_len, .-error_msg

.section .bss
.align 3
read_buffer:
    .space 128

.section .text
.global _start

_start:
    # Open/create file
    li a7, 56
    li a0, -100
    la a1, filename
    li a2, 577
    li a3, 420
    ecall

    bltz a0, error_exit
    mv s0, a0

    # Write file
    li a7, 64
    mv a0, s0
    la a1, write_msg
    li a2, write_len
    ecall

    bltz a0, error_exit

    # Close file
    li a7, 57
    mv a0, s0
    ecall

    # Open for reading
    li a7, 56
    li a0, -100
    la a1, filename
    li a2, 0
    li a3, 0
    ecall

    bltz a0, error_exit
    mv s0, a0

    # Read file
    li a7, 63
    mv a0, s0
    la a1, read_buffer
    li a2, 128
    ecall

    bltz a0, error_exit
    mv s1, a0

    # Close file
    li a7, 57
    mv a0, s0
    ecall

    # Display success
    li a7, 64
    li a0, 1
    la a1, success_msg
    li a2, success_len
    ecall

    # Display actual read data
    li a7, 64
    li a0, 1
    la a1, read_buffer
    mv a2, s1
    ecall

    li a7, 93
    li a0, 0
    ecall

error_exit:
    li a7, 64
    li a0, 2
    la a1, error_msg
    li a2, error_len
    ecall

    li a7, 93
    li a0, 1
    ecall
