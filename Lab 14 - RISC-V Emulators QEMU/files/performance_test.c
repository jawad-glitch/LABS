#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 2500

static void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int main(void) {
    int *array = malloc(ARRAY_SIZE * sizeof(int));
    if (!array) {
        perror("malloc");
        return 1;
    }

    srand(12345);
    for (int i = 0; i < ARRAY_SIZE; i++)
        array[i] = rand() % 10000;

    printf("Sorting %d elements on RISC-V emulation...\n", ARRAY_SIZE);
    clock_t start = clock();
    bubble_sort(array, ARRAY_SIZE);
    clock_t end = clock();

    int sorted = 1;
    for (int i = 1; i < ARRAY_SIZE; i++) {
        if (array[i - 1] > array[i]) sorted = 0;
    }

    printf("Elapsed CPU time: %.6f seconds\n",
           (double)(end - start) / CLOCKS_PER_SEC);
    printf("Array is %s\n", sorted ? "correctly sorted" : "NOT sorted");

    free(array);
    return sorted ? 0 : 1;
}
