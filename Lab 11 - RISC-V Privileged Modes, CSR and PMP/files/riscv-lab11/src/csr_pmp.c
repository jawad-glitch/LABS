typedef unsigned long uint64_t;

#define UART ((volatile unsigned char *)0x10000000UL)

static void putc_uart(char c)
{
    *UART = (unsigned char)c;
}

static void puts_uart(const char *s)
{
    while (*s)
        putc_uart(*s++);
}

static void print_hex(uint64_t value)
{
    static const char digits[] = "0123456789abcdef";
    puts_uart("0x");
    for (int i = 60; i >= 0; i -= 4)
        putc_uart(digits[(value >> i) & 15]);
}

static uint64_t read_mstatus(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, mstatus" : "=r"(x));
    return x;
}

static uint64_t read_misa(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, misa" : "=r"(x));
    return x;
}

static uint64_t read_mtvec(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, mtvec" : "=r"(x));
    return x;
}

static uint64_t read_mscratch(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, mscratch" : "=r"(x));
    return x;
}

static uint64_t read_pmpcfg0(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, pmpcfg0" : "=r"(x));
    return x;
}

static uint64_t read_pmpaddr0(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, pmpaddr0" : "=r"(x));
    return x;
}

static uint64_t read_pmpaddr1(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, pmpaddr1" : "=r"(x));
    return x;
}

static uint64_t read_pmpaddr2(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, pmpaddr2" : "=r"(x));
    return x;
}

static uint64_t read_pmpaddr3(void)
{
    uint64_t x;
    __asm__ volatile("csrr %0, pmpaddr3" : "=r"(x));
    return x;
}

static void print_reg(const char *name, uint64_t value)
{
    puts_uart(name);
    puts_uart(" = ");
    print_hex(value);
    putc_uart('\n');
}

/*
 * NAPOT entries:
 * 0: 0x80000000..0x80007fff  RX code
 * 1: 0x80008000..0x8000ffff  RW data/stack
 * 2: 0x10000000..0x10000fff  RW UART
 *
 * Unmatched S/U-mode addresses are denied by PMP.
 * M-mode remains unrestricted for unmatched addresses.
 */
static uint64_t napot(uint64_t base, uint64_t size)
{
    return (base >> 2) | ((size >> 3) - 1);
}

int main(void)
{
    puts_uart("\nCSR values before PMP configuration:\n");
    print_reg("mstatus ", read_mstatus());
    print_reg("misa    ", read_misa());
    print_reg("mtvec   ", read_mtvec());
    print_reg("mscratch", read_mscratch());

    uint64_t code = napot(0x80000000UL, 0x8000);
    uint64_t data = napot(0x80008000UL, 0x8000);
    uint64_t uart = napot(0x10000000UL, 0x1000);

    __asm__ volatile("csrw pmpaddr0, %0" :: "r"(code) : "memory");
    __asm__ volatile("csrw pmpaddr1, %0" :: "r"(data) : "memory");
    __asm__ volatile("csrw pmpaddr2, %0" :: "r"(uart) : "memory");
    __asm__ volatile("csrw pmpaddr3, zero" ::: "memory");

    /*
     * Entry 0: NAPOT RX = 0x1d
     * Entry 1: NAPOT RW = 0x1b
     * Entry 2: NAPOT RW = 0x1b
     * Entry 3: OFF      = 0x00
     */
    uint64_t cfg = 0x001b1b1dUL;
    __asm__ volatile("csrw pmpcfg0, %0" :: "r"(cfg) : "memory");

    puts_uart("\nPMP values after configuration:\n");
    print_reg("pmpcfg0 ", read_pmpcfg0());
    print_reg("pmpaddr0", read_pmpaddr0());
    print_reg("pmpaddr1", read_pmpaddr1());
    print_reg("pmpaddr2", read_pmpaddr2());
    print_reg("pmpaddr3", read_pmpaddr3());

    puts_uart("CSR/PMP configuration complete\n");
    for (;;)
        __asm__ volatile("wfi");

    return 0;
}
