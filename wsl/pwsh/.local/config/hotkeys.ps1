# Imports

Import-Module PSFzf

# Functions

function Invoke-FzfPsReadlineHandlerHistory {
    $result = $null
    try {
        $line = $null
        $cursor = $null
        [Microsoft.PowerShell.PSConsoleReadline]::GetBufferState([ref]$line, [ref]$cursor)

        $reader = New-Object PSFzf.IO.ReverseLineReader -ArgumentList $((Get-PSReadlineOption).HistorySavePath)

        $fileHist = @{}
        $reader.GetEnumerator() | ForEach-Object {
            if (-not $fileHist.ContainsKey($_)) {
                $fileHist.Add($_,$true)
                $_
            }
        } | Invoke-Fzf -Color 16 -Query "$line" -NoSort -Bind ctrl-r:toggle-sort | ForEach-Object { $result = $_ }
    }
    finally
    {
        $reader.Dispose()
    }
    if (-not [string]::IsNullOrEmpty($result)) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,$line.Length,$result)
    }
}

function Set-PSReadLineKeyHandlerBothModes($Chord, $ScriptBlock) {
    Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
        -ScriptBlock $PSBoundParameters.ScriptBlock
    if ((Get-PSReadLineOption).EditMode -eq "Vi") {
        Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
            -ScriptBlock $PSBoundParameters.ScriptBlock `
            -ViMode Command
    }
}
function RunExactCommand($cmd) {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($cmd)
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# Hotkeys

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    AliasExtention -Mode "Space"
}
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    AliasExtention -Mode "Enter"
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -ViMode Command -Key Enter -ScriptBlock {
    AliasExtention -Mode "Enter"
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -ViMode Command -Key V -ScriptBlock {
    RunExactCommand('vi .')
}
Set-PSReadLineKeyHandlerBothModes -Chord Alt+h -ScriptBlock {
    RunExactCommand('cd')
}
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+k -ScriptBlock {
    RunExactCommand('Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize')
}
Set-PSReadLineKeyHandlerBothModes -Chord Alt+k -ScriptBlock {
    RunExactCommand('Clear-Host && Get-ChildItem | Format-Table -AutoSize')
}
Set-PSReadLineKeyHandlerBothModes -Chord Alt+p -ScriptBlock {
    RunExactCommand('Get-Location | Set-Clipboard')
}
Set-PSReadLineKeyHandlerBothModes -Chord Alt+u -ScriptBlock {
    RunExactCommand('Set-LocationToParentAndList')
}
Set-PSReadLineKeyHandlerBothModes -Chord Alt+U -ScriptBlock {
    &$keyBindings["fu"]
}
Set-PSReadLineKeyHandler -Chord Ctrl+w -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteWord()
}
Set-PSReadLineKeyHandler -Chord Ctrl+u -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
}

Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+p -ScriptBlock {
    Invoke-FuzzyKillProcess
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+r -ScriptBlock {
    Invoke-FzfPsReadlineHandlerHistory
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

$color = 'dark'
$keyBindings = @{
    "ff" = {
        Invoke-Expression $env:FD_FIND_FILE_COMMAND  | Invoke-Fzf -Color $color | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "fig" = {
        Invoke-Expression $env:FILES_IN_GIT_COMMAND | Invoke-Fzf -Color $color -NoSort | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "gff" = {
        Invoke-Expression $env:FD_GLOBAL_FIND_FILE_COMMAND | Invoke-Fzf -Color $color -NoSort | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "fd" = {
        Invoke-Expression $env:FD_FIND_DIRECTORY_COMMAND | Invoke-Fzf -Color $color | ForEach-Object {
            RunExactCommand("Set-Location '$_' | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
        }
    }
    "fu" = {
        $counter = 1
        Set-LocationToUpperDir | ForEach-Object {
            "$_`:$counter"
            $counter++
        } | Invoke-Fzf -Color $color | ForEach-Object {
            $_.Substring(0, $_.IndexOf(":"))
        } | ForEach-Object {
            RunExactCommand("Set-Location '$_' | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
        }
    }
    "gfd" = {
        Invoke-Expression $env:FD_GLOBAL_FIND_DIRECTORY_COMMAND| Invoke-Fzf -Color $color | ForEach-Object {
            RunExactCommand("Set-Location '$_' | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
        }
    }
}

function Set-LocationToUpperDir {
    $results = @()
    $remainder = (Get-Location).ToString()
    while ($remainder.Contains([System.IO.Path]::DirectorySeparatorChar)) {
        $aboveIndex = $remainder.LastIndexOf([System.IO.Path]::DirectorySeparatorChar)
        $upperDir = $remainder.Substring(0, $aboveIndex)
        $results += $upperDir
        $remainder = $upperDir
    }
    $results[$results.Length - 1] = [System.IO.Path]::DirectorySeparatorChar
    return $results
}

function _play_sound {
    if ($IsWindows) {
        [System.Media.SystemSounds]::Hand.Play()
    } else {
        Write-Host "`a"
    }
}

Set-PSReadLineKeyHandler -ViMode Command -Key Spacebar -ScriptBlock {
    # Change cursor to _
    Write-Host -NoNewLine "`e[4 q"

    $userInput = ""
    for ($i = 0; $i -lt 5; $i++) {
        $key = [System.Console]::ReadKey($true)  # ReadKey(true) suppresses the display of the key
        $userInput += $key.KeyChar

        # Esc
        if ($key.Key -eq 'Escape') {
            Write-Error "Key chord cancelled (Esc)."
            _play_sound
            break
        }

        # Ctrl-C
        if ($key.Key -eq [System.ConsoleKey]::C -and $key.Modifiers -eq [System.ConsoleModifiers]::Control) {
            Write-Error "Key chord cancelled (Ctrl + C)."
            _play_sound
            break
        }

        # Other
        if ($keyBindings.ContainsKey($userInput)) {
            &$keyBindings[$userInput]
            break
        }
    }

    # Revert cursor to []
    Write-Host -NoNewLine "`e[2 q"

    if (-not $keyBindings.ContainsKey($userInput)) {
        _play_sound
    }
}

function Set-PSReadLineKeyHandlerBothModes($Chord, $ScriptBlock) {
    Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
        -ScriptBlock $PSBoundParameters.ScriptBlock
}
