[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Shared environment variables

$env:DOTFILES = "$env:HOME/.dotfiles"
$env:PATH = "$env:PATH`:$env:HOME/.sdkman/candidates/java/current/bin"
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$fzfParam = "--path-separator / --hidden " + `
"--exclude 'AppData' " + `
"--exclude '.m2' " + `
"--exclude '.git' " + `
"--exclude '.jdks' " + `
"--exclude '.gradle' "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d $fzfParam"

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

Write-Host -NoNewLine "`e[6 q" # Set the cursor to a non blinking line.
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

. "$env:DOTFILES/pwsh/nvim-switcher.ps1"
. "$env:DOTFILES/pwsh/alias_autocomplete.ps1"

Import-Module posh-git
 
# Configuring

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

# Aliases

New-Alias -Name .f -Value 'Set-Location $env:DOTFILES'
New-Alias -Name .fe -Value 'Set-Location $env:DOTFILES && nvim .'
New-Alias -Name .p -Value CopyPathToClipboard
New-Alias -Name l -Value "Get-ChildItem -Force"
Add-IgnoredAlias -Name vi -Value nvim
Add-BlankAlias -Name e -Value "`$env:"

