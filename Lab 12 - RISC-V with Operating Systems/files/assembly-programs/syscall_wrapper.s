.section .text
.global sys_write
.global sys_read
.global sys_openat
.global sys_close
.global sys_exit

sys_write:
    li a7, 64
    ecall
    ret

sys_read:
    li a7, 63
    ecall
    ret

sys_openat:
    li a7, 56
    ecall
    ret

sys_close:
    li a7, 57
    ecall
    ret

sys_exit:
    li a7, 93
    ecall
    ret
