#!usr/bin/perl -w
use strict;
use GeneList;
use SeqAnalysis;
use Bio::SeqIO;

# File names
my $file1 = "";
my $file2 = "";
my $file3 = "";

# File content arrays
my @file1_lines = ();
my @file2_lines = ();
my @file3_lines = ();

# If no params given
if($#ARGV < 1) {
	die "Wrong parameter!\nUsage: perl loomisdf_a3.pl File1 File2 File3\n";
}

# if too many args
if($#ARGV > 2) {
	die "Too many args!\nUsage: perl loomisdf_a3.pl File1 File2 File3\n";
}

# Get cmdline parameters
$file1 = $ARGV[0];
$file2 = $ARGV[1];
$file3 = $ARGV[2];

# create first object
my $object1 = GeneList->new( -gene_list_one=>$file1, -gene_list_two=>$file2 );

# get the commonlist, unique list 1, unique list 2
my $common_ref = $object1->getCommonList();
my $unique1_ref = $object1->getUnique1List();
my $unique2_ref = $object1->getUnique2List();

# set up hashes from hashref
my %common_hash = %$common_ref;
my %unique1_hash = %$unique1_ref;
my %unique2_hash = %$unique2_ref;
my %sequences;

# use SeqIO to extract gene sequences
my $stream = Bio::SeqIO->new(-file => $file3,
                             -format => 'fasta');

while (my $seq_objt=$stream->next_seq()) {
    my $seq_name=$seq_objt->display_id();
    my $seq_desc=$seq_objt->desc();
    my $seq_base=$seq_objt->seq();
	my $key = $seq_name." ".$seq_desc;
	$sequences{$key} = $seq_base;
	#print "key=($key)\n";
}

# Begin main output
###################
print "Comparison results:\n\t+ means up-regulated gene\n\t- means down-regulated gene\n\n";

print "[1] Common gene set for 2 files: $file1, $file2\n";
foreach my $key (sort(keys(%common_hash))) {
	my $val = $common_hash{$key};
	print "$key $val\n";
}

print "[2] Gene Set unique for 1 file: $file1\n";
foreach my $key (sort(keys(%unique1_hash))) {
	my $val = $unique1_hash{$key};
	print "$key=$val\n";
}

print "[3] Gene Set unique for 1 file: $file2\n";
foreach my $key (sort(keys(%unique2_hash))) {
	my $val = $unique2_hash{$key};
	print "$key=$val\n";
}

print "\n";
print "Which gene set would you like to examine?\n>";
my $seqname = <STDIN>;
chomp($seqname);

# exit if sequence does not exist
if(!exists($sequences{$seqname})) {
	die "sequence does not exist\n";
}

# get the sequence
my $seq = $sequences{$seqname};

# create the analysis object
my $object2=SeqAnalysis->new(-seq_name=>$seqname, -sequence=>$seq);

# Print with spacer
$object2->printWithSpacer();
print "\n";

# Print the length of the sequence
print "Sequence length: ".length($seq)."\n\n";

# Print the nucleotide counts
my ($a, $t, $g, $c, $n) = $object2->nucleotideCounter();
print "Nucleotide Counts: A=$a T=$t G=$g C=$c Other=$n\n\n";

# Print the GC Content
my $gc_content = $object2->GCContent();
print "GC Content: $gc_content\n\n";

# print the enzymes
$object2->detectEnzyme();
print "\n";

# Print the poly A signals
$object2->polyA_signal();
print "\n";

# Print the motifs
my $hashref = $object2->detectMotif('GAATCC', 'GAATGG', 'GAACC');
my %motif_hash = %$hashref;
print "Detection of motifs: ('GAATCC', 'GAATGG', GAACC')\n\n";
print "Motif     Start\n";
foreach my $key (keys(%motif_hash)) {
	print $key."    ".$motif_hash{$key}."\n";
}







