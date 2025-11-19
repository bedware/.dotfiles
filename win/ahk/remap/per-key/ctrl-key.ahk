
; Left Control

#if HOTKEYS_ON
    *LCtrl::
        global isNeedToCancel 

        SendEvent {Ctrl DownR}
        KeyWait, LCtrl
        SendEvent {Ctrl Up}

        if (A_PriorKey = "LControl") {
            if (!isNeedToCancel) {
                Send {Esc}
                english()
            }
            isNeedToCancel := false
        }
    return
#if 

