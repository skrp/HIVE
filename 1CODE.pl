my $born = gmtime();
my $btime = TIME(); print "HELLOWORLD $btime\n";
# WORK ###############################
while (1)
{
  my @ls = `ls que`; my $QUE = $ls[0];
  if (not defined $QUE)
    { sleep 3600; next; }
  open(my $qfh, '<', "que/$QUE") or die "cant open que/$QUE\n";
  my @QUE = readline $qfh; chomp @QUE;
  close $qfh; unlink $QUE;
  my $stime = TIME(); print "start $stime\n";
  my $set_name = shift; print "set $set_name\n";
  my $count = @QUE; print "count $count\n"; my $ttl = $count;
  foreach my $i (@QUE)
  {
    if (-e $SUICIDE)
      { SUICIDE(); }
    if (-e $SLEEP)
      { SLEEP(); }
    print "started $i\n";
#####################################
## CODE #############################
