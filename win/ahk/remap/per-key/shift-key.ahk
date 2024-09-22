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
