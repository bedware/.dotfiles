param(
    [Parameter(Mandatory = $true)]
    [string]$App,

    [Parameter(Mandatory = $true)]
    [ValidateSet("default", "shell")]
    [string]$Mode,

    [string]$Path
)
if ($IsWindows) {
    $DEFAULT_APP_DIR = "$HOME/.local/bin"
} elseif ($IsLinux) {
    $DEFAULT_APP_DIR = "/bin"
}
$candidates = @{}
# Java base
$candidates["java"] = "$env:HOME/.sdkman/candidates/java"
$candidates["gradle"] = "$env:HOME/.sdkman/candidates/gradle"
$candidates["mvn"] = "$env:HOME/.sdkman/candidates/maven"
# Java ecosystem
$candidates["jbang"] = "$env:HOME/.sdkman/candidates/jbang"
$candidates["jmeter"] = "$env:HOME/.sdkman/candidates/jmeter"
$candidates["karaf"] = "$env:HOME/.sdkman/candidates/karaf"
# Other
$candidates["springboot"] = "$env:HOME/.sdkman/candidates/springboot"
$candidates["labctl"] = "$env:HOME/.local/.iximiuz"

if ($candidates.ContainsKey($App)) {

    $selected = Get-ChildItem $candidates[$App] | Select-Object -ExpandProperty Name | Invoke-Fzf

    switch ($Mode) {
        "default" {
            $link = "$DEFAULT_APP_DIR/$App"
            Write-Host $link

            $target = $candidates[$App]
            $target = "$target/$selected/bin/$App"
            Write-Host $target

            if ($IsWindows) {
                New-Item -Force -ItemType SymbolicLink -Path $link -Target $target
            } elseif ($IsLinux) {
                Invoke-Expression "sudo ln -f -s $target $link"
            }
        }
        "shell" {
            $target = $candidates[$App]
            $target = "$target/$selected/bin"
            Write-Host $target

            $tmp = ,$target + ($env:PATH -split [IO.Path]::PathSeparator)
            $env:PATH = ($tmp -join [IO.Path]::PathSeparator)
        }
    }
} else {
    Write-Host "Sorry that candidate ($App) doesn't supported. Check '$PSCommandPath'."
}

function Test-CommandInPath($command){
    if (Get-Command $command -ErrorAction SilentlyContinue) {
        Write-Output "Command '$command' is available."
        return $true
    } else {
        Write-Output "Command '$command' is not available."
        return $false
    }
}
# Test-CommandInPath("java")
