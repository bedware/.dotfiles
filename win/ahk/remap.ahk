isNeedToCancel := false
*~RButton::
*~MButton::
*~LButton::
    if (GetKeyState("Capslock", "P")) {
        isNeedToCancel := true
    }
return
*WheelDown::
    if (GetKeyState("RButton", "P")) {
        Send {RButton Up}
        Send +{WheelDown}
    } else {
        Send {WheelDown}
    }
return 
*WheelUp::
    if (GetKeyState("RButton", "P")) {
        Send {RButton Up}
        Send +{WheelUp}
    } else {
        Send {WheelUp}
    }
return 
RButton & LButton::GoToAlternateVD()
LButton & RButton::Func("doTranslation").Call()

; Left finger
Home::F19 ; Start/stop recording
End::F17 ; Pause/unpause

; Right finger
PgUp::F20
PgDn::F18

; Pedal
; +F21::Run, "g:\My Drive\Keyboard\Layer 1.png"
; F21::^+a

; it is for neovim's harpoon
; ^;::^F5
; ^'::^F6

; Use the Soundcard Analysis script found here to set these parameters
; https://www.autohotkey.com/docs/commands/SoundSet.htm#Soundcard
; Volume_Up::
;     scSpeakers := 2
;     scHeadphones := 4
;     SoundSet, +2, Master, Volume, %scSpeakers%
;     SoundSet, +2, Master, Volume, %scHeadphones%
; return
; Volume_Down::
;     scSpeakers := 2
;     scHeadphones := 4
;     SoundSet, -2, Master, Volume, %scSpeakers%
;     SoundSet, -2, Master, Volume, %scHeadphones%
; return

; !^f::makeAnyWindowFullscreen()

; !^;::
;     WinMove, A, , -10, -100, 2180, 1325
; return

#b::
    Send #a
    Sleep 800
    Send {Right}
    Send {Tab}
    Send {Enter}
    Sleep 800
    Send {Tab}
return

#`:: ; Quake alive
    if (!ProcessExist("WindowsTerminal.exe")) {
        Run, wt.exe -w _quake new-tab --title .dotfiles -d "C:/Users/dmitr/.dotfiles/" -- nvim .
        WinWait, ahk_exe WindowsTerminal.exe,, 5
        WinActivate
        Sleep 300
        Send ^{F12}
        Sleep 20
        Run, wt --window _quake new-tab --title AutoHotkey -d "C:/Users/dmitr/.dotfiles/win/ahk/" -- nvim .
        Sleep 20
        Run, wt --window _quake new-tab --title Neovim -d "C:/Users/dmitr/.dotfiles/wsl/nvim/.config/nvim/" -- nvim .
        Sleep 20
        Run, wt --window _quake new-tab --title Console -d "C:/Users/dmitr/"
        Run, wt --window _quake focus-tab -t 3
    } else {
        Send #``
    }
return

#Enter::
    Run wt
    WinWait, "Administrator: PowerShell ahk_exe WindowsTerminal.exe",, 3
return
#Space::
    global apps
    GoToAlternateApp(apps)
return

LShift & RShift::ToggleRaceMode()
RShift & LShift::ToggleRaceMode()
RShift & Capslock::Send +{Esc}

LCtrl::LCtrl ; to enable hook

raceMode := false
#if !raceMode && GetKeyState("LShift", "P")
    LShift up::
        global apps
        if (A_PriorKey = "LShift") {
            RunAlfred(apps)
        }
    return 
#if

; #if !raceMode && GetKeyState("RShift", "P")
;     RShift up::
;         global apps
;         if (A_PriorKey = "RShift") {
;             GoToAlternateApp(apps)
;         }
;     return 
; #if

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

#if !raceMode
    ; ~*RShift::
    ;     Send {RShift DownR}
    ;     KeyWait, RShift
    ;     Send {RShift Up}
    ;     if (A_PriorKey = "RShift") {
    ;         Send #{Space}
    ;     }
    ; return 
    *CapsLock::
        SendEvent {Ctrl DownR}
        KeyWait, Capslock
        SendEvent {Ctrl Up}
        if (A_PriorKey = "Capslock") {
            if WinExist("ahk_exe DeepL.exe") and WinExist("ahk_exe Lingvo.exe") or WinExist("ahk_exe DeepL.exe") {
                WinClose, ahk_exe Lingvo.exe
                WinClose, ahk_exe DeepL.exe
            }
            if (WinActive("ahk_exe PowerToys.Peek.UI.exe")) {
                WinClose, ahk_exe PowerToys.Peek.UI.exe
            }
            if (!isNeedToCancel) {
                Send {Esc}
            }
            isNeedToCancel := false
        }
    return

    *Space::
        KeyWait, Space
        if (A_ThisHotkey = "*Space" and A_PriorKey = "Space") {
            if (WinActive("ahk_exe explorer.exe")) {
                Send ^{Space}
                return
            }
            SendEvent {Blind}{Space}
        }
    return
#if 

#if !raceMode && GetKeyState("Space", "P")
    Tab::
        global apps
        GoToAlternateApp(apps)
        ; if (A_PriorKey = "RShift") {
        ; }
        ; Send {Alt down}{Tab}
        ; Send {Alt up}
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
    a::^+a
    ; zxcv
    z::^z
    x::^x
    c::^c
    v::^+m ; Select mode (vi-mode) in wt
    ;v::SendInput {U+2705}

    ; Right hand
    Enter::Insert
    /::
        Reload
    return

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

    ; For browser
    f::
        Send ^l ; Search in history
        Sleep 50
        Send @{Down} ; Search in history
    return
#if

#if WinActive("ahk_exe chatgpt.exe")
    ^s::Send ^+s
    ^n::Send ^+o
    ^i::Send ^+i
    ^r::Send ^+c
    ^e::Send ^+;
    ^x::Send ^+{BackSpace}
    CapsLock Up::
        if (A_PriorKey = "Capslock") {
            HideAppToTray()
        }
    return
#if
#if WinActive("ahk_exe explorer.exe")
    !1::Send ^+6
    !2::Send ^+2
#if
#if WinActive("ahk_exe chrome.exe")
    or WinActive("ahk_exe msedge.exe")
    or WinActive("ahk_exe firefox.exe")
    or WinActive("ahk_exe Cypress.exe")
    ^g::Send ^+{a} ; Search in tabs popup
    ^s::Send ^+{p}
    ^i::Send !{Right} ; Navigation history forward 
    ^o::Send !{Left} ; Navigation history backward
    ^6::
        Send ^+a
        Sleep 150
        Send {Enter}
    return
    !g::
        Send {F6}{F6}
        Sleep 250
        Send {AppsKey}aa{Enter}
    return
#if

#if WinActive("Excalidraw Plus ahk_exe chrome.exe")
    *RButton::MButton
    *MButton::RButton
    *WheelDown::
        if (GetKeyState("RButton", "P")) {
            Send ^{-}
        } else {
            Send {WheelDown}
        }
    return
    *WheelUp::
        if (GetKeyState("RButton", "P")) {
            Send ^{+}
        } else {
            Send {WheelUp}
        }
    return
#if

#if WinActive("ahk_exe TOTALCMD64.EXE")
    !e::Send {Home}{F2} ; Edit path
    !p::Send ^{F12} ; Copy path to selected file
#if

#if WinActive("ahk_exe Telegram.exe")
    ^u::Send ^+{Up}
    ^d::Send ^+{Down}
    !j::Send !{Down}
    !k::Send !{Up}
    ^j::
        if (GetKeyState("Space", "P")) {
            Send ^{Down}
        } else {
            Send ^+{Down}
        }
    return
    ^k::
        if (GetKeyState("Space", "P")) {
            Send ^{Up}
        } else {
            Send ^+{Up}
        }
    return
#if

#if WinActive("ahk_exe Notion.exe")
    ^o::^[
    ^i::^]
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

; Win-hotkeys

; ChatGpt
#g::
    global apps
    if (WinActive(apps["gpt"].selector))
        HideAppToTray()
    else
        executeInput(apps, "gpt")
return

; Show active window on all virtual desktops (VD)
#^t:: 
    WS_EX_TOOLWINDOW := 0x00000080
    WinSet, ExStyle, ^%WS_EX_TOOLWINDOW%, A
    PlayErrorSound()
return

; Quit
#q::Send !{F4}

; Virtual desktops management
#1::GoToVD(1)
#2::GoToVD(2)
#3::GoToVD(3)
#4::GoToVD(4)
#5::GoToVD(5)
#6::GoToAlternateVD()
#7::GoToVD(7)
#8::GoToVD(8)
#9::GoToVD(9)
#0::GoToVD(6)

#+1::MoveActiveWinAndGoToVD(1)
#+2::MoveActiveWinAndGoToVD(2)
#+3::MoveActiveWinAndGoToVD(3)
#+4::MoveActiveWinAndGoToVD(4)
#+5::MoveActiveWinAndGoToVD(5)
#+7::MoveActiveWinAndGoToVD(7)
#+8::MoveActiveWinAndGoToVD(8)
#+9::MoveActiveWinAndGoToVD(9)
#+0::MoveActiveWinAndGoToVD(6)

; #w::
;     global apps
;     executeInput(apps, "web")
; return
;
; #h::
;     global apps
;     executeInput(apps, "turm")
; return
;
; #j::
;     global apps
;     executeInput(apps, "db")
; return
;
; #k::
;     global apps
;     executeInput(apps, "post")
; return
;
; #l::
;     global apps
;     RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 1
;     executeInput(apps, "tt")
;     RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0
; return

