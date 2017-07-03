#!/usr/local/bin/perl
package HIVE::vsha;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(vkey)

sub vkey
{
	my ($i, $path) = shift;
	my $ipath = $path.$i;
	my $tmp = "$dump/tmp"; unlink $tmp;
	open($ifh, '<', $ipath);
	open($tfh, '>>', $tmp);
	my @keys = readline $ifh; chomp @keys;
	my $data = 0;
	foreach my $key (@keys)
	{
		open(my $bfh, '<', "$path/sea/$key");
		read($bfh, $data);
		print $tfh $data;
	}
	my $tsha = file_digest($tmp);
	if ($tsha ne $i)
		{ print "FKFK $i ne $tsha\n"; }
}
