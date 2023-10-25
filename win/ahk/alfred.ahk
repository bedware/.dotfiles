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
        showAlfredError("You have reached the timeout of " timeout " seconds.")
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
    FormatTime, currentDateTime, %A_Now%, yyyy-MM-dd HH:mm:ss
    color := "rgb(255, 222, 93)"
    getHTMLForAlfred(color, currentDateTime)

    selector := "bedware.ahk"
    if WinExist(selector) {
        WinActivate
        ; WinSet, AlwaysOnTop, On, %selector%
        WinGet, activeHwnd, ID, %selector%
        PinWindow(activeHwnd)
    }
    OutputDebug % "Alfred show"
}

showAlfredRunning(text) {
    color := "rgb(223, 255, 93)"
    getHTMLForAlfred(color, text)

    selector := "bedware.ahk"
    if WinExist(selector) {
        WinActivate
        ; WinSet, AlwaysOnTop, On, %selector%
        WinGet, activeHwnd, ID, %selector%
        PinWindow(activeHwnd)
    }
}
showAlfredError(errorText) {
    color := "rgb(255, 0, 0)"
    getHTMLForAlfred(color, errorText)
    OutputDebug % "Alfred error show"
    Sleep 4000
}

getHTMLForAlfred(bgColor, text) {
    Gui, Destroy
    Gui, -Caption -AlwaysOnTop +ToolWindow +DPIScale
    Gui, Margin, 0, 0
    info := "bedware.software | " text
    taskbarHeight := 48
    html = 
    (
        mshtml:
        <div style='
                margin: -15px -10px;
                background: %bgColor%;
                padding: 35px;
                font-size: 36px;
                font-weight: bold;
                font-style: none;
                font-family: "Segoe UI";
            '>%info%</div>
        </body>
    )
    Gui, Add, ActiveX, w960 h%taskbarHeight%, %html%
    Gui, Show, xCenter y1100 NoActivate
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
    if (IsObject(apps[userInput . ""])) { ; Otherwise, a match was found.
        showAlfredRunning(userInput)
        app := apps[userInput . ""]
        if (app.selector != "") {
            if (app.desktop != "") {
                OutputDebug % "executed inside"
                num := IndexOf(app.desktop, desktops)
                current := GetCurrentDesktopNumber()
                OutputDebug % "app's desktop:" num
                OutputDebug % "current desktop:" current
                if (num != current) {
                    GoToVD(num)
                }
            }
            OutputDebug % "Im going to run " app.path " on " app.selector
            if (RunIfNotExist(app.selector, app.path) == -1) {
                return
            }
            OutputDebug % "executed"
        } else {
            OutputDebug % "Im going to run the app without selector"
            path := app.path
            Run %path%
        }
        if (app.postFunction != "") {
            if (app.postFunctionParam != "") {
                Func(app.postFunction).Call(app.postFunctionParam)
            } else {
                Func(app.postFunction).Call()
            }
        } 
    }
}
