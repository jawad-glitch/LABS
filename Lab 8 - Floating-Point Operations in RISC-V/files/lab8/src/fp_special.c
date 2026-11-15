#include <stdio.h>
#include <math.h>
#include <float.h>
#include "fp_ops.h"

int probe_s(int id) {
    volatile float x=4.0f;
    volatile float zero=fp_sub_s(x,x);
    float r=0.0f;
    int pass=0;

    switch(id) {
        case 1: r=fp_div_s(1.0f,zero); pass=isinf(r)&&!signbit(r); break;
        case 2: r=fp_div_s(-1.0f,zero); pass=isinf(r)&&signbit(r); break;
        case 3: r=fp_sqrt_s(-1.0f); pass=isnan(r); break;
        case 4: r=fp_mul_s(FLT_MAX,2.0f); pass=isinf(r)&&!signbit(r); break;
        default: return 0;
    }

    printf("[S] condition %d result=%g class=%s [%s]\n",
           id,r,isnan(r)?"NaN":isinf(r)?(signbit(r)?"-Inf":"+Inf"):"finite",
           pass?"PASS":"FAIL");
    return pass;
}

int probe_d(int id) {
    volatile double x=4.0;
    volatile double zero=fp_sub_d(x,x);
    double r=0.0;
    int pass=0;

    switch(id) {
        case 1: r=fp_div_d(1.0,zero); pass=isinf(r)&&!signbit(r); break;
        case 2: r=fp_div_d(-1.0,zero); pass=isinf(r)&&signbit(r); break;
        case 3: r=fp_sqrt_d(-1.0); pass=isnan(r); break;
        case 4: r=fp_mul_d(DBL_MAX,2.0); pass=isinf(r)&&!signbit(r); break;
        default: return 0;
    }

    printf("[D] condition %d result=%g class=%s [%s]\n",
           id,r,isnan(r)?"NaN":isinf(r)?(signbit(r)?"-Inf":"+Inf"):"finite",
           pass?"PASS":"FAIL");
    return pass;
}

int main(void) {
    int passed=0;

    for (int i=1;i<=4;i++) {
        passed+=probe_s(i);
        passed+=probe_d(i);
    }

    printf("\nSpecial-value checks: %d/8 passed\n",passed);

    if (passed==8) {
        printf("All IEEE 754 special-value checks passed.\n");
        return 0;
    }

    return 1;
}
