#!/usr/bin/perl
use File::Slurp;
use strict;
use warnings;
my ($w,$h) = map int, split ",", read_file("/sys/class/graphics/fb0/virtual_size");
print "P3
$w $h
255
";
sub pr { my ($r, $g, $b, $a)=@_; print "$r $g $b\n"; }
my $sq=int($h/2);
my $mc=255;
open(my $fb, ">:raw", "/dev/fb0");
for my $x (0..$h-1) {
    for my $y (0..$w-1) {
        my ($r, $g, $b, $a) = (
            (!(int($x/$sq)%2) | !(int($y/$sq)%2)) ? 0: ($y^$x)% $mc,
            (int($y/$sq) % 2) ? 0 : int($y*$mc/$sq) % $mc,
            (int($x/$sq) % 2) ? 0 : int($x*$mc/$sq) % $mc,
            0,
        );
        pr ($r, $g, $b, $a);
        print $fb pack "C4", ($b, $g,$r ,$a);
    }
}
close($fb)
