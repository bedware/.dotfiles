# INSTALL SIMLINKS

if ($IsWindows) {
    Write-Error "Script created for non-Windows system. Aborting..."
    Sleep 5
    Exit
}
$env:DOTFILES="$env:HOME/.dotfiles"

# Define the list of symlinks
$links = @(
    @{ # pwsh
        Path = "$env:HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
        Target = "$env:DOTFILES/wsl/pwsh/profile.ps1"
    },
    @{ # neovim
        Path = "$env:HOME/.config/nvim"
        Target = "$env:DOTFILES/wsl/nvim"
    },
    @{ # tmux
        Path = "$env:HOME/.tmux.conf"
        Target = "$env:DOTFILES/wsl/tmux/.tmux.conf"
    }
)

foreach ($link in $links) {
    New-Item -Path $(Split-Path $link.Path) -ItemType Directory -Force
    New-Item -ItemType SymbolicLink -Force -Path $link.Path -Target $link.Target
}
