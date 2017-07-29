#!/usr/local/bin/perl
use Term::ANSIColor;

# 'api/'
# 'sea/'
# 'pool/'
# 'work/'
# 'cemetery/'

# DEMON_LOG moves from 'work/' to 'cemetery/'
# When DEMON is disconnected

# FACE is the status
# tomestone is the outbut

const my $y_winsize = 144
const my $x_winsize = 10

# FORMAT
####### HUBBUB0 ########### ####### HUBBUB 1 ############
# $YAY $NAME $AGE           $YAY $NAME $AGE
# $api $yay $count $ttl     $api $yay $count $ttl
#
# $i_time $i                $i_time $i 
# .                         .
# .                         .
# .                         .
##########################  #############################

if (@work)
{
  screen_launch($y, $x);
  print color('bold green') "$hostname\n";
  print color('yellow') "$YAY $NAME $AGE\n";
  print color('yellow') "$api $yay $count $ttl\n";
  For (0 .. 6)
    { print color('white') "$i_time[$_] $i[$_]\n"; }
}
sub fill_screen
{
  screen_launch($y, $x);
  print color('bold green') "$hostname\n";
  print color('yellow') "$YAY $NAME $AGE\n";
  print color('yellow') "$api $yay $count $ttl\n";
  For (0 .. 6)
    { print color('white') "$i_time[$_] $i[$_]\n"; }
}
