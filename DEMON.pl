#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon;
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
my $tombstone = "/tombstone/"$name."tar";
my $name = name($pid);
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
    print $Lfh "$i\n";
#####################################
## CLEAN ############################
    shift @QUE; $count--;
    # print $Lfh "ended $i\n"; #### DEBUG
# RATE ##############################
    if ($count % $RATE == 0)
      { face(); }
  }
  my $dtime = TIME(); print $Lfh "done $dtime\n";
  dumpr();
  tombstone();
}
# SUB ##############################
sub dumpr
{
  `XS $dump /pool`;
  `ls $dump > $rep`;
  `rm -r $dump`;
}
sub tombstone
{
  `tar -cf $gravestone $name*`;
  my $xxtime = TIME(); print $Lfh "farewell $xxtime\n";
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
  my ($pid) = shift;
  my @set = ("A".."Z", "a".."z", "1".."9");
  my $id = $chars[rand @chars] for 1..8;
  my $name = $name.$id
  return $name;
}
sub face
{ # FACE (age, name, rep, status)
      my $current = gmtime();
      $FACE[0] = $name;
      $FACE[1] = (($current - $born) / 60);
      $FACE[3] = $set_name . '_' . $count . '/' . $ttl;
      print $wffh "@FACE";
}
