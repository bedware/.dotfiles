# Get the current state of the proxy
$currentProxyState = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable

# Invert the proxy state
$newProxyState = -not $currentProxyState.ProxyEnable

# Set the new proxy state
Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable -Value ([int]$newProxyState)

# Notify the system about the proxy settings change
# $null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject(New-Object -ComObject WScript.Network)

# Output the new state
if ($newProxyState) {
    Write-Output "Proxy has been enabled."
} else {
    Write-Output "Proxy has been disabled."
}

