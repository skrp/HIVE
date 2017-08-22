// check '/' on path in core code
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sha256.h>
////////////////////////////////
// BLKR - shred file into blocks
int main(int argc, char *argv[])
{
 FILE *ifh;
 int position = 0;
 int SIZE = 10000;
 char *buf[SIZE];
 char *bsha = malloc(65);
 char *fsha = malloc(65);

 fsha = SHA256_File(argv[1], NULL);

 char *kpath = malloc(strlen(argv[2])+76);
 strcpy(kpath, argv[2]);
 strcat(kpath, "key/");
 strcat(kpath, fsha);

// CONTINUE IF EXIST //////////////////
 FILE *testfh;
 testfh = fopen(kpath, "r");
 if (testfh)
 {
    fclose(testfh);
    exit(0);
 }

 ifh = fopen(argv[1], "r");

 while (fread(buf, 1, (size_t) SIZE, ifh) > 0)
 {
    bsha = SHA256_FileChunk(argv[1], NULL, position, SIZE);

    char *bpath = malloc(strlen(argv[2])+76);
    strcpy(bpath, argv[2]);
    strcat(bpath, "sea/");
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
 }
}
