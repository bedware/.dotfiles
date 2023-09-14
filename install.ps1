# INSTALL SIMLINKS

if (-not $IsWindows) {
    Write-Error "Script created for Windows system. Aborting..."
    Sleep 5
    Exit
}
$env:DOTFILES="$env:HOME\.dotfiles"

# Define the list of symlinks
$links = @(
    @{ # pwsh
        Path = "$env:HOME\Documents\Powershell\Microsoft.PowerShell_profile.ps1"
        Target = "$env:DOTFILES\wsl\pwsh\profile.ps1"
    },
    @{ # pwsh scripts
        Path = "$env:HOME\Documents\Powershell\Scripts"
        Target = "$env:DOTFILES\pwsh\"
    },
    @{ # neovim
        Path = "$env:LOCALAPPDATA\nvim"
        Target = "$env:DOTFILES\wsl\nvim"
    },
    @{ # widows terminal
        Path = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
        Target = "$env:DOTFILES\wt\settings.json"
    },
    @{ # jetbrains idea vimrc
        Path = "$env:HOME\.ideavimrc"
        Target = "$env:DOTFILES\.ideavimrc"
    },
    @{ # total commander
        Path = "$env:HOME\wincmd.ini"
        Target = "$env:DOTFILES\wincmd.ini"
    }
)

foreach ($link in $links) {
    New-Item -ItemType SymbolicLink -Force -Path $link.Path -Target $link.Target
}

# CREATE AUTOSTARTUP TASKS

#.\pwsh\autostart_ahk_admin_rights.ps1
