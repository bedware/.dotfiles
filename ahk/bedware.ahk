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
SetTitleMatchMode, 2

; Constants
EnvGet, HOME, UserProfile
SplitPath, A_AhkPath,, AHK_FOLDER

desktops := ["Personal", "Work", "Terminal", "IDE", "Chats", "Planner", "Music", "Files", "Other"]
apps := {}
; Personal
apps["steam"] := { desktop: "Personal", selector: "ahk_exe Steam.exe", path: "C:\Program Files (x86)\Steam\Steam.exe" }
; Work
apps["draw"] := { desktop: "Work", selector: "Excalidraw ahk_exe msedge.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Excalidraw.lnk" }
apps["figma"] := { desktop: "Work", selector: "ahk_exe Figma.exe", path: HOME . "\AppData\Local\Figma\app-116.5.18\Figma.exe" }
; apps["g"] := { desktop: "Work", selector: "ahk_exe ChatGPT.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\ChatGPT\ChatGPT.lnk" }
apps["miro"] := { desktop: "Work", selector: "ahk_exe Miro.exe", path: HOME . "\AppData\Local\RealtimeBoard\Miro.exe" }
apps["post"] := { desktop: "Work", selector: "ahk_exe Postman.exe", path: HOME . "\AppData\Local\Postman\Postman.exe" }
apps["rize"] := { desktop: "Work", selector: "ahk_exe Rize.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Rize.lnk" }
; apps["space"] := { desktop: "Work", selector: "ahk_exe spacedeskConsole.exe", path: "C:\Windows\System32\spacedeskConsole.exe" }
apps["subl"] := { desktop: "Work", selector: "ahk_exe sublime_text.exe", path: "C:\Program Files\Sublime Text\sublime_text.exe" }
apps["tf"] := { desktop: "Work", selector: "ahk_exe Teamflow.exe", path: HOME . "\AppData\Local\Programs\huddle\Teamflow.exe" }
; IDE
apps["idea"] := { desktop: "IDE", selector: "ahk_exe idea64.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["jvm"] := { desktop: "IDE", selector: "VisualVM", path: HOME . "\.jdks\visualvm_216\bin\visualvm-my-jdk.lnk" }
apps["jmc"] := { desktop: "IDE", selector: "ahk_exe jmc.exe", path: HOME . "\.jdks\jmc-8.3.1_windows-x64\JDK Mission Control\jmc.exe" }
apps["jkit"] := { desktop: "IDE", selector: "YourKit", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\YourKit Java Profiler 2021.11-b227.lnk" }
; Terminal
apps["term"] := { desktop: "Terminal", selector: "ahk_exe WindowsTerminal.exe", path: "wt.exe" }
apps["turm"] := { funcName: "runWSL"}
; Chats
apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: HOME . "\AppData\Local\slack\slack.exe" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: HOME . "\AppData\Roaming\Telegram Desktop\Telegram.exe" }
; Planner
apps["day"] := { desktop: "Planner", selector: "DayCaptain ahk_exe firefox.exe", path: """C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"" https://daycaptain.com/week.html" } 
apps["note"] := { desktop: "Planner", selector: "ahk_exe Notion.exe", path: HOME . "\AppData\Local\Programs\Notion\Notion.exe" }
apps["rize"] := { desktop: "Planner", selector: "ahk_exe Rize.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Rize.lnk" }
apps["map"] := { desktop: "Planner", selector: "FreeMind ahk_exe javaw.exe", path: "C:\Program Files (x86)\FreeMind\FreeMind.exe" }
; Music
apps["music"] := { desktop: "Music", selector: "Yandex Music ahk_exe firefox.exe", path: """C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"" https://music.yandex.com/home" } 
; Files
apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
; Other
apps["obs"] := { desktop: "Other", selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }
apps["task"] := { desktop: "Other", selector: "ahk_class TaskManagerWindow", path: "Taskmgr.exe" }

; desktop independent
apps[".a"] := { selector: "AHK Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""AHK Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\ahk && nvim .""" }
apps[".o"] := { selector: "Oh-my-shell Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Oh-my-shell Settings"" pwsh -c ""nvim $env:LOCALAPPDATA\Programs\oh-my-posh\themes\bedware.omp.json""" }
apps[".t"] := { selector: "Windows Terminal Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Windows Terminal Settings"" pwsh -nop -c ""nvim -p $env:USERPROFILE\.dotfiles\wt\settings.json 'C:\Program Files\WindowsApps\Microsoft.WindowsTerminal_1.16.10262.0_x64__8wekyb3d8bbwe\defaults.json'""" }
apps[".v"] := { selector: "Neovim Settings ahk_exe WindowsTerminal.exe", path: "wt new-tab --title ""Neovim Settings"" pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles\nvim && nvim . """ }
apps["tr"] := { path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
apps["ytr"] := { selector: "ahk_exe firefox.exe", path: """C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"" https://translate.yandex.ru" } 
apps["dtr"] := { selector: "ahk_exe DeepL.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\DeepL.lnk" }
apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: HOME . "\OneDrive\Soft\DebugView\dbgview64.exe" }
apps["ahelp"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["adoc"] := apps["ahelp"]
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["paint"] := { selector: "ahk_exe mspaint.exe", path: "mspaint.exe" }

; functions
apps["cl"] := { funcName: "RearrangeWindows" }
apps["h"] := { funcName: "FocusOrRunPersonalChromeProfile" }
apps["l"] := { funcName: "FocusOrRunWorkChromeProfile" }
apps["psc"] := { funcName: "screencastProfile" }

; Dependencies
#Include %A_ScriptDir%/utils.ahk
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/chrome.ahk
#Include %A_ScriptDir%/dependencies/toggle_taskbar.ahk
#Include %A_ScriptDir%/dependencies/virtual_desktop.ahk
#Include %A_ScriptDir%/moving_around.ahk
#Include %A_ScriptDir%/user_functions.ahk

Init(desktops) ; Must be run before hotkeys & hotstrings

; Use InputLevel so that the script's own hotkeys can be triggered.
#InputLevel 1
; Key remaps
#Include %A_ScriptDir%/remap.ahk

; Set InputLevel 0 to make hotstrings can be triggered by script events
#InputLevel 0
; Hotstrings
#Include %A_ScriptDir%/hotstrings.ahk

