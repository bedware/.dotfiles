param(
    [switch]$Work,
    [switch]$Personal
)

$startingDir = Get-Location

if ($Work)
{
    Write-Output "Backing up work files"
    # Make list of files to backup
    Set-Location "$env:USERPROFILE\Work\" 
    # Compress
    $filename = (Get-Date).ToString('yyyy-MM-dd') + "_backup_work.zip"
    7z a -tzip "$env:USERPROFILE\OneDrive\Backup\$filename" *
}
if ($Personal)
{
    Write-Output "Backing up personal files"
    Set-Location "$env:USERPROFILE\Personal\" 
    $filename = (Get-Date).ToString('yyyy-MM-dd') + "_backup_personal.zip"
    # (Get-Date).ToString('yyyyMMdd_HHmmss')
    7z a -tzip "$env:USERPROFILE\OneDrive\Backup\$filename" *
}

Set-Location $startingDir
