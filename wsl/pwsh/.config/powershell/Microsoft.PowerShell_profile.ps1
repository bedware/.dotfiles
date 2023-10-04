[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Platform-dependent stuff
if ($PSVersionTable.OS -match "Linux") {
    $env:PATH_SEPARATOR = ":"
    if ($PSVersionTable.OS -match "WSL") {
        # Remove windows stuff from linux. Great lookup booster.
        $env:PATH = $env:PATH | tr ":" "\n" | grep -v -e /mnt -e "^$" | tr "\n" ":"
    }
} elseif ($PSVersionTable.OS -match "Windows") {
    $env:PATH_SEPARATOR = ";"
    function scan {
        & "$env:HOME\OneDrive\Soft\SpaceSniffer.exe" scan "$pwd"
    }
} else {
    throw "OS is not detected. Separator is not determined!"
}

# Shared environment variables

# Bun
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:PATH += "$env:PATH_SEPARATOR$env:BUN_INSTALL/bin"
# Scripts
$env:PATH += "$env:PATH_SEPARATOR$env:HOME/.local/bin"
# Java
$env:JAVA_HOME = "$env:HOME/.jdks/jdk-21"
$env:PATH += "$env:PATH_SEPARATOR$env:JAVA_HOME/bin"

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

# Imports & Init

. "$env:DOTFILES/wsl/pwsh/.local/bin/lazyload.ps1" `
    -Modules {Import-Module -Name posh-git} `
    -AfterModulesLoad {
        $global:GitPromptSettings.DefaultPromptPrefix.Text = '⭐'
        # $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n'
    }
. "$env:DOTFILES/wsl/pwsh/.local/bin/nvim-switcher.ps1"
 
# Configuring

Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a non blinking block.
        Write-Host -NoNewLine "`e[2 q"
    } else {
        # Set the cursor to a non blinking line.
        Write-Host -NoNewLine "`e[6 q"
    }
}

Set-PsFzfOption `
    -PSReadlineChordProvider 'Ctrl+f' `
    -PSReadlineChordReverseHistory 'Ctrl+r' `
    -PSReadlineChordSetLocation 'Ctrl+g'

# Aliases

. "$env:DOTFILES/wsl/pwsh/.local/bin/alias_autocomplete.ps1"
# dotfiles
New-Alias -Name .f -Value 'Set-Location $env:DOTFILES'
New-Alias -Name .fe -Value 'Set-Location $env:DOTFILES && nvim .'

# others
New-Alias -Name .p -Value CopyPathToClipboard
function CopyPathToClipboard {
    Get-Location | Set-Clipboard
}
New-Alias -Name l -Value "Get-ChildItem -Force"
Add-IgnoredAlias -Name vi -Value nvim
Add-BlankAlias -Name e -Value "`$env:"

