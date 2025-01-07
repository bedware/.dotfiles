RunAlfred(apps) {
    _RunBase(apps, "runAlfredFunc", "LShift", "show")
}
runAlfredFunc(apps, userInput) {
    executeInput(apps, userInput)
    proceedLast2Apps(userInput)
}

RunContext(commands) {
    _RunBase(commands, "runContextFunc", "RShift", "show-alternate")
}
runContextFunc(commands, userInput) {
    command := commands[userInput]
    keys := command.keys
    Send %keys%
}

getShortuctsByComa(apps) {
    ; e.g. "term,slack,tg"
    shortcutsByComa := ""
    for key, app in apps {
        shortcutsByComa := shortcutsByComa . key . ","
    }
    return SubStr(shortcutsByComa, 1, -1)
}

executeInput(apps, userInput) {
    global desktops
    app := GetIfContains(apps, userInput "")

    if (!app) {
        MsgBox % "App doesn't exist for input" userInput
        return
    }

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
                HideAppToTray(userInput)
                return
            }
        }

        ; Activate window
        if WinExist(app.selector) {
            WinActivate
        }
        ; If nothing on the screen
        else {
            ; Check in tray
            winId := fromStore(userInput)
            if (IsAppInTrayById(winId)) {
                ; MsgBox % "Window exist in tray"
                RemoveAppFromTrayById(winId)
                return
            }

            ; Try to run
            runCmd := app.run
            if (app.runArgs) {
                runCmd := runCmd . " " . app.runArgs
            }

            ; Try to fix profile name bug
            runCmd := StrReplace(runCmd, getOldName(), getNewName())

            Run % runCmd
            WinWait % app.selector,, 10
            if ErrorLevel {
                PlayErrorSound()
                return
            }

            ; Activate window after running
            if WinExist(app.selector) {
                WinActivate
                WinGet, hwnd, ID, A
                toStore(userInput, hwnd)
            }

            ; Call init function
            if (app.initFunction) {
                retval := Func(app.initFunction).Call()
            } 
        }
    }
    ; there is no selector for the app
    else {
        if (app.run && IsAppInTrayByPath(app.run)) {
            RemoveAppFromTrayByPath(app.run)
            return
        }

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

showAlfred(icon := "show") {
    ChangeTrayIcon(icon)
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

_RunBase(commands, funcName, endKey, icon) {
    global HOTKEYS_ON
    global CONTEXT_HOTKEYS_ON 

    tmp_hotkeys := HOTKEYS_ON
    tmp_context := CONTEXT_HOTKEYS_ON 

    if (commands.Count() = 0) {
        return
    }

    showAlfred(icon)

    timeout := "6" ; seconds
    length := "6" ; chars

    HOTKEYS_ON := false
    CONTEXT_HOTKEYS_ON := false

    ; Wait for user input
    SetCapsLockState, AlwaysOff
    Input, userInput, T%timeout% L%length% C, {%endKey%}, % getShortuctsByComa(commands)
    SetCapsLockState, Off
    if (ErrorLevel = "Max") {
        showAlfredError("You entered '" userInput "' and have reached maximum length (" length ") of the text.")
    } else if (ErrorLevel = "Timeout") {
        showAlfredError("You have reached the timeout of " timeout " seconds.")
    } else if InStr(ErrorLevel, "EndKey:") {
        KeyWait, %endKey%
    } else {
        showAlfredRunning()
        retval := Func(funcName).Call(commands, userInput)
    }

    HOTKEYS_ON := tmp_hotkeys
    CONTEXT_HOTKEYS_ON := tmp_context

    hideAlfred()
}
