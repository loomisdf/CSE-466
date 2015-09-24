#!usr/bin/perl -w
use strict;
use Venn::Chart;

# File names
my $file1 = "";
my $file2 = "";
my $file3 = "";

# File content arrays
my @file1Lines = ();
my @file2Lines = ();
my @file3Lines = ();

# File hashes
my %file1Hash;
my %file2Hash;
my %file3Hash;


# If no params given
if($#ARGV < 1) {
	die "Wrong parameter!\nUsage: perl loomisdf_a2.pl File1 File2 File3\n";
}
$file1 = $ARGV[0];
$file2 = $ARGV[1];

# If there is a third file
if($#ARGV == 2) {
	$file3 = $ARGV[2];
}

print "file1=($file1) file2=($file2) file3=($file3)\n";

#Open the files
open(FILE1, "<$file1") or die "cannot open $file1 for processing!\n";
@file1Lines = <FILE1>;
open(FILE2, "<$file2") or die "cannot open $file2 for processing!\n";
@file2Lines = <FILE2>;
if($file3 ne "") {
	open(FILE3, "<$file3") or die "Cannot open $file3 for processing!\n";
	@file3Lines = <FILE3>;
}

#Extract the file contents
extractContents(\%file1Hash, @file1Lines);

while (my ($key, $val) = each(%file1Hash) ) {
	print "$key => $val\n";
}

sub extractContents {
	my ($href, @lines) = @_;
	for(my $i = 1; $i <= $#lines; $i++) {
		chomp($lines[$i]);
		print "($i)($lines[$i])\n";

		my @tmpArray = split('\t', $lines[$i]);
		my $geneID = $tmpArray[0];
		my $exp = '';

		if ($tmpArray[1] > $tmpArray[2]) {
			$exp = '-';
		}
		elsif ($tmpArray[1] < $tmpArray[2]) {
			$exp = '+';
		}
		else {
			$exp = '0';
		}
		print "($i)($geneID)($exp)\n";
		$href->{$geneID} = $exp;
	}
}
