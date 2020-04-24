/* Default linker script, for normal executables */

/*shall be included in a higher level linker script which defines the following
OUTPUT_FORMAT(...)
OUTPUT_ARCH(...)
MEMORY
{
  ram          (rwx): ORIGIN = 0x000000, LENGTH = 20K
  bootvector   (rx) : ORIGIN = 0x100000, LENGTH = 4
  flash        (rx) : ORIGIN = 0x100004, LENGTH = 100K-4
}
*/
LD_FEATURE ("SANE_EXPR")
SECTIONS
{

   ENTRY( _start )
  /* Read-only sections, merged into text segment.  */
  .hash          : { *(.hash)             }
  .dynsym        : { *(.dynsym)           }
  .dynstr        : { *(.dynstr)           }
  .gnu.version   : { *(.gnu.version)      }
  .gnu.version_d   : { *(.gnu.version_d)  }
  .gnu.version_r   : { *(.gnu.version_r)  }
  .rel.init      : { *(.rel.init) }
  .rela.init     : { *(.rela.init) }
  .rel.text      :
    {
      *(.rel.text)
      *(.rel.text.*)
      *(.rel.gnu.linkonce.t*)
    }
  .rela.text     :
    {
      *(.rela.text)
      *(.rela.text.*)
      *(.rela.gnu.linkonce.t*)
    }
  .rel.fini      : { *(.rel.fini) }
  .rela.fini     : { *(.rela.fini) }
  .rel.rodata    :
    {
      *(.rel.rodata)
      *(.rel.rodata.*)
      *(.rel.gnu.linkonce.r*)
    }
  .rela.rodata   :
    {
      *(.rela.rodata)
      *(.rela.rodata.*)
      *(.rela.gnu.linkonce.r*)
    }
  .rel.data      :
    {
      *(.rel.data)
      *(.rel.data.*)
      *(.rel.gnu.linkonce.d*)
    }
  .rela.data     :
    {
      *(.rela.data)
      *(.rela.data.*)
      *(.rela.gnu.linkonce.d*)
    }
  .rel.ctors     : { *(.rel.ctors)        }
  .rela.ctors    : { *(.rela.ctors)       }
  .rel.dtors     : { *(.rel.dtors)        }
  .rela.dtors    : { *(.rela.dtors)       }
  .rel.got       : { *(.rel.got)          }
  .rela.got      : { *(.rela.got)         }
  .rel.bss       : { *(.rel.bss)          }
  .rela.bss      : { *(.rela.bss)         }
  .rel.plt       : { *(.rel.plt)          }
  .rela.plt      : { *(.rela.plt)         }

  .bootvector :
  {
    LONG(_start)
  } > bootvector

  /* Internal text space.  */
  .text :
    ALIGN(2)
    {
      *(.init)
      *(.init0)  /* Start here after reset.  */
      *(.init1)
      *(.init2)  /* Copy data loop  */
      *(.init3)
      *(.init4)  /* Clear bss  */
      *(.init5)
      *(.init6)  /* C++ constructors.  */
      *(.init7)
      *(.init8)
      *(.init9)  /* Call main().  */
       __ctors_start = . ;
       *(.ctors)
       __ctors_end = . ;
       __dtors_start = . ;
       *(.dtors)
       __dtors_end = . ;
      . = ALIGN(2);
      *(.text)
      . = ALIGN(2);
      *(.text.*)
      . = ALIGN(2);
      *(.fini9)  /*   */
      *(.fini8)
      *(.fini7)
      *(.fini6)  /* C++ destructors.  */
      *(.fini5)
      *(.fini4)
      *(.fini3)
      *(.fini2)
      *(.fini1)
      *(.fini0)  /* Infinite loop after program termination.  */
      *(.fini)
      . = ALIGN(128);
      _etext = .;
    } > flash

  .rodata :
  ALIGN(2)
    {
      . = ALIGN(2);
      *(.rodata .rodata.* .gnu.linkonce.r.*)
      *(.rodata1)
      . = ALIGN(128);
      _etext = .;
    }  > flash

  .vector_table :
    ALIGN(128)
    SUBALIGN(128)
    ONLY_IF_RO
  {
     _vectors = .;
     KEEP(*(.vector_table));
     _evectors = .;
     _etext = .;
  } >flash

  .vector_table :
    ALIGN(128)
    SUBALIGN(128)
    ONLY_IF_RW
  {
     _vectors = .;
     KEEP(*(.vector_table));
     _evectors = .;
  } >ram AT >flash


  .ram_code   :
    ALIGN (2)
  {
    _ram_code = DEFINED(_ram_code)? _ram_code : . ;
    /*INCLUDE ram_code_section.ld*/
    KEEP(*(.ram_code));
    _eram_code = .;
  } >ram AT >flash

  .data   :
    ALIGN (2)
  {
    _data = DEFINED(_data)? _data : . ;
    . = ALIGN(2);
    *(.data)
    . = ALIGN(2);
    *(.data.*)
    . = ALIGN(2);
    *(.gnu.linkonce.d*)
    . = ALIGN(2);
     _edata = . ;
  } >ram AT >flash

  .bss :
    ALIGN (2)
  {
     _bss = . ;
    *(.bss)
    . = ALIGN(2);
    *(.bss.*)
    . = ALIGN(2);
    *(COMMON)
    . = ALIGN(2);
     _ebss = . ;
  } >ram



  .noinit :
    ALIGN (2)
  {
    *(.noinit)
    . = ALIGN(2);
    *(.noinit.*)
    . = ALIGN(2);
     _end = . ;
  } >ram

  
  OVERLAY : NOCROSSREFS
  {
    .text_overlay0
    {
      __text_overlay0_vma = .;
      KEEP(*(.text_overlay0))
      __text_overlay0_vma_end = .;
    }
  } >ram AT> flash

  _stack = ORIGIN(ram) + LENGTH(ram);
  
  PROVIDE (__stack_size = 0x400);
  .stack_check :
  {
    PROVIDE (__stack_base = .);
    ASSERT ((_stack > (__stack_base + __stack_size)), "Error: Not enough room left for the stack");
  }

  _stack_size_ok = (_stack > (__stack_base + __stack_size));
  _ram_codelma  = LOADADDR(.ram_code) ;
  _datalma  = LOADADDR(.data) ;
  _vectorslma  = LOADADDR(.vector_table) ;

  

  /* Addresses of IPs, help for disassembly readability */
  INCLUDE target_ips.ld

  /* Stabs for profiling information*/
  .profiler 0 : { *(.profiler) }
  /* Stabs debugging sections.  */
  .stab 0 : { *(.stab) }
  .stabstr 0 : { *(.stabstr) }
  .stab.excl 0 : { *(.stab.excl) }
  .stab.exclstr 0 : { *(.stab.exclstr) }
  .stab.index 0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment 0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info) *(.gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
}

