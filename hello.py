#!/usr/bin/env python3
from struct import pack
from os import SEEK_CUR, lseek as  seek, write
w,h =map(int, open("/sys/class/graphics/fb0/virtual_size").read().split(","))
so_pixel = 4
stride = w * so_pixel

encode = lambda b,g,r,a : pack("4B",b,g,r,a)

font = {
    'void' : [ 
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 0,
        0, 1, 0, 0, 0, 0, 1, 0, 
        0, 0, 1, 0, 0, 1, 1, 0,
        0, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 1, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 1, 0, 0, 0, 
       ],
    "height":8,
    "width":8,
    "l":[ 
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 0,
        ],
    "o": [
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 0, 0,
        0, 1, 0, 0, 0, 0, 1, 0,
        0, 1, 0, 0, 0, 0, 1, 0,
        0, 1, 0, 0, 0, 0, 1, 0,
        0, 1, 0, 0, 0, 0, 1, 0,
        0, 0, 1, 0, 0, 1, 0, 0,
        0, 0, 0, 1, 1, 0, 0, 0],
    "h": [
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 0, 0, 0, 0, 0, 0,
        0, 1, 1, 1, 1, 0, 0, 0,
        0, 1, 0, 0, 1, 0, 0, 0,
        0, 1, 1, 0, 1, 0, 0, 0,
        0, 1, 0, 0, 1, 0, 0, 0],
}

def go_at(fh, x, y): 
   global stride
   seek(fh.fileno(),x*so_pixel + y *stride, 0)

def next_line(fh, reminder):
    seek(fh.fileno(), stride - reminder, SEEK_CUR)


def put_char(fh, x,y, letter):
    go_at(fh, x, y)
    black = encode(0,0,0,255)
    white = encode(255,255,255,255)
    char = font.get(letter, None) or font["void"]
    line = ""
    for col,pixel in enumerate(char):
        write(fh.fileno(), white if pixel else black)
        if (col%font["width"]==font["width"]-1):
            next_line(fh, so_pixel * font["width"])
COL=0
LIN=0

OUT = open("/dev/fb0", "bw")
FD = OUT.fileno()

def newline():
    global OUT,LIN,COL
    LIN+=1
    go_at(OUT, 0, LIN * font["height"])

def print_(line):
    global OUT, COL, LIN
    COL=0
    for c in line:
        if c == "\n":
            newline()
        put_char(OUT,COL * font["width"] , LIN * font['height'], c)
        COL+=1
    newline() 
    LIN+=1

RED = encode(0xFF,0,0,0)
for i in range(30):
    print_("hello lol")

