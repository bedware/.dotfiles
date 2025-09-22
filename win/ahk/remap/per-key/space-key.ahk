#if HOTKEYS_ON 
    *Space::
        global HYPER_PRESSED
        HYPER_PRESSED := true
        KeyWait, Space
        HYPER_PRESSED := false
        if (A_ThisHotkey == "*Space" && A_PriorKey == "Space") {
            SendEvent {Blind}{Space}
            ; Send {Space}
        }
    return
#if 

#if HOTKEYS_ON && HYPER_PRESSED
    ; Tab::
    ;     global apps
    ;     GoToAlternateApp(apps)
    ; return
    ; From Win
    ; d::toggleDay()
    ; e::inPlaceNeovim()
    ; g::toggleGpt()
    ; g::toggleGpt()
    ; q::closeWindow()

    ; Other Win keys
    ; i::#i
    ; a::#a
    ; p::#p
    ; v::#v
    ; t::#t
    ; o::!#o
    ; `;::#`;
    ; +v::^+m ; Select mode (vi-mode) in wt

    ; Copy & Paste
    ; y::Send ^{Insert}
    ; p::Send +{Insert}


    ; Other
    ; +`;::NumpadMult


    ; Navigation
    *h::Left
    *j::Down
    *k::Up
    *l::Right
    *[::PgUp
    *]::PgDn
    *,::Home
    *.::End

    ; Other
    `::quakeAlive()
    e::english()
    r::russian()
    Enter::runNewWindowsTerminal()
    ^t::toggleShowOnAllDesktops()
    ; Context menu
    m::Send {AppsKey}
    Backspace::Send {Enter}
    /::Reload

    ; To work as modifiers when Space pressed
    *LShift::LShift
    *LAlt::LAlt

    ; Virtual desktops
    1::GoToVD(1)
    2::GoToVD(2)
    3::GoToVD(3)
    4::GoToVD(4)
    5::GoToVD(5)
    6::GoToAlternateVD()
    7::GoToVD(7)
    8::GoToVD(8)
    9::GoToVD(9)
    0::GoToVD(6)
    ; Move
    +1::MoveActiveWinAndGoToVD(1)
    +2::MoveActiveWinAndGoToVD(2)
    +3::MoveActiveWinAndGoToVD(3)
    +4::MoveActiveWinAndGoToVD(4)
    +5::MoveActiveWinAndGoToVD(5)
    +7::MoveActiveWinAndGoToVD(7)
    +8::MoveActiveWinAndGoToVD(8)
    +9::MoveActiveWinAndGoToVD(9)
    +0::MoveActiveWinAndGoToVD(6)
#if

