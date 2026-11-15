#!/bin/bash

echo "=== RISC-V Open-Source Ecosystem ==="
echo

declare -A repos=(
  [riscv-isa-manual]="ISA specification"
  [riscv-gnu-toolchain]="GNU compiler and binutils toolchain"
  [riscv-pk]="Proxy kernel"
  [riscv-tests]="ISA tests"
  [riscv-opcodes]="Instruction opcode database"
)

for repo in "${!repos[@]}"; do
  echo "Repository: $repo"
  echo "Description: ${repos[$repo]}"
  echo "URL: https://github.com/riscv/$repo"
  echo
done

echo "Open ecosystem benefits:"
echo "- Public specifications"
echo "- Community development"
echo "- Independent implementations"
echo "- Research and education"
echo "- Freedom to choose compatible implementations"
