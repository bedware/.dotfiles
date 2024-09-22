[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Write-Host "Profile reading started"

# Environment variables {{{1

$env:DOTFILES = "$env:HOME/.dotfiles"
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:JAVA_HOME = Get-Command java | Select-Object -ExpandProperty Path | Get-Item | Select-Object -ExpandProperty Target | Split-Path -Parent | Split-Path -Parent
$env:OPENAI_API_KEY = Get-Content "$env:HOME/.ssh/openai"
$env:DC_API_TOKEN = Get-Content "$env:HOME/.ssh/daycaptain"
$env:SDKMAN_DIR = "$env:HOME/.sdkman"
$env:TERM = "xterm-256color"

# Path {{{1
function Add-ToPathSafely($path) {
    if (Test-Path $path) {
        $env:PATH += [IO.Path]::PathSeparator + $path
    } else {
        Write-Warning "Path: '$path' doesn't exist. It won't be added to PATH."
    }
}
Add-ToPathSafely("$env:BUN_INSTALL/bin")
Add-ToPathSafely("$env:HOME/.local/bin")
Add-ToPathSafely("$env:HOME/.cargo/bin")

# Imports & Init {{{1

Import-Module -Name posh-git
$global:GitPromptSettings.DefaultPromptPrefix.Text = ""
$global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
$global:GitPromptSettings.DefaultPromptSuffix.Text = '> $(OnViModeChange([Microsoft.PowerShell.PSConsoleReadLine]::InViCommandMode() ? "Command" : "Insert"))'

. "$env:DOTFILES/wsl/pwsh/.local/config/vimode.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/alias-autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/hotkeys.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/autocompletion.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/user-functions.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/nvim-switcher.ps1"

. "$env:DOTFILES/wsl/pwsh/.local/config/script-wrapper.ps1"
Add-ScriptsFromDir("$env:DOTFILES/wsl/pwsh/.local/bin")

# Aliases {{{1

New-Alias -Name .f -Value 'cd $env:DOTFILES'
New-Alias -Name .fe -Value 'Edit-AndComeBack($env:DOTFILES)'
New-Alias -Name .a -Value 'cd $env:DOTFILES/win/ahk'
New-Alias -Name .ae -Value 'Edit-AndComeBack("$env:DOTFILES/win/ahk")'
New-Alias -Name .n -Value 'cd $env:DOTFILES/wsl/nvim/.config/nvim'
New-Alias -Name .ne -Value 'Edit-AndComeBack("$env:DOTFILES/wsl/nvim/.config/nvim")'
New-Alias -Name .c -Value 'nvim -c ":ChatGPT"'
New-Alias -Name .pe -Value 'vi $profile' 
Remove-Alias cd; New-Alias -Name cd -Value 'Set-LocationAndList'
New-Alias -Name rmr -Value "Remove-Item -Force -Recurse"
New-Alias -Name l -Value 'Get-ChildItem -Force'
New-Alias -Name ll -Value 'Get-ChildItem -Force | Format-Table -AutoSize'
New-Alias -Name '|l' -Value '| less'
New-Alias -Name '|a' -Value '| Format-Table -AutoSize'
New-Alias -Name '|w' -Value '| Select-Object -ExpandProperty Path | ForEach-Object { nvim $_ }'
New-Alias -Name '|e' -Value '| Select-Object -ExpandProperty Path'
New-Alias -Name '|p' -Value '| Select-Object -Property *'
New-Alias -Name '|f' -Value '| ForEach-Object { $_ }'
New-BlankAlias -Name e -Value '$env:'
New-IgnoredAlias -Name vi -Value 'nvim'

# Other {{{1

# cleaning the PATH
$env:PATH = ($env:PATH).Replace("//", "/")
$env:PATH = ($env:PATH).Replace([IO.Path]::PathSeparator + [IO.Path]::PathSeparator, [IO.Path]::PathSeparator)

# Platform-dependent stuff
if ($IsLinux) {
    . "$env:DOTFILES/wsl/pwsh/.local/config/borrowed.ps1"

    # Remove windows stuff from linux. Great lookup booster.
    $env:PATH = ($env:PATH -split [IO.Path]::PathSeparator | `
        Where-Object { $_ -notlike "/mnt*" } | Sort-Object | Get-Unique) -join [IO.Path]::PathSeparator

    Write-Host "PATH:"
    Write-Host ($env:PATH).Replace([IO.Path]::PathSeparator, "`n")
} elseif ($IsWindows) {
    . "$env:DOTFILES/win/pwsh/config/user-functions.ps1"
    Add-ScriptsFromDir("$env:DOTFILES/win/pwsh/bin/")
}

Write-Host "Profile has been read"
Get-Content "$env:DOTFILES/all/pragmatic-programmer-tips.json" | ConvertFrom-Json | Get-Random | ForEach-Object { Write-Host "`nTip #$($_.id): $($_.tip)`n$($_.tip_description)`n" }

