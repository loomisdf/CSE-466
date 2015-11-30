package GFF_GTF_Parser;
use strict;
no warnings ('uninitialized', 'substr');
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

my %chromosome_ref=(
'NC_000001.11' => '1',
'NC_000002.12' => '2',
'NC_000003.12' => '3',
'NC_000004.12' => '4',
'NC_000005.10' => '5',
'NC_000006.12' => '6',
'NC_000007.14' => '7',
'NC_000008.11' => '8',
'NC_000009.12' => '9',
'NC_000010.11' => '10',
'NC_000011.10' => '11',
'NC_000012.12' => '12',
'NC_000013.11' => '13',
'NC_000014.9' => '14',
'NC_000015.10' => '15',
'NC_000016.10' => '16',
'NC_000017.11' => '17',
'NC_000018.10' => '18',
'NC_000019.10' => '19',
'NC_000020.11' => '20',
'NC_000021.9' => '21',
'NC_000022.11' => '22',
'NC_000023.11' => 'X',
'NC_000024.10' => 'Y',

);





sub parseFile {
	my $self = shift;
	my $file_name = $self->{'-file_name'};
	my $file_type = $self->{'-file_type'};
	my $file_src = $self->{'-file_src'};
	
	open(FILE1, "<$file_name") or die "cannot open file ($file_name)";
	open(FILE2, ">gene_gtf.txt") or die "cannot create file $!";
	open(FILE3, ">transcript_gtf.txt") or die "cannot create file $!";
    open(FILE4, ">gene_gff.txt") or die "cannot create file $!";
	open(FILE5, ">transcript_gff.txt") or die "cannot create file $!";

	####### Print header
    print FILE2 "Gene_ID\tGene_Name\tGene_Source\tGene_Type\tChromosome\tGene_Strand\tStart\tEnd\n";
	print FILE3 "Transcript_ID\tTranscript_Name\tGene_ID\tGene_Name\tChromosome\tGene_Strand\tStart\tEnd\tTranscript_Source\tTranscript_Type\n";
    print FILE4 "Gene_ID\tGene_Name\tGene_Source\tGene_Type\tChromosome\tGene_Strand\tStart\tEnd\n";
	print FILE5 "Transcript_ID\tTranscript_Name\tGene_ID\tGene_Name\tChromosome\tGene_Strand\tStart\tEnd\tTranscript_source\tTranscript_Type\n";

	my @curr_line;
#################
	if(lc($file_type) eq 'gtf') {
		while (my $line = <FILE1>) {
			chomp($line);
			$line =~ s/\r$//;
			if(substr($line, 0, 1) eq "#") {
				next;
			}

            @curr_line = split(/\s/, $line);
			
			if($curr_line[2] eq 'gene') {
                my $chromosome = $curr_line[0];
                my $gene_id = $curr_line[9];
                   $gene_id=~s/[";]//g;
                my $gene_source = $curr_line[15];
                   $gene_source=~s/[";]//g;
                my $gene_name = $curr_line[13];
                   $gene_name=~s/[";]//g;
                my $gene_strand = $curr_line[6];
                my $gene_type = $curr_line[17];
                   $gene_type=~s/[";]//g;
                my $start = $curr_line[3];
                my $stop = $curr_line[4];
                print FILE2 "$gene_id\t$gene_name\t$gene_source\t$gene_type\t$chromosome\t$gene_strand\t$start\t$stop\n"; 
			}
			
			elsif ($curr_line[2] eq 'transcript') {
				my $chromosome = $curr_line[0];
                my $gene_id = $curr_line[9];
                   $gene_id=~s/[";]//g;
                my $gene_name = $curr_line[17];
                   $gene_name=~s/[";]//g;
                my $gene_strand = $curr_line[6];
                my $start = $curr_line[3];
                my $stop = $curr_line[4];
                my $transcript_id=$curr_line[13];
                   $transcript_id=~s/[";]//g;
                my $transcript_name=$curr_line[23];
                   $transcript_name=~s/[";]//g;                 
                my $transcript_source = $curr_line[25];
                   $transcript_source=~s/[";]//g;
                my $transcript_type=$curr_line[27];
                   $transcript_type=~s/[";]//g;
             
             
                print FILE3 "$transcript_id\t$transcript_name\t$gene_id\t$gene_name\t$chromosome\t$gene_strand\t$start\t$stop\t$transcript_source\t$transcript_type\n"; 
			}
			}
			
		}
	
#######################
	if(lc($file_type) eq 'gff') {
		while (my $line = <FILE1>) {
			chomp($line);
			$line =~ s/\r$//;
			if(substr($line, 0, 1) eq "#") {
				next;
			}

            @curr_line = split(/[\t=:;,]/, $line);
			
		if($curr_line[2] eq 'gene') {
           
                my $chromosome = $curr_line[0];
                   foreach my $key (keys %chromosome_ref){
                   	if ($curr_line[0] eq $key){
                   		$chromosome=~s/$curr_line[0]/$chromosome_ref{$key}/g;
                   	}
                   }
                my $gene_strand = $curr_line[6];
                my $start = $curr_line[3];
                my $stop = $curr_line[4];
                my $gene_source=$curr_line[1];
                my $gene_id='';
                my $gene_name='';
                my $gene_type='';
                   for (my $i=0; $i<$#curr_line; $i++){
                
                	  if ($curr_line[$i] eq 'GeneID'){
                		 $gene_id=$curr_line[$i+1];
                	}
                	  elsif ($curr_line[$i] eq 'gene'){
                		 $gene_name=$curr_line[$i+1];
                	}
                      elsif ($curr_line[$i] eq 'gene_biotype'){
                		 $gene_type=$curr_line[$i+1];
                	}	
                	
                }
               
                print FILE4 "$gene_id\t$gene_name\t$gene_source\t$gene_type\t$chromosome\t$gene_strand\t$start\t$stop\n";
			}
			
		if (($curr_line[2] eq 'transcript') ||  ($curr_line[2] eq 'ncRNA' ) ||  ($curr_line[2] eq 'mRNA') ||  ($curr_line[2] eq 'primary_transcript'))  {
           
                my $chromosome = $curr_line[0];
                    foreach my $key (keys %chromosome_ref){
                   	if ($curr_line[0] eq $key){
                   		$chromosome=~s/$curr_line[0]/$chromosome_ref{$key}/g;
                   	}
                   }
                my $gene_strand = $curr_line[6];
                my $start = $curr_line[3];
                my $stop = $curr_line[4];
                my $transcript_source=$curr_line[1];
                my $gene_id='';
                my $gene_name='';
                my $transcript_id='';
                my $transcript_name='';
                my $transcript_type='';
                
                for (my $i=0; $i<$#curr_line; $i++){
                
                	if ($curr_line[$i] eq 'GeneID'){
                		 $gene_id=$curr_line[$i+1];
                	}
                	elsif ($curr_line[$i] eq 'gene'){
                		 $gene_name=$curr_line[$i+1];
                	}
                	elsif ($curr_line[$i] eq 'transcript_id'){
                		 $transcript_id=$curr_line[$i+1];
                	}
                	elsif ($curr_line[$i] eq 'Name'){
                		 $transcript_name=$curr_line[$i+1];
                	}              	
                	
                    elsif ($curr_line[$i] eq 'gbkey'){
                		 $transcript_type=$curr_line[$i+1];
                	}	
                	
                }
               
             
                print FILE5 "$transcript_id\t$transcript_name\t$gene_id\t$gene_name\t$chromosome\t$gene_strand\t$start\t$stop\t$transcript_source\t$transcript_type\n"; 
			}
			}
			
		}
	

}
1;