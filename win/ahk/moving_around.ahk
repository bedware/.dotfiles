Init(desktops) {
    OutputDebug % "Loaded. Admin mode: " A_IsAdmin
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
    IconByThemeAndDesktopNumber(GetCurrentDesktopNumber())
}

; Mechanism to make double Win+N to go to previous VD like it was possible in i3.
altVD := GetCurrentDesktopNumber()

proceedAlternateVD(num) {
    global altVD
    if (num == GetCurrentDesktopNumber()) {
        return altVD
    } else {
        return num
    }
}

; Better alt+tab in the way of monoid layout in i3
windowsList := [] ; List of windows hwnds
activeIndex := -1 ; Active hwnd

feedWindowList() {
    global activeIndex
    global windowsList
    activeMonitor := getActiveMonitorByMouse()

    tempArr := []
    ; Get all windows on the screen
    WinGet, id, List
    Loop % id {
        hwnd := id%A_Index%
        ; Store in appropriate structure
        obj := gatherData(hwnd)
        ; Filter out windows using euristics
        if (filteredApps(obj) or !onThisMonitor(activeMonitor, obj)) {
            ; filtered.Push(hwnd)
        } else {
            ; OutputDebug % "Window title: " obj.title ", class: " obj.class ", process:" obj.process
            tempArr.Push(hwnd)
        }
    }
    
    ; Merge 2 lists ; windowsList - old ; tempArr - new
    ; 1. Filter not existing anymore items in old array.
    i := 1
    while i <= windowsList.MaxIndex() {
        if (IndexOf(windowsList[i], tempArr) == -1) {
            windowsList.RemoveAt(i)
        } else {
            i := i + 1
        }
    }

    ; 2. Traverse new array to find items that not exist in old array.
    i := 1
    while i <= tempArr.MaxIndex() {
        if (IndexOf(tempArr[i], windowsList) != -1) {
            tempArr.RemoveAt(i)
        } else {
            i := i + 1
        }
    }
    ; 3. Add the to the top
    for i, v in tempArr {
        windowsList.Push(v)
    }
    ; _showDebugWindow(windowsList)
}

; Control

MoveActiveWinAndGoToVD(num) {
    selected := proceedAlternateVD(num)
    MoveCurrentWindowToDesktopAndGoTo(selected - 1)
}
GoToVD(num) {
    selected := proceedAlternateVD(num)
    GoToDesktopNumber(selected - 1) ; indexes in this function start with 0
    feedWindowList()
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

NextWindow() {
    global windowsList
    global activeIndex
    if !WinExist("ahk_id " + activeIndex) {
        WinGet, active_id, ID, A
        activeIndex := active_id
    }
    feedWindowList()
    index := IndexOf(activeIndex, windowsList)
    if (index != -1) {
        if index + 1 <= windowsList.MaxIndex() {
            activeIndex := windowsList[index + 1]
            index := index + 1
            OutputDebug % "Next"
            ; _showDbg(index, activeIndex, windowsList)
        }
    } else {
        OutputDebug % "Next - Init"
        activeIndex := windowsList[1]
    }
    if WinExist("ahk_id " + activeIndex) {
        WinActivate
    }
}
PrevWindow() {
    global windowsList
    global activeIndex
    ; winCountBefore := windowsList.MaxIndex()
    if !WinExist("ahk_id " + activeIndex) {
        WinGet, active_id, ID, A
        activeIndex := active_id
    }
    feedWindowList()
    index := IndexOf(activeIndex, windowsList)
    if (index != -1) {
        if (index - 1 >= 1) {
            activeIndex := windowsList[index - 1]
            index := index - 1
            OutputDebug % "Prev"
            ; _showDbg(index, activeIndex, windowsList)
        }
    } else {
        OutputDebug % "Prev - Init"
        activeIndex := windowsList[1]
    }
    if WinExist("ahk_id " + activeIndex) {
        WinActivate
    }
}

; Filter

filteredApps(obj) {
    if obj.title == ""
        return true
    if obj.title == "PopupHost"
        return true
    if obj.x == 0 and obj.y == 0 and obj.width == 0 and obj.height == 0
        return true
    if obj.class == "Progman"
        return true
    if obj.class == "Xaml_WindowedPopupClass"
        return true
    if obj.class == "WorkerW"
        return true
    if obj.class == "Shell_TrayWnd"
        return true
    if obj.class == "Shell_SecondaryTrayWnd"
        return true
    if obj.class == "PseudoConsoleWindow"
        return true
    if obj.process == "svchost.exe"
        return true
    if obj.process == "AutoHotkey.exe"
        return true
    return false
}

; Utility

gatherData(hwnd) {
    WinGetClass, Clazz, ahk_id %hwnd%
    WinGetTitle, Title, ahk_id %hwnd%
    WinGetPos, X, Y, Width, Height, ahk_id %hwnd%
    if X < 0
        X = 0
    if Y < 0
        Y = 0
    WinGet, processName, ProcessName, ahk_id %hwnd%
    return { id: hwnd, class: Clazz, title: Title, process: processName, x: X + 40, y: Y + 40, width: Width, height: Height }
}
onThisMonitor(activeMonitor, obj) {
    SysGet, Monitor, Monitor, %activeMonitor%
    SysGet, MonitorName, MonitorName, %activeMonitor%
    if (MonitorLeft <= obj.x && obj.x <= MonitorRight && MonitorTop <= obj.y && obj.y <= MonitorBottom) {
        return true
    }
    return false
}
getActiveMonitorByMouse() {
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

; Debug

_showDbg(index, hwnd, arr) {
    OutputDebug % "index " index ", hwnd " hwnd ", windowsList.size" arr.MaxIndex()
    for i, v in arr {
        if (index == i) {
            OutputDebug % "windowsList[" i "]-" arr[i] "-SELECTED"
        } else {
            OutputDebug % "windowsList[" i "]-" arr[i]
        }
    }
}

_showDebugWindow(arr) {
    for i, h in arr {
        obj := gatherData(h)
        info := " 
        (
            Active Monitor " activeMonitor "
            Windows " i " of " arr.MaxIndex() "
            ahk_id " obj.id "
            ahk_class " obj.class "
            processName " obj.process "
            Title: " obj.title "
            X: " obj.x ", Y: " obj.y ", W: " obj.width ", H: " obj.height "
            Continue?
        )"
        ; MsgBox, 4, ,%info%
        ; IfMsgBox, NO, break
        OutputDebug % "Window detected: " i "-" obj.title
        OutputDebug % info
    }
}

