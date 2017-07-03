#!/usr/local/bin/perl
package HIVE::xtrac;
use strict; use warnings;
use Exporter; use Archive::Any ();
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(xtrac)

sub xtrac
{
	my ($i, $path) = shift;
	my $archive = Archive::Tar->new($i);
	if ($archive->is_naughty)
		{ print $Lfh "ALERT xtrac naughty $i"; next; }
	my @files = $archive->files; print $Lfh @files;
	$archive->extract($dump);
	XS($dump, $path);
	print $Lfh "YAY $i\n";
}
