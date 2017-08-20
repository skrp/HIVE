// check '/' on path in core code
#include <stdio.h>
#include <strings.h>
#include <fcntlh>
#include <unistd.h>
////////////////////////////////
// BLKR - shred file into blocks

SIZE 128000

int key(char *$i, char *bsha);
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
   if (key(*bsha) < 0)
	
 }


int key(char *$i, char *bsha)
{
	FILE *kfh;
	
	char *kpath = malloc(strlen(i)+strlen(bsha)+1);
	strcpy(kpath, i);
	strcat(kpath, bsha);
	
	if ((open(kfh, const char *kpath, O_APPEND)) < 0) 
      		printf("FAIL key open %p\n", *kpath);
   	if ((fprintf(FILE *kfh, const char *bsha)) < 0) 
	  	printf("FAIL key write %p\n", *kpath);
	return 0;
}
