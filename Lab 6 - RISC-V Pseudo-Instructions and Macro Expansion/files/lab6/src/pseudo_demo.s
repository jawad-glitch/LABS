.section .text
.globl _start
_start:
    # li: small positive immediate
    li t0, 42
    li t1, 42
    bne t0, t1, fail

    # li: 32-bit value requiring LUI plus ADDI
    li t2, 0x12345
    li t3, 0x12345
    bne t2, t3, fail

    # li: zero
    li t4, 0
    bne t4, zero, fail

    # li: negative value outside the signed 12-bit range
    li t5, -4097
    li t6, -4097
    bne t5, t6, fail

    # mv must copy the source value
    li a0, 987
    mv a1, a0
    bne a0, a1, fail

    # not and neg on the same source
    li a2, 0x55
    not a3, a2
    neg a4, a2
    not a5, a3
    bne a2, a5, fail

    # Verify the complement and negation results
    li a6, -86
    bne a3, a6, fail
    li a7, -85
    bne a4, a7, fail

    # nop
    nop

    # j skips this failure instruction
    j after_skip
    li s0, 1
    j fail

after_skip:
    li s0, 0
    bne s0, zero, fail

success:
    li a0, 0
    li a7, 93
    ecall

fail:
    li a0, 1
    li a7, 93
    ecall
