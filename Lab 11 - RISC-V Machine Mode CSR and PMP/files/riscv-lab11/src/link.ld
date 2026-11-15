OUTPUT_ARCH(riscv)
ENTRY(_start)

SECTIONS
{
    . = 0x80000000;

    .text : ALIGN(4)
    {
        KEEP(*(.text.init))
        KEEP(*(.text.trap))
        KEEP(*(.text.user))
        *(.text*)
    }

    .rodata : ALIGN(8) { *(.rodata*) }

    . = 0x80008000;
    .data : ALIGN(8) { *(.data*) }
    .bss : ALIGN(8)
    {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        __bss_end = .;
    }

    . = 0x80010000;
    _stack_top = .;
}
