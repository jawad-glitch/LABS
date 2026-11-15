.section .text.start,"ax"
.globl _start
_start:
    lui t0, 0x10000
    addi t1, zero, 0x55
    sw t1, 0(t0)
1:
    lw t2, 4(t0)
    andi t2, t2, 1
    beq t2, zero, 1b
    lui t0, 0x20000
    addi t1, zero, 0xa5
    sw t1, 0(t0)
2:
    lw t2, 4(t0)
    andi t2, t2, 2
    beq t2, zero, 2b
    lw t2, 0(t0)
    andi t2, t2, 255
    lui t0, 0x10
    sw t2, 0(t0)
3:
    jal zero, 3b
