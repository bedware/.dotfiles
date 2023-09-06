# INSTALL SIMLINKS

# Powershell
New-Item -ItemType SymbolicLink -Force `
-Path "$profile" `
-Target "$env:HOME\.dotfiles\pwsh\profile.ps1"
# New-Item -ItemType SymbolicLink -Force `
# -Path "$env:HOME\Documents\Powershell\Scripts" `
# -Target "$env:HOME\.dotfiles\pwsh\Scripts"

# Neovim
New-Item -ItemType SymbolicLink -Force `
-Path "$env:HOME\.config\nvim" `
-Target "$env:HOME\.dotfiles\nvim"

