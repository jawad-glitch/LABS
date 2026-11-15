    .text
    .align 2

    .globl fp_add_d
    .type fp_add_d,@function
fp_add_d:
    fadd.d fa0, fa0, fa1
    ret

    .globl fp_sub_d
    .type fp_sub_d,@function
fp_sub_d:
    fsub.d fa0, fa0, fa1
    ret

    .globl fp_mul_d
    .type fp_mul_d,@function
fp_mul_d:
    fmul.d fa0, fa0, fa1
    ret

    .globl fp_div_d
    .type fp_div_d,@function
fp_div_d:
    fdiv.d fa0, fa0, fa1
    ret

    .globl fp_sqrt_d
    .type fp_sqrt_d,@function
fp_sqrt_d:
    fsqrt.d fa0, fa0
    ret

    .globl fp_fma_d
    .type fp_fma_d,@function
fp_fma_d:
    fmadd.d fa0, fa0, fa1, fa2
    ret

    .globl fp_widen
    .type fp_widen,@function
fp_widen:
    fcvt.d.s fa0, fa0
    ret

    .globl fp_narrow
    .type fp_narrow,@function
fp_narrow:
    fcvt.s.d fa0, fa0
    ret

    .section .note.GNU-stack,"",@progbits
