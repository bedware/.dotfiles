#if WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
    or WinActive("ahk_exe firefox.exe")
    or WinActive("ahk_exe Cypress.exe")
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

#if WinActive("ahk_exe msedge.exe")
    Space & s::
    #s::
        createPopUp("select workspace", "C:\Users\dmitr\.dotfiles\win\pwsh\bin\Switch-BrowserWorkspace.ps1", false)
    return
#if

#if WinActive("select workspace ahk_class Window Class ahk_exe alacritty.exe")
    Space & s::
    #s::
    ~*Enter::
        HideAppToTray()
    return
#if

