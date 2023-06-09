Init(desktops) {
    OutputDebug % "Loaded. Admin mode: " A_IsAdmin
    ; RemoveAllDesktops()
    desktopCount := GetDesktopCount()
    counter := 0
    for i, v in desktops {
        currentDesktop := i - 1
        ; before := GetDesktopName(currentDesktop)
        ; Check if desktop doesn't exist
        if (i > desktopCount) {
            CreateDesktopByName(v)
        } else
        ; Check if desktop exists with exact name
        if (GetDesktopName(currentDesktop) != v) {
            SetDesktopName(currentDesktop, v)
        }
        ;OutputDebug % before " => " GetDesktopName(currentDesktop) " currentDesktop: " currentDesktop " counter: " counter
        counter++
    }
    ; Remove all extra desktops
    while (counter < desktopCount) {
        RemoveDesktop(counter, 1)
        ; OutputDebug % "counter: " counter " => Removed"
        counter++
    }
    ; OutputDebug % "desktopCount: " GetDesktopCount() " counter: " counter

    ; Icon
    defaultIcon := % ResolveIconPathDependingOnTheme(GetSystemTheme()) "\+.ico"  
    ChangeTrayIcon(defaultIcon)
    RearrangeWindows()
}

; User functions
RearrangeWindows() {
    global apps
    global desktops
    for i, v in apps {
        if (v.desktop != "" && v.selector != "") {
            while (WinExist(v.selector)) {
                WinActivate 
                desktopNum := IndexOf(v.desktop, desktops)
                if (IndexOf(v.desktop, desktops) != -1) {
                    MoveCurrentWindowToDesktop(desktopNum)
                }
            }
        }
    } 
}

FocusOrRunWorkChromeProfile() {
    RunIfNotExistChromeProfile("Will", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Default""")
}

FocusOrRunPersonalChromeProfile() {
    RunIfNotExistChromeProfile("Power", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Profile 4""")
}

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
        WinWait, %selector%,, 20
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

