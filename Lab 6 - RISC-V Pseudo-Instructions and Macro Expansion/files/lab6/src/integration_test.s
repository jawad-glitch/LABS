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
    blt \a, \b, .Lint_max_b\@
    mv \dst, \a
    j .Lint_max_done\@
.Lint_max_b\@:
    mv \dst, \b
.Lint_max_done\@:
.endm

# t5 and t6 are reserved internal scratch registers.
.macro CLAMP dst, val, lo, hi
    MAX \dst, \val, \lo
    neg t5, \dst
    neg t6, \hi
    MAX t5, t5, t6
    neg \dst, t5
.endm

.globl _start
_start:
    # Test 1: ABS(-37) == 37
    li s0, -37
    ABS s1, s0, t0
    li t1, 37
    bne s1, t1, fail

    # Test 2: SWAP(100, 200)
    li s2, 100
    li s3, 200
    SWAP s2, s3, t0
    li t1, 200
    bne s2, t1, fail
    li t1, 100
    bne s3, t1, fail

    # Test 3: MAX(42, 99) == 99
    li s4, 42
    li s5, 99
    MAX s6, s4, s5
    li t1, 99
    bne s6, t1, fail

    # Test 4: CLAMP(150, 0, 100) == 100
    li s7, 150
    li s8, 0
    li s9, 100
    CLAMP s10, s7, s8, s9
    li t1, 100
    bne s10, t1, fail

    # Test 5: CLAMP(-5, 0, 100) == 0
    li s7, -5
    CLAMP s10, s7, s8, s9
    li t1, 0
    bne s10, t1, fail

    # Additional check: in-range value remains unchanged
    li s7, 55
    CLAMP s10, s7, s8, s9
    li t1, 55
    bne s10, t1, fail

success:
    li a0, 0
    li a7, 93
    ecall

fail:
    li a0, 1
    li a7, 93
    ecall
