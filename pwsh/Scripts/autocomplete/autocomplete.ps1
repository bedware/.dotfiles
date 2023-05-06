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

Set-PSReadLineKeyHandler -Key Spacebar -ScriptBlock {
    $buffer = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$buffer, [ref]$cursor)

    $subBuffer = $buffer.Substring(0, $cursor)
    $lastSpaceIndex = $subBuffer.LastIndexOf(" ")
    $lastSpaceIndex = ($lastSpaceIndex -eq -1) ? 0 : $lastSpaceIndex + 1
    $length = $cursor - $lastSpaceIndex
    $lastWord = $subBuffer.Substring($lastSpaceIndex, $length)

    $alias = Get-Alias -Name $lastWord -ErrorAction SilentlyContinue

    if ($alias) {
        if ($global:IgnoredAliases -contains $lastWord) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
        } else {
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($lastSpaceIndex, $lastWord.Length, $alias.Definition)
            if ($global:BlankAliases -notcontains $lastWord) {
                [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
            }
        }
    } else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(" ")
    }
}


# function LastWordBeforeCursor {
# }
# Set-PSReadLineKeyHandler -Key Enter -ScriptBlock {
#     [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
# }
