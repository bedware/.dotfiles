; By Dmitry Surin aka bedware

IndexOf(needle, haystack) {
    for j, k in haystack {
        if (k == needle) {
            return j - 1
        }
    }
    return -1
}

RunIfNotExist(selector, executablePath) {
    if WinExist(selector)
        WinActivate
    else {
        Run, %executablePath%
        WinWait, %selector%,, 3
        if ErrorLevel
        {
            PlayErrorSound()
        }
        if WinExist(selector)
            WinActivate
    }
}

RunIfNotExistChromeProfile(profile, executablePath) {
    if ChromeProfileWinExist(profile)
       WinActivate
    else
       Run, %executablePath%
}

PlayErrorSound() {
    SoundPlay, %A_WinDir%\Media\Windows Hardware Fail.wav
}

GetSystemTheme() {
    RegRead, theme, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize, AppsUseLightTheme
    return theme ; 0-Black, 1-White
}

; Icon
ChangeTrayIcon(pathToIcon) {
    Menu, Tray, Icon, %pathToIcon%
}

ResolveIconPathDependingOnTheme(theme) {
    global IconsFolder
    global IconsBlackTheme
    global IconsWhiteTheme
    pathToIcon := % A_ScriptDir "\" IconsFolder 
    if (theme == 1) { ; 0 is default, but I like inverted style because it stands out more
        pathToIcon := % pathToIcon "\" IconsBlackTheme 
    } else {
        pathToIcon := % pathToIcon "\" IconsWhiteTheme 
    }
    return pathToIcon
}

IconByThemeAndDesktopNumber(theme, num) {
    theme := GetSystemTheme()
    pathToIcon := ResolveIconPathDependingOnTheme(theme)
    pathToIcon := % pathToIcon "\" num ".ico"
    return ChangeTrayIcon(pathToIcon)
}

; Extending virutal displays functionality
MoveOrGotoDesktopNumberWithIcon(num) {
    MoveOrGotoDesktopNumber(num)
    IconByThemeAndDesktopNumber(GetSystemTheme(), num + 1)
}

MoveCurrentWindowToDesktopWithIcon(num) {
    MoveCurrentWindowToDesktopAndGoTo(num)
    IconByThemeAndDesktopNumber(GetSystemTheme(), num + 1)
}

; Chrome Profile
ChromeProfileWinExist(profile) {
    GroupAdd ChromeWindow, ahk_exe chrome.exe
    WinGet hwndList, List, ahk_group ChromeWindow
    Loop % hwndList {
        hwnd := hwndList%A_Index%
        extractedProfile := Chrome_GetProfile(hwnd)
        OutputDebug % "Chrome window (Profile name): " extractedProfile
        if (extractedProfile = profile){
            WinExist("ahk_id " . hwnd) ; To have ability to use WinActivate
            Return True
        }
    }
    Return False
}

Chrome_GetProfile(hwnd:=""){
    title := Acc_ObjectFromWindow(hwnd).accName
    RegExMatch(title, "^.+Google Chrome . .*?([^(]+[^)]).?$", match)
    return match1
}

Acc_ObjectFromWindow(hwnd, objectId := 0) {
    Acc_Init()
    static OBJID_NATIVEOM := 0xFFFFFFF0

    objectId &= 0xFFFFFFFF
    If (objectId == OBJID_NATIVEOM)
        riid := -VarSetCapacity(IID, 16) + NumPut(0x46000000000000C0, NumPut(0x0000000000020400, IID, "Int64"), "Int64")
    Else
        riid := -VarSetCapacity(IID, 16) + NumPut(0x719B3800AA000C81, NumPut(0x11CF3C3D618736E0, IID, "Int64"), "Int64")

    If (DllCall("oleacc\AccessibleObjectFromWindow", Ptr,hwnd, UInt,objectId, Ptr,riid, PtrP,pacc:=0) == 0)
        Return ComObject(9, pacc, 1), ObjAddRef(pacc)
}

Acc_Init() {
    Static h
    If Not h
        h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}

