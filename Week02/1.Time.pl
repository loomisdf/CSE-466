#!/usr/bin/perl 
# file name: 1.Time.pl
=begin
This code shows you the difference between # and #! and
how to generate comments of multiple lines
=cut 
$time = localtime(); 
print "The time is now $time\n"; 
print "Please enter something!\n";
$msg=<STDIN>;
print "After you entered:$msg, the time is now $time\n"; 
