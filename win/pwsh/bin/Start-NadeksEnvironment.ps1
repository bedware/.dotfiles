Write-Host "Nadeks"
Invoke-Expression "podman info"

$counter = 0
while ($LASTEXITCODE -ne 0 -and $counter -lt 30) {
    if ($counter -eq 0) {
        Start-Process -FilePath "C:\Users\dmitr\AppData\Local\Programs\podman-desktop\Podman Desktop.exe" &
    }
    Invoke-Expression "podman info"
    $counter += 1
    Start-Sleep -Seconds 1
}

if ($LASTEXITCODE -ne 0) {
    exit
}

Invoke-Expression "podman start mysqlpsp"

Start-Job -ScriptBlock {
& "C:\Program Files\Alacritty\alacritty.exe" `
    --config-file "C:\Users\dmitr\.dotfiles\all\alacritty\alacritty-work-profile.yml" `
    --title "ubuntu" `
    --command "wsl" `
    -d "Ubuntu-22.04" `
    --cd "~/.dotfiles" `
    -- "Open-TmuxWorkSession nadeks"

. "C:/Users/dmitr/.dotfiles/win/pwsh/bin/Run-AHK.ps1" @'
#Include C:\Users\dmitr\.dotfiles\win\ahk\utils\windows.ahk
WinClose, ahk_exe Podman Desktop.exe
WinWait, ubuntu ahk_class Window Class ahk_exe alacritty.exe,, 5
WinActivate, ubuntu ahk_class Window Class ahk_exe alacritty.exe
makeAnyWindowCenteredThenMaximized()
'@
}

Get-Job | Wait-Job
# $pass = Read-Host -Prompt "Enter to continue" -MaskInput
