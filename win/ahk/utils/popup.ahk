; ChatGpt popup

#g::toggle_gpt()

toggle_gpt() {
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray()
    else
        executeInput(apps, "gpt")
}

#if WinActive("ahk_exe chatgpt.exe")
    CapsLock Up::
        if (A_PriorKey = "Capslock") {
            HideAppToTray()
        }
    return
#if

; Planning popup

#d::toggle_day()

toggle_day() {
    global apps
    if (WinActive(apps["day"].selector))
        HideAppToTray()
    else
        executeInput(apps, "day")
}

; Workspace switcher popup

#if WinActive("ahk_exe msedge.exe")
    !s::
        createPopUp("select workspace", "C:\Users\dmitr\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1", false)
    return
#if

#if WinActive("select workspace ahk_class Window Class ahk_exe alacritty.exe")
    !s::
    ~*Enter::
        HideAppToTray()
    return
#if

; In-place Neovim editor

#e::inPlaceNeovim()

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


; Creating popups


createPopUp(title, pwshCommand, centered := true, maximized := false) {
    if (!RemoveAppFromTrayByTitle(title)) {
        Run, % "C:\Program Files\Alacritty\alacritty.exe" 
            . " --title """ title """"
            . " -o window.decorations=None"
            . " -o window.opacity=1.0"
            . " -o window.position.x=1000"
            . " -o window.position.y=250"
            . " -o window.dimensions.lines=25"
            . " -o window.dimensions.columns=35"
            . " --command pwsh -nop -nologo -c """ pwshCommand """"
        WinWait, %title% ahk_class Window Class ahk_exe alacritty.exe,, 5
        WinActivate ; Use the window found by WinWait.

        Sleep 100
        if (centered)
            makeAnyWindowCentered()
        if (maximized)
            makeAnyWindowMaximized()

    }
}

