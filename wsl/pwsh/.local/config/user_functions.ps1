function wpwsh {
    & "/mnt/c/Program Files/PowerShell/7/pwsh.exe"
}
function Set-LocationToParentAndList {
    Set-LocationAndList("..")
}

function Set-LocationAndList([string]$Path = "~") {
    Set-Location $Path && Get-ChildItem -Force | Format-Table -AutoSize
}

function Edit-AndComeBack([string]$TempPath = ".") {
    $currentDir = Get-Location
    Set-Location $TempPath
    vi .
    Set-Location $currentDir
}
function Count-History {
   Get-Content (Get-PSReadlineOption).HistorySavePath | Measure-Object -Line
}
function Deduplicate-HistoryOnExit {
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        $Path = (Get-PSReadlineOption).HistorySavePath
        Get-Content $Path | ForEach-Object {$_.Trim()}| Select-Object -Unique | Set-Content -Path $Path
    }
    Write-Host "History will be cleared on exit"
}

function Save-Thought() {
    $filePath = "$HOME/thoughts.store"
    $todayDate = Get-Date -Format "yyyy.MM.dd"
    $todayDateTime = Get-Date -Format "yyyy.MM.dd HH:mm:ss"
    
    if (!(Select-String -Path $filePath -Pattern $todayDate)) {
        Add-Content -Path $filePath -Value $todayDate
    }
    Add-Content -Path $filePath -Value "$todayDateTime $args"
}

