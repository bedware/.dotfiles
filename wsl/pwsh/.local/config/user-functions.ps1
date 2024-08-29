function wpwsh {
    & "/mnt/c/Program Files/PowerShell/7/pwsh.exe" $args
}

function upwsh {
    & "C:\WINDOWS\system32\wsl.exe" -d "Ubuntu-22.04" $args
}

function Set-LocationToParentAndList {
    Set-LocationAndList("..")
}

function Set-LocationAndList([string]$Path = "~") {
    if (Test-Path -Path $path -PathType Container) {
        Set-Location $Path && Get-ChildItem -Force | Format-Table -AutoSize
    } else {
        Write-Output "The path is not a directory."
    }
}

function Edit-AndComeBack([string]$TempPath = ".") {
    $currentDir = Get-Location
    Set-Location $TempPath
    vi .
    Set-Location $currentDir
}

function Show-HistoryCount {
   Get-Content (Get-PSReadlineOption).HistorySavePath | Measure-Object -Line
}

function Clear-HistoryEntriesOnExit {
    Register-EngineEvent -SourceIdentifier PowerShell.Exiting -SupportEvent -Action {
        $Path = (Get-PSReadlineOption).HistorySavePath
        Get-Content $Path | ForEach-Object {$_.Trim()}| Select-Object -Unique | Set-Content -Path $Path
    }
    Write-Host "History will be cleared on exit"
}

function Edit-LastError {
    $stack = $error | Select-Object -ExpandProperty ScriptStackTrace | Out-String | ForEach-Object { $_ -split "`n" }
    $stack[0] -match ".*, (.+): line (\d+)"
    $line = $matches[2]
    $file = $matches[1]
    vi +$line +"normal! zz" $file
}
