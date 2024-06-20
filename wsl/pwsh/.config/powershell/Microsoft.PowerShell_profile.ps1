[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Write-Host "Profile reading started"

# Environment variables {{{1

$env:DOTFILES = $env:HOME.ToString().Replace("\", "/") + "/.dotfiles"
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
$env:LESS = "-S +g"
$env:BUN_INSTALL = "$env:HOME/.bun"
$env:JAVA_HOME = "$env:HOME/.sdkman/candidates/java/current/"
$env:OPENAI_API_KEY = Get-Content "$env:HOME/.ssh/openai"
$env:DC_API_TOKEN = Get-Content "$env:HOME/.ssh/daycaptain"
$env:SDKMAN_DIR = "$env:HOME/.sdkman"

# Path {{{1
function safelyAddToPath($path) {
    if (Test-Path $path) {
        $env:PATH += [IO.Path]::PathSeparator + $path
    } else {
        Write-Warning "Path: '$path' doesn't exist. It won't be added to PATH."
    }
}
safelyAddToPath("$env:DOTFILES/wsl/pwsh/.local/bin")
safelyAddToPath("$env:BUN_INSTALL/bin")
safelyAddToPath("$env:JAVA_HOME/bin")
safelyAddToPath("$env:HOME/.local/bin")
safelyAddToPath("$env:HOME/.cargo/bin")
if (Test-Path $env:SDKMAN_DIR) {
    Get-ChildItem "$env:SDKMAN_DIR/candidates" | ForEach-Object { 
        safelyAddToPath("$env:SDKMAN_DIR/candidates/$($_.Name)/current/bin")
    }
}

# Imports & Init {{{1

Import-Module -Name posh-git
$global:GitPromptSettings.DefaultPromptPrefix.Text = ""
$global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
$global:GitPromptSettings.DefaultPromptSuffix.Text = '> $(OnViModeChange([Microsoft.PowerShell.PSConsoleReadLine]::InViCommandMode() ? "Command" : "Insert"))'

. "$env:DOTFILES/wsl/pwsh/.local/config/vimode.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/alias-autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/hotkeys.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/user-functions.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/config/nvim-switcher.ps1"

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
New-Alias -Name '|l' -Value '| Format-Table -AutoSize'
New-Alias -Name '|w' -Value '| Select-Object -ExpandProperty Path | ForEach-Object { nvim $_ }'
New-BlankAlias -Name e -Value '$env:'
New-IgnoredAlias -Name vi -Value 'nvim'

# Other {{{1

# cleaning the PATH
$env:PATH = ($env:PATH).Replace("//", "/")
$env:PATH = ($env:PATH).Replace([IO.Path]::PathSeparator + [IO.Path]::PathSeparator, [IO.Path]::PathSeparator)

# Platform-dependent stuff
if ($IsLinux) {
    . "$env:DOTFILES/wsl/pwsh/.local/config/borrowed.ps1"

    # argc-completions
    $env:ARGC_COMPLETIONS_ROOT = '/home/bedware/github/argc-completions'    
    $env:PATH += [IO.Path]::PathSeparator + "$env:ARGC_COMPLETIONS_ROOT/bin"
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

    # Remove windows stuff from linux. Great lookup booster.
    $env:PATH = ($env:PATH -split [IO.Path]::PathSeparator | Where-Object { $_ -notlike "/mnt*" } | Sort-Object | Get-Unique) -join [IO.Path]::PathSeparator

    Write-Host "PATH:"
    $env:PATH -replace [IO.Path]::PathSeparator, "`n"
} elseif ($IsWindows) {
    . "$env:DOTFILES/win/pwsh/config/user-functions.ps1"
    $env:PATH += [IO.Path]::PathSeparator + "$env:DOTFILES/win/pwsh/bin/"
}

# iximiuz
if (Test-Path "$env:HOME/.iximiuz/labctl/autocompletion.ps1") {
    $env:PATH += [IO.Path]::PathSeparator + "$env:HOME/.config/powershell/autocompletion/labctl/bin"
    . "$env:HOME/.iximiuz/labctl/autocompletion.ps1"
}

# My autocompletion override
# to generate autocomplete file use: argc --argc-completions powershell podman > filename.ps1
# argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression
if (Test-Path "$env:HOME/.autocompletion/") {
    Get-Content "$env:HOME/.autocompletion/*" | Out-String | Invoke-Expression
}

Write-Host "Profile has been read"

