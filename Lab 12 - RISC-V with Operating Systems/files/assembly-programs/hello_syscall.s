.section .data
hello_msg:
    .ascii "Hello from RISC-V assembly!\n"
.set hello_len, .-hello_msg

.section .text
.global _start

_start:
    li a7, 64
    li a0, 1
    la a1, hello_msg
    li a2, hello_len
    ecall

    li a7, 93
    li a0, 0
    ecall
