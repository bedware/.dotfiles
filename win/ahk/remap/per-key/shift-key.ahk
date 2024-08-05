; Shifts + RaceMode

RShift & Capslock::Send +{Esc}
LShift & RShift::toggleRaceMode()
RShift & LShift::toggleRaceMode()

#if !raceMode
    LShift up::
        global apps
        if (A_PriorKey = "LShift") {
            RunAlfred(apps)
        }
    return 

    RShift up::
        if (A_PriorKey = "RShift") {
            commands := {}
            if (WinActive("ahk_exe TOTALCMD64.EXE")) {
                commands["rm"] := "{F8}"
                commands["cp"] := "{F5}"
                commands["mv"] := "{F6}"
                commands["mk"] := "{F7}"
            }
            RunContext(commands)
        }
    return 
#if 
