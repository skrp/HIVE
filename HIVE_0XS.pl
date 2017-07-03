#!/usr/local/bin/perl
package HIVE::XS;
use File::LibMagic;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(XS file_digest xsname xspath xssize file_mime_encoding)

sub XS
{
	my ($target, $dump) = shift;
	if (not defined $target) { die "usage: TARGET ARGV[0] & dump argv[1]"; }
	if (not defined $dump) { die "usage: target argv[0] & DUMP ARGV[1]"; }
	my $rule = File::Find::Rule->file()->start($target);
	my $magic = File::LibMagic->new();
	while (defined( my $file = $rule->match))
	{
		my ($sha) = file_digest($file) or die "couldn't sha $file";
		File::Copy::copy($file, "$dump/pool/$sha");
		my $cur = "$dump/g/g$sha";
		open(my $fh, '>>', $cur) or die "Meta File Creation FAIL $file";
		printf $fh "%s\n%s\n%s\n%s\n",
			xsname($file),
			xspath($file),
			xssize($file),
			file_mime_encoding($file);
	}
}
sub file_digest {
	my ($filename) = @_;
	my $digester = Digest::SHA->new('sha256');
	$digester->addfile( $filename, 'b' );
	return $digester->hexdigest;
}
sub xsname {
	my ($filename) = @_;
	$filename =~ s#^.*/##;
	return $filename;
}
sub xspath {
	my ($filename) = @_;
	$filename =~ s#/#_#g;
	return $filename;
}
sub file_mime_encoding {
	my ($filename) = @_;
	my $info = $magic->info_from_filename($filename);
	my $des = $info->{description};
	$des =~ s#[/ ]#.#g;
	$des =~ s/,/_/g;
	my $md = $info->{mime_type};
	$md =~ s#[/ ]#.#g;
	my $enc = sprintf("%s %s %s", $des, $md, $info->{encoding});
	return $enc;
}
sub xssize {
	my $size = [ stat $_[0] ]->[7];
	return $size;
}
