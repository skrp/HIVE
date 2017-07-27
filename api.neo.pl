use LWP::UserAgent;
use LWP::Protocol::https;
const my $NEO => 'http://searchcode.com/codesearch/raw/';
const my $ARX => 'https://arxiv.org/pdf/';
sub neo
{
	my ($point) = @_;
	sleep 5;
	my $ua = uagent();
	my $url = $NEO.$point;
	my $file = $DUMP.$point;
	my $resp = $ua->get($url, ':content_file'=>$file); 
	if (-e $file) 
		{ print $Lfh "YAY $point\n"; }
	else
		{ print $Lfh "FAIL $point\n"; }
	XS($file) && unlink($file);
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
# XS ###########################################################
sub XS
{
	my ($file) = shift;
	my ($sha) = file_digest($file) or die "couldn't sha $file";
	File::Copy::copy($file, $PATH."pool/$sha");
	my $cur = $PATH."g/g$sha";
	open(my $fh, '>>', $cur) or die "Meta File Creation FAIL $file";
	printf $fh "%s\n%s\n%s\n%s\n", 
		xsname($file),
		xspath($file),
		xssize($file),
		file_mime_encoding($file);
}
sub file_digest {
	my ($file) = @_;
	my $digester = Digest::SHA->new('sha256');
	$digester->addfile( $file, 'b' );
	return $digester->hexdigest;
}
sub xsname {
	my ($file) = @_;
	$file =~ s?^.*/??;
	return $file;
}
sub xspath {
	my ($file) = @_;
	$file =~ s?/?_?g;
	return $file; 
}
sub file_mime_encoding {
	my ($file) = @_;
	my $magic = File::LibMagic->new();
	my $info = $magic->info_from_filename($file);
	my $des = $info->{description};
	$des =~ s?[/ ]?.?g;
	$des =~ s/,/_/g;
	my $md = $info->{mime_type};
	$md =~ s?[/ ]?.?g;
	my $enc = sprintf("%s %s %s", $des, $md, $info->{encoding}); 
	return $enc;
}
sub xssize {
	my ($file) = @_;
	my $size = -s $file;
	return $size;
}
