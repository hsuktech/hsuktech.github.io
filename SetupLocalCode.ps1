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
