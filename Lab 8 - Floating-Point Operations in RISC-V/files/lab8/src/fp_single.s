    .text
    .align 2

    .globl fp_add_s
    .type fp_add_s,@function
fp_add_s:
    fadd.s fa0, fa0, fa1
    ret

    .globl fp_sub_s
    .type fp_sub_s,@function
fp_sub_s:
    fsub.s fa0, fa0, fa1
    ret

    .globl fp_mul_s
    .type fp_mul_s,@function
fp_mul_s:
    fmul.s fa0, fa0, fa1
    ret

    .globl fp_div_s
    .type fp_div_s,@function
fp_div_s:
    fdiv.s fa0, fa0, fa1
    ret

    .globl fp_sqrt_s
    .type fp_sqrt_s,@function
fp_sqrt_s:
    fsqrt.s fa0, fa0
    ret

    .globl fp_fma_s
    .type fp_fma_s,@function
fp_fma_s:
    fmadd.s fa0, fa0, fa1, fa2
    ret

    .section .note.GNU-stack,"",@progbits
