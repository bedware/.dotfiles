function Add-ScriptsFromDir($currentDir) {
    Get-ChildItem $currentDir | ForEach-Object {
        $fileName = $_.BaseName
        $titleCaseFileName = (Get-Culture).TextInfo.ToTitleCase($fileName.ToLower())
        if ($titleCaseFileName.IndexOf('-') -ne -1) {
            $parts = $titleCaseFileName.Split('-')
            $titleCaseFileName = $parts[0] + '-' + ($parts[1..($parts.Length - 1)] -join '')
        }
        New-IgnoredAlias -Name $titleCaseFileName -Value $_.FullName
    }
}

