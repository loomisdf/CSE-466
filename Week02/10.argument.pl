#! /usr/bin/perl
# file name:10.Argument.pl
# This code is used to illustrate how to accept argument for a perl code

$file=shift;

open(INPUT,"<$file") or die "Can't open file: $file\n";

my $line_number=0;
my $sequence='';

while ($line=<INPUT>) {
   chomp($line);
   $line =~ s/\r$//;
   $line_number=$line_number+1;
   print "[$line_number]".$line."[LineEnd]\n";
   if ($line_number>1) {
      $sequence=$sequence.$line;
   }
}

print "Seq=[".$sequence."]\n";
