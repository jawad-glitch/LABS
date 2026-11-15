.option norelax
.section .text
.globl _start

_start:
    la x1, numbers
    li x2, 5
    li x3, 0
    li x4, 0

sum_loop:
    beq x4, x2, end_sum

    slli x5, x4, 2
    add x6, x1, x5
    lw x7, 0(x6)
    add x3, x3, x7

    addi x4, x4, 1
    j sum_loop

end_sum:
    la x8, final_sum
    sw x3, 0(x8)

    la x1, numbers
    lw x9, 0(x1)
    li x4, 1

max_loop:
    beq x4, x2, end_max

    slli x5, x4, 2
    add x6, x1, x5
    lw x7, 0(x6)

    blt x9, x7, update_max
    j skip_update

update_max:
    mv x9, x7

skip_update:
    addi x4, x4, 1
    j max_loop

end_max:
    la x8, max_value
    sw x9, 0(x8)

    lw x10, 0(x8)
    li x11, 89
    bne x10, x11, failed

    la x8, final_sum
    lw x10, 0(x8)
    li x11, 207
    bne x10, x11, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

.section .data
.align 2
numbers: .word 42, 17, 89, 3, 56
final_sum: .word 0
max_value: .word 0
