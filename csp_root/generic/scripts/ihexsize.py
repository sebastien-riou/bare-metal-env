#do not use shebang here. this is troublesome on some windows systems

import os
import sys
import logging
from intelhex import IntelHex

def bytes_length(x):
    return (x.bit_length() + 7) // 8

def ihexsize(ihexf, granularity=1):
    ih = IntelHex()
    ih.loadhex(ihexf)
    all_sections = ih.segments()
    low_addr=all_sections[0][0]
    high_addr=all_sections[0][1]
    logging.debug("input hex file sections:")
    for sec in all_sections:
        logging.debug("0x%08X 0x%08X"%(sec[0],sec[1]-1))
        low_addr=min(low_addr,sec[0])
        high_addr=max(high_addr,sec[1])

    logging.debug("low_addr =0x%x"%low_addr)
    logging.debug("high_addr=0x%x"%high_addr)
    size=high_addr-low_addr
    part = size % granularity
    if 0 != part:
        size += granularity - part
    return size


if (len(sys.argv) < 3):
    print("ERROR: incorrect arguments")
    print("ihexsize.py: compute total footprint size of ihex")
    print("Usage:")
    print("ihexsize.py <ihex> <granularity>")
    exit(-1)

ihexf = sys.argv[1]
granularity = int(sys.argv[2],0)
size=ihexsize(ihexf,granularity=granularity)

print("0x%x"%size)
