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
    if ([Environment]::GetCommandLineArgs().Length -eq 1 `
        -or `
        [Environment]::GetCommandLineArgs() -contains "-Interactive") {
        # We are in an interactive shell.
        Write-Host -NoNewLine "`e[6 q"
    }
    $profile.Dispose()
    $runspace.Close()
    $runspace.Dispose()
}

