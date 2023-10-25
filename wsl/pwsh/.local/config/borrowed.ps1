function total {
    $currentPath = Get-Location
    if ($IsWindows) {
        & "c:\Program Files\totalcmd\TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
    } elseif ($IsLinux) {
        $currentPath = "\\wsl.localhost\Ubuntu-22.04" + $currentPath
        & "/mnt/c/Program Files/totalcmd/TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
    }
}

function podman {
    & "/mnt/c/Program Files/RedHat/Podman/podman.exe" $args
}
