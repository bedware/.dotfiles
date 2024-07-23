; Notebook keys
Home::F19 ; Start/stop recording
End::F17 ; Pause/unpause
PgUp::F20
PgDn::F18

LCtrl::LCtrl ; to enable hook


; Mouse


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


; Shifts + RaceMode


RShift & Capslock::Send +{Esc}

LShift & RShift::ToggleRaceMode()
RShift & LShift::ToggleRaceMode()

#if !raceMode
    LShift up::
        global apps
        if (A_PriorKey = "LShift") {
            RunAlfred(apps)
        }
    return 

    RShift up::
        global apps
        if (A_PriorKey = "RShift") {
            GoToAlternateApp(apps)
            ; MsgBox, "Context dependent stuff!"
        }
    return 

    *CapsLock::
        global isNeedToCancel 

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
            SendEvent {Blind}{Space}
        }
    return
#if 

#if !raceMode && GetKeyState("Space", "P")
    ; Copy & Paste
    y::Send ^{Insert}
    p::Send +{Insert}
    d::Send +{Del}

    v::^+m ; Select mode (vi-mode) in wt
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


; Tab


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


; Win-key hotkeys


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

; Toggle to show active window on all virtual desktops (VD)
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

