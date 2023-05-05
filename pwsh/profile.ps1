[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
 
Import-Module "$env:LOCALAPPDATA\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1"

oh-my-posh init pwsh --config "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\bedware.omp.json"| Invoke-Expression

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

$env:EDITOR = 'nvim'
$env:DOTFILES = "$env:USERPROFILE\.dotfiles"
$env:ChocolateyToolsLocation = "$env:LOCALAPPDATA\tools"
$fzfParam = "--path-separator / --hidden --exclude 'AppData'"
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d $fzfParam"

Set-Alias -Name vi -Value nvim
Set-Alias -Name .f -Value dotfiles
Set-Alias -Name .fe -Value dotfilesEdit
Set-Alias -Name l -Value lslah

function dotfiles {
    Set-Location $env:DOTFILES
}
function dotfilesEdit {
    Set-Location $env:DOTFILES ; nvim .
}
function scan {
    & "$env:USERPROFILE\OneDrive\Soft\SpaceSniffer.exe" scan "$pwd"
}
function lslah {
    Get-ChildItem -Force $args
}
