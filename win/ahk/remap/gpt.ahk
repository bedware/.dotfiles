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
#g::toggle_gpt()

toggle_gpt() {
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray()
    else
        executeInput(apps, "gpt")
}
