#if HOTKEYS_ON 
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
#if 

#if HOTKEYS_ON && ScopeIs("ahk_exe Telegram.exe") && GetKeyState("Tab", "P")
    ; Tabs management
    j::Send ^+{Up}
    k::Send ^+{Down}
#if 

#if HOTKEYS_ON && GetKeyState("Tab", "P")
    ; ; Tabs management
    j::Send ^+{Tab}
    k::Send ^{Tab}

    ; Terminals
    n::runNewAlacrittyTerminal()
    t::runNewWindowsTerminal()

    ; From Win
    g::
        MsgBox "RUN"
        ; Run "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ChatGPT.lnk"
    return

    ; C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Default\Web Applications
    ; C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Profile 3\Web Applications
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
    Tab::toggleGameMode()

    1::open_dot()
    2::open_ahk()
    3::open_nvim()
    4::open_pwsh()
#if
