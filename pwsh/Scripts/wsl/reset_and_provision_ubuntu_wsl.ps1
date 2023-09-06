$ErrorActionPreference = "Stop"

$user = "bedware"
./reset_ubuntu_wsl.ps1 $user $env:PASS
Copy-Item -Recurse "$env:DOTFILES/ansible/wsl" "\\wsl.localhost\Ubuntu-22.04\home\$user\wsl_init"
