#include <stdio.h>
#include <pthread.h>

#define ITERATIONS 500000

volatile int unsync_counter = 0;
volatile int atomic_counter = 0;

void *unsync_worker(void *arg) {
    (void)arg;
    for (int i = 0; i < ITERATIONS; i++)
        unsync_counter++;
    return NULL;
}

void *atomic_worker(void *arg) {
    (void)arg;
    for (int i = 0; i < ITERATIONS; i++)
        __atomic_add_fetch(&atomic_counter, 1, __ATOMIC_SEQ_CST);
    return NULL;
}

int main(void) {
    pthread_t threads[4];

    if (pthread_create(&threads[0], NULL, unsync_worker, NULL) != 0)
        return 2;
    if (pthread_create(&threads[1], NULL, unsync_worker, NULL) != 0)
        return 2;
    if (pthread_create(&threads[2], NULL, atomic_worker, NULL) != 0)
        return 2;
    if (pthread_create(&threads[3], NULL, atomic_worker, NULL) != 0)
        return 2;

    for (int i = 0; i < 4; i++)
        if (pthread_join(threads[i], NULL) != 0)
            return 2;

    printf("Threads: 4 (2 unsynchronized, 2 atomic)\n");
    printf("Increments per thread: %d\n", ITERATIONS);
    printf("Expected counter value: 1000000\n");
    printf("Unsynchronized counter: %d\n", unsync_counter);
    printf("Atomic counter: %d\n", atomic_counter);

    return atomic_counter == 1000000 ? 0 : 1;
}
