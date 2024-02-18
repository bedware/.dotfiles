[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Environment variables {{{1

$env:DOTFILES = $env:HOME.ToString().Replace("\", "/") + "/.dotfiles"
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:JAVA_HOME = "$env:HOME/.sdkman/candidates/java/current/"
$env:OPENAI_API_KEY = Get-Content "$env:HOME/.ssh/openai"
$env:SDKMAN_DIR = "$env:HOME/.sdkman"

# Platform-dependent stuff {{{1

if ($IsLinux) {
    $env:PATH_SEPARATOR = ":"
    if ($PSVersionTable.OS -match "WSL") {
        # Remove windows stuff from linux. Great lookup booster.
        $env:PATH = $env:PATH | tr ":" "\n" | grep -v -e /mnt -e "^$" | tr "\n" ":"
    }
    . "$env:DOTFILES/wsl/pwsh/.local/config/borrowed.ps1"
} elseif ($IsWindows) {
    $env:PATH_SEPARATOR = ";"
    . "$env:DOTFILES/win/pwsh/config/user_functions.ps1"
    $env:PATH += "$env:PATH_SEPARATOR$env:DOTFILES/win/pwsh/bin/"
} else {
    throw "OS is not detected. Separator is not determined!"
}

# Path {{{1

$env:PATH += "$env:PATH_SEPARATOR$env:DOTFILES/wsl/pwsh/.local/bin/"
$env:PATH += "$env:PATH_SEPARATOR$env:BUN_INSTALL/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:JAVA_HOME/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:HOME/.local/bin"
if (Test-Path $env:SDKMAN_DIR) {
    Get-ChildItem "$env:SDKMAN_DIR/candidates" | ForEach-Object { 
        $env:PATH += "$env:PATH_SEPARATOR$env:SDKMAN_DIR/candidates/$($_.Name)/current/bin"
    }
}
$env:PATH = ($env:PATH).Replace("$env:PATH_SEPARATOR$env:PATH_SEPARATOR", "$env:PATH_SEPARATOR")

# Imports & Init {{{1

Import-Module -Name posh-git
$global:GitPromptSettings.DefaultPromptPrefix.Text = ""
$global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
$global:GitPromptSettings.DefaultPromptSuffix.Text = '> $(OnViModeChange([Microsoft.PowerShell.PSConsoleReadLine]::InViCommandMode() ? "Command" : "Insert"))'

. "$env:DOTFILES/wsl/pwsh/.local/config/vimode.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/alias_autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/hotkeys.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/user_functions.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/nvim-switcher.ps1"

# Aliases {{{1

New-Alias -Name .f -Value 'cd $env:DOTFILES'
New-Alias -Name .fe -Value 'Edit-AndComeBack($env:DOTFILES)'
New-Alias -Name .a -Value 'cd $env:DOTFILES/win/ahk'
New-Alias -Name .ae -Value 'Edit-AndComeBack("$env:DOTFILES/win/ahk")'
New-Alias -Name .n -Value 'cd $env:DOTFILES/wsl/nvim/.config/nvim'
New-Alias -Name .ne -Value 'Edit-AndComeBack("$env:DOTFILES/wsl/nvim/.config/nvim")'
New-Alias -Name .p -Value Copy-PathToClipboard
New-Alias -Name .pe -Value 'vi $profile' 
Remove-Alias cd; New-Alias -Name cd -Value 'Set-LocationAndList'
New-Alias -Name l -Value 'Get-ChildItemCompact'
New-Alias -Name rmr -Value "Remove-Item -Force -Recurse"
New-BlankAlias -Name e -Value '$env:'
New-IgnoredAlias -Name vi -Value 'nvim'
New-IgnoredAlias -Name docker -Value 'podman' 

