[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Environment variables

$env:DOTFILES = "$env:HOME/.dotfiles"
# Editor
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
# Bun
$env:BUN_INSTALL = "$env:HOME/.bun"
# Java
$env:JAVA_HOME = "$env:HOME/.jdks/jdk-21"
# fzf
$exclude = @('.git', 'AppData', '.m2', '.jdks', '.gradle')
$fzfParam = "--path-separator '/' --hidden " + @($exclude | ForEach-Object {"--exclude '$_'"}) -join " "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d --follow $fzfParam"

# Platform-dependent stuff

if ($PSVersionTable.OS -match "Linux") {
    $env:PATH_SEPARATOR = ":"
    if ($PSVersionTable.OS -match "WSL") {
        # Remove windows stuff from linux. Great lookup booster.
        $env:PATH = $env:PATH | tr ":" "\n" | grep -v -e /mnt -e "^$" | tr "\n" ":"
    }
} elseif ($PSVersionTable.OS -match "Windows") {
    $env:PATH_SEPARATOR = ";"
    . "$env:DOTFILES/pwsh/user_functions_win.ps1"
} else {
    throw "OS is not detected. Separator is not determined!"
}

# Path
$env:PATH += "$env:PATH_SEPARATOR$env:BUN_INSTALL/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:JAVA_HOME/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:HOME/.local/bin"

# Imports & Init

. "$env:DOTFILES/wsl/pwsh/.local/bin/lazyload.ps1" `
    -Modules { Import-Module -Name posh-git } `
    -AfterModulesLoad { $global:GitPromptSettings.DefaultPromptPrefix.Text = '⭐' }
. "$env:DOTFILES/wsl/pwsh/.local/bin/vimode.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/nvim-switcher.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/alias_autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/user_functions.ps1"
 
# Configuring

Set-PsFzfOption -PSReadlineChordProvider "Ctrl+f" `
                -PSReadlineChordReverseHistory "Ctrl+r" `
                -PSReadlineChordSetLocation "Ctrl+g"

# Aliases

New-Alias -Name .f -Value "Set-Location $env:DOTFILES"
New-Alias -Name .fe -Value "Set-Location $env:DOTFILES && nvim ."
New-Alias -Name l -Value "Get-ChildItem -Force"
Add-IgnoredAlias -Name vi -Value "nvim"
Add-BlankAlias -Name e -Value "`$env:"

# aliases with functions
New-Alias -Name .p -Value CopyPathToClipboard

