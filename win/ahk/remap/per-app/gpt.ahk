#if ScopeIs("^ChatGPT ahk_exe msedge.exe")
    ^s::Send ^+s
    ^n::Send ^+o
    ^i::Send ^+i
    ^r::Send ^+c
    ^e::Send ^+;
    ^x::Send ^+{BackSpace}

    CapsLock Up::
        if (A_PriorKey = "Capslock") {
            HideAppToTray("gpt")
        }
    return
#if

