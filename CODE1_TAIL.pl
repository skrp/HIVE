## CLEAN ############################
    shift @QUE; $count--;
    print "ended $i\n";
# RATE ##############################
    if ($count % $RATE == 0)
    {
      my $current = gmtime();
      # FACE (age, name, rep, status)
      $FACE[0] = $name;
      $FACE[1] = (($current - $born) / 60);
      open(my $Rfh, '<', $REP); $FACE[2] = readline $Rfh;
      $FACE[3] = $set_name . '_' . $count . '/' . $ttl;
    }
  }
  my $dtime = TIME(); print "done $dtime\n";
  open(my $Wfh, '>', $DONE);
}
# SUB ##############################
sub SUICIDE
{
  unlink $SUICIDE;
  my $xtime = TIME(); print "FKTHEWORLD $xtime\n";
  exit;
}
sub SLEEP
{
  open(my $Sfh, '<', $SLEEP);
  my $timeout = readline $Sfh; chomp $timeout;
  my $ztime = TIME(); print "sleep $ztime $timeout\n";
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
