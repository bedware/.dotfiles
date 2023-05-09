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

$global:BlankAliases = @()
$global:IgnoredAliases = @()
$global:IgnoredAliases += "*"
$global:IgnoredAliases += "?"
$global:IgnoredAliases += "diff"

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    AliasSpaceExtention -SpaceMode $true
}

Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
    AliasSpaceExtention
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function AliasSpaceExtention {
    param($SpaceMode = $false)
    $lastSpaceIndex = $null
    $lastWord = LastWordBeforeCursor([ref]$lastSpaceIndex)
    $alias = GetAliasByWord($lastWord)
    if ($alias -ne $null) {
        if ($global:IgnoredAliases -contains $lastWord) {
            if ($SpaceMode) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ") }
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($lastSpaceIndex, $lastWord.Length, $alias.Definition)
            if ($global:BlankAliases -notcontains $lastWord) {
                if ($SpaceMode) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ") }
            }
        }
    } else {
        if ($SpaceMode) { [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ") }
    }
}

function GetAliasByWord($alias) {
    if (-not [string]::IsNullOrEmpty($lastWord)) {
        $alias = Get-Alias -Name $lastWord -ErrorAction SilentlyContinue
        if ($alias -ne $null) {
            return $alias
        }
    }
    return $null
}

function LastWordBeforeCursor([ref]$lastSpaceIndex = $null) {
    $buffer = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursor)

    $subBuffer = $buffer.Substring(0, $cursor)
    $lastSpaceIndex.Value = $subBuffer.LastIndexOf(" ")
    $lastSpaceIndex.Value = ($lastSpaceIndex.Value -eq -1) ? 0 : $lastSpaceIndex.Value + 1
    $length = $cursor - $lastSpaceIndex.Value
    $lastWord = $subBuffer.Substring($lastSpaceIndex.Value, $length)
    return $lastWord
}

