.section .data
.align 2
.globl input_a
input_a:
.word 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
.word 17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32
.word 33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48
.word 49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64
.globl input_b
input_b:
.word 64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49
.word 48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33
.word 32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17
.word 16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1
.globl dot_result
dot_result:
.word 0

.section .text
.globl _start
_start:
    la s0, input_a
    la s1, input_b
    li t0, 16

    # Four independent accumulators.
    li s2, 0
    li s3, 0
    li s4, 0
    li s5, 0

.globl dot_loop
dot_loop:
    lw t1, 0(s0)
    lw t2, 0(s1)
    mul t3, t1, t2
    add s2, s2, t3

    lw t1, 4(s0)
    lw t2, 4(s1)
    mul t3, t1, t2
    add s3, s3, t3

    lw t1, 8(s0)
    lw t2, 8(s1)
    mul t3, t1, t2
    add s4, s4, t3

    lw t1, 12(s0)
    lw t2, 12(s1)
    mul t3, t1, t2
    add s5, s5, t3

    addi s0, s0, 16
    addi s1, s1, 16
    addi t0, t0, -1
    bnez t0, dot_loop

    add t0, s2, s3
    add t1, s4, s5
    add t0, t0, t1

    la t1, dot_result
    sw t0, 0(t1)

    li a0, 0
    li a7, 93
    ecall
