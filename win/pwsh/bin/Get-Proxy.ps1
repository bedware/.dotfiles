# Get the current state of the proxy
$currentProxyState = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable

if ($currentProxyState.ProxyEnable -eq 1) {
    Write-Output "Proxy has been enabled."
} else {
    Write-Output "Proxy has been disabled."
}

