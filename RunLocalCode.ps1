iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/LocalCode.ps1)

if($webhookUri -eq $null){
  $webhookUri = Read-Host "Webhook Uri"
}

if($sharedSecret -eq $null){
  $sharedSecret = Read-Host "Shared Secret"
}

$scriptName = Read-Host "Script"
RunLocalCode -scriptName $scriptName -sharedSecret $sharedSecret -webhookUri $webhookUri
