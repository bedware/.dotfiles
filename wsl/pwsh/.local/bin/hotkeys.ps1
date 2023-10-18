Add-Type -Path "$env:DOTFILES/wsl/pwsh/.local/bin/PSFzf.dll"

function Set-PSReadLineKeyHandlerBothModes($Chord, $ScriptBlock) {
    # Set-PSReadLineKeyHandler -ViMode Command @Args
    Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
        -ScriptBlock $PSBoundParameters.ScriptBlock
    Set-PSReadLineKeyHandler -Chord $PSBoundParameters.Chord `
        -ScriptBlock $PSBoundParameters.ScriptBlock `
        -ViMode Command
}

# Alias extention

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    AliasExtention -Mode "Space"
}
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    AliasExtention -Mode "Enter"
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

# General moves

Set-PSReadLineKeyHandlerBothModes -Chord Alt+u -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('Set-LocationToParentAndList')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+w -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteWord()
}

# Fzf

$fzfExclude = @('.git', 'AppData', '.npm', '.m2', '.jdks', '.gradle')
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

$fileCommand = "fd --type f $fzfParam"
Set-PSReadLineKeyHandlerBothModes -Chord Ctrl+f -ScriptBlock {
    Invoke-Expression $fileCommand | Invoke-Fzf | ForEach-Object {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert($_)
    }
}

# ChatGPT

function shellGpt($wordBeforeCursor)
{
    # Must start with coma
    if ($wordBeforeCursor -eq ",s")
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $wordBeforeCursorStartIndex,
            $wordBeforeCursor.Length,
            "sgpt `'`'"
        )
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
        return $true
    }
    return $false
}
$global:AbbrFunctions += "shellGpt"

function shellGptMultiline($wordBeforeCursor)
{
    # Must start with coma
    if ($wordBeforeCursor -eq ",sm")
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
            $wordBeforeCursorStartIndex,
            $wordBeforeCursor.Length,
            "sgpt @`'`n"
        )
        return $true
    }
    return $false
}
$global:AbbrFunctions += "shellGptMultiline"

# Not mine

# $((Get-PSReadlineOption).HistorySavePath)
# Set-PsFzfOption -PSReadlineChordReverseHistory "Ctrl+r"
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
