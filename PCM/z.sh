#!/bin/sh
###0123456701234567
Y="1332111122220000"
R=4; Z=3
eval "R=$R+\${Y:$Z:1}"
echo $R
