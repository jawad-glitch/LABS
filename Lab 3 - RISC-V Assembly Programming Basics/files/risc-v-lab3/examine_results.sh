#!/bin/bash

cd "$HOME/risc-v-lab3" || exit 1

FAILED=0

run_test() {
    name="$1"
    printf "%-24s" "$name"

    if [ ! -x "$name" ]; then
        echo "FAIL: executable missing"
        FAILED=1
        return
    fi

    qemu-riscv64 "./$name"
    status=$?

    if [ "$status" -eq 0 ]; then
        echo "PASS"
    else
        echo "FAIL: exit status $status"
        FAILED=1
    fi
}

echo "=== RISC-V Assembly Lab 3 Results ==="
echo

run_test arithmetic
run_test logical
run_test branches
run_test functions
run_test debug_example
run_test comprehensive_test

echo
echo "=== Expected calculated values ==="
echo "Arithmetic: 15+7=22, 15-7=8, 15*7=105"
echo "Logical: AND=160, OR=250, XOR=90"
echo "Logical: NOT=-241 (RV64 sign-extended result)"
echo "Shifts: left=960, right=60"
echo "Branches: comparison result=2, loop counter=5"
echo "Functions: 8+3=11, factorial(5)=120"
echo "Debug: array sum=207, maximum=89"
echo "Comprehensive: 125, 15, 1, 100"

echo
if [ "$FAILED" -eq 0 ]; then
    echo "RESULT: ALL TESTS PASSED"
else
    echo "RESULT: ONE OR MORE TESTS FAILED"
fi

exit "$FAILED"
