; Shifts
ToggleCaps(){
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}

; Modifiers handling
SendWithCorrectModifiers(key) {
    OutputDebug % "Shift:" GetKeyState("Shift") ",Ctrl:" GetKeyState("Ctrl") ",Alt:" GetKeyState("Alt")  
    if (GetKeyState("Shift") and GetKeyState("Ctrl") and GetKeyState("Alt"))
        Send !+^{%key%}
    else if (GetKeyState("Shift") and GetKeyState("Ctrl"))
        Send +^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Ctrl"))
        Send !^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Shift"))
        Send !+{%key%}
    else if (GetKeyState("Shift"))
        Send +{%key%}
    else if (GetKeyState("Ctrl"))
        Send ^{%key%}
    else if (GetKeyState("Alt"))
        Send !{%key%}
    else
        Send {%key%}
}

