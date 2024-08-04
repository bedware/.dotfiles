$textfield = "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_textfield"
while ($true) {
    . nvim $textfield
    . "c:\Users\dmitr\.dotfiles\win\pwsh\bin\Run-AHK.ps1" @"

#Include C:\Users\dmitr\.dotfiles\win\ahk\utils\windows.ahk
WinGet, WinID, ID, A

hwnd_file := "c:\Users\dmitr\AppData\Local\Temp\in_place_editor_hwnd"
FileDelete, %hwnd_file%
FileAppend, %WinID%, %hwnd_file%, UTF-8

FileRead, content, $textfield
Clipboard := content

WinHide, ahk_id %WinID%
ForceForegroundWinActivate()

Send +{Insert}

"@
}
