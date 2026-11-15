.option norvc

.section .data
.align 2
array:
    .word 1, 2, 3, 4
result:
    .word 0

.section .text
.globl _start
.type _start, @function

_start:
    # U-type: load address of result
    lui   t4, %hi(result)
    addi  t4, t4, %lo(result)

    # U-type: load address of array
    lui   t0, %hi(array)
    addi  t0, t0, %lo(array)

    # I-type: loop count and accumulator
    addi  t1, zero, 4
    addi  t2, zero, 0

sum_loop:
    # I-type load
    lw    t3, 0(t0)

    # R-type addition
    add   t2, t2, t3

    # I-type pointer and counter updates
    addi  t0, t0, 4
    addi  t1, t1, -1

    # B-type conditional branch
    bne   t1, zero, sum_loop

    # Prepare function argument
    addi  a0, t2, 0

    # J-type function call
    jal   ra, double_store

    # Verify that the result is 20
    lw    t5, 0(t4)
    addi  t6, zero, 20
    bne   t5, t6, failed

success:
    addi  a0, zero, 0
    addi  a7, zero, 93
    ecall

failed:
    addi  a0, zero, 1
    addi  a7, zero, 93
    ecall

# Leaf function: double a0, store it, and return
double_store:
    # I-type arithmetic
    slli  a0, a0, 1

    # S-type store
    sw    a0, 0(t4)

    # I-type JALR return
    jalr  zero, 0(ra)

.size _start, .-_start
