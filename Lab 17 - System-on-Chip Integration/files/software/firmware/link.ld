OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
  . = 0x00000000;
  .text : { *(.text.start) *(.text*) *(.rodata*) }
  . = 0x00010000;
  .data : { *(.data*) }
  .bss : { *(.bss*) *(COMMON) }
}
