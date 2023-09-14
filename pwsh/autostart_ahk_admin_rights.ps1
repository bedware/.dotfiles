# Run the following commands in an Administrator powershell prompt. 
# Be sure to specify the correct path to your desktop_switcher.ahk file. 

$A = New-ScheduledTaskAction -Execute "C:\Program Files\AutoHotkey\AutoHotkey.exe" -Argument "$env:USERPROFILE\.dotfiles\ahk\bedware.ahk"
$T = New-ScheduledTaskTrigger -AtLogon
$P = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
$S = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit 0
$D = New-ScheduledTask -Action $A -Principal $P -Trigger $T -Settings $S
Register-ScheduledTask -Force -TaskPath "AHK" -TaskName "AHK Autostart" -InputObject $D

