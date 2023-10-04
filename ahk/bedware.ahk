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
SplitPath, A_AhkPath,, AHK_FOLDER

desktops := ["Personal", "Work", "Dev", "Planner", "Chats", "Studio", "Translation", "Files", "Other"]
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
; IDE & Terminal
apps["idea"] := { desktop: "Dev", selector: "ahk_exe idea64.exe", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["jvm"] := { desktop: "Dev", selector: "VisualVM", path: HOME . "\.jdks\visualvm_216\bin\visualvm-my-jdk.lnk" }
apps["jmc"] := { desktop: "Dev", selector: "ahk_exe jmc.exe", path: HOME . "\.jdks\jmc-8.3.1_windows-x64\JDK Mission Control\jmc.exe" }
apps["jkit"] := { desktop: "Dev", selector: "YourKit", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\YourKit Java Profiler 2021.11-b227.lnk" }
apps["term"] := { desktop: "Dev", selector: "(Admin:)|(C:) ahk_exe WindowsTerminal.exe", path: "wt --fullscreen" }
apps["turm"] := { desktop: "Dev", selector: "^(?!Admin).* ahk_exe WindowsTerminal.exe", path: "wt --fullscreen --profile Ubuntu" }
; Chats
apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: HOME . "\AppData\Local\slack\slack.exe" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: HOME . "\AppData\Roaming\Telegram Desktop\Telegram.exe" }
; Planner
apps["day"] := { desktop: "Planner", selector: "Calendar ahk_exe firefox.exe", path: """C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Firefox.lnk"" https://calendar.google.com" } 
apps["note"] := { desktop: "Planner", selector: "ahk_exe Notion.exe", path: HOME . "\AppData\Local\Programs\Notion\Notion.exe" }
apps["map"] := { desktop: "Planner", selector: "FreeMind ahk_exe javaw.exe", path: "C:\Program Files (x86)\FreeMind\FreeMind.exe" }
; Translation
apps["atr"] := { desktop: "Translation", path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
apps["ytr"] := { desktop: "Translation", selector: "Yandex Translate.*", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Yandex.Translate.lnk" }
apps["dtr"] := { desktop: "Translation", selector: "DeepL Translate", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\DeepL Translate.lnk" }
; apps["tr"] := { funcName: "doTranslation" }
; Files
apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
; Other
apps["task"] := { desktop: "Other", selector: "ahk_class TaskManagerWindow", path: "Taskmgr.exe" }
; Studio
apps["obs"] := { desktop: "Studio", selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }
apps["music"] := { desktop: "Studio", selector: "Yandex.Music", path: HOME . "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Yandex.Music.lnk" } 

; desktop independent
apps[".f"] := { selector: "ahk_exe WindowsTerminal.exe", path: "wt --fullscreen new-tab pwsh -nop -c ""Set-Location $env:USERPROFILE\.dotfiles && nvim .""" }
apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: HOME . "\OneDrive\Soft\DebugView\dbgview64.exe" }
apps["ahelp"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["adoc"] := apps["ahelp"]
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["paint"] := { selector: "ahk_exe mspaint.exe", path: "mspaint.exe" }

; functions
apps["cl"] := { funcName: "RearrangeWindows" }
apps["h"] := { funcName: "FocusOrRunPersonalChromeProfile" }
apps["l"] := { funcName: "FocusOrRunWorkChromeProfile" }
apps["pd"] := { funcName: "defaultProfile" }
apps["psc"] := { funcName: "screencastProfile" }

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

