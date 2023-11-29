function total {
    param(
        [string]$Left = $null,
        [string]$Right = $null
    )
    if ($null -eq $Left -or $null -eq $Right) {
        $currentPath = Get-Location
        $currentPath = "\\wsl.localhost\Ubuntu-22.04" + $currentPath
        & "/mnt/c/Program Files/totalcmd/TOTALCMD64.EXE" /O /T /L="$currentPath" /R="$currentPath"
    } else {
        $Left = "\\wsl.localhost\Ubuntu-22.04" + $Left
        $Right = "\\wsl.localhost\Ubuntu-22.04" + $Right
        & "/mnt/c/Program Files/totalcmd/TOTALCMD64.EXE" /N /L="$Left" /R="$Right"
    }
}

# function podman {
#     & "/mnt/c/Program Files/RedHat/Podman/podman.exe" $args
# }
