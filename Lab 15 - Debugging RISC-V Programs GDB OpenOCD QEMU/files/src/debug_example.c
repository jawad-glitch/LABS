#include <stdio.h>

int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

/* Logical off-by-one bug, with a physical guard element
   so the demonstration remains inside allocated storage. */
int find_max(int arr[], int size) {
    int max = arr[0];

    for (int i = 1; i <= size; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

void pointer_demo(int *ptr) {
    printf("Pointer value: %d\n", *ptr);
    *ptr *= 2;
    printf("Modified value: %d\n", *ptr);
}

int main(void) {
    int num = 5;
    int fact_result = factorial(num);

    /* Sixth element is a guard, not part of the logical array. */
    int numbers[6] = {10, 25, 8, 42, 15, 99};
    int array_size = 5;
    int test_value = 20;

    printf("RISC-V Debugging Example\n");
    printf("Factorial of %d = %d\n", num, fact_result);
    printf("Logical array size = %d\n", array_size);

    int max_value = find_max(numbers, array_size);
    printf("Maximum reported = %d\n", max_value);

    printf("Original value = %d\n", test_value);
    pointer_demo(&test_value);
    printf("Final value = %d\n", test_value);

    return 0;
}
