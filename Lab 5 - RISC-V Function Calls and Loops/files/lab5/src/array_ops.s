.section .text
.globl _start
.globl array_sum
.globl find_max
.option norelax

_start:
    la a0, test_array
    la t0, array_size
    lw a1, 0(t0)
    call array_sum

    la t0, sum_result
    sd a0, 0(t0)

    la a0, test_array
    la t0, array_size
    lw a1, 0(t0)
    call find_max

    la t0, max_result
    sd a0, 0(t0)

    # Exit with array_sum result modulo 256.
    la t0, sum_result
    ld a0, 0(t0)
    andi a0, a0, 255
    li a7, 93
    ecall

# array_sum
# a0 = array address, a1 = element count
# Returns signed 64-bit accumulation in a0.
array_sum:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0
    mv s1, a1
    li s2, 0

array_sum_loop:
    beqz s1, array_sum_done
    lw t0, 0(s0)
    add s2, s2, t0
    addi s0, s0, 4
    addi s1, s1, -1
    j array_sum_loop

array_sum_done:
    mv a0, s2
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

# find_max
# a0 = array address, a1 = element count (>= 1)
# Returns largest signed 32-bit element, sign-extended in a0.
find_max:
    addi sp, sp, -32
    sd ra, 24(sp)
    sd s0, 16(sp)
    sd s1, 8(sp)
    sd s2, 0(sp)

    mv s0, a0
    mv s1, a1

    lw s2, 0(s0)
    addi s0, s0, 4
    addi s1, s1, -1

find_max_loop:
    beqz s1, find_max_done
    lw t0, 0(s0)
    bge s2, t0, find_max_skip
    mv s2, t0

find_max_skip:
    addi s0, s0, 4
    addi s1, s1, -1
    j find_max_loop

find_max_done:
    mv a0, s2
    ld s2, 0(sp)
    ld s1, 8(sp)
    ld s0, 16(sp)
    ld ra, 24(sp)
    addi sp, sp, 32
    ret

.section .data
.align 2
.globl test_array
test_array:
    .word 10, 20, 30, 40, 50

array_size:
    .word 5

.align 3
sum_result:
    .zero 8
max_result:
    .zero 8
