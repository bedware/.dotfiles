# Imports

Import-Module PSFzf
# Add-Type -Path "$env:DOTFILES/wsl/pwsh/.local/config/PSFzf.dll"

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
Set-PSReadLineKeyHandler -Chord Ctrl+w -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteWord()
}
Set-PSReadLineKeyHandler -Chord Ctrl+u -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
}

$fzfExclude = @('.git', '.npm')
$fzfParam = "--path-separator '/' --hidden --strip-cwd-prefix " + `
@($fzfExclude | ForEach-Object {"--exclude '$_'"}) -join " "
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+p -ScriptBlock {
    Invoke-FuzzyKillProcess
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+r -ScriptBlock {
    Invoke-FzfPsReadlineHandlerHistory
    [Microsoft.PowerShell.PSConsoleReadLine]::InvokePrompt()
}

Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+g -ScriptBlock {
    Invoke-Expression "fd --type f $fzfParam" | Invoke-Fzf -Color $color | ForEach-Object {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
    }
}

$color = 'dark'
$keyBindings = @{
    "ff" = {
        Invoke-Expression "fd --type f $fzfParam" | Invoke-Fzf -Color $color | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "fig" = {
        Invoke-Expression "git ls-files" | Invoke-Fzf -Color $color | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "gff" = {
        Invoke-Expression "fd --type f --no-ignore $fzfParam" | Invoke-Fzf -Color $color | ForEach-Object {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
        }
    }
    "fd" = {
        Invoke-Expression "fd --type d --follow $fzfParam" | Invoke-Fzf -Color $color | ForEach-Object { 
            RunExactCommand("Set-Location $_ | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
        }
    }
    "gfd" = {
        Invoke-Expression "fd --type d --follow --no-ignore $fzfParam" | Invoke-Fzf -Color $color | ForEach-Object { 
            RunExactCommand("Set-Location $_ | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
        }
    }
}

Set-PSReadLineKeyHandler -ViMode Command -Key Spacebar -ScriptBlock {
    Write-Host -NoNewLine "`e[4 q"

    $userInput = ""
    for ($i = 0; $i -lt 5; $i++) {
        $key = [System.Console]::ReadKey($true)  # ReadKey(true) suppresses the display of the key
        $userInput += $key.KeyChar

        if ($key.Key -eq 'Escape') {
            Write-Error "Key chord cancelled."
            [System.Media.SystemSounds]::Hand.Play()
            break
        }

        if ($key.Key -eq [System.ConsoleKey]::C -and $key.Modifiers -eq [System.ConsoleModifiers]::Control) {
            Write-Error "Key chord cancelled."
            [System.Media.SystemSounds]::Hand.Play()
            break
        }
        if ($keyBindings.ContainsKey($userInput)) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            &$keyBindings[$userInput]
            break
        }
    }
    Write-Host -NoNewLine "`e[2 q"
    if (-not $keyBindings.ContainsKey($userInput)) {
        [System.Media.SystemSounds]::Hand.Play()
    }
}

function Set-PSReadLineKeyHandlerBothModes($Chord, $ScriptBlock) {
    Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
        -ScriptBlock $PSBoundParameters.ScriptBlock
}
