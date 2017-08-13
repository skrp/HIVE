const my $SIZE => 128000;

sub blkr
{
	my ($i) = @_;
	my $block = 0;
	my $ipath = $PATH.'pool/'.$i;
	open(my $ifh, '<', "$ipath") || print $Lfh "Cant open $i: $!\n";
	binmode($ifh);
	
	while (read($ifh, $block, $SIZE))
	{
		my $bsha = sha256_hex($block);
		my $bname = $PATH.'sea/'.$bsha;
		open(my $fh, '>', "$bname");
		binmode($fh);
		print $fh $block;
		key($i, $bsha);
	}
	$YAY++;
}
sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $PATH.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
}
