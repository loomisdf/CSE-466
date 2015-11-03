#! usr/bin/perl -w
use strict;
use Align;
use Bio::SeqIO;

# Variables
# =============================
my %sequences; 				# sequence hash
my $file = shift; 			# filename
my $target_seq = shift; 	# sequence to match against
my $match = shift;			# match score
my $mismatch = shift;		# mismatch score
my $gap = shift;			# gap score
my $min_map_length = shift; # minimum mapped length in the long sequence
my $max_err_bases = shift;  # maximum error bases
my $mode = shift;			# either all or one. print all the best scores, or just one of them
# =============================


# use SeqIO to extract gene sequences
# ================================================
my $stream = Bio::SeqIO->new(-file => $file,
                             -format => 'fasta');

while (my $seq_objt=$stream->next_seq()) {
    my $seq_name=$seq_objt->display_id();
    my $seq_desc=$seq_objt->desc();
    my $seq_base=$seq_objt->seq();
	my $key = $seq_name." ".$seq_desc;
	$sequences{$key} = $seq_base;
}
# ================================================


# user input
# ===================================
print ">";
my $seqname = <STDIN>;
chomp($seqname);

printWithSpacer($sequences{$seqname});
# ===================================


# print scoring info
# ===================================
print "[Scoring schema]: match=$match, mismatch=$mismatch, gap=$gap\n";
print "[Search Target]: $target_seq\n";
print "[Minimum mapped length]: $min_map_length\n";
print "[The highest score]:\n";
print "[The alignments with the highest score]:\n";
# ===================================

# Print out the sequence, nice and formatted
sub printWithSpacer {
	my $seq = shift;;
	my $space = " ";
	# Figure out the number of lines to print
	my $lineNum = int(length($seq) / 100);

	# Check if there needs to be an extra line
	if( length($seq) % 100 != 0) {
		$lineNum++;
	}

	# Get the number of digits
	my $digits = length("".$lineNum);

	# Figure out padding for line and necleotide position
	my $linePad = " ";

	# Begin printing the sequence
	print("    ".$linePad.
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

	print("Line".$linePad.
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

	my $indent = " ";
	for(my $i = 1; $i <= $lineNum; $i++) {
		my $padding = "";
		if($i < 10) {
			$padding .= "  ";
		} elsif ($i >= 10 && $i < 100) {
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
}
