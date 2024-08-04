; Tab
*Tab::
    if (A_PriorKey = "LAlt") {
        SendEvent {Blind}{Tab}
        KeyWait, Tab
    } else {
        KeyWait, Tab
        if (A_ThisHotkey = "*Tab" and A_PriorKey = "Tab") {
            SendEvent {Blind}{Tab}
        }
    }
return

#if GetKeyState("Tab", "P")
    ; Virtual desktops
    6::GoToAlternateVD()
    7::GoToVD(7)
    8::GoToVD(8)
    9::GoToVD(9)
    0::GoToVD(6)
    ; Move
    LWin & 7::MoveActiveWinAndGoToVD(7)
    LWin & 8::MoveActiveWinAndGoToVD(8)
    LWin & 9::MoveActiveWinAndGoToVD(9)
    LWin & 0::MoveActiveWinAndGoToVD(6)
    Space & 7::MoveActiveWinAndGoToVD(7)
    Space & 8::MoveActiveWinAndGoToVD(8)
    Space & 9::MoveActiveWinAndGoToVD(9)
    Space & 0::MoveActiveWinAndGoToVD(6)
    ; Languages (this one for one-hand interacting)
    e::english()
    r::russian()
    g::georgian()

    LWin::#z ; Windows layout popup
    j::Send ^+{Tab} ; Next tab
    k::Send ^{Tab} ; Prev tab
#if

; Opposite Tab
*\::
    KeyWait, \
    if (A_ThisHotkey = "*\" and A_PriorKey = "\") {
        SendEvent {Blind}\
    }
return
#if GetKeyState("\", "P")
    ; Virtual desktops
    1::GoToVD(1)
    2::GoToVD(2)
    3::GoToVD(3)
    4::GoToVD(4)
    5::GoToVD(5)
    ; Move 
    Space & 1::MoveActiveWinAndGoToVD(1)
    Space & 2::MoveActiveWinAndGoToVD(2)
    Space & 3::MoveActiveWinAndGoToVD(3)
    Space & 4::MoveActiveWinAndGoToVD(4)
    Space & 5::MoveActiveWinAndGoToVD(5)
    ; Languages
    e::english()
    r::russian()
    g::georgian()
#if
