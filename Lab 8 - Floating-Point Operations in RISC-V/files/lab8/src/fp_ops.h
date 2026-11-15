#ifndef FP_OPS_H
#define FP_OPS_H

float fp_add_s(float a, float b);
float fp_sub_s(float a, float b);
float fp_mul_s(float a, float b);
float fp_div_s(float a, float b);
float fp_sqrt_s(float a);
float fp_fma_s(float a, float b, float c);

double fp_add_d(double a, double b);
double fp_sub_d(double a, double b);
double fp_mul_d(double a, double b);
double fp_div_d(double a, double b);
double fp_sqrt_d(double a);
double fp_fma_d(double a, double b, double c);

double fp_widen(float a);
float fp_narrow(double a);

#endif
