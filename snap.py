#!/usr/bin/env python3
from struct import unpack
w,h = map( int,open("/sys/class/graphics/fb0/virtual_size").read().split(","))

# returns b g r a
decode = lambda pixel : unpack("4B", pixel)

def pr(b,g,r,a):
    print("%d %d %d" % (r,g,b))

print(f"""P3
{w} {h}
255
""")

with open("/dev/fb0", "rb") as fin:
    while pixel := fin.read(4):
        pr(*decode(pixel))
