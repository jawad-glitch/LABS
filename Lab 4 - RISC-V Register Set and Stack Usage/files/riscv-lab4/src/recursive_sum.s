# Lab 4 - Recursive sum with 16-byte stack frames
# recursive_sum(10) = 55. Every frame saves a0 at 0(sp), ra at 8(sp).
# The base-case frame records the deepest stack pointer.

.section .text
.globl _start
.option norelax

_start:
    la t0, initial_sp
    sd sp, 0(t0)

    li a0, 10
    call recursive_sum

    # Compute initial_sp - deepest_sp and retain it in s1.
    la t0, initial_sp
    ld t1, 0(t0)
    la t2, deepest_sp
    ld t3, 0(t2)
    sub s1, t1, t3
    li t4, 176
    bne s1, t4, failed

    la t0, measured_stack_bytes
    sd s1, 0(t0)

    # The expected sum is 55; use it as the process exit status.
    li t0, 55
    bne a0, t0, failed

    li a7, 93
    ecall

failed:
    li a0, 1
    li a7, 93
    ecall

.globl recursive_sum
recursive_sum:
    # Exactly 16 bytes per frame.
    addi sp, sp, -16
    sd a0, 0(sp)
    sd ra, 8(sp)

    beqz a0, recursive_base

    # Genuine recursion: sum(N) = N + sum(N-1).
    addi a0, a0, -1
    call recursive_sum

    # Restore N and add it to the recursive result.
    ld t0, 0(sp)
    add a0, a0, t0
    j recursive_restore

recursive_base:
    # This is the deepest frame (N=0).
    la t0, deepest_sp
    sd sp, 0(t0)
    li a0, 0

recursive_restore:
    ld ra, 8(sp)
    addi sp, sp, 16
    ret

.section .bss
.align 3
initial_sp:
    .zero 8
deepest_sp:
    .zero 8
measured_stack_bytes:
    .zero 8
