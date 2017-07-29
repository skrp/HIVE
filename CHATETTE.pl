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
  my ($offset) = @_;
  my $key;
  read($Kfh, $key, $offset);
  return $key;
}
