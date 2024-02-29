makeAnyWindowFullscreen() {
    WinSet, Style, -0xC40000, A
    ; WinMaximize, A
    ; WinMove, A, , 0, 0, 3456, 2166
    ; WinMove, A, , 0, 0, 2560, 1600
    WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
}
makeAnyWindowMaximized() {
    WinMaximize, A
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
    }
}

defaultProfile() {
    global apps
    global desktops
    init := [] 
    init.Push({ name: "task", ref: apps["task"], maximize: true })
    init.Push({ name: "tg", ref: apps["tg"] })
    init.Push({ name: "note", ref: apps["note"], maximize: true })
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

screencastProfile() {
    global apps
    global desktops
    init := [] 
    init.Push({ name: "obs", ref: apps["obs"] })
    init.Push({ name: "razer", ref: apps["razer"] })
    init.Push({ name: "carnac", ref: apps["carnac"] })

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

