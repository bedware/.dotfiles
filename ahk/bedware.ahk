; By Dmitry Surin aka bedware

; Init System
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
;#KeyHistory 0 ; Ensures user privacy when debugging is not needed
#InstallKeybdHook
#InstallMouseHook
#UseHook
#MaxHotkeysPerInterval 200
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetCapslockState, AlwaysOff

; Constants
EnvGet, UserHome, UserProfile
SplitPath, A_AhkPath,, A_AhkFolder
IconsFolder := "icons"
IconsBlackTheme := "white-on-black"
IconsWhiteTheme := "black-on-white"

desktops := ["Work", "Personal", "Terminal", "Planner", "Chats"]

; For Alfred (My window manager)
apps := {}
apps[".a"] := { desktop: "Personal", selector: "AHK Settings ahk_exe WindowsTerminal.exe", executablePath: "wt new-tab --title ""AHK Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\ahk && nvim .""" }
apps[".o"] := { desktop: "Personal", selector: "Oh-my-shell Settings ahk_exe WindowsTerminal.exe", executablePath: "wt new-tab --title ""Oh-my-shell Settings"" pwsh -c ""nvim $env:LOCALAPPDATA\Programs\oh-my-posh\themes\bedware.omp.json""" }
apps[".t"] := { desktop: "Personal", selector: "Windows Terminal Settings ahk_exe WindowsTerminal.exe", executablePath: "wt new-tab --title ""Windows Terminal Settings"" pwsh -nop -c ""nvim -p $env:USERPROFILE\.dotfiles\wt\settings.json 'C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.16.10262.0_x64__8wekyb3d8bbwe\defaults.json'""" }
apps[".v"] := { desktop: "Personal", selector: "Neovim Settings ahk_exe WindowsTerminal.exe", executablePath: "wt new-tab --title ""Neovim Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\nvim && nvim . """ }
apps["adbg"] := { desktop: "Personal", selector: "ahk_exe dbgview64.exe", executablePath: UserHome . "\OneDrive\Soft\DebugView\dbgview64.exe" }
apps["ahelp"] := { desktop: "Personal", selector: "AutoHotkey Help", executablePath: A_AhkFolder . "\AutoHotkey.chm" }
apps["aspy"] := { selector: "Window Spy", executablePath: A_AhkFolder . "\WindowSpy.ahk" }
apps["cl"] := { funcName: "rearrangeWindows" }
apps["cmd"] := { desktop: "Personal", selector: "ahk_exe TOTALCMD64.EXE", executablePath: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
apps["day"] := { desktop: "Planner", selector: "DayCaptain ahk_exe msedge.exe", executablePath: UserHome . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DayCaptain.lnk" }
apps["rize"] := { desktop: "Planner", selector: "ahk_exe Rize.exe", executablePath: UserHome . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Rize.lnk" }
apps["depl"] := { desktop: "Work", selector: "ahk_exe DeepL.exe", executablePath: UserHome . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DeepL.lnk" }
apps["fi"] := { desktop: "Work", selector: "ahk_exe Figma.exe", executablePath: UserHome . "\AppData\Local\Figma\app-116.5.18\Figma.exe" }
apps["g"] := { desktop: "Work", selector: "ahk_exe ChatGPT.exe", executablePath: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ChatGPT\ChatGPT.lnk" }
apps["h"] := { funcName: "focusOrRunPersonalChromeProfile" }
apps["i"] := { desktop: "Work", selector: "ahk_exe idea64.exe", executablePath: UserHome . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["l"] := { funcName: "focusOrRunWorkChromeProfile" }
apps["miro"] := { desktop: "Work", selector: "ahk_exe Miro.exe", executablePath: UserHome . "\AppData\Local\RealtimeBoard\Miro.exe" }
apps["note"] := { desktop: "Planner", selector: "ahk_exe Notion.exe", executablePath: UserHome . "\AppData\Local\Programs\Notion\Notion.exe" }
apps["obs"] := { desktop: "Work", selector: "ahk_exe obs64.exe", executablePath: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }
apps["post"] := { desktop: "Work", selector: "ahk_exe Postman.exe", executablePath: UserHome . "\AppData\Local\Postman\Postman.exe" }
apps["slack"] := { desktop: "Work", selector: "ahk_exe slack.exe", executablePath: UserHome . "\AppData\Local\slack\slack.exe" }
apps["steam"] := { desktop: "Work", selector: "ahk_exe Steam.exe", executablePath: "C:\Program Files (x86)\Steam\Steam.exe" }
apps["subl"] := { desktop: "Work", selector: "ahk_exe sublime_text.exe", executablePath: "C:\Program Files\Sublime Text\sublime_text.exe" }
apps["term"] := { desktop: "Terminal", selector: "ahk_exe WindowsTerminal.exe", executablePath: "wt.exe" }
apps["tf"] := { desktop: "Work", selector: "ahk_exe Teamflow.exe", executablePath: UserHome . "\AppData\Local\Programs\huddle\Teamflow.exe" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", executablePath: UserHome . "\AppData\Roaming\Telegram Desktop\Telegram.exe" }
apps["tr"] := { desktop: "Work", executablePath: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }

; Dependencies
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/virtual_desktop.ahk
#Include %A_ScriptDir%/functions.ahk

; Init Personal
Init() {
    global desktops
    RemoveAllDesktops()
    for i, v in desktops {
        CreateDesktopByName(v)
    }

    ; Icon
    defaultIcon := % ResolveIconPathDependingOnTheme(GetSystemTheme()) "\+.ico"  
    ChangeTrayIcon(defaultIcon)

    OutputDebug % "Loaded. Admin mode: " A_IsAdmin
}
Init() ; Must be run before hotkeys & hotstrings

; User functions
rearrangeWindows() {
    global apps
    global desktops
    for i, v in apps {
        if (v.desktop != "" && v.selector != "") {
            if (WinExist(v.selector)) {
                WinActivate 
                desktopNum := IndexOf(v.desktop, desktops)
                if (IndexOf(v.desktop, desktops) != -1) {
                    MoveCurrentWindowToDesktop(desktopNum)
                }
            }
        }
    } 
}

focusOrRunWorkChromeProfile() {
    RunIfNotExistChromeProfile("Will", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Default""")
}

focusOrRunPersonalChromeProfile() {
    RunIfNotExistChromeProfile("Power", """C:\Program Files\Google\Chrome\Application\chrome.exe"" --profile-directory=""Profile 4""")
}

; Use InputLevel so that the script's own hotkeys can be triggered.
#InputLevel 1
; Key remaps
#Include %A_ScriptDir%/remap.ahk

; Set InputLevel 0 to make hotstrings can be triggered by script events
#InputLevel 0
; Hotstrings
#Include %A_ScriptDir%/hotstrings.ahk

