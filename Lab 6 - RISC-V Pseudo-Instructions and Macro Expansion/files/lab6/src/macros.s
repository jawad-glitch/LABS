.section .text

.macro SWAP reg1, reg2, scratch
    mv \scratch, \reg1
    mv \reg1, \reg2
    mv \reg2, \scratch
.endm

.macro ABS dst, src, scratch
    srai \scratch, \src, 63
    xor \dst, \src, \scratch
    sub \dst, \dst, \scratch
.endm

.macro MAX dst, a, b
    blt \a, \b, .Lmax_b\@
    mv \dst, \a
    j .Lmax_done\@
.Lmax_b\@:
    mv \dst, \b
.Lmax_done\@:
.endm

# CLAMP reserves t5 and t6 as internal scratch registers.
# It computes max(val, lo), then min(result, hi).
# min(x, hi) = -max(-x, -hi).
.macro CLAMP dst, val, lo, hi
    MAX \dst, \val, \lo
    neg t5, \dst
    neg t6, \hi
    MAX t5, t5, t6
    neg \dst, t5
.endm

.globl _start
_start:
    # SWAP invocation 1
    li s0, 11
    li s1, 22
    SWAP s0, s1, t0
    li t1, 22
    bne s0, t1, fail
    li t1, 11
    bne s1, t1, fail

    # SWAP invocation 2
    li s2, 33
    li s3, 44
    SWAP s2, s3, t0
    li t1, 44
    bne s2, t1, fail
    li t1, 33
    bne s3, t1, fail

    # ABS invocation 1: negative
    li s4, -123
    ABS s5, s4, t0
    li t1, 123
    bne s5, t1, fail

    # ABS invocation 2: positive
    li s6, 77
    ABS s7, s6, t0
    li t1, 77
    bne s7, t1, fail

    # MAX invocation 1: second argument wins
    li s8, 4
    li s9, 9
    MAX s10, s8, s9
    li t1, 9
    bne s10, t1, fail

    # MAX invocation 2: first argument wins
    li s8, 15
    li s9, 6
    MAX s10, s8, s9
    li t1, 15
    bne s10, t1, fail

    # CLAMP invocation 1: above upper bound
    li s0, 150
    li s1, 0
    li s2, 100
    CLAMP s3, s0, s1, s2
    li t1, 100
    bne s3, t1, fail

    # CLAMP invocation 2: below lower bound
    li s0, -5
    CLAMP s3, s0, s1, s2
    li t1, 0
    bne s3, t1, fail

success:
    li a0, 0
    li a7, 93
    ecall

fail:
    li a0, 1
    li a7, 93
    ecall
