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
    li s2, 0
    li s3, 64
    li s4, 1

dot_baseline_loop:
    # Recalculate both element addresses on every iteration.
    mul t0, s2, s4
    slli t0, t0, 2
    add t1, s0, t0

    mul t2, s2, s4
    slli t2, t2, 2
    add t3, s1, t2

    lw t4, 0(t1)
    lw t5, 0(t3)
    mul t6, t4, t5
    add s5, s5, t6

    addi s2, s2, 1
    blt s2, s3, dot_baseline_loop

    la t0, dot_result
    sw s5, 0(t0)

    li a0, 0
    li a7, 93
    ecall
