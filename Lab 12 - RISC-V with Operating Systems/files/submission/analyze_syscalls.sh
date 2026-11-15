#!/bin/bash
echo "=== RISC-V System Call Analysis ==="
for PROGRAM in hello_syscall syscall_test file_syscall memory_syscalls performance_test; do
    echo
    echo "Program: $PROGRAM"
    riscv64-linux-gnu-objdump -d "$PROGRAM" | grep -B 4 -A 2 'ecall'
done
echo
echo "=== Analysis completed ==="
