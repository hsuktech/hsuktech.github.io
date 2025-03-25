# Load CodeFetch
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1)

# Test for CodeFetch variables
if(Test-Path variable:global:codeFetchUri){
    # Do nothing
} else { 
    $codeFetchUri = Read-Host "Code Fetch Uri"
}

if(Test-Path variable:global:sharedSecret){
    # Do nothing
} else { 
    $sharedSecret = Read-Host "Shared Secret"
}