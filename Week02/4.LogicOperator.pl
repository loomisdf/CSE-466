#! /usr/bin/perl
# file name: 4.LogicOperator.pl
# This code shows you how to use a logic operator
print "Enter your sequence ...";
$Seq=<STDIN>;
$Length=length($Seq);
if ($Length<=10){
  print "Your sequence=$Seq \n";
  print "It is too short, because its length is $Length \n";
}
else {
  print "Your sequence=$Seq \n";
  print "It has a length more than 10 (actual length=$Length\n";
}
