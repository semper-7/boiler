#include <stdio.h>
#include <sys/io.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char *argv[]){
if (argc!=3){
printf("Out byte to port ver 1.0.\nCopyright (C) 2014 Semper\nUsage:\tout [decimal port address] [byte in decimal format]\n");
return 1;
exit;
}
int port = atoi(argv[1]);
int x = atoi(argv[2]);
if (ioperm (port, 1, 1)){
perror ("ioperm()");
exit;
}
outb (x, port);
return 0;
}
