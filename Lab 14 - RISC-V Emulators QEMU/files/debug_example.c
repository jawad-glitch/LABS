#include <stdio.h>

int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int divide_numbers(int a, int b) {
    if (b == 0) {
        puts("Division by zero detected safely.");
        return -1;
    }
    return a / b;
}

int main(void) {
    int num = 5;
    int fact = factorial(num);
    int x = 100, y = 0;

    puts("=== RISC-V Debugging Example ===");
    printf("Factorial of %d is %d\n", num, fact);
    puts("Before division operation");
    int result = divide_numbers(x, y);
    printf("Division result: %d\n", result);
    return 0;
}
