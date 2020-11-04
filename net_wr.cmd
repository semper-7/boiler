@echo off
setlocal enabledelayedexpansion
if "%1"=="" echo Command line: %~n0 filename&pause&exit
call :delay 100
echo file.remove("%1")
call :delay 30
echo file.open("%1","w+")
call :delay 30
echo w = file.writeline
call :delay 30
for /f "tokens=*" %%X in (%1) do echo w([==[%%X]==]) & call :delay 30
echo file.close()
call :delay 30
echo collectgarbage()
call :delay 30
echo exit
exit

:delay
call :gettick
set /a finish=%errorlevel%+%1
if %finish% geq 8640000 set finish=0
:d
call :gettick
if %errorlevel% lss %finish% goto d
exit /b

:gettick
setlocal
set t=%time: =0%
set /a tick=1%t:~9,2%-100+(1%t:~6,2%-100)*100+(1%t:~3,2%-100)*6000+(1%t:~0,2%-100)*360000
exit /b %tick%
