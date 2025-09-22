#if HOTKEYS_ON && ScopeIs("ahk_exe msedge.exe")
    RShift Up::
        if (A_PriorKey = "RShift") {
            if (WinExist("select workspace ahk_class Window Class ahk_exe alacritty.exe")) {
                WinActivate
            } else {
                createPopUp("select workspace", home "\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1")
            }
        }
        Send {RShift Up}
    return
#if

#if HOTKEYS_ON
    RShift & Capslock::Send +{Esc}
    LShift & RShift::ToggleCaps()
    RShift & LShift::ToggleCaps()

    LShift Up::
        global apps
        if (A_PriorKey = "LShift") {
            RunAlfred(apps)
        }
        Send {LShift Up}
    return 

    RShift Up::
        global commands
        if (A_PriorKey = "RShift") {
            for key, command in commands {
                if (ScopeIs(command.selector)) {
                    RunContext(command.commands)
                    break
                }
            }
        }
        Send {RShift Up}
    return 
#if 
