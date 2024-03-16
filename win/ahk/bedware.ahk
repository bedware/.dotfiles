#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
;#KeyHistory 0 ; Ensures user privacy when debugging is not needed
#InstallKeybdHook
#InstallMouseHook
#UseHook
#MaxHotkeysPerInterval 200
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
; SetCapslockState, AlwaysOff
SetTitleMatchMode, RegEx ; Write selectors using regexp

; Constants
EnvGet, HOME, UserProfile
ALOCAL := HOME . "\AppData\Local"
AROAMI := HOME . "\AppData\Roaming"
SplitPath, A_AhkPath,, AHK_FOLDER

desktops := ["Browsing", "Dev", "Chats", "Office", "Creator", "Stream", "English", "Files", "Other"]
apps := {}
apps["bro"] := { desktop: "Browsing", selector: "^(?!DevTools) ahk_exe chrome.exe", path: "C:\Program Files\Google\Chrome\Application\chrome.exe" }
apps["dev"] := { desktop: "Browsing", selector: "^DevTools ahk_exe chrome.exe" }
apps["steam"] := { desktop: "Browsing", selector: "ahk_exe steamwebhelper.exe", path: "C:\Program Files (x86)\Steam\Steam.exe" }
apps["fire"] := { desktop: "Browsing", selector: "ahk_exe firefox.exe", path: "C:\Program Files\Mozilla Firefox\firefox.exe" }
apps["pip"] := { selector: "Picture in picture ahk_exe chrome.exe" }

apps["post"] := { desktop: "Dev", selector: "ahk_exe Postman.exe", path: ALOCAL . "\Postman\Postman.exe" }
apps["db"] := { desktop: "Dev", selector: "ahk_exe datagrip64.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\DataGrip Release.lnk" }
apps["idea"] := { desktop: "Dev", selector: "ahk_exe idea64.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["jkit"] := { desktop: "Dev", selector: "YourKit", path: "C:\Program Files\YourKit Java Profiler 2021.11-b227\bin\profiler.exe" }
apps["jmc"] := { desktop: "Dev", selector: "ahk_exe jmc.exe", path: HOME . "\.jdks\jmc-8.3.1_windows-x64\JDK Mission Control\jmc.exe" }
apps["jvm"] := { desktop: "Dev", selector: "VisualVM", path: HOME . "\.jdks\visualvm_216\bin\visualvm-my-jdk.lnk" }
apps["pod"] := { desktop: "Dev", selector: "ahk_exe Podman Desktop.exe", path: ALOCAL . "\Programs\podman-desktop\Podman Desktop.exe" }
apps["term"] := { desktop: "Dev", selector: "windows ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --title windows", postFunction: "makeAnyWindowFullscreen" }
apps["turm"] := { desktop: "Dev", selector: "ubuntu ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --config-file " . HOME . "\.dotfiles\all\alacritty\alacritty-work-profile.yml" .  " --title ubuntu --command wsl -d Ubuntu-22.04 --cd ~", postFunction: "makeAnyWindowFullscreen"}
apps["adoc"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: "G:\My Drive\Soft\DebugView\dbgview64.exe" }
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["quake"] := { selector: "ahk_exe WindowsTerminal.exe", path: "wt.exe -w _quake" }

apps["draw"] := { desktop: "Creator", selector: "Excalidraw ahk_exe msedge.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\Excalidraw.lnk" }
apps["figma"] := { desktop: "Creator", selector: "ahk_exe Figma.exe", path: ALOCAL . "\Figma\app-116.5.18\Figma.exe" }
apps["miro"] := { desktop: "Creator", selector: "ahk_exe Miro.exe", path: ALOCAL . "\RealtimeBoard\Miro.exe" }
apps["paint"] := { selector: "ahk_exe mspaint.exe", path: "mspaint.exe" }

apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: ALOCAL . "\slack\slack.exe" }
apps["disc"] := { desktop: "Chats", selector: "ahk_exe Discord.exe", path: AROAMI . "\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: AROAMI . "\Telegram Desktop\Telegram.exe" }
apps["tf"] := { desktop: "Chats", selector: "ahk_exe Teamflow.exe", path: ALOCAL . "\Programs\huddle\Teamflow.exe" }

apps["cal"] := { desktop: "Office", selector: "ahk_exe Notion Calendar.exe", path: "C:\Users\dmitr\AppData\Local\Programs\cron-web\Notion Calendar.exe", postFunction: "makeAnyWindowMaximized" }  
apps["mail"] := { desktop: "Office", selector: "ahk_exe Spark Desktop.exe", path: ALOCAL . "\Programs\SparkDesktop\Spark Desktop.exe", postFunction: "makeAnyWindowMaximized" } 
apps["note"] := { desktop: "Office", selector: "ahk_exe Notion.exe", path: ALOCAL . "\Programs\Notion\Notion.exe", postFunction: "makeAnyWindowMaximized" }
apps["book"] := { desktop: "Office", selector: "ahk_exe calibre.exe", path: "C:\Program Files\Calibre2\calibre.exe" }

apps["tra"] := { desktop: "English", path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
apps["trd"] := { desktop: "English", selector: "DeepL Translate ahk_exe msedge.exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --app=https://www.deepl.com/translator#ru/en/", postFunction: "makeAnyWindowMaximized" }
apps["try"] := { desktop: "English", selector: "Yandex Translate.* ahk_exe msedge.exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --app=https://translate.yandex.com/en/" }

apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
apps["pdf"] := { desktop: "Files", selector: "ahk_exe SumatraPDF.exe", path: ALOCAL . "\SumatraPDF\SumatraPDF.exe" }

apps["obs"] := { desktop: "Stream", selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Stream\OBS Stream (64bit).lnk" }
apps["keys"] := { selector: "ahk_exe Carnac.exe", path: ALOCAL . "\carnac\Carnac.exe" }

apps["task"] := { desktop: "Other", selector: "ahk_class TaskManagerWindow", path: "Taskmgr.exe", postFunction: "makeAnyWindowMaximized" }
apps["mus"] := { desktop: "Other", selector: "ahk_exe YandexMusic.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\YandexMusic.lnk", postFunction: "makeAnyWindowMaximized" }
apps["duet"] := { selector: "ahk_exe duet.exe", path: "C:\Program Files\Kairos\Duet Display\duet.exe" }

; functions
apps[" pd"] := { postFunction: "defaultProfile" }
apps[" ps"] := { postFunction: "screencastProfile" }

; VD navigation for alfred
apps["1"] := { postFunction: "GoToVD", postFunctionParam: 1 }
apps["2"] := { postFunction: "GoToVD", postFunctionParam: 2 }
apps["3"] := { postFunction: "GoToVD", postFunctionParam: 3 }
apps["4"] := { postFunction: "GoToVD", postFunctionParam: 4 }
apps["5"] := { postFunction: "GoToVD", postFunctionParam: 5 }
apps["6"] := { postFunction: "GoToAlternateVD" }
apps["7"] := { postFunction: "GoToVD", postFunctionParam: 7 }
apps["8"] := { postFunction: "GoToVD", postFunctionParam: 8 }
apps["9"] := { postFunction: "GoToVD", postFunctionParam: 9 }
apps["0"] := { postFunction: "GoToVD", postFunctionParam: 6 }

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
#Hotstring ? ; Make it work inside a word
#Hotstring EndChars -()[]{}`n `t
#Include %A_ScriptDir%/hotstrings.ahk

