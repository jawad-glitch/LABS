#include <stdio.h>
#include <stdint.h>

static void gpio_init(void) {
    puts("Initializing simulated GPIO pins...");
}

static void sensor_read(void) {
    uint16_t temperature = 25;
    uint16_t humidity = 60;

    printf("Temperature: %u C, Humidity: %u%%\n",
           (unsigned)temperature, (unsigned)humidity);
}

static void wireless_transmit(void) {
    puts("Simulating wireless data transmission...");
}

int main(void) {
    puts("=== RISC-V Embedded System Simulation ===");
    gpio_init();

    for (int i = 0; i < 3; i++) {
        printf("\nCycle %d:\n", i + 1);
        sensor_read();
        wireless_transmit();
    }

    puts("\nEmbedded simulation complete.");
    return 0;
}
