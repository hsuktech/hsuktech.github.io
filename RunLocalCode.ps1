iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/LocalCode.ps1)

$webhookUri = Read-Host "Webhook Uri"
$sharedSecret = Read-Host "Shared Secret"
$scriptName = Read-Host "Script"
RunLocalCode -scriptName $scriptName -sharedSecret $sharedSecret -webhookUri $webhookUri
