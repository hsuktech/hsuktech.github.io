if(Test-Path variable:global:webhookUri){
    # Do nothing
} else { 
    $codeFetchUri = Read-Host "Code Fetch Uri"
}

if(Test-Path variable:global:sharedSecret){
    # Do nothing
} else { 
    $sharedSecret = Read-Host "Shared Secret"
}
