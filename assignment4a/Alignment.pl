#!/usr/bin/perl -w
use strict;
use SmithWaterman;
use NeedlemanWunsch;

my $seqObj1=SmithWaterman->new(-seq1=>'ATATGGCCAATATTCACATAAATATA',
                      -seq2=>'ATAGGGAAAATATA');
$seqObj1->align();

my $seqObj2=NeedlemanWunsch->new(-seq1=>'ATATGGCCAATATTCACATAAATATA',
                      -seq2=>'ATAGGGAAAATATA');
$seqObj2->align();
