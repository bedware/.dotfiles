#if ScopeIs("Excalidraw Plus ahk_exe msedge.exe")
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
    !c::+!c
    !d::+!d
#if

#if ScopeIs("Excalidraw Plus ahk_exe msedge.exe") && GetKeyState("Space", "P")
    a::Send ^+p
    f::Send ^p
#if
