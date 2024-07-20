#if WinActive("ahk_exe chatgpt.exe")
    ^s::Send ^+s
    ^n::Send ^+o
    ^i::Send ^+i
    ^r::Send ^+c
    ^e::Send ^+;
    ^x::Send ^+{BackSpace}
    CapsLock Up::
        if (A_PriorKey = "Capslock") {
            HideAppToTray()
        }
    return
#if

; ChatGpt
#g::
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray()
    else
        executeInput(apps, "gpt")
return

