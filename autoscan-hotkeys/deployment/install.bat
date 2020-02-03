@echo off

set directoryOfThisScript=%~dp0
set installDirectory=%programfiles%\

echo Now installing [[[[ PUT SOMETHING MEANINGFUL HERE ]]]]

@REM THE FOLLOWING COMMANDS ARE A WAY TO INVOKE A POWERSHELL SCRIPT.
Powershell.exe -NonInteractive -command "Set-ExecutionPolicy Unrestricted"
Powershell.exe -NonInteractive -command "%directoryOfThisScript%[[[[[[[[NAME OF POWERSHELL SCRIPT TO EXECUTE]]]]]].ps1"

@REM if you need to copy files into c:\windows\system32, use the 'sysnative' virtual directory as in the below example.
copy /Y "%directoryOfThisScript%SysinternalsSuite\*" "%SystemRoot%\Sysnative\"

echo.
echo This window will close in 20 seconds...
timeout /t 20 >nul
exit