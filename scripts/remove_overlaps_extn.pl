#!/usr/bin/env perl
## Parse a sorted BED3 file, avoiding overlapping coordinates
use strict;

sub max ($$) { $_[$_[0] < $_[1]] }
sub min ($$) { $_[$_[0] > $_[1]] }

my $infile = $ARGV[0];
chomp $infile;
open(INFILE, "<$infile");
open(OUTFILE, ">$infile.fixed");

my $last_space = "";
my $last_rid= "";
my $last_end = -1;
my $span = 0;
my $flen = 0;
my $num_contigs = 0;
while (<INFILE>) {
  # prepare the current line
  chomp $_;
  my ($cur_space, $cur_start, $cur_end,$qlen,$alen,$rid,$rstart,$rend,$rlen,$pident,$e_value,$bitscore) = split("\t", $_);
  $cur_start = min(int($cur_start),int($cur_end));
  $cur_end = max(int($cur_start),int($cur_end));
  
  # Removing overlapping shorter contained alignments.
  if (($cur_space eq $last_space) && ($rid eq $last_rid ) && ($cur_end <= $last_end)) {
    #$cur_start = $last_end;
    #Do nothing
  } 
  else {
  if (($cur_space eq $last_space) && ($rid eq $last_rid ) && ($cur_start < $last_end)) {
    $cur_start = $last_end;
    $flen = $cur_end - $cur_start;
  }
  else { 
    $flen = $alen;
  }
  # output adjusted information and reset for next line
  #printf OUTFILE ("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $cur_space, $cur_start, $cur_end,$alen,$slen,$pident,$rid,$rstart,$rend);
  printf OUTFILE ("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $cur_space, $cur_start, $cur_end,$alen,$flen,$slen,$pident,$rid,$rstart,$rend);
  $last_space = $cur_space;
  $last_end = $cur_end;
  $last_rid = $rid;
  }
}
