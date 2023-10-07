RearrangeWindows() {
    global apps
    global desktops
    for i, v in apps {
        if (v.desktop != "" && v.selector != "") {
            moved := false
            while (WinExist(v.selector) and !moved) {
                WinActivate 
                desktopNum := IndexOf(v.desktop, desktops)
                if (IndexOf(v.desktop, desktops) != -1) {
                    ; MoveActiveWindowToDesktop(desktopNum - 1)
                    moved = true
                }
            }
        }
    } 
}

defaultProfile() {
    global apps
    global desktops
    init := [] 
    init.Push({ name: "obs", ref: apps["obs"] })
    init.Push({ name: "task", ref: apps["task"], maximize: true })
    init.Push({ name: "tg", ref: apps["tg"] })
    ; init.Push({ name: "music", ref: apps["music"] })
    init.Push({ name: "note", ref: apps["note"], maximize: true })
    init.Push({ name: "term", ref: apps["term"] })
    init.Push({ name: "cmd", ref: apps["cmd"] })

    for index, app in init {
        if (app.ref.desktop != "") {
            num := IndexOf(app.ref.desktop, desktops)
                GoToVD(num)
        }
        executeInput(apps, app.name)

        if (app.maximize) {
            WinWait, % app.ref.selector,, 5
            if WinExist(app.ref.selector) {
                WinActivate
                WinMinimize
                WinMaximize
            }
        }
    }
}

doTranslation() {
    global apps
    global desktops

    Send ^{Insert}
    Sleep, 100
    buffer := Trim(Clipboard)
    Clipboard := buffer
    GoToVDIgnoreAlternate(IndexOf("Translation", desktops))

    if (InStr(buffer, " ")) { ; a sentence
        selector := apps["trd"].selector
        if (!WinExist(selector)) {
            executeInput(apps, "trd")
            WinWait, %selector%,, 5
            Sleep, 500
        }
        if (WinExist(selector)) {
            WinActivate
            Send gi
            Send ^a
            Send +{Insert}
            Sleep, 100
            WinActivate, %selector%
        }
    } else { ; a word
        ; Yandex Translate
        yandex := apps["try"].selector
        if (!WinExist(yandex)) {
            executeInput(apps, "try")
            WinWait, %yandex%,, 5
            Sleep, 500
        }
        if (WinExist(yandex)) {
            WinActivate
            Send !d
            Sleep, 150
            Send +{Insert}
        }

        ; ABBY
        abby := "ABBYY Lingvo ahk_exe Lingvo.exe"
        if (!WinExist(abby)) {
            executeInput(apps, "tra")
            WinWait, %abby%,, 5
            Sleep, 500
            WinActivate, %abby%
        }
        if (WinExist(abby)) {
            WinActivate
            Send ^a
            Send +{Insert}
            Send {Enter}
        }
    }
}

screencastProfile() {
    init := {}
    ; init["Screen share"] := { exe: "duet.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\duet.lnk" }
    ; init["Camera"] := { exe: "iVCam.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\e2eSoft iVCam\iVCam.lnk" }
    ; init["OBS"] := { exe: "obs64.exe", path: apps["obs"].path, moveToMonitorNumber: 2, maximize: true, showOnAllDesktops: true }
    ; init["Task Manager"] := { exe: "Taskmgr.exe", path: "Taskmgr.exe", moveToMonitorNumber: 2, maximize: true, showOnAllDesktops: true }
    init["OBS"] := { exe: "obs64.exe", path: apps["obs"].path, maximize: true }
    init["Task Manager"] := { exe: "Taskmgr.exe", path: "Taskmgr.exe",  maximize: true }
    ; Run
    for index, app in init {
        if (app.exe and app.path) {
            RunIfProcessNotExist(app.exe, app.path)
        }
        ; Configure
        if (app.moveToMonitorNumber or app.maximize or app.showOnAllDesktops or app.sleepy) {
            selector := "ahk_exe " app.exe

            WinWait, %selector%,, 5
            if WinExist(selector) {
                WinActivate
                if (app.moveToMonitorNumber == 2) {
                    WinRestore
                    WinMove,,, 1000, 3000, 500, 500
                    ; Sleep 50
                }
                if (app.maximize) {
                    WinMinimize
                    ; Sleep 150
                    WinMaximize
                }
                if (app.showOnAllDesktops) {
                    WinGet, activeHwnd, ID, A
                    PinWindow(activeHwnd)
                }
            }
        }
    }
    ; Post action
    if WinExist("ahk_exe iVCam.exe") {
        WinClose
    }
}

