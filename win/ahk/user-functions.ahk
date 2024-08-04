ToggleRaceMode() {
    global raceMode
    raceMode := !raceMode
    if (raceMode) 
        ChangeTrayIcon("race")
    else
        ChangeTrayIcon("desktop", GetCurrentDesktopNumber())
}

; OPEN mode
startWork() {
    Run C:\Users\dmitr\.dotfiles\win\pwsh\bin\Start-WorkEnvironment.ps1
}

; check out Get-WinUserLanguageList to find needed code
english() {
    PostMessage, 0x0050, 0, 0x0000409,, A
}
russian() {
    PostMessage, 0x0050, 0, 0x0000419,, A
}
georgian() {
    PostMessage, 0x0050, 0, 0x0000437,, A
}

open_dot() {
    Run, wt --window _quake focus-tab -t 0
}
open_ahk() {
    Run, wt --window _quake focus-tab -t 1
}
open_nvim() {
    Run, wt --window _quake focus-tab -t 2
}
open_pwsh() {
    Run, wt --window _quake focus-tab -t 3
}
_deeplCheck() {
    if (!ProcessExist("DeepL.exe")) {
        Run, "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DeepL.lnk"
        WinWait, ahk_exe DeepL.exe,, 5
    }
}
deeplTranslateSelected() {
    _deeplCheck()
    Send {F21}
}
deeplTranslateScreen() {
    _deeplCheck()
    Send {F22}
}
deeplTranslateOnTheGo() {
    _deeplCheck()
    Send {F23}
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

