; Shifts + RaceMode

RShift & Capslock::Send +{Esc}
LShift & RShift::ToggleRaceMode()
RShift & LShift::ToggleRaceMode()

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
