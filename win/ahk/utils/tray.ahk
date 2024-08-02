; Initialize the list to keep track of appsInTray and their information
appsInTray := []

; Function to add a window to the tray menu
AddAppToTray(winTitle, winID, pathToExe) {
    global appsInTray

    unhide := Func("RemoveAppFromTrayByPath").Bind(pathToExe)
    Menu, Tray, Add, % winTitle, % unhide
    Menu, Tray, Icon, % winTitle, % pathToExe
    appsInTray.Push({winID: winID, pathToExe: pathToExe, winTitle: winTitle, unhide: unhide})
}

; Function to check if a window is already in the tray menu
IsAppInTray(pathToExe) {
    global appsInTray
    for _, win in appsInTray {
        if (win.pathToExe = pathToExe) {
            return true
        }
    }
    return false
}

; Function to remove a window from the tray menu
RemoveAppFromTrayByPath(pathToExe) {
    global appsInTray
    for index, win in appsInTray {
        if (win.pathToExe = pathToExe) {
            Menu, Tray, Delete, % win.winTitle
            appsInTray.RemoveAt(index)

            ; Restore window
            winID := win.winID
            WinShow, ahk_id %winID%
            WinActivate, ahk_id %winID%
        }
    }
}

RemoveAppFromTrayByTitle(title) {
    global appsInTray
    for index, win in appsInTray {
        if (win.winTitle = title) {
            Menu, Tray, Delete, % win.winTitle
            appsInTray.RemoveAt(index)

            ; Restore window
            winID := win.winID
            WinShow, ahk_id %winID%
            WinActivate, ahk_id %winID%
            return true
        }
    }
    return false
}

HideAppToTray(){
    global apps
    WinGet, WinID, ID, A
    WinGet, pathToExe, ProcessPath, ahk_id %WinID%
    WinGetTitle, WinTitle, ahk_id %WinID%
    WinGet, Style, Style, ahk_id %WinID%

    if (Style & 0xC00000) { ; If active window has titlebar
        if (StrLen(WinTitle) > 50) {
            WinTitle := SubStr(WinTitle, 1, 50) "..."
        }
        AddAppToTray(WinTitle, WinID, pathToExe)
        WinHide, ahk_id %WinID%

        ForceForegroundWinActivate()
    }
}

freeHiddenWindows() {
    global appsInTray
    for _, win in appsInTray {
        winID := win.winID
        WinShow, ahk_id %winID%
        WinActivate, ahk_id %winID%
    }
}
OnExit("freeHiddenWindows")

