$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Import-Module 'C:\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1'

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

$env:EDITOR = 'nvim'
$env:DOTFILES = "$env:USERPROFILE\.dotfiles"
$env:FZF_CTRL_T_COMMAND = 'fd --type f --path-separator / --hidden'
$env:FZF_ALT_C_COMMAND = 'fd --type d --path-separator /'

Set-Alias -Name vi -Value nvim
Set-Alias -Name .f -Value dotfiles
Set-Alias -Name .fe -Value dotfilesEdit

function dotfiles {
    Set-Location $env:DOTFILES
}
function dotfilesEdit {
    Set-Location $env:DOTFILES && nvim .
}
