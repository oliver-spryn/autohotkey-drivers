#SingleInstance force

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Read the configuration file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; File locatoin
configFile = config.db

; Test settings
annotation =
browserN =
browserV =
client =
env =
patho =

; Browser settings
chromeN =
chromeV =
firefoxN =
firefoxV =
ieN =
ieV =
icN =
icV =

IfExist, %configFile%
{
	key =

	Loop, read, %configFile%
	{
		Loop, parse, A_LoopReadLine, =, %A_Space%%A_Tab%
		{
			if(key == "Annotation Type") {
				annotation := A_LoopField
			} else if (key == "Client Machine Name") {
				client := A_LoopField
			} else if (key == "Test Environment") {
				env := A_LoopField
			} else if (key == "Pathology Build") {
				patho := A_LoopField
			} else if (key == "Chrome Name") {
				chromeN := A_LoopField
			} else if (key == "Chrome Version") {
				chromeV := A_LoopField
			} else if (key == "Firefox Name") {
				firefoxN := A_LoopField
			} else if (key == "Firefox Version") {
				firefoxV := A_LoopField
			} else if (key == "IE Name") {
				ieN := A_LoopField
			} else if (key == "IE Version") {
				ieV := A_LoopField
			} else if (key == "Installed Client Name") {
				icN := A_LoopField
			} else if (key == "Installed Client Version") {
				icV := A_LoopField
			}

			key := A_LoopField
		}
	}
} else {
	MsgBox, 16, Configuration Error, Whoa! There isn't a configuration file here!
	ExitApp
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Tool tray menu options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Menu, Tray, Tip, Chrome

Menu, Tray, nostandard
Menu, Tray, Add, Chrome, chrome
Menu, Tray, Check, Chrome
Menu, Tray, Add, Firefox, firefox
Menu, Tray, Add, Internet Explorer, ie
Menu, Tray, Add, Installed Client, ic
Menu, Tray, Add, Edit Configuration, edit
Menu, Tray, Add, Reload, reload
Menu, Tray, Add, Exit, exit

option = chrome
optionText := chromeN
optionVersion := chromeV

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Start the test set
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Config
na = N/A

; Fill out the initial form
^#a::
if(option == "chrome") {
	browserN := chromeN
	browserV := chromeV
} else if (option == "firefox") {
	browserN := firefoxN
	browserV := firefoxV
} else if (option == "ie") {
	browserN := ieN
	browserV := ieV
} else if (option == "ic") {
	browserN := icN
	browserV := icV
}

Send, {tab}{tab}{tab}{tab}   ; Get to the first field
Send, %annotation%{tab}%client%{tab}%patho%{tab}%na%{tab}%browserN%{tab}%browserV%{tab}%patho%{tab}{tab}%na%{tab}{tab}%env%{tab}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pass the test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#p::
NumpadAdd::
WinGet, active, ID, A

IfWinExist, Manual Runner: Test Set
{
	WinActivate
	Send, ^p

	WinActivate, ahk_id %active%
}

return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Fail the test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#f::
NumpadSub::
CoordMode, Mouse, Screen
MouseGetPos, mouseX, mouseY

IfWinExist, Manual Runner: Test Set
{
	WinActivate

	WinGetPos, winX, winY, winW, winH, A
	MouseMove, winX + winW - 100, winY + 100
	Click
	Send, ^f

	MouseMove, winX + winW - 100, winY + winH - 100
	Click

	MouseMove, %mouseX%, %mouseY%
}

return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Finish the test case
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#d::
NumpadEnter::
WinGet, active, ID, A

IfWinExist, Manual Runner: Test Set
{
	WinActivate
	Send, ^q

	WinActivate, ahk_id %active%
}

return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Edit the script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#e::
edit:
Run, notepad.exe %configFile%, , , PID
Process, WaitClose, %PID%
MsgBox, 4, Reload Macro, Do you want to reload this macro to read in the new configuration changes?

IfMsgBox Yes
	Reload

return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Reload the script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#r::
reload:
Reload
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Exit the script
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

^#x::
exit:
ExitApp
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Set the different browsers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

removeOld() {
	Menu, Tray, Uncheck, Chrome
	Menu, Tray, Uncheck, Firefox
	Menu, Tray, Uncheck, Internet Explorer
	Menu, Tray, Uncheck, Installed Client
}

tip(browser, version) {
	if (version != "N/A") {
		TrayTip, Changed Mode, The script is now configured to run for %browser% %version%, 10, 1
	} else {
		TrayTip, Changed Mode, The script is now configured to run for %browser%, 10, 1
	}
}

toggleNew() {
	global option

	if(option == "chrome") {
		Menu, Tray, Check, Chrome
		Menu, Tray, Tip, Chrome
	} else if (option == "firefox") {
		Menu, Tray, Check, Firefox
		Menu, Tray, Tip, Firefox
	} else if (option == "ie") {
		Menu, Tray, Check, Internet Explorer
		Menu, Tray, Tip, Internet Explorer
	} else if (option == "ic") {
		Menu, Tray, Check, Installed Client
		Menu, Tray, Tip, Installed Client
	}
}

^#Q::
IfWinExist, Manual Runner: Test Set
{
	WinSet, AlwaysOnTop, On, Manual Runner: Test Set
	WinSet, AlwaysOnTop, Off, Manual Runner: Test Set
}
return

^#Left::
^#Right::
WinGet, active, ID, A

IfWinExist, Manual Runner: Test Set
{
	WinActivate
	WinMaximize
	WinRestore
	SendInput, #{Left}
	SendInput, #{Left}
	SendInput, #{Up}

	WinActivate, ahk_id %active%
	WinSet, Top, , Manual Runner: Test Set
}
return

^#0::
if (optionVersion != "N/A") {
	TrayTip, Active Mode, The script is configured to run for %optionText% %optionVersion%, 10, 1
} else {
	TrayTip, Active Mode, The script is configured to run for %optionText%, 10, 1
}

return

^#1::
tip(chromeN, chromeV)

chrome:
removeOld()
option = chrome
optionText := chromeN
optionVersion := chromeV
toggleNew()
return

^#2::
tip(firefoxN, firefoxV)

firefox:
removeOld()
option = firefox
optionText := firefoxN
optionVersion := firefoxV
toggleNew()
return

^#3::
tip(ieN, ieV)

ie:
removeOld()
option = ie
optionText := ieN
optionVersion := ieV
toggleNew()
return

^#4::
tip("the Installed Client", icV)

ic:
removeOld()
option = ic
optionText = Installed Client
optionVersion := icV
toggleNew()
return
