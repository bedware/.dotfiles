<#
.SYNOPSIS
Installs this directory as IntelliJ IDEA's LivePlugin directory on Windows.

.DESCRIPTION
Creates a directory symbolic link named "live-plugins" in an IntelliJ IDEA
scratch directory. IntelliJ normally uses its versioned config directory as
the scratch directory, but -ScratchDirectory supports idea.scratch.path and
idea.config.path overrides.

With no path or version, the script uses the only detected IntelliJ config
directory. If several versions exist, it only auto-selects one that already
links to this source; otherwise it asks for an explicit choice.

The installer is idempotent and never replaces an existing file, directory,
or link. In Auto mode it falls back to a directory junction only when Windows
denies symbolic-link creation because the process lacks that privilege.

.PARAMETER Version
The IntelliJ IDEA version under the standard JetBrains config root, such as
"2026.1". Mutually exclusive with -ScratchDirectory.

.PARAMETER ScratchDirectory
The exact IntelliJ scratch directory in which "live-plugins" belongs.
Use this for custom idea.scratch.path or idea.config.path settings.

.PARAMETER LinkType
Auto, SymbolicLink, or Junction. Auto prefers a symbolic link and falls back
to a junction only for the Windows "privilege not held" error.

.EXAMPLE
.\install.ps1 -Version 2026.1

.EXAMPLE
.\install.ps1 -ScratchDirectory 'D:\JetBrains\idea-scratch'

.EXAMPLE
.\install.ps1 -Version 2026.1 -LinkType Junction
#>

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]
param(
    [Parameter()]
    [string] $Version,

    [Parameter()]
    [Alias('ConfigDirectory', 'IntelliJConfigPath')]
    [string] $ScratchDirectory,

    [Parameter()]
    [ValidateSet('Auto', 'SymbolicLink', 'Junction')]
    [string] $LinkType = 'Auto'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function ConvertTo-NormalizedPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $LiteralPath,

        [Parameter(Mandatory = $true)]
        [string] $BaseDirectory
    )

    if (-not [IO.Path]::IsPathRooted($LiteralPath)) {
        $LiteralPath = Join-Path $BaseDirectory $LiteralPath
    }

    $normalized = [IO.Path]::GetFullPath($LiteralPath)
    $root = [IO.Path]::GetPathRoot($normalized)

    if (-not [StringComparer]::OrdinalIgnoreCase.Equals($normalized, $root)) {
        $separators = [char[]] @(
            [IO.Path]::DirectorySeparatorChar,
            [IO.Path]::AltDirectorySeparatorChar
        )
        $normalized = $normalized.TrimEnd($separators)
    }

    return $normalized
}

function Get-PathEntry {
    param(
        [Parameter(Mandatory = $true)]
        [string] $LiteralPath
    )

    $parent = Split-Path -Parent $LiteralPath
    $leaf = Split-Path -Leaf $LiteralPath

    if (-not [IO.Directory]::Exists($parent)) {
        return $null
    }

    foreach ($entry in @(Get-ChildItem -LiteralPath $parent -Force)) {
        if ([StringComparer]::OrdinalIgnoreCase.Equals($entry.Name, $leaf)) {
            return $entry
        }
    }

    return $null
}

function Get-DirectoryLinkMetadata {
    param(
        [Parameter(Mandatory = $true)]
        [IO.FileSystemInfo] $Entry,

        [Parameter(Mandatory = $true)]
        [string] $LinkParent
    )

    $isReparsePoint =
        ($Entry.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0
    if (-not $isReparsePoint) {
        return $null
    }

    $linkTypeProperty = $Entry.PSObject.Properties['LinkType']
    $targetProperty = $Entry.PSObject.Properties['Target']
    if ($null -eq $linkTypeProperty -or $null -eq $targetProperty) {
        return $null
    }

    $detectedLinkType = [string] $linkTypeProperty.Value
    if ($detectedLinkType -notin @('SymbolicLink', 'Junction')) {
        return $null
    }

    $targets = @($targetProperty.Value)
    if ($targets.Count -ne 1 -or [string]::IsNullOrWhiteSpace([string] $targets[0])) {
        return $null
    }

    $storedTarget = [string] $targets[0]
    try {
        $normalizedTarget = ConvertTo-NormalizedPath `
            -LiteralPath $storedTarget `
            -BaseDirectory $LinkParent
    }
    catch {
        return $null
    }

    return [pscustomobject] @{
        LinkType         = $detectedLinkType
        StoredTarget     = $storedTarget
        NormalizedTarget = $normalizedTarget
    }
}

function Test-SymbolicLinkPrivilegeError {
    param(
        [Parameter(Mandatory = $true)]
        [Management.Automation.ErrorRecord] $ErrorRecord
    )

    if (
        $ErrorRecord.FullyQualifiedErrorId -like
            'NewItemSymbolicLinkElevationRequired,*'
    ) {
        return $true
    }

    $exception = $ErrorRecord.Exception
    while ($null -ne $exception) {
        if (
            $exception -is [ComponentModel.Win32Exception] -and
            $exception.NativeErrorCode -eq 1314
        ) {
            return $true
        }
        $exception = $exception.InnerException
    }

    return $false
}

if ($env:OS -ne 'Windows_NT') {
    throw 'This installer supports Windows only. Use install.sh on macOS.'
}

if (
    $PSBoundParameters.ContainsKey('Version') -and
    $PSBoundParameters.ContainsKey('ScratchDirectory')
) {
    throw '-Version and -ScratchDirectory are mutually exclusive.'
}

$sourceItem = Get-Item -LiteralPath $PSScriptRoot -Force
if (-not ($sourceItem -is [IO.DirectoryInfo])) {
    throw "LivePlugin source is not a directory: $PSScriptRoot"
}

$sourcePath = ConvertTo-NormalizedPath `
    -LiteralPath $sourceItem.FullName `
    -BaseDirectory $sourceItem.Parent.FullName

$jetBrainsRoot = $null

if ($PSBoundParameters.ContainsKey('ScratchDirectory')) {
    if ([string]::IsNullOrWhiteSpace($ScratchDirectory)) {
        throw '-ScratchDirectory cannot be empty.'
    }

    try {
        $scratchProviderPath =
            $ExecutionContext.SessionState.Path.
                GetUnresolvedProviderPathFromPSPath($ScratchDirectory)
        $scratchItem = Get-Item -LiteralPath $scratchProviderPath -Force
    }
    catch {
        throw "Scratch directory does not exist or is not accessible: $ScratchDirectory"
    }

    if (-not ($scratchItem -is [IO.DirectoryInfo])) {
        throw "Scratch path is not a directory: $ScratchDirectory"
    }

    $scratchPath = ConvertTo-NormalizedPath `
        -LiteralPath $scratchItem.FullName `
        -BaseDirectory (Get-Location).ProviderPath
}
elseif ($PSBoundParameters.ContainsKey('Version')) {
    $appData = [Environment]::GetFolderPath(
        [Environment+SpecialFolder]::ApplicationData
    )
    if ([string]::IsNullOrWhiteSpace($appData)) {
        throw 'Windows did not provide a roaming ApplicationData directory.'
    }
    $jetBrainsRoot = Join-Path $appData 'JetBrains'

    if (
        [string]::IsNullOrWhiteSpace($Version) -or
        $Version -notmatch '^[0-9]{4}\.[0-9]+(?:\.[0-9]+)?$'
    ) {
        throw '-Version must look like 2026.1 or 2026.1.2.'
    }

    $scratchPath = Join-Path $jetBrainsRoot "IntelliJIdea$Version"
    if (-not [IO.Directory]::Exists($scratchPath)) {
        throw "IntelliJ config directory does not exist: $scratchPath. Start that IDE version first or use -ScratchDirectory."
    }
}
else {
    $appData = [Environment]::GetFolderPath(
        [Environment+SpecialFolder]::ApplicationData
    )
    if ([string]::IsNullOrWhiteSpace($appData)) {
        throw 'Windows did not provide a roaming ApplicationData directory.'
    }
    $jetBrainsRoot = Join-Path $appData 'JetBrains'

    if (-not [IO.Directory]::Exists($jetBrainsRoot)) {
        throw "JetBrains config root does not exist: $jetBrainsRoot. Start IntelliJ IDEA first or use -ScratchDirectory."
    }

    $candidates = @(
        Get-ChildItem -LiteralPath $jetBrainsRoot -Directory -Force |
            Where-Object {
                $_.Name -match
                    '^(?:IntelliJIdea|IdeaIC)[0-9]{4}\.[0-9]+(?:\.[0-9]+)?$'
            } |
            Sort-Object Name
    )

    if ($candidates.Count -eq 1) {
        $scratchPath = $candidates[0].FullName
    }
    elseif ($candidates.Count -gt 1) {
        $matchingCandidates = @(
            foreach ($candidate in $candidates) {
                $candidateDestination =
                    Join-Path $candidate.FullName 'live-plugins'
                $candidateEntry =
                    Get-PathEntry -LiteralPath $candidateDestination

                if ($null -eq $candidateEntry) {
                    continue
                }

                $candidateLink = Get-DirectoryLinkMetadata `
                    -Entry $candidateEntry `
                    -LinkParent $candidate.FullName

                if (
                    $null -ne $candidateLink -and
                    [StringComparer]::OrdinalIgnoreCase.Equals(
                        $candidateLink.NormalizedTarget,
                        $sourcePath
                    )
                ) {
                    $candidate
                }
            }
        )

        if ($matchingCandidates.Count -eq 1) {
            $scratchPath = $matchingCandidates[0].FullName
        }
        else {
            $choices = (
                $candidates |
                    ForEach-Object { "  - $($_.Name)" }
            ) -join [Environment]::NewLine

            throw "Multiple IntelliJ config directories were found and no unique existing installation identifies one:`n$choices`nRun again with -Version or -ScratchDirectory."
        }
    }
    else {
        throw "No IntelliJ config directories were found under $jetBrainsRoot. Start IntelliJ IDEA first or use -ScratchDirectory."
    }
}

$scratchPath = ConvertTo-NormalizedPath `
    -LiteralPath $scratchPath `
    -BaseDirectory (Get-Location).ProviderPath

$scratchRoot = [IO.Path]::GetPathRoot($scratchPath)
if ([StringComparer]::OrdinalIgnoreCase.Equals($scratchPath, $scratchRoot)) {
    throw "Refusing to use a filesystem root as the scratch directory: $scratchPath"
}

$sourcePrefix = $sourcePath + [IO.Path]::DirectorySeparatorChar
if (
    [StringComparer]::OrdinalIgnoreCase.Equals($scratchPath, $sourcePath) -or
    $scratchPath.StartsWith($sourcePrefix, [StringComparison]::OrdinalIgnoreCase)
) {
    throw "Refusing to create a recursive link inside the source directory: $scratchPath"
}

$destination = Join-Path $scratchPath 'live-plugins'
$existingEntry = Get-PathEntry -LiteralPath $destination

if ($null -ne $existingEntry) {
    $existingLink = Get-DirectoryLinkMetadata `
        -Entry $existingEntry `
        -LinkParent $scratchPath

    if ($null -eq $existingLink) {
        throw "Refusing to replace an existing file, directory, or unsupported reparse point: $destination"
    }

    if (
        [StringComparer]::OrdinalIgnoreCase.Equals(
            $existingLink.NormalizedTarget,
            $sourcePath
        )
    ) {
        [pscustomobject] @{
            Status      = 'AlreadyInstalled'
            Source      = $sourcePath
            Destination = $destination
            LinkType    = $existingLink.LinkType
        }
        return
    }

    throw "Refusing to replace link '$destination', which points to '$($existingLink.StoredTarget)'."
}

$requestedAction = "Create a $LinkType directory link to '$sourcePath'"
if (-not $PSCmdlet.ShouldProcess($destination, $requestedAction)) {
    return
}

$createdLinkType = $LinkType
if ($LinkType -eq 'Auto') {
    try {
        New-Item `
            -ItemType SymbolicLink `
            -Path $destination `
            -Target $sourcePath | Out-Null
        $createdLinkType = 'SymbolicLink'
    }
    catch {
        if (-not (Test-SymbolicLinkPrivilegeError -ErrorRecord $_)) {
            throw
        }

        if ($sourcePath.StartsWith('\\', [StringComparison]::Ordinal)) {
            throw "Windows denied symbolic-link creation, and a junction cannot target a network path. Enable Windows Developer Mode or run elevated. Source: $sourcePath"
        }

        Write-Warning (
            'Windows denied symbolic-link creation. ' +
            'Falling back to a directory junction.'
        )
        New-Item `
            -ItemType Junction `
            -Path $destination `
            -Target $sourcePath | Out-Null
        $createdLinkType = 'Junction'
    }
}
else {
    try {
        New-Item `
            -ItemType $LinkType `
            -Path $destination `
            -Target $sourcePath | Out-Null
    }
    catch {
        if (
            $LinkType -eq 'SymbolicLink' -and
            (Test-SymbolicLinkPrivilegeError -ErrorRecord $_)
        ) {
            throw 'Windows denied symbolic-link creation. Enable Windows Developer Mode, run elevated, or use -LinkType Junction.'
        }
        throw
    }
}

$verifiedEntry = Get-PathEntry -LiteralPath $destination
if ($null -eq $verifiedEntry) {
    throw "Link creation reported success, but the destination is missing: $destination"
}

$verifiedLink = Get-DirectoryLinkMetadata `
    -Entry $verifiedEntry `
    -LinkParent $scratchPath
if (
    $null -eq $verifiedLink -or
    -not [StringComparer]::OrdinalIgnoreCase.Equals(
        $verifiedLink.NormalizedTarget,
        $sourcePath
    )
) {
    throw "Link creation could not be verified safely: $destination"
}

[pscustomobject] @{
    Status      = 'Installed'
    Source      = $sourcePath
    Destination = $destination
    LinkType    = $createdLinkType
}
