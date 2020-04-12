/* Default linker script, for normal executables */
OUTPUT_FORMAT("elf32-littleriscv", "elf32-littleriscv", "elf32-littleriscv")
OUTPUT_ARCH(riscv)
MEMORY
{
  ram          (rwx): ORIGIN = 0x100000, LENGTH = 20K
  bootvector   (rx) : ORIGIN = 0x200000, LENGTH = 4
  flash        (rx) : ORIGIN = 0x200004, LENGTH = 100K-4
}

INCLUDE generic-flash.ld
