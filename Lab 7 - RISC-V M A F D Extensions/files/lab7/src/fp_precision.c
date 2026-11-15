#include <stdio.h>
#include <math.h>

int main(void) {
    volatile float one_f = 1.0f / 7.0f;
    volatile float pi_f = 3.14159265358979323846f;
    volatile float e_f = 2.71828182845904523536f;
    volatile float result_f = sqrtf((one_f + pi_f) * e_f) / 3.0f;

    volatile double one_d = 1.0 / 7.0;
    volatile double pi_d = 3.14159265358979323846;
    volatile double e_d = 2.71828182845904523536;
    volatile double result_d = sqrt((one_d + pi_d) * e_d) / 3.0;

    double difference = fabs((double)result_f - result_d);

    printf("Single precision: %.12f\n", result_f);
    printf("Double precision: %.15f\n", result_d);
    printf("Absolute difference: %.12g\n", difference);

    return isfinite(result_f) && isfinite(result_d) && difference < 1e-6 ? 0 : 1;
}
