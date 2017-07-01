#!/usr/local/bin/perl
########################
# API.sha - verify file 
use strict; use warnings;
use Digest::SHA ();
# INPUT ###############
my ($que) = @ARGV;
open(my $qfh, '<', $que);
my @que = readline $qfh; chomp @que;

foreach my $file (@que)
{
    my ($sha) = file_digest($file) or die "couldn't sha $file";
    if ($sha != $file)
      { print $Lfh "ERK! $file != $sha\n"; }
}
########################
# SHA FN
sub file_digest {
    my ($filename) = @_;
    my $digest = Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
