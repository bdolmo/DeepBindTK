#!/usr/bin/perl


use strict;
use warnings;

while(my$line=<STDIN>) {
	chomp $line;
	my @tmp = split (/\t/, $line);
	my $size = $tmp[2]-$tmp[1];
	my $start= $tmp[1];
	my $end  = $tmp[2];

	my $start_before = $tmp[1];
	my $end_before = $tmp[2];

	if ($size < 235) {
	   if (&checkEvenOdd($size)) {
	      my $st = ((200-$size)/2);
	      my $ed = ((200-$size)/2)+36;
	      $start = $start- $st;
	      $end = $end + $ed;
	   }
	   else {
	      my $st = ((200-$size)/2)-0.5;
	      my $ed = ((200-$size)/2)+ 36 + 0.5;
	      $start = $start-$st;
	      $end   = $end+$ed;
	   }
	}

	my $info_field = "$tmp[3]:$tmp[4]-$tmp[5]";

	my $extra_fields = join ("\t", @tmp[3..@tmp-1]);
	print "$tmp[0]\t$start\t$end\t$info_field\n";
}

####################
sub checkEvenOdd {

 my $size = shift;
 if ($size % 2 == 1)
 {
    return 0;
 }
 else
 {
    return 1;
 }
}
