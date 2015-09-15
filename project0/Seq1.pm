package Seq1;
use strict;

sub new {
  my $class = shift;
  my $display_id=shift;
  my $desc=shift;
  my $sequence=shift;
  print "I am inside new() of Sequence.pm\n";
  print "display_id=($display_id)\n";
  print "desc=($desc)\n";
  print "sequence=($sequence)\n";
  my $self = bless {}, $class;
  return $self;
}
1;