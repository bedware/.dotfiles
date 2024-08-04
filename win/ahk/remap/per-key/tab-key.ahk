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
    ; Languages (this one for one-hand interacting)
    e::english()
    r::russian()
    g::georgian()

    LWin::#z ; Windows layout popup
    j::Send ^+{Tab} ; Next tab
    k::Send ^{Tab} ; Prev tab
#if

*\::
    KeyWait, \
    if (A_ThisHotkey = "*\" and A_PriorKey = "\") {
        SendEvent {Blind}\
    }
return
#if GetKeyState("\", "P")
    ; Languages
    e::english()
    r::russian()
    g::georgian()
#if
