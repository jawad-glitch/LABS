.section .text
.globl _start
.globl text_marker
text_marker:
_start:
    la t0, byte_data
    lb t1, 0(t0)
    sb t1, 1(t0)

    la t0, half_data
    lh t1, 0(t0)
    sh t1, 2(t0)

    la t0, word_data
    lw t1, 0(t0)
    sw t1, 4(t0)

    la t0, double_data
    ld t1, 0(t0)
    sd t1, 8(t0)

    # Exercise BSS storage.
    la t0, bss_area
    li t1, 123
    sd t1, 0(t0)
    ld t2, 0(t0)
    bne t1, t2, fail

    # Software stack: push three 64-bit values.
    la sp, software_stack_end
    li t0, 0x111
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 0x222
    addi sp, sp, -8
    sd t0, 0(sp)
    li t0, 0x333
    addi sp, sp, -8
    sd t0, 0(sp)

    # Pop in LIFO order and verify the first-pushed value last.
    ld t1, 0(sp)
    addi sp, sp, 8
    li t2, 0x333
    bne t1, t2, fail
    ld t1, 0(sp)
    addi sp, sp, 8
    li t2, 0x222
    bne t1, t2, fail
    ld t1, 0(sp)
    addi sp, sp, 8
    li t2, 0x111
    bne t1, t2, fail

    # Traverse the linked list. Expected payload sum = 60.
    la a0, node1
    jal ra, traverse_list
    li t1, 60
    bne a0, t1, fail

    # Touch the simulated heap region.
    la t0, heap_area
    li t1, 0x55
    sd t1, 0(t0)
    ld t2, 0(t0)
    bne t1, t2, fail

    li a0, 0
    j finish

fail:
    li a0, 1

finish:
    li a7, 93
    ecall

# a0 = first node; returns sum of payload fields in a0.
# Clobbers t0,t1.
traverse_list:
    li t1, 0
list_loop:
    beqz a0, list_done
    ld t0, 8(a0)
    add t1, t1, t0
    ld a0, 0(a0)
    j list_loop
list_done:
    mv a0, t1
    ret

.section .data
.balign 8
byte_data:
    .byte 0x7f
    .space 7
half_data:
    .half 0x1234
    .space 6
word_data:
    .word 0x12345678
    .space 4
.balign 8
double_data:
    .dword 0x1122334455667788

.balign 8
node3:
    .dword 0
    .dword 30
node2:
    .dword node3
    .dword 20
node1:
    .dword node2
    .dword 10

.section .bss
.balign 8
bss_area:
    .space 64
software_stack:
    .space 128
software_stack_end:

.section .heap,"aw",@nobits
.balign 16
heap_area:
    .space 256

.section .note.GNU-stack,"",@progbits
