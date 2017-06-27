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
;~LWin Up:: return
;~RWin Up:: return


;
; Alt & .::SendInput,{HOME}
; Alt & /::SendInput,{END}
Alt & ,::
  holdCtrl := GetKeyState("Ctrl", "P")
  holdShift := GetKeyState("Shift", "P")
  homeChar = {HOME}
  If (holdCtrl and holdShift) {
    SendInput,+^%homeChar%
  } Else If (holdCtrl) {
    SendInput,^%homeChar%
  } Else If (holdShift) {
    SendInput,+%homeChar%
  } Else {
    SendInput,%homeChar%
  }
return
Alt & .::
  holdCtrl := GetKeyState("Ctrl", "P")
  holdShift := GetKeyState("Shift", "P")
  endChar = {END}
  If (holdCtrl and holdShift) {
    SendInput,+^%endChar%
  } Else If (holdCtrl) {
    SendInput,^%endChar%
  } Else If (holdShift) {
    SendInput,+%endChar%
  } Else {
    SendInput,%endChar%
  }
return

