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
$fzfParam = "--path-separator / --hidden " + `
"--exclude 'AppData' " + `
"--exclude '.m2' " + `
"--exclude '.git' " + `
"--exclude '.jdks' " + `
"--exclude '.gradle' "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d $fzfParam"

. "$env:DOTFILES\pwsh\Scripts\autocomplete.ps1"
Set-Alias -Name .f -Value dotfiles
Set-Alias -Name .fe -Value dotfilesEdit
Add-IgnoredAlias -Name vi -Value nvim
Add-IgnoredAlias -Name l -Value lslah
Add-BlankAlias -Name e -Value `$env:

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
