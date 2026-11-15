.section .text
.global _start
.type _start, @function

_start:
    li x1, 10
    li x2, 20
    li x3, 0

    add x3, x1, x2

    la x4, result
    sw x3, 0(x4)
    lw x5, 0(x4)

    li x6, 5
    li x7, 0

loop:
    add x7, x7, x6
    addi x6, x6, -1
    bne x6, x0, loop

    li a0, 0
    li a7, 93
    ecall

.section .data
.align 2
result:
    .word 0
