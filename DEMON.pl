#!/usr/local/bin/perl
use strict; use warnings;
use Const::Fast 'const';
use Digest::SHA 'sha256_hex';
use POSIX;
use File::Path; 
use File::Copy;
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
const my $PATH => $path;
const my $NAME => name();
const my $BIRTH => gmtime();
const my $QUE => $NAME.'_que';
const my $DUMP => $NAME.'_dump/';
const my $TOMB => $PATH.'cemetery/'.$NAME;
const my $SLEEP => $NAME.'_SLEEP';
const my $SUICIDE => $NAME.'_SUICIDE';
const my $SIZE => 128000;
const my $RATE => 100;
const my @API => 'pop', 'chkmeta', 'index', 'blkr', 'build', 'vsha', 'xtrac', 'rgex', 'get';
const my $ARK => 'https://archive.org/download/';
# GLOBAL VARIABLE ####################################
my $YAY = 0;

# PREP ###############################################
chdir('/tmp/');

mkdir $DUMP or die "$DUMP FAIL\n";
open(my $Lfh, '>>', $TOMB);
$Lfh->autoflush(1);

printf $Lfh ("HELLOWORLD %s\n", TIME());
while (1)
{ # WORK ################################################
	unless (-e $QUE)
		{ sleep 3600; next; }
	open(my $qfh, '<', $QUE) or die "cant open $QUE\n";
	my @QUE = readline $qfh; chomp @QUE;

	my $api = shift @QUE; 
	next if (api($api) < 0);
	
	my $ttl = @QUE; 
	my $count = 0;
	
	foreach my $i (@QUE)
	{
		if (-e $SUICIDE)
    			{ SUICIDE(); }
		if (-e $SLEEP)
   	 		{ SLEEP(); }
		\&$api($i);
		print $Lfh "started $i\n";
		$count++;
		tombstone($api, $count, $ttl) if ($count % $RATE == 0);
	}
} # API ##################################################
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
sub build
{
	my ($i) = @_;
	my $kpath = $PATH.'key/'.$i;
	my $dpath = $DUMP.'tmp';

	open(my $kfh, '<', $kpath);
	my @set = readline $kfh; chomp @set;
	foreach my $part (@set)
	{
		my $ipath = $PATH.'sea/'.$part;
		open(my $tfh, '>>', "$dpath");
		open(my $ifh, '<', "$ipath");
		my $block;
		read($ifh, $block, $SIZE);
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
		{ print $Lfh "ERK $i ne $sha\n"; }
	$YAY++;
}
sub xtrac
{
	my ($i) = @_;
	my $archive = Archive::Any->new($i);
	if ($archive->is_naughty)
		{ print $Lfh "ALERT xtrac naughty $i"; next; }
	my @files = $archive->files; print $Lfh @files;
	$archive->extract($DUMP);
	XS($DUMP, $PATH) && rmtree($DUMP);
	mkdir $DUMP;
	print $Lfh "YAY $i\n"; $YAY++;
}
sub regx
{
	my ($i) = @_;
	open(my $fh, '<', $i); 
	open(my $mfh, '<', $PATH);
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
	my $response = $ua->get($i, ':content_file'=>"$DUMP$i");
	print $Lfh "YAY $i\n"; $YAY++;
	XS($i) && unlink($i);
}
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
# XS ###########################################################
sub XS
{
	my ($file) = shift;
	my ($sha) = file_digest($file) or die "couldn't sha $file";
	File::Copy::copy($file, $PATH."pool/$sha");
	my $cur = $PATH."g/g$sha";
	open(my $fh, '>>', $cur) or die "Meta File Creation FAIL $file";
	printf $fh "%s\n%s\n%s\n%s\n", 
		xs$NAME($file),
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
sub xs$NAME {
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
	my $info = $magic->info_from_file$NAME($file);
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
   die "FAIL daemon1 $!\n" if (fork() < 0);
   exit 0;
   POSIX::setsid() or die "FAIL setsid $!";
   die "FAIL daemon2 $!\n" if (fork() < 0);
   exit 0;
   chdir('/tmp');
   umask 0;
   my $fds = 0;
   while ($fds < 1024)
      { POSIX::close($fds); $fds++;  }
   my $des = '/dev/null';
   open(STDIN, "<$des");
   open(STDOUT, ">$des");
   open(STDERR, ">$des");
}
sub api
{
	my ($api) = @_;
	print $Lfh "api $api\n";
	unless (/$api/, @API)
	{
		print $Lfh "FAIL_API $api\n";
		close $qfh;
		move($QUE, $PATH.'cemetery/zombie_'.$NAME);
		return -1;
	}
	return 0;	
}
sub $SUICIDE
{
	my ($api, $count, $ttl) = @_;
	unlink $SUICIDE;
	printf $Lfh ("FKTHEWORLD %s\n", TIME());
	tombstone($api, $count, $ttl);
	exit;
}
sub $SLEEP
{
	my ($api, $count, $ttl) = @_;
	open(my $Sfh, '<', $SLEEP);
	my $timeout = readline $Sfh; chomp $timeout;
	print $Lfh ("$SLEEP %s %s\n", $timeout, TIME());
	close $Sfh; unlink $SLEEP;
	tombstone($api, $count, $ttl);
	$SLEEP $timeout;
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
	my ($api, $count, $ttl) = @_;
	
	open(my $LLfh, '<', $TOMB);
	my @llfh = readline $LLfh;
	my @yay = grep { /^YAY / } @llfh; 
	my $yay = @yay;
	my @FACE;
	$FACE[0] = $NAME;	
	$FACE[1] = ((gmtime() - $BIRTH) / 60);
	$FACE[2] = $api . '_' $yay . '_' . $count . '_' . $ttl;
	
	open(my $Tfh, '>>', $TOMB); 
	printf $Tfh ("%d %s %d %s\n", $YAY, $FACE[0], $FACE[1], $FACE[2]);
}
sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $PATH.'key/'.$i;
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
