; By Dmitry Surin aka bedware

; Alfred

initAlfred() {
    global UserHome
    ; TaskBar overload
    pic := UserHome "\.dotfiles\ahk\loading.gif"
    Gui, -Caption -Border -Toolwindow +AlwaysOnTop +DPIScale
    Gui, Margin, 0, 0
    Gui, Add, ActiveX, w2000 h60, % "mshtml:<div style='background: rgb(0, 29, 48); width: 100%; height: 100%; margin: -10px 0 0 -10px;'><img src='" pic "' style='margin: -202px -70px; padding-left: 1475px'/></div>"
    Gui, Show, xCenter y2076 NoActivate
    Gui, Hide
    OutputDebug % "Alfred inititalized!"
}
initAlfred()

ShowAlfred() {
    Gui, Show
}

HideAlfred() {
    Gui, Hide
}

runAlfred() {
    global apps

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

