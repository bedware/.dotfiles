using namespace System.Management.Automation

$_argc_completer = {
    param($wordToComplete, $commandAst, $cursorPosition)
    $words = @($commandAst.CommandElements | Where-Object { $_.Extent.StartOffset -lt $cursorPosition } | ForEach-Object {
        $word =  $_.ToString()
        if ($word.Length -gt 2) {
            if (($word.StartsWith('"') -and $word.EndsWith('"')) -or ($word.StartsWith("'") -and $word.EndsWith("'"))) {
                $word = $word.Substring(1, $word.Length - 2)
            }
        }
        return $word
    })
    $emptyS = ''
    if ($PSVersionTable.PSVersion.Major -eq 5) {
        $emptyS = '""'
    }
    $lastElemIndex = -1
    if ($words.Count -lt $commandAst.CommandElements.Count) {
        $lastElemIndex = $words.Count - 1
    }
    if ($commandAst.CommandElements[$lastElemIndex].Extent.EndOffset -lt $cursorPosition) {
        $words += $emptyS
    }
    @((argc --argc-compgen powershell $emptyS $words) -split "`n") | ForEach-Object {
        $parts = ($_ -split "`t")
        if ($parts[1] -eq "1") {
            $value = $parts[0] + " "
        } else {
            $value = $parts[0]
        }
        if ($parts[3] -eq "") {
            $description = "$([char]0x1b)[" + $parts[4] + "m" + $parts[2] + "$([char]0x1b)[0m"
        } else {
            $description = "$([char]0x1b)[" + $parts[4] + "m" + $parts[2] + "$([char]0x1b)[33m (" + $parts[3] + ")$([char]0x1b)[0m"
        }
        [CompletionResult]::new($value, $description, [CompletionResultType]::ParameterValue, " ")
    }
}

$env:ARGC_COMPLETIONS_ROOT = "$env:HOME/.local/argc-completions"
Add-ToPathSafely($env:ARGC_COMPLETIONS_ROOT + '/bin')
if ($IsLinux) {
    $env:ARGC_COMPLETIONS_PATH = "$env:ARGC_COMPLETIONS_ROOT/completions/linux"
} 
elseif ($IsWindows) {
    $env:ARGC_COMPLETIONS_PATH = "$env:ARGC_COMPLETIONS_ROOT/completions/windows"
}
$env:ARGC_COMPLETIONS_PATH += [IO.Path]::PathSeparator + "$env:ARGC_COMPLETIONS_ROOT/completions"

# To add completions for only the specified command, modify next line e.g. $argc_scripts = @("cargo", "git")
$argc_scripts = Get-ChildItem -File -Path ($env:ARGC_COMPLETIONS_PATH).Split([IO.Path]::PathSeparator) | ForEach-Object { $_.Name -replace '\.sh$' }
$argc_scripts += "argc"

$argc_scripts | ForEach-Object {
    Register-ArgumentCompleter -Native -ScriptBlock $_argc_completer -CommandName $_
}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression

# Others
if (Test-Path "$env:HOME/.local/.iximiuz/labctl/autocompletion.ps1") {
    . "$env:HOME/.local/.iximiuz/labctl/autocompletion.ps1"
}

