[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Write-Host "Profile reading started"

# Environment variables {{{1

$env:DOTFILES = $env:HOME.ToString().Replace("\", "/") + "/.dotfiles"
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:JAVA_HOME = "$env:HOME/.sdkman/candidates/java/current/"
$env:OPENAI_API_KEY = Get-Content "$env:HOME/.ssh/openai"
$env:SDKMAN_DIR = "$env:HOME/.sdkman"

# Path {{{1

$env:PATH += [IO.Path]::PathSeparator + "$env:DOTFILES/wsl/pwsh/.local/bin/"
$env:PATH += [IO.Path]::PathSeparator + "$env:BUN_INSTALL/bin"
$env:PATH += [IO.Path]::PathSeparator + "$env:JAVA_HOME/bin"
$env:PATH += [IO.Path]::PathSeparator + "$env:HOME/.local/bin"
if (Test-Path $env:SDKMAN_DIR) {
    Get-ChildItem "$env:SDKMAN_DIR/candidates" | ForEach-Object { 
        $env:PATH += [IO.Path]::PathSeparator + "$env:SDKMAN_DIR/candidates/$($_.Name)/current/bin"
    }
}

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
New-Alias -Name docker -Value 'podman' 

# Other {{{1

# cleaning the PATH
$env:PATH = ($env:PATH).Replace("//", "/")
$env:PATH = ($env:PATH).Replace([IO.Path]::PathSeparator + [IO.Path]::PathSeparator, [IO.Path]::PathSeparator)

# Platform-dependent stuff
if ($IsLinux) {
    # argc-completions
    # Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    $env:ARGC_COMPLETIONS_ROOT = '/home/bedware/argc-completions'    
    $env:ARGC_COMPLETIONS_PATH = "$env:ARGC_COMPLETIONS_ROOT/completions"    
    $env:PATH += [IO.Path]::PathSeparator + "$env:ARGC_COMPLETIONS_ROOT/bin"
    # To add completions for only the specified command, modify next line e.g. $argc_scripts = @("cargo", "git")
    $argc_scripts = ((Get-ChildItem -File ($env:ARGC_COMPLETIONS_ROOT + '/completions')) | ForEach-Object { $_.Name -replace '\.sh$' })
    argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression

    # Remove windows stuff from linux. Great lookup booster.
    . "$env:DOTFILES/wsl/pwsh/.local/config/borrowed.ps1"
    # $env:PATH = ($env:PATH | tr ':' '\n' | grep -v -e /mnt -e "^$" | unique | sort | tr "\n" ":")
    $env:PATH = ($env:PATH -split [IO.Path]::PathSeparator | Where-Object { $_ -notlike "/mnt*" } | Sort-Object | Get-Unique) -join [IO.Path]::PathSeparator

    Write-Host "PATH:"
    $env:PATH -replace [IO.Path]::PathSeparator, "`n"
} elseif ($IsWindows) {
    . "$env:DOTFILES/win/pwsh/config/user_functions.ps1"
    $env:PATH += [IO.Path]::PathSeparator + "$env:DOTFILES/win/pwsh/bin/"
}

Write-Host "Profile has been read"

