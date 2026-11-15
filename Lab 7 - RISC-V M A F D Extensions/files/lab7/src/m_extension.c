#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
    volatile int64_t sa = INT64_C(5000000000);
    volatile int64_t sb = INT64_C(3000000000);
    volatile uint64_t ua = UINT64_C(6000000000);
    volatile uint64_t ub = UINT64_C(4000000000);
    volatile int64_t sd_a = -INT64_C(9876543210);
    volatile int64_t sd_b = 12345;
    volatile uint64_t ud_a = UINT64_C(9876543210);
    volatile uint64_t ud_b = 12345;

    int64_t smul = sa * sb;
    uint64_t umul = ua * ub;
    int64_t sdiv = sd_a / sd_b;
    uint64_t udiv = ud_a / ud_b;
    int64_t srem = sd_a % sd_b;
    uint64_t urem = ud_a % ud_b;

    printf("Signed multiplication: %" PRId64 " * %" PRId64 " = %" PRId64 "\n",
           (int64_t)sa, (int64_t)sb, smul);
    printf("Unsigned multiplication: %" PRIu64 " * %" PRIu64 " = %" PRIu64 "\n",
           (uint64_t)ua, (uint64_t)ub, umul);
    printf("Signed division: %" PRId64 " / %" PRId64 " = %" PRId64 "\n",
           (int64_t)sd_a, (int64_t)sd_b, sdiv);
    printf("Unsigned division: %" PRIu64 " / %" PRIu64 " = %" PRIu64 "\n",
           (uint64_t)ud_a, (uint64_t)ud_b, udiv);
    printf("Signed remainder: %" PRId64 " %% %" PRId64 " = %" PRId64 "\n",
           (int64_t)sd_a, (int64_t)sd_b, srem);
    printf("Unsigned remainder: %" PRIu64 " %% %" PRIu64 " = %" PRIu64 "\n",
           (uint64_t)ud_a, (uint64_t)ud_b, urem);

    char command[1024];
    int n = snprintf(command, sizeof(command),
        "riscv64-linux-gnu-objdump -d '%s' | "
        "grep -E '[[:space:]](mul|mulh|mulhu|div|divu|rem|remu)[[:space:]]' "
        "> '%s'",
        argv[0], argc > 1 ? argv[1] : "/tmp/lab7_m_count.txt");

    if (n < 0 || (size_t)n >= sizeof(command) || system(command) != 0) {
        fprintf(stderr, "Disassembly/count command failed\n");
        return 2;
    }

    const char *count_file = argc > 1 ? argv[1] : "/tmp/lab7_m_count.txt";
    snprintf(command, sizeof(command), "wc -l < '%s'", count_file);
    printf("M-extension instruction count: ");
    fflush(stdout);
    if (system(command) != 0)
        return 2;

    return 0;
}
