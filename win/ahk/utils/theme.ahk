GetSystemTheme() {
    RegRead, theme, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme
    return theme ; 0-Black, 1-White
}

; Icon
icon = "default"
ChangeTrayIcon(mode, number := 0) {
    global icon

    if (mode = "desktop") {
        pathToIcon := _ResolveIconPathDependingOnTheme(GetSystemTheme()) "\" number ".ico"
        Menu, Tray, Icon, %pathToIcon%
    } else if (mode = "race") {
        Menu, Tray, Icon, shell32.dll, 28 ; [X]
    } else if (mode = "show") {
        Menu, Tray, Icon, shell32.dll, 298 ; ->
    } else if (mode = "show-alternate") {
        Menu, Tray, Icon, shell32.dll, 138 ; >
    } else if (mode = "running") {
        Menu, Tray, Icon, shell32.dll, 239 ; (%)
    } else if (mode = "error") {
        Menu, Tray, Icon, shell32.dll, 132 ; X
    }

    icon := mode
}

_ResolveIconPathDependingOnTheme(theme) {
    IconsFolder := "icons"
    IconsBlackTheme := "white-on-black"
    IconsWhiteTheme := "black-on-white"
    pathToIcon := % A_ScriptDir "\" IconsFolder 
    if (theme == 1) { ; 0 is default, but I like inverted style because it stands out more
        pathToIcon := % pathToIcon "\" IconsBlackTheme 
    } else {
        pathToIcon := % pathToIcon "\" IconsWhiteTheme 
    }
    return pathToIcon
}

