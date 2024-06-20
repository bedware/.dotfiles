RunAlfred(apps) {
    showAlfred()

    endKey := "LShift"
    timeout := "8" ; seconds
    length := "5" ; chars

    ; Wait for user input
    Input, userInput, T%timeout% L%length% C, {%endKey%}, % getShortuctsByComa(apps)
    if (ErrorLevel = "Max") {
        showAlfredError("You entered '" userInput "' and have reached maximum length (" length ") of the text.")
    } else if (ErrorLevel = "Timeout") {
        showAlfredError("You have reached the timeout of " timeout " seconds.")
    } else if (ErrorLevel = "NewInput") {
        showAlfredError("New input begun.")
    } else if InStr(ErrorLevel, "EndKey:") {
        KeyWait, %endKey%
        hideAlfred()
    } else {
        executeInput(apps, userInput)
        proceedAppHistory(userInput)
    }
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
    app := _getIfContains(apps, userInput . "")
    if (app) {
        showAlfredRunning(userInput)
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
                retval := Func(app.postFunction).Call(app.postFunctionParam)
            } else {
                retval := Func(app.postFunction).Call()
            }
        } 
        hideAlfred()
    }
}

;             current
;         prev  |
;           |   |
altApp := ["", ""]
;           1   2

GoToAlternateApp(apps) {
    global altApp

    ; Go to the previous app
    executeInput(apps, altApp[1])

    ; Ajust history
    proceedAppHistory("justswap")
}

proceedAppHistory(userInput) {
    global altApp
    if (userInput == "justswap") { ; Swap value between 2 cells of the array
        tmp := altApp[1]
        altApp[1] := altApp[2]
        altApp[2] := tmp
    } else if (altApp[2] != userInput) { ; Diffrent - we swap
        altApp[1] := altApp[2]
        altApp[2] := userInput
    } else {
        ; Same as current - do nothing
    }
    ; MsgBox % "Input:" . userInput . "Prev:" . altApp[1] . ". Curr:" . altApp[2] . "."
}


; Just visual stuff
; Using iexplorer pop-up (fast & ugly)
showAlfred() {
    Menu, Tray, Icon, shell32.dll, 298
    ; FormatTime, currentDateTime, %A_Now%, yyyy-MM-dd HH:mm:ss
    ; color := "rgb(255, 222, 93)"
    ; getHTMLForAlfred(color, currentDateTime)
    ;
    ; selector := "bedware.ahk"
    ; if WinExist(selector) {
    ;     WinActivate
    ;     ; WinSet, AlwaysOnTop, On, %selector%
    ;     WinGet, activeHwnd, ID, %selector%
    ;     PinWindow(activeHwnd)
    ; }
    ; OutputDebug % "Alfred show"
}
; showAlfredAsync() {
;     fu := Func("showAlfred")
;     SetTimer %fu%, -1
; }

showAlfredRunning(text) {
    Menu, Tray, Icon, shell32.dll, 239
    ; color := "rgb(223, 255, 93)"
    ; getHTMLForAlfred(color, text)
    ;
    ; selector := "bedware.ahk"
    ; if WinExist(selector) {
    ;     WinActivate
    ;     ; WinSet, AlwaysOnTop, On, %selector%
    ;     WinGet, activeHwnd, ID, %selector%
    ;     PinWindow(activeHwnd)
    ; }
}
showAlfredError(errorText) {
    Menu, Tray, Icon, shell32.dll, 132
    MsgBox % errorText
    Sleep 2000
    hideAlfred()
    ; color := "rgb(255, 0, 0)"
    ; getHTMLForAlfred(color, errorText)
    ; OutputDebug % "Alfred error show"
}

hideAlfred() {
    IconByThemeAndDesktopNumber(GetCurrentDesktopNumber())
    ; Gui, Destroy
    ; OutputDebug % "Alfred hide"
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
                margin: -25px -10px;
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

