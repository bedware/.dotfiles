; Modifiers handling
SendWithCorrectModifiers(key) {
    if (GetKeyState("Shift") and GetKeyState("Ctrl") and GetKeyState("Alt"))
        Send !+^{%key%}
    else if (GetKeyState("Shift") and GetKeyState("Ctrl"))
        Send +^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Ctrl"))
        Send !^{%key%}
    else if (GetKeyState("Alt") and GetKeyState("Shift"))
        Send !+{%key%}
    else if (GetKeyState("Shift"))
        Send +{%key%}
    else if (GetKeyState("Ctrl"))
        Send ^{%key%}
    else if (GetKeyState("Alt"))
        Send !{%key%}
    else
        Send {%key%}
}

; Shifts
ToggleCaps(){
    SetStoreCapsLockMode, Off
    Send {CapsLock}
    SetStoreCapsLockMode, On
    return
}

; Disable keys
RCtrl::return
RAlt::return
Home::F13
End::F14
PgUp::F15
PgDn::F16

; Shift
RShift & Capslock::Send +{Esc}

~*LShift::
    Send {LShift DownR}
    KeyWait, LShift
    Send {LShift Up}
    if (A_PriorKey = "LShift") {
        runAlfred()
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

;Close tab
Tab & Backspace::
    if WinActive("ahk_exe idea64.exe") or WinActive("ahk_exe sublime_text.exe")
        Send ^{F4}
    else ; Default
        Send ^w
return

; Layout set up
Tab & LWin::#z

; Tab-hotkeys
*Tab::Tab
Tab & j::
    if WinActive("ahk_exe idea64.exe")
        Send {Alt Down}{Left}{Alt Up}
    else ; Default
        Send ^+{Tab}
return
Tab & k::
    if WinActive("ahk_exe idea64.exe")
        Send {Alt Down}{Right}{Alt Up}
    else ; Default
        Send ^{Tab}
return
Tab & i:: ; Navigation history backward
    if WinActive("ahk_exe idea64.exe")
        Send {Ctrl Down}{Alt Down}{Left}{Alt Up}{Ctrl Up}
    else ; Default
        Send {Alt Down}{Right}{Alt Up}
return
Tab & o:: ; Navigation history forward
    if WinActive("ahk_exe idea64.exe")
        Send {Ctrl Down}{Alt Down}{Right}{Alt Up}{Ctrl Up}
    else ; Default
        Send {Alt Down}{Left}{Alt Up}
return

; Non-disappearing AltTab + Win
Tab & LAlt::Send ^!{Tab}

; Translate
LCtrl::Send {Ctrl Down}cc{Ctrl Up}

*CapsLock::
if (A_PriorHotkey <> "~*CapsLock" or A_TimeSincePriorHotkey > 300)
{
    Send {Ctrl DownR}
    KeyWait, Capslock
    Send {Ctrl Up}
    if (A_PriorKey = "Capslock") {
        if WinActive("ahk_exe DeepL.exe") or WinActive("ahk_exe Lingvo.exe") {
            WinClose, ahk_exe Lingvo.exe
            WinClose, ahk_exe DeepL.exe
        }
        Send {Esc}
    }
}
;runAlfred() ; double tap goes here
return

; Space
*Space::Space

; Copy & Paste
Space & y::Send ^{Insert}
Space & p::Send +{Insert}
Space & d::Send +{Del}

; Left hand
; qw
Space & q::^q
Space & w::^w
; as
Space & a::^a
; zx
Space & z::^z
Space & x::^x
Space & v::^+m
;Space & v::SendInput {U+2705}

; Undo, Redo, Chrome hotkeys
Space & i:: ; Undo
    if WinActive("ahk_exe chrome.exe")
        Send ^l@history{Space}
    else
        Send ^{z}
return
Space & o:: ; Redo
    if WinActive("ahk_exe chrome.exe")
        Send ^l@tabs{Space}
    if WinActive("ahk_exe idea64.exe")
        Send ^+{z}
    else
        Send ^{y}
return
Space & b:: ; bookmarks 
    if WinActive("ahk_exe chrome.exe")
        Send ^l@bookmarks{Space}
    else
        Send ^{b}
return

; Run
Space & r::
if GetKeyState("Shift")
    Send ^{F2}
else
    Send ^+{F10}
return

; Right hand
Space & Enter::Insert
Space & Backspace::Delete
Space & /::Reload

; Context menu
Space & m::Send {AppsKey}
; Other
Space & `;::NumpadMult

; F-keys
Space & 1::SendWithCorrectModifiers("F1")
Space & 2::SendWithCorrectModifiers("F2")
Space & 3::SendWithCorrectModifiers("F3")
Space & 4::SendWithCorrectModifiers("F4")
Space & 5::SendWithCorrectModifiers("F5")
Space & 6::SendWithCorrectModifiers("F6")
Space & 7::SendWithCorrectModifiers("F7")
Space & 8::SendWithCorrectModifiers("F8")
Space & 9::SendWithCorrectModifiers("F9")
Space & 0::SendWithCorrectModifiers("F10")
Space & -::SendWithCorrectModifiers("F11")
Space & =::SendWithCorrectModifiers("F12")
; Navigation
Space & h::SendWithCorrectModifiers("Left")
Space & j::SendWithCorrectModifiers("Down")
Space & k::SendWithCorrectModifiers("Up")
Space & l::SendWithCorrectModifiers("Right")
Space & [::SendWithCorrectModifiers("PgUp")
Space & ]::SendWithCorrectModifiers("PgDn")
Space & ,::SendWithCorrectModifiers("Home")
Space & .::SendWithCorrectModifiers("End")

; Virtual desktops management
#1::MoveOrGotoDesktopNumberWithIcon(0)
#2::MoveOrGotoDesktopNumberWithIcon(1)
#3::MoveOrGotoDesktopNumberWithIcon(2)
#4::MoveOrGotoDesktopNumberWithIcon(3)
#5::MoveOrGotoDesktopNumberWithIcon(4)

#+1::MoveCurrentWindowToDesktopWithIcon(0)
#+2::MoveCurrentWindowToDesktopWithIcon(1)
#+3::MoveCurrentWindowToDesktopWithIcon(2)
#+4::MoveCurrentWindowToDesktopWithIcon(3)
#+5::MoveCurrentWindowToDesktopWithIcon(4)

