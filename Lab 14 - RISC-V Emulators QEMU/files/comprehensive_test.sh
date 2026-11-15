#!/bin/bash
set -u
if command -v qemu-riscv64-static >/dev/null 2>&1; then
    QEMU=qemu-riscv64-static
else
    QEMU=qemu-riscv64
fi
FAILED=0
for program in hello_riscv system_info debug_example performance_test advanced_debug; do
    if timeout 30s "$QEMU" "./$program" >/dev/null 2>&1; then
        echo "[PASS] $program"
    else
        echo "[FAIL] $program"
        FAILED=1
    fi
done
exit "$FAILED"
