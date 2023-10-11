. "alias_autocomplete.ps1"

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    AliasExtention -Mode "Space"
}
Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    AliasExtention -Mode "Enter"
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Alt+u -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('GoUpDirAndList')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Ctrl+w -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteWord()
}

function shellGpt($wordBeforeCursor) {
    if ($wordBeforeCursor -eq ",s") {
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

function shellGptMultiline($wordBeforeCursor) {
    if ($wordBeforeCursor -eq ",sm") {
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

