# INSTALL SIMLINKS

# Powershell
New-Item -ItemType SymbolicLink -Force `
-Path "$env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1" `
-Target "$env:USERPROFILE\.dotfiles\pwsh\profile.ps1"
New-Item -ItemType SymbolicLink -Force `
-Path "$env:USERPROFILE\Documents\Powershell\Scripts" `
-Target "$env:USERPROFILE\.dotfiles\pwsh\Scripts"

# Neovim
New-Item -ItemType SymbolicLink -Force `
-Path "$env:LOCALAPPDATA\nvim" `
-Target "$env:USERPROFILE\.dotfiles\nvim"

# Windows Terminal
New-Item -ItemType SymbolicLink -Force `
-Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
-Target "$env:USERPROFILE\.dotfiles\wt\settings.json"

# IDEA Vim Plugin
New-Item -ItemType SymbolicLink -Force `
-Path "$env:USERPROFILE\.ideavimrc" `
-Target "$env:USERPROFILE\.dotfiles\.ideavimrc"

# Total Commander
New-Item -ItemType SymbolicLink -Force `
-Path "$env:USERPROFILE\wincmd.ini" `
-Target "$env:USERPROFILE\.dotfiles\wincmd.ini"


# CREATE AUTOSTARTUP TASKS

.\pwsh\Scripts\autostart_ahk_admin_rights.ps1

