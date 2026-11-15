#!/bin/bash
set -u
if command -v qemu-riscv64-static >/dev/null 2>&1; then
    QEMU=qemu-riscv64-static
else
    QEMU=qemu-riscv64
fi
for program in hello_riscv system_info debug_example performance_test advanced_debug; do
    echo
    echo "=== $program ==="
    if [ -x "$program" ]; then
        timeout 30s "$QEMU" "./$program"
        echo "Exit code: $?"
    else
        echo "Program not found: $program"
    fi
done
