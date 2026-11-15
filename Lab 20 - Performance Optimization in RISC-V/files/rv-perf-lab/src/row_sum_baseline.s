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
    li s0, 0                 # row index
    li s1, 8                 # number of rows
    li s2, 8                 # number of columns
    la s3, matrix
    la s4, row_sums

row_baseline_outer:
    li s5, 0                 # column index
    li s6, 0                 # row accumulator

row_baseline_inner:
    # Recalculate matrix[row][column] address each iteration.
    mul t0, s0, s2
    add t0, t0, s5
    slli t0, t0, 2
    add t0, s3, t0
    lw t1, 0(t0)
    add s6, s6, t1

    addi s5, s5, 1
    blt s5, s2, row_baseline_inner

    slli t2, s0, 2
    add t2, s4, t2
    sw s6, 0(t2)

    addi s0, s0, 1
    blt s0, s1, row_baseline_outer

    li a0, 0
    li a7, 93
    ecall
