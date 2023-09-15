$payload = [System.Text.Encoding]::UTF8.GetBytes((@{ string = $args -join ' '} | ConvertTo-Json))

$url = "https://daycaptain.com/backlog-items"
$headers = @{
	'Content-Type'='application/json'
	'Authorization'='Bearer xxxxx'
	}
Invoke-RestMethod -Method Post -Uri $url -Body $payload -Headers $headers
