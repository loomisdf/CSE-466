#! /usr/local/bin/perl
# file name: 3.StringLiteral.pl
# This code is used to illustrate the difference among '', "" and ``
$command=`pwd`;
print "1: $command\n";
$command=`ls`;
print '2: $command\n';
print "3: $command\n";

