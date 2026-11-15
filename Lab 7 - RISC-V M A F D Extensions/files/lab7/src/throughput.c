#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdint.h>
#include <stdatomic.h>
#include <time.h>

#define N 1000000

static double elapsed(struct timespec a, struct timespec b) {
    return (b.tv_sec - a.tv_sec) * 1000.0 +
           (b.tv_nsec - a.tv_nsec) / 1000000.0;
}

int main(void) {
    struct timespec a, b;
    volatile uint64_t m = 7;
    volatile float f = 1.001f;
    volatile double d = 1.000001;
    atomic_uint_fast64_t counter = 0;
    volatile uint64_t sink = 0;
    double tm, ta, tf, td;

    clock_gettime(CLOCK_MONOTONIC, &a);
    for (uint64_t i = 1; i <= N; i++)
        m = (m * 6364136223846793005ULL + i) % 1000000007ULL;
    clock_gettime(CLOCK_MONOTONIC, &b);
    tm = elapsed(a, b);
    sink += m;

    clock_gettime(CLOCK_MONOTONIC, &a);
    for (uint64_t i = 0; i < N; i++)
        atomic_fetch_add_explicit(&counter, 1, memory_order_relaxed);
    clock_gettime(CLOCK_MONOTONIC, &b);
    ta = elapsed(a, b);
    sink += atomic_load(&counter);

    clock_gettime(CLOCK_MONOTONIC, &a);
    for (uint64_t i = 0; i < N; i++)
        f = f * 1.000001f + 0.000001f;
    clock_gettime(CLOCK_MONOTONIC, &b);
    tf = elapsed(a, b);
    sink += (uint64_t)(f * 1000.0f);

    clock_gettime(CLOCK_MONOTONIC, &a);
    for (uint64_t i = 0; i < N; i++)
        d = d * 1.0000001 + 0.0000001;
    clock_gettime(CLOCK_MONOTONIC, &b);
    td = elapsed(a, b);
    sink += (uint64_t)(d * 1000.0);

    printf("Iterations per test: %d\n", N);
    printf("M integer arithmetic: %.3f ms\n", tm);
    printf("A atomic operations:  %.3f ms\n", ta);
    printf("F single precision:   %.3f ms\n", tf);
    printf("D double precision:   %.3f ms\n", td);
    printf("Result checksum: %llu\n", (unsigned long long)sink);

    return sink != 0 ? 0 : 1;
}
