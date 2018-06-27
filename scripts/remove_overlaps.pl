#!/usr/bin/env perl
## Parse a sorted BED3 file, avoiding overlapping coordinates
use strict;

my $infile = $ARGV[0];
chomp $infile;
open(INFILE, "<$infile");
open(OUTFILE, ">$infile.fixed");

my $last_space = "";
my $last_end = -1;
my $span = 0;
while (<INFILE>) {
  # prepare the current line
  chomp $_;
  my ($cur_space, $cur_start, $cur_end,$alen,$slen,$pident,$rid,$rstart,$rend) = split("\t", $_);
  $cur_start = int($cur_start);
  $cur_end = int($cur_end);
  $cur_end >= $cur_start || die "Start greater than end";
  # if we are on the same chromosome and last end overlaps, reset our start
  if (($cur_space eq $last_space) && ($cur_end <= $last_end)) {
    #$cur_start = $last_end;
  }
  else {
  if (($cur_space eq $last_space) && ($cur_start < $last_end)) {
    $cur_start = $last_end;
    $alen = $cur_end - $cur_start;
  }
  # output adjusted information and reset for next line
  printf OUTFILE ("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", $cur_space, $cur_start, $cur_end,$alen,$slen,$pident,$rid,$rstart,$rend);
  $last_space = $cur_space;
  $last_end = $cur_end;
  }
}
