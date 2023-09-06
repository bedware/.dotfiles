param(
    [string]$user = "bedware",
    [string]$pass = "bedware"
)

$ErrorActionPreference = "Stop"

$sw = [Diagnostics.Stopwatch]::StartNew()

$ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
wsl --terminate $ubuntu
wsl --unregister $ubuntu
ubuntu2204 install --root
if ([string]::IsNullOrEmpty($ubuntu)) {
    $ubuntu = wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1
    wsl --terminate $ubuntu
    wsl --unregister $ubuntu
    wsl -d $ubuntu /bin/bash -c "useradd -m -s /bin/bash -G adm,sudo,dip,plugdev,netdev $user"
    wsl -d $ubuntu /bin/bash -c "echo $user`:$pass | chpasswd"
    ubuntu2204 config --default-user $user
}
$ubuntu = $ubuntu.ToString()
Write-Host "Profile name: $ubuntu"

$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
