function Set-PSReadLineKeyHandlerBothModes($Chord, $ScriptBlock) {
    # Set-PSReadLineKeyHandler -ViMode Command @Args
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

# Alias extention

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

# General moves

Set-PSReadLineKeyHandlerBothModes -Chord Alt+h -ScriptBlock {
    RunExactCommand('cd')
}
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+k -ScriptBlock {
    RunExactCommand('Get-ChildItemCompact')
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

# Fzf
Import-Module PSFzf

$fzfExclude = @('.git', 'AppData', '.npm', '.oh-my-zsh', '.tmp', '.cache',
                '.jdks', '.gradle', '.java', '.lemminx')
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

$dirCommand = "fd --type d --follow $fzfParam"
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+g -ScriptBlock {
    Invoke-Expression $dirCommand | Invoke-Fzf | ForEach-Object { 
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("Set-LocationAndList $_")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}
Set-PSReadLineKeyHandler -ViMode Command -Key g -ScriptBlock {
    Invoke-Expression $dirCommand | Invoke-Fzf | ForEach-Object { 
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("Set-LocationAndList $_")
        [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
    }
}

$fileCommand = "fd --type f $fzfParam"
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+f -ScriptBlock {
    Invoke-Expression $fileCommand | Invoke-Fzf | ForEach-Object {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
    }
}

Add-Type -Path "$env:DOTFILES/wsl/pwsh/.local/config/PSFzf.dll"
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
		} | Invoke-Fzf -Query "$line" -NoSort -Bind ctrl-r:toggle-sort | ForEach-Object { $result = $_ }
	}
	finally
	{
		$reader.Dispose()
	}
	if (-not [string]::IsNullOrEmpty($result)) {
		[Microsoft.PowerShell.PSConsoleReadLine]::Replace(0,$line.Length,$result)
	}
}

