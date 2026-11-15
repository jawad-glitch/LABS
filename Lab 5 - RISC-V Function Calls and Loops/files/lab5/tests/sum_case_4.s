.section .text
.globl _start
.globl calculate_sum
.option norelax

_start:
    li a0, 4
    call calculate_sum

    # Return the sum as the Linux process exit code.
    li a7, 93
    ecall

# calculate_sum
# Input: a0 = N
# Output: a0 = 1 + 2 + ... + N, or 0 when N < 1
# Clobbers: t0, t1, t2
# Preserves: ra, sp, s0-s11
calculate_sum:
    addi sp, sp, -16
    sd ra, 8(sp)
    sd s0, 0(sp)

    mv t0, a0          # t0 = remaining counter
    li s0, 0            # s0 = running sum

    blez t0, sum_done

sum_loop:
    add s0, s0, t0
    addi t0, t0, -1
    bgtz t0, sum_loop

sum_done:
    mv a0, s0
    ld s0, 0(sp)
    ld ra, 8(sp)
    addi sp, sp, 16
    ret
