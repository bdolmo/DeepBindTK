#!/usr/bin/perl

use strict;
use warnings;

my $size_param = $ARGV[0];

while(my$line=<STDIN>) {
	chomp $line;
	my @tmp = split (/\t/, $line);
	my $size = $tmp[2]-$tmp[1];
	my $start= $tmp[1];
	my $end  = $tmp[2];
	if ($size < $size_param-1) {
	
	   my $x = $size_param - 36;
	
	   if (&checkEvenOdd($size)) {
	      my $st = (($x-$size)/2);
	      my $ed = (($x-$size)/2)+36;
	      $start = $start- $st;
	      $end = $end + $ed;
	   }
	   else {
	      my $st = (($x-$size)/2)-0.5;
	      my $ed = (($x-$size)/2)+ 36 + 0.5;
	      $start = $start-$st;
	      $end   = $end+$ed;
	   }
	}
	my $extra_fields = join ("\t", @tmp[3..@tmp-1]);
	print "$tmp[0]\t$start\t$end\t$extra_fields\n";
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
