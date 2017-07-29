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
my $cnt = @work;
my $y = $cnt/10
my $x = $cnt/10;
if (@work)
{
  `screenrc $y $x`;
  while (1)
    { fill_screen($_); }
}
sub fill_screen
{
  my ($demonite) = @_;
  open($deFAfh, '<', $demonite);
  my @FACE = readline $deFAfh; chomp @FACE;
  my $hostname = @FACE[1];
  my $YAY = shift @FACE;
  my $NAME = shift @FACE;
  my $AGE = shift @FACE;
  my $api = shift @FACE;
  my $yay = shift @FACE;
  my $count = shift @FACE;
  my $ttl = shift @FACE;
  
  print color('bold green') "$hostname\n";
  print color('yellow') "$YAY $NAME $AGE\n";
  print color('yellow') "$api $yay $count $ttl\n";
  
  foreach (@FACE)
    { print color('white') "$i_time[$_] $i[$_]\n"; }
  sleep 10;
 }
