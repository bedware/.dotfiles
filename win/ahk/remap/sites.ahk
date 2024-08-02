#if WinActive("Workona ahk_exe chrome.exe")
    *Enter::
        Send {Enter}
        Sleep 150
        WinMaximize, A
    return
#if

#if WinActive("Excalidraw Plus ahk_exe msedge.exe")
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

#if WinActive("Excalidraw Plus ahk_exe msedge.exe") && GetKeyState("Space", "P")
    a::Send ^+p
    f::Send ^p
#if
