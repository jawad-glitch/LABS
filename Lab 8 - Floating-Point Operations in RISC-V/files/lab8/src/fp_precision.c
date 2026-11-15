#include <stdio.h>
#include <math.h>
#include "fp_ops.h"

void scenario_a(void) {
    printf("\nScenario A - Catastrophic cancellation\n");
    printf("%-14s %-18s %-18s %s\n",
           "epsilon","single","double","relative_error");

    for (double eps=1e-4; eps>=1e-10; eps*=0.5) {
        float es=(float)eps;
        float rs=fp_sub_s(fp_add_s(1.0f,es),1.0f);
        double rd=fp_sub_d(fp_add_d(1.0,eps),1.0);
        double rel=rd==0.0 ? 0.0 : fabs(((double)rs-rd)/rd);

        printf("%.9g       %.12g       %.15g       %.9g\n",
               eps,rs,rd,rel);
    }
}

void scenario_b(void) {
    const double values[]={1.0,1e4,1e6,1e8};

    printf("\nScenario B - Large-small addition loss\n");
    printf("%-14s %-18s %-18s %-15s %-15s\n",
           "small_addend","single_result","double_result",
           "single_absorbed","double_absorbed");

    for (int i=0;i<4;i++) {
        float s=fp_add_s(1e20f,(float)values[i]);
        double d=fp_add_d(1e20,values[i]);

        printf("%-14.0f %-18.9g %-18.12g %-15s %-15s\n",
               values[i],s,d,
               s==1e20f?"YES":"NO",
               d==1e20?"YES":"NO");
    }
}

void scenario_c(void) {
    float s=0.0f;
    double d=0.0;
    float third_s=1.0f/3.0f;
    double third_d=1.0/3.0;

    for (int i=0;i<300;i++) {
        s=fp_add_s(s,third_s);
        d=fp_add_d(d,third_d);
    }

    printf("\nScenario C - Iterative accumulation drift\n");
    printf("Single sum: %.12g deviation from 100: %.12g\n",
           s,(double)s-100.0);
    printf("Double sum: %.15g deviation from 100: %.15g\n",
           d,d-100.0);
}

int main(void) {
    scenario_a();
    scenario_b();
    scenario_c();
    return 0;
}
