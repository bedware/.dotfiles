#if HOTKEYS_ON && ScopeIs("ahk_exe msedge.exe")
    RShift Up::
        if (A_PriorKey = "RShift") {
            english()
            Send ^#!w
        }
        Send {RShift Up}
    return
#if
#if HOTKEYS_ON && ScopeIs("ahk_exe Microsoft.CmdPal.UI.exe")
    RShift Up::
        if (A_PriorKey = "RShift") {
            Send ^#!{Space}
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
            ; RunAlfred(apps)
            english()
            Send ^#!{Space}
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
