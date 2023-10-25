; Utility
; Yeah, arrays start from 1 in AHK and arr.Length == arr.MaxIndex()
IndexOf(needle, haystack) {
    for i, k in haystack {
        if (k == needle) {
            return i
        }
    }
    return -1
}

; Processes

ProcessExist(exeName) {
    Process, Exist, %exeName%
    return ErrorLevel
}

RunIfProcessNotExist(exeName, path) {
    if (!ProcessExist(exeName)) {
        Run %path%
        return ProcessExist(exeName) 
    }
    return 0
}

RunIfNotExist(selector, executablePath) {
    OutputDebug % "Trying to activate " selector 
    if WinExist(selector) {
        OutputDebug % "Activating " selector 
        WinActivate
    } else {
        Run %executablePath%
        WinWait, %selector%,, 10
        if ErrorLevel {
            PlayErrorSound()
            showAlfredError("You have reached the timeout after running.")
            return -1
        }
        if WinExist(selector) {
            OutputDebug % "Activating after run " selector 
            WinActivate
        }
    }
}

; Themes, sound, video

PlayErrorSound() {
    SoundPlay, %A_WinDir%\Media\Windows Hardware Fail.wav
}

GetSystemTheme() {
    RegRead, theme, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme
    return theme ; 0-Black, 1-White
}

; Icon
IconByThemeAndDesktopNumber(theme, num) {
    theme := GetSystemTheme()
    pathToIcon := ResolveIconPathDependingOnTheme(theme)
    pathToIcon := % pathToIcon "\" num ".ico"
    return ChangeTrayIcon(pathToIcon)
}
ResolveIconPathDependingOnTheme(theme) {
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
ChangeTrayIcon(pathToIcon) {
    Menu, Tray, Icon, %pathToIcon%
}

; Keys
; Modifiers handling
SendWithCorrectModifiers(key) {
    OutputDebug % "Shift:" GetKeyState("Shift") ",Ctrl:" GetKeyState("Ctrl") ",Alt:" GetKeyState("Alt")  
    if (GetKeyState("Shift") and GetKeyState("Ctrl") and GetKeyState("Alt"))
        Send !+^{%key%}
    else if (GetKeyState("Shift") and GetKeyState("Ctrl"))
        Send +^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Ctrl"))
        Send !^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Shift"))
        Send !+{%key%}
    else if (GetKeyState("Shift"))
        Send +{%key%}
    else if (GetKeyState("Ctrl"))
        Send ^{%key%}
    else if (GetKeyState("Alt"))
        Send !{%key%}
    else
        Send {%key%}
}

; Shifts
ToggleCaps(){
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}

