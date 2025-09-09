FocusOrRunWorkChromeProfile() {
    RunIfNotExistChromeProfile("Dmitry Surin", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Default""")
}

FocusOrRunPersonalChromeProfile() {
    RunIfNotExistChromeProfile("bedware", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Profile 5""")
}

RunIfNotExistChromeProfile(profile, executablePath) {
    if ChromeProfileWinExist(profile)
       WinActivate
    else
       Run %executablePath%
}

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

; !a::
;     WinGet, hwnd, ID, A
;     name := Acc_ObjectFromWindow(hwnd).accName
;     MsgBox % name
; return
;
; !s::
;     WinGet, hwnd, ID, A
;     name := Chrome_GetProfile(hwnd)
;     MsgBox % name
; return

Chrome_GetProfile(hwnd:=""){
    title := Acc_ObjectFromWindow(hwnd).accName
    RegExMatch(title, ".*- (.*)$", match)
    return match1
}

; For processes observation. I use it to extract Chrome's Active Profile Name.
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

