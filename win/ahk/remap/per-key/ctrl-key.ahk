
; Left Control

#if HOTKEYS_ON
    *LCtrl::
        global isNeedToCancel 

        SendEvent {Ctrl DownR}
        KeyWait, LCtrl
        SendEvent {Ctrl Up}
	;MsgBox, Hello
	;MsgBox, %A_PriorKey%
        if (A_PriorKey = "LControl") {
	    ;MsgBox, Hello2
            if WinExist("ahk_exe DeepL.exe") and WinExist("ahk_exe Lingvo.exe") or WinExist("ahk_exe DeepL.exe") {
                WinClose, ahk_exe Lingvo.exe
                WinClose, ahk_exe DeepL.exe
            }
            if (WinActive("ahk_exe PowerToys.Peek.UI.exe")) {
                WinClose, ahk_exe PowerToys.Peek.UI.exe
            }
            if (!isNeedToCancel) {
                Send {Esc}
                english()
            }
            isNeedToCancel := false
        }
    return
#if 

