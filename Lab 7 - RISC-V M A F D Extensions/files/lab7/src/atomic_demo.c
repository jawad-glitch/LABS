#include <stdio.h>
#include <stdatomic.h>

int main(void) {
    atomic_int shared = 15;
    int old;

    old = atomic_fetch_add(&shared, 3);
    printf("fetch_add: old=%d new=%d\n", old, atomic_load(&shared));

    old = atomic_fetch_and(&shared, 31);
    printf("fetch_and: old=%d new=%d\n", old, atomic_load(&shared));

    old = atomic_fetch_or(&shared, 64);
    printf("fetch_or: old=%d new=%d\n", old, atomic_load(&shared));

    int expected = 82;
    int success = atomic_compare_exchange_strong(&shared, &expected, 153);
    printf("compare_exchange success=%d value=%d\n", success, atomic_load(&shared));

    expected = 82;
    success = atomic_compare_exchange_strong(&shared, &expected, 119);
    printf("compare_exchange failure=%d expected=%d value=%d\n",
           success, expected, atomic_load(&shared));

    return atomic_load(&shared) == 153 ? 0 : 1;
}
