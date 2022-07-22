#do not use shebang here. this is troublesome on some windows systems

import os
import sys
from intelhex import IntelHex

def bytes_length(x):
    return (x.bit_length() + 7) // 8

if (len(sys.argv) < 2):
    print("ERROR: incorrect arguments")
    print("ihex2ascii.py: convert an ihex to human readable binary image")
    print("Usage:")
    print("ihex2binascii.py <ihex> <word size in bits>")
    exit()

ihexf = sys.argv[1]
wordWidth = int(sys.argv[2],0)
wordWidthBytes = wordWidth // 8

ih = IntelHex()
ih.loadhex(ihexf)
all_sections = ih.segments()
low_addr=all_sections[0][0]
high_addr=all_sections[0][1]
for sec in all_sections:
    low_addr=min(low_addr,sec[0])
    high_addr=max(high_addr,sec[1])

size=high_addr-low_addr
if size>10*1024*1024:
    print("image is larger than 10MB, give up")
    exit(-1)

#copy all regular sections
for i in range(low_addr,high_addr):
    print(bin(ih[i])[2:].zfill(8),end="")
    if wordWidthBytes-1==(i%wordWidthBytes):
        print("")


