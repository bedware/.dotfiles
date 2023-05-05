$sw = [Diagnostics.Stopwatch]::StartNew()
$ubuntu = (wsl -l | ForEach-Object { $_ -replace "`0", "" } |  Select-String -Pattern "ubuntu" | Select-Object -First 1).ToString()
$user = "bedware"

wsl --terminate $ubuntu
wsl --unregister $ubuntu
ubuntu2204 install --root
wsl -d $ubuntu /bin/bash -c "useradd -m -s /bin/bash -G adm,sudo,dip,plugdev,netdev $user"
wsl -d $ubuntu /bin/bash -c "echo $user`:$env:PASS | chpasswd"
ubuntu2204 config --default-user $user
$sw.Stop()
"$($sw.Elapsed.Seconds) seconds, $($sw.Elapsed.Milliseconds) millis"
