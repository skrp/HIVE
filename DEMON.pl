#!/usr/local/bin/perl
use strict; use warnings;
use POSIX 'setsuid' 'close';
use Proc::Daemon; use Archive::Tar;
use File::Path; use File::Copy;
use Digest::SHA qw(sha256_hex); use File::Find::Rule;
use File::stat; use List::Util qw(any);
######################################################
# DEMON - daemon summoning scroll

# INIT ###############################################
my ($que, $path) = @ARGV;
if (not defined $que) { die ('NO ARGV1 que'); }
if (not defined $path) { die ('NO ARGV2 dir'); }
if (substr($path, -1) ne "/") { $path .= '/'; }

# BIRTH ##############################################
my $demon = daemon() do die "FAIL daemon\n";

# DIRS ###############################################
# sea/ : blkr()
# key/ : key()
# graveyard/ : tombstone()
# g/ : XS()
# pool/ : XS()

# PREP ###############################################
my $name = name();
chdir('/tmp/');
my $wfifo = '/tmp/HOST';
my $RATE = '100'; 
my $size = 128000;
my $count = 0;
my $LIFE = 1000; # error tolerance

my $dump = "$name"."_dump/";
my $log = "$name"."_log";
my $SLEEP = "$name"."_SLEEP"; 
my $SUICIDE = "$name"."_SUICIDE";

mkdir $dump or die "dump FAIL\n";
open(my $Lfh, '>>', $log);
my $btime = TIME(); 
print $Lfh "HELLOWORLD $btime\n";

# WORK ################################################
open(my $qfh, '<', $que) or die "cant open que\n";
my @QUE = readline $qfh; chomp @QUE;

my $api = shift @QUE; print $Lfh "api $api\n";
my $api = shift @QUE; print $Lfh "api $api\n";
my @api = { "blkr", "build", "vsha", "xtrac", "rgex", "get" };
die "bad api $api" unless any { /$api/ } @api;

my $ttl = @QUE; 
print $Lfh "ttl $ttl\n"; 

foreach my $i (@QUE)
{
	if (-e $SUICIDE)
    		{ SUICIDE(); }
	if (-e $SLEEP)
    		{ SLEEP(); }
	print $Lfh "started $i\n";
	switch($api) {
		case 'blkr' { blkr($i); }
		case 'build' { build($i); }
		case 'vsha' { vsha($i); }
		case 'xtrac' { xtrac($i); }
		case 'regx' { regx($i); }
		case 'get' { get($i); }
	$count++;
}
my $dtime = TIME(); print $Lfh "FKTHEWRLD $dtime\n";
tombstone();
dumpr($i);

# SUB ###########################################################
sub daemon {
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
sub dumpr
{
	my ($i) = @_;
	XS($i);
	remove_tree($dump);
}
sub rep
{
	my $rep = "$name"."_rep";
	my @files = File::Find::Rule->file->in($dump);
	open(my $rfp, '>', $rep);
	print $rfp @files;
	return $rep;
}
sub tombstone
{
	my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
	my $tombstone = 'graveyard/'."$name".'.tar';
	my $tar = Archive::Tar->new;
	$tar->write($tombstone);
	my $rep = rep();
	$tar->add_files($log, $rep);
}
sub SUICIDE
{
	unlink $SUICIDE;
	my $xtime = TIME(); print $Lfh "FKTHEWORLD $xtime\n";
	exit;
}
sub SLEEP
{
	open(my $Sfh, '<', $SLEEP);
	my $timeout = readline $Sfh; chomp $timeout;
	my $ztime = TIME(); print $Lfh "sleep $ztime $timeout\n";
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
sub face
{ # FACE (age, name, rep, status)
	my ($count, $ttl) = @_;
	my @FACE;
	my $wfifo = shift;
	my $current = gmtime();
	$FACE[0] = $name;
	$FACE[1] = (($current - $born) / 60);
	$FACE[3] = $api . '_' . $count . '/' . $ttl;
	print $wfifo "@FACE";
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
sub uagent
{
	my $s_ua = LWP::UserAgent->new(
		agent => "Mozilla/50.0.2",
		from => 'punxnotdead',
		timeout => 45,
	);
	return $s_ua;
}
sub life
{
	my ($life) = @_;
	$life--;
	if ($life > 0)
		{ next; }
	else
		{ tombstone(); exit; }
}
# API ###########################################################
sub blkr
{
	my ($i) = @_;
	my $block = 0;
	my $ipath = $path.'pool/'.$i;
	open(my $ifh, '<', "$ipath") || die "Cant open $i: $!\n";
	binmode($ifh);
	
	my $istart = gettimeofday();
	my $cunt = 0;
	while (read($ifh, $block, $size))
	{
		my $bsha = sha256_hex($block);
		my $bname = $path.'sea/'.$bsha;
		open(my $fh, '>', "$bname");
		binmode($fh);

		print $fh $block;
		key($i, $bsha);
		$cunt++;
	}
	print $Lfh "YAY $i\n";

	my $elapsed = gettimeofday()-$istart;
	print "$i : $cunt : $elapsed \n";	
}
sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $path.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
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
}
sub vsha
{
	my ($i) = @_;
	my ($sha) = file_digest($i);
	if ($sha ne $i)
		{ print $Lfh "ERK! $file ne $sha\n"; }
	print $Lfh "YAY $i\n";
}
sub xtrac
{
	my ($i) = @_;
	my $archive = Archive::Any->new($i);
	if ($archive->is_naughty)
		{ print $Lfh "ALERT xtrac naughty $i"; next; }
	my @files = $archive->files; print $Lfh @files;
	$archive->extract($dump);
	XS($dump, $path);
	print $Lfh "YAY $i\n";
}
sub regx
{ # 2 files $i = list $path = master
	my ($i) = @_;
	open(my $fh, '<', $i); open(my $mfh, '<', $path);
	my @i = readline $fh; chomp @i;
	my @master = readline $mfh; chomp @master;
	foreach (@i)
		{ print $Lfh "no $_\n" unless any { /$_/ } @master; }
}
sub get
{
	my ($i) = @_;
	my $ua = uagent();
	my $response = $ua->get($i, ':content_file'=>"$dump/$i");
	print $Lfh "YAY $i\n";
}
