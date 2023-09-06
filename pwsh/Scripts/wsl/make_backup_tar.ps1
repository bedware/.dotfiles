$ErrorActionPreference = "Stop"

$sw = [Diagnostics.Stopwatch]::StartNew()
$ubuntu = (wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1).ToString()
wsl --terminate $ubuntu
wsl --shutdown
New-Item -ItemType Directory -Path $env:HOME/.wsl -ErrorAction Ignore
wsl --export $ubuntu "$env:HOME/.wsl/ubuntu_backup.tar"
$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
