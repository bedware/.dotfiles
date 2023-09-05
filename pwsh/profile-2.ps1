[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$env:DOTFILES = "$env:HOME/.dotfiles"
$env:PATH = "$env:PATH`:$env:HOME/.sdkman/candidates/java/current/bin"

# I need to push this into background
if ($PSVersionTable.OS -match "Linux") {
    if ($PSVersionTable.OS -match "WSL") {
        $env:PATH = $env:PATH | tr ":" "\n" | grep -v -e /mnt -e "^$" | tr "\n" ":"
    }
}
elseif ($PSVersionTable.OS -match "Windows") {

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

Write-Host -NoNewLine "`e[6 q" # Set the cursor to a non blinking line.
Set-PSReadLineOption -EditMode Vi -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
 
# New-Alias -Name .f -Value 'Set-Location ~/.dotfiles'
. "$env:DOTFILES/pwsh/Scripts/alias_autocomplete.ps1"

