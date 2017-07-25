use Archive::Any
sub xtrac
{
	my ($i) = @_;
	my $archive = Archive::Any->new($i);
	if ($archive->is_naughty)
		{ print $Lfh "ALERT xtrac naughty $i"; next; }
	my @files = $archive->files; print $Lfh @files;
	$archive->extract($DUMP);
	XS($DUMP, $PATH) && rmtree($DUMP);
	mkdir $DUMP;
	print $Lfh "YAY $i\n"; $YAY++;
}
