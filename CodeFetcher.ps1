iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1)

if(Test-Path variable:global:webhookUri){
    # Do nothing
} else { 
    $webhookUri = Read-Host "Webhook Uri"
}

if(Test-Path variable:global:sharedSecret){
    # Do nothing
} else { 
    $sharedSecret = Read-Host "Shared Secret"
}

$scriptName = Read-Host "Script"
CodeFetch -scriptName $scriptName -sharedSecret $sharedSecret -webhookUri $webhookUri