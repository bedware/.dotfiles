ListIdeaWindows() {
    GroupAdd IdeaWindows, ahk_exe idea64.exe
    WinGet hwndList, List, ahk_group IdeaWindows
    result := "Idea windows:`n"
    Loop % hwndList {
        hwnd := hwndList%A_Index%
        WinGetTitle, windowTitle, ahk_id %hwnd%
        result := result . " - " . windowTitle . "`n"
    }
    MsgBox % result
}

!w::ListIdeaWindows()
#if ScopeIs("ahk_exe idea64.exe")
    Esc::Send +{Esc}
    ^f::^+f
#if
