#if HOTKEYS_ON 
    *Space::
        global HYPER_PRESSED
        HYPER_PRESSED := true
        KeyWait, Space
        HYPER_PRESSED := false
        if (A_ThisHotkey == "*Space" && A_PriorKey == "Space") {
            SendEvent {Blind}{Space}
        }
    return
#if 

#if HOTKEYS_ON && HYPER_PRESSED
    /::Reload
    ; Modifiers to work when Space pressed
    *LShift::LShift
    *LAlt::LAlt

    ; Navigation
    *h::Left
    *j::Down
    *k::Up
    *l::Right
    *,::Home
    *.::End
    *u::PgUp
    *d::PgDn

    ; Languages (this one for one-hand interacting)
    e::english()
    r::russian()

    ; Terminal
    `::quakeAlive()

    ; Context menu
    m::Send {AppsKey}

    ; Other
    *w::^#!f
    *q::closeWindow()
    Backspace::Send {Delete}
    `;::NumpadMult

    ; Virtual desktops (VD)
    1::GoToVD(1)
    2::GoToVD(2)
    3::GoToVD(3)
    4::GoToVD(4)
    5::GoToVD(5)
    6::GoToAlternateVD()
    7::GoToVD(7)
    8::GoToVD(8)
    9::GoToVD(9)
    0::GoToVD(10)
    +1::MoveActiveWinAndGoToVD(1)
    +2::MoveActiveWinAndGoToVD(2)
    +3::MoveActiveWinAndGoToVD(3)
    +4::MoveActiveWinAndGoToVD(4)
    +5::MoveActiveWinAndGoToVD(5)
    +7::MoveActiveWinAndGoToVD(7)
    +8::MoveActiveWinAndGoToVD(8)
    +9::MoveActiveWinAndGoToVD(9)
    +0::MoveActiveWinAndGoToVD(10)
#if

