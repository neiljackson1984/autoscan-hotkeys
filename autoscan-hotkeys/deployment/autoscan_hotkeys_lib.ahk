;#InstallMouseHook ;;testing something. -Neil
; #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
DetectHiddenWindows, On
SetTitleMatchMode, 1


#Include %A_ScriptDir%  ; Changes the working directory for subsequent #Includes and FileInstalls.  Note: SetWorkingDir does not have any effect on the driectory for includes, because the #include statements are processed before the program runs (compile time vs. run time)


respondToSpecialNumberDown(n)
{
	Local projectPath
	Local tempDirectory
    Local pathStackFile ;; we will set this to the fully qualified path to the file that stores the path stack.
    
    EnvGet, tempDirectory, TEMP
    
    ; pathStackFile=%A_ScriptDir%\projectPath.txt
    pathStackFile=%tempDirectory%/projectPath.txt
    

	; read projectPath from projectPath.txt
	FileReadLine, projectPath, %pathStackFile%, n
	
	If (GetKeyState("LWin") || GetKeyState("RWin") )  ; if a windows key is down or if the star button is down...
	{
		;MsgBox ahoy
		run explorer "%projectPath%"
	} Else
	{
		; SendRaw %projectPath%\ 
		; SendEvent {Raw}%projectPath%\ 
		
		
		originalSendMode:=A_SendMode
		SendMode Event
		originalKeyDelay:=A_KeyDelay
		SetKeyDelay:=100
		paste(projectPath)
		SetKeyDelay %originalKeyDelay%
		SendMode %originalSendMode%
		
		;the above thrashing around with send mode is in an effort to make the functionality work reliably within a remote desktop session.
	}
}



; this function googles a string
google(x)
{
	Run, "http://google.com/search?q=%x%"
}


; this function gets the currently selected text (relies on sending a ctrl-c, and then reading the clipboard, but leaves the contents of the clipboard as they were initially.)
; this function is likely to return an unexpected result in the case where no text is selected.  We would want to return an empty string.  However, ion most text editors,
; sending a ctrl-c keystroke when nothing is selected results in no change to the clipboard (i.e. whatever was there originally will still be there.)
; I could look whether the contents of the clipboard changed after sending the control-c, but this would still not let me detect the case of nothing selected because the 
; user might happen to have selected some text that is exactly the same as what happens to be in the clipboard.
; oops.  I was getting ready to use the OnClipboardChanged event to detect the empty selection state, and then I realized that I had already solved this problem by setting the Clipboard to the empty string as part of this function, which is a much more elegant solution.

getSelectedText() 
{
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	Clipboard := "" ; clear the clipboard, just in case the copy command fails, we won't return the previous clipboard contents.
	sleep 80 ;I added this line as an empirical fix to a pathology I encountered using this hotkey in Adobe reader: Adobe reader complained that an error had occured copying to the clipboard.  Inserting this Sleep statement seemed to prevent this patholgy.  It is as if the above command to save the current clipboard ties up the clipboard file for a short period, and if you try to write to the clipboard in that period you get an error.  This Sleep waits long enough for that period to pass, or so it seems.
	; ... here make temporary use of the clipboard
	Send ^c  ; copy whatever text is selected, by sending ctrl-c to the active window
	Sleep 100 ;
	returnValue := clipboard
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	return returnValue
}

; this function is similar to getSelectedText but uses Ctrl-x instead of Ctrl-c, in order to cut the selected text.
cutSelectedText() 
{
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	Clipboard := "" ; clear the clipboard, just in case the copy command fails, we won't return the previous clipboard contents.
	sleep 80 ;I added this line as an empirical fix to a pathology I encountered using this hotkey in Adobe reader: Adobe reader complained that an error had occured copying to the clipboard.  Inserting this Sleep statement seemed to prevent this patholgy.  It is as if the above command to save the current clipboard ties up the clipboard file for a short period, and if you try to write to the clipboard in that period you get an error.  This Sleep waits long enough for that period to pass, or so it seems.
	; ... here make temporary use of the clipboard
	Send ^x  ; cut whatever text is selected, by sending ctrl-x to the active window
	Sleep 100 ;
	returnValue := clipboard
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	return returnValue
}

; this function uses ctrl-x keystroke, and a  few others, and the clipboard, to retrieve the contents of the current line in a text editor
; this function leaves the origianl contents of the clipboard intact when it is finished.
cutCurrentLine() 
{
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	Clipboard := "" ; clear the clipboard, just in case the copy command fails, we won't return the previous clipboard contents.
	;; send {Home} and then Shift-End keystrokes to select the current line.
	Send {Home}
	Send +{End}
	sleep 80 ;
	Send ^x  ; CUT whatever text is selected, by sending ctrl-c to the active window
	Send {End} ; send End to bring the cursor to the end of the line and deselect all.
	Sleep 100 ;
	returnValue := clipboard
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	return returnValue
}


; similar to cutCurrentLine(), but does not remove the line
getCurrentLine() 
{
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	Clipboard := "" ; clear the clipboard, just in case the copy command fails, we won't return the previous clipboard contents.
	;; send {Home} and then Shift-End keystrokes to select the current line.
	Send {Home}
	Send +{End}
	sleep 40 ;
	Send ^c  ; COPY whatever text is selected, by sending ctrl-c to the active window
	Send {End} ; send End to bring the cursor to the end of the line and deselect all.
	Sleep 40 ;
	returnValue := clipboard
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	return returnValue
}

; similar to cutCurrentLine(), but does not remove the line
getCurrentLineOnOneSideOfCursor(sideSpec) 
{
	;sideSpec can be zero for the left of the cursor, or 1 for the right of the cursor
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard to a variable of your choice.
	Clipboard := "" ; clear the clipboard, just in case the copy command fails, we won't return the previous clipboard contents.
	;; send {Home} and then Shift-End keystrokes to select the current line.
	If(sideSpec=0)
	{
		Send +{Home}
	} Else
	{
		Send +{End}
	}
	sleep 10 ;
	Send ^c  ; COPY whatever text is selected, by sending ctrl-c to the active window
	;bring the cursor back to where it was (and deselect)
	If(sideSpec=0)
	{
		Send {Right}
	} Else
	{
		Send {Left}
	}
	Sleep 10 ;
	returnValue := clipboard
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
	return returnValue
}



; this function pastes its argument into the current text editor (by using the clipboard and sending ctrl-v keystroke),
; but it takes care to leave the clipboard as it found it.
paste(x)
{
	ClipSaved := ClipboardAll   ; Save the entire existing clipboard
	Clipboard := x ; set the clipboard to our string that we want to paste
	sleep 100 
	; Send ^v  ; send control-v, which hopefully has the intended effect in the currently-open window.
	Send {Control Down}v{Control Up}
	Sleep 100 ;
	Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
	ClipSaved = ; set ClipSaved to empty to preserve memory, in case ClipboardAll was huge. (Autohtokey help recommmends doing this)
}



addSlashes(x)
{
	x := StrReplace(x, "\", "\\")
	x := StrReplace(x, """", "\""")
	return x
}

; This function uses keystrokes and clipboard (assuming standard text editor keystrokes like Home, End, Shift-Home, Ctrl-C, and Ctrl-V produce the expected results)
; to duplicate the current line (Much like the Ctrl-D command does in Notepad++)
duplicateCurrentLine() 
{
	leftContents := getCurrentLineOnOneSideOfCursor(0)
	Sleep 100
	rightContents := getCurrentLineOnOneSideOfCursor(1)
	contentsOfCurrentLine := leftContents . rightContents
	Send {End} ; send End to bring the cursor to the end of the line and deselect all.
	; paste("`n" . contentsOfCurrentLine)
	Send {Enter}
    paste(contentsOfCurrentLine)
	Send {Up}{Home}
	; at this point, the cursor is at the beginning of the original-line
	
	;; move the cursor to the original location
	i := StrLen(leftContents)
	While( i > 0 ) 
	{
		Send {Right}
		; Sleep 10
		i := i - 1
	}
}

; creates a random guid and returns it
guid()
{
	; thanks to https://autohotkey.com/board/topic/78512-generate-guid/
	return Format("{:L}",RegExReplace(ComObjCreate("Scriptlet.TypeLib").Guid, "\W"))
	;the REGExReplace deletes any characters that are not word characters. (a word characters is any of A-Za-z0-9)
	; the Format() function converts to lower case.
}

; This function emits keystrokes to type date-and-time stamp of the current time in some reasonable format that works well for file names (no spaces or weird characters).
typeATimestamp(format)
{
	FormatTime, timeStampString, , %format%
	Send %timeStampString%
}
