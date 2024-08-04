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

