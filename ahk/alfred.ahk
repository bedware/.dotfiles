; By Dmitry Surin aka bedware

; Alfred

ShowAlfred() {
    ; TaskBar overload
    Gui, -Caption -Border -Toolwindow +AlwaysOnTop +DPIScale
    Gui, Margin, 0, 0
    Gui, Add, ActiveX, w2000 h60, % "mshtml:<div style='border-bottom: 120px solid rgb(255, 222, 93); height: 0; margin: -10px 0 0 -10px;'></div>"
    Gui, Show, xCenter y2076 NoActivate
}

HideAlfred() {
    Gui, Hide
}

RunAlfred(apps) {
    shortcutsList := ""
    for index, app in apps {
        shortcutsList := shortcutsList . index . ","
    }
    shortcutsList := SubStr(shortcutsList, 1, -1)

    ShowAlfred()

    Input, userInput, T8 L5, {LShift}, %shortcutsList%
    if (ErrorLevel = "Max")
    {
        PlayErrorSound()
        HideAlfred()
        MsgBox, You entered "%userInput%", which is the maximum length of text.
        return
    }
    if (ErrorLevel = "Timeout")
    {
        PlayErrorSound()
        HideAlfred()
        return
    }
    if (ErrorLevel = "NewInput") {
        HideAlfred()
        return
    }
    If InStr(ErrorLevel, "EndKey:")
    {
        PlayErrorSound()
        HideAlfred()
        return
    }

    ; Otherwise, a match was found.
    if (IsObject(apps[(userInput)])) {
        app := apps[(userInput)]
        if (app.funcName != "") {
            Func(app.funcName).Call()
        } else if (app.selector != "") {
            RunIfNotExist(app.selector, app.executablePath)
        } else {
            Run % app.executablePath
        }
    }
    HideAlfred()
}

