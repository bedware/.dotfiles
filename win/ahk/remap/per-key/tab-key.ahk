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
    ; Navigation
    u::PgUp
    d::PgDn

    ; Languages (this one for one-hand interacting)
    e::english()
    r::russian()
    g::georgian()

    ; Tabs management
    j::Send ^+{Tab}
    k::Send ^{Tab}

    ; Terminals
    n::runNewAlacrittyTerminal()
    t::runNewWindowsTerminal()
#if

; #if ScopeIs("ahk_exe datagrip64.exe") and GetKeyState("Tab", "P")
;     j::Send !{Left}
;     k::Send !{Right}
; #if


; Opposite Tab
*\::
    KeyWait, \
    if (A_ThisHotkey = "*\" and A_PriorKey = "\") {
        SendEvent {Blind}\
    }
return
#if GetKeyState("\", "P")
    Tab::toggleRaceMode()
    ; From Win
    g::
        MsgBox "RUN"
        Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ChatGPT.lnk"
    return

    ; C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications
    ; C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Profile 3\Web Applications

    1::open_dot()
    2::open_ahk()
    3::open_nvim()
    4::open_pwsh()
#if
