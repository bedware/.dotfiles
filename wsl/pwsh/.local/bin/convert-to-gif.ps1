param(
    [string]$original = $null
)
if ($null -ne $original) {
    $ext = Get-ChildItem $original | Select-Object -ExpandProperty Extension
    $output = $original.Replace($ext, ".gif")
    ffmpeg -i $original $output
    & "$output"
    Write-Host "FILEPATH OF GIF: $output"
    Set-Clipboard "`"$output`""
}

