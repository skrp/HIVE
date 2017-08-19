#include <stdio.h>
////////////////////////////////
// BLKR - shred file into blocks

SIZE 128000
int main(int argv, char *argc)
{
 char *filepath = argv1;
 FILE *ifh;
 char *buf[SIZE]
   
 if ((open(ifh, const char *filepath, O_RDONLY)) < 0)
  printf("FAIL open %p\n", *filepath);
 
 while (read(ifh, void *buf, size_t SIZE) > 0)
 {
   sha256(*buf);
   FILE *bfh;
   if ((open(bfh, const char *filepath, O_WRONLY)) < 0) 
      printf("FAIL block open %p\n", *filepath);
   if ((fprintf(FILE *bfh, const char *buf)) < 0) 
      printf("FAIL block write %p\n", *filepath);
   key(*bsha);
 }


sub key
{
	my ($i, $bsha) = @_;
	my $kpath = $PATH.'key/'.$i;
	open(my $kfh, '>>', "$kpath");
	print $kfh "$bsha\n";
}
