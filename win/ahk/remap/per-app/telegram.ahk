#if ScopeIs("ahk_exe Telegram.exe")
    ^u::Send ^+{Up}
    ^d::Send ^+{Down}
    !j::Send !{Down}
    !k::Send !{Up}
    ^j::
        if (GetKeyState("Space", "P")) {
            Send ^{Down}
        } else {
            Send ^+{Down}
        }
    return
    ^k::
        if (GetKeyState("Space", "P")) {
            Send ^{Up}
        } else {
            Send ^+{Up}
        }
    return
#if

