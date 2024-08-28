param(
    [string]$SetDefault
)

if ($SetDefault) {
    Write-Host "`$SetDefault was provided"
    Write-Host "`$SetDefault = $SetDefault"
} else {
    Write-Host "No `$SetDefault provided"

}

function Check-IfInPath($command){
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Write-Output "Command '$command' is available."
    } else {
        Write-Output "Command '$command' is not available."
    }
}

Check-IfInPath("java")
Check-IfInPath("javas")
