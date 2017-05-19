#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use POSIX qw(mkfifo);
#######################################
# BROOD - daemon birth mother
# SETUP ###############################
my $work = '.';
# FILES 
my $BUG = 'BUG'; my $LOG = 'LOG'; my $pid = 'PID';
my $SLEEP = 'SLEEP'; my $SUICIDE = 'SUICIDE';
# DAEMONIZE ##########################
my $daemon = Proc::Daemon->new(
    work_dir     => $work,
    child_STDOUT => +>>$LOG,
    child_STDERR => +>>$BUG,
    pid_file     => $pid,
);
$daemon->Init();
# INIT ###############################
my $WORD = 'WORD'; mkfifo($WORD, 0770) or die "mkfifo WORD fail\n"; # wrapped code location
my $POST = 'POST'; mkfifo($POST, 0770) or die "mkfifo POST fail\n"; # $btime
while(1)
{
  my $code = <$WORD>; chomp $code;
  if (not defined $code)
    { sleep 500; next; }
  my $set_name = gen(); regen($set_name);
# DIR 
  my $home = "hive/$set_name"; my $dump = "$home/dump"; my $que = "$home/que";
# FILES
  my $BUG = "BUG"; my $LOG = "LOG"; my $mPID = 'PID'; 
# PREP ################################
  mkdir $home or die "home FAIL\n"; mkdir $que or die "que FAIL\n"; mkdir $dump or die "dump FAIL\n";
# BIRTH ###############################
  my $embryo = Proc::Daemon->new(
    work_dir => $home,
    child_STDOUT => "+>>$LOG",
    child_STDERR => "+>>$BUG",
    pid_file => $mPID,
    exec_command => "perl $code",
  );
  $embryo->Init() or die "STILLBORN\n";
  my $btime = TIME(); print "$name $btime\n";
}
# FN ################################
sub gen
{
  open(my $Gfh, '<', 'GENERATION') or die "GENERATION fail\n";
  my $set_name = readline $Gfh; close $Gfh; 
  return $set_name;
}
sub regen
{
  my ($set_name) = shift; $set_name++;
  open(my $Gfh, '>', 'GENERATION') or die "REGENERATION fail\n";
  print $Gfh "$set_name"; close $Gfh; 
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
