#!/usr/bin/perl -w
# Filename: Statment_comp_conditioon.pl
print "Please enter your letter:\n";
my $nucleotide=<>;
chomp($nucleotide);
if (($nucleotide eq 'A')||($nucleotide eq 'a')){ 
  print "this is adenine\n";
}
elsif (($nucleotide eq 'C')||($nucleotide eq 'c')){
  print "this is cytosine\n";
}
elsif (($nucleotide eq 'G')||($nucleotide eq 'g')){
  print "this is guanine\n";
}
elsif (($nucleotide eq 'T')||($nucleotide eq 't')){
  print "this is thymine\n";
}
else{
  print "Not a valid input\n";
}

