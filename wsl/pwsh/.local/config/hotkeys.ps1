
# Imports

Import-Module PSFzf
Add-Type -Path "$env:DOTFILES/wsl/pwsh/.local/config/PSFzf.dll"

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
# Ctrl+f (Filtered folders)
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+f -ScriptBlock {
    Invoke-Expression "fd --type d --follow $fzfParam" | Invoke-Fzf -Color 16 | ForEach-Object { 
        RunExactCommand("Set-Location $_ | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
    }
}
# Ctrl+g (Global folders)
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+g -ScriptBlock {
    Invoke-Expression "fd --type d --follow --no-ignore $fzfParam" | Invoke-Fzf -Color 16 | ForEach-Object { 
        RunExactCommand("Set-Location $_ | Clear-Host && Get-ChildItem -Force | Format-Table -AutoSize")
    }
}
# Alt+f (Filtered files)
Set-PSReadLineKeyHandlerBothModes -Chord Alt+f -ScriptBlock {
    Invoke-Expression "fd --type f $fzfParam" | Invoke-Fzf -Color 16 | ForEach-Object {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
    }
}
# Alt+g (Global files)
Set-PSReadLineKeyHandlerBothModes -Chord Alt+g -ScriptBlock {
    Invoke-Expression "fd --type f --no-ignore $fzfParam" | Invoke-Fzf -Color 16 | ForEach-Object {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
    }
}

