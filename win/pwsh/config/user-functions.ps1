function scan {
    & "G:\My Drive\Soft\SpaceSniffer.exe" scan "$pwd"
}
function total {
    & "C:\Program Files\totalcmd\TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
}

