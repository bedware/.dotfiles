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
    ; TaskBar overlap
    Gui, -Caption -Border -Toolwindow +AlwaysOnTop +DPIScale
    Gui, Margin, 0, 0
    Gui, Add, ActiveX, w2000 h48, % "mshtml:<div style='border-bottom: 120px solid rgb(255, 222, 93); height: 0; margin: -10px 0 0 -10px;'></div>"
    Gui, Show, xCenter y2076 NoActivate
}

hideAlfred() {
    Gui, Hide
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
            Run % app.path
        }
    }
}
