.section .data
msg:
    .ascii "RISC-V syscall benchmark completed: 10000 getpid calls.\n"
.set msg_len, .-msg

.section .text
.global _start

_start:
    li t0, 10000

loop:
    li a7, 172
    ecall
    addi t0, t0, -1
    bnez t0, loop

    li a7, 64
    li a0, 1
    la a1, msg
    li a2, msg_len
    ecall

    li a7, 93
    li a0, 0
    ecall
