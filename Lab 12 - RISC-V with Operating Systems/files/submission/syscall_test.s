.section .data
msg1:
    .ascii "Testing RISC-V Linux system calls...\n"
.set len1, .-msg1

msg2:
    .ascii "Process ID: "
.set len2, .-msg2

msg3:
    .ascii "Unix time: "
.set len3, .-msg3

newline:
    .ascii "\n"

.section .bss
.align 3
timebuf:
    .space 16

.section .text
.global _start

_start:
    li a7, 64
    li a0, 1
    la a1, msg1
    li a2, len1
    ecall

    li a7, 172
    ecall
    mv s0, a0

    li a7, 64
    li a0, 1
    la a1, msg2
    li a2, len2
    ecall

    mv a0, s0
    jal ra, print_number
    jal ra, print_newline

    li a7, 169
    la a0, timebuf
    li a1, 0
    ecall

    bltz a0, fail

    li a7, 64
    li a0, 1
    la a1, msg3
    li a2, len3
    ecall

    la t0, timebuf
    ld a0, 0(t0)
    jal ra, print_number
    jal ra, print_newline

    li a7, 93
    li a0, 0
    ecall

print_newline:
    li a7, 64
    li a0, 1
    la a1, newline
    li a2, 1
    ecall
    ret

print_number:
    addi sp, sp, -48
    sd ra, 40(sp)
    mv t0, a0
    addi t1, sp, 32
    li t2, 0
    li t3, 10

number_loop:
    remu t4, t0, t3
    divu t0, t0, t3
    addi t4, t4, 48
    addi t1, t1, -1
    sb t4, 0(t1)
    addi t2, t2, 1
    bnez t0, number_loop

    li a7, 64
    li a0, 1
    mv a1, t1
    mv a2, t2
    ecall

    ld ra, 40(sp)
    addi sp, sp, 48
    ret

fail:
    li a7, 93
    li a0, 1
    ecall
