[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Shared environment variables

# Bun
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:PATH = "$env:BUN_INSTALL/bin:$env:PATH"
# Scripts
$env:PATH = "$env:HOME/.local/bin:$env:PATH"
# Java
$env:JAVA_HOME = "$env:HOME/.jdks/jdk-21"
$env:PATH = "$env:JAVA_HOME/bin:$env:PATH"

$env:DOTFILES = "$env:HOME/.dotfiles"
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$fzfParam = "--path-separator '/' --hidden " + `
"--exclude '.git' " + `
"--exclude 'AppData' " + `
"--exclude '.m2' " + `
"--exclude '.jdks' " + `
"--exclude '.gradle' "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d --follow $fzfParam"

# Platform-dependent stuff

if ($PSVersionTable.OS -match "Linux") {
    if ($PSVersionTable.OS -match "WSL") {
        # Remove windows stuff from linux. Great lookup booster.
        $env:PATH = $env:PATH | tr ":" "\n" | grep -v -e /mnt -e "^$" | tr "\n" ":"
    }
} elseif ($PSVersionTable.OS -match "Windows") {
    # Functions
    function scan {
        & "$env:HOME\OneDrive\Soft\SpaceSniffer.exe" scan "$pwd"
    }
}

# Shared functions

function CopyPathToClipboard {
    Get-Location | Set-Clipboard
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

# Imports & Init

# Write-Host -NoNewLine "`e[6 q" # Set the cursor to a non blinking line.
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

. "$env:DOTFILES/wsl/pwsh/.local/bin/alias_autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/nvim-switcher.ps1"

Import-Module posh-git
 
# Configuring

# fzf
Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

# Aliases

# dotfiles
New-Alias -Name .f -Value 'Set-Location $env:DOTFILES'
New-Alias -Name .fe -Value 'Set-Location $env:DOTFILES && nvim .'

# others
New-Alias -Name .p -Value CopyPathToClipboard
New-Alias -Name l -Value "Get-ChildItem -Force"
Add-IgnoredAlias -Name vi -Value nvim
Add-BlankAlias -Name e -Value "`$env:"

