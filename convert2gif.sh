#!/usr/bin/bash
FILE=$1
echo $FILE
[ -z "$1" ] && exit 1
for format in $( ffmpeg -pix_fmts 2> /dev/null | grep "32$"  | cut -d " " -f 2 ); do
    rm screendump.$format.png
    ffmpeg   -vcodec rawvideo   -f rawvideo   -pix_fmt $format -s 1920x1080 \
        -i $FILE -f image2   -vcodec gif screendump.$format.gif
    fim screendump.$format.gif
done &> /dev/null

