#!/bin/bash
ROOT=$(cd "$(dirname "$0")" && pwd)
cd "$ROOT" || exit 1
FAIL=0

for BIN in src/dot_product_baseline src/row_sum_baseline; do
    if [ ! -x "$BIN" ]; then
        echo "FAIL: $BIN is missing or not executable"
        FAIL=1
        continue
    fi
    qemu-riscv64-static "$BIN"
    STATUS=$?
    if [ "$STATUS" -eq 0 ]; then
        echo "PASS: $BIN exited with code 0"
    else
        echo "FAIL: $BIN exited with code $STATUS"
        FAIL=1
    fi
done

exit "$FAIL"
