#!/bin/sh
P0="black"; P1="red"; P2="yellow"; P3="orange"
echo -n> log.txt
while : ; do
  T=`./digitemp -q -a -o 2 | sed -e 's/\t\(.\...\)/\t0\1/g; s/^0\t//1'`
if [ "${#T}" -eq "47" ]; then
  D=`date +%Y.%m.%d_%H:%M`; D=${D/_/ }
  X=`cat cfg.cfg`
  F=`./in 889`
  I=0
   for S in $T; do
   S=${S:0:4}
   eval "S$I=$S"
   C=`dc $S 2 / 15 - 16 o p`
   [ "${#C}" -eq "8" ] && C="0"
   [ "${#C}" -gt "1" ] && C="f"
   eval "C$I=#$C'2f'"
   let "I+=1"
   done
  B=${S0:0:2}; O=${S5:0:2}; H=${S6:0:2}
  echo -n $H${S6:3:1}> home.t
  let "F=$F>>2&4^4"
  R=0
  [ "$B" -ge "${X:0:2}" -a "$H" -lt "${X:0:2}" ] && [ "$F" -ne "4" -o "$O" -ge "${X:3:2}" ] && R=2
  [ "$B" -ge "${X:12:2}" ] && R=2
  [ "$F" -eq "4" -a "$O" -lt "${X:9:2}" ] && [ "$R" -ne "2" -o "$O" -lt "${X:6:2}" ] && let "R|=1"
  [ "$R" -eq "0" -a "${S7:0:1}" -eq "-" ] && R=2
  eval "P=\$P$R"
  let "R|=$F"
  ./out 890 $R
  echo $D" "$T" "$R>> log.txt
  SS=${X:0:2}
  sed -e "s/#C0/$C0/;s/#C1/$C1/;s/#C2/$C2/;s/#C3/$C3/;s/#C4/$C4/;s/#C5/$C5/;s/#P/$P/;s/DATE/$D/;s/SS/$SS/;s/S0/$S0/;s/S1/$S1/;s/S2/$S2/;s/S3/$S3/;s/S4/$S4/;s/S5/$S5/;s/S6/$S6/;s/S7/$S7/" < index > index.html
  T=`echo $T" "$R| sed -e "s/ /\+/g"`
  ping -c 1 -W 1 beget.ru > /dev/null && wget -q -O log.cfg -U Mozilla/5.0 http://yfb7905i.bget.ru/log.php?var=$T
  [ -s log.cfg ] && cat log.cfg>cfg.cfg
fi
  sleep 20
  [ "$R" -lt "7" ] && sleep 30
  [ "$R" -lt "4" ] && sleep 150
done
