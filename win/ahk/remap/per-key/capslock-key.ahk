; Capslock

#if !raceMode
    *CapsLock::
        global isNeedToCancel 

        SendEvent {Ctrl DownR}
        KeyWait, Capslock
        SendEvent {Ctrl Up}
        if (A_PriorKey = "Capslock") {
            if WinExist("ahk_exe DeepL.exe") and WinExist("ahk_exe Lingvo.exe") or WinExist("ahk_exe DeepL.exe") {
                WinClose, ahk_exe Lingvo.exe
                WinClose, ahk_exe DeepL.exe
            }
            if (WinActive("ahk_exe PowerToys.Peek.UI.exe")) {
                WinClose, ahk_exe PowerToys.Peek.UI.exe
            }
            if (!isNeedToCancel) {
                Send {Esc}
            }
            isNeedToCancel := false
        }
    return
#if 

