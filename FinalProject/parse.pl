#! usr/bin/perl -w
use strict;
use GFF_GTF_Parser;

my $file_name = shift;
my $file_type = shift;
my $file_src = shift;

my $obj = GFF_GTF_Parser->new( -file_name => $file_name,
								-file_type => $file_type,
								-file_src => $file_src);
$obj->parseFile();