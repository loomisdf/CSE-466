package GeneList;
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

# returns the common genes from two lists
sub getCommonList {
	my $self = shift;
	my $file1 = $self->{'-gene_list_one'};
	my $file2 = $self->{'-gene_list_two'};

	my @file1_lines = ();
	my @file2_lines = ();

	my %file1_hash;
	my %file2_hash;

	open(FILE1, "<$file1") or die "cannot open $file1 for processing!\n";
	@file1_lines = <FILE1>;
	open(FILE2, "<$file2") or die "cannot open $file2 for processing!\n";
	@file2_lines = <FILE2>;

	extractContents(\%file1_hash, @file1_lines);
	extractContents(\%file2_hash, @file2_lines);

	my @intersect = intersect(\%file1_hash, \%file2_hash);
 	my %common = map { $_ => 1 } @intersect;
	foreach my $key (keys(%common)) {
		$common{$key} = "$file1=".$file1_hash{$key}." $file2=".$file2_hash{$key};
	}
	return \%common;
}

#returns the unique genes from list one
sub getUnique1List {
	my $self = shift;
	my $file1 = $self->{'-gene_list_one'};
	my $file2 = $self->{'-gene_list_two'};

	my @file1_lines = ();
	my @file2_lines = ();

	my %file1_hash;
	my %file2_hash;

	open(FILE1, "<$file1") or die "cannot open $file1 for processing!\n";
	@file1_lines = <FILE1>;
	open(FILE2, "<$file2") or die "cannot open $file2 for processing!\n";
	@file2_lines = <FILE2>;

	extractContents(\%file1_hash, @file1_lines);
	extractContents(\%file2_hash, @file2_lines);

	my @file1Unique = diff(\%file1_hash, \%file2_hash);
	my %unique = map { $_ => 1 } @file1Unique;
	foreach my $key (keys(%unique)) {
		$unique{$key} = $file1_hash{$key};
	}
	return \%unique;
}

# returns the unique genes from list two
sub getUnique2List {
	my $self = shift;
	my $file1 = $self->{'-gene_list_one'};
	my $file2 = $self->{'-gene_list_two'};

	my @file1_lines = ();
	my @file2_lines = ();

	my %file1_hash;
	my %file2_hash;

	open(FILE1, "<$file1") or die "cannot open $file1 for processing!\n";
	@file1_lines = <FILE1>;
	open(FILE2, "<$file2") or die "cannot open $file2 for processing!\n";
	@file2_lines = <FILE2>;

	extractContents(\%file1_hash, @file1_lines);
	extractContents(\%file2_hash, @file2_lines);

	my @file2Unique = diff(\%file2_hash, \%file1_hash);
	my %unique = map { $_ => 1 } @file2Unique;
	foreach my $key (keys(%unique)) {
		$unique{$key} = $file2_hash{$key};
	}
	return \%unique;
}

# Takes the difference between two or three hashes and returns it as an array
sub diff {
	my ($href1, $href2, $href3) = @_;
	#my %hash = map{$_ => 1} @$href1;
	if(defined($href3)) {
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
	return grep(!defined $href2->{$_}, keys(%$href1)); # href1 - href2
}

# Takes two, or three hashes as input and returns an array of their intersection
sub intersect {
	my ($href1, $href2, $href3) = @_;
	my @intersect = grep( $href1->{$_}, keys(%$href2));
	if(defined($href3)) {
		@intersect = grep( $href3->{$_}, @intersect);
	}
	return @intersect;
}

# Extracts the lines of file into a hash reference
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
1;
