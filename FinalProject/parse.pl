#! usr/bin/perl -w
use strict;

my $file_name = shift;

open(INPUT, "<$file_name") or die "cannot open file $file_name";


my $line;
my @curr_line;

while ($line = <INPUT>) {
	chomp($line);
	$line =~ s/\r$//;
	if(substr($line, 0, 1) eq "#") {
		next;
	}
	@curr_line = split($line, "\t");
	foreach my $val (@curr_line) {
		print "val=$val\n";
	}
	last;
}
