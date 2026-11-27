# PowerShell-only aliases (Windows). Shared ones live in ./aliases.
function global:l { Get-ChildItem -Force @args }
