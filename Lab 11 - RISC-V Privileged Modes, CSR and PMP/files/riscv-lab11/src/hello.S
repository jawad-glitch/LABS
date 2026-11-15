.section .text
.globl _start
_start:
    li t0, 0x10000000
    la t1, message
1:
    lbu t2, 0(t1)
    beqz t2, 2f
    sb t2, 0(t0)
    addi t1, t1, 1
    j 1b
2:
    j 2b

.section .rodata
message:
    .asciz "M-mode pipeline OK\n"
