#include <stdio.h>
#include <math.h>
#include "fp_ops.h"

static int validate_s(float r, float e, float t) {
    return (isnan(r) && isnan(e)) || fabsf(r-e) <= t;
}

static int validate_d(double r, double e, double t) {
    return (isnan(r) && isnan(e)) || fabs(r-e) <= t;
}

#define TEST_S(name, expression, expected) do { \
    float r = (expression); \
    float e = (expected); \
    int p = validate_s(r,e,1e-6f); \
    printf("[S] %s = %.9g expected=%.9g [%s]\n",name,r,e,p?"PASS":"FAIL"); \
    if (!p) failures++; \
} while (0)

#define TEST_D(name, expression, expected) do { \
    double r = (expression); \
    double e = (expected); \
    int p = validate_d(r,e,1e-14); \
    printf("[D] %s = %.15g expected=%.15g [%s]\n",name,r,e,p?"PASS":"FAIL"); \
    if (!p) failures++; \
} while (0)

int main(void) {
    int failures = 0;

    TEST_S("add(5,2)", fp_add_s(5.0f,2.0f), 5.0f+2.0f);
    TEST_S("sub(5,2)", fp_sub_s(5.0f,2.0f), 5.0f-2.0f);
    TEST_S("mul(5,2)", fp_mul_s(5.0f,2.0f), 5.0f*2.0f);
    TEST_S("div(7,2)", fp_div_s(7.0f,2.0f), 7.0f/2.0f);
    TEST_S("sqrt(9)", fp_sqrt_s(9.0f), sqrtf(9.0f));
    TEST_S("fma(2,3,4)", fp_fma_s(2.0f,3.0f,4.0f), fmaf(2.0f,3.0f,4.0f));

    TEST_D("add(5,2)", fp_add_d(5.0,2.0), 5.0+2.0);
    TEST_D("sub(5,2)", fp_sub_d(5.0,2.0), 5.0-2.0);
    TEST_D("mul(5,2)", fp_mul_d(5.0,2.0), 5.0*2.0);
    TEST_D("div(7,2)", fp_div_d(7.0,2.0), 7.0/2.0);
    TEST_D("sqrt(9)", fp_sqrt_d(9.0), sqrt(9.0));
    TEST_D("fma(2,3,4)", fp_fma_d(2.0,3.0,4.0), fma(2.0,3.0,4.0));

    TEST_D("widen(1.25)", fp_widen(1.25f), (double)1.25f);
    TEST_S("narrow(1.25)", fp_narrow(1.25), 1.25f);

    printf("Driver failures: %d\n", failures);
    return failures == 0 ? 0 : 1;
}
