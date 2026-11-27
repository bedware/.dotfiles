# Dot-sourced from the PowerShell profile (install.ps1 adds the line).
# Turns each `name = command` from ./aliases into a function that appends its arguments.
foreach ($line in Get-Content -LiteralPath (Join-Path $PSScriptRoot 'aliases')) {
    if ($line -match '^\s*#' -or $line -notmatch '=') { continue }
    $name, $cmd = $line -split '=', 2
    Set-Item -Path "function:global:$($name.Trim())" -Value ([scriptblock]::Create("$($cmd.Trim()) @args"))
}
. (Join-Path $PSScriptRoot 'aliases.ps1')
