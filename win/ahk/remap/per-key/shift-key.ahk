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
        global apps
        if (A_PriorKey = "RShift") {
            GoToAlternateApp(apps)
        }
    return 
#if 
