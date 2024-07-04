param(
    [string]$backupName = "backup"
)
$ErrorActionPreference = "Stop"

$sw = [Diagnostics.Stopwatch]::StartNew()
$user = "bedware"
$ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
if ([string]::IsNullOrEmpty($ubuntu)) {
    ./reset_ubuntu_wsl.ps1
    $ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
}
$ubuntu = $ubuntu.ToString()
wsl --terminate $ubuntu
wsl --unregister $ubuntu

$path = "$env:HOME/.wsl/ubuntu_$backupName.vhdx"
$copy = "$env:HOME/.wsl/ubuntu_$backupName.copy.vhdx"
Write-Host "Making a copy of backup"
Copy-Item $path $copy

Write-Host "Importing"
wsl --import-in-place $ubuntu $copy
ubuntu2204 config --default-user $user
$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
