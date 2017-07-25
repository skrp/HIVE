sub arki
{
	my ($i) = @_;
	sleep 5;
	my $ua = uagent();
	my $file = $DUMP."$i.pdf";
	my $mfile = $DUMP."$i".'_meta.xml';
	my $url = $ARK."$i/$i.pdf";
	my $murl = $ARK."$i/$i".'_meta.xml';	
	my $resp = $ua->get($url, ':content_file'=>$file); 
	my $mresp = $ua->get($murl, ':content_file'=>$mfile);
	if (-f $file) 
		{ print $Lfh "YAY $i\n"; $YAY++; }
	else
	{ 
		my $eresp = $ua->get($ARK.$i, ':content_file'=>$DUMP.'/tmp');
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		my $redo = `grep pdf $DUMP.'tmp' | sed 's?</a>.*??' | sed 's/.*>//'`;
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		my $rresp = $ua->get($ARK."$i/$redo", ':content_file'=>$file);
		if (-f $file) 
			{ print $Lfh "YAY $i\n"; $YAY++; }
		else 
			{ print $Lfh "FAIL $i\n"; unlink($mfile); next; }
	}
	XS($file) && unlink($file);
	XS($mfile) && unlink($mfile);
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
