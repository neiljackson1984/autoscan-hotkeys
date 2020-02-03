; this file contains nothing other than hotkey definitions.
; the library of functions that these hotkey definitions depend on is in a separate file, called neil_hotkeys_lib.ahk, which this file includes.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include %A_ScriptDir% 
#include autoscan_hotkeys_lib.ahk
#Include %A_ScriptDir% 


chordMode:=false ;; I will use this variable to enable some hotkeys conditionally only when chordMode is true.  There will be one hotkey which will set chordmode to true.


#if,chordMode
    1::
    #1::
        GoSub,exitChordMode
        respondToSpecialNumberDown(1)
    return
    2::
    #2::
        GoSub,exitChordMode
        respondToSpecialNumberDown(2)
    return
    3::
    #3::
        GoSub,exitChordMode
        respondToSpecialNumberDown(3)
    return
    4::
    #4::
        GoSub,exitChordMode
        respondToSpecialNumberDown(4)
    return
    5::
    #5::
        GoSub,exitChordMode
        respondToSpecialNumberDown(5)
    return
    
    d::
        GoSub,exitChordMode
        ; dials the selected text as a phone number using "dial ..." command sent to the shell.
        digitString:=RegExReplace(getSelectedText(), "\D", "") ; replace any non digits with an empty string (he result is only the digits.
        run % "dial" . " " . """" .  digitString  . """" 
    return
    
    ;;ideally, the key for this next command should be 'the very modifier key that was held down along with z that got us into chordMode'.
    ;; the idea with this next command is that we could do away with the timer-based method of getting out of chordMode and instead use the release of the
    ;; modifier key as the only way to get out of chord mode.  this would create a more comfortable, consistent user experience (the potential downside of 
    ;; doing away with the timer is that it would force the user to
    ;; hold down the modifier key while tapping the subsequent keys in the sequence, which might be physically awkward.)
    ; LWin UP::
    ; RWin UP::
        ; GoSub,respondToTheReleaseOfTheModifierKeyThatGotUsIntoChordMode
    ; return
#if

#if (chordMode && (modifierKeyThatGotUsIntoChordMode="LWin"))
    LWin UP::
        SoundBeep, 330, 180
        GoSub,respondToTheReleaseOfTheModifierKeyThatGotUsIntoChordMode
    return
    
    *Alt::
        SoundBeep, 220, 90
    return
        
#if


#if (chordMode && (modifierKeyThatGotUsIntoChordMode="RWin"))
    RWin UP::
        GoSub,respondToTheReleaseOfTheModifierKeyThatGotUsIntoChordMode
    return
#if

; ideally, we want to keep chordMode on indefinitely as long as the "Windows" modifier key remains depressed.
; In fact, it might make sense to use the modifier key being held down as the only thing that causes chordMode to stay on, and do away with the timer.  (or maybe the timer is still potentially useful.)
; I insticintively don't like the timer-based approach because of the mode-iness that the timer introduces; the user's awareness of, and control over, the mode, is reduced by using the timer.
; I may not be misuing the word "chord".  The interaction I am creating is something more like a sequence of taps.

<#z::
    modifierKeyThatGotUsIntoChordModeIsStillHeldDown:=true
    modifierKeyThatGotUsIntoChordMode:="LWin"
    GoSub,enterChordMode
return

>#z::
    modifierKeyThatGotUsIntoChordModeIsStillHeldDown:=true
    modifierKeyThatGotUsIntoChordMode:="RWin"
    GoSub,enterChordMode
return

enterChordMode:
;MsgBox % (modifierKeyThatGotUsIntoChordMode . " UP")
;MsgBox % GetKeyName("{" . modifierKeyThatGotUsIntoChordMode . " UP" . "}")
;MsgBox % GetKeyName(modifierKeyThatGotUsIntoChordMode)
    ; MsgBox modifierKeyThatGotUsIntoChordMode: %modifierKeyThatGotUsIntoChordMode%
    ; Hotkey, %modifierKeyThatGotUsIntoChordMode% UP, respondToTheReleaseOfTheModifierKeyThatGotUsIntoChordMode, On
    chordMode:=true 
    ;MsgBox chord mode is enabled    
    Menu,TRAY,Icon,C:\Program Files\AutoHotkey\AutoHotkey.exe,3 
    TrayTip,chordMode enabled,"yes it is",9000 ;this is not working
    SplashTextOn, , , chordMode enabled, 
    SetTimer,checkToSeeIfWeShouldExitChordMode,-6000  ;turn off chord mode in 6000 milliseconds, then disable the timer
return

checkToSeeIfWeShouldExitChordMode:
    SetTimer,checkToSeeIfWeShouldExitChordMode,Off  ; disable any timer that might be set for checkToSeeIfWeShouldExitChordMode
    If(!modifierKeyThatGotUsIntoChordModeIsStillHeldDown)
    {
        GoSub,exitChordMode
    }
return

exitChordMode:
    ; Hotkey, %modifierKeyThatGotUsIntoChordMode% UP, Off
     TrayTip  ;; remove any currently-dsiplayed tray tip
     Menu,TRAY,Icon,* ;;set the icon back to default
     SplashTextOff
     ;MsgBox chord mode is disabled    
     chordMode:=false
return

respondToTheReleaseOfTheModifierKeyThatGotUsIntoChordMode:
    modifierKeyThatGotUsIntoChordModeIsStillHeldDown:=false
    GoSub,exitChordMode
return

#T::
    Run outlook
return


#s::
    FileRead, signature, %A_ScriptDir%\signature1.txt
    paste(signature)
return

#!s::
    ; type my signature2
    FileRead, signature, %A_ScriptDir%\signature2.txt
    paste(signature)
return

#n::
	typeATimestamp("yyyy-MM-dd-HHmm")
return

#!n::
	typeATimestamp("yyyy.MM.dd-HHmm")
return



; Google the currently selected text.
; Sends Ctrl+c to the current window to capture the text
; preserves the original contents of the clipboard after it is done
#g::
	; ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	; sleep 100 ;I added this line as an empirical fix to a pathology I encountered using this hotkey in Adobe reader: Adobe reader complained that an error had occured copying to the clipboard.  Inserting this Sleep statement seemed to prevent this patholgy.  It is as if the above command to save the current clipboard ties up the clipboard file for a short period, and if you try to write to the clipboard in that period you get an error.  This Sleep waits long enough for that period to pass, or so it seems.
	; ; ... here make temporary use of the clipboard
	; Send ^c  ; copy whatever text is selected, by sending ctrl-c to the active window
	; Sleep 100 ;
	; ; Run, "http://google.com/search?q=%clipboard%"
	; google(clipboard)
	; Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	; ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	google(getSelectedText())
return

; google the current contents of the clipboard
#!g::
    google(clipboard)
return


#i::
    ; MsgBox A_SendLevel: %A_SendLevel%
    SendInput, % guid()
return


; #x::
; Run, "U:\RDP shortcuts\vnc_to_gantrymill.vnc"
; return



;; Control-shift-v: type the clipboard as plain text
^+v::
    SendInput {Raw}%clipboard%

;; here is an alternative for slow deliberate keystrokes:
; SendMode Event
; SetKeyDelay 25
; Send {Raw}%clipboard%
return

