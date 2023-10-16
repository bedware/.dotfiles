function Copy-PathToClipboard {
    Get-Location | Set-Clipboard
}

function Set-LocationToParentAndList {
    Set-Location .. && Get-ChildItemCompact
}

function Set-LocationAndList([string]$Path = "~") {
    Set-Location $Path && Get-ChildItemCompact
}

function Get-ChildItemCompact([string]$Path = ".") {
    Get-ChildItem -Force $Path | Format-Table -AutoSize
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
