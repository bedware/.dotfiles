$startingDir = pwd
# Make list of files to backup
Set-Location "$env:USERPROFILE\Work\" 

# Make folder where to store
New-Item -ItemType Directory -Path "$env:USERPROFILE\OneDrive\Backup\Work" -Force

# Compress
$filename = "backup_" + (Get-Date).ToString('yyyyMMdd_HHmmss') + ".zip"
7z a -tzip "$env:USERPROFILE\OneDrive\Backup\Work\$filename" *

Set-Location $startingDir
