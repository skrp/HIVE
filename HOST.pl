#!/usr/local/bin/perl
use strict; use warnings;
use Proc::Daemon; use POSIX qw(mkfifo);
#####################################
# HOST - daemon code father
# INIT ##############################
my $LOG = 'LOG'; open(my $Lfh, '>>', $LOG) or die "cant open LOG\n";
my $WORD = 'WORD'; mkfifo($WORD, 0770) or die "mkfifo WORD fail\n"; # code location
my $POST = 'POST'; mkfifo($POST, 0770) or die "mkfifo POST fail\n"; # wrapped code location
while(1)
{
  
