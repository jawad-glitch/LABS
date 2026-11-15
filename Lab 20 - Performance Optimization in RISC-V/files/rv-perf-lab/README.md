# Lab 20 — RISC-V Performance Optimization

This lab compares baseline and four-way unrolled RISC-V assembly programs.

## Programs
- Dot product: 64 signed 32-bit elements.
- Row sums: 8x8 row-major matrix.
- Optimizations: four-way loop unrolling, four accumulators, pointer/address hoisting.

## Build
Run the lab implementation block in the Ubuntu terminal.

## Important measurement distinction
`objdump -d` counts static instructions present in the binary. It does not count dynamic executions. Unrolling can reduce loop branch executions while the static branch count remains one. It may increase static load and multiply instruction counts because the unrolled body contains four operations.

QEMU user-mode wall-clock time is not a cycle-accurate CPU performance measurement. Results are affected by host scheduling and timer resolution. No hardware pipeline, cache, or cycle counter is being simulated here.
