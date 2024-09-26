Write-Host "Alfa"

Start-Job -ScriptBlock {
& "C:\Program Files\Alacritty\alacritty.exe" `
    --config-file "C:\Users\dmitr\.dotfiles\all\alacritty\alacritty-work-profile.yml" `
    --title "ubuntu" `
    --command "wsl" `
    -d "Ubuntu-22.04" `
    --cd "~/.dotfiles" `
    -- "Open-TmuxWorkSession alfa"

. "C:/Users/dmitr/.dotfiles/win/pwsh/bin/Run-AHK.ps1" @'
#Include C:\Users\dmitr\.dotfiles\win\ahk\utils\windows.ahk
WinWait, ubuntu ahk_class Window Class ahk_exe alacritty.exe,, 5
WinActivate, ubuntu ahk_class Window Class ahk_exe alacritty.exe
makeAnyWindowCenteredThenMaximized()
'@
}

Get-Job | Wait-Job
# $pass = Read-Host -Prompt "Enter to continue" -MaskInput
