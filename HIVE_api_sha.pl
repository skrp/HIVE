#!/usr/local/bin/perl
package HIVE::sha;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(fsha bsha);

sub fsha
{
	my $i = shift;
	my ($sha) = file_digest($i);
	if ($sha ne $i)
		{ print $Lfh "ERK! $file ne $sha\n"; }
	print $Lfh "YAY $i\n";
}
sub bsha
{
	my $block = shift;
	my $bsha = sha256_hex($block)
	return $bsha;
}
