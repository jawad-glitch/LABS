typedef volatile unsigned int reg32;

#define UART_DATA   (*(reg32 *)0x10000000u)
#define UART_STATUS (*(reg32 *)0x10000004u)
#define SPI_DATA    (*(reg32 *)0x20000000u)
#define SPI_STATUS  (*(reg32 *)0x20000004u)
#define RESULT      (*(reg32 *)0x00010000u)

void _start(void) {
    UART_DATA = 0x55u;
    while ((UART_STATUS & 1u) == 0u) { }
    SPI_DATA = 0xA5u;
    while ((SPI_STATUS & 2u) == 0u) { }
    RESULT = SPI_DATA & 0xffu;
    for (;;) { __asm__ volatile ("nop"); }
}
