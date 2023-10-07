$global:BlankAliases = @()
$global:IgnoredAliases = @(
    "*",
    "?",
    "%",
    "cat",
    "clear",
    "compare",
    "copy",
    "diff",
    "echo",
    "erase",
    "group",
    "history",
    "kill",
    "ls",
    "man",
    "measure",
    "mount",
    "move",
    "ps",
    "r",
    "rm",
    "select",
    "set",
    "sleep",
    "sort",
    "start",
    "type",
    "where",
    "write"
)

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    AliasExtention -SpaceMode $true
}

Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    AliasExtention
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
Set-PSReadLineKeyHandler -Chord Alt+u -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::DeleteLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('cd ..')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function Add-BlankAlias {
    param($Name, $Value)

    Set-Alias -Scope Global -Name $Name -Value $Value
    $global:BlankAliases += $Name
}

function Add-IgnoredAlias {
    param($Name, $Value)

    Set-Alias -Scope Global -Name $Name -Value $Value
    $global:IgnoredAliases += $Name
}

function AliasExtention {
    param($SpaceMode = $false)
    $wordBeforeCursorStartIndex = $null
    $wordBeforeCursor = GetLastWordBeforeCursor([ref]$wordBeforeCursorStartIndex)
    $alias = GetAliasByWord($wordBeforeCursor)
    if ($null -ne $alias)
    {
        if ($global:IgnoredAliases -contains $wordBeforeCursor)
        {
            if ($SpaceMode) {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            }
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($wordBeforeCursorStartIndex, $wordBeforeCursor.Length, $alias.Definition)
            if ($global:BlankAliases -notcontains $wordBeforeCursor) {
                if ($SpaceMode) {
                    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ") 
                }
            }
        }
    } else {
        if (-not [string]::IsNullOrEmpty($wordBeforeCursor) -and $wordBeforeCursor.Chars(0) -eq ",") {
            if ($wordBeforeCursor -eq ",s") {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace($wordBeforeCursorStartIndex, $wordBeforeCursor.Length, "sgpt `'`'")
                [Microsoft.PowerShell.PSConsoleReadLine]::BackwardChar()
                return 
            }
            if ($wordBeforeCursor -eq ",sm") {
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace($wordBeforeCursorStartIndex, $wordBeforeCursor.Length, "sgpt @`'`n")
                return 
            }
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($wordBeforeCursorStartIndex, $wordBeforeCursor.Length, $wordBeforeCursor.Substring(1, $wordBeforeCursor.Length - 1))
        }
        if ($SpaceMode) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
        }
    }
}

function GetAliasByWord($wordBeforeCursor) {
    if (-not [string]::IsNullOrEmpty($wordBeforeCursor) -and (Get-Alias).Name -Contains $wordBeforeCursor) {
        return Get-Alias -Name $wordBeforeCursor
    }
    return $null
}

function GetLastWordBeforeCursor([ref]$wordBeforeCursorStartIndex = $null) {
    $buffer = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursor)

    $subBuffer = $buffer.Substring(0, $cursor)
    $wordBeforeCursorStartIndex.Value = $subBuffer.LastIndexOf(" ") -eq -1 ? 0 : $subBuffer.LastIndexOf(" ") + 1
    $length = $cursor - $wordBeforeCursorStartIndex.Value
    $wordBeforeCursor = $subBuffer.Substring($wordBeforeCursorStartIndex.Value, $length)
    return $wordBeforeCursor
}

