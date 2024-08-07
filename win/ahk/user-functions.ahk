toggleRaceMode() {
    global raceMode
    raceMode := !raceMode
    if (raceMode) 
        ChangeTrayIcon("race")
    else
        ChangeTrayIcon("desktop", GetCurrentDesktopNumber())
}

toggleGpt() {
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray()
    else
        executeInput(apps, "gpt")
}

toggleDay() {
    global apps
    if (WinActive(apps["day"].selector))
        HideAppToTray()
    else
        executeInput(apps, "day")
}

quakeAlive() {
    if (!ProcessExist("WindowsTerminal.exe")) {
        Run, wt.exe -w _quake new-tab --title .dotfiles -d "C:/Users/dmitr/.dotfiles/" -- nvim .
        WinWait, ahk_exe WindowsTerminal.exe,, 5
        WinActivate
        Sleep 300
        Send ^{F12}
        Sleep 20
        Run, wt --window _quake new-tab --title AutoHotkey -d "C:/Users/dmitr/.dotfiles/win/ahk/" -- nvim .
        Sleep 20
        Run, wt --window _quake new-tab --title Neovim -d "C:/Users/dmitr/.dotfiles/wsl/nvim/.config/nvim/" -- nvim .
        Sleep 20
        Run, wt --window _quake new-tab --title Console -d "C:/Users/dmitr/"
        Run, wt --window _quake focus-tab -t 3
    } else {
        Send #``
    }
}

runNewWindowsTerminal() {
    Run wt
    WinWait, "Administrator: PowerShell ahk_exe WindowsTerminal.exe",, 3
}

toggleShowOnAllDesktops() {
    WS_EX_TOOLWINDOW := 0x00000080
    WinSet, ExStyle, ^%WS_EX_TOOLWINDOW%, A
    PlayErrorSound()
}

closeWindow() {
    Send !{F4}
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

inPlaceNeovim() {
    buffer_before := Trim(Clipboard)
    Send ^{Insert}
    Sleep, 50
    buffer := Trim(Clipboard)
    
    if (buffer_before == buffer) {
        Send ^a
        Send ^{Insert}
        Sleep, 50
        buffer := Trim(Clipboard)
    }

    textfield := "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_textfield"
    FileDelete, %textfield%
    FileAppend, %buffer%, %textfield%, UTF-8

    hwnd_file := "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_hwnd"
    FileRead, hwnd, %hwnd_file%

    DetectHiddenWindows, On  ; Enable detection of hidden windows
    WinShow, ahk_id %hwnd%
    WinActivate, ahk_id %hwnd%
    if (!WinActive("ahk_id" hwnd)) {
        createPopUp("in_place_editor", "C:\Users\dmitr\.dotfiles\win\pwsh\bin\Edit-InPlaceWithNeovim.ps1")
        WinWait, in_place_editor ahk_class Window Class ahk_exe alacritty.exe,, 5
        WinActivate ; Use the window found by WinWait.
    }
    DetectHiddenWindows, Off
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

