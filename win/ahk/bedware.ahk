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

; Imports
#Include %A_ScriptDir%/JSON.ahk

; Read config
FileRead, tmp, %A_ScriptDir%/actions.json 
config := JSON.Load(tmp)
desktops := config["desktops"]
apps := config["apps"]

; Dependencies
#Include %A_ScriptDir%/utils.ahk
#Include %A_ScriptDir%/alfred.ahk
#Include %A_ScriptDir%/chrome.ahk
#Include %A_ScriptDir%/dependencies/virtual-desktop.ahk
#Include %A_ScriptDir%/vd-moving-around.ahk
#Include %A_ScriptDir%/user-functions.ahk

Init(desktops) ; Must be run before hotkeys & hotstrings

; Use InputLevel so that the script's own hotkeys can be triggered.
#InputLevel 1
; Key remaps
#Include %A_ScriptDir%/remap.ahk
#Include %A_ScriptDir%/remap/chrome-devtools.ahk
; Set InputLevel 0 to make hotstrings can be triggered by script events
#InputLevel 0

; Hotstrings
; #Hotstring ? ; Make it work inside a word
#Hotstring EndChars -()[]{}`n `t
#Include %A_ScriptDir%/hotstrings.ahk

