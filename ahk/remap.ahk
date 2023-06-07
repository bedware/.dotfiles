; Disable keys
*~LButton::return ; To make mouse hook work
RCtrl::return
RAlt::return
Home::F13
End::F14
PgUp::F15
PgDn::F16

; Shift
RShift & Capslock::Send +{Esc}

~*LShift::
    global apps

    Send {LShift DownR}
    KeyWait, LShift
    Send {LShift Up}
    if (A_ThisHotkey = "~*LShift" and A_PriorKey = "LShift") {
        RunAlfred(apps)
    }
return 

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

; Win-hotkeys
#h::#Left
#j::#Down
#k::#Up
#l::#Right
;#t::#t ; Powertoys pin window on-top
#m::Send {Ctrl Down}{Shift Down}{Esc}{Shift Up}{Ctrl Up} ; Task manager
#,::#^Left
#.::#^Right

;Close window
#Backspace::Send !{F4}

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
    ;Close tab
    Backspace::
        if WinActive("ahk_exe idea64.exe") or WinActive("ahk_exe sublime_text.exe")
            Send ^{F4}
        else ; Default
            Send ^w
    return
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

; Translate
LCtrl::
    global UserHome

    Send {Ctrl Down}cc{Ctrl Up}
    KeyWait, LCtrl

    translationFile := UserHome . "\translations"
    clipboardPlusSeparator := clipboard . "`n---`n"

    FileAppend, %clipboardPlusSeparator%, %translationFile%
return

*CapsLock::
    Send {Ctrl DownR}
    KeyWait, Capslock
    Send {Ctrl Up}
    if (A_PriorKey = "Capslock") {
        if WinExist("ahk_exe DeepL.exe") and WinExist("ahk_exe Lingvo.exe") {
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
    ; zx
    z::^z
    x::^x
    v::^+m
    ;v::SendInput {U+2705}

    ; Undo, Redo, Chrome hotkeys
    i:: ; Undo
        if WinActive("ahk_exe chrome.exe")
            Send ^l@history{Space}
        else
            Send ^{z}
    return
    o:: ; Redo
        if WinActive("ahk_exe chrome.exe")
            Send ^l@tabs{Space}
        if WinActive("ahk_exe idea64.exe")
            Send ^+{z}
        else
            Send ^{y}
    return
    b:: ; bookmarks 
        if WinActive("ahk_exe chrome.exe")
            Send ^l@bookmarks{Space}
        else
            Send ^{b}
    return

    ; Run
    r::
    if GetKeyState("Shift")
        Send ^{F2}
    else
        Send ^+{F10}
    return

    ; Right hand
    Enter::Insert
    Backspace::Delete
    /::Reload

    ; Context menu
    m::Send {AppsKey}
    ; Other
    `;::NumpadMult

    ; To work as modifiers when Space pressed
    *LShift::LShift
    *LAlt::LAlt
    ; F-keys
    1::SendWithCorrectModifiers("F1")
    2::SendWithCorrectModifiers("F2")
    3::SendWithCorrectModifiers("F3")
    4::SendWithCorrectModifiers("F4")
    5::SendWithCorrectModifiers("F5")
    6::SendWithCorrectModifiers("F6")
    7::SendWithCorrectModifiers("F7")
    8::SendWithCorrectModifiers("F8")
    9::SendWithCorrectModifiers("F9")
    0::SendWithCorrectModifiers("F10")
    -::SendWithCorrectModifiers("F11")
    =::SendWithCorrectModifiers("F12")
    ; Navigation
    h::SendWithCorrectModifiers("Left")
    j::SendWithCorrectModifiers("Down")
    k::SendWithCorrectModifiers("Up")
    l::SendWithCorrectModifiers("Right")
    [::SendWithCorrectModifiers("PgUp")
    ]::SendWithCorrectModifiers("PgDn")
    ,::SendWithCorrectModifiers("Home")
    .::SendWithCorrectModifiers("End")
#if

; Virtual desktops management
#1::MoveOrGotoDesktopNumberWithIcon(0)
#2::MoveOrGotoDesktopNumberWithIcon(1)
#3::MoveOrGotoDesktopNumberWithIcon(2)
#4::MoveOrGotoDesktopNumberWithIcon(3)
#5::MoveOrGotoDesktopNumberWithIcon(4)
#6::MoveOrGotoDesktopNumberWithIcon(5)
#7::MoveOrGotoDesktopNumberWithIcon(6)
#8::MoveOrGotoDesktopNumberWithIcon(7)

#+1::MoveCurrentWindowToDesktopWithIcon(0)
#+2::MoveCurrentWindowToDesktopWithIcon(1)
#+3::MoveCurrentWindowToDesktopWithIcon(2)
#+4::MoveCurrentWindowToDesktopWithIcon(3)
#+5::MoveCurrentWindowToDesktopWithIcon(4)
#+6::MoveCurrentWindowToDesktopWithIcon(5)
#+7::MoveCurrentWindowToDesktopWithIcon(6)
#+8::MoveCurrentWindowToDesktopWithIcon(7)

