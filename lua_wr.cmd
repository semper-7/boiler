@echo off
setlocal enabledelayedexpansion
if "%1"=="" echo Command line: %~n0 filename&pause&exit
mkdir tmp
call :pr %1 >tmp\%1
lineterm COM4 115200<tmp\%1
rd /s/q tmp
pause&exit

:pr
echo.
echo file.remove("%1")
echo file.open("%1","w+")
echo w = file.writeline
for /f "tokens=*" %%X in (%1) do echo w([==[%%X]==])
echo file.close()
echo collectgarbage()
echo 
exit /b
