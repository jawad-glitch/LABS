#include <stdio.h>

int main(void) {
    int a = 42, b = 24;
    printf("Hello from RISC-V emulation!\n");
    printf("Architecture: RISC-V 64-bit\n");
    printf("Running through QEMU user-mode emulation\n");
    printf("Computation: %d + %d = %d\n", a, b, a + b);
    return 0;
}
