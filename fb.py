#!/usr/bin/env python3
from struct import pack
w,h =map(int, open("/sys/class/graphics/fb0/virtual_size").read().split(","))
midx = w//2
midy = h//2

encode = lambda b,g,r,a : pack("4B",b,g,r,a)

with open("/dev/fb0", "wb") as f:
    for y in range(0,h):
        for x in range(0,w):
            f.write(encode(
                not x%100 and 0xA0 or x<midx and 0xFF or 0, #blue
                y<midy and 0xFF or 0,                       #green
                x>midx and y>midy and 0xFF or 0,            #red
                0,
            ))
