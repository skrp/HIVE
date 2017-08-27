// #include <sys/time.h>
// troubleshoot uncomment * 3
#include <stdlib.h>
#define _WITH_GETLINE
#include <stdio.h>
#include <string.h>
#include <sha256.h>
////////////////////////////////
// BLKR - shred file into blocks
int main(int argc, char *argv[])
{
 FILE *ifh;
 int SIZE = 10000;
 char *buf[SIZE];

 int blen = strlen(argv[1]+65);
 int klen = strlen(argv[2]+65);
 char *bpath = malloc(blen);
 char *kpath = malloc(klen);

 // ITERATE BY STDIN /////////////////////////////
 char *line = NULL;
 size_t linecap = 0;
 ssize_t linelen;
 while ((linelen = getline(&line, &linecap, 0)) > 0)
 {
	// CONTINUE IF EXIST //////////////////
	FILE *ifh;
 	ifh = fopen(line, "r");
 	if (ifh)
 	 {fclose(ifh); continue; }

 	char *fsha = SHA256_File(line, NULL);

	bzero(kpath, klen);
 	strcpy(kpath, argv[2]);
 	strcat(kpath, fsha);

 	int position = 0; // SHA256_FileChunk

	while (fread(buf, 1, (size_t) SIZE, ifh) > 0)
 	{
    		//struct timeval tp;
    		//struct timeval tf;
    		//gettimeofday(&tp, NULL);

    		char *bsha = SHA256_FileChunk(line, NULL, position, SIZE);

		bzero(bpath,blen);
    		strcpy(bpath, argv[1]);
    		strcat(bpath, bsha);

    		FILE *bfh;
    		bfh = fopen(bpath, "w");
    		fwrite(buf, 1, (size_t) SIZE, bfh);

  	 	FILE *kfh;
    		kfh = fopen(kpath, "a");
    		fwrite(bsha, 1, 64, kfh);
    		fwrite("\n", 1, 1, kfh);

    		fclose(bfh);
    		fclose(kfh);
    		position += SIZE;
    		free(bpath);
      		bzero(buf, (size_t) SIZE);
		
		//gettimeofday(&tf, NULL);
    		//printf("%ld\n", tf.tv_usec-tp.tv_usec);
 	}
	fclose(ifh);
 	free(line);
 	free(kpath);
 }
}
