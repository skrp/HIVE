#!/usr/local/bin/perl
package HIVE::demon;
use strict; use warnings;
use Proc::Daemon; use Archive::Tar;
use File::Path; use File::Copy;
use Digest::SHA (); use File::Find::Rule;
######################################################
# DEMON - daemon summoning scroll
# INIT ###############################################
my ($que) = @ARGV;
# BIRTH ##############################################
my $embryo = Proc::Daemon->new(work_dir => "/tmp/");
my $pid = $embryo->Init() or die "STILLBORN\n";
my $born = gmtime();
my $btime = TIME(); print $Lfh "HELLOWORLD $btime\n";
# PREP ###############################################
my $name = name($pid);
my $wfifo = "/tmp/HOST";
my $RATE = '100';
my $dump = "$name"."_dump"; my $code = "$name"."_code";
my $tar = "$name"."_tar"; my $log = "$name"."_log";
my $SLEEP = "$name"."_SLEEP"; my $SUICIDE = "$name"."_SUICIDE";
mkdir $dump or die "dump FAIL\n";
open(my $Lfh, '>>', $log);
# WORK ################################################
while (1)
{
	open(my $qfh, '<', $que) or die "cant open que\n";
	my @QUE = readline $qfh; chomp @QUE;
	close $qfh;
	my $stime = TIME(); print $Lfh "start $stime\n";
	my $api = shift @QUE; print $Lfh "set $set_name\n";
	my @apis = { "sha", "blkr", "xtrac", "get" };
	die "bad api $api" unless grep(/$api/, @apis);
	my $count = @QUE; print $Lfh "count $count\n"; my $ttl = $count;
	foreach my $i (@QUE)
	{
		if (-e $SUICIDE)
    			{ SUICIDE($Lfh); }
      		if (-e $SLEEP)
    			{ SLEEP($Lfh); }
     		print $Lfh "started $i\n";
		switch ($api)
		{
			case "sha" { sha($i) }
			case "blkr" { blkr($i, $path) }
			case "slicr" { slicr($i, $path) }
			case "xtrac" { xtrac($i, $path) }
			case "vkey" { vkey($i, $path) }
			case "regx" { regx($i, $path) }
			case "get" { eval{ get($i) } }
	}
## CLEAN #############################################
	shift @QUE; $count--;
	# print $Lfh "ended $i\n"; #### DEBUG
# RATE ###############################################
	if ($count % $RATE == 0)
		{ face($wfifo); }
	}
	my $dtime = TIME(); print $Lfh "done $dtime\n";
	dumpr($name, $dump);
	tombstone($name, $Lfh, $log, $code, $rep);
}
# SUB ####################################
sub dumpr
{
	my $name = shift; my $dump = shift;
	my $rep = "$name"."_rep";
	XS($dump, /);
	my @files = File::Find::Rule->file->in($dump);
	open($rfp, '>', $rep);
	print $rfp @files;
	remove_tree($dump);
}
sub tombstone
{
	my ($name, $Lfh, $log, $api, $rep) = shift;
	my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
	close $Lfh;
	my $tombstone = "/tombstone/$name."."tar";
	my $tar = Archive::Tar->new($tombstone);
	$tar->add_files($log, $code, $rep);
}
sub SUICIDE
{
	my $Lfh = shift;
	unlink $SUICIDE;
	my $xtime = TIME(); print $Lfh "FKTHEWORLD $xtime\n";
	exit;
}
sub SLEEP
{
	my $Lfh = shift;
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
	my ($pid) = shift;
	my @set = ("A".."Z", "a".."z", "1".."9");
	my $id = $chars[rand @chars] for 1..8;
	my $name = $name.$id;
	return $name;
}
sub face
{ # FACE (age, name, rep, status)
	my @FACE;
	my $wfifo = shift;
	my $current = gmtime();
	$FACE[0] = $name;
	$FACE[1] = (($current - $born) / 60);
	$FACE[3] = $set_name . '_' . $count . '/' . $ttl;
	print $wfifo "@FACE";
}
sub key
{
	my ($i, $sha, $path, $bsha) = shift;
	my $kpath = $path."key\\"; $kpath = $kpath.$sha;
	open($kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
}
sub new_block
{
	my ($i, $sha, $path, $block) = shift;
	my $bsha = bsha($block);
	my $nbname = $path . $bsha;
	key($i, $sha, $path, $bsha);
	open(my $fh, '>', "$nbname") or die "Cant open $name: $!\n";
	binmode($fh);
	return *$fh;
}
