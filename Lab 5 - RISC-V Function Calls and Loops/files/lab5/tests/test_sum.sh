#!/bin/bash

set -u
cd "$(dirname "$0")/.." || exit 1

failed=0

for n in $(seq 1 22); do
    expected=$((n * (n + 1) / 2))

    # Change only the test input in a temporary source copy.
    sed "s/    li a0, 10/    li a0, $n/" \
        src/sum_function.s > "tests/sum_case_${n}.s"

    if ! riscv64-linux-gnu-gcc -static -nostartfiles \
        -march=rv64im -mabi=lp64 \
        -Wl,-e,_start -Wl,--no-relax \
        -o "bin/sum_case_${n}" "tests/sum_case_${n}.s"; then
        echo "FAIL: N=$n compilation failed"
        failed=1
        continue
    fi

    qemu-riscv64 "bin/sum_case_${n}"
    actual=$?

    if [ "$actual" -eq "$expected" ]; then
        echo "PASS: N=$n sum=$expected exit=$actual"
    else
        echo "FAIL: N=$n expected=$expected actual=$actual"
        failed=1
    fi
done

# Also test the required N < 1 behaviour.
sed 's/    li a0, 10/    li a0, 0/' \
    src/sum_function.s > tests/sum_case_zero.s

if riscv64-linux-gnu-gcc -static -nostartfiles \
    -march=rv64im -mabi=lp64 \
    -Wl,-e,_start -Wl,--no-relax \
    -o bin/sum_case_zero tests/sum_case_zero.s; then
    qemu-riscv64 bin/sum_case_zero
    actual=$?
    if [ "$actual" -eq 0 ]; then
        echo "PASS: N=0 sum=0 exit=0"
    else
        echo "FAIL: N=0 expected=0 actual=$actual"
        failed=1
    fi
else
    echo "FAIL: N=0 compilation failed"
    failed=1
fi

if [ "$failed" -eq 0 ]; then
    echo "ALL SUM TESTS PASSED"
    exit 0
else
    echo "SUM TEST FAILURES DETECTED"
    exit 1
fi
