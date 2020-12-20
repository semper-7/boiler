@echo off
setlocal enabledelayedexpansion
if "%1"=="" echo Command line: %~n0 filename.lua ^| busybox nc ip_address 23&pause&exit
busybox usleep 100000
echo file.remove("%1"); file.open("%1","w+"); w = file.writeline
busybox usleep 100000
for /f "tokens=*" %%X in (%1) do echo w([==[%%X]==])& busybox usleep 100000
echo file.close(); collectgarbage()
busybox usleep 100000
echo exit
