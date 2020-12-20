#!/bin/sh
if [ -z "$1" ] ; then
 echo "Command line: lua_wr.sh filename.lua | \/dev\/ttyUSB0"
 echo "Command line: lua_wr.sh filename.lua | nc IP_address 23"
 sleep 0; exit
fi
sleep 1
echo "file.remove(\"$1\"); file.open(\"$1\",\"w+\"); w = file.writeline"
usleep 200000
N=`sed -n "$=" "$1"`
I=1
while [ "$I" -le "$N" ] ; do
 sed -n ""$I"s/\(.*\)/w([==[\1]==])/p" "$1"
 let "I+=1"
 usleep 200000
done
echo "file.close(); collectgarbage()"
usleep 200000
echo "exit"
