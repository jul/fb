#!/usr/bin/perl
use strict;
use warnings;
use File::Slurp;
my ($FILE) = @ARGV;
open(my $fh, "<:raw", $FILE);
my ($w,$h) = map int, split ",", read_file("/sys/class/graphics/fb0/virtual_size");
print "P3
${w} ${h}
255
";
sub pr { my ($b, $g, $r, $a)=@_; print "$r $g $b\n"; }
while (read($fh,my $l, 4)) { pr unpack "C4", $l }
close($fh);
