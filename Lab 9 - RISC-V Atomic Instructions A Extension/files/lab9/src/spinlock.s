.section .text
.align 2
.globl _start
.globl acquire_lock
.globl release_lock

_start:
    la a0, lock_word
    jal ra, acquire_lock

    la t0, shared_counter
    lw t1, 0(t0)
    addi t1, t1, 1
    sw t1, 0(t0)

    la a0, lock_word
    jal ra, release_lock

    li a7, 93
    li a0, 0
    ecall

acquire_lock:
    li t1, 1
1:
    amoswap.w.aq t0, t1, (a0)
    bnez t0, 1b
    ret

release_lock:
    amoswap.w.rl zero, zero, (a0)
    ret

.section .data
.align 2
lock_word:
    .word 0
shared_counter:
    .word 0
