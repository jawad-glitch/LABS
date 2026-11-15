#!/bin/bash
set -u

echo "=== RISC-V Lab 1 Verification ==="
cd "$HOME/risc-v-lab1" || exit 1

required_files=(
  risc-v-notes.txt
  architecture_comparison.txt
  hello_risc.c
  hello_risc.s
  hello_risc
  embedded_example.c
  embedded_example
  hpc_example.c
  hpc_example
  simple_risc.s
  simple_risc.o
  simple_risc
  analyze_assembly.sh
  risc_v_modularity.py
  risc_v_extensions.txt
  embedded_use_cases.txt
  hpc_use_cases.txt
  industry_adoption.txt
  market_analysis.sh
  lab_summary.txt
)

FAILED=0

echo
echo "Checking required files:"
for f in "${required_files[@]}"; do
  if [ -s "$f" ]; then
    echo "PASS: $f"
  else
    echo "FAIL: $f missing or empty"
    FAILED=1
  fi
done

echo
echo "Checking RISC-V ELF architecture:"
for f in hello_risc embedded_example hpc_example simple_risc; do
  if riscv64-linux-gnu-readelf -h "$f" 2>/dev/null |
       grep -q 'RISC-V'; then
    echo "PASS: $f is a RISC-V ELF binary"
  else
    echo "FAIL: $f is not recognized as RISC-V"
    FAILED=1
  fi
done

echo
echo "Checking modularity demonstration:"
python3 risc_v_modularity.py >/tmp/riscv-modularity.out
if grep -q 'High-Performance Computing example' /tmp/riscv-modularity.out; then
  echo "PASS: Python modularity demonstration"
else
  echo "FAIL: Python modularity demonstration"
  FAILED=1
fi

echo
echo "Checking emulated execution:"
if command -v qemu-riscv64-static >/dev/null 2>&1; then
  QEMU=$(command -v qemu-riscv64-static)
else
  QEMU=$(command -v qemu-riscv64 || true)
fi

if [ -n "$QEMU" ]; then
  "$QEMU" ./hello_risc >/tmp/riscv-hello.out &&
    grep -q 'Hello, RISC-V World!' /tmp/riscv-hello.out &&
    echo "PASS: Hello World" || FAILED=1

  "$QEMU" ./embedded_example >/tmp/riscv-embedded.out &&
    grep -q 'Embedded simulation complete' /tmp/riscv-embedded.out &&
    echo "PASS: Embedded simulation" || FAILED=1

  "$QEMU" ./hpc_example >/tmp/riscv-hpc.out &&
    grep -q 'HPC simulation complete' /tmp/riscv-hpc.out &&
    echo "PASS: HPC simulation" || FAILED=1

  "$QEMU" ./simple_risc &&
    echo "PASS: Standalone assembly program" || FAILED=1
else
  echo "FAIL: QEMU not found"
  FAILED=1
fi

rm -f /tmp/riscv-modularity.out /tmp/riscv-hello.out \
  /tmp/riscv-embedded.out /tmp/riscv-hpc.out

echo
if [ "$FAILED" -eq 0 ]; then
  echo "RESULT: ALL LAB CHECKS PASSED"
else
  echo "RESULT: ONE OR MORE CHECKS FAILED"
fi

exit "$FAILED"
