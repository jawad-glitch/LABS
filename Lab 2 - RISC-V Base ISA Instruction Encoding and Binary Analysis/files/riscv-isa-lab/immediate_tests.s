.option norvc
.text
.globl immediate_tests
immediate_tests:
    beq x1, x2, -16
    jal x1, -20
