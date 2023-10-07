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
SetTitleMatchMode, RegEx

; Constants
EnvGet, HOME, UserProfile
ALOCAL := HOME . "\AppData\Local"
AROAMI := HOME . "\AppData\Roaming"
SplitPath, A_AhkPath,, AHK_FOLDER

desktops := ["Personal", "Work", "Dev", "Planner", "Chats", "Studio", "Translation", "Files", "Other"]
apps := {}
; Personal
apps["steam"] := { desktop: "Personal", selector: "ahk_exe Steam.exe", path: "C:\Program Files (x86)\Steam\Steam.exe" }
; Work
apps["draw"] := { desktop: "Work", selector: "Excalidraw ahk_exe msedge.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\Excalidraw.lnk" }
apps["figma"] := { desktop: "Work", selector: "ahk_exe Figma.exe", path: ALOCAL . "\Figma\app-116.5.18\Figma.exe" }
apps["miro"] := { desktop: "Work", selector: "ahk_exe Miro.exe", path: ALOCAL . "\RealtimeBoard\Miro.exe" }
apps["subl"] := { desktop: "Work", selector: "ahk_exe sublime_text.exe", path: "C:\Program Files\Sublime Text\sublime_text.exe" }
apps["tf"] := { desktop: "Work", selector: "ahk_exe Teamflow.exe", path: ALOCAL . "\Programs\huddle\Teamflow.exe" }
; IDE & Terminal
apps["ide"] := { desktop: "Dev", selector: "ahk_exe idea64.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["jvm"] := { desktop: "Dev", selector: "VisualVM", path: HOME . "\.jdks\visualvm_216\bin\visualvm-my-jdk.lnk" }
apps["jmc"] := { desktop: "Dev", selector: "ahk_exe jmc.exe", path: HOME . "\.jdks\jmc-8.3.1_windows-x64\JDK Mission Control\jmc.exe" }
apps["jkit"] := { desktop: "Dev", selector: "YourKit", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\YourKit Java Profiler 2021.11-b227.lnk" }
apps["post"] := { desktop: "Dev", selector: "ahk_exe Postman.exe", path: ALOCAL . "\Postman\Postman.exe" }
apps["pod"] := { desktop: "Dev", selector: "ahk_exe Podman Desktop.exe", path: ALOCAL . "\Programs\podman-desktop\Podman Desktop.exe" }
; Chats
apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: ALOCAL . "\slack\slack.exe" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: AROAMI . "\Telegram Desktop\Telegram.exe" }
; Planner
apps["day"] := { desktop: "Planner", selector: "Calendar ahk_exe firefox.exe", path: """C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"" https://calendar.google.com" } 
apps["note"] := { desktop: "Planner", selector: "ahk_exe Notion.exe", path: ALOCAL . "\Programs\Notion\Notion.exe" }
apps["map"] := { desktop: "Planner", selector: "FreeMind ahk_exe javaw.exe", path: "C:\Program Files (x86)\FreeMind\FreeMind.exe" }
; Translation
apps["tra"] := { desktop: "Translation", path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
apps["try"] := { desktop: "Translation", selector: "Yandex Translate.*", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Yandex.Translate.lnk" }
apps["trd"] := { desktop: "Translation", selector: "DeepL Translate", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\Chrome Apps\DeepL Translate.lnk" }
; Files
apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
; Other
apps["task"] := { desktop: "Other", selector: "ahk_class TaskManagerWindow", path: "Taskmgr.exe" }
; Studio
apps["obs"] := { desktop: "Studio", selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }

; desktop independent
apps["term"] := { selector: "windows ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --title windows" }
apps["turm"] := { selector: "ubuntu ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --title ubuntu --command wsl -d Ubuntu-22.04 --cd ~" }
apps["quake"] := { selector: "ahk_exe WindowsTerminal.exe", path: "wt.exe -w _quake" }
apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: HOME . "\OneDrive\Soft\DebugView\dbgview64.exe" }
apps["ahelp"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["adoc"] := apps["ahelp"]
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["paint"] := { selector: "ahk_exe mspaint.exe", path: "mspaint.exe" }
apps["pip"] := { selector: "Picture in picture ahk_exe chrome.exe" }

; functions
apps["cl"] := { funcName: "RearrangeWindows" }
apps["h"] := { selector: "ahk_exe chrome.exe", path: ALOCAL . "\Google\Chrome SxS\Application\chrome.exe" }
apps["l"] := { selector: "ahk_exe chrome.exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe" }
apps["pd"] := { funcName: "defaultProfile" }

; hotkeys
apps["1"] := { funcName: "GoToVD", param: 1 }
apps["2"] := { funcName: "GoToVD", param: 2 }
apps["3"] := { funcName: "GoToVD", param: 3 }
apps["4"] := { funcName: "GoToVD", param: 4 }
apps["5"] := { funcName: "GoToVD", param: 5 }
apps["6"] := { funcName: "GoToAlternateVD" }
apps["7"] := { funcName: "GoToVD", param: 7 }
apps["8"] := { funcName: "GoToVD", param: 8 }
apps["9"] := { funcName: "GoToVD", param: 9 }
apps["0"] := { funcName: "GoToVD", param: 6 }

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

