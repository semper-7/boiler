#!/bin/sh
if [ -z "$2" ]; then echo "Command line: tftp_lua IP_adress filename"
else
 sed -e "/^$/d;s/^[ 	]*//;s/[ 	]*$//" "$2" > "$2.tmp"
 tftp -p -l "$2.tmp" -r "$2" "$1"
 rm -f "$2.tmp"
fi
