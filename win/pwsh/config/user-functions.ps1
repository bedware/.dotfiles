function scan {
    & "$env:HOME\iCloudDrive\Soft\SpaceSniffer.exe" scan "$pwd"
}
function total {
    & "c:\Program Files\totalcmd\TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
}

