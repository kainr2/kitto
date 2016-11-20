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

;===========================================================
; Remap Home & End
; The Shortcuts
;    Alt + ; => Home
;    Alt + ' => End
;
; vim Shortcuts
;    Alt + k => UP
;    Alt + h => LEFT
;    Alt + l => RIGHT
;    Alt + j => DOWN
;
;!;::SendInput,{HOME}
;!'::SendInput,{END}
;!k::SendInput,{UP}
;!h::SendInput,{LEFT}
;!l::SendInput,{RIGHT}
;!j::SendInput,{DOWN}


; ===========================================================================
; Run a program or switch to it if already running.
;    Target - Program to run. E.g. Calc.exe or C:\Progs\Bobo.exe
;    WinTitle - Optional title of the window to activate.  Programs like
;       MS Outlook might have multiple windows open (main window and email
;       windows).  This parm allows activating a specific window.
; https://webcache.googleusercontent.com/search?q=cache:7hOyESJcuR8J:https://autohotkey.com/board/topic/7129-run-a-program-or-switch-to-an-already-running-instance/+&cd=5&hl=en&ct=clnk&gl=us
; ===========================================================================
RunOrActivate(Target, WinTitle = "")
{
	; Get the filename without a path
	SplitPath, Target, TargetNameOnly

	Process, Exist, %TargetNameOnly%
	If ErrorLevel > 0
		PID = %ErrorLevel%
	Else
		Run, %Target%, , , PID

	; At least one app (Seapine TestTrack wouldn't always become the active
	; window after using Run), so we always force a window activate.
	; Activate by title if given, otherwise use PID.
	If WinTitle <> 
	{
		SetTitleMatchMode, 2
		WinWait, %WinTitle%, , 3
		TrayTip, , Activating Window Title "%WinTitle%" (%TargetNameOnly%)
		WinActivate, %WinTitle%
	}
	Else
	{
		WinWait, ahk_pid %PID%, , 3
		TrayTip, , Activating PID %PID% (%TargetNameOnly%)
		WinActivate, ahk_pid %PID%
	}


	SetTimer, RunOrActivateTrayTipOff, 1500
}

; Turn off the tray tip
RunOrActivateTrayTipOff:
	SetTimer, RunOrActivateTrayTipOff, off
	TrayTip
Return

; Example uses...
; #b::RunOrActivate("C:\Program Files\Seapine\TestTrack Pro\TestTrack Pro Client.exe")
; #c::RunOrActivate("control panel")
; #n::RunOrActivate("uedit32.exe")
; Outlook can have multiple child windows, so specify which window to activate
; #o::RunOrActivate("C:\Program Files\Microsoft Office\OFFICE11\OUTLOOK.EXE", "Microsoft Outlook")
;
; ALT + "." to run Console.exe
; !.::RunOrActivate("D:\portable\bin\ConsoleZ.x64.1.12.0.14282\Console.exe")
;
