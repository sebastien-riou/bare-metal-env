#!/usr/bin/env python
import os
import sys
import logging
from intelhex import IntelHex

def bytes_length(x):
    return (x.bit_length() + 7) // 8

if len(sys.argv) < 3:
    print("ERROR: incorrect arguments")
    print("ihexpad.py: pad with 0xFF")
    print("Usage:")
    print("ihexpad.py <ihex> <pad_size>")
    exit()

ihexf = sys.argv[1]
pad_size = int(sys.argv[2],0)


ih = IntelHex()
iho = IntelHex()
ih.loadhex(ihexf)
all_sections = ih.segments()
logging.debug("input hex file sections:")
for sec in all_sections:
    logging.debug("0x%08X 0x%08X"%(sec[0],sec[1]-1))

#copy all regular sections
for sec in all_sections:
    for i in range(sec[0],sec[1]):
        iho[i]=ih[i]
    addr = sec[1]
    while addr % pad_size:
        iho[addr] = 0xFF
        addr += 1

#copy start address
logging.debug("start address: ",ih.start_addr)
iho.start_addr = ih.start_addr
            
iho.write_hex_file(ihexf+".pad.ihex")

