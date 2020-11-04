@echo off
set A=D:\Arduino\
rd /S /Q tmp >nul 2>nul
md tmp
echo Compile %~n0.ino ...
"%A%arduino-builder.exe" -hardware "%A%hardware" -fqbn arduino:avr:nano:cpu=atmega328 -libraries "%A%libraries" -ide-version 10805 -tools "%A%tools-builder,%A%hardware\tools\avr" -build-path %~dp0tmp\ %~n0.ino
copy %~dp0tmp\%~n0.ino.hex
rd /S /Q tmp>nul 2>nul
pause
exit
