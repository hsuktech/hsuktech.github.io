iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/LocalCode.ps1)

if($webhookUri -eq ""){
  $webhookUri = Read-Host "Webhook Uri"
}

if($sharedSecret -eq ""){
  $sharedSecret = Read-Host "Shared Secret"
}

$scriptName = Read-Host "Script"
RunLocalCode -scriptName $scriptName -sharedSecret $sharedSecret -webhookUri $webhookUri
