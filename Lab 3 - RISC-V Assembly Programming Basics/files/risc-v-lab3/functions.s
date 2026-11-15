.option norelax
.section .text
.globl _start

_start:
    li a0, 8
    li a1, 3
    jal ra, add_function

    la x1, add_result
    sw a0, 0(x1)

    li a0, 5
    jal ra, factorial

    la x1, fact_result
    sw a0, 0(x1)

    lw x2, 0(x1)
    li x3, 120
    bne x2, x3, failed

    la x1, add_result
    lw x2, 0(x1)
    li x3, 11
    bne x2, x3, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

add_function:
    add a0, a0, a1
    jr ra

factorial:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd a0, 0(sp)

    li x1, 1
    ble a0, x1, fact_base_case

    addi a0, a0, -1
    jal ra, factorial

    ld x1, 0(sp)
    mul a0, a0, x1
    j fact_return

fact_base_case:
    li a0, 1

fact_return:
    ld ra, 8(sp)
    addi sp, sp, 16
    jr ra

.section .data
.align 2
add_result: .word 0
fact_result: .word 0
