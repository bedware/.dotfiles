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
EnvGet, HOME, UserProfile
SplitPath, A_AhkPath,, AHK_FOLDER

; TODO: Revise all desktop dependencies. Try to make them desktop independent.
apps := {}
; Work
apps["draw"] := { desktop: "Work", selector: "Excalidraw ahk_exe msedge.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Excalidraw.lnk" }
apps["dtr"] := { desktop: "Work", selector: "ahk_exe DeepL.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DeepL.lnk" }
apps["fi"] := { desktop: "Work", selector: "ahk_exe Figma.exe", path: HOME . "\AppData\Local\Figma\app-116.5.18\Figma.exe" }
apps["g"] := { desktop: "Work", selector: "ahk_exe ChatGPT.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ChatGPT\ChatGPT.lnk" }
apps["miro"] := { desktop: "Work", selector: "ahk_exe Miro.exe", path: HOME . "\AppData\Local\RealtimeBoard\Miro.exe" }
apps["post"] := { desktop: "Work", selector: "ahk_exe Postman.exe", path: HOME . "\AppData\Local\Postman\Postman.exe" }
apps["rize"] := { desktop: "Work", selector: "ahk_exe Rize.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Rize.lnk" }
apps["space"] := { desktop: "Work", selector: "ahk_exe spacedeskConsole.exe", path: "C:\Windows\System32\spacedeskConsole.exe" }
apps["steam"] := { desktop: "Work", selector: "ahk_exe Steam.exe", path: "C:\Program Files (x86)\Steam\Steam.exe" }
apps["subl"] := { desktop: "Work", selector: "ahk_exe sublime_text.exe", path: "C:\Program Files\Sublime Text\sublime_text.exe" }
apps["tf"] := { desktop: "Work", selector: "ahk_exe Teamflow.exe", path: HOME . "\AppData\Local\Programs\huddle\Teamflow.exe" }
apps["tr"] := { desktop: "Work", path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
; Personal
apps[".a"] := { desktop: "Personal", selector: "AHK Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""AHK Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\ahk && nvim .""" }
apps[".o"] := { desktop: "Personal", selector: "Oh-my-shell Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Oh-my-shell Settings"" pwsh -c ""nvim $env:LOCALAPPDATA\Programs\oh-my-posh\themes\bedware.omp.json""" }
apps[".t"] := { desktop: "Personal", selector: "Windows Terminal Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Windows Terminal Settings"" pwsh -nop -c ""nvim -p $env:USERPROFILE\.dotfiles\wt\settings.json 'C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.16.10262.0_x64__8wekyb3d8bbwe\defaults.json'""" }
apps[".v"] := { desktop: "Personal", selector: "Neovim Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Neovim Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\nvim && nvim . """ }
apps["idea"] := { desktop: "Personal", selector: "ahk_exe idea64.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
; Terminal
apps["term"] := { desktop: "Terminal", selector: "ahk_exe WindowsTerminal.exe", path: "wt.exe" }
apps["turm"] := { funcName: "runWSL"}
runWSL() {
    Run, wt -p "Ubuntu"
}
; Planner
apps["day"] := { desktop: "Planner", selector: "DayCaptain ahk_exe msedge.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DayCaptain.lnk" }
apps["note"] := { desktop: "Planner", selector: "ahk_exe Notion.exe", path: HOME . "\AppData\Local\Programs\Notion\Notion.exe" }
apps["rize"] := { desktop: "Planner", selector: "ahk_exe Rize.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Rize.lnk" }
apps["map"] := { desktop: "Planner", selector: "FreeMind ahk_exe javaw.exe", path: "C:\Program Files (x86)\FreeMind\FreeMind.exe" }
; Chats
apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: HOME . "\AppData\Local\slack\slack.exe" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: HOME . "\AppData\Roaming\Telegram Desktop\Telegram.exe" }
; Files
apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }

; desktop independent
apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: HOME . "\OneDrive\Soft\DebugView\dbgview64.exe" }
apps["ahelp"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["adoc"] := apps["ahelp"]
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["obs"] := { selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }
; functions
apps["cl"] := { funcName: "RearrangeWindows" }
apps["h"] := { funcName: "FocusOrRunPersonalChromeProfile" }
apps["l"] := { funcName: "FocusOrRunWorkChromeProfile" }
apps["init"] := { funcName: "initRecordingProfile" }

desktops := ["Work", "Personal", "Terminal", "Planner", "Chats", "6", "7", "Files", "9"]

initRecordingProfile() {
    init := {}
    init["Screen share"] := { exe: "duet.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\duet.lnk" }
    init["Camera"] := { exe: "iVCam.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\e2eSoft iVCam\iVCam.lnk" }
    init["OBS"] := { exe: "obs64.exe", path: apps["obs"].path, moveTo: 2, maximize: true, showOnAllDesktops: true }
    init["Task Manager"] := { exe: "Taskmgr.exe", path: "Taskmgr.exe", moveTo: 2, maximize: true, showOnAllDesktops: true }
    ; Run
    for index, app in init {
        if (app.exe and app.path) {
            RunIfProcessNotExist(app.exe, app.path)
        }
        ; Configure
        if (app.moveTo or app.maximize or app.showOnAllDesktops or app.sleepy) {
            selector := "ahk_exe " app.exe

            WinWait, %selector%,, 5
            if WinExist(selector) {
                WinActivate
                if (app.moveTo == 2) {
                    WinMove, 1000, 2800
                }
                if (app.showOnAllDesktops) {
                    WinGet, activeHwnd, ID, A
                    PinWindow(activeHwnd)
                }
                if (app.maximize) {
                    WinMinimize
                    WinMaximize
                }
            }
        }
    }
    ; Post action
    if WinExist("ahk_exe iVCam.exe") {
        WinClose
    }
}

; Dependencies
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/dependencies/toggle_taskbar.ahk
#Include %A_ScriptDir%/dependencies/virtual_desktop.ahk
#Include %A_ScriptDir%/functions.ahk

Init(desktops) ; Must be run before hotkeys & hotstrings

; Use InputLevel so that the script's own hotkeys can be triggered.
#InputLevel 1
; Key remaps
#Include %A_ScriptDir%/remap.ahk

; Set InputLevel 0 to make hotstrings can be triggered by script events
#InputLevel 0
; Hotstrings
#Include %A_ScriptDir%/hotstrings.ahk

