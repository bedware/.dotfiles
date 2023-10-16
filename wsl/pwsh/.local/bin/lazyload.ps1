param (
    [Parameter(Mandatory=$true)]
    [ScriptBlock]$Modules,
    [ScriptBlock]$AfterModulesLoad
)

$runspace = [RunspaceFactory]::CreateRunspace()
$profile = [PowerShell]::Create()
$profile.Runspace = $runspace
$runspace.Open()
[void]$profile.AddScript($Modules)
[void]$profile.BeginInvoke()

$null = Register-ObjectEvent -InputObject $profile -EventName InvocationStateChanged -Action {
    Invoke-Command $Modules
    Invoke-Command $AfterModulesLoad
    Write-Host -NoNewLine "`e[6 q"
    $profile.Dispose()
    $runspace.Close()
    $runspace.Dispose()
}

