$ErrorActionPreference = "Stop"

$sw = [Diagnostics.Stopwatch]::StartNew()

$user = "bedware"
$pass = Read-Host -Prompt "Type your password" -MaskInput
./wsl_reset_ubuntu.ps1 $user $pass
Write-Host "Preparing for proviosioning"
$ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
wsl -d $ubuntu --cd ~ -- git clone https://github.com/bedware/.dotfiles.git
Write-Host "dotfiles successfully cloned to WSL"

$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
