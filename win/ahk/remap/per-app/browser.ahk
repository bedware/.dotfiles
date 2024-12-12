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
    LAlt::createPopUp("select workspace", "C:\Users\dmitr\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1", false)
#if

#if ScopeIs("select workspace ahk_class Window Class ahk_exe alacritty.exe")
    LAlt::
    ~*Enter::
        HideAppToTray("select workspace")
    return
#if
