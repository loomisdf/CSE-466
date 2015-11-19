package GFF_GTF_Parser;
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

sub parseFile {
	my $self = shift;
	my $file_name = $self->{'-file_name'};
	my $file_type = $self->{'-file_type'};
	my $file_src = $self->{'-file_src'};
	
	open(FILE1, "<$file_name") or die "cannot open file ($file_name)";
	open(FILE2, ">gene.txt") or die "cannot create file ($file_name.txt)";
	open(FILE3, ">transcript.txt") or die "cannot create file ($file_name.txt)";

	# Print header
	print FILE2 "Gene_ID\tGene_Source\tGene_Name\tGene_Strand\tGene_Type\tStart\tStop\n";
	print FILE3 "Gene_ID\tTrans_ID\tGene_Source\tTrans_Source\tTrans_Strand\tGene_Type\tTrans_Type\tStart\tStop\n";

	my @curr_line;

	if(lc($file_type) eq 'gtf') {
		while (my $line = <FILE1>) {
			print "something\n";
			chomp($line);
			$line =~ s/\r$//;
			if(substr($line, 0, 1) eq "#") {
				next;
			}

			@curr_line = split(/[\s+]/, $line);

			if($curr_line[2] eq 'gene') {
				my $gene_id = $curr_line[9];
				my $gene_src = $curr_line[13];
				my $gene_name = 'NULL';
				my $gene_strand = $curr_line[6];
				my $gene_type = $curr_line[15];
				my $start = $curr_line[3];
				my $stop = $curr_line[4];
			
				print FILE2 "$gene_id\t$gene_src\t$gene_name\t$gene_strand\t$gene_type\t$start\t$stop";
			}
			elsif($curr_line[2] eq 'transcript') {
				my $gene_id = 
			}
			last;
		}
	}
}
1;