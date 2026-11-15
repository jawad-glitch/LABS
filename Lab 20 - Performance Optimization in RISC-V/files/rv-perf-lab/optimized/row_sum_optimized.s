.section .data
.align 2
.globl matrix
matrix:
.word 1,2,3,4,5,6,7,8
.word 9,10,11,12,13,14,15,16
.word 17,18,19,20,21,22,23,24
.word 25,26,27,28,29,30,31,32
.word 33,34,35,36,37,38,39,40
.word 41,42,43,44,45,46,47,48
.word 49,50,51,52,53,54,55,56
.word 57,58,59,60,61,62,63,64

.globl row_sums
row_sums:
.space 32

.section .text
.globl _start
_start:
    la s0, matrix
    la s1, row_sums
    li s2, 8

row_optimized_outer:
    # Four independent lane accumulators, reset for each row.
    li s3, 0
    li s4, 0
    li s5, 0
    li s6, 0
    li t0, 2

.globl row_unroll_loop
row_unroll_loop:
    # Four columns per iteration; two iterations cover one row.
    lw t1, 0(s0)
    add s3, s3, t1
    lw t1, 4(s0)
    add s4, s4, t1
    lw t1, 8(s0)
    add s5, s5, t1
    lw t1, 12(s0)
    add s6, s6, t1

    addi s0, s0, 16
    addi t0, t0, -1
    bnez t0, row_unroll_loop

    # Combine the four accumulators.
    add t1, s3, s4
    add t2, s5, s6
    add t1, t1, t2
    sw t1, 0(s1)

    addi s1, s1, 4
    addi s2, s2, -1
    bnez s2, row_optimized_outer

    li a0, 0
    li a7, 93
    ecall
