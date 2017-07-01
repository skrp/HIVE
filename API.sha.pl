#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon;
use Digest::SHA ();
#####################################
# SUMMON SCROLL
# INIT ##############################
my ($que) = @ARGV;
my @FACE; my $RATE = '100';
# BIRTH ###############################
my $embryo = Proc::Daemon->new(
  work_dir => "/tmp/",
);
my $pid = $embryo->Init() or die "STILLBORN\n";
# LOCATION
my $gravestone = "/graveyard/"$name"."tar";
my $name = "/tmp/$pid"";
my $dump = "$name"."_dump";
my $code = "$name"."_code";
my $tar = "$name"."_tar";
my $log = "$name"."_log";
my $rep = "$name"."_rep";
my $SLEEP = "$name"."_SLEEP";
my $SUICIDE = "$name"."_SUICIDE";
my $wfifo = "/tmp/HOST";
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
  my $set_name = shift; print $Lfh "set $set_name\n";
  my $count = @QUE; print $Lfh "count $count\n"; my $ttl = $count;
  foreach my $i (@QUE)
  {
    if (-e $SUICIDE)
      { SUICIDE(); }
    if (-e $SLEEP)
      { SLEEP(); }
    print $Lfh "started $i\n";
#####################################
## CODE #############################
    my ($sha) = file_digest($i) or die "couldn't sha $file";
    if ($sha != $i)
      { print $Lfh "ERK! $file != $sha\n"; }
#####################################
## CLEAN ############################
    shift @QUE; $count--;
    # print $Lfh "ended $i\n"; #### DEBUG
# RATE ##############################
    if ($count % $RATE == 0)
    {
      my $current = gmtime();
      # FACE (age, name, rep, status)
      $FACE[0] = $name;
      $FACE[1] = (($current - $born) / 60);
      $FACE[3] = $set_name . '_' . $count . '/' . $ttl;
      open(my $wffh, '>', $wfifo);
      print $wffh "@FACE";
    }
  }
  my $dtime = TIME(); print $Lfh "done $dtime\n";

  `XS $dump /otto/pool`;
  `ls $dump > $rep`;
  `rm -r $dump`; 
  `tar -cf $gravestone $name*`;
  my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
}
# SUB ##############################
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
sub file_digest {
    my ($filename) = @_;
    my $digest = Digest::SHA->new(256);
    $digest->addfile($filename, "b");
    return $digest->hexdigest();
}
