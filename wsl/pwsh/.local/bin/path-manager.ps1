param(
    [Parameter(Mandatory = $true)]
    [string]$App,

    [Parameter(Mandatory = $true)]
    [ValidateSet("default", "shell")]
    [string]$Mode,

    [string]$AppVersion
)

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

class PathManager {
    [hashtable]$candidates

    PathManager($candidates){
        $this.candidates = $candidates
    }

    # factory method
    [void] setCandidate($App, $Mode, $AppVersion) {
        $this._checkApp($App)
        $selected = $this._findSelectedVersion($App, $AppVersion)
        $target = $this.candidates[$App]

        $bin = "$target/$selected/bin"

        Write-Host "$Mode mode"
        switch ($Mode) {
            "default" {
                Write-Host "target: $target, selected: $selected"
                $this.setDefaultCandidate($target, $selected)
            }
            "shell" {
                Write-Host "bin: $bin"
                $this.setShellCandidate($bin)
            }
        }
    }

    [void] setDefaultCandidate($target, $selected) {
        throw("Must be overriden")
    }

    [void] setShellCandidate($bin) {
        $tmp = ,$bin + ($env:PATH -split [IO.Path]::PathSeparator)
        $env:PATH = ($tmp -join [IO.Path]::PathSeparator)
    }

    hidden [void] _checkApp($App) {
        if (!$this.candidates.ContainsKey($App)) {
            throw("Sorry that candidate ($App) doesn't supported. Check '$PSCommandPath'.")
        }
    }
    hidden [string] _findSelectedVersion($App, $AppVersion){
        $pathToCandidate = $this.candidates[$App]
        if (-not (Test-Path $pathToCandidate)) {
            throw("Candidate passed as an argument ($pathToCandidate) doesn't exist!")
        }
        if ($AppVersion) {
            $pathToCandidate = $this.candidates[$App] + "/$AppVersion"
            if (Test-Path ($pathToCandidate)) {
                $selected = $AppVersion
            } else {
                throw("Candidate passed as an argument ($pathToCandidate) doesn't exist!")
            }
        } else {
            $selected = Get-ChildItem $this.candidates[$App] | Select-Object -ExpandProperty Name | Invoke-Fzf
            if (!$selected) {
                throw("Candidate wasn't selected in fzf")
            }
        }
        return $selected
    }

    # testCommandInPath("java")
    static [bool] testCommandInPath($command) {
        if (Get-Command $command -ErrorAction SilentlyContinue) {
            Write-Output "Command '$command' is available."
            return $true
        } else {
            Write-Output "Command '$command' is not available."
            return $false
        }
    }

    static [PathManager] getInstance($candidates) {
        if ($global:IsWindows) {
            return [WindowsPathManager]::new($candidates)
        } else {
            return [LinuxPathManager]::new($candidates)
        }
    }
}

class WindowsPathManager : PathManager {

    WindowsPathManager([hashtable]$candidates) : base($candidates) {}

    [void] setDefaultCandidate($target, $selected) {
        $defaultLink = "$target/default"
        New-Item -Force -ItemType SymbolicLink -Path $defaultLink -Target "$target/$selected"

        $defaultBinLink = "$defaultLink/bin"
        $pathContent = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User) -split [IO.Path]::PathSeparator
        if (!$pathContent.Contains($defaultBinLink)) {
            $pathContent += $defaultBinLink
            [Environment]::SetEnvironmentVariable("PATH", ($pathContent -join [IO.Path]::PathSeparator), [EnvironmentVariableTarget]::User)
            Write-Host "Restart of session is required"
        }
    }
}

class LinuxPathManager : PathManager {

    LinuxPathManager([hashtable]$candidates) : base($candidates) {}

    [void] setDefaultCandidate($target, $selected) {
        $defaultLink = "$target/default"
        New-Item -Force -ItemType SymbolicLink -Path $defaultLink -Target "$target/$selected"

        $defaultBinLink = "$defaultLink/bin"
        $pathContent = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Process) -split [IO.Path]::PathSeparator
        if (!$pathContent.Contains($defaultBinLink)) {
            $check = 'export PATH="$PATH:' + $defaultBinLink + '"' 
            $candidateExistInProfile = Select-String -Path "$env:HOME/.profile" -Pattern "^$check$"
            if (!$candidateExistInProfile) {
                Add-Content -Path "$env:HOME/.profile" -Value $check
                Write-Host "Restart of session is required"
            }
        }
    }
}

[PathManager]::getInstance($candidates).setCandidate($App, $Mode, $AppVersion)

