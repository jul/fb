#!/usr/bin/bash
W=$( cut -d "," -f 1 /sys/class/graphics/fb0/virtual_size )
H=$( cut -d "," -f 2 /sys/class/graphics/fb0/virtual_size )
OUT=screen.gif
rm $OUT &> /dev/null
( ffmpeg   -vcodec rawvideo -f rawvideo   -pix_fmt bgra -s ${W}x${H} \
    -i /dev/fb0  -f image2   -vcodec  gif $OUT  && fim $OUT ) &> /dev/null
