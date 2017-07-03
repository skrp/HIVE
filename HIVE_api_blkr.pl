#!/usr/local/bin/perl
package HIVE::blkr;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(blkr)

sub blkr
{
	my ($i, $path) = shift;
	my $size = 10000;
	my $st = stat($i);
	my $total = $st->size;
	my $count = $total / $size;
	open(my $ifh, '<', "$i") || die "Cant open $i: $!\n";
	binmode($ifh);
	my $block = 0;
	while (read ($ifh, $block, $size) <= $count)
	{
		my $fh = new_block($path, $block);
		print $fh $block;
		close $fh;
		$count += $size;
	}
	print $Lfh "YAY $i\n";
}
