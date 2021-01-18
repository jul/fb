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
    
$font{"void"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 1, 0,
    0, 0, 1, 0, 1, 0, 1, 0, 
    0, 0, 1, 1, 0, 0, 1, 0,
    0, 0, 0, 1, 0, 0, 1, 0,
    0, 0, 1, 0, 1, 0, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 
   ];
$font{" "} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 
   ];
$font{"h"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0, 
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 
   ];
$font{"height"}=8;
$font{"width"}=8;
$font{"e"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    ];


$font{"l"} =[ 
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 1, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    ];

$font{"o"} = [
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 1, 1, 1, 0, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 0, 1, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,];
$font{"w"} = [
    0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 0, 0, 1, 0, 0,
    0, 1, 0, 1, 0, 1, 0, 0,
    0, 0, 1, 1, 1, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0,
    ];
sub go_at{
    my  ($fh, $x, $y)=@_;
    sysseek $fh, $x * $so_pixel+ ($y * $stride),0;
}
sub next_line{
   my ($fh, $so_pixel_array)=@_;
   sysseek $fh, $stride - ( $so_pixel_array * $so_pixel), SEEK_CUR;

};
my @cmap =  map { ((($_)+220) %256 , ($_ * 8) % 256, (255 - ($_))%256, 255 )  } (0 .. 32);
sub get_col { my ($index) = @_;$index=$index%32 ; return @cmap[($index*4)..(($index+1)*4-1)]; }



my $CI=0;
sub pr_char{ 
    my ($fh, $x, $y, $letter,$ci)=@_;
    my @black = (0, 0, 0, 255);
    my @white = (255, 255,255,255);


    go_at $fh, $x, $y;
    my $c=0;
    my $line="";
    my @color= @black;
    my @char = exists($font{$letter}) ? @{$font{$letter}} : @{$font{"void"}};
    if ($letter !~ / /) {
        @color = get_col ((($x+$y)/32)%32);
        #print $letter . "," . $x . ",". $x%32 . "\n";
        $CI=$CI%32;
   }
    for my $pixel ( @char) {

        $line.= pack "C4", $pixel ? @color: @black;
        $line.= pack "C4", $pixel ? @color: @black;
        $line.= pack "C4", $pixel ? @color: @black;
        $line.= pack "C4", $pixel ? @color: @black;
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

    for my $c (split //,$_[0]) {
        if ($c =~ /"\n"/ ) {
            nl;
        } else {
            pr_char $fb, $COL++ * $CW, $LIN * $LW, $c, $CI;
            $CI=$CI%32;
        }
    }
    nl;
}
for my $i (0 ... 30) { 
    print_ " " x (int(cos($i/3)*15) + 20 )  .  "hello lol world";
}
close($fb)
