@echo off
if "%2"=="" echo Command line: %~n0 IP_adress filename&exit
mkdir tmp
busybox sed -e "/^$/d;s/^[ 	]*//;s/[ 	]*$//" %2 > tmp\%2
tftp -i %1 PUT tmp\%2
rd /s/q tmp
