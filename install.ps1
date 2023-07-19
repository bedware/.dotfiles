# INSTALL SIMLINKS

# Powershell
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\Documents\Powershell\Microsoft.PowerShell_profile.ps1" `
-Target "$env:HOME\.dotfiles\pwsh\profile.ps1"
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\Documents\Powershell\Scripts" `
-Target "$env:HOME\.dotfiles\pwsh\Scripts"

# Neovim
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\.config\nvim" `
-Target "$env:HOME\.dotfiles\nvim"

# Windows Terminal
New-Item -ItemType SymbolicLink -Force `
-Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" `
-Target "$env:HOME\.dotfiles\wt\settings.json"

# IDEA Vim Plugin
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\.ideavimrc" `
-Target "$env:HOME\.dotfiles\.ideavimrc"

# Total Commander
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\wincmd.ini" `
-Target "$env:HOME\.dotfiles\wincmd.ini"


# CREATE AUTOSTARTUP TASKS

#.\pwsh\Scripts\autostart_ahk_admin_rights.ps1

