@echo off
set C=COM5
set A=D:\Arduino\hardware\tools\avr\bin
"%A%\avrdude.exe" -C "%A:~0,-3%etc\avrdude.conf" -p m328p -c arduino -P %C% -b 57600 -D -U flash:w:%~n0.ino.hex:i
