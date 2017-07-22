#!/usr/local/bin/perl
use strict; use warnings;
use POSIX 'setsuid' 'close';
use File::Path; use File::Copy;
use Digest::SHA 'sha256_hex';
use File::LibMagic;
use LWP::UserAgent;
######################################################
# DEMON - daemon summoning scroll

# INIT ###############################################
my ($path) = @ARGV;
if (not defined $path) { die ('NO ARGV1 dir'); }
if (substr($path, -1) ne "/") { $path .= '/'; }

# BIRTH ##############################################
daemon() or die "FAIL daemon\n";

# DIRS ###############################################
# sea/ : blkr()
# key/ : key()
# cemetery/ : tombstone()
# g/ : XS()
# pool/ : XS()

# GLOBAL CONST #######################################
use constant {
	PATH => $path,
	NAME => "name()",
	BIRTH => "TIME()",
	QUE => NAME.'_que',
	DUMP => NAME.'_dump',
	TOMB => "$path".'cemetery/'.NAME,
	SLEEP => NAME.'_SLEEP',
	SUICIDE => NAME.'_SUICIDE',
	SIZE => 128000
	RATE => 100,
	@API => 'pop', 'chkmeta', 'index', 'blkr', 'build', 'vsha', 'xtrac', 'rgex', 'get';
}
# GLOBAL VARIABLE ####################################
my $YAY = 0;
# PREP ###############################################
chdir('/tmp/');

mkdir DUMP or die "dump FAIL\n";
open(my $Lfh, '>>', TOMB);
$Lfh->autoflush(1);

printf $Lfh ("HELLOWORLD %s\n", TIME());

while (1)
{ # WORK ################################################
	unless (-e QUE)
		{ sleep 3600; next; }
	open(my $qfh, '<', QUE) or die "cant open QUE\n";
	my @QUE = readline $qfh; chomp @QUE;

	my $api = shift @QUE; 
	api($api);
	
	my $ttl = @QUE; 
	my $count = 0;
	
	foreach my $i (@QUE)
	{
		if (-e $SUICIDE)
    			{ SUICIDE(); }
		if (-e $SLEEP)
   	 		{ SLEEP(); }
		\&$api($i)
		print $Lfh "started $i\n";
		$count++;
		tombstone() if ($count % 100 == 0);
	}
} # API ##################################################
sub blkr
{
	my ($i) = @_;
	my $block = 0;
	my $ipath = $path.'pool/'.$i;
	open(my $ifh, '<', "$ipath") || print $Lfh "Cant open $i: $!\n";
	binmode($ifh);
	
	while (read($ifh, $block, $size))
	{
		my $bsha = sha256_hex($block);
		my $bname = $path.'sea/'.$bsha;
		open(my $fh, '>', "$bname");
		binmode($fh);
		print $fh $block;
		key($i, $bsha);
	}
	$YAY++;
}
sub build
{
	my ($i) = @_;
	my $kpath = $path.'key/'.$i;
	my $dpath = $dump.'tmp';

	open(my $kfh, '<', $kpath);
	my @set = readline $kfh; chomp @set;
	foreach my $part (@set)
	{
		my $ipath = $path.'sea/'.$part;
		open(my $tfh, '>>', "$dpath");
		open(my $ifh, '<', "$ipath");
		my $block;
		read($ifh, $block, $size);
		print $tfh $block;
# DEBUG
#	my $bsha = sha256_hex($block);
#	if ($i ne $bsha)
#		{ print $Lfh "SHAERR $i ne $bsha"; } 
	}
	$YAY++;
}
sub sha
{
	my ($i) = @_;
	my ($sha) = file_digest($i);
	if ($sha ne $i)
		{ print $Lfh "ERK $file ne $sha\n"; }
	$YAY++;
}
sub xtrac
{
	my ($i) = @_;
	my $archive = Archive::Any->new($i);
	if ($archive->is_naughty)
		{ print $Lfh "ALERT xtrac naughty $i"; next; }
	my @files = $archive->files; print $Lfh @files;
	$archive->extract($dump);
	XS($dump, $path) && rmtree($dump);
	mkdir $dump;
	print $Lfh "YAY $i\n"; $YAY++;
}
sub regx
{ # 2 files $i = list $path = master
	my ($i) = @_;
	open(my $fh, '<', $i); open(my $mfh, '<', $path);
	my @i = readline $fh; chomp @i;
	my @master = readline $mfh; chomp @master;
	foreach (@i)
		{ print $Lfh "no $_\n" unless any { /$_/ } @master; }
	$YAY++;
}
sub get
{
	my ($i) = @_;
	my $ua = uagent();
	my $response = $ua->get($i, ':content_file'=>"$dump/$i");
	print $Lfh "YAY $i\n"; $YAY++;
	XS($i) && unlink($i);
}
sub arki
{
	my ($i) = @_;
	sleep 1;
	my $ua = uagent();
	my $file = "$dump"."$i.pdf";
	my $mfile = "$dump"."$i".'_meta.xml';
	my $url = "$base/$i/$i.pdf";
	my $murl = "$base/$i/$i".'_meta.xml';	
	my $resp = $ua->get($url, ':content_file'=>$file); 
	my $mresp = $ua->get($murl, ':content_file'=>$mfile);
	if (-f $file) 
		{ print $Lfh "YAY $i\n"; $YAY++; }
	else
	{ 
		my $eresp = $ua->get("$base/$i", ':content_file'=>"$dump/tmp");
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		my $redo = `grep pdf $dump/tmp | sed 's?</a>.*??' | sed 's/.*>//'`;
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		my $rresp = $ua->get("$base/$i/$redo", ':content_file'=>$file);
		if (-f $file) 
			{ print $Lfh "YAY $i\n"; $YAY++; }
		else 
			{ print $Lfh "FAIL $i\n"; unlink($mfile); next; }
	}
	XS($file) && unlink($file);
	XS($mfile) && unlink($mfile);
}
# XS ###########################################################
sub XS
{
	my ($file) = shift;
	my ($sha) = file_digest($file) or die "couldn't sha $file";
	File::Copy::copy($file, "$path"."pool/$sha");
	my $cur = "$path"."g/g$sha";
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
# SUB ###########################################################
sub daemon {
#  fork() && exit 0;
   setsid() or die "FAIL_SETSID $!";
   my $pid = fork();
   die "FAIL_FORK $!" if ($pid < 0);
   exit 0;
   chdir('/tmp');
   umask 0;
   my $fds = 1024;
   my $des = '/dev/null';
   while ($fds > 0)
      { close $fds; $fds--;  }
   open(STDIN, "<$des");
   open(STDOUT, ">$des");
   open(STDERR, ">$des");
}
sub api
{
	my ($api) = @_;
	unless (/$api/, @API)
	{
		print $Lfh "FAIL_API $api\n";
		copy($que, PATH.'zombie_'.NAME);
		unlink $que;
		next;
	}
	print $Lfh "api $api\n";
	
}
sub SUICIDE
{
	unlink $SUICIDE;
	my $xtime = TIME(); print $Lfh "FKTHEWORLD $xtime\n";
	tombstone();
	exit;
}
sub SLEEP
{
	open(my $Sfh, '<', $SLEEP);
	my $timeout = readline $Sfh; chomp $timeout;
	print $Lfh ("sleep %s %s\n", $timeout, TIME());
	close $Sfh; unlink $SLEEP;
	sleep $timeout;
}
sub TIME
{
	my $t = localtime;
	my $mon = (split(/\s+/, $t))[1];
	my $day = (split(/\s+/, $t))[2];
	my $hour = (split(/\s+/, $t))[3];
	my $time = $mon.'_'.$day.'_'.$hour;
	return $time;
}
sub name
{
	my $id = int(rand(999));
	my $name = $$.'_'.$id;
	return $name;
}
sub tombstone
{
	my ($count, $ttl) = @_;
	my $tombstone = NAME.'cemetery/'.NAME;
	my $current = gmtime();
	
	open(my $LLfh, '<', $log);
	my @llfh = readline $LLfh;
	my @YAY = grep /^YAY / @llfh;
	my $suk= @YAY;

	my @FACE;
	$FACE[0] = $name;	
	$FACE[1] = (($current - $born) / 60);
	$FACE[2] = $api . '_' . $suk . '_' . $count . '_' . $ttl;
	
	open(my $Tfh, '>>', $tombstone); 
	printf $Tfh ("%s %d %s\n", $FACE[0], $FACE[1], $FACE[2]);
}
sub bsha
{
	my $block = shift;
	my $bsha = sha256_hex($block)
	return $bsha;
}
sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $path.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
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
