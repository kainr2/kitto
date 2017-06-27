; IMPORTANT INFO ABOUT GETTING STARTED: Lines that start with a
; semicolon, such as this one, are comments.  They are not executed.

; This script has a special filename and path because it is automatically
; launched when you run the program directly.  Also, any text file whose
; name ends in .ahk is associated with the program, which means that it
; can be launched simply by double-clicking it.  You can have as many .ahk
; files as you want, located in any folder.  You can also run more than
; one ahk file simultaneously and each will get its own tray icon.

; SAMPLE HOTKEYS: Below are two sample hotkeys.  The first is Win+Z and it
; launches a web site in the default browser.  The second is Control+Alt+N
; and it launches a new Notepad window (or activates an existing one).  To
; try out these hotkeys, run AutoHotkey again, which will load this file.
; https://www.autohotkey.com/docs/KeyList.htm
; #z::Run www.autohotkey.com

#n::
IfWinExist Untitled - Notepad
	WinActivate
else
	Run Notepad
return

; Disable Win key from opening start menu
; http://www.autohotkey.com/board/topic/51631-disable-windows-key-start-menu-but-not-shortcuts/
~LWin Up:: return
~RWin Up:: return


#c::PrintScreen

; Map PrintScreen button to End
;  PrtSc  => End
; http://forumserver.twoplustwo.com/45/software/ahk-key-combo-three-key-combo-1055069/
PrintScreen::End

;
; Map RAlt+Space to run Launchy.exe application
; * Wait a second key, or else it acts like HOME button
; * use "~" to let it fall through
; * use "Input" instead of keywait if there are more combo keys
;
~RAlt::SendInput {Home}
; RAlt & Space::
; KeyWait,space,D
; If (ErrorLevel = 0)
;   Run Launchy.exe /show,D:\Program Files (x86)\Launchy 
; return
Ctrl & RAlt::
  SendInput ^{Home}
return
Shift & RAlt::
  SendInput +{Home}
return
; This detects "double-clicks" of the alt key.
~Alt::
  DoubleAlt := A_PriorHotKey = "~Alt" AND A_TimeSincePriorHotkey < 400
  Sleep 0
  KeyWait Alt  ; This prevents the keyboard's auto-repeat feature from interfering.
return

