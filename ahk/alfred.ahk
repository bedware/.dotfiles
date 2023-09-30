RunAlfred(apps) {
    showAlfred()

    endKey := "LShift"
    timeout := "8" ; seconds
    length := "5" ; chars

    ; Wait for user input
    Input, userInput, T%timeout% L%length%, {%endKey%}, % getShortuctsByComa(apps)
    if (ErrorLevel = "Max")
    {
        showAlfredError("You entered '" userInput "', which is the maximum length '" length "' of the text.")
        hideAlfred()
        return
    }
    if (ErrorLevel = "Timeout")
    {
        showAlfredError("You have reached the timeout of " timeout " per command.")
        hideAlfred()
        return
    }
    if (ErrorLevel = "NewInput") {
        showAlfredError("New input begun.")
        hideAlfred()
        return
    }
    If InStr(ErrorLevel, "EndKey:")
    {
        ; showAlfredError("You have endkey '" endKey "' pressed.")
        hideAlfred()
        KeyWait, %endKey%
        return
    }
    executeInput(apps, userInput)

    hideAlfred()
}

showAlfred() {
    Gui, Destroy
    Gui, -Caption -AlwaysOnTop +ToolWindow +DPIScale
    Gui, Margin, 0, 0
    FormatTime, currentDateTime, %A_Now%, yyyy-MM-dd HH:mm:ss
    info := "bedware.software | " currentDateTime
    html := getHTMLForAlfred(info, "rgb(255, 222, 93)")
    Gui, Add, ActiveX, w2000 h48, %html%
    Gui, Show, xCenter y2076 NoActivate

    selector := "bedware.ahk"
    if WinExist(selector) {
        WinActivate
        ; WinSet, AlwaysOnTop, On, %selector%
        WinGet, activeHwnd, ID, %selector%
        PinWindow(activeHwnd)
    }
    OutputDebug % "Alfred show"
}

showAlfredError(errorText) {
    Gui, Destroy
    Gui, -Caption -AlwaysOnTop +ToolWindow +DPIScale
    Gui, Margin, 0, 0
    info := "bedware.software | " errorText
    html := getHTMLForAlfred(errorText, "rgb(255, 0, 0)")
    Gui, Add, ActiveX, w2000 h48, %html%
    Gui, Show, xCenter y2076

    OutputDebug % "Alfred error show"
    Sleep 4000
}

getHTMLForAlfred(text, bgColor) {
    html = 
    (
        mshtml:
        <div style='
                border: 48px solid %bgColor%;
                background-color: %bgColor%;
                margin-left: -10px;
                margin-top: -45px;
                font-size: 36px;
                font-weight: bold;
                font-style: none;
                font-family: "Segoe UI";
            '>%text%</div>
    )
    return html
}

hideAlfred() {
    Gui, Destroy
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
