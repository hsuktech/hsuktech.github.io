iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1)

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

$scriptName = Read-Host "Script"
CodeFetch -scriptName $scriptName -sharedSecret $sharedSecret -codeFetchUri $codeFetchUri
