#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon;
use File::Path;
use Archive::Any ();
use Digest::SHA ();
use File::stat;
#####################################
# DEMON - summon scroll shell 
# INIT ##############################
my ($que) = @ARGV;
# BIRTH ###############################
my $embryo = Proc::Daemon->new(work_dir => "/tmp/");
my $pid = $embryo->Init() or die "STILLBORN\n";
# VAR ####################################
my $name = name($pid);
my $dump = "$name"."_dump";
my $code = "$name"."_code";
my $tar = "$name"."_tar";
my $log = "$name"."_log";
my $SLEEP = "$name"."_SLEEP";
my $SUICIDE = "$name"."_SUICIDE";
my $wfifo = "/tmp/HOST";
my $RATE = '100';
mkdir $dump or die "dump FAIL\n";
open(my $Lfh, '>>', $log);
# INHERIT ############################
my $born = gmtime();
my $btime = TIME(); print $Lfh "HELLOWORLD $btime\n";
# WORK ###############################
while (1)
{
  open(my $qfh, '<', $que) or die "cant open que\n";
  my @QUE = readline $qfh; chomp @QUE;
  close $qfh;
  my $stime = TIME(); print $Lfh "start $stime\n";
  my $api = shift @QUE; print $Lfh "set $set_name\n";
  my @apis = { "sha", "blockr", "xtrac", "get" };
  die "bad api $api" unless grep(/$api/, @apis);
  my $count = @QUE; print $Lfh "count $count\n"; my $ttl = $count;
  foreach my $i (@QUE)
  {
  	if (-e $SUICIDE)
    		{ SUICIDE($Lfh); }
      	if (-e $SLEEP)
    		{ SLEEP($Lfh); }
     	print $Lfh "started $i\n";
#####################################
## CODE #############################
	switch ($api)
	{
		case "sha" { sha($i) }
		case "blockr" { blockr($i, $path) }
		case "slicr" { slicr($i, $path) }
		case "xtrac" { xtrac($i, $path) }
		case "get" { eval{ get($i) } }
	}
#####################################
## CLEAN ############################
	shift @QUE; $count--;
	# print $Lfh "ended $i\n"; #### DEBUG
# RATE ##############################
	if ($count % $RATE == 0)
		{ face($wfifo); }
	}
	my $dtime = TIME(); print $Lfh "done $dtime\n";
	dumpr($name, $dump);
	tombstone($name, $Lfh, $log, $code, $rep);
}
# SUB ##############################
sub dumpr
{
  my $name = shift; my $dump = shift;
  my $rep = "$name"."_rep";
  `XS $dump /`;
  `ls $dump > $rep`;
  remove_tree($dump);
}
sub tombstone
{
  my ($name, $Lfh, $log, $code, $rep) = @_; 
  my $tombstone = "/tombstone/"$name."tar";
  my $tar = Archive::Tar->new();
  $tar->add_files($log, $code, $rep) 
  `tar -cf $tombstone /tmp/$name*`;
  my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
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
  my $name = $name.$id
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
# API ##################################################
sub sha
{
  my $i = shift;
  my ($sha) = file_digest($i);
  if ($sha ne $i)
    { print $Lfh "ERK! $file ne $sha\n"; }
  print $Lfh "YAY $i\n";
}
sub blockr
{
  my ($i, $path) = shift;
  my $size = 10000;
  my $st = stat($i);
  my $total = $st->size;
  my $count = $total / $size;
  open(my $ifh, '<', "$i") || die "Cant open $i: $!\n";
  binmode($ifh);
  my $block = 0;
  while (read ($ifh, $block, $size) <= $count)
  {
  	my $fh = new_block($path, $block);
	print $fh $block;
	close $fh;
	$count += $size; 
  }
  print $Lfh "YAY $i\n";
}
sub slicr
{
  my ($i, $path) = shift;

  my $st = stat($i);
  my $total = $st->size;
  open(my $ifh, '<', "$i") || die "Cant open $i: $!\n";
  binmode($ifh);
  my $block = 0; my $position = 0;
  while ($position < $total)
  {
    my $size = int(rand(99999));
    if ($position + $size >= $total)
      { $size = $total - $position; }
    read($ifh, $block, $size);
    my $fh = new_block($path, $block);
    print $fh $block;
    close $fh;
    $count += $size; 
  }
  print $Lfh "YAY $i\n";
}
sub xtrac
{
 my ($i, $path) = shift;
 my $archive = Archive::Tar->new($i);
 if ($archive->is_naughty)
 	{ print $Lfh "ALERT xtrac naughty $i"; next; }
 my @files = $archive->files; print $Lfh @files;
 $archive->extract($dump);
 `XS $dump $path`;
 print $Lfh "YAY $i\n";
}
sub new_block
{
	my ($path, $block) = shift;
	my $sha = sha256_hex($block);
	my $name = $path . $sha;
	open(my $fh, '>', "$name") or die "Cant open $name: $!\n";
	binmode($fh);
	return *$fh;
}
sub file_digest 
{ 
  my ($filename) = @_;
  my $digest = Digest::SHA->new(256);
  $digest->addfile($filename, "b");
  return $digest->hexdigest();
}
