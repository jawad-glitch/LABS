.equ ARRAY_ID, 0
.equ TEST_MODE, 0

.section .text
.globl _start
.globl array_sum
.globl find_max
.option norelax

_start:
    # Select array and element count at assembly time.
.if ARRAY_ID == 0
    la a0, arr_a
    li a1, 3
.elseif ARRAY_ID == 1
    la a0, arr_b
    li a1, 4
.elseif ARRAY_ID == 2
    la a0, arr_c
    li a1, 5
.else
    li a0, 1
    li a7, 93
    ecall
.endif

.if TEST_MODE == 0
    call array_sum
.else
    call find_max
.endif

    li a7, 93
    ecall

array_sum:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0
    mv s1, a1
    li s2, 0

multi_sum_loop:
    beqz s1, multi_sum_done
    lw t0, 0(s0)
    add s2, s2, t0
    addi s0, s0, 4
    addi s1, s1, -1
    j multi_sum_loop

multi_sum_done:
    mv a0, s2
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

find_max:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0
    mv s1, a1
    lw s2, 0(s0)
    addi s0, s0, 4
    addi s1, s1, -1

multi_max_loop:
    beqz s1, multi_max_done
    lw t0, 0(s0)
    bge s2, t0, multi_max_skip
    mv s2, t0

multi_max_skip:
    addi s0, s0, 4
    addi s1, s1, -1
    j multi_max_loop

multi_max_done:
    mv a0, s2
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

.section .data
.align 2
arr_a:
    .word 1, 2, 3
arr_b:
    .word 5, 10, 15, 20
arr_c:
    .word 7, 3, 9, 1, 5
