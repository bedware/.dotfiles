#if ScopeIs("ahk_exe chrome.exe")
    or ScopeIs("ahk_exe msedge.exe")
    or ScopeIs("ahk_exe firefox.exe")
    or ScopeIs("ahk_exe Cypress.exe")
    ^g::Send ^+{a} ; Search in tabs popup
    ^i::Send !{Right} ; Navigation history forward 
    ^o::Send !{Left} ; Navigation history backward
    !g::
        Send {F6}{F6}
        Sleep 250
        Send {AppsKey}aa{Enter}
    return
#if

; Workspace switcher popup

#if ScopeIs("ahk_exe msedge.exe")
    *LAlt::
        SendEvent {LAlt DownR}
        KeyWait, LAlt
        SendEvent {LAlt Up}
        if (A_PriorKey = "LAlt") {
            createPopUp("select workspace", "C:\Users\bedware\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1", false)
        }
    return
#if

#if ScopeIs("select workspace ahk_class Window Class ahk_exe alacritty.exe")
    LAlt::
        HideAppToTray("select workspace")
    return
    ~*Enter::
        HideAppToTray("select workspace")
        Sleep 75
        Send ^l
        Send {Esc}
    return
#if
