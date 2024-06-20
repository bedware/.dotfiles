on := false
#if WinActive("^DevTools ahk_exe chrome.exe")
    ; Debug
    `;:: ; Step
        global on
        if (A_PriorKey = "\") {
            Send {Backspace}`;
            on := false
        } else {
            if (on) {
                Send {F9}
                on := false
            } else {
                on := true
            }
        }
    return
#if on 
    b:: ; Toggle Breakpoint
        global on
        if (on) {
            Send ^b
            on := false
        } else {
            Send b
        }
    return
    d:: ; Disable Breakpoints
        global on
        if (on) {
            Send ^{F8}
            on := false
        } else {
            Send d
        }
    return
    c:: ; Continue
        global on
        if (on) {
            Send {F8}
            on := false
        } else {
            Send c
        }
    return
    i:: ; In
        global on
        if (on) {
            Send {F11}
            on := false
        } else {
            Send i
        }
    return
    o:: ; Out
        global on
        if (on) {
            Send +{F11}
            on := false
        } else {
            Send o
        }
    return
#if
