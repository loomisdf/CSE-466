#!/usr/bin/perl -w
# file name: 8.LoopFor.pl

$Seq='ATGCTTGCGC'; 
$Nucleotide='';

for ($position=0; $position<length($Seq); $position=$position+1){
   $Nucleotide=substr($Seq,$position,1);
   print "$position $Nucleotide\n";
}

for ($position=length($Seq)-1; $position>=0; $position=$position-1){
   $Nucleotide=substr($Seq,$position,1);
   print "$position $Nucleotide\n";
}
