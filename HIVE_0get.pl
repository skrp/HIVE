use LWP::UserAgent;
#!/usr/local/bin/perl
package HIVE::get;
use strict; use warnings;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT = ();
@EXPORT_OK = qw(get)

sub get
{
	my $i = shift;
	my $ua = uagent();
	my $response = $ua->get($i, ':content_file'=>"$dump/$i");
	print $Lfh "YAY $i\n";
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
