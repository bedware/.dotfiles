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
    ; F-keys
    *6::F6
    *7::F7
    *8::F8
    *9::F9
    *0::F10
    *-::F11
    *=::F12

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
    ; F-keys
    *1::F1
    *2::F2
    *3::F3
    *4::F4
    *5::F5

    ; Languages
    e::english()
    r::russian()
    g::georgian()
#if
