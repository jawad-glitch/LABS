.section .text
.globl _start
_start:
    la sp, _stack_top

    # Install M-mode trap handler.
    la t0, trap_handler
    csrw mtvec, t0

    # PMP: code RX, data/stack RW, UART RW.
    li t0, 0x80001fff
    csrw pmpaddr0, t0
    li t0, 0x80009fff
    csrw pmpaddr1, t0
    li t0, 0x04003fff
    csrw pmpaddr2, t0
    csrw pmpaddr3, zero
    li t0, 0x001b1b1d
    csrw pmpcfg0, t0

    # Set mepc to U-mode entry and clear MPP to User.
    la t0, user_entry
    csrw mepc, t0
    li t0, 0x1800
    csrc mstatus, t0

    # Enable global M-mode interrupt bit (no interrupt sources enabled).
    csrsi mstatus, 8
    mret

/*
 * Trap handler saves all 32 integer registers in a 256-byte frame
 * before reading mcause. The original SP is saved in slot x2.
 */
.align 4
.globl trap_handler
trap_handler:
    addi sp, sp, -256

    sd zero,   0(sp)
    sd ra,     8(sp)
    addi t0, sp, 256
    sd t0,    16(sp)
    sd gp,    24(sp)
    sd tp,    32(sp)
    sd t0,    40(sp)
    sd t1,    48(sp)
    sd t2,    56(sp)
    sd s0,    64(sp)
    sd s1,    72(sp)
    sd a0,    80(sp)
    sd a1,    88(sp)
    sd a2,    96(sp)
    sd a3,   104(sp)
    sd a4,   112(sp)
    sd a5,   120(sp)
    sd a6,   128(sp)
    sd a7,   136(sp)
    sd s2,   144(sp)
    sd s3,   152(sp)
    sd s4,   160(sp)
    sd s5,   168(sp)
    sd s6,   176(sp)
    sd s7,   184(sp)
    sd s8,   192(sp)
    sd s9,   200(sp)
    sd s10,  208(sp)
    sd s11,  216(sp)
    sd t3,   224(sp)
    sd t4,   232(sp)
    sd t5,   240(sp)
    sd t6,   248(sp)

    csrr t0, mcause
    li t1, 8
    bne t0, t1, trap_halt

    # Skip the 32-bit ecall instruction.
    csrr t0, mepc
    addi t0, t0, 4
    csrw mepc, t0

    # Trap acknowledgement byte: T
    li t1, 0x10000000
    li t2, 84
    sb t2, 0(t1)

    # Restore all registers.
    ld ra,     8(sp)
    ld gp,    24(sp)
    ld tp,    32(sp)
    ld t0,    40(sp)
    ld t1,    48(sp)
    ld t2,    56(sp)
    ld s0,    64(sp)
    ld s1,    72(sp)
    ld a0,    80(sp)
    ld a1,    88(sp)
    ld a2,    96(sp)
    ld a3,   104(sp)
    ld a4,   112(sp)
    ld a5,   120(sp)
    ld a6,   128(sp)
    ld a7,   136(sp)
    ld s2,   144(sp)
    ld s3,   152(sp)
    ld s4,   160(sp)
    ld s5,   168(sp)
    ld s6,   176(sp)
    ld s7,   184(sp)
    ld s8,   192(sp)
    ld s9,   200(sp)
    ld s10,  208(sp)
    ld s11,  216(sp)
    ld t3,   224(sp)
    ld t4,   232(sp)
    ld t5,   240(sp)
    ld t6,   248(sp)
    ld sp,    16(sp)
    mret

trap_halt:
    j trap_halt

.align 4
.globl user_entry
user_entry:
    ecall

    # User mode resumed after M-mode trap. Emit byte U.
    li t0, 0x10000000
    li t1, 85
    sb t1, 0(t0)

user_halt:
    j user_halt
