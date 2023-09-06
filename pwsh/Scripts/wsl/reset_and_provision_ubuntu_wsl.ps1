$ErrorActionPreference = "Stop"

$sw = [Diagnostics.Stopwatch]::StartNew()

$user = "bedware"
./reset_ubuntu_wsl.ps1 $user $env:PASS
Write-Host "Preparing for provioning"
$ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
wsl -d $ubuntu --cd ~ -- git clone https://github.com/bedware/.dotfiles.git
Write-Host "dotfiles successfylly cloned to WSL"
# Copy-Item -Recurse "$env:DOTFILES/ansible/wsl" "\\wsl.localhost\Ubuntu-22.04\home\$user"
# Write-Host "Copying SSH-keys"
# Copy-Item -Recurse "$env:HOME/.ssh" "\\wsl.localhost\Ubuntu-22.04\home\$user"

$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
