#if HOTKEY_ON
    LCtrl::LCtrl ; to enable hook

    ; Notebook keys
    Home::F19 ; Start/stop recording
    End::F17 ; Pause/unpause
    PgUp::F20
    PgDn::F18
#if

#Include %A_ScriptDir%/remap/per-key/mouse-key.ahk
#Include %A_ScriptDir%/remap/per-key/shift-key.ahk
#Include %A_ScriptDir%/remap/per-key/alt-key.ahk
#Include %A_ScriptDir%/remap/per-key/ctrl-key.ahk
#Include %A_ScriptDir%/remap/per-key/capslock-key.ahk
#Include %A_ScriptDir%/remap/per-key/space-key.ahk
#Include %A_ScriptDir%/remap/per-key/tab-key.ahk
#Include %A_ScriptDir%/remap/per-key/windows-key.ahk

#Include %A_ScriptDir%/remap/per-app/total-cmd.ahk
#Include %A_ScriptDir%/remap/per-app/telegram.ahk
#Include %A_ScriptDir%/remap/per-app/gpt.ahk
#Include %A_ScriptDir%/remap/per-app/idea.ahk
#Include %A_ScriptDir%/remap/per-app/lens.ahk
#Include %A_ScriptDir%/remap/per-app/browser.ahk
#Include %A_ScriptDir%/remap/per-app/sites.ahk
#Include %A_ScriptDir%/remap/per-app/devtools.ahk
#Include %A_ScriptDir%/remap/per-app/sumatra.ahk
