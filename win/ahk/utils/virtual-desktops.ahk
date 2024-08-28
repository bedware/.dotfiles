; OnChangeDesktop listener
DllCall(RegisterPostMessageHookProc, "Ptr", A_ScriptHwnd, "Int", 0x1400 + 30, "Int")
OnMessage(0x1400 + 30, "OnChangeDesktop")
OnChangeDesktop(wParam, lParam, msg, hwnd) {
    Critical, 100
    OldDesktop := wParam + 1
    NewDesktop := lParam + 1
    Name := GetDesktopName(NewDesktop - 1)

    global altVD
    altVD := OldDesktop

    global icon
    if (icon != "running") {
        ChangeTrayIcon("desktop", NewDesktop)
    }

    ; Use Dbgview.exe to checkout the output debug logs
    OutputDebug % "Desktop changed to " Name " from " OldDesktop " to " NewDesktop
}

InitDesktops(desktops) {
    OutputDebug % "Loaded. Admin mode: " A_IsAdmin
    ; MsgBox % "Loaded. Admin mode: " A_IsAdmin
    desktopCount := GetDesktopCount()
    counter := 1
    for i, v in desktops {
        before := GetDesktopName(i - 1)
        ; Check if desktop doesn't exist
        if (i > desktopCount) {
            CreateDesktopByName(v)
        } else
        ; Check if desktop exists with exact name
        if (GetDesktopName(i - 1) != v) {
            SetDesktopName(i - 1, v)
        }
        counter++
    }
    ; Remove all extra desktops
    while (desktopCount > counter - 1) {
        RemoveDesktop(counter - 1, 1)
        OutputDebug % "counter: " counter " => Removed"
        counter++
    }

    ; Icon
    ChangeTrayIcon("desktop", GetCurrentDesktopNumber())
}

; Mechanism to make double Win+N to go to previous VD like it was possible in i3.
altVD := GetCurrentDesktopNumber()

proceedLast2VDs(num) {
    global altVD
    if (num == GetCurrentDesktopNumber()) {
        return altVD
    } else {
        return num
    }
}

; Control

MoveActiveWinAndGoToVD(num) {
    selected := proceedLast2VDs(num)
    MoveCurrentWindowToDesktopAndGoTo(selected - 1)
}
GoToVD(num) {
    selected := proceedLast2VDs(num)
    GoToDesktopNumber(selected - 1) ; indexes in this function start with 0
}
GoToVDIgnoreAlternate(num) {
    if (GetCurrentDesktopNumber() != num) {
        GoToVD(num)
    }
}
GoToAlternateVD() {
    global altVD
    GoToVD(altVD)
}

; Utility

OnThisMonitor(activeMonitor, obj) {
    SysGet, Monitor, Monitor, %activeMonitor%
    SysGet, MonitorName, MonitorName, %activeMonitor%
    if (MonitorLeft <= obj.x && obj.x <= MonitorRight && MonitorTop <= obj.y && obj.y <= MonitorBottom) {
        return true
    }
    return false
}

GetActiveMonitorByMouse() {
    selectedMonitor = -1

    CoordMode, Mouse, Screen
    MouseGetPos, xpos, ypos 

    SysGet, MonitorCount, MonitorCount
    SysGet, MonitorPrimary, MonitorPrimary
    Loop, %MonitorCount%
    {
        SysGet, MonitorName, MonitorName, %A_Index%
        SysGet, Monitor, Monitor, %A_Index%
        SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
        if (MonitorLeft <= xpos && xpos <= MonitorRight && MonitorTop <= ypos && ypos <= MonitorBottom) {
            selectedMonitor := A_Index
            break
        }
    }
    ; Tooltip, selectedMonitor :`t%selectedMonitor%`n

    return selectedMonitor
}

