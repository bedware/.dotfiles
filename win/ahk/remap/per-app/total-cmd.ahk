#if ScopeIs("ahk_exe TOTALCMD64.EXE")
    !e::Send {Home}{F2} ; Edit path
    !p::Send ^{F12} ; Copy path to selected file
    ^i::Send !{Right} ; Forward History
    ^o::Send !{Left} ; Backward History
#if

#if ScopeIs("ahk_class TLister ahk_exe TOTALCMD64.EXE")
    j::Down
    k::Up
    h::Left
    l::Right
    ^d::PgDn
    ^u::PgUp
    g::Send ^{Home}
    +g::Send ^{End}
#if

#if ScopeIs("ahk_exe explorer.exe")
    !1::Send ^+6
    !2::Send ^+2
#if

