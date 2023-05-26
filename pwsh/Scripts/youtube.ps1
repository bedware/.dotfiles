param(
    [switch]$OnlyAudio = $false,
    [string]$URL = $null
)
$parameters = @()
$parameters += "youtube-dl"

if ($OnlyAudio)
{
    $parameters += "-x --audio-format mp3"
}

if ($URL -ne $null)
{
    $parameters += "-o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $URL"
    Invoke-Expression ($parameters -join " ")
} else
{
    Write-Output "No URL specified"
}
