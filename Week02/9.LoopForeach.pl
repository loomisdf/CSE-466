#!/usr/bin/perl -w
# file name: 9.LoopForeach.pl
# This code is used to illustrate how foreach loop works

$loop_time=0;

foreach my $nucleotide (A,T,G,C,N)
{
  $loop_time=$loop_time+1;
  print "$loop_time nucleotide=[".$nucleotide."]\n";
}
