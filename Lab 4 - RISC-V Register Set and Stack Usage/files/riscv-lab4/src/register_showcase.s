# Lab 4 - Register showcase
# Audit notes:
# 1. The call add_and_scale pseudo-instruction expands to AUIPC ra,... and
#    JALR ra,... (or an equivalent linker-relaxed sequence if relaxation is enabled).
#    This build disables linker relaxation.
# 2. LI may expand into LUI plus ADDI when a constant cannot fit in a
#    12-bit signed immediate. This is needed to construct larger constants.
# x0 is hardwired to zero and cannot contain a non-zero value.

.section .text
.globl _start
.option norelax

_start:
    # Exercise temporary registers x5-x7 and x28-x31.
    li t0, 15
    li t1, 16
    li t2, 17
    li t3, 28
    li t4, 29
    li t5, 30
    li t6, 31

    # Exercise all callee-saved registers x8-x9 and x18-x27.
    li s0, 100
    li s1, 101
    li s2, 102
    li s3, 103
    li s4, 104
    li s5, 105
    li s6, 106
    li s7, 107
    li s8, 108
    li s9, 109
    li s10, 110
    li s11, 0x12345678

    # Exercise argument registers x10-x17.
    li a0, 10
    li a1, 11
    li a2, 12
    li a3, 13
    li a4, 14
    li a5, 15
    li a6, 16
    li a7, 17

    # Verify that writes to x0 are discarded and reads remain zero.
    li t0, 9
    addi zero, t0, 1
    addi t1, zero, 0
    bnez t1, failed

    # Call with a=10 and b=20. Expected (10+20)*4 = 120.
    li a0, 10
    li a1, 20
    call add_and_scale
    li t2, 120
    bne a0, t2, failed

    # Success: Linux RV64 sys_exit(0).
    li a0, 0
    li a7, 93
    ecall

failed:
    li a0, 1
    li a7, 93
    ecall

# a0 = a, a1 = b; return (a+b)*4.
# Uses only add and shift; does not modify s0-s11.
.globl add_and_scale
add_and_scale:
    add a0, a0, a1
    slli a0, a0, 2
    ret
