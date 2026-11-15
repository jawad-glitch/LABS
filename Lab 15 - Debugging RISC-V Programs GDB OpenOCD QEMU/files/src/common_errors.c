#include <stdio.h>
#include <stddef.h>

int main(void) {
    int values[5] = {1, 2, 3, 4, 5};
    int initialized_value = 0;
    int *pointer = NULL;

    puts("Common error demonstrations");

    puts("1. Array boundary:");
    for (int i = 0; i <= 5; i++) {
        if (i < 5)
            printf("values[%d] = %d\n", i, values[i]);
        else
            printf("Detected invalid index %d; access skipped\n", i);
    }

    puts("2. Initialized variable:");
    printf("Value = %d\n", initialized_value);

    puts("3. Null pointer:");
    if (pointer == NULL)
        puts("Null pointer detected; dereference skipped");

    return 0;
}
