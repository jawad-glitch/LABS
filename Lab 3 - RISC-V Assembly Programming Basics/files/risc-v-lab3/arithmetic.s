.option norelax
.section .text
.globl _start

_start:
    li x1, 15
    li x2, 7

    add x3, x1, x2
    sub x4, x1, x2
    mul x5, x1, x2

    la x6, result_add
    sw x3, 0(x6)

    la x6, result_sub
    sw x4, 0(x6)

    la x6, result_mul
    sw x5, 0(x6)

    lw x7, 0(x6)
    li x8, 105
    bne x7, x8, failed

    la x6, result_add
    lw x7, 0(x6)
    li x8, 22
    bne x7, x8, failed

    la x6, result_sub
    lw x7, 0(x6)
    li x8, 8
    bne x7, x8, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

.section .data
.align 2
result_add: .word 0
result_sub: .word 0
result_mul: .word 0
