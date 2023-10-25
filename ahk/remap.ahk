; Disable keys
*~LButton::return ; To make mouse hook work
*RButton::
if (GetKeyState("LButton")) {
    ; KeyWait, LButton
    Func("doTranslation").Call()
} else {
    Send {RButton}
}
return ; To make mouse hook work
*~MButton::return ; To make mouse hook work
*~WheelDown::return ; To make mouse hook work
*~WheelUp::return ; To make mouse hook work

; Laptop
Escape::F15 ; On/Off speakers
Home::F16 ; Start/stop recording
End::F20 ; Pause/unpause recording
PgUp::F24 ; First scene
PgDn::F23 ; Second scene
; Pedal
F13::Func("doTranslation").Call()
; Shift
RShift & Capslock::Send +{Esc}
; Press both shift keys together to toggle Capslock
LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

; it is for harpoon to work
^;::^F5
^'::^F6
; Use the Soundcard Analysis script found here to set these parameters
; https://www.autohotkey.com/docs/commands/SoundSet.htm#Soundcard
Volume_Up::
    SoundSet, +2, Master, Volume, 2
    SoundSet, +2, Master, Volume, 4
return
Volume_Down::
    SoundSet, -2, Master, Volume, 2
    SoundSet, -2, Master, Volume, 4
return

!^f::makeAnyWindowFullsreen()

!^;::
    WinMove, A, , -10, -100, 2180, 1325
return

#`:: ; Quake alive
    processName := "WindowsTerminal.exe"
    if (!ProcessExist("WindowsTerminal.exe")) {
        Run, wt.exe -w _quake
        WinWait, ahk_exe WindowsTerminal.exe,, 5
        WinActivate
    } else {
        Send #``
    }
return
#Enter::
    Run wt
    WinWait, "Administrator: PowerShell ahk_exe WindowsTerminal.exe",, 3
return

#if GetKeyState("LShift", "P")
LShift up::
    global apps
    if (A_PriorKey = "LShift") {
        RunAlfred(apps)
    }
return 
#if

; Language switch
~*RShift::
    Send {RShift DownR}
    KeyWait, RShift
    Send {RShift Up}
    if (A_PriorKey = "RShift") {
        Send #{Space}
    }
return 

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
    LWin::#z ; Windows layout popup
    j::Send ^+{Tab} ; Next tab
    k::Send ^{Tab} ; Prev tab
#if

LCtrl::LCtrl ; to enable hook
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
    '::Send {Enter}
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
    ^g::Send ^+{a} ; Search in tabs popup
    !t::Send ^l@tabs{Space} ; Search in tabs
    !h::Send ^l@history{Space} ; Search in history
    !b::Send ^l@bookmarks{Space} ; Search in Bookmarks 
    ^i::Send !{Right} ; Navigation history forward 
    ^o::Send !{Left} ; Navigation history backward
#if
#if WinActive("ahk_exe TOTALCMD64.EXE")
    !e::Send {Home}{F2} ; Edit path
    !p::Send ^{F12} ; Copy path to selected file
#if
#if WinActive("ahk_class TLister ahk_exe TOTALCMD64.EXE")
    j::Down
    k::Up
    h::Left
    l::Right
    ^d::PgDn
    ^u::PgUp
    g::Send ^{Home}
    +g::Send ^{End}
#if

#InputLevel 0
; Win-hotkeys
#j::NextWindow()
#f::NextWindow()
#k::PrevWindow()
#b::PrevWindow()
#^t:: ; Toggle taskbar
    toggleTaskbar(-1)
    PlayErrorSound()
return
#^d:: ; Show active windows on all virtual desktops (VD)
    WinGet, activeHwnd, ID, A
    PinWindow(activeHwnd)
    PlayErrorSound()
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
#6::GoToAlternateVD()
#=::GoToAlternateVD()
#7::GoToVD(7)
#8::GoToVD(8)
#9::GoToVD(9)
#0::GoToVD(6)

#+1::MoveActiveWinAndGoToVD(1)
#+2::MoveActiveWinAndGoToVD(2)
#+3::MoveActiveWinAndGoToVD(3)
#+4::MoveActiveWinAndGoToVD(4)
#+5::MoveActiveWinAndGoToVD(5)
; #+6
#+7::MoveActiveWinAndGoToVD(7)
#+8::MoveActiveWinAndGoToVD(8)
#+9::MoveActiveWinAndGoToVD(9)
#+0::MoveActiveWinAndGoToVD(6)

