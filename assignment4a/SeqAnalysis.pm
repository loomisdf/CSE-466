package SeqAnalysis;
use strict;

sub new {
	my $class = shift;
	my %args = @_;
	my $self = bless {}, $class;
	foreach my $key (keys %args) {
		my $value = $args{$key};
		$self->{$key} = $value;
	}
	return $self;
}

# Print out the sequence, nice and formatted
sub printWithSpacer {
	my $self = shift;
	my $seq = $self->{'-sequence'};
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

# count the number of times a, t, g, c, and other nucleotides appear in the sequence
sub nucleotideCounter {
	my $self = shift;
	my $seq = $self->{'-sequence'};
	my ($a, $t, $g, $c, $n) = (0, 0, 0, 0, 0);
	$a = () = $seq =~ /A/g;
	$t = () = $seq =~ /T/g;
	$g = () = $seq =~ /G/g;
	$c = () = $seq =~ /C/g;
	$n = length($seq) - $a - $t - $g - $c;
	return ($a, $t, $g, $c, $n);
}

# find the GC content of the sequence
sub GCContent {
	my $self = shift;
	my $seq = $self->{'-sequence'};
	my ($a, $t, $g, $c, $n) = $self->nucleotideCounter();
	my $gc_content = ($g + $c) / ($a + $t + $c + $g + $n);
	return $gc_content;
}

# detect the enzymes in the sequence
sub detectEnzyme {
	my $self = shift;
	my $seq = $self->{'-sequence'};
	my ($BclI, $BfmI, $EcoRI, $Cac8I) = ('TGATCA', 'CTGCAG', 'GAATTC', 'GCAAGC');
	my ($IUPAC_1, $IUPAC_2, $IUPAC_3, $IUPAC_4) = ('TGATCA', 'CTRYAG', 'GAATTC', 'GCNNGC');
	my ($ALT_1, $ALT_2, $ALT_3, $ALT_4) = ('TGATCA', 'CT[AG][CT]AG', 'GAATTC', 'GC[ATGC][ATGC]GC');
	my ($pos_1, $pos_2, $pos_3, $pos_4) = (0, 0, 0, 0);

	if($seq =~ m/$ALT_1/g) {
		$pos_1 = pos($seq) - length($ALT_1);
	}
	else {
		$pos_1 = 'N/A';
	}

	if($seq =~ m/$ALT_2/g) {
		$pos_2 = pos($seq) - 6;
	}
	else {
		$pos_2 = 'N/A';
	}

	if($seq =~ m/$ALT_3/g) {
		$pos_3 = pos($seq) - length($ALT_3);
	}
	else {
		$pos_3 = 'N/A';
	}

	if($seq =~ m/$ALT_4/g) {
		$pos_4 = pos($seq) - 6;
	}
	else {
		$pos_4 = 'N/A';
	}

	print "Restriction sites:\n\n";
	print "Name  Pos   Seq     IUPAC   ALT\n";
	print "BclI  $pos_1   $BclI  $IUPAC_1  $ALT_1\n";
	print "BfmI  $pos_2   $BfmI  $IUPAC_2  $ALT_2\n";
	print "EcoRI $pos_3   $EcoRI  $IUPAC_3  $ALT_3\n";
	print "Cac8I $pos_4   $Cac8I  $IUPAC_4  $ALT_4\n"; 
}

# Look for the poly(A) signal (AATAA)
sub polyA_signal {
	my $self = shift;
	my $seq = $self->{'-sequence'};
	my $signal = 'AATAA';
	my $indent1 = '      ';
	my $indent2 = '           ';
	my $num = 1;
	
	# layout
	print "Detection of poly(A) signal ($signal):\n\n";
	print "No.    Start            End\n";

	# search for the signal
	while($seq =~ m/$signal/g) {
		# Get the end position
		my $end = pos($seq);

		# Get the start position
		my $start = $end - length($signal);

		# set up the correct indentaion
		if(length("".$start) == 2) {
			$indent2 .= "    ";
		}
		elsif (length("".$start) == 1) {
			$indent2 .= "     ";
		}
		else {
			$indent2 .= "   ";
		}

		# Print to the screen
		print $num.$indent1.$start.$indent2.$end."\n";
		
		# reset the indentation
		$indent2 = '           ';
		$num++;
	}
}

# detect a list of motifs in the sequence
sub detectMotif {
	my $self = shift;
	my $seq = $self->{'-sequence'};
	my @motifs = @_;
	my %hash;
	foreach my $motif ( @motifs ) {
		if($seq =~ m/$motif/g) {
			$hash{$motif} = pos($seq);
		}
	}
	return \%hash;
}
1;
