#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use Fcntl 'SEEK_CUR';
use utf8;

my ($w,$h) = map int, split ",", read_file("/sys/class/graphics/fb0/virtual_size");
my $stride = int read_file("/sys/class/graphics/fb0/stride");
my $so_pixel=$stride / $w;
my %font=();
    
$font{"h"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 1, 0,
    0, 1, 0, 0, 0, 0, 1, 0, 
    0, 1, 0, 0, 0, 0, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 0, 0, 0, 0, 1, 0,
    0, 1, 0, 0, 0, 0, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 
   ];
$font{"height"}=8;
$font{"width"}=8;
$font{"e"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0, 0,
    ];


$font{"l"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, ];

$font{"o"} = [
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 1, 1, 0, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 0, 1, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,];

sub go_at{
    my  ($fh, $x, $y)=@_;
    sysseek $fh, $x * $so_pixel+ ($y * $stride),0;
}
sub next_line{
   my ($fh, $so_pixel_array)=@_;
   sysseek $fh, $stride - ( $so_pixel_array * $so_pixel), SEEK_CUR;

};
sub pr_char{ 
    my ($fh, $x, $y, $letter)=@_;
    go_at $fh, $x, $y;
    my @black = (0, 0, 0, 255);
    my @white = (255, 255,255,255);
    my $c=0;
    my $line="";
    for my $pixel (@{$font{$letter}}) {
        $line.= pack "C4", $pixel ? @white: @black;
        $line.= pack "C4", $pixel ? @white: @black;
        $line.= pack "C4", $pixel ? @white: @black;
        $line.= pack "C4", $pixel ? @white: @black;
        if (($c++%8)==7) {
            syswrite $fh, $line;
            next_line $fh, $font{"width"} * 4;
            syswrite $fh, $line;
            next_line $fh, $font{"width"} * 4;
            syswrite $fh, $line;
            next_line $fh, $font{"width"} * 4;
            syswrite $fh, $line;
            next_line $fh, $font{"width"} * 4;
            $line="";
        }
    }
}
my $COL=0;
my $CW=32;
my $LIN=0;
my $LW=32;

open(my $fb, ">:raw", "/dev/fb0") or die;
sub nl {
    $COL=0;
    $LIN++;
    go_at $fb, $COL*$CW, $LIN*$LW;
}
sub print_ {
    for my $c (split //,@_[0]) {
        if ($c =~ /"\n"/ ) {
            nl;
        } else {
            pr_char $fb, $COL++ * $CW, $LIN * $LW, $c;
        }
    }
    nl;
}
for my $i (0 ... 10) { 
    print_ "hello lololol";
}
close($fb)
