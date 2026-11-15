.option norvc
.section .text.init
.globl _start
_start:
    la sp, _stack_top

    la t0, trap_handler
    csrw mtvec, t0

    # PMP region 0: 0x80000000-0x80007fff, NAPOT, RX
    li t0, 0x20000fff
    csrw pmpaddr0, t0

    # PMP region 1: 0x80008000-0x8000ffff, NAPOT, RW
    li t0, 0x20002fff
    csrw pmpaddr1, t0

    # PMP region 2: 0x10000000-0x10000fff, NAPOT, RW
    li t0, 0x040001ff
    csrw pmpaddr2, t0

    # Entry 0 = NAPOT RX; entries 1 and 2 = NAPOT RW
    li t0, 0x001b1b1d
    csrw pmpcfg0, t0

    # Enter user mode at user_entry
    la t0, user_entry
    csrw mepc, t0
    li t0, 0x1800
    csrc mstatus, t0
    mret

.section .text.trap
.align 4
.globl trap_handler
trap_handler:
    # Reserve 256 bytes. Save t0 before using it to calculate old SP.
    addi sp, sp, -256
    sd zero,   0(sp)
    sd ra,     8(sp)
    addi t0, sp, 256
    sd t0,    16(sp)
    sd gp,    24(sp)
    sd tp,    32(sp)
    # Original t0 was saved before the frame was allocated below.
