#if WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
    or WinActive("ahk_exe firefox.exe")
    or WinActive("ahk_exe Cypress.exe")
    ^g::Send ^+{a} ; Search in tabs popup
    ^i::Send !{Right} ; Navigation history forward 
    ^o::Send !{Left} ; Navigation history backward
    !g::
        Send {F6}{F6}
        Sleep 250
        Send {AppsKey}aa{Enter}
    return
    !s::run_workspace_switcher()
#if
#if WinActive("ahk_exe msedge.exe") && GetKeyState("Space", "P")
    s::run_workspace_switcher()
#if

; ChatGpt
#d::toggle_day()

toggle_day() {
    global apps
    if (WinActive(apps["day"].selector))
        HideAppToTray()
    else
        executeInput(apps, "day")
}

#if WinActive("select workspace ahk_class Window Class ahk_exe alacritty.exe")
    !s::
    ~*Enter::
        HideAppToTray()
    return
#if

run_workspace_switcher() {
    if (RemoveAppFromTrayByTitle("select workspace")) {
        ; Send {Esc}
    } else {
        Run, % "C:\Program Files\Alacritty\alacritty.exe" 
            . " --title ""select workspace"" "
            . " -o window.decorations=None "
            . " -o window.opacity=1.0 "
            . " -o window.position.x=1000 "
            . " -o window.position.y=250 "
            . " -o window.dimensions.lines=25 "
            . " -o window.dimensions.columns=35 "
            . " --command pwsh -nop -nologo -c ""C:\Users\dmitr\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1"""
        WinWait, select workspace ahk_class Window Class ahk_exe alacritty.exe,, 4
        WinActivate ; Use the window found by WinWait.
    }
}
