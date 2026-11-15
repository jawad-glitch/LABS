#!/bin/bash
set -u

ASM="hello_risc.s"

if [ ! -f "$ASM" ]; then
    echo "Assembly file not found: $ASM"
    exit 1
fi

echo "=== RISC-V Assembly Analysis ==="
echo "File: $ASM"

echo
echo "1. Instruction mnemonics:"
grep -E '^[[:space:]]+[a-z][a-z0-9.]*[[:space:]]' "$ASM" |
    awk '{print $1}' | sort | uniq -c | sort -nr || true

echo
echo "2. Integer register references:"
grep -Eo '\b(x([0-9]|[12][0-9]|3[01])|zero|ra|sp|gp|tp|a[0-7]|s([0-9]|1[01])|t[0-6])\b' "$ASM" |
    sort | uniq -c | sort -nr || true

echo
echo "3. Function calls:"
grep -E 'call|jal|jalr' "$ASM" || true

echo
echo "4. Memory instructions:"
grep -E '^[[:space:]]+(lw|sw|ld|sd|lb|sb|lh|sh|lbu|lhu|lwu)[[:space:]]' "$ASM" || true

echo
echo "Assembly analysis complete."
