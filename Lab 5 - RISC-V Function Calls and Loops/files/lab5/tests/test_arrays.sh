#!/bin/bash

set -u
cd "$(dirname "$0")/.." || exit 1

failed=0

run_case() {
    array_id="$1"
    mode="$2"
    label="$3"
    expected="$4"
    source="tests/array_${label}.s"
    binary="bin/array_${label}"

    sed -e "s/ARRAY_ID_VALUE/$array_id/" \
        -e "s/TEST_MODE_VALUE/$mode/" \
        src/array_multi_test.s > "$source"

    if ! riscv64-linux-gnu-gcc -static -nostartfiles \
        -march=rv64im -mabi=lp64 \
        -Wl,-e,_start -Wl,--no-relax \
        -o "$binary" "$source"; then
        echo "FAIL: $label compilation failed"
        failed=1
        return
    fi

    qemu-riscv64 "$binary"
    actual=$?

    if [ "$actual" -eq "$expected" ]; then
        echo "PASS: $label expected=$expected actual=$actual"
    else
        echo "FAIL: $label expected=$expected actual=$actual"
        failed=1
    fi
}

# TEST_MODE 0 = sum, TEST_MODE 1 = maximum.
run_case 0 0 arr_a_sum 6
run_case 0 1 arr_a_max 3

run_case 1 0 arr_b_sum 50
run_case 1 1 arr_b_max 20

run_case 2 0 arr_c_sum 25
run_case 2 1 arr_c_max 9

if [ "$failed" -eq 0 ]; then
    echo "ALL SIX ARRAY TESTS PASSED"
    exit 0
else
    echo "ARRAY TEST FAILURES DETECTED"
    exit 1
fi
