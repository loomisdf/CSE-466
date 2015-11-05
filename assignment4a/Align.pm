package Align;
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

sub getAlignment {
	my $self = shift;
	my $seq1 = $self->{'-seq1'};
	my $seq2 = $self->{'-seq2'};
	# scoring
	my $MATCH = $self->{'-match'};
	my $MISMATCH = $self->{'-mismatch'};
 	my $GAP = $self->{'-gap'};

	my $min_map_length = $self->{'-min_map_len'};
	my $max_error = $self->{'-max_error'};
	my $mode = $self->{'-mode'};

	# initialization
	my @matrix;
	$matrix[0][0]{score}   = 0;
	$matrix[0][0]{pointer} = "none";
	for(my $j = 1; $j <= length($seq1); $j++) {
    	$matrix[0][$j]{score}   = 0;
    	$matrix[0][$j]{pointer} = "none";
  	}
  	for (my $i = 1; $i <= length($seq2); $i++) {
    	$matrix[$i][0]{score}   = 0;
    	$matrix[$i][0]{pointer} = "none";
  	}

  	# fill
  	my $max_i     = 0;
  	my $max_j     = 0;
  	my $max_score = 0;

	my $seq2_len = length($seq2);
	my $seq1_len = length($seq1);
	my $startPos = 1;

  	for(my $i = $startPos; $i <= $seq1_len; $i++) {
		for(my $j = 1; $j <= $seq1_len; $j++) {
	    	my ($diagonal_score, $left_score, $up_score);
        
        	# calculate match score
        	my $letter1 = substr($seq1, $j-1, 1);
        	my $letter2 = substr($seq2, $i-1, 1);
        	if ($letter1 eq $letter2) {
            	$diagonal_score = $matrix[$i-1][$j-1]{score} + $MATCH;
        	}
        	else {
            	$diagonal_score = $matrix[$i-1][$j-1]{score} + $MISMATCH;
        	}
        
        	# calculate gap scores
        	$up_score   = $matrix[$i-1][$j]{score} + $GAP;
        	$left_score = $matrix[$i][$j-1]{score} + $GAP;
        
        	if ($diagonal_score <= 0 and $up_score <= 0 and $left_score <= 0) {
           		$matrix[$i][$j]{score}   = 0;
				$matrix[$i][$j]{pointer} = "none";
				next; # terminate this iteration of the loop
        	}
        
        	# choose best score
			if ($diagonal_score >= $up_score) {
            	if ($diagonal_score >= $left_score) {
                	$matrix[$i][$j]{score}   = $diagonal_score;
                	$matrix[$i][$j]{pointer} = "diagonal";
            	}
            	else {
                	$matrix[$i][$j]{score}   = $left_score;
                	$matrix[$i][$j]{pointer} = "left";
            	}
        	} else {
            	if ($up_score >= $left_score) {
                	$matrix[$i][$j]{score}   = $up_score;
                	$matrix[$i][$j]{pointer} = "up";
            	}
            	else {
                	$matrix[$i][$j]{score}   = $left_score;
                	$matrix[$i][$j]{pointer} = "left";
            	}
        	}
        
        	# set maximum score
        	if ($matrix[$i][$j]{score} > $max_score) {
            	$max_i     = $i;
            	$max_j     = $j;
            	$max_score = $matrix[$i][$j]{score};
        	}
		}
	}
	print "\n";
	print "  ";
	for(my $i = 1; $i <= length($seq1); $i++) {
		print substr($seq1, $i-1, 1)."  ";
	}
	print "\n";
	for(my $i = 1; $i <= length($seq1); $i++) {
		print substr($seq2, $i-1, 1);
		for(my $j = 1; $j <= length($seq1); $j++) {
			print "[".$matrix[$i][$j]{score}."]";
		}
		print "\n";
	}
	print "\n";

  	# trace-back
  	my $align1 = "";
  	my $align2 = "";
  	my $nucl1 = "";
  	my $nucl2 = "";
  	my $verti = "";
	my $bot = "";
  	my $j = $max_j;
  	my $i = $max_i;

	while (1) {
    	last if $matrix[$i][$j]{pointer} eq "none";
    
    	if ($matrix[$i][$j]{pointer} eq "diagonal") {
        	$align1 .= substr($seq1, $j-1, 1);
        	$align2 .= substr($seq2, $i-1, 1);
        	$nucl1=substr($seq1, $j-1, 1);
        	$nucl2=substr($seq2, $i-1, 1);
        	if($nucl1 eq $nucl2){
        		$verti.="|";
				$bot .= "m";
        	}else{
        		$verti.=" ";
        	}
        	$nucl1="";
        	$nucl2="";
        	$i--; $j--;
    	}
    	elsif ($matrix[$i][$j]{pointer} eq "left") {
        	$align1 .= substr($seq1, $j-1, 1);
        	$align2 .= "-";
        	$verti.=" ";
        	$j--;
			$bot .= "I";
    	}
    	elsif ($matrix[$i][$j]{pointer} eq "up") {
        	$align1 .= "-";
        	$align2 .= substr($seq2, $i-1, 1);
        	$verti.=" ";
        	$i--;
			$bot .= "D";
    	}   
	}

  	$align1 = reverse $align1;
  	$align2 = reverse $align2;
  	$verti = reverse $verti;
  	print "$align1\n";
  	print "$verti\n";
  	print "$align2\n";

	# print scoring info
	# ===================================
	print "[Scoring schema]: match=$MATCH, mismatch=$MISMATCH, gap=$GAP\n";
	print "[Search Target]: $seq1\n";
	print "[Minimum mapped length]: $min_map_length\n";
	print "[The highest score]:\n";
	print "[The alignments with the highest score]:\n";
	# ===================================
}

# Print out the sequence, nice and formatted
sub printSeqWithSpacer {
	my $self = shift;
	my $seq = $self->{'-seq2'};
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
1;
