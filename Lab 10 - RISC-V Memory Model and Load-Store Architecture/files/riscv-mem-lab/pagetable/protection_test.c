#define _GNU_SOURCE
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/mman.h>
#include <signal.h>
#include <setjmp.h>
#include <string.h>

#define PAGE_SIZE 4096

typedef struct {
    void *fault_addr;
    int si_code;
    int attempt_number;
    const char *access_type;
} fault_entry_t;

static sigjmp_buf recovery;
static volatile sig_atomic_t current_attempt;
static volatile sig_atomic_t current_access;
static volatile sig_atomic_t fault_count;
static fault_entry_t internal_log[2];

static void segv_handler(int sig, siginfo_t *info, void *context)
{
    (void)sig;
    (void)context;

    if (fault_count < 2) {
        int n = fault_count;
        internal_log[n].fault_addr = info->si_addr;
        internal_log[n].si_code = info->si_code;
        internal_log[n].attempt_number = current_attempt;
        internal_log[n].access_type = current_access == 1 ? "write" : "read";
        fault_count++;
    }
    siglongjmp(recovery, 1);
}

static void attempt_write(volatile uint32_t *p, uint32_t value, int number)
{
    current_attempt = number;
    current_access = 1;
    if (sigsetjmp(recovery, 1) == 0)
        *p = value;
}

static void attempt_read(volatile uint32_t *p, int number)
{
    current_attempt = number;
    current_access = 0;
    if (sigsetjmp(recovery, 1) == 0) {
        volatile uint32_t value = *p;
        (void)value;
    }
}

int upgrade_and_verify(void *ro_region, uint32_t sentinel)
{
    if (mprotect(ro_region, PAGE_SIZE, PROT_READ | PROT_WRITE) != 0)
        return -1;

    volatile uint32_t *p = (volatile uint32_t *)ro_region;
    *p = sentinel;
    return *p == sentinel ? 0 : -1;
}

int run_protection_test(fault_entry_t fault_log[2])
{
    void *rw = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    void *ro = mmap(NULL, PAGE_SIZE, PROT_READ,
                    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    void *none = mmap(NULL, PAGE_SIZE, PROT_NONE,
                      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (rw == MAP_FAILED || ro == MAP_FAILED || none == MAP_FAILED)
        return -1;

    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = segv_handler;
    sa.sa_flags = SA_SIGINFO;
    sigemptyset(&sa.sa_mask);

    if (sigaction(SIGSEGV, &sa, NULL) != 0)
        return -1;

    fault_count = 0;

    attempt_write((volatile uint32_t *)rw, 0x12345678, 1);
    attempt_read((volatile uint32_t *)rw, 2);
    attempt_read((volatile uint32_t *)ro, 3);
    attempt_write((volatile uint32_t *)ro, 0xabcdef01, 4);
    attempt_read((volatile uint32_t *)none, 5);

    for (int i = 0; i < fault_count && i < 2; ++i)
        fault_log[i] = internal_log[i];

    printf("Protection mappings: RW=%p RO=%p NONE=%p\n", rw, ro, none);
    printf("Faults captured: %d\n", (int)fault_count);

    for (int i = 0; i < fault_count && i < 2; ++i) {
        printf("Fault %d: attempt=%d type=%s address=%p si_code=%d (%s)\n",
               i + 1, fault_log[i].attempt_number,
               fault_log[i].access_type, fault_log[i].fault_addr,
               fault_log[i].si_code,
               fault_log[i].si_code == SEGV_ACCERR ? "SEGV_ACCERR" : "other");
    }

    int result = (int)fault_count;

    /* Upgrade the original RO mapping and verify writing is now permitted. */
    if (upgrade_and_verify(ro, 0x55aa33cc) != 0) {
        puts("mprotect upgrade verification: FAIL");
        result = -1;
    } else {
        puts("mprotect upgrade verification: PASS");
    }

    munmap(rw, PAGE_SIZE);
    munmap(ro, PAGE_SIZE);
    munmap(none, PAGE_SIZE);
    return result;
}

int main(void)
{
    fault_entry_t log[2] = {{0}};
    int count = run_protection_test(log);

    if (count != 2) {
        printf("Expected exactly 2 protection faults; got %d\n", count);
        return 1;
    }

    if (log[0].attempt_number != 4 || log[1].attempt_number != 5)
        return 1;

    if (log[0].si_code != SEGV_ACCERR || log[1].si_code != SEGV_ACCERR)
        return 1;

    puts("mmap/mprotect protection tests: PASS");
    return 0;
}
