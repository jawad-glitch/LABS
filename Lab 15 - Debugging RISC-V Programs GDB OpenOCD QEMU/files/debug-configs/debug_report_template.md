# RISC-V Debugging Session Report

## Environment
- Architecture: RISC-V 64-bit
- Emulator: QEMU user-mode
- Debugger: GDB Multiarch
- Hardware debugging framework: OpenOCD

## Issues Identified
1. find_max uses i <= size rather than i < size.
2. The improved implementation validates array size.
3. Pointer use should check for NULL before dereferencing.

## Debugging techniques
- Breakpoints and temporary execution stops
- Watchpoints
- Register and stack inspection
- Memory examination
- Source-level and instruction-level stepping
- Remote GDB connection

## Hardware limitation
No physical JTAG adapter or RISC-V development board was connected.
