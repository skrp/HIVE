use LWP::UserAgent;
use LWP::Protocol::https;
sub neo
{
	my ($point) = @_;
	sleep 5;
	my $ua = uagent();
	my $url = $NEO.$point;
	my $resp = $ua->get($url, ':content_file'=>$DUMP.$point); 
	if (-e $DUMP.$point) 
		{ print $Lfh "YAY $point\n"; }
	else
		{ print $Lfh "FAIL $point\n"; }
}
sub uagent
{
	my $s_ua = LWP::UserAgent->new(
		agent => "Mozilla/50.0.2",
		from => 'punxnotdead',
		timeout => 45,
	);
	return $s_ua;
}
