#!/usr/local/bin/perl
package HIVE::regx;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(regx)

sub regx
{ # 2 files $i = list $path = master
	my ($i, $path) = shift;
	open(my $fh, '<', $i); open(my $mfh, '<', $path);
	my @i = readline $fh; chomp @i;
	my @master = readline $mfh; chomp @master;
	foreach (@i)
		{ print $Lfh "no $_\n" unless /$_/ @master; }
}
