#include <stdio.h>
#include <assert.h>

int factorial(int n) {
    assert(n >= 0);
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int find_max(int arr[], int size) {
    if (arr == NULL || size <= 0) return -1;

    int max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] > max) max = arr[i];
    }
    return max;
}

int main(void) {
    int values[] = {10, 25, 8, 42, 15};

    printf("Improved debugging example\n");
    printf("Factorial 5 = %d\n", factorial(5));
    printf("Correct maximum = %d\n", find_max(values, 5));
    return 0;
}
