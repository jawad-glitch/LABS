#!/usr/bin/env bash
cd "$HOME/lab8" || exit 1
mkdir -p output

failed=0
: > output/report.txt

echo "RISC-V Lab 8 - Floating-Point Operations" >> output/report.txt
echo "=========================================" >> output/report.txt
echo "Execution environment: QEMU RISC-V user-mode" >> output/report.txt
echo >> output/report.txt

echo "Running floating-point driver..."
if qemu-riscv64 bin/fp_driver > output/driver_results.txt 2>&1; then
    echo "fp_driver: PASS" >> output/report.txt
else
    echo "fp_driver: FAIL" >> output/report.txt
    failed=1
fi

echo "Running precision stress tests..."
if qemu-riscv64 bin/fp_precision > output/precision_results.txt 2>&1; then
    echo "fp_precision: PASS" >> output/report.txt
else
    echo "fp_precision: FAIL" >> output/report.txt
    failed=1
fi

echo "Running special-value tests..."
if qemu-riscv64 bin/fp_special > output/special_results.txt 2>&1; then
    echo "fp_special: PASS" >> output/report.txt
else
    echo "fp_special: FAIL" >> output/report.txt
    failed=1
fi

{
    echo
    echo "=== Driver results ==="
    cat output/driver_results.txt

    echo
    echo "=== Precision deviations and results ==="
    grep -E 'Scenario|deviation from 100|relative_error|absorbed' \
        output/precision_results.txt || true

    echo
    echo "=== Special-value classifications ==="
    cat output/special_results.txt

    echo
    echo "Overall status: $([ "$failed" -eq 0 ] && echo PASS || echo FAIL)"
} >> output/report.txt

test -s output/report.txt || failed=1
cat output/report.txt
exit "$failed"
