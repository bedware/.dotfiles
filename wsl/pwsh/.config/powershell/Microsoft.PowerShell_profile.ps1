[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# Environment variables {{{1

$env:DOTFILES = $env:HOME.ToString().Replace("\", "/") + "/.dotfiles"
# Editor
$env:EDITOR = "nvim"
$env:VISUAL = "$env:EDITOR"
# Bun
$env:BUN_INSTALL = "$env:HOME/.bun"
# Java
$env:JAVA_HOME = "$env:HOME/.jdks/jdk-21"
# OpenAI
$env:OPENAI_API_KEY = Get-Content "$env:HOME/.ssh/openai"

# Platform-dependent stuff {{{1

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

# Path {{{1

$env:PATH += "$env:PATH_SEPARATOR$env:BUN_INSTALL/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:JAVA_HOME/bin"
$env:PATH += "$env:PATH_SEPARATOR$env:HOME/.local/bin"

# Imports & Init {{{1

$backup = $profile
. "$env:DOTFILES/wsl/pwsh/.local/bin/lazyload.ps1" `
    -Modules { Import-Module -Name posh-git } `
    -AfterModulesLoad { 
        $global:GitPromptSettings.DefaultPromptPrefix.Text = "☹️  "
        $global:GitPromptSettings.DefaultPromptBeforeSuffix.Text = "`n"
        $global:GitPromptSettings.DefaultPromptSuffix.Text = ""
        $global:profile = $backup
    }
. "$env:DOTFILES/wsl/pwsh/.local/bin/vimode.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/nvim-switcher.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/alias_autocomplete.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/hotkeys.ps1"
. "$env:DOTFILES/wsl/pwsh/.local/bin/user_functions.ps1"
 
# Configuring {{{1

# fzf
$fzfExclude = @('.git', 'AppData', '.m2', '.jdks', '.gradle')
$fzfParam = "--path-separator '/' --hidden " + @($fzfExclude | ForEach-Object {"--exclude '$_'"}) -join " "
$env:FZF_CTRL_T_COMMAND = "fd --type f $fzfParam"
$env:FZF_ALT_C_COMMAND = "fd --type d --follow $fzfParam"
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+f" `
                -PSReadlineChordReverseHistory "Ctrl+r" `
                -PSReadlineChordSetLocation "Ctrl+g"

# Aliases {{{1

New-Alias -Name .f -Value "cd $env:DOTFILES"
New-Alias -Name .fe -Value "`$curr=pwd; cd $env:DOTFILES && nvim .; cd `$curr"
New-Alias -Name .a -Value "cd $env:DOTFILES/ahk"
New-Alias -Name .ae -Value "`$curr=pwd; cd $env:DOTFILES/ahk && nvim .; cd `$curr"
New-Alias -Name .n -Value "cd $env:DOTFILES/wsl/nvim/.config/nvim"
New-Alias -Name .ne -Value "`$curr=pwd; cd $env:DOTFILES/wsl/nvim/.config/nvim && nvim .; cd `$curr"
New-Alias -Name .p -Value CopyPathToClipboard
New-Alias -Name .pe -Value "vi `$profile" 
New-Alias -Name cs -Value "GoToDirAndList"
New-Alias -Name l -Value "Get-ChildItem -Force | Format-Table -AutoSize"
New-Alias -Name rmr -Value "Remove-Item -Force -Recurse"
Add-IgnoredAlias -Name vi -Value "nvim"
Add-BlankAlias -Name e -Value "`$env:"

