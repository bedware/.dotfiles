ScopeIs(selector) {
    global CONTEXT_HOTKEYS_ON 
    return CONTEXT_HOTKEYS_ON and WinActive(selector)
}

toggleRaceMode() {
    global HOTKEYS_ON
    HOTKEYS_ON := !HOTKEYS_ON
    if (HOTKEYS_ON) 
        ChangeTrayIcon("desktop", GetCurrentDesktopNumber())
    else
        ChangeTrayIcon("race")
}

toggleGpt() {
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray("gpt")
    else
        executeInput(apps, "gpt")
}

toggleDay() {
    global apps
    if (WinActive(apps["day"].selector))
        HideAppToTray("day")
    else
        executeInput(apps, "day")
}

quakeAlive() {
    global home

    ; with russian layout it doesn't trigger
    english()

    if (!ProcessExist("WindowsTerminal.exe")) {
        path := home "/.dotfiles/"
        Run, wt.exe -w _quake new-tab --title .dotfiles -d %path% -- nvim .
        Sleep 300

        ; workaround for --unfocus (by default quake window is focused)
        WinWait, ahk_exe WindowsTerminal.exe,, 5
        WinActivate
        Send ^{F12}

        path := home "/.dotfiles/win/ahk/"
        Run, wt --window _quake new-tab --title AutoHotkey -d %path% -- nvim .
        Sleep 20

        path := home "/.dotfiles/wsl/nvim/.config/nvim/"
        Run, wt --window _quake new-tab --title Neovim -d %path%
        Sleep 20

        path := home
        Run, wt --window _quake new-tab --title Console -d %path%
        ; Sleep 100
        ; Run, wt --window _quake focus-tab -t 2
    } else {
        Send #``
    }
}

runNewWindowsTerminal() {
    Run wt
    WinWait, "Administrator: PowerShell ahk_exe WindowsTerminal.exe",, 3
}

runNewAlacrittyTerminal() {
    global home
    path := home ; "/.dotfiles/"
    title := "bedware.software"

    Run, % "C:\Program Files\Alacritty\alacritty.exe" 
        . " --title """ title """"
        . " -o window.dimensions.lines=40"
        . " -o window.dimensions.columns=125"
        . " --command pwsh -wd """ path """"

    WinWait, %title% ahk_class Window Class ahk_exe alacritty.exe,, 5
    WinActivate
    makeAnyWindowCentered()
}

toggleShowOnAllDesktops() {
    WS_EX_TOOLWINDOW := 0x00000080
    WinSet, ExStyle, ^%WS_EX_TOOLWINDOW%, A
    PlayErrorSound()
}

closeWindow() {
    Send !{F4}
}

; Work-related
startNadeksEnv() {
    Run, wt --title Start-NadeksEnvironment -- pwsh -nop -c C:\Users\dmitr\.dotfiles\win\pwsh\bin\Start-NadeksEnvironment.ps1
}
startAlfaEnv() {
    Run, wt --title Start-AlfaEnvironment -- pwsh -nop -c C:\Users\dmitr\.dotfiles\win\pwsh\bin\Start-AlfaEnvironment.ps1
}

; check out Get-WinUserLanguageList to find needed code
english() {
    PostMessage, 0x0050, 0, 0x0000409,, A
    ; Run, C:\Users\dmitr\Downloads\im-select.exe 1033
}
russian() {
    PostMessage, 0x0050, 0, 0x0000419,, A
    ; Run, C:\Users\dmitr\Downloads\im-select.exe 1049
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
    _putSelectionToBuffer()
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
    buffer := _putSelectionToBuffer()

    textfield := "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_textfield"
    ; textfield := StrReplace(textfield, getOldName(), getNewName())
    FileDelete, %textfield%
    FileAppend, %buffer%, %textfield%, UTF-8

    hwnd_file := "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_hwnd"
    ; hwnd_file  := StrReplace(hwnd_file , getOldName(), getNewName())
    FileRead, hwnd, %hwnd_file%

    DetectHiddenWindows, On  ; Enable detection of hidden windows
    WinShow, ahk_id %hwnd%
    WinActivate, ahk_id %hwnd%
    if (!WinActive("ahk_id" hwnd)) {
        path := "C:\Users\dmitr\.dotfiles\win\pwsh\bin\Edit-InPlaceWithNeovim.ps1"
        ; path := StrReplace(path, getOldName(), getNewName())
        createPopUp("in_place_editor", path)
        WinWait, in_place_editor ahk_class Window Class ahk_exe alacritty.exe,, 5
        WinActivate ; Use the window found by WinWait.
    }
    DetectHiddenWindows, Off
}

_putSelectionToBuffer() {
    Clipboard := ""
    
    ; Get currently selected text to buffer
    Send ^{Insert}
    Sleep, 50
    buffer:= Clipboard
    
    ; If empty select all (Ctrl+a) to buffer
    if (buffer = "") {
        Send ^a
        Sleep, 50
        Send ^{Insert}
        Sleep, 50
        buffer := Clipboard
    }
    return buffer
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

