# Lab 4 - Three-level nested call chain
# outer(7): leaf(7)=107, middle returns 321, outer adds 42 => 363.
# _start checks 363 and exits 0 on success.

.section .text
.globl _start
.option norelax

_start:
    li a0, 7
    call outer
    li t0, 363
    bne a0, t0, failed

    li a0, 0
    li a7, 93
    ecall

failed:
    li a0, 1
    li a7, 93
    ecall

# Saves ra, s0, and s1. Uses s0 as a value that middle must preserve.
.globl outer
outer:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)

    li s0, 42
    li s1, 88
    call middle

    # Verify middle preserved s0.
    li t0, 42
    bne s0, t0, outer_corrupt

    # middle returned 321; add s0_initial (42) => 363.
    add a0, a0, s0
    j outer_restore

outer_corrupt:
    li a0, -1

outer_restore:
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

# Saves ra and s0. Calls leaf(value), then returns leaf_result * 3.
.globl middle
middle:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv s0, a0
    call leaf

    # Repeated addition: 107 + 107 + 107 = 321.
    mv t0, a0
    add a0, t0, t0
    add a0, a0, t0

    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

# Leaf function: no calls and no callee-saved registers modified.
.globl leaf
leaf:
    addi a0, a0, 100
    ret
