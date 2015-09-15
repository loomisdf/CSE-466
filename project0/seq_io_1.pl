#!/usr/bin/perl -w
# FileName=SeqIO.1.pl
use strict;
use Bio::SeqIO;

my $filename=shift;
my $stream = Bio::SeqIO->new(-file => $filename,
                             -format => 'fasta');

my $seq_objt=$stream->next_seq();
my $seq_name=$seq_objt->display_id();
my $seq_desc=$seq_objt->desc(); 
my $seq_base=$seq_objt->seq();           
print "seq_name($seq_name),seq_desc($seq_desc),seq_base($seq_base)\n";