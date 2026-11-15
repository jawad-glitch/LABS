.option norelax
.section .text
.globl _start

_start:
    li x1, 100
    li x2, 25

    add x3, x1, x2
    sub x4, x1, x2
    mul x5, x1, x2

    li x6, 0xff
    li x7, 0x0f

    and x8, x6, x7
    or x9, x6, x7
    xor x10, x6, x7

    li x11, 50
    blt x11, x1, test3_true

    li x12, 0
    j test3_end

test3_true:
    li x12, 1

test3_end:
    li a0, 10
    jal ra, square_function
    mv x13, a0

    la x14, test_data
    sw x3, 0(x14)
    sw x8, 4(x14)
    sw x12, 8(x14)
    sw x13, 12(x14)

    lw x15, 0(x14)
    lw x16, 4(x14)
    lw x17, 8(x14)
    lw x18, 12(x14)

    li x19, 125
    bne x15, x19, failed

    li x19, 15
    bne x16, x19, failed

    li x19, 1
    bne x17, x19, failed

    li x19, 100
    bne x18, x19, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

square_function:
    mul a0, a0, a0
    jr ra

.section .data
.align 2
test_data: .word 0, 0, 0, 0
