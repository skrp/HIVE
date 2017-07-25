sub regx
{
	my ($i) = @_;
	open(my $fh, '<', $i); 
	open(my $mfh, '<', $PATH);
	my @i = readline $fh; chomp @i;
	my @master = readline $mfh; chomp @master;
	foreach (@i)
		{ print $Lfh "no $_\n" unless any { /$_/ } @master; }
	$YAY++;
}
