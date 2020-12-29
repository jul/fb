#!/usr/bin/bash
chr() { [[ $1 == 0 ]] && echo -n \0 || printf \\$(printf '%03o' $1) ; }
W=$( cut -d "," -f 1 /sys/class/graphics/fb0/virtual_size )
H=$( cut -d "," -f 2 /sys/class/graphics/fb0/virtual_size )
S=$(( $( cat /sys/class/graphics/fb0/stride ) / $W ))

echo -n $( chr 65 )
echo $( chr 80 )
die() { 
    echo "$@";
    exit 1;
}
[[ "$S" == 4 ]] || die "ça va pas marcher"

for ((y=0;y<H;y++)); do
    for ((x=0;x<W;x++)); do
        echo -n $( chr $(( x % 255)) )$( chr $(( y%255)) )$( chr $(( ( x + y ) % 255 )) )$( chr 255)
    done;
done

