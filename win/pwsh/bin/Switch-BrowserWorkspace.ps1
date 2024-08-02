$jsonFilePath = "C:\Users\dmitr\AppData\Local\Microsoft\Edge\User Data\Default\Workspaces\WorkspacesCache"

$jsonContent = Get-Content -Path $jsonFilePath -Raw | ConvertFrom-Json

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
    }
}

