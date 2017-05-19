#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use POSIX qw(mkfifo);
#######################################
# HOST - daemon code father
# SETUP ###############################
my $work = '.'; my $batch = 'batch';
my $ver = './ver/'; my $dump ='./dump/';
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
# INIT ##############################
my $WORD = 'WORD'; mkfifo($WORD, 0770) or die "mkfifo WORD fail\n"; # code location
open($FWfh, '<', $WORD) or die "cant open WORD\n";
my $POST = 'POST'; mkfifo($POST, 0770) or die "mkfifo POST fail\n"; # wrapped code location
open($FPfh, '<', $POST) or die "cant open POST\n";
while(1)
{
  my $code = <$WORD>; chomp $code;
  if (not defined $code)
    { sleep 500; next; }
  my @set = split(/\s+/, $code);
  my $set_name = $set[0]; my $version = $set[1]; my $custom = $set[2];
  my $version =~ $ver.$version; my $wrapped = $dump.$set_name; 
  my $tail = $version.'_tail'; my $custom =~ './batch/'.$custom;
  
  open(my $Wfh, '>>', $wrapped) or print "fail create $wrapped\n";
  `cat $version >> $wrapped`; print $Wfh "\n"; 
  `cat $custom >> $wrapped`; print $Wfh "\n";
  `cat $tail >> $wrapped`;
  print "wrapped $set_name\n";
}
# FN ################################
sub TIME
{
  my $t = localtime;
  my $mon = (split(/\s+/, $t))[1];
  my $day = (split(/\s+/, $t))[2];
  my $hour = (split(/\s+/, $t))[3];
  my $time = $mon.'_'.$day.'_'.$hour;
  return $time;
}
