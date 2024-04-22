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
SplitPath, A_AhkPath,, AHK_FOLDER

desktops := ["Browsing", "Dev", "Chats", "Office", "Creator", "Stream", "English", "Files", "Other"]
apps := {}

apps["adbg"] := { selector: "ahk_exe dbgview64.exe", path: "G:\My Drive\Soft\DebugView\dbgview64.exe" }
apps["adoc"] := { selector: "AutoHotkey Help", path: AHK_FOLDER . "\AutoHotkey.chm" }
apps["anki"] := { desktop: "Office", selector: "ahk_exe anki.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Anki.lnk" }
apps["aspy"] := { selector: "Window Spy", path: AHK_FOLDER . "\WindowSpy.ahk" }
apps["book"] := { desktop: "Office", selector: "ahk_exe calibre.exe", path: "C:\Program Files\Calibre2\calibre.exe" }
apps["cal"] := { desktop: "Office", selector: "DayCaptain ahk_exe msedge.exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --start-maximized --app=https://daycaptain.com" }
apps["cmd"] := { desktop: "Files", selector: "ahk_exe TOTALCMD64.EXE", path: "C:\Program Files\totalcmd\TOTALCMD64.EXE" }
apps["code"] := { desktop: "Dev", selector: "ubuntu ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --config-file " . HOME . "\.dotfiles\all\alacritty\alacritty-work-profile.yml" .  " --title ubuntu --command wsl -d Ubuntu-22.04 --cd ~", postFunction: "makeAnyWindowFullscreen"}
apps["db"] := { desktop: "Dev", selector: "ahk_exe datagrip64.exe", path: "C:\Program Files\JetBrains\DataGrip 2019.1.4\bin\datagrip64.exe" }
apps["dev"] := { desktop: "Browsing", selector: "^DevTools ahk_exe chrome.exe" }
apps["disc"] := { desktop: "Chats", selector: "ahk_exe Discord.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk" }
apps["draw"] := { desktop: "Creator", selector: "Excalidraw ahk_exe msedge.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Excalidraw.lnk" }
apps["vedit"] := { desktop: "Creator", selector: "ahk_exe CapCut.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\CapCut\CapCut.lnk" }
apps["duet"] := { selector: "ahk_exe duet.exe", path: "C:\Program Files\Kairos\Duet Display\duet.exe" }
apps["figma"] := { desktop: "Creator", selector: "ahk_exe Figma.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Figma.lnk" }
apps["fire"] := { desktop: "Browsing", selector: "ahk_exe firefox.exe", path: "C:\Program Files\Mozilla Firefox\firefox.exe" }
apps["idea"] := { desktop: "Dev", selector: "ahk_exe idea64.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk" }
apps["jkit"] := { desktop: "Dev", selector: "YourKit", path: "C:\Program Files\YourKit Java Profiler 2021.11-b227\bin\profiler.exe" }
apps["jmc"] := { desktop: "Dev", selector: "ahk_exe jmc.exe", path: HOME . "\.jdks\jmc-8.3.1_windows-x64\JDK Mission Control\jmc.exe" }
apps["jvm"] := { desktop: "Dev", selector: "VisualVM", path: HOME . "\.jdks\visualvm_216\bin\visualvm-my-jdk.lnk" }
apps["keys"] := { selector: "ahk_exe Carnac.exe", path: "C:\Users\dmitr\AppData\Local\carnac\Carnac.exe" }
apps["lon"] := { selector: "ahk_exe LonelyScreen.exe", path: "g:\My Drive\Soft\LonelyScreen.exe" }
apps["mail"] := { desktop: "Office", selector: "ahk_exe Spark Desktop.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Spark Desktop.lnk" }
apps["music"] := { desktop: "Other", selector: "ahk_exe Яндекс Музыка.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Яндекс Музыка.lnk", postFunction: "makeAnyWindowMaximized" }
apps["note"] := { desktop: "Office", selector: "ahk_exe Notion.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Notion.lnk", postFunction: "makeAnyWindowMaximized" }
apps["obs"] := { desktop: "Stream", selector: "ahk_exe obs64.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OBS Studio\OBS Studio (64bit).lnk" }
apps["paint"] := { selector: "ahk_exe mspaint.exe", path: "mspaint.exe" }
apps["pdf"] := { desktop: "Files", selector: "ahk_exe SumatraPDF.exe", path: "C:\Users\dmitr\AppData\Local\SumatraPDF\SumatraPDF.exe" }
apps["pip"] := { selector: "Picture in picture ahk_exe chrome.exe" }
apps["pod"] := { desktop: "Dev", selector: "ahk_exe Podman Desktop.exe", path: "C:\Users\dmitr\AppData\Local\Programs\podman-desktop\Podman Desktop.exe" }
apps["post"] := { desktop: "Dev", selector: "ahk_exe Postman.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Postman\Postman.lnk" }
apps["quake"] := { selector: "ahk_exe WindowsTerminal.exe", path: "wt.exe -w _quake" }
apps["slack"] := { desktop: "Chats", selector: "ahk_exe slack.exe", path: "C:\Users\dmitr\AppData\Local\slack\slack.exe" }
apps["steam"] := { desktop: "Browsing", selector: "ahk_exe steamwebhelper.exe", path: "C:\Program Files (x86)\Steam\Steam.exe" }
apps["task"] := { desktop: "Other", selector: "ahk_class TaskManagerWindow", path: "Taskmgr.exe", postFunction: "makeAnyWindowMaximized" }
apps["td"] := { desktop: "Dev", selector: "^Developer Tools ahk_exe Cypress.exe" }
apps["term"] := { desktop: "Dev", selector: "windows ahk_exe alacritty.exe", path: """C:\Program Files\Alacritty\alacritty.exe"" --title windows", postFunction: "makeAnyWindowFullscreen" }
apps["tg"] := { desktop: "Chats", selector: "ahk_exe Telegram.exe", path: "\Telegram Desktop\Telegram.exe" }
apps["tra"] := { desktop: "English", path: "C:\Program Files (x86)\ABBYY Lingvo x6\Lingvo.exe" }
apps["trd"] := { desktop: "English", selector: "DeepL Translate ahk_exe msedge.exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --start-maximized --app=https://www.deepl.com/translator#ru/en/" }
apps["try"] := { desktop: "English", selector: "Yandex Translate.* ahk_exe msedge.exe", path: "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe --app=https://translate.yandex.com/en/" }
apps["tt"] := { desktop: "Dev", selector: "^(?!Developer Tools|Cypress) ahk_exe Cypress.exe" }
apps["web"] := { desktop: "Browsing", selector: "^(?!DevTools) ahk_exe chrome.exe", path: "C:\Users\dmitr\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps\Chrome.lnk" }

; different
apps["sw"] := { postFunction: "startWork" }

; Dependencies
#Include %A_ScriptDir%/utils.ahk
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/chrome.ahk
#Include %A_ScriptDir%/dependencies/virtual-desktop.ahk
#Include %A_ScriptDir%/moving-around.ahk
#Include %A_ScriptDir%/user-functions.ahk

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
