. "C:/Users/dmitr/.dotfiles/win/pwsh/bin/Run-AHK.ps1"


$jsonFilePathPersonal = "C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Default\Workspaces\WorkspacesCache"
$jsonFilePathJob = "C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Profile 2\Workspaces\WorkspacesCache"
while ($true) {

ahk @"
WinGet, hwnd, ID, ahk_exe msedge.exe
FileDelete, C:/temp.file
WinGetTitle, windowTitle, ahk_id %hwnd%
FileAppend, %windowTitle%, C:/temp.file, UTF-8
"@
    $title = Get-Content C:/temp.file
    Write-Host $title
    if ($title -match "- Alfa -") {
        $jsonContent = Get-Content -Path $jsonFilePathJob -Raw | ConvertFrom-Json
    } elseif ($title -match "- Personal -") {
        $jsonContent = Get-Content -Path $jsonFilePathPersonal -Raw | ConvertFrom-Json
    } else {
        "Wrong profile!"
    }
    exit;

#     $jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

    $selectedWorkspaceName = ($jsonContent.workspaces | ForEach-Object {
            if ($_.active -eq "true") {
                "> " + $_.name
            } elseif ($_.accent -eq "true") {
                "+ " + $_.name
            } else {
                "- " + $_.name
            }
        } | Sort-Object -Descending | fzf `
        --color=16 --layout=reverse --border=rounded --border-label="Select Workspace" --margin="1,1,0,1" --info=hidden)

    if ($selectedWorkspaceName) {
        $selectedWorkspaceName = $selectedWorkspaceName.Substring(2)
    }

    foreach ($workspace in $jsonContent.workspaces) {
        if ($workspace.name -eq $selectedWorkspaceName){
            $workspaceID = $workspace.id
            # Write-Host "Launching Microsoft Edge for workspace ID: $workspaceID"
            Start-Process -FilePath "msedge.exe" -ArgumentList "--launch-workspace=$workspaceID"

            ahk @"
WinWait, $selectedWorkspaceName ahk_exe msedge.exe,, 5
;MsgBox % "$selectedWorkspaceName ahk_exe msedge.exe"
if (WinExist("$selectedWorkspaceName ahk_exe msedge.exe")) {
    WinActivate
    ;MsgBox % "Activated: $selectedWorkspaceName"
}
"@
            break;
        }
    }
}
