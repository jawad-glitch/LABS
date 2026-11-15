# RISC-V Operating Systems Lab Report

## Lab Information
- Lab: 12 - RISC-V with Operating Systems
- Architecture: RISC-V 64-bit
- Emulator: QEMU user-mode
- Toolchain: RISC-V GNU cross compiler and binutils

## Completed Tasks
- [x] Installed and verified RISC-V development tools
- [x] Created RISC-V assembly programs
- [x] Compiled RISC-V ELF executables
- [x] Executed programs using QEMU
- [x] Tested Linux write and exit system calls
- [x] Tested process ID and time system calls
- [x] Tested file creation, reading and writing
- [x] Tested mmap and munmap
- [x] Analyzed ecall instructions
- [x] Performed a 10,000-call performance test

## System Call Analysis

| System call | Number | Purpose |
|---|---:|---|
| read | 63 | Read data |
| write | 64 | Write data |
| close | 57 | Close descriptor |
| openat | 56 | Open or create file |
| gettimeofday | 169 | Obtain time |
| getpid | 172 | Obtain process ID |
| exit | 93 | Terminate process |
| mmap | 222 | Map memory |
| munmap | 215 | Unmap memory |

## Architecture and Operating System Integration

RISC-V assembly uses the ecall instruction to request operating
system services. The system call number is placed in register a7,
and arguments are passed through registers a0-a5.

The Linux kernel processes the request and returns a result in a0.

QEMU user-mode translates RISC-V Linux system calls for execution
on the host Linux environment.

## Performance Testing

The performance test performs 10,000 getpid system calls.
Execution time can be measured using the Linux time utility.

## Important Implementation Note

This implementation uses QEMU user-mode emulation. It validates
RISC-V Linux ELF programs and syscall behavior but does not build
or boot a separate RISC-V Linux kernel using OpenSBI.

## Learning Outcomes

- Understood RISC-V Linux system call conventions.
- Practiced cross-compilation.
- Used QEMU for RISC-V program execution.
- Implemented file and memory system calls.
- Examined the relationship between ecall and Linux services.
