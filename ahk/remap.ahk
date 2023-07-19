; Disable keys
*~LButton::return ; To make mouse hook work
*~RButton::return ; To make mouse hook work
*~MButton::
; DetectHiddenWindows, Off
; WinGet, id, List,,, Program Manager
; Loop, %id%
; {
;     this_id := id%A_Index%
;     WinActivate, ahk_id %this_id%
;     WinGetClass, this_class, ahk_id %this_id%
;     WinGetTitle, this_title, ahk_id %this_id%
;     MsgBox, 4, , Visiting All Windows`n%A_Index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
;     IfMsgBox, NO, break
; }
return ; To make mouse hook work
*~WheelDown::return ; To make mouse hook work
*~WheelUp::return ; To make mouse hook work
LCtrl::return
Home::F13
End::F14
PgUp::F15
PgDn::F16
; Translate
F20::
    global HOME

    Send {Ctrl Down}cc{Ctrl Up}
    KeyWait, LCtrl

    translationFile := HOME . "\translations"
    clipboardPlusSeparator := clipboard . "`n---`n"

    FileAppend, %clipboardPlusSeparator%, %translationFile%
return


; Shift
RShift & Capslock::Send +{Esc}

#if GetKeyState("LShift", "P")
LShift up::
    global apps
    if (A_PriorKey = "LShift") {
        RunAlfred(apps)
    }
return 

#if

; ~*LShift::
;     global apps
;
;     SendEvent {Blind}{LShift DownR}
;     KeyWait, LShift
;     SendEvent {Blind}{LShift Up}
;     if (A_ThisHotkey = "~*LShift" and A_PriorKey = "LShift") {
;         RunAlfred(apps)
;     }
; return 
; F20::
;     global apps
;     RunAlfred(apps)
; return 

; Language switch
~*RShift::
    Send {RShift DownR}
    KeyWait, RShift
    Send {RShift Up}
    if (A_PriorKey = "RShift") {
        Send #{Space}
    }
return 

; Press both shift keys together to toggle Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

; Tab-hotkeys
*Tab::
    if (A_PriorKey = "LAlt") {
        SendEvent {Blind}{Tab}
        KeyWait, Tab
    } else {
        KeyWait, Tab
        if (A_ThisHotkey = "*Tab" and A_PriorKey = "Tab") {
            SendEvent {Blind}{Tab}
        }
    }
return
#if GetKeyState("Tab", "P")
    ; Layout set up
    LWin::#z
    j::
        if WinActive("ahk_exe idea64.exe")
            Send {Alt Down}{Left}{Alt Up}
        else if GetKeyState("Space", "P")
            SendWithCorrectModifiers("Down")
        else ; Default
            Send ^+{Tab}
    return
    k::
        if WinActive("ahk_exe idea64.exe")
            Send {Alt Down}{Right}{Alt Up}
        else if GetKeyState("Space", "P")
            SendWithCorrectModifiers("Up")
        else ; Default
            Send ^{Tab}
    return
    i:: ; Navigation history backward
        if WinActive("ahk_exe idea64.exe")
            Send {Ctrl Down}{Alt Down}{Left}{Alt Up}{Ctrl Up}
        else ; Default
            Send {Alt Down}{Right}{Alt Up}
    return
    o:: ; Navigation history forward
        if WinActive("ahk_exe idea64.exe")
            Send {Ctrl Down}{Alt Down}{Right}{Alt Up}{Ctrl Up}
        else ; Default
            Send {Alt Down}{Left}{Alt Up}
    return

    ; Non-disappearing AltTab + Win
    LAlt::Send ^!{Tab}
#if

*CapsLock::
    SendEvent {Ctrl DownR}
    KeyWait, Capslock
    SendEvent {Ctrl Up}
    if (A_PriorKey = "Capslock") {
        if WinExist("ahk_exe DeepL.exe") and WinExist("ahk_exe Lingvo.exe") or WinExist("ahk_exe DeepL.exe") {
            WinClose, ahk_exe Lingvo.exe
            WinClose, ahk_exe DeepL.exe
        }
        Send {Esc}
    }
return

#if GetKeyState("RCtrl", "P")
    Backspace::
        MsgBox % "Hit"
        Send ^{Backspace}
    return
#if 

; Space
*Space::
    KeyWait, Space
    if (A_ThisHotkey = "*Space" and A_PriorKey = "Space") {
        SendEvent {Blind}{Space}
    }
return

#if GetKeyState("Space", "P")
    *Tab::
        Send {LAlt DownR}
        KeyWait, Tab
        Send {LAlt Up}
    return
    ; Copy & Paste
    y::Send ^{Insert}
    p::Send +{Insert}
    d::Send +{Del}

    ; Left hand
    ; qw
    q::^q
    w::^w
    ; as
    a::^a
    ; zxcv
    z::^z
    x::^x
    c::^c
    v::^+m ; Select mode (vi-mode) in wt
    ;v::SendInput {U+2705}

    ; Right hand
    Enter::Insert
    /::Reload

    ; Context menu
    m::Send {AppsKey}
    ; Other
    `;::NumpadMult

    ; To work as modifiers when Space pressed
    *LShift::LShift
    *LAlt::LAlt

    ; F-keys
    *1::F1
    *2::F2
    *3::F3
    *4::F4
    *5::F5
    *6::F6
    *7::F7
    *8::F8
    *9::F9
    *0::F10
    *-::F11
    *=::F12

    ; Navigation
    *h::Left
    *j::Down
    *k::Up
    *l::Right
    *[::PgUp
    *]::PgDn
    *,::Home
    *.::End
#if

#if WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe msedge.exe")
    !g::Send ^+{a} ; Search in tabs popup
    !t::Send ^l@tabs{Space} ; Search in tabs
    !h::Send ^l@history{Space} ; Search in history
    !b::Send ^l@bookmarks{Space} ; Search in Bookmarks 
#if

#InputLevel 0
; Win-hotkeys
#h::#Left
#j::#Down
#k::#Up
#l::#Right
;#t::#t ; Powertoys pin window on-top
#m::Send ^+{Esc} ; Task manager
#,::#^Left
#.::#^Right
#^t::toggleTaskbar(-1)
#^d::
    WinGet, activeHwnd, ID, A
    PinWindow(activeHwnd)
return
; Close
#w::Send ^{w}
; Quit
#q::Send !{F4}

; Virtual desktops management
#1::GoToVD(1)
#2::GoToVD(2)
#3::GoToVD(3)
#4::GoToVD(4)
#5::GoToVD(5)
#6::GoToVD(6)
#7::GoToVD(7)
#8::GoToVD(8)
#9::GoToVD(9)

#+1::MoveActiveWinAndGoToVD(1)
#+2::MoveActiveWinAndGoToVD(2)
#+3::MoveActiveWinAndGoToVD(3)
#+4::MoveActiveWinAndGoToVD(4)
#+5::MoveActiveWinAndGoToVD(5)
#+6::MoveActiveWinAndGoToVD(6)
#+7::MoveActiveWinAndGoToVD(7)
#+8::MoveActiveWinAndGoToVD(8)
#+9::MoveActiveWinAndGoToVD(9)

