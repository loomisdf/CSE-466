#!/usr/bin/perl
# Filename: loomisdf_a1.pl
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);

=begin
This perl program is for the first assignment in CSE 466
=cut

# Read the filename from an argument
my $fileName = $ARGV[0];

# Initilize some global variables
my @sequences = ("");	# Array to hold each sequence
my $seqCount = 0;		# Number of sequences found in the file
my $space = '';

# open the file
open(INPUT, "<$fileName") or die "cannot open file $fileName";

# perform sequence calculation...
my $seqNum = 0;
my $header = <INPUT>; # the first line is the header, save just in case
my $line;

while ($line=<INPUT>) {
   chomp($line);
   $line =~ s/\r$//;
   
   # if The first character of the line is '>'
   if(substr($line, 0, 1) eq ">" ) {
	$seqNum++;	
   	$sequences[$seqNum] = "";
   	next; # Start the next iteration of the loop
   }
   
   # store each sequence in the array @sequences
   $sequences[$seqNum] .= $line;
}

$seqCount = $#sequences+1;

# Begin main output
while(1) {
	print("There are a total of $seqCount sequences in the file $fileName\n");

	print("Do you need a space separator (Y/N)? Type 'Q' to exit the program.\n");
	my $in = <STDIN>;
	chomp($in);
	
	if($in eq "Q") {
		exit(); # equivalent to 'break' in C
	} elsif($in eq "Y") {
		$space = ' ';
	} elsif($in eq "N") {
		$space = '';
	} else {
		print("Warning, invalid input!\n");
		next;
	}
	print("Which one do you want to examine?\n");
	my $chosenSeq = <STDIN>;
	chomp($chosenSeq);
	
	# If they input Q here, quit
	if($chosenSeq eq "Q") {
		exit();
	}
	
	# Make sure they input a number
	if(!looks_like_number($chosenSeq)) {
		print("Warning, invalid input!\n");
		next;
	}
	
	# Make sure the sequence exists
	if($chosenSeq > $seqCount || $chosenSeq < 1) {
		print("That sequence does not exist!\n");
		next;
	}
		  
	# Get the current sequence
	my $seq = $sequences[$chosenSeq - 1];
	
	# Figure out the number of lines to print
	my $lineNum = int(length($seq) / 100);
	
	# Check if there needs to be an extra line
	if( length($seq) % 100 != 0) {
		$lineNum++;
	}
	# Get the number of digits
	my $digits = length("".$lineNum);
	my $linePad = "";
	for(my $l = 0; $l < $digits; $l++) {
		$linePad .= " ";	
	}


	# Begin printing the sequence
	print("     ".$linePad.
	      "         1".$space.
		  "         2".$space.
		  "         3".$space.
		  "         4".$space.
		  "         5".$space.
		  "         6".$space.
		  "         7".$space.
		  "         8".$space.
		  "         9".$space.
		  "        10\n");
		  
	print("Line".$linePad." ".
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890".$space.
		  "1234567890\n");

	my $indent = "    ";
	for(my $i = 1; $i <= $lineNum; $i++) {
		my $paddingLen = $digits - length("".$i);
		my $padding = "";
		for(my $l = 0; $l < $paddingLen; $l++) {
			$padding .= " ";	
		}
		print($indent.$padding."$i ");
		
		# $k starting point is 100 times the current line number - 1. 
		# The subtraction ensures that $k starts at 0.
		# Loop goes until the next 100 characters have been processed
		for(my $k = ($i - 1) * 100; $k < 100 * $i; $k+=10) {
			if($k > length($seq)) {
				last;
			}
			print(substr($seq, $k, 10).$space);
		}
		print("\n");
	}
	
	# Print out the number of nucleotides
	nucleotideCounting($seq);
}

# Counts the nucleotides in a given sequence
sub nucleotideCounting {
	my $seq = shift;
	my $A = 0;
	my $T = 0;
	my $G = 0;
	my $C = 0;
	my $N = 0;
	my $other = 0;
	my $nucleotide = "";
	
	for(my $i = 0; $i < length($seq); $i++) {
		$nucleotide = substr($seq, $i, 1);
		
		if($nucleotide eq "A") {
			$A++;
		} 
		elsif ($nucleotide eq "T") {
			$T++;	
		}
		elsif ($nucleotide eq "G") {
			$G++;
		}
		elsif ($nucleotide eq "C") {
			$C++;
		}
		elsif ($nucleotide eq "N") {
			$N++;
		}
		else {
			$other++;
		}
	}
	print("The nucleotide counts:\n", 
		"A=".$A."\n", 
		"T=".$T."\n", 
		"G=".$G."\n", 
		"C=".$C."\n", 
		"N=".$N."\n", 
		"Other=".$other."\n",);
}

# Executed when exit() is called
sub END {
	print("Exiting program\n");
}

