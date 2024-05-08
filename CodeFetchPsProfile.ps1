cls

# Load the Code Fetch function
iex (irm https://raw.githubusercontent.com/hsuktech/hsuktech.github.io/main/CodeFetch.ps1)

# Set the variables
$codeFetchUri = Read-Host "Code Fetch Uri"
$sharedSecret = Read-Host "Shared Secret"

# Fetch the code

# Create standard PowerShell profile for the current user 
CodeFetch -scriptName ReACKs-CodeFetchPsProfile.ps1 -sharedSecret $sharedSecret -webhookUri $codeFetchUri
