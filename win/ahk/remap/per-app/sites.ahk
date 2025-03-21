#if ScopeIs("Excalidraw Plus ahk_exe msedge.exe")
    *RButton::MButton
    *MButton::RButton
    *WheelDown::^-
    *WheelUp::^+
    !c::+!c
    !d::+!d
#if

#if ScopeIs("Excalidraw Plus ahk_exe msedge.exe") && GetKeyState("Space", "P")
    a::Send ^+p
    f::Send ^p
#if
