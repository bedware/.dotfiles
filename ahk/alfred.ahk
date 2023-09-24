; By Dmitry Surin aka bedware

; Alfred

RunAlfred(apps) {
    showAlfred()

    ; Wait for user input
    Input, userInput, T8 L5, {LShift}, % getShortuctsByComa(apps)
    if (ErrorLevel = "Max")
    {
        PlayErrorSound()
        hideAlfred()
        MsgBox, You entered "%userInput%", which is the maximum length of text.
        return
    }
    if (ErrorLevel = "Timeout")
    {
        PlayErrorSound()
        hideAlfred()
        return
    }
    if (ErrorLevel = "NewInput") {
        hideAlfred()
        return
    }
    If InStr(ErrorLevel, "EndKey:")
    {
        PlayErrorSound()
        hideAlfred()
        ; MsgBox, Endkey pressed!
        Sleep 100
        return
    }
    executeInput(apps, userInput)
    hideAlfred()
}

showAlfred() {
    ; Run, calc
    ; selector := "Calculator"
    Run, % HOME . "\.dotfiles\ahk\ahk-overlay.exe"
    selector := "ahk-overlay"
    WinWait, %selector%,, 5
    if ErrorLevel
    {
        PlayErrorSound()
    }
    if WinExist(selector) {
        WinActivate
        WinSet, AlwaysOnTop, On, %selector%
        WinGet, activeHwnd, ID, %selector%
        PinWindow(activeHwnd)
    }

    OutputDebug % "Alfred show"
}

hideAlfred() {
    ; selector := "Calculator"
    selector := "ahk-overlay"

    if WinExist(selector) {
        WinClose, % selector 
    }

    OutputDebug % "Alfred hide"
}

getShortuctsByComa(apps) {
    ; e.g. "term,slack,tg"
    shortcutsByComa := ""
    for index, app in apps {
        shortcutsByComa := shortcutsByComa . index . ","
    }
    return SubStr(shortcutsByComa, 1, -1)
}

executeInput(apps, userInput) {
    global desktops
    if (IsObject(apps[userInput])) { ; Otherwise, a match was found.
        app := apps[userInput]
        if (app.funcName != "") {
            Func(app.funcName).Call()
        } else if (app.selector != "") {
            OutputDebug % "Im going to run " app.path " on " app.selector
            RunIfNotExist(app.selector, app.path)
            OutputDebug % "executed"
            if (app.desktop != "") {
                OutputDebug % "executed inside"
                num := IndexOf(app.desktop, desktops)
                current := GetCurrentDesktopNumber()
                OutputDebug % "app's desktop:" num
                OutputDebug % "current desktop:" current
                if (num != current) {
                    MoveActiveWinAndGoToVD(num)
                }
            }
        } else {
            OutputDebug % "Im going to run the app without selector"
            Run % app.path
        }
    }
}
