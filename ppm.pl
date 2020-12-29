#!/usr/bin/perl
use File::Slurp;
my $out="";
my ($h,$w) = map int, strip split ",", read_file("/sys/class/graphics/fb0/virtual_size");

print "P3\n$h $w\n255\n";
for my $x (0..$w-1) {
    for my $y (0..$h-1) {
        $out.= map {  ($x/100 % 2 ? 0 : 255 ) . chr(int($y/100) % 2 ? 255 : 0) . chr($x%255) . chr(255) ;
    }
}
print $out;
