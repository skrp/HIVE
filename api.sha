sub sha
{
	my ($i) = @_;
	my ($sha) = file_digest($i);
	if ($sha ne $i)
		{ print $Lfh "ERK $i ne $sha\n"; }
	$YAY++;
}
