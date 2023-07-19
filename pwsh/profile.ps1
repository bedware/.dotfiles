[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Environment variables
$env:ChocolateyToolsLocation = "$env:LOCALAPPDATA\tools"
$env:EDITOR = 'nvim'
$env:DOTFILES = "$env:HOME\.dotfiles"
$env:XDG_CONFIG_HOME = "$env:HOME\.config"
$fzfParam = "--path-separator / --hidden " + `
"--exclude 'AppData' " + `
"--exclude '.m2' " + `
"--exclude '.git' " + `
"--exclude '.jdks' " + `
"--exclude '.gradle' "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d $fzfParam"

# Functions

function Set-EnvVar {
    $env:SHELLEDITMODE=(Get-PSReadLineOption).EditMode
}
function scan {
    & "$env:HOME\OneDrive\Soft\SpaceSniffer.exe" scan "$pwd"
}
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a non blinking block.
        Write-Host -NoNewLine "`e[2 q"
    } else {
        # Set the cursor to a non blinking line.
        Write-Host -NoNewLine "`e[6 q"
    }
}

# Imports

Import-Module PSProfiler
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
    Update-SessionEnvironment
}
 
Import-Module "$env:LOCALAPPDATA\tools\poshgit\dahlbyk-posh-git-9bda399\src\posh-git.psd1"
New-Alias -Name 'Set-PoshContext' -Value 'Set-EnvVar' -Scope Global -Force
oh-my-posh init pwsh --config "$env:LOCALAPPDATA\Programs\oh-my-posh\themes\bedware.omp.json" | Invoke-Expression

# Configuring

Write-Host -NoNewLine "`e[6 q" # Set the cursor to a non blinking line.
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

# Aliases

. "$env:DOTFILES\pwsh\Scripts\alias_autocomplete.ps1"
New-Alias -Name .f -Value 'Set-Location $env:DOTFILES'
New-Alias -Name .fe -Value 'Set-Location $env:DOTFILES && nvim .'
#Set-Alias -Name gst -Value "git status"
# Remove-Alias -Force -ErrorAction SilentlyContinue -Name gc
# Set-Alias -Name gc -Value "git commit"
Add-IgnoredAlias -Name vi -Value nvim
New-Alias -Name l -Value "Get-ChildItem -Force"
Add-BlankAlias -Name e -Value "`$env:"

