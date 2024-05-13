$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';
$v=(Get-ItemProperty -Path $p).Settings;
if ($null -eq $global:taskbarToggle -or $global:taskbarToggle -eq 2){
    $v[8]=$global:taskbarToggle;
    $global:taskbarToggle = 3;
} else {
    $v[8]=$global:taskbarToggle;
    $global:taskbarToggle = 2;
}
Set-ItemProperty -Path $p -Name Settings -Value $v;
Stop-Process -f -ProcessName explorer
