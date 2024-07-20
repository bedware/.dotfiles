Write-Host "Hello from Windows host"

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

# alacritty
Start-Job -ScriptBlock {
    . "C:\Program Files\Alacritty\alacritty.exe" `
        --config-file "C:\Users\dmitr\.dotfiles\all\alacritty\alacritty-work-profile.yml" `
        --title "ubuntu" `
        --command "wsl" `
        -d "Ubuntu-22.04" `
        --cd "~/.dotfiles" `
        -- "tmux-work-session.ps1"

    Start-Sleep -Seconds 1
    Run-AHK @'
    #Include C:\Users\dmitr\.dotfiles\win\ahk\utils\windows.ahk

    makeAnyWindowCenteredThenMaximized()
'@
}

# podman desktop
Run-AHK 'WinClose, ahk_exe Podman Desktop.exe'

Get-Job | Wait-Job
# $pass = Read-Host -Prompt "Enter to skip" -MaskInput
