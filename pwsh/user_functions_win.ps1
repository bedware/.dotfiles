function scan {
    & "$env:HOME\OneDrive\Soft\SpaceSniffer.exe" scan "$pwd"
}

function total {
    $currentPath = Get-Location
    & "c:\Program Files\totalcmd\TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
}

