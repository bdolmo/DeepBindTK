#!/usr/bin/perl

use strict;
use warnings;
use List::MoreUtils qw(any uniq);

while(my$line=<STDIN>) {
	chomp $line;
	my @tmp = split (/\t/, $line);
	my @samples = (split /,/, $tmp[3]);
	my @uniq = uniq(@samples);
	my $samples_uniq = join (",", @uniq);
	print "$tmp[0]\t$tmp[1]\t$tmp[2]\t$samples_uniq\n";
}

