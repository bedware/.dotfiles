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
    } else if InStr(ErrorLevel, "EndKey:") {
        KeyWait, %endKey%
    } else {
        showAlfredRunning()
        executeInput(apps, userInput)
        proceedLast2Apps(userInput)
    }
    hideAlfred()
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
    app := GetIfContains(apps, userInput . "")

    if (!app) {
        MsgBox % "App doesn't exist for input" userInput
        return
    }

    if (app.run && IsAppInTray(app.run)) {
        RemoveAppFromTrayByPath(app.run)
        return
    }

    ; there is a selector for the app
    if (app.selector != "") {
        ; Go to needed desktop
        if (app.desktop != "") { ; app specifies a virtual desktop to work on
            neededDesktop := IndexOf(app.desktop, desktops)
            if (GetCurrentDesktopNumber() != neededDesktop) {
                GoToVD(neededDesktop)
            }
        }
        
        if WinActive(app.selector) {
            if (app.tray != "") {
                HideAppToTray()
                return
            }
        }

        ; Activate window
        if WinExist(app.selector) {
            WinActivate
        }
        ; If nothing to activate
        else {

            runCmd := app.run
            if (app.runArgs != "") {
                runCmd := runCmd . " " . app.runArgs
            }

            ; Try to run
            Run % runCmd
            WinWait % app.selector,, 10
            if ErrorLevel {
                PlayErrorSound()
                return
            }

            ; Activate window
            if WinExist(app.selector) {
                WinActivate
            }

            ; Call init function
            if (app.initFunction != "") {
                retval := Func(app.initFunction).Call()
            } 
        }
    }
    ; there is no selector for the app
    else {

        ; Run
        path := app.run
        Run %path%

        ; Call init function
        if (app.initFunction != "") {
            retval := Func(app.initFunction).Call()
        } 
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

    ; Adjust history
    proceedLast2Apps("justswap")
}

proceedLast2Apps(userInput) {
    global altApp
    if (userInput == "justswap") { ; Swap value between 2 cells of the array
        tmp := altApp[1]
        altApp[1] := altApp[2]
        altApp[2] := tmp
    } else if (altApp[2] != userInput) { ; Diffrent - we swap
        altApp[1] := altApp[2]
        altApp[2] := userInput
    }
}

showAlfred() {
    ChangeTrayIcon("show")
}
hideAlfred() {
    ChangeTrayIcon("desktop", GetCurrentDesktopNumber())
}

showAlfredRunning() {
    ChangeTrayIcon("running")
}
showAlfredError(errorText) {
    ChangeTrayIcon("error")
    MsgBox % errorText
    Sleep 2000
}

