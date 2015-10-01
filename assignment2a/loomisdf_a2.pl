#!usr/bin/perl -w
use strict;
use Venn::Chart;

my $venn_chart = Venn::Chart->new(400, 400) or die("error:$!");

# File names
my $file1 = "";
my $file2 = "";
my $file3 = "";

# File content arrays
my @file1_lines = ();
my @file2_lines = ();
my @file3_lines = ();

# File hashes
my %file1_hash;
my %file2_hash;
my %file3_hash;

# Boolean for knowing if there are 3 files
my $has3Files = 0;

# If no params given
if($#ARGV < 1) {
	die "Wrong parameter!\nUsage: perl loomisdf_a2.pl File1 File2 File3\n";
}
$file1 = $ARGV[0];
$file2 = $ARGV[1];

# If there is a third file
if($#ARGV == 2) {
	$file3 = $ARGV[2];
	$has3Files = 1;
}

print "file1=($file1) file2=($file2) file3=($file3)\n";

#Open the files
open(FILE1, "<$file1") or die "cannot open $file1 for processing!\n";
@file1_lines = <FILE1>;
open(FILE2, "<$file2") or die "cannot open $file2 for processing!\n";
@file2_lines = <FILE2>;
if($has3Files) {
	open(FILE3, "<$file3") or die "Cannot open $file3 for processing!\n";
	@file3_lines = <FILE3>;
}

#Extract the file contents into a corresponding hash
extractContents(\%file1_hash, @file1_lines);

extractContents(\%file2_hash, @file2_lines);

if($has3Files) {
	extractContents(\%file3_hash, @file3_lines);
}

print "Comparison results:\n\t+ means up-regulated gene\n\t- means down-regulated gene\n";
# find the difference between the hashes which means the values unique to each hash will be left over
my @file1_unique = ();
my @file2_unique = ();
my @file3_unique = ();

if($has3Files) {
	# TODO need to change these to diff(diff(A, B), C);
	@file1_unique = diff(\%file1_hash, \%file2_hash, \%file3_hash);
	@file2_unique = diff(\%file2_hash, \%file1_hash, \%file3_hash);
	@file3_unique = diff(\%file3_hash, \%file1_hash, \%file2_hash);
} else {
	@file1_unique = diff(\%file1_hash, \%file2_hash); # file1 - file2
	@file2_unique = diff(\%file2_hash, \%file1_hash); # file2 - file1
}

# MAIN OUTPUT
#############
my @intersect = ();

if($has3Files) {
	@intersect = intersect(\%file1_hash, \%file2_hash, \%file3_hash);
	print "[1] Common gene set for 3 files: $file1, $file2, and $file3\n";
	foreach my $key (sort(@intersect)) {
		print "$key $file1=$file1_hash{$key} $file2=$file2_hash{$key} $file3=$file3_hash{$key}\n";
	}

	@intersect = ();
	@intersect = intersect(\%file1_hash, \%file2_hash);
	print "[2] Common gene set for 2 files: $file1 and $file2\n";
	foreach my $key (sort(@intersect)) {
		print "$key $file1=$file1_hash{$key} $file2=$file2_hash{$key}\n";
	}

	@intersect = ();
	@intersect = intersect(\%file1_hash, \%file3_hash);
	print "[3] Common gene set for 2 files: $file1 and $file3\n";
	foreach my $key (sort(@intersect)) {
		print "$key $file1=$file1_hash{$key} $file3=$file3_hash{$key}\n";
	}

	@intersect = ();
	@intersect = intersect(\%file2_hash, \%file3_hash);
	print "[4] Common gene set for 2 files: $file2 and $file3\n";
	foreach my $key (sort(@intersect)) {
		print "$key $file2=$file2_hash{$key} $file3=$file3_hash{$key}\n";
	}

	#print out the unique values
	print "[5] Gene Set unique for 1 file: $file1\n";
	foreach my $key (sort(@file1_unique)) {
		print "$key=$file1_hash{$key}\n";
	}

	print "[6] Gene Set unique for 1 file: $file2\n";
	foreach my $key (sort(@file2_unique)) {
		print "$key=$file2_hash{$key}\n";
	}

	print "[7] Gene Set unique for 1 file: $file3\n";
	foreach my $key (sort(@file3_unique)) {
		print "$key=$file3_hash{$key}\n";
	}
} else {
	@intersect = ();
	@intersect = intersect(\%file1_hash, \%file2_hash);
	print "[1] Common gene set for 2 files: $file1 and $file2\n";
	foreach my $key (sort(@intersect)) {
		print "$key $file1=$file1_hash{$key} $file2=$file2_hash{$key}\n";
	}

	print "[2] Gene Set unique for 1 file: $file1\n";
	foreach my $key (sort(@file1_unique)) {
		print "$key=$file1_hash{$key}\n";
	}

	print "[3] Gene Set unique for 1 file: $file2\n";
	foreach my $key (sort(@file2_unique)) {
		print "$key=$file2_hash{$key}\n";
	}
}

# FUNCTIONS
###########

# Takes the difference between two or three hashes and returns it as an array
sub diff {
	my ($href1, $href2, $href3) = @_;
	#my %hash = map{$_ => 1} @$href1;
	if(defined($href3)) {
		#TODO this code is very close
		my @list1 = sort(keys(%$href1));
		my @list2 = sort(keys(%$href2));
		my @list3 = sort(keys(%$href3));
		my @unique = ();
		foreach my $i (@list1) {
			my $isUnique = 1;
			foreach my $k (@list2) {
				if($i eq $k) {
					$isUnique = 0;
				}
			}
			foreach my $j (@list3) {
				if($i eq $j) {
					$isUnique = 0;
				}
			}
			if($isUnique) {
				push(@unique, $i);
			}
		}
		return @unique;
	}
	return grep(!defined %$href2->{$_}, keys(%$href1)); # href1 - href2
}

# Takes two, or three hashes as input and returns an array of their intersection
sub intersect {
	my ($href1, $href2, $href3) = @_;
	my @intersect = grep( %$href1->{$_}, keys(%$href2));
	if(defined($href3)) {
		@intersect = grep( %$href3->{$_}, @intersect);
	}
	return @intersect;
}

sub extractContents {
	my ($href, @lines) = @_;
	#print "number of genes = $#lines\n";
	for(my $i = 1; $i <= $#lines; $i++) {
		chomp($lines[$i]);
		#print "($i)($lines[$i])\n";

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
		#print "($i)($geneID)($exp)\n";
		$href->{$geneID} = $exp;
	}
}
