.section .data
msg:
    .ascii "Testing RISC-V mmap and munmap...\n"
.set msg_len, .-msg

success:
    .ascii "Memory allocation and verification successful.\n"
.set success_len, .-success

.section .text
.global _start

_start:
    li a7, 64
    li a0, 1
    la a1, msg
    li a2, msg_len
    ecall

    # mmap
    li a7, 222
    li a0, 0
    li a1, 4096
    li a2, 3
    li a3, 34
    li a4, -1
    li a5, 0
    ecall

    li t0, -4095
    bgeu a0, t0, error_exit

    mv s0, a0

    # Write and verify allocated memory
    li t1, 0x12345678
    sw t1, 0(s0)
    lw t2, 0(s0)
    bne t1, t2, error_exit

    # munmap
    li a7, 215
    mv a0, s0
    li a1, 4096
    ecall

    bnez a0, error_exit

    li a7, 64
    li a0, 1
    la a1, success
    li a2, success_len
    ecall

    li a7, 93
    li a0, 0
    ecall

error_exit:
    li a7, 93
    li a0, 1
    ecall
