.section .text
.globl _start

_start:
    li t0, 42
    li t1, 8
    add t2, t0, t1

    # Linux RISC-V exit syscall:
    # a7 = 93, a0 = exit status 0
    li a0, 0
    li a7, 93
    ecall
