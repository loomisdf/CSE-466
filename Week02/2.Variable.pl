#! /usr/local/bin/perl
# file name: 2.Variable.pl
# This code helps you understand variables and values in Perl
$Y='ATGG';
$X=4;
print "$Y has $X nucleotides\n";
$Y='ATG';
$X=length($Y);
print "$Y has $X nucleotides\n";