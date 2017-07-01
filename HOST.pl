#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use POSIX qw(mkfifo);
#######################################
# HOST - daemon code father
# SETUP ###############################
my $dir = '/tmp'; chdir $dir; 
my $work = '.'; 
# FILES
my $BUG = 'host_BUG'; my $LOG = 'host_LOG'; my $pid = 'host_PID';
my $SLEEP = 'host_SLEEP'; my $SUICIDE = 'host_SUICIDE';
# DAEMONIZE ##########################
my $daemon = Proc::Daemon->new(
    work_dir     => $work,
    child_STDOUT => $LOG,
    child_STDERR => $BUG,
    pid_file     => $pid,
);
$daemon->Init();
# INIT ##############################
my $WORD = 'RHOST'; mkfifo($WORD, 0770) or die "mkfifo WORD fail\n"; # code location
open(my $FWfh, '<', $WORD) or die "cant open RHOST\n";
my $POST = 'WHOST'; mkfifo($POST, 0770) or die "mkfifo POST fail\n"; # wrapped code location
open(my $FPfh, '>', $POST) or die "cant open WHOST\n";
while(1)
{
  my $code = <$WORD>; chomp $code;
  if (not defined $code)
    { sleep 500; next; }
  my @set = split(/\s+/, $code);
  # api 
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
# sanitize udp api req
