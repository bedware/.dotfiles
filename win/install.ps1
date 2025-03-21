# INSTALL SIMLINKS

if (-not $IsWindows) {
    Write-Error "Script created for Windows system. Aborting..."
    Sleep 5
    Exit
}
$env:DOTFILES="$env:USERPROFILE\.dotfiles"

# Define the list of symlinks
$links = @(
    @{ # pwsh
        Path = "$env:USERPROFILE\Documents\Powershell\Microsoft.PowerShell_profile.ps1"
        Target = "$env:DOTFILES\wsl\pwsh\.config\powershell\Microsoft.PowerShell_profile.ps1"
    },
    @{ # neovim
        Path = "$env:LOCALAPPDATA\nvim"
        Target = "$env:DOTFILES\wsl\nvim\.config\nvim"
    },
    @{ # widows terminal
        Path = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Target = "$env:DOTFILES\win\wt\settings.json"
    },
    @{ # widows terminal
        Path = "$env:APPDATA\alacritty\alacritty.yml"
        Target = "$env:DOTFILES\all\alacritty\alacritty.yml"
    },
    @{ # jetbrains idea vimrc
        Path = "$env:USERPROFILE\.gitconfig"
        Target = "$env:DOTFILES\wsl\git\.gitconfig"
    },
    @{ # jetbrains idea vimrc
        Path = "$env:USERPROFILE\.config\git\.gitignore"
        Target = "$env:DOTFILES\wsl\git\.config\git\.gitignore"
    },
    @{ # jetbrains idea vimrc
        Path = "$env:USERPROFILE\.ideavimrc"
        Target = "$env:DOTFILES\all\.ideavimrc"
    }
)

foreach ($link in $links) {
    New-Item -ItemType SymbolicLink -Force -Path $link.Path -Target $link.Target
}
