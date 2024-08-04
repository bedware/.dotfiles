; Mouse

*~RButton::
*~MButton::
*~LButton::
    if (GetKeyState("Capslock", "P")) {
        isNeedToCancel := true
    }
return
*WheelDown::
    if (GetKeyState("RButton", "P")) {
        Send {RButton Up}
        Send +{WheelDown}
    } else {
        Send {WheelDown}
    }
return 
*WheelUp::
    if (GetKeyState("RButton", "P")) {
        Send {RButton Up}
        Send +{WheelUp}
    } else {
        Send {WheelUp}
    }
return 

