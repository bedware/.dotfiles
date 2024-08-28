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
        if (A_PriorKey = "RShift") {
            commands := {}
            if (ScopeIs("ahk_exe TOTALCMD64.EXE")) {
                commands["re"] := "{F2}"
                commands["q"] := "{F3}"
                commands["e"] := "{F4}"
                commands["cp"] := "{F5}"
                commands["mv"] := "{F6}"
                commands["md"] := "{F7}"
                commands["mf"] := "+{F4}"
                commands["mk"] := "{F7}"
                commands["rm"] := "{F8}"
            }
            RunContext(commands)
        }
        Send {RShift Up}
    return 
#if 
