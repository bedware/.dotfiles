Write-Host "Hello from win host"

Start-Process -FilePath "C:\Users\dmitr\AppData\Local\Programs\podman-desktop\Podman Desktop.exe" &
Invoke-Expression "podman info"

$counter = 0
while ($LASTEXITCODE -ne 0 -and $counter -lt 10) {
    Invoke-Expression "podman info"
    $counter += 1
    Start-Sleep -Seconds 1
}

if ($LASTEXITCODE -ne 0) {
    exit
}

Invoke-Expression "podman start mysqlpsp"

$scriptBlock = {
    # Your script block code here
    . "C:\Program Files\Alacritty\alacritty.exe" --config-file "C:\Users\dmitr\.dotfiles\all\alacritty\alacritty-work-profile.yml" --title "ubuntu" --command "wsl" -d "Ubuntu-22.04" --cd "~/.dotfiles" -- "start-working-session"
    Start-Sleep -Seconds 1

    # ahk 'WinWait, ahk_exe alacritty.exe,, 5'
    # ahk 'WinActivate, ahk_exe alacritty.exe'
    ahk 'WinSet, Style, -0xC40000, A'
    ahk 'WinMove, A, , 0, 0, A_ScreenWidth, A_ScreenHeight'
    # Not hang
}
Start-Job -ScriptBlock $scriptBlock

Get-Job | Wait-Job
# $pass = Read-Host -Prompt "Enter to skip" -MaskInput
