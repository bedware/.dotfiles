toggleTaskbar(how_to_toggle) {
    
    static SW_HIDE := 0, SW_SHOWNA := 8, SPI_SETWORKAREA := 0x2F
    
    DetectHiddenWindows, On
    
    hTB := WinExist("ahk_class Shell_TrayWnd")
    
    WinGetPos,,,, H
    
    hBT := WinExist("ahk_class Button ahk_exe Explorer.EXE")  ; for Windows 7
    
    b := DllCall("IsWindowVisible", "Ptr", hTB)

    ; always set to false

    if (how_to_toggle != -1) 
    {
        b = %how_to_toggle%
    } 

    
    for k, v in [hTB, hBT]
        ( v && DllCall("ShowWindow", "Ptr", v, "Int", b ? SW_HIDE : SW_SHOWNA) )
    
    VarSetCapacity(RECT, 16, 0)
    
    NumPut(A_ScreenWidth, RECT, 8)
    NumPut(A_ScreenHeight - !b * H, RECT, 12, "UInt")
    
    DllCall("SystemParametersInfo", "UInt", SPI_SETWORKAREA, "UInt", 0, "Ptr", &RECT, "UInt", 0)

    ; set all windows to max dimensions 

    WinGet, List, List
    
    Loop % List {
        WinGet, res, MinMax, % "ahk_id" . List%A_Index%
        if (res = 1)
            WinMove, % "ahk_id" . List%A_Index%,, 0, 0, A_ScreenWidth, A_ScreenHeight - !b * H
    }
}
