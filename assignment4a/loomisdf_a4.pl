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
my $max_error = shift;  # maximum error bases
my $mode = shift;			# either all or one. print all the best scores, or just one of them
# ===


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
# ===


# user input
# ===================================
print ">";
my $seqname = <STDIN>;
chomp($seqname);
# ===

# create the Align object
# ===================================
my $AlignObject = Align->new(-seq1=>$target_seq,
								-seq2=>$sequences{$seqname},
								-match=>$match,
								-mismatch=>$mismatch,
								-gap=>$gap,
								-min_map_len=>$min_map_length,
								-max_error=>$max_error,
								-mode=>$mode
							);
$AlignObject->printSeqWithSpacer();
$AlignObject->getAlignment();
# ===
