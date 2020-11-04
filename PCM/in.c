#include <stdio.h>
#include <sys/io.h>
#include <stdlib.h>
#include <unistd.h>

int main (int argc, char *argv[]){
if (argc!=2){
printf("In byte ver 1.0.\nCopyright (C) 2014 Semper\nUsage:\tin [decimal port address]\n");
return 1;
exit;
}
int port = atoi(argv[1]);
if (ioperm (port, 1, 1)){
perror ("ioperm()");
exit;
}
int x = inb (port);
printf("%d\n", x);
return x;
}
