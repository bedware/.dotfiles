$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"

$headers.Add("Content-Type", "application/json")

$headers.Add("Authorization", "Bearer $env:DC_API_TOKEN")

$response = Invoke-RestMethod 'https://daycaptain.com/2024-04-21/tasks' -Method 'GET' -Headers $headers

# $response | ConvertTo-Json
# $response | ConvertTo-Json | jq .[].string
# "Visit a vet clinic"
# "Plan the day"
# "Составить календарь приездов"
# "Move snippets from GH to AHK (or maybe NVIM)"
# "Досмотреть DP курс"
#
# $response | ConvertTo-Json | jq -r .[].string
# Visit a vet clinic
# Plan the day
# Составить календарь приездов
# Move snippets from GH to AHK (or maybe NVIM)
# Досмотреть DP курс
