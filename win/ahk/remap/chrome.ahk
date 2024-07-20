#if WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
    or WinActive("ahk_exe firefox.exe")
    or WinActive("ahk_exe Cypress.exe")
    ^g::Send ^+{a} ; Search in tabs popup
    ; ^s::Send ^+{p}
    ^i::Send !{Right} ; Navigation history forward 
    ^o::Send !{Left} ; Navigation history backward
    ^6::
        Send ^+a
        Sleep 150
        Send {Enter}
    return
    !g::
        Send {F6}{F6}
        Sleep 250
        Send {AppsKey}aa{Enter}
    return
#if

#if WinActive("Workona ahk_exe chrome.exe")
    *Enter::
        Send {Enter}
        Sleep 150
        WinMaximize, A
    return
#if

#if WinActive("Excalidraw Plus ahk_exe chrome.exe")
    *RButton::MButton
    *MButton::RButton
    *WheelDown::
        if (GetKeyState("RButton", "P")) {
            Send ^{-}
        } else {
            Send {WheelDown}
        }
    return
    *WheelUp::
        if (GetKeyState("RButton", "P")) {
            Send ^{+}
        } else {
            Send {WheelUp}
        }
    return
#if

