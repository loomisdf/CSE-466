package NeedlemanWunsch;
use strict;
sub new {
  my $class = shift;
  my %args=@_;
  my $self = bless {}, $class;
  foreach my $key (keys %args)
  {
    my $value=$args{$key};
    $self->{$key}=$value;
  }
  return $self;
}

sub align {
  my $self=shift;
  my $seq1=$self->{'-seq1'};
  my $seq2=$self->{'-seq2'};
  # scoring scheme
  my $MATCH    =  1; # +1 for letters that match
  my $MISMATCH = -1; # -1 for letters that mismatch
  my $GAP      = -1; # -1 for any gap
  # initialization
  my @matrix;
  $matrix[0][0]{score}   = 0;
  $matrix[0][0]{pointer} = "none";
  for(my $j = 1; $j <= length($seq1); $j++) {
    $matrix[0][$j]{score}   = $GAP * $j;
    $matrix[0][$j]{pointer} = "left";
  }
  for (my $i = 1; $i <= length($seq2); $i++) {
    $matrix[$i][0]{score}   = $GAP * $i;
    $matrix[$i][0]{pointer} = "up";
  }

  # fill
  for(my $i = 1; $i <= length($seq2); $i++) {
    for(my $j = 1; $j <= length($seq1); $j++) {
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
    }
  }
  # trace-back
  my $align1 = "";
  my $align2 = "";
  my $nucl1 = "";
  my $nucl2 = "";
  my $verti = "";
  # start at last cell of matrix
  my $j = length($seq1);
  my $i = length($seq2);

  while (1) {
    last if $matrix[$i][$j]{pointer} eq "none"; # ends at first cell of matrix

    if ($matrix[$i][$j]{pointer} eq "diagonal") {
        $align1 .= substr($seq1, $j-1, 1);
        $align2 .= substr($seq2, $i-1, 1);
        $nucl1=substr($seq1, $j-1, 1);
        $nucl2=substr($seq2, $i-1, 1);
        if($nucl1 eq $nucl2){
        	$verti.="|";
        }else{
        	$verti.=" ";
        }
        $nucl1="";
        $nucl2="";
        $i--;
        $j--;
    }
    elsif ($matrix[$i][$j]{pointer} eq "left") {
        $align1 .= substr($seq1, $j-1, 1);
        $align2 .= "-";
        $verti.=" ";
        $j--;
    }
    elsif ($matrix[$i][$j]{pointer} eq "up") {
        $align1 .= "-";
        $align2 .= substr($seq2, $i-1, 1);
        $verti.=" ";
        $i--;
    }    
  }

  $align1 = reverse $align1;
  $align2 = reverse $align2;
  $verti = reverse $verti;
  print "$align1\n";
  print "$verti\n";
  print "$align2\n";
}
1;
