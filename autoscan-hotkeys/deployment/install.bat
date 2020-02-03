@echo off
echo Now installing AUTOSCAN HOTKEYS
set directoryOfThisScript=%~dp0
set installDirectory=%localappdata%\autoscan-hotkeys\
taskkill /f /im autohotkey.exe
mkdir %installDirectory%
copy /y "%directoryOfThisScript%autoscan_hotkeys.ahk" "%installDirectory%autoscan_hotkeys.ahk" 
copy /y "%directoryOfThisScript%autoscan_hotkeys_lib.ahk" "%installDirectory%autoscan_hotkeys_lib.ahk"

echo.
echo Configuring autoscan-hotkeys to run on startup
@rem  confoigure the hotkeys to run on startup.
set pathOfAhkScript=%installDirectory%autoscan_hotkeys.ahk
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /V "autoscan_hotkeys" /t REG_SZ /d "autohotkey \"%pathOfAhkScript%\"" /f

echo.
echo installing AutoHotkey, silently.  Please wait...
@rem launch the autohotkey installer
start "" /wait "%directoryOfThisScript%AutoHotkey_1.1.32.00_setup.exe" /S

echo launching autoscan-hotkeys
start /b "" autohotkey "%pathOfAhkScript%"
@REM THE FOLLOWING COMMANDS ARE A WAY TO INVOKE A POWERSHELL SCRIPT.
REM Powershell.exe -NonInteractive -command "Set-ExecutionPolicy Unrestricted"
REM Powershell.exe -NonInteractive -command "%directoryOfThisScript%[[[[[[[[NAME OF POWERSHELL SCRIPT TO EXECUTE]]]]]].ps1"

@REM if you need to copy files into c:\windows\system32, use the 'sysnative' virtual directory as in the below example.
REM copy /Y "%directoryOfThisScript%SysinternalsSuite\*" "%SystemRoot%\Sysnative\"
echo.
echo This window will close in 20 seconds...
timeout /t 20 >nul
exit