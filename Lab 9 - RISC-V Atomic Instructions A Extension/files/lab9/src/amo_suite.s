.section .text
.align 2
.globl _start

_start:
    la t0, amo_target
    la t1, amo_results

    li t2, 51
    amoswap.w.aqrl t3, t2, (t0)
    sw t3, 0(t1)

    li t2, 7
    amoadd.w.aqrl t3, t2, (t0)
    sw t3, 4(t1)

    li t2, 60
    amoand.w.aqrl t3, t2, (t0)
    sw t3, 8(t1)

    li t2, 128
    amoor.w.aqrl t3, t2, (t0)
    sw t3, 12(t1)

    li t2, 85
    amoxor.w.aqrl t3, t2, (t0)
    sw t3, 16(t1)

    # Verify expected pre-operation values.
    li t4, 90
    lw t5, 0(t1)
    bne t4, t5, fail
    li t4, 51
    lw t5, 4(t1)
    bne t4, t5, fail
    li t4, 58
    lw t5, 8(t1)
    bne t4, t5, fail
    li t4, 56
    lw t5, 12(t1)
    bne t4, t5, fail
    li t4, 184
    lw t5, 16(t1)
    bne t4, t5, fail

    li a7, 93
    li a0, 0
    ecall

fail:
    li a7, 93
    li a0, 1
    ecall

.section .data
.align 2
amo_target:
    .word 90
amo_results:
    .space 20
