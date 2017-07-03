#!/usr/local/bin/perl
package HIVE::slicr;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(slicr)

sub slicr
{
	my ($i, $path) = shift;
	my $st = stat($i);
	my $total = $st->size;
	open(my $ifh, '<', "$i") || die "Cant open $i: $!\n";
	binmode($ifh);
	my $sha = file_digest($i);
	my $block = 0; my $position = 0;
	while ($position < $total)
	{
		my $size = int(rand(99999));
		if ($position + $size >= $total)
			{ $size = $total - $position; }
		read($ifh, $block, $size);
		my $fh = new_block($i, $sha, $path, $block);
		print $fh $block;
		close $fh;
		$count += $size;
	}
	print $Lfh "YAY $i\n";
}
