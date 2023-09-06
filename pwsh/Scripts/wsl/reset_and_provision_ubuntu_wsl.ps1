$ErrorActionPreference = "Stop"

$user = "bedware"
./reset_ubuntu_wsl.ps1 $user $env:PASS
Write-Host "Copying WSL provisioning files"
Copy-Item -Recurse "$env:DOTFILES/ansible/wsl" "\\wsl.localhost\Ubuntu-22.04\home\$user"
Write-Host "Copying SSH-keys"
Copy-Item -Recurse "$env:HOME/.ssh" "\\wsl.localhost\Ubuntu-22.04\home\$user"
