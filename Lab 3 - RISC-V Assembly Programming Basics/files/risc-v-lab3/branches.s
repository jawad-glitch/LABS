.option norelax
.section .text
.globl _start

_start:
    li x1, 10
    li x2, 5
    li x3, 0

    blt x2, x1, greater_than
    beq x1, x2, equal

    li x3, 1
    j end_comparison

greater_than:
    li x3, 2
    j end_comparison

equal:
    li x3, 3

end_comparison:
    la x4, comparison_result
    sw x3, 0(x4)

    li x5, 0
    li x6, 5

loop_start:
    beq x5, x6, loop_end
    addi x5, x5, 1
    j loop_start

loop_end:
    la x7, loop_counter
    sw x5, 0(x7)

    lw x8, 0(x4)
    li x9, 2
    bne x8, x9, failed

    lw x8, 0(x7)
    li x9, 5
    bne x8, x9, failed

    li a0, 0
    j exit

failed:
    li a0, 1

exit:
    li a7, 93
    ecall

.section .data
.align 2
comparison_result: .word 0
loop_counter: .word 0
