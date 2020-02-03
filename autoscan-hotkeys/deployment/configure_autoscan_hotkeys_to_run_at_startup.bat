@echo off
set directoryOfThisScript=%~dp0
set pathOfAhkScript=%directoryOfThisScript%autoscan_hotkeys.ahk
echo %pathOfAhkScript%
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /V "autoscan_hotkeys" /t REG_SZ /d "autohotkey \"%pathOfAhkScript%\""
pause