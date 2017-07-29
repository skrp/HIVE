########################
# CHATETTE - log updater

sub fuk_log
{
	while (1)
	{
		my ($Tfh, \@new_items) = @_;
		printf $Tfh @new_items;
		`scp $tmp $server:$PATH/work/$tmp`;
		sleep 60;
	}
}
sub key_up
{
  sleep 60;
  my $key;
  read($Kfh, $key, $OFFSET);
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
