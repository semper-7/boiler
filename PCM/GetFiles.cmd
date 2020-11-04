@echo off
setlocal enabledelayedexpansion
set L=files.lst
attrib -R *.*
for /f "usebackq tokens=*" %%A IN (`find /C /V ""^<%L%`) DO set A=%%A
(for /L %%A IN (1,1,!A!) DO (
set X=& set /p X=
move /Y "!X!" .\ARCH\
tftp -i 192.168.1.111 GET "!X!"
))<%L%
attrib -R *.*
