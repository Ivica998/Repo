@echo off
REM this is a comment
REM '@echo off' - disable an output of commands on cmd
REM %1 - first argument , %~1 - arg without extention(.smtg)
REM if filename is ""
if "%1"=="" (
    REM output 
    REM echo "Usage: dom <filename>"
    REM exit /b
    set "skip=1"
)
REM set current session variable
set "target=C:\PATH_PROGRAMS\tmp"
REM /d to allow partition change as well
cd /d %target%
if not exist "Domaci" (
    REM '2 > nul' - redirect stderr(2) to nul, which deletes text output
    mkdir "Domaci" 2 > nul
)
set "fn=%1.docx"
setlocal enabledelayedexpansion
if not exist "Domaci\%fn%" (
    REM '!var!' is delayed expression; regular, with $, doesnt work
    if !skip! NEQ 1 (
        touch "Domaci\%fn%"
    )
)
if exist "Domaci\%fn%" (
    REM open file in Microsoft Word
    start "" /MIN winword.exe "Domaci\%fn%"
)
REM Check if an explorer process is already open for "Domaci"
REM /V - verbose, | - pipe output to input of next command
REM '> nul' - redirect stdout to nul(delete); 
REM '2>&1' - redirect stderr to same place where stdin(&1) went(which is nul)
tasklist /FI "IMAGENAME eq explorer.exe" /V | findstr /I "Domaci" > nul 2>&1
if %errorlevel% NEQ 0 (
    start "" /MIN explorer.exe "Domaci"
)
REM doesnt work with .exe; 'start "" code ..' will open unwanted cmd as well
REM code ..
REM '/B' opens in current cmd, therefore suppressing unwanted cmd
REM '/MIN' opens in minimized mode, therefore avoiding focus change
REM start "" /B /MIN code ..
REM dont open if its already opened, so to not change focus
tasklist /FI "IMAGENAME eq code.exe" | findstr /I "code.exe" > nul
if %errorlevel% NEQ 0 (
    start "" /B /MIN code .
)