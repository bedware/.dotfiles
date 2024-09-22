; Initialize the list to keep track of appsInTray and their information
appsInTray := []

; Function to add a window to the tray menu
AddAppToTray(winId, path, winTitle) {
    global appsInTray

    unhide := Func("RemoveAppFromTrayByPath").Bind(path)
    Menu, Tray, Add, % winTitle, % unhide
    Menu, Tray, Icon, % winTitle, % path
    appsInTray.Push({ winId: winId, path: path, winTitle: winTitle, unhide: unhide })
}

; Function to check if a window is already in the tray menu
IsAppInTrayById(winId) {
    global appsInTray
    for _, win in appsInTray {
        if (win.winId = winId) {
            return true
        }
    }
    return false
}
IsAppInTrayByPath(path) {
    global appsInTray
    for _, win in appsInTray {
        if (win.path = path) {
            return true
        }
    }
    return false
}
IsAppInTrayByTitle(title) {
    global appsInTray
    for _, win in appsInTray {
        if (win.winTitle = title) {
            return true
        }
    }
    return false
}

RemoveAppFromTrayById(winId) {
    global appsInTray
    for index, win in appsInTray {
        if (win.winId = winId) {
            Menu, Tray, Delete, % win.winTitle
            appsInTray.RemoveAt(index)

            winId := win.winId
            WinShow, ahk_id %winId%
            WinActivate, ahk_id %winId%
            return true
        }
    }
    return false
}
RemoveAppFromTrayByPath(path) {
    global appsInTray
    for index, win in appsInTray {
        if (win.path = path) {
            Menu, Tray, Delete, % win.winTitle
            appsInTray.RemoveAt(index)

            winId := win.winId
            WinShow, ahk_id %winId%
            WinActivate, ahk_id %winId%
            return true
        }
    }
    return false
}
RemoveAppFromTrayByTitle(title) {
    global appsInTray
    for index, win in appsInTray {
        if (win.winTitle = title) {
            Menu, Tray, Delete, % win.winTitle
            appsInTray.RemoveAt(index)

            winId := win.winId
            WinShow, ahk_id %winId%
            WinActivate, ahk_id %winId%
            return true
        }
    }
    return false
}

HideAppToTray(appName := false){
    global apps
    WinGet, winId, ID, A
    WinGet, path, ProcessPath, ahk_id %winId%
    WinGetTitle, winTitle, ahk_id %winId%
    WinGet, Style, Style, ahk_id %winId%

    if (Style & 0xC00000) { ; If active window has titlebar
        if (StrLen(winTitle) > 50) {
            winTitle := SubStr(winTitle, 1, 50) "..."
        }
        AddAppToTray(winId, path, winTitle)
        WinHide, ahk_id %winId%

        if (appName) {
            toStore(appName, winId)
        }

        ForceForegroundWinActivate()
    }
}

freeHiddenWindows() {
    global appsInTray
    for _, win in appsInTray {
        winId := win.winId
        WinShow, ahk_id %winId%
        WinActivate, ahk_id %winId%
        WinClose, ahk_id %winId%
    }
}
OnExit("freeHiddenWindows")

