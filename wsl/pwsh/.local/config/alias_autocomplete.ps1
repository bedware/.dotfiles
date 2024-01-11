$global:BlankAliases = @()
$global:IgnoredAliases = @(
    "*", "?", "%",
    "cat", "clear", "compare", "copy",
    "diff",
    "echo", "erase", "group",
    "history",
    "kill",
    "ls",
    "man", "measure", "mount", "move", "ps",
    "r", "rm", "select",
    "set", "sleep", "sort", "start",
    "type",
    "where", "write"
)
$global:AbbrFunctions = @()

function New-BlankAlias {
    param($Name, $Value)

    Set-Alias -Scope Global -Name $Name -Value $Value
    $global:BlankAliases += $Name
}

function New-IgnoredAlias {
    param($Name, $Value)

    Set-Alias -Scope Global -Name $Name -Value $Value
    $global:IgnoredAliases += $Name
}

function AliasExtention {
    param($Mode)
    $wordBeforeCursorStartIndex = $null
    $wordBeforeCursor = GetLastWordBeforeCursor([ref]$wordBeforeCursorStartIndex)
    $alias = GetAliasByWord($wordBeforeCursor)
    if ($null -ne $alias) {
        if ($global:IgnoredAliases -notcontains $wordBeforeCursor) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                $wordBeforeCursorStartIndex,
                $wordBeforeCursor.Length,
                $alias.Definition
            )
        }
    } else {
        $inputCanBeAbbr = -not [string]::IsNullOrEmpty($wordBeforeCursor) -and $wordBeforeCursor.Chars(0) -eq ","
            if ($inputCanBeAbbr) {
                foreach ($func in $global:AbbrFunctions) {
                    if (Invoke-Expression "$func('$wordBeforeCursor')") {
                        return
                    }
                }
                [Microsoft.PowerShell.PSConsoleReadLine]::Replace(
                    $wordBeforeCursorStartIndex,
                    $wordBeforeCursor.Length,
                    $wordBeforeCursor.Substring(1, $wordBeforeCursor.Length - 1)
                )
            }
    }
    if ($Mode -eq "Space" -and $global:BlankAliases -notcontains $alias) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
    }
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

function GetAliasByWord($wordBeforeCursor) {
    if (-not [string]::IsNullOrEmpty($wordBeforeCursor) -and (Get-Alias).Name -Contains $wordBeforeCursor) {
        return Get-Alias -Name $wordBeforeCursor
    }
    return $null
}

