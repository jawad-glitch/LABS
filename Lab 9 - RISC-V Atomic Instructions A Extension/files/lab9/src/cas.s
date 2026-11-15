.section .text
.align 2
.globl _start
.globl compare_and_swap

_start:
    la a0, cas_target
    li a1, 41
    li a2, 99
    jal ra, compare_and_swap
    li t0, 1
    bne a0, t0, fail

    la t1, cas_target
    lw t2, 0(t1)
    li t0, 99
    bne t2, t0, fail

    la a0, cas_target
    li a1, 41
    li a2, 123
    jal ra, compare_and_swap
    bnez a0, fail

    la t1, cas_target
    lw t2, 0(t1)
    li t0, 99
    bne t2, t0, fail

    li a7, 93
    li a0, 0
    ecall

fail:
    li a7, 93
    li a0, 1
    ecall

compare_and_swap:
1:
    lr.w.aq t0, (a0)
    bne t0, a1, 2f
    sc.w.rl t1, a2, (a0)
    bnez t1, 1b
    li a0, 1
    ret
2:
    li a0, 0
    ret

.section .data
.align 2
cas_target:
    .word 41
