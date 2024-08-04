makeAnyWindowFullscreenNative() {
    Send {F11}
}

makeAnyWindowMaximized() {
    ; WinGet, hwnd, ID, A
    WinGet, windowState, MinMax, A
    if (windowState == 1) {  ; 1 means the window is maximized
        WinRestore, A
    } else {
        WinMaximize, A
    }
}

makeAnyWindowCentered() {
    ; Get the screen dimensions
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    ; Calculate the new window dimensions (60% of screen size)
    newWidth := screenWidth * 0.6
    newHeight := screenHeight * 0.6
    ; Calculate the new window position (centered)
    newX := (screenWidth - newWidth) / 2
    newY := (screenHeight - newHeight) / 2
    ; Move the window to the calculated position and size
    WinMove, A, , newX, newY, newWidth, newHeight
}

makeAnyWindowCenteredThenMaximized() {
    WinGet, windowState, MinMax, A
    if (windowState == 1) {  ; 1 means the window is maximized
    } else {
        makeAnyWindowCentered()
        ; Maximize the window
        WinMaximize, A
    }
}

; makeAnyWindowFullscreen() {
;     WinSet, Style, -0xC40000, A
;     ; WinSet, Style, -0xC40000, ahk_exe alacritty.exe
;     ; WinMaximize, A
;     ; WinMove, A, , 0, 0, 3456, 2166
;     ; WinMove, A, , 0, 0, 2560, 1600
;     WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight
;     ; WinMove, ahk_exe alacritty.exe, , 0, 0, A_ScreenWidth, A_ScreenHeight
; }
; makeAnyWindowMaximized() {
;     WinMaximize, A
; }

ForceForegroundWinActivate() {
    WinGet, id, List
    Loop % id {
        hwnd := id%A_Index%
        obj := GatherData(hwnd)
        if (!FilterApps(obj)) {
            WinActivate, ahk_id %hwnd%
            break
        }
    }
}

GatherData(hwnd) {
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

FilterApps(obj) {
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

