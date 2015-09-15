#!/usr/bin/perl -w
# file name: 7.LoopWhile.pl
# This code is used to illustrate while loop. 

$File='0.MADFE2Q2135.fa.txt';

open(INPUT,"<$File") or die "Can't open file: $File\n";

my $line_number=0;
while ($line=<INPUT>) {
   chomp($line);
   $line =~ s/\r$//;
   $line_number=$line_number+1;
   print "[$line_number]".$line."[LineEnd]\n";
}
