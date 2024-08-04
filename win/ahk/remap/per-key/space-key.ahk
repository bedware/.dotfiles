#if !raceMode
    *Space::
        KeyWait, Space
        if (A_ThisHotkey = "*Space" and A_PriorKey = "Space") {
            SendEvent {Blind}{Space}
        }
    return
#if 

#if !raceMode && GetKeyState("Space", "P")
    ; From Win
    `::quakeAlive()
    d::toggleDay()
    e::inPlaceNeovim()
    g::toggleGpt()
    Enter::runNewWindowsTerminal()
    ^t::toggleShowOnAllDesktops()
    q::closeWindow()

    ; Other Win keys
    r::#r

    ; Copy & Paste
    y::Send ^{Insert}
    p::Send +{Insert}

    v::^+m ; Select mode (vi-mode) in wt
    /::Reload

    ; Context menu
    m::Send {AppsKey}
    Backspace::Send {Enter}

    ; Other
    `;::NumpadMult

    ; To work as modifiers when Space pressed
    *LShift::LShift
    *LAlt::LAlt

    ; F-keys
    *1::F1
    *2::F2
    *3::F3
    *4::F4
    *5::F5
    *6::F6
    *7::F7
    *8::F8
    *9::F9
    *0::F10
    *-::F11
    *=::F12

    ; Navigation
    *h::Left
    *j::Down
    *k::Up
    *l::Right
    *[::PgUp
    *]::PgDn
    *,::Home
    *.::End
#if
