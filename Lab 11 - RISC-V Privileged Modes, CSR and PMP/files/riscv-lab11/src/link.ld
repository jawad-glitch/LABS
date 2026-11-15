OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
    . = 0x80000000;
    .text : ALIGN(16) { *(.text.init) *(.text .text.*) }
    .rodata : ALIGN(16) { *(.rodata .rodata.*) }
    . = 0x80008000;
    .data : ALIGN(16) { *(.data .data.*) }
    .bss : ALIGN(16) { *(.bss .bss.*) *(COMMON) }
    . = 0x80010000;
    _stack_top = .;
}
