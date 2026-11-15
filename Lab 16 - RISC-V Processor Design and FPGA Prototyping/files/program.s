# RV32I arithmetic, memory and branch test
addi x1, x0, 15
addi x2, x0, 10
add  x3, x1, x2
sub  x4, x1, x2
and  x5, x1, x2
or   x6, x1, x2
xor  x7, x1, x2
sw   x3, 0(x0)
lw   x8, 0(x0)
beq  x3, x3, 8
addi x10, x0, 99
addi x9, x0, 77
nop
