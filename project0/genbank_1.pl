#!/usr/bin/perl -w
# FileName=genbank_1.pl
use strict;
use Bio::SeqIO;
use Bio::DB::GenBank;

my  $gb = new Bio::DB::GenBank();
# this returns a Seq object :
my  $seq1 = $gb->get_Seq_by_id('308736933'); #('MUSIGHBA1');
my  $seq2 = $gb->get_Seq_by_acc('FW391231.1'); #('AF303112');

my  $seq_base = $seq2->seq();
my  $seq_name = $seq2->display_id();
my  $seq_desc = $seq2->desc();             
print "seq_name($seq_name),seq_desc($seq_desc),seq_base($seq_base)\n";

