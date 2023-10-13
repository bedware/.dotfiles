function CopyPathToClipboard {
    Get-Location | Set-Clipboard
}

function GoUpDirAndList {
    Set-Location .. && Get-ChildItem -Force | Format-Table -AutoSize
}

function GoToDirAndList {
    param(
            [string]$Path = "~"
    )
    Set-Location $Path && Get-ChildItem -Force | Format-Table -AutoSize
}
