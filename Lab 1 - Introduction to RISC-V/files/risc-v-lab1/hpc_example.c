#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_SIZE 100

static double *allocate_matrix(size_t count) {
    return calloc(count * count, sizeof(double));
}

int main(void) {
    const size_t n = MATRIX_SIZE;
    double *a = allocate_matrix(n);
    double *b = allocate_matrix(n);
    double *c = allocate_matrix(n);

    if (!a || !b || !c) {
        fprintf(stderr, "Matrix allocation failed.\n");
        free(a);
        free(b);
        free(c);
        return 1;
    }

    puts("=== RISC-V HPC Matrix Multiplication Simulation ===");

    for (size_t i = 0; i < n; i++) {
        for (size_t j = 0; j < n; j++) {
            a[i * n + j] = (double)(i + j);
            b[i * n + j] = (double)(i * j + 1);
        }
    }

    clock_t start = clock();

    for (size_t i = 0; i < n; i++) {
        for (size_t k = 0; k < n; k++) {
            double aik = a[i * n + k];
            for (size_t j = 0; j < n; j++) {
                c[i * n + j] += aik * b[k * n + j];
            }
        }
    }

    clock_t end = clock();

    printf("Matrix size: %zux%zu\n", n, n);
    printf("Elapsed CPU time: %.6f seconds\n",
           (double)(end - start) / CLOCKS_PER_SEC);
    printf("Result sample c[0][0] = %.2f\n", c[0]);

    free(a);
    free(b);
    free(c);

    puts("HPC simulation complete.");
    return 0;
}
