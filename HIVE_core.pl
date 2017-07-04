#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use Archive::Tar;
use File::Path; use File::Copy;
use Digest::SHA qw(sha256_hex); use File::Find::Rule;
use File::stat;
######################################################
# DEMON - daemon summoning scroll
# INIT ###############################################
my ($que, $path) = @ARGV;
# BIRTH ##############################################
my $embryo = Proc::Daemon->new(work_dir => "/tmp/");
my $pid = $embryo->Init() or die "STILLBORN\n";
my $born = gmtime();
my $btime = TIME(); print $Lfh "HELLOWORLD $btime\n";
# DIRS ###############################################
if (not defined $que) { die ('NO ARGV1 que'); }
if (not defined $path) { die ('NO ARGV2 dir'); }
if (substr($path, -1) eq "/")
	{ $path .= '/'; }
# sea/ blkr
# key/ key
# tombstone/ graveyard
# g/ dumpr
# pool/ dumpr
# PREP ###############################################
my $name = name();
my $pid = $$;

chdir('/tmp/');
my $wfifo = '/tmp/HOST';
my $RATE = '100';

my $dump = "$name"."_dump";
my $tar = "$name"."_tar";
my $log = "$name"."_log";
my $SLEEP = "$name"."_SLEEP";
my $SUICIDE = "$name"."_SUICIDE";

mkdir $dump or die "dump FAIL\n";
open(my $Lfh, '>>', $log);
my $born = gmtime();
my $btime = TIME(); print $Lfh "HELLOWORLD $btime\n";

# WORK ################################################
open(my $qfh, '<', $que) or die "cant open que\n";
my @QUE = readline $qfh; chomp @QUE;
close $qfh;

my $api = shift @QUE; print $Lfh "api $api\n";

my $ttl = @QUE;
print $Lfh "ttl $ttl\n";

my $count = 0;

foreach my $i (@QUE)
{
		if (-e $SUICIDE)
    	{ SUICIDE(); }
    if (-e $SLEEP)
    	{ SLEEP(); }

    print $Lfh "started $i\n";
		blkr($i);
		$count++;
}
my $dtime = TIME(); print $Lfh "FKTHEWRLD $dtime\n";
tombstone();
# SUB ####################################
sub dumpr
{
	XS($dump, );
	remove_tree($dump);
}
sub rep
{
	my $rep = "$name"."_rep";
	my @files = File::Find::Rule->file->in($dump);
	open(my $rfp, '>', $rep);
	print $rfp @files;
}
sub tombstone
{
	my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
	close $Lfh;
	my $tombstone = "$name."."tar";
	my $tar = Archive::Tar->new;
	$tar->write($tombstone);
	rep();
	my $rep = "$name".'rep';
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
	my $name = $pid.'_'.$id;
	return $name;
}
sub face
{ # FACE (age, name, rep, status)
	my ($count, $ttl) = shift;
	my @FACE;
	my $wfifo = shift;
	my $current = gmtime();
	$FACE[0] = $name;
	$FACE[1] = (($current - $born) / 60);
	$FACE[3] = $api . '_' . $count . '/' . $ttl;
	print $wfifo "@FACE";
}
sub blkr
{
	my ($i) = shift;
	my $block = 0;
	my $size = 128000;

	my $st = stat($i);
	my $total = $st->size;

	open(my $ifh, '<', "$i") || die "Cant open $i: $!\n";
	binmode($ifh);

	while (read($ifh, $block, $size))
	{
		my $bsha = sha256_hex($block);
		my $bname = $path.'sea/'.$bsha;

		open(my $fh, '>', "$bname");
		binmode($fh);

		print $fh $block;
		key($i, $bsha)
	}
	print $Lfh "YAY $i\n";
}
sub key
{
  my ($i, $bsha) = shift;
	my $kpath = $path.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print "$i\n";
	print $kfh "$bsha\n";
}
