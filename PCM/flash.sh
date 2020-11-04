#!/bin/sh
scan (){
F=`./in 889`
let "F&=32"
[ "$F" -eq "0" ] && echo -n> log.txt
usleep 400000
}

while : ;do
X=`cat home.t`
let "X0=2**${X:1:1}-1"
let "X1=$X0*2+1"
./out 888 $X0
I=0
 while [ "$I" -lt "${X:2:1}" ]; do
 ./out 888 $X1
 scan
 ./out 888 $X0
 scan
 let "I+=1"
 done
for I in 1 2 3 4 5 6; do scan; done
done
