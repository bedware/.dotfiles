; Directives
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
#InstallKeybdHook
#InstallMouseHook
#UseHook
#MaxHotkeysPerInterval 200
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory
SendMode Input ; Recommended for new scripts due to its superior speed and reliability
SetTitleMatchMode, RegEx ; Write selectors using regexp

EnvGet, home, USERPROFILE

; Dependencies
#Include %A_ScriptDir%/dependencies/JSON.ahk
#Include %A_ScriptDir%/dependencies/VirtualDesktopAccessor.ahk

; Read config
FileRead, tmp, %A_ScriptDir%/config/desktops.json
desktops := JSON.Load(tmp)
FileRead, tmp, %A_ScriptDir%/config/actions.json
apps := JSON.Load(tmp)
FileRead, tmp, %A_ScriptDir%/config/context_commands.json
commands := JSON.Load(tmp)

; Modules
#Include %A_ScriptDir%/utils/__init__.ahk
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/user-functions.ahk

InitDesktops(desktops) ; Must be run before hotkeys & hotstrings

; Globals
HOTKEYS_ON := true
CONTEXT_HOTKEYS_ON := true

isNeedToCancel := false
HYPER_PRESSED := false

; Popups windows settings
#Include %A_ScriptDir%/utils/popup.ahk

; Use InputLevel so that the script's own hotkeys can be triggered.
#InputLevel 1
; Key remaps
#Include %A_ScriptDir%/remap/__init__.ahk
; Set InputLevel 0 to make hotstrings can be triggered by script events
#InputLevel 0

; Hotstrings
#Hotstring ? ; Make it work inside a word
#Hotstring EndChars -()[]{}`n `t
#Include %A_ScriptDir%/hotstrings.ahk
#Include %A_ScriptDir%/dont-include.ahk

