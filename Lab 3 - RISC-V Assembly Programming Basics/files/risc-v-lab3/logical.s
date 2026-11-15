.option norelax
.section .text
.globl _start

_start:
    li x1, 0xf0
    li x2, 0xaa

    and x3, x1, x2
    or  x4, x1, x2
    xor x5, x1, x2
    not x6, x1

    slli x7, x1, 2
    srli x8, x1, 2

    la x9, and_result
    sw x3, 0(x9)

    la x9, or_result
    sw x4, 0(x9)

    la x9, xor_result
    sw x5, 0(x9)

    la x9, not_result
    sw x6, 0(x9)

    la x9, sll_result
    sw x7, 0(x9)

    la x9, srl_result
    sw x8, 0(x9)

    li x10, 160
    bne x3, x10, failed

    li x10, 250
    bne x4, x10, failed

    li x10, 90
    bne x5, x10, failed

    li x10, -241
    bne x6, x10, failed

    li x10, 960
    bne x7, x10, failed

    li x10, 60
    bne x8, x10, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

.section .data
.align 2
and_result: .word 0
or_result:  .word 0
xor_result: .word 0
not_result: .word 0
sll_result: .word 0
srl_result: .word 0
