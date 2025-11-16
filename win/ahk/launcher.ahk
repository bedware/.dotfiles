; Dependencies
#Include C:/Users/dmitr/.dotfiles/win/ahk/dependencies/JSON.ahk
#Include C:/Users/dmitr/.dotfiles/win/ahk/dependencies/VirtualDesktopAccessor.ahk
; Read config
FileRead, tmp, C:/Users/dmitr/.dotfiles/win/ahk/config/desktops.json
desktops := JSON.Load(tmp)
FileRead, tmp, C:/Users/dmitr/.dotfiles/win/ahk/config/actions.json
apps := JSON.Load(tmp)

; Yeah, arrays start from 1 in AHK and arr.Length == arr.MaxIndex()
IndexOf(needle, haystack) {
    for i, k in haystack {
        if (k == needle) {
            return i
        }
    }
    return -1
}

GetIfContains(arr, inp) {
    result := false
    for key, value in arr {
        if (key == inp) {
            result := value
            break
        }
    }
    return result
}

; Проверяем, были ли переданы аргументы
if (A_Args.Length = 0) {
    MsgBox "Нет аргументов."
} else {
    userInput  := A_Args[1]
    ; MsgBox % userInput
    app := GetIfContains(apps, userInput "")

    if (!app) {
        MsgBox % "App doesn't exist for input: " userInput
        return
    }

    if (app.selector != "") {

        ; Trying to activate window first time
        if WinExist(app.selector) {
            WinActivate
            return
        }

        ; Go to needed desktop
        if (app.desktop != "") { ; app specifies a virtual desktop to work on
            neededDesktop := IndexOf(app.desktop, desktops)
            if (GetCurrentDesktopNumber() != neededDesktop) {
                GoToDesktopNumber(neededDesktop - 1) ; indexes in this function start with 0
            }
        }
    }

    ; Activate window
    if WinExist(app.selector) {
        WinActivate
    }
    ; If nothing on the screen
    else {
        ; Prepare to try to run
        runCmd := app.run
        if (app.runArgs) {
            runCmd := runCmd . " " . app.runArgs
        }

        Run % runCmd
        WinWait % app.selector,, 10
        if ErrorLevel {
            SoundPlay, %A_WinDir%\Media\Windows Hardware Fail.wav
            return
        }

        ; Activate window after running
        if WinExist(app.selector) {
            WinActivate
        }
    }
}
